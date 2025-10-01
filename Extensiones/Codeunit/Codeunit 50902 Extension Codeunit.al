

/// <summary>
/// Codeunit GMAExtention Codeunit (ID 34006463).
/// </summary>
codeunit 34006902 "PERExtention Codeunit"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    //DDS13072023 ajuste de modificacion de impuestos
    //DDS160424 se agrego en contabilidad el campo provincia para calculo de impuesto de solo esa provincia

    Permissions =
    tabledata "GMAPosted Change Type Adjust" = rimd,
    tabledata "GMAValues Entry" = rimd,
    tabledata 319 = rimd,
    tabledata 18 = rimd,
    tabledata 318 = rimd,
    tabledata "GMAPadron CABA" = rimd,
    tabledata "GMAPadron ARBA" = rimd;


    [EventSubscriber(ObjectType::codeunit, 12, 'OnBeforeInsertGlEntry', '', false, false)]
    local procedure OnBeforeInsertGlEntry(var GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean);
    begin
        GLEntry."Additional-currency Adjusted" := GenJnlLine."Additional-currency Adjusted";
        IsHandled := false;
    end;

    //DDS19062025 Nestor pedio la validacion del campo Posting No. en ventas para que completen el numero para comprobante que no es electronico
    [EventSubscriber(ObjectType::Table, 36, 'OnAfterValidateEvent', 'Posting No.', false, false)]
    local procedure OnAfterValidateEventPostingNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header");
    var
        recCompanyInformation: Record "Company Information";
        posicionguion: Integer;
        pos: text;
        documentno: Text;
        numfactura: Text;
        "Company Information": Record "Company Information";
        letter: Text;
        cduEsLetra: Codeunit GMAstringFunctions;
        recVendor: Record Customer;
        recTaxArea: Record "Tax Area";
        recPPS: Record "Purchases & Payables Setup";
        GMAAFIPVoucherType: Record "GMAAFIP - Voucher Type";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF ("Company Information".GET) AND ("Company Information".GMACompany = "Company Information".GMACompany::Argentina) AND (rec."GMAElectronic Invoicing" = rec."GMAElectronic Invoicing"::No) THEN BEGIN
                begin
                    posicionguion := StrPos(rec."Posting No.", '-');
                    if posicionguion <> 0 then begin

                        if cduEsLetra.isaLetter(copystr(rec."Posting No.", 1, 1)) then begin
                            pos := CopyStr(rec."Posting No.", 2, posicionguion - 2);
                            letter := copystr(rec."Posting No.", 1, 1);
                            rec.TestField("GMAAFIP Invoice Voucher Type");
                            GMAAFIPVoucherType.Reset();
                            GMAAFIPVoucherType.SetRange(GMAAFIPVoucherType.GMAID, rec."GMAAFIP Invoice Voucher Type");
                            if GMAAFIPVoucherType.FindFirst() then begin
                                GMAAFIPVoucherType.TestField(GMALetter);
                                IF (letter <> GMAAFIPVoucherType.GMALetter) then
                                    Error('Letra ingresada %1 no corresponde con la letra en tipo de documento %2', letter, GMAAFIPVoucherType.GMALetter);
                            end;

                        end
                        else begin
                            rec.TestField("GMAAFIP Invoice Voucher Type");

                            GMAAFIPVoucherType.Reset();
                            GMAAFIPVoucherType.SetRange(GMAAFIPVoucherType.GMAID, rec."GMAAFIP Invoice Voucher Type");
                            GMAAFIPVoucherType.FindFirst();

                            GMAAFIPVoucherType.TestField(GMALetter);
                            letter := GMAAFIPVoucherType.GMALetter;
                            pos := CopyStr(rec."Posting No.", 1, posicionguion - 1);
                        end;
                        documentno := CopyStr(Rec."Posting No.", posicionguion + 1, StrLen(rec."Posting No."));

                        //el largo del punto de venta lo va a buscar a la configuración de compras y pagos.
                        recPPS.Reset();
                        recPPS.FindFirst();
                        if recPPS.GMAPointofSalesWidth = 0 then begin
                            CASE STRLEN(pos) OF
                                1:
                                    pos := '000' + pos;
                                2:
                                    pos := '00' + pos;
                                3:
                                    pos := '0' + pos;
                            END;
                        end
                        else begin
                            pos := CompletarCerosAIzquierda(pos, recPPS.GMAPointofSalesWidth);
                        end;


                        CASE STRLEN(documentno) OF
                            1:
                                numfactura := '0000000' + documentno;
                            2:
                                numfactura := '000000' + documentno;
                            3:
                                numfactura := '00000' + documentno;
                            4:
                                numfactura := '0000' + documentno;
                            5:
                                numfactura := '000' + documentno;
                            6:
                                numfactura := '00' + documentno;
                            7:
                                numfactura := '0' + documentno;
                            else
                                numfactura := documentno;
                        END;
                    end;
                end;
                rec."Posting No." := letter + pos + '-' + numfactura;

            end;
        end;

    end;



    local procedure CompletarCerosAIzquierda(texto: Text; Length: Integer) retorno: Text;
    var
        recCompanyInformation: Record "Company Information";
        aux: Integer;
        parteEntera: Integer;
        parteDecimal: Integer;
        cantDecimales: Integer;
        numeroOriginal: Decimal;
        strParteDecimal: Text;
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin

            aux := StrLen(copystr(texto, 1, StrLen(texto)));
            retorno := texto;
            while aux < Length do begin
                retorno := '0' + retorno;
                aux += 1;
            end;
        end;
    end;
    //DDS19062025 Nestor pedio la validacion del campo Posting No. en ventas para que completen el numero para comprobante que no es electronico


    //actualizacion de entidad en tax area--
    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateEventSelltoCustomerNo(var Rec: Record "Sales Header");
    var
        TaxArea: Record "Tax Area";
        recCompanyInformation: Record "Company Information";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin
                IF (rec."Sell-to Customer No." <> '') and (rec."Shortcut Dimension 1 Code" <> '') THEN begin
                    TaxArea.Reset();
                    TaxArea.SetRange(PERCustomerNo, rec."Sell-to Customer No.");
                    TaxArea.SetRange(EntityID, rec."Shortcut Dimension 1 Code");
                    IF (TaxArea.FindFirst()) THEN begin
                        rec."Tax Area Code" := TaxArea.Code;
                    end;
                end;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, 36, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvent(var Rec: Record "Sales Header");
    var
        TaxArea: Record "Tax Area";
        recCompanyInformation: Record "Company Information";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin
                IF (rec."Sell-to Customer No." <> '') and (rec."Shortcut Dimension 1 Code" <> '') THEN begin
                    TaxArea.Reset();
                    TaxArea.SetRange(PERCustomerNo, rec."Sell-to Customer No.");
                    TaxArea.SetRange(EntityID, rec."Shortcut Dimension 1 Code");
                    IF (TaxArea.FindFirst()) THEN begin
                        rec."Tax Area Code" := TaxArea.Code;
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'GMAFiscal Type', false, false)]
    local procedure OnAfterValidatePERCustomerFiscalType(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer);
    var

        Text34003106: Label 'Complete primero el campo Código de área fiscal';
        Text34003104: Label 'No está configurado el tipo fiscal en la zona fiscal %1';
        Text34003105: Label 'El tipo fiscal debe ser %1';
        TaxArea: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        fiscaltype: Record "GMAFiscal Type";
        jurisdicciongeneric: Record "Tax Jurisdiction";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
        recCompanyInformation: Record "Company Information";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin
                TaxArea.Reset();
                TaxArea.SetRange(PERCustomerNo, rec."No.");
                IF (TaxArea.FindFirst()) THEN
                    repeat
                        IF (rec."GMAFiscal Type" <> '') THEN
                            TaxArea."GMAFiscal Type" := Rec."GMAFiscal Type";
                        fiscaltype.get(rec."GMAFiscal Type");
                        IF (fiscaltype."GMAInvoice Letter" <> '') THEN
                            TaxArea."GMAInvoice Letter" := fiscaltype."GMAInvoice Letter";

                        IF (TaxArea.Modify()) THEN;
                    until TaxArea.Next() = 0;
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 319, 'OnAfterValidateEvent', 'EntityID', false, false)]
    local procedure OnAfterValidateEvent319(var Rec: Record "Tax Area Line");
    var
        TaxArea: Record "Tax Area";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
        recCompanyInformation: Record "Company Information";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin

                TaxArea.Reset();
                TaxArea.SetRange(Code, rec."Tax Area");
                IF (TaxArea.FindFirst()) THEN begin
                    rec.TestField(EntityID, TaxArea.EntityID);
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 319, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent319(var Rec: Record "Tax Area Line");
    var
        TaxArea: Record "Tax Area";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
        recCompanyInformation: Record "Company Information";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin

                TaxArea.Reset();
                TaxArea.SetRange(Code, rec."Tax Area");
                IF (TaxArea.FindFirst()) THEN begin
                    rec.EntityID := TaxArea.EntityID;
                end;
            end;
        end;
    end;
    //actualizacion de entidad en tax area--
    //Actualizacion de padron arba y caba++
    [EventSubscriber(ObjectType::Table, 18, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustomerPER(var Rec: Record Customer; RunTrigger: Boolean);
    var
        recCompanyInformation: Record "Company Information";
        TaxArea: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        fiscaltype: Record "GMAFiscal Type";
        jurisdicciongeneric: Record "Tax Jurisdiction";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
        BssiDimenstionValue: Record "Dimension Value";
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        GestNoSerie: Codeunit "No. Series";
        NewNoSeriesCode: code[20];

    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (Rec."No." <> '') and (RunTrigger = true) THEN begin
                IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin

                    //  CLEAR(NewNoSeriesCode);
                    //  GMASalesReceivableSetup.TestField("GMATemp Tax Area Code");
                    // IF GestNoSerie.AreRelated(GMASalesReceivableSetup."GMATemp Tax Area Code", NewNoSeriesCode) then
                    //     GMASalesReceivableSetup."GMATemp Tax Area Code" := GMASalesReceivableSetup."GMATemp Tax Area Code";
                    //NewNoSeriesCode := GestNoSerie.GetNextNo(GMASalesReceivableSetup."GMATemp Tax Area Code");

                    BssiMEMSystemSetup.Get();
                    BssiDimenstionValue.Reset();
                    BssiDimenstionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    IF (BssiDimenstionValue.FindFirst()) THEN
                        repeat
                            TaxArea.INIT;
                            TaxArea.Code := CopyStr(rec."No." + '-' + BssiDimenstionValue.Code, 1, MAXSTRLEN(rec."No."));
                            TaxArea.Description := rec.Name;
                            TaxArea."GMAFiscal Type" := rec."GMAFiscal Type";
                            TaxArea.EntityID := BssiDimenstionValue.Code;
                            TaxArea.PERCustomerNo := Rec."No.";
                            IF (rec."GMAFiscal Type" <> '') THEN
                                fiscaltype.get(rec."GMAFiscal Type");
                            IF (fiscaltype."GMAInvoice Letter" <> '') THEN
                                TaxArea."GMAInvoice Letter" := fiscaltype."GMAInvoice Letter";
                            IF (TaxArea.Insert()) THEN begin
                                rec."Tax Area Code" := TaxArea.Code;
                                rec.Modify();
                                jurisdicciongeneric.RESET;
                                jurisdicciongeneric.setrange(jurisdicciongeneric."GMAGeneric Tax", true);
                                IF (jurisdicciongeneric.FindFirst()) THEN
                                    repeat
                                        TaxAreaLine.INIT;
                                        TaxAreaLine."Tax Area" := TaxArea.Code;
                                        TaxAreaLine.EntityID := BssiDimenstionValue.Code;
                                        TaxAreaLine."Tax Jurisdiction Code" := jurisdicciongeneric.Code;
                                        TaxAreaLine."Jurisdiction Description" := jurisdicciongeneric.Description;
                                        IF (TaxAreaLine.Insert()) THEN;
                                    UNTIL jurisdicciongeneric.Next = 0;
                            END;
                        until BssiDimenstionValue.Next() = 0;
                END;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'VAT Registration No.', false, false)]
    local procedure OnAfterValidateCustomerTableVATRegistrationNoPER(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer);
    var
        recCompanyInformation: Record "Company Information";
        //recCustomer: Record Customer;
        "GMATreasury Setup": Record "GMATreasury Setup";
        recPadronARBA: Record "GMAPadron ARBA";
        recTaxAreaLine: Record "Tax Area Line";
        recAuxJurisdicciones: Record "Tax Jurisdiction";
        recJurisdiccionActual: Record "Tax Jurisdiction";
        linareaimpuestoaux: Record "Tax Area Line";
        linareaimpuestoClienteDelete: Record "Tax Area Line";
        recPadronCABA: Record "GMAPadron CABA";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
        PerceptionabyEntity: Record PerceptionabyEntity;
        TaxArea: Record "Tax Area";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin

            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin

                "GMATreasury Setup".get;
                "GMATreasury Setup".TestField("GMAProvince Code ARBA");
                IF ("GMATreasury Setup"."GMATax Historic Activation") then begin
                    //mantiene 2 meses del padron

                    //creo la nueva tax area line con el grupo que corresponda
                    recPadronARBA.Reset();
                    recPadronARBA.SetCurrentKey(GMARegimen, "GMAFecha_Pub", GMAN_CUIT);
                    recPadronARBA.SetFilter(GMAN_CUIT, '=%1', DelChr(rec."VAT Registration No.", '=', '_-. '));
                    recPadronARBA.SetFilter(GMARegimen, '=%1', 'P');
                    if recPadronARBA.FindFirst() then begin
                        recJurisdiccionActual.Reset();
                        recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code ARBA");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual.GMAARBA, true);
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", recPadronARBA.GMAG_P_R);
                        if recJurisdiccionActual.FindFirst() then begin
                            PerceptionabyEntity.Reset();
                            PerceptionabyEntity.SetRange(ProvinceCode, "GMATreasury Setup"."GMAProvince Code ARBA");
                            PerceptionabyEntity.Setfilter(EntityID, '<>%1', '');
                            if PerceptionabyEntity.FindFirst() then
                                repeat
                                    TaxArea.Reset();
                                    TaxArea.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                    TaxArea.SetRange(PERCustomerNo, rec."No.");
                                    IF (TaxArea.FindFirst()) THEN
                                        repeat
                                            recTaxAreaLine.Reset();
                                            recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                            recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                            recTaxAreaLine.SetRange(GMAARBA, true);
                                            recTaxAreaLine.SetFilter("GMATo Date", '=%1', recPadronARBA.GMAFecha_Hasta);
                                            recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            if not (recTaxAreaLine.FindFirst()) then begin
                                                recTaxAreaLine.Reset();
                                                recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                                recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                                recTaxAreaLine.SetRange(GMAARBA, true);
                                                if (recTaxAreaLine.FindFirst()) then begin
                                                    linareaimpuestoClienteDelete.Reset();
                                                    linareaimpuestoClienteDelete.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                    linareaimpuestoClienteDelete.SetRange(linareaimpuestoClienteDelete."Tax Area", TaxArea.Code);
                                                    linareaimpuestoClienteDelete.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                                    linareaimpuestoClienteDelete.SetRange(GMAARBA, true);
                                                    if (linareaimpuestoClienteDelete.FindFirst()) then begin
                                                        IF (linareaimpuestoClienteDelete.COUNT) >= 2 THEN
                                                            linareaimpuestoClienteDelete.DELETE;
                                                    end;
                                                end;
                                            end;
                                            recTaxAreaLine.RESET;
                                            recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                            recTaxAreaLine.SETRANGE(recTaxAreaLine."Tax Area", TaxArea.Code);
                                            recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            recTaxAreaLine.SETRANGE(GMAARBA, TRUE);
                                            IF (recTaxAreaLine.FINDFIRST) THEN;
                                            IF (recTaxAreaLine."Tax Jurisdiction Code" = recJurisdiccionActual.Code) THEN BEGIN
                                                IF (recTaxAreaLine."GMAFrom Date" = 0D) OR (recTaxAreaLine."GMAFrom Date" > recPadronARBA.GMAFecha_Hasta) THEN
                                                    recTaxAreaLine."GMAFrom Date" := recPadronARBA.GMAFecha_Desde;
                                                recTaxAreaLine."GMATo Date" := recPadronARBA.GMAFecha_Hasta;
                                                IF (recTaxAreaLine.MODIFY) THEN;
                                            END
                                            ELSE BEGIN
                                                linareaimpuestoaux.Reset();
                                                linareaimpuestoaux.init;
                                                linareaimpuestoaux.validate("Tax Area", TaxArea.Code);
                                                linareaimpuestoaux.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                                linareaimpuestoaux.Validate("GMAFrom Date", recPadronARBA.GMAFecha_Desde);
                                                linareaimpuestoaux.Validate("GMATo Date", recPadronARBA.GMAFecha_Hasta);
                                                linareaimpuestoaux.EntityID := PerceptionabyEntity.EntityID;
                                                linareaimpuestoaux.GMAARBA := true;
                                                IF (linareaimpuestoaux.Insert()) then begin
                                                    recPadronARBA.GMACliente := rec."No.";
                                                    recPadronARBA.GMAActualizado := true;
                                                    recPadronARBA.Modify();
                                                end;
                                            end;
                                        until TaxArea.Next() = 0;
                                until PerceptionabyEntity.Next() = 0;
                        end
                        else
                            Error('No existe combinacion de Codigo provincia %1 , Codigo Padron %2  y es ARBA en SI en la tabla jurisdiccion', "GMATreasury Setup"."GMAProvince Code ARBA", recPadronARBA.GMAG_P_R);

                    end;


                end
                else begin
                    //solo 1 mantiene el mes actual del padron
                    //creo la nueva tax area line con el grupo que corresponda

                    recPadronARBA.Reset();
                    recPadronARBA.SetCurrentKey(GMARegimen, "GMAFecha_Pub", GMAN_CUIT);
                    recPadronARBA.SetFilter(GMAN_CUIT, '=%1', DelChr(rec."VAT Registration No.", '=', '_-. '));
                    recPadronARBA.SetFilter(GMARegimen, '=%1', 'P');
                    if recPadronARBA.FindFirst() then begin

                        recJurisdiccionActual.Reset();
                        recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code ARBA");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual.GMAARBA, true);
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", recPadronARBA.GMAG_P_R);
                        if recJurisdiccionActual.FindFirst() then begin
                            PerceptionabyEntity.Reset();
                            PerceptionabyEntity.SetRange(ProvinceCode, "GMATreasury Setup"."GMAProvince Code ARBA");
                            PerceptionabyEntity.Setfilter(EntityID, '<>%1', '');
                            if PerceptionabyEntity.FindFirst() then
                                repeat
                                    TaxArea.Reset();
                                    TaxArea.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                    TaxArea.SetRange(PERCustomerNo, rec."No.");
                                    IF (TaxArea.FindFirst()) THEN
                                        repeat
                                            recTaxAreaLine.Reset();
                                            recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                            recTaxAreaLine.SetRange(GMAARBA, true);
                                            recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            if recTaxAreaLine.FindFirst() then
                                                recTaxAreaLine.DeleteAll;


                                            recTaxAreaLine.Init();
                                            recTaxAreaLine.validate("Tax Area", TaxArea.Code);
                                            recTaxAreaLine.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                            recTaxAreaLine.Validate("GMAFrom Date", recPadronARBA.GMAFecha_Desde);
                                            recTaxAreaLine.Validate("GMATo Date", recPadronARBA.GMAFecha_Hasta);
                                            recTaxAreaLine.EntityID := PerceptionabyEntity.EntityID;
                                            recTaxAreaLine.GMAARBA := true;
                                            IF (recTaxAreaLine.Insert()) then begin
                                                recPadronARBA.GMACliente := rec."No.";
                                                recPadronARBA.GMAActualizado := true;
                                                recPadronARBA.Modify();
                                            end;
                                        until TaxArea.Next() = 0;
                                until PerceptionabyEntity.Next() = 0;

                        end
                        else
                            Error('No existe combinacion de Codigo provincia %1 , Codigo Padron %2  y es ARBA en SI en la tabla jurisdiccion', "GMATreasury Setup"."GMAProvince Code ARBA", recPadronARBA.GMAG_P_R);

                    end;

                end;


                //Validacion de CABA
                "GMATreasury Setup".get;
                "GMATreasury Setup".TestField("GMAProvince Code CABA");
                IF ("GMATreasury Setup"."GMATax Historic Activation") then begin
                    //mantiene 2 meses del padron

                    //creo la nueva tax area line con el grupo que corresponda


                    recPadronCABA.Reset();
                    recPadronCABA.SetCurrentKey("GMAFecha_Pub", GMAN_CUIT);
                    recPadronCABA.SetFilter(GMAN_CUIT, '=%1', DelChr(rec."VAT Registration No.", '=', '_-. '));
                    if recPadronCABA.FindFirst() then begin
                        recJurisdiccionActual.Reset();
                        recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code CABA");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual.GMACABA, true);
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", FORMAT(recPadronCABA.GMAPercepcion));
                        if recJurisdiccionActual.FindFirst() then begin
                            PerceptionabyEntity.Reset();
                            PerceptionabyEntity.SetRange(ProvinceCode, "GMATreasury Setup"."GMAProvince Code CABA");
                            PerceptionabyEntity.Setfilter(EntityID, '<>%1', '');
                            if PerceptionabyEntity.FindFirst() then
                                repeat
                                    TaxArea.Reset();
                                    TaxArea.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                    TaxArea.SetRange(PERCustomerNo, rec."No.");
                                    IF (TaxArea.FindFirst()) THEN
                                        repeat
                                            recTaxAreaLine.Reset();
                                            recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                            recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                            recTaxAreaLine.SetRange(recTaxAreaLine."GMAHigh Risk CABA", true);
                                            recTaxAreaLine.SetFilter("GMATo Date", '=%1', recPadronCABA.GMAFecha_Hasta);
                                            recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            if not (recTaxAreaLine.FindFirst()) then begin
                                                recTaxAreaLine.Reset();
                                                recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                                recTaxAreaLine.SetRange(recTaxAreaLine."GMAHigh Risk CABA", true);
                                                recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                                if (recTaxAreaLine.FindFirst()) then begin
                                                    linareaimpuestoClienteDelete.Reset();
                                                    linareaimpuestoClienteDelete.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                    linareaimpuestoClienteDelete.SetRange(linareaimpuestoClienteDelete."Tax Area", TaxArea.Code);
                                                    linareaimpuestoClienteDelete.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                                    linareaimpuestoClienteDelete.SetRange(linareaimpuestoClienteDelete."GMAHigh Risk CABA", true);
                                                    if (linareaimpuestoClienteDelete.FindFirst()) then begin
                                                        IF (linareaimpuestoClienteDelete.COUNT) >= 2 THEN
                                                            linareaimpuestoClienteDelete.DELETE;
                                                    end;
                                                end;
                                            end;
                                            recTaxAreaLine.RESET;
                                            recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                            recTaxAreaLine.SETRANGE(recTaxAreaLine."Tax Area", TaxArea.Code);
                                            recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            recTaxAreaLine.SETRANGE(recTaxAreaLine."GMAHigh Risk CABA", TRUE);
                                            IF (recTaxAreaLine.FINDFIRST) THEN;
                                            IF (recTaxAreaLine."Tax Jurisdiction Code" = recJurisdiccionActual.Code) THEN BEGIN
                                                IF (recTaxAreaLine."GMAFrom Date" = 0D) OR (recTaxAreaLine."GMAFrom Date" > recPadronCABA.GMAFecha_Hasta) THEN
                                                    recTaxAreaLine."GMAFrom Date" := recPadronCABA.GMAFecha_Desde;
                                                recTaxAreaLine."GMATo Date" := recPadronCABA.GMAFecha_Hasta;
                                                IF (recTaxAreaLine.MODIFY) THEN;
                                            END
                                            ELSE BEGIN
                                                linareaimpuestoaux.Reset();
                                                linareaimpuestoaux.init;
                                                linareaimpuestoaux.validate("Tax Area", TaxArea.Code);
                                                linareaimpuestoaux.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                                linareaimpuestoaux.Validate("GMAFrom Date", recPadronCABA.GMAFecha_Desde);
                                                linareaimpuestoaux.Validate("GMATo Date", recPadronCABA.GMAFecha_Hasta);
                                                linareaimpuestoaux.EntityID := PerceptionabyEntity.EntityID;
                                                linareaimpuestoaux."GMAHigh Risk CABA" := true;
                                                IF (linareaimpuestoaux.Insert()) then begin
                                                    recPadronCABA.GMACliente := rec."No.";
                                                    recPadronCABA.GMAActualizado := true;
                                                    recPadronCABA.Modify();
                                                end;
                                            end;
                                        until TaxArea.Next() = 0;
                                until PerceptionabyEntity.Next() = 0;
                        end
                        else
                            Error('No existe combinacion de Codigo provincia %1 , Codigo CABA %2  y es CABA en SI en la tabla jurisdiccion', "GMATreasury Setup"."GMAProvince Code CABA", FORMAT(recPadronCABA.GMAPercepcion));

                    end;

                end
                else begin
                    //solo 1 mantiene el mes actual del padron
                    //creo la nueva tax area line con el grupo que corresponda

                    recPadronCABA.Reset();
                    recPadronCABA.SetCurrentKey("GMAFecha_Pub", GMAN_CUIT);
                    recPadronCABA.SetFilter(GMAN_CUIT, '=%1', DelChr(rec."VAT Registration No.", '=', '_-. '));
                    if recPadronCABA.FindFirst() then begin
                        recJurisdiccionActual.Reset();
                        recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code CABA");
                        recJurisdiccionActual.SetRange(recJurisdiccionActual.GMACABA, true);
                        recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", FORMAT(recPadronCABA.GMAPercepcion));
                        if recJurisdiccionActual.FindFirst() then begin
                            PerceptionabyEntity.Reset();
                            PerceptionabyEntity.SetRange(ProvinceCode, "GMATreasury Setup"."GMAProvince Code CABA");
                            PerceptionabyEntity.Setfilter(EntityID, '<>%1', '');
                            if PerceptionabyEntity.FindFirst() then
                                repeat
                                    TaxArea.Reset();
                                    TaxArea.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                    TaxArea.SetRange(PERCustomerNo, rec."No.");
                                    IF (TaxArea.FindFirst()) THEN
                                        repeat
                                            recTaxAreaLine.Reset();
                                            recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                            recTaxAreaLine.SetRange("GMAHigh Risk CABA", true);
                                            recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            if recTaxAreaLine.FindFirst() then
                                                recTaxAreaLine.DeleteAll;


                                            recTaxAreaLine.Init();
                                            recTaxAreaLine.validate("Tax Area", TaxArea.Code);
                                            recTaxAreaLine.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                            recTaxAreaLine.Validate("GMAFrom Date", recPadronCABA.GMAFecha_Desde);
                                            recTaxAreaLine.Validate("GMATo Date", recPadronCABA.GMAFecha_Hasta);
                                            recTaxAreaLine.EntityID := PerceptionabyEntity.EntityID;
                                            recTaxAreaLine."GMAHigh Risk CABA" := true;
                                            IF (recTaxAreaLine.Insert()) then begin
                                                recPadronCABA.GMACliente := rec."No.";
                                                recPadronCABA.GMAActualizado := true;
                                                recPadronCABA.Modify();
                                            end;
                                        until TaxArea.Next() = 0;
                                until PerceptionabyEntity.Next() = 0;

                        end
                        else
                            Error('No existe combinacion de Codigo provincia %1 , Codigo CABA %2  y es CABA en SI en la tabla jurisdiccion', "GMATreasury Setup"."GMAProvince Code CABA", FORMAT(recPadronCABA.GMAPercepcion));
                    end;

                end;
            end;
        end;
    end;

    //Actualizacion de padron arba y caba--
    //Ajuste por diferencia de cambio++
    [EventSubscriber(ObjectType::codeunit, 699, OnPostGenJnlLineOnBeforeGenJnlPostLineRun, '', false, false)]
    local procedure OnPostGenJnlLineOnBeforeGenJnlPostLineRun(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary; var GenJnlLine: Record "Gen. Journal Line")
    var
        recCompanyInformation: Record "Company Information";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") THEN begin
                GenJnlLine."Message to Recipient" := 'AjusteXDC';
            end;
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, 12, OnAfterPostBankAcc, '', false, false)]
    local procedure OnAfterPostBankAcc(var GenJnlLine: Record "Gen. Journal Line"; Balancing: Boolean; sender: Codeunit "Gen. Jnl.-Post Line"; var NextEntryNo: Integer; var NextTransactionNo: Integer; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        ValueEntry: Record "GMAValues Entry";
        ValueEntryLast: Record "GMAValues Entry";
        paymentMetodCode: Record "Payment Method";
        ProximoMovimiento: Integer;
        recCompanyInformation: Record "Company Information";
        cashbank: Record "GMACash/Bank Account";
        recPosterChangeTypeAdjust: Record "GMAPosted Change Type Adjust";
        LastMov: Integer;

    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin

            if (GenJnlLine."Message to Recipient" = 'AjusteXDC') THEN begin
                cashbank.Reset();
                cashbank.SetRange("GMANav Bank Account Number", GenJnlLine."Account No.");
                IF (cashbank.FindFirst()) THEN begin
                    IF not (ValueEntryLast.FindLast()) THEN
                        ProximoMovimiento := 1
                    else
                        ProximoMovimiento := ValueEntryLast."GMAEntry No." + 1;
                    ValueEntry.Init();
                    ValueEntry."GMAEntry No." := ProximoMovimiento;
                    ValueEntry.GMAValue := cashbank."GMAConciliation Value";
                    ValueEntry."GMACash/Bank Account" := cashbank."GMANo.";
                    ValueEntry."GMADocument Date" := GenJnlLine."Document Date";
                    ValueEntry."GMADocument Type" := ValueEntry."GMADocument Type"::Realizacion;
                    ValueEntry."GMADocument No." := GenJnlLine."Document No.";
                    ValueEntry.GMAAmount := GenJnlLine.Amount;
                    ValueEntry."GMAAmount (LCY)" := GenJnlLine."Amount (LCY)";
                    ValueEntry.GMADescription := COPYSTR(GenJnlLine.Description, 1, MaxStrLen(ValueEntry.GMADescription));
                    ValueEntry."GMAInitial Amount (LCY)" := GenJnlLine."Amount (LCY)";
                    ValueEntry."GMARemaining Amount" := GenJnlLine.Amount;
                    ValueEntry."GMARemaining Amount (LCY)" := GenJnlLine."Amount (LCY)";
                    ValueEntry."GMAInitial Amount (LCY)" := GenJnlLine."Amount (LCY)";
                    ValueEntry.GMAOpen := true;
                    ValueEntry."GMAUser Id" := UserId;
                    ValueEntry."GMACurrency Code" := GenJnlLine."Currency Code";
                    ValueEntry."GMACurrency Factor" := GenJnlLine."Currency Factor";
                    ValueEntry."GMAValue Date" := GenJnlLine."Document Date";
                    ValueEntry."GMAPosting Date" := GenJnlLine."Posting Date";
                    ValueEntry."GMAGlobal Dimension 1" := GenJnlLine."Shortcut Dimension 1 Code";
                    ValueEntry."GMAGlobal Dimension 2" := GenJnlLine."Shortcut Dimension 2 Code";
                    ValueEntry.Insert();

                    recPosterChangeTypeAdjust.RESET;
                    IF recPosterChangeTypeAdjust.FINDLAST THEN
                        LastMov := recPosterChangeTypeAdjust."GMAEntry No." + 1
                    ELSE
                        LastMov := 1;

                    recPosterChangeTypeAdjust.INIT;
                    recPosterChangeTypeAdjust."GMAEntry No." := LastMov;
                    recPosterChangeTypeAdjust."GMAPosting Date" := ValueEntry."GMAPosting Date";
                    recPosterChangeTypeAdjust."GMADocument Type" := ValueEntry."GMADocument Type";
                    recPosterChangeTypeAdjust."GMADocument No." := ValueEntry."GMADocument No.";
                    recPosterChangeTypeAdjust.GMAAmount := ValueEntry.GMAAmount;
                    recPosterChangeTypeAdjust."GMACash/Bank Account" := ValueEntry."GMACash/Bank Account";
                    recPosterChangeTypeAdjust.GMAValue := ValueEntry.GMAValue;
                    recPosterChangeTypeAdjust."GMAValues Entry No." := ValueEntry."GMAEntry No.";
                    recPosterChangeTypeAdjust."GMAUser Id" := USERID;
                    recPosterChangeTypeAdjust."GMACurrency Code" := ValueEntry."GMACurrency Code";
                    recPosterChangeTypeAdjust."GMAPrevious Exchange Rate" := ValueEntry."GMACurrency Factor";
                    recPosterChangeTypeAdjust."GMAExchange Rate" := GenJnlLine."Currency Factor";

                    recPosterChangeTypeAdjust."GMAAmount (LCY)" := ValueEntry."GMAAmount (LCY)";
                    recPosterChangeTypeAdjust.GMAAmount := ValueEntry.GMAAmount;
                    recPosterChangeTypeAdjust."GMATo be Posted" := TRUE;

                    recPosterChangeTypeAdjust.GMAAccount := ValueEntry."GMACash/Bank Account";

                    recPosterChangeTypeAdjust.INSERT(FALSE);
                end;
            end;
        end;
    end;

    //Ajuste por diferencia de cambio--
    //Actualizacion de ARBA ++

    [EventSubscriber(ObjectType::Page, Page::"GMAPadron ARBA", 'ActualizarPercepcionesARBAGMA', '', false, false)]
    local procedure ActualizarPercepcionesARBA(var IsHandled: Boolean);
    var
        recPadronARBA: Record "GMAPadron ARBA";
        recGrupoActual: Text;
        recPorcentajeActual: Text;
        recJurisdiccionActual: Record "Tax Jurisdiction";
        recTaxDetails: Record "Tax Detail";
        decTaxPercentage: decimal;
        recTaxAreaLine: Record "Tax Area Line";
        linareaimpuestoaux: Record "Tax Area Line";
        linareaimpuestoClienteDelete: Record "Tax Area Line";
        recCustomer: Record Customer;
        recAuxJurisdicciones: Record "Tax Jurisdiction";
        recGMAProcAli: record GMALogProcAlicuotas;
        "GMATreasury Setup": Record "GMATreasury Setup";

        PerceptionabyEntity: Record PerceptionabyEntity;
        TaxArea: Record "Tax Area";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
        recCompanyInformation: Record "Company Information";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin

                IsHandled := true;

                recGMAProcAli.reset;
                recGMAProcAli.GMAUserID := UserId;
                recGMAProcAli.GMAStartDateTime := CurrentDateTime();
                recGMAProcAli.GMAEndDateTime := recGMAProcAli.GMAStartDateTime;
                recGMAProcAli.GMAPadronType := 'PERCEPCIONES';
                recGMAProcAli.GMAJurisdictionCode := 'ARBA';
                recGMAProcAli.GMAStatus := recGMAProcAli.GMAStatus::Interrupted;
                recGMAProcAli.Insert(true);
                Commit();
                "GMATreasury Setup".get;
                "GMATreasury Setup".TestField("GMAProvince Code ARBA");
                IF ("GMATreasury Setup"."GMATax Historic Activation") then begin
                    //mantiene 2 meses del padron
                    recCustomer.Reset();
                    if recCustomer.FindFirst() then
                        REPEAT
                            //creo la nueva tax area line con el grupo que corresponda
                            recCustomer."VAT Registration No." := DelChr(recCustomer."VAT Registration No.", '=', '_-. ');

                            recPadronARBA.Reset();
                            recPadronARBA.SetCurrentKey(GMARegimen, "GMAFecha_Pub", GMAN_CUIT);
                            recPadronARBA.SetFilter(GMAN_CUIT, '=%1', recCustomer."VAT Registration No.");
                            recPadronARBA.SetFilter(GMARegimen, '=%1', 'P');
                            if recPadronARBA.FindFirst() then begin
                                recJurisdiccionActual.Reset();
                                recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code ARBA");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual.GMAARBA, true);
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", recPadronARBA.GMAG_P_R);
                                if recJurisdiccionActual.FindFirst() then begin
                                    PerceptionabyEntity.Reset();
                                    PerceptionabyEntity.SetRange(ProvinceCode, "GMATreasury Setup"."GMAProvince Code ARBA");
                                    PerceptionabyEntity.Setfilter(EntityID, '<>%1', '');
                                    if PerceptionabyEntity.FindFirst() then
                                        repeat
                                            TaxArea.Reset();
                                            TaxArea.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            TaxArea.SetRange(PERCustomerNo, recCustomer."No.");
                                            IF (TaxArea.FindFirst()) THEN
                                                repeat
                                                    recTaxAreaLine.Reset();
                                                    recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                    recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                                    recTaxAreaLine.SetRange(GMAARBA, true);
                                                    recTaxAreaLine.SetFilter("GMATo Date", '=%1', recPadronARBA.GMAFecha_Hasta);
                                                    if not (recTaxAreaLine.FindFirst()) then begin
                                                        recTaxAreaLine.Reset();
                                                        recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                        recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                                        recTaxAreaLine.SetRange(GMAARBA, true);
                                                        if (recTaxAreaLine.FindFirst()) then begin
                                                            linareaimpuestoClienteDelete.Reset();
                                                            linareaimpuestoClienteDelete.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                            linareaimpuestoClienteDelete.SetRange(linareaimpuestoClienteDelete."Tax Area", TaxArea.Code);
                                                            linareaimpuestoClienteDelete.SetRange(GMAARBA, true);
                                                            if (linareaimpuestoClienteDelete.FindFirst()) then begin
                                                                IF (linareaimpuestoClienteDelete.COUNT) >= 2 THEN
                                                                    linareaimpuestoClienteDelete.DELETE;
                                                            end;
                                                        end;
                                                    end;
                                                    recTaxAreaLine.RESET;
                                                    recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                    recTaxAreaLine.SETRANGE("Tax Area", TaxArea.Code);
                                                    recTaxAreaLine.SETRANGE(GMAARBA, TRUE);
                                                    IF (recTaxAreaLine.FINDFIRST) THEN;
                                                    IF (recTaxAreaLine."Tax Jurisdiction Code" = recJurisdiccionActual.Code) THEN BEGIN
                                                        IF (recTaxAreaLine."GMAFrom Date" = 0D) OR (recTaxAreaLine."GMAFrom Date" > recPadronARBA.GMAFecha_Hasta) THEN
                                                            recTaxAreaLine."GMAFrom Date" := recPadronARBA.GMAFecha_Desde;
                                                        recTaxAreaLine."GMATo Date" := recPadronARBA.GMAFecha_Hasta;
                                                        IF (recTaxAreaLine.MODIFY) THEN;
                                                    END
                                                    ELSE BEGIN
                                                        linareaimpuestoaux.Reset();
                                                        linareaimpuestoaux.init;
                                                        linareaimpuestoaux.validate("Tax Area", TaxArea.Code);
                                                        linareaimpuestoaux.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                                        linareaimpuestoaux.Validate("GMAFrom Date", recPadronARBA.GMAFecha_Desde);
                                                        linareaimpuestoaux.Validate("GMATo Date", recPadronARBA.GMAFecha_Hasta);
                                                        recTaxAreaLine.EntityID := PerceptionabyEntity.EntityID;
                                                        linareaimpuestoaux.GMAARBA := true;
                                                        IF (linareaimpuestoaux.Insert()) then begin
                                                            recPadronARBA.GMACliente := recCustomer."No.";
                                                            recPadronARBA.GMAActualizado := true;
                                                            recPadronARBA.Modify();
                                                        end;
                                                    end;
                                                until TaxArea.Next() = 0;
                                        until PerceptionabyEntity.Next() = 0;
                                end
                                else
                                    Error('There is no combination of Province Code %1, Census Code %2 and ARBA in YES in the jurisdiction table.', "GMATreasury Setup"."GMAProvince Code ARBA", recPadronARBA.GMAG_P_R);
                            end;
                        until recCustomer.Next() = 0;
                    Message('Process ended successfully');
                end
                else begin
                    //solo 1 mantiene el mes actual del padron
                    recCustomer.Reset();
                    if recCustomer.FindFirst() then
                        REPEAT
                            //creo la nueva tax area line con el grupo que corresponda
                            recCustomer."VAT Registration No." := DelChr(recCustomer."VAT Registration No.", '=', '_-. ');

                            recPadronARBA.Reset();
                            recPadronARBA.SetCurrentKey(GMARegimen, "GMAFecha_Pub", GMAN_CUIT);
                            recPadronARBA.SetFilter(GMAN_CUIT, '=%1', recCustomer."VAT Registration No.");
                            recPadronARBA.SetFilter(GMARegimen, '=%1', 'P');
                            if recPadronARBA.FindFirst() then begin
                                recJurisdiccionActual.Reset();
                                recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code ARBA");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual.GMAARBA, true);
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", recPadronARBA.GMAG_P_R);
                                if recJurisdiccionActual.FindFirst() then begin
                                    PerceptionabyEntity.Reset();
                                    PerceptionabyEntity.SetRange(ProvinceCode, "GMATreasury Setup"."GMAProvince Code ARBA");
                                    PerceptionabyEntity.Setfilter(EntityID, '<>%1', '');
                                    if PerceptionabyEntity.FindFirst() then
                                        repeat
                                            TaxArea.Reset();
                                            TaxArea.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            TaxArea.SetRange(PERCustomerNo, recCustomer."No.");
                                            IF (TaxArea.FindFirst()) THEN
                                                repeat
                                                    recTaxAreaLine.Reset();
                                                    recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                                    recTaxAreaLine.SetRange(GMAARBA, true);
                                                    if recTaxAreaLine.FindFirst() then
                                                        recTaxAreaLine.DeleteAll;

                                                    recTaxAreaLine.Reset();
                                                    recTaxAreaLine.validate("Tax Area", TaxArea.Code);
                                                    recTaxAreaLine.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                                    recTaxAreaLine.Validate("GMAFrom Date", recPadronARBA.GMAFecha_Desde);
                                                    recTaxAreaLine.Validate("GMATo Date", recPadronARBA.GMAFecha_Hasta);
                                                    recTaxAreaLine.EntityID := PerceptionabyEntity.EntityID;
                                                    recTaxAreaLine.GMAARBA := true;
                                                    IF (recTaxAreaLine.Insert()) then begin
                                                        recPadronARBA.GMACliente := recCustomer."No.";
                                                        recPadronARBA.GMAActualizado := true;
                                                        recPadronARBA.Modify();
                                                    end;
                                                until TaxArea.Next() = 0;
                                        until PerceptionabyEntity.Next() = 0;
                                end
                                else
                                    Error('There is no combination of Province Code %1, Census Code %2 and ARBA in YES in the jurisdiction table.', "GMATreasury Setup"."GMAProvince Code ARBA", recPadronARBA.GMAG_P_R);
                            end;
                        until recCustomer.Next() = 0;
                    Message('Process ended successfully');
                end;
            end;
        end;
    end;

    /*
    [EventSubscriber(ObjectType::Page, 34006694, 'ActualizarRetencionesARBA', '', false, false)]
    local procedure ActualizarRetencionesARBA(var IsHandled: Boolean);
    var
        Proveedor: Record Vendor;
        RetencCondicion: Record "GMATax Conditions";
        ProvComportRet: Record "GMAVendor Condition";
        "GMATreasury Setup": Record "GMATreasury Setup";
        Fecha_Desde: Date;
        Fecha_Hasta: Date;
        recGMAProcAli: record GMALogProcAlicuotas;
        recPadronARBA: Record "GMAPadron ARBA";
        VendorCondition: Record "GMAVendor Condition";
        ProvComportRetDEL: Record "GMAVendor Condition";
        PerceptionabyEntity: Record PerceptionabyEntity;
        TaxArea: Record "Tax Area";
    begin
        IsHandled := true;
        "GMATreasury Setup".get;
        "GMATreasury Setup".TestField("GMATax Code CABA");
        recGMAProcAli.reset;
        recGMAProcAli.GMAUserID := UserId;
        recGMAProcAli.GMAStartDateTime := CurrentDateTime();
        recGMAProcAli.GMAEndDateTime := recGMAProcAli.GMAStartDateTime;
        recGMAProcAli.GMAPadronType := 'RETENCIONES';
        recGMAProcAli.GMAJurisdictionCode := 'ARBA';
        recGMAProcAli.GMAStatus := recGMAProcAli.GMAStatus::Interrupted;
        recGMAProcAli.Insert(true);
        Commit();
        //----------------------------------PROVEEDORES--------------------------------------------------------
        Proveedor.RESET;
        IF Proveedor.FINDFIRST THEN
            repeat
                Proveedor."VAT Registration No." := DelChr(Proveedor."VAT Registration No.", '=', '_-. ');

                recPadronARBA.Reset();
                recPadronARBA.SetCurrentKey(GMARegimen, "GMAFecha_Pub", GMAN_CUIT);
                recPadronARBA.SetFilter(GMAN_CUIT, '=%1', Proveedor."VAT Registration No.");
                recPadronARBA.SetFilter(GMARegimen, '=%1', 'R');
                if recPadronARBA.FindFirst() then begin

                    //--Retenciones--------------------------------------------------------------------------------
                    RetencCondicion.RESET;
                    RetencCondicion.SETCURRENTKEY("GMAGross Inco Withholding Gr");
                    RetencCondicion.SETRANGE("GMAGross Inco Withholding Gr", recPadronARBA.GMAG_P_R);
                    IF RetencCondicion.FINDFIRST THEN BEGIN

                        ProvComportRet.RESET;
                        ProvComportRet.SETCURRENTKEY("GMAVendor Code", "GMATax Code", "GMATax Condition", "GMAFrom Date");
                        ProvComportRet.SETRANGE("GMAVendor Code", Proveedor."No.");
                        ProvComportRet.SETRANGE("GMATax Code", RetencCondicion."GMATax Code");
                        ProvComportRet.SETRANGE("GMATax Condition", RetencCondicion."GMACondition Code");
                        ProvComportRet.LOCKTABLE;
                        IF ProvComportRet.FINDFIRST THEN BEGIN
                            IF (ProvComportRet."GMATo Date" <= recPadronARBA.GMAFecha_Desde) THEN BEGIN
                                //elimino todos los registros para el proveedor, con mismo tax code y mismo periodo
                                ProvComportRetDEL.Reset();
                                ProvComportRetDEL.SetRange("GMAVendor Code", Proveedor."No.");
                                ProvComportRetDEL.SetRange("GMATax Code", RetencCondicion."GMATax Code");
                                if ProvComportRetDEL.FindSet() then
                                    repeat
                                        ProvComportRetDEL.Delete();
                                    until ProvComportRetDEL.Next() = 0;

                                //inserto
                                ProvComportRet.INIT;
                                ProvComportRet.VALIDATE("GMAVendor Code", Proveedor."No.");
                                ProvComportRet.VALIDATE("GMATax Code", RetencCondicion."GMATax Code");
                                ProvComportRet.VALIDATE("GMATax Condition", RetencCondicion."GMACondition Code");
                                ProvComportRet.Validate("GMAFrom Date", recPadronARBA.GMAFecha_Desde);
                                ProvComportRet.Validate("GMATo Date", recPadronARBA.GMAFecha_Hasta);
                                if not ProvComportRet.Insert() then
                                    ProvComportRet.Modify();
                            end;
                        end
                        else begin
                            ProvComportRet.SETRANGE("GMATax Condition");
                            IF ProvComportRet.FINDFIRST THEN BEGIN
                                IF (ProvComportRet."GMATo Date" <= recPadronARBA.GMAFecha_Desde) THEN BEGIN


                                    //elimino todos los registros para el proveedor, con mismo tax code y mismo periodo
                                    "GMATreasury Setup".TestField("GMATax Code ARBA");
                                    ProvComportRetDEL.Reset();
                                    ProvComportRetDEL.SetRange("GMAVendor Code", Proveedor."No.");
                                    ProvComportRetDEL.SetRange("GMATax Code", "GMATreasury Setup"."GMATax Code ARBA");
                                    if ProvComportRetDEL.FindSet() then
                                        repeat
                                            ProvComportRetDEL.Delete();
                                        until ProvComportRetDEL.Next() = 0;

                                    //inserto
                                    ProvComportRet.INIT;
                                    ProvComportRet.VALIDATE("GMAVendor Code", Proveedor."No.");
                                    ProvComportRet.VALIDATE("GMATax Code", RetencCondicion."GMATax Code");
                                    ProvComportRet.VALIDATE("GMATax Condition", RetencCondicion."GMACondition Code");
                                    ProvComportRet.Validate("GMAFrom Date", recPadronARBA.GMAFecha_Desde);
                                    ProvComportRet.Validate("GMATo Date", recPadronARBA.GMAFecha_Hasta);
                                    if not ProvComportRet.Insert() then begin
                                        ProvComportRet.Modify();
                                        recPadronARBA.GMAProveedor := Proveedor."No.";
                                        recPadronARBA.GMAActualizado := true;
                                        recPadronARBA.Modify();
                                    end
                                    else begin
                                        recPadronARBA.GMAProveedor := Proveedor."No.";
                                        recPadronARBA.GMAActualizado := true;
                                        recPadronARBA.Modify();

                                    end;

                                end;

                            end
                            else begin
                                //inserto
                                ProvComportRet.INIT;
                                ProvComportRet.VALIDATE("GMAVendor Code", Proveedor."No.");
                                ProvComportRet.VALIDATE("GMATax Code", RetencCondicion."GMATax Code");
                                ProvComportRet.VALIDATE("GMATax Condition", RetencCondicion."GMACondition Code");
                                ProvComportRet.Validate("GMAFrom Date", recPadronARBA.GMAFecha_Desde);
                                ProvComportRet.Validate("GMATo Date", recPadronARBA.GMAFecha_Hasta);
                                if not ProvComportRet.Insert() then begin
                                    ProvComportRet.Modify();
                                    recPadronARBA.GMAProveedor := Proveedor."No.";
                                    recPadronARBA.GMAActualizado := true;
                                    recPadronARBA.Modify();
                                end
                                else begin
                                    recPadronARBA.GMAProveedor := Proveedor."No.";
                                    recPadronARBA.GMAActualizado := true;
                                    recPadronARBA.Modify();

                                end;
                            end;
                        end;
                    end
                    else begin
                        IF (recPadronARBA.gmaG_P_R <> '00') THEN
                            ERROR('The configuration is not found in the Tax Condition table with Withholding Group %1 %2', "GMATreasury Setup"."GMATax Code ARBA", recPadronARBA.GMAG_P_R);

                    end;
                end;
            until Proveedor.Next() = 0;

        recGMAProcAli.GMAStatus := recGMAProcAli.GMAStatus::Processed;
        recGMAProcAli.GMAEndDateTime := CurrentDateTime();
        recGMAProcAli.Modify();
        Message('Process ended successfully');
    end;
    */
    //Actualizacion de ARBA --

    //Actualizacion de CABA++
    [EventSubscriber(ObjectType::Page, Page::"GMAPadron CABA", 'ActualizarPercepcionesCABAGMA', '', false, false)]
    local procedure ActualizarPercepcionesCABA(var IsHandled: Boolean);
    var
        recPadronCABA: Record "GMAPadron CABA";
        recGrupoActual: Text;
        recPorcentajeActual: Text;
        recJurisdiccionActual: Record "Tax Jurisdiction";
        recTaxDetails: Record "Tax Detail";
        decTaxPercentage: decimal;
        recTaxAreaLine: Record "Tax Area Line";
        linareaimpuestoaux: Record "Tax Area Line";
        linareaimpuestoClienteDelete: Record "Tax Area Line";
        recCustomer: Record Customer;
        recAuxJurisdicciones: Record "Tax Jurisdiction";
        recGMAProcAli: record GMALogProcAlicuotas;
        "GMATreasury Setup": Record "GMATreasury Setup";
        PerceptionabyEntity: Record PerceptionabyEntity;
        TaxArea: Record "Tax Area";
        GMASalesReceivableSetup: Record "Sales & Receivables Setup";
        recCompanyInformation: Record "Company Information";
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            IF (GMASalesReceivableSetup.Get()) and (GMASalesReceivableSetup.GMANotCreateTaxArea = true) and (GMASalesReceivableSetup.PerCreateTaxArea = true) then begin

                IsHandled := true;

                recGMAProcAli.reset;
                recGMAProcAli.GMAUserID := UserId;
                recGMAProcAli.GMAStartDateTime := CurrentDateTime();
                recGMAProcAli.GMAEndDateTime := recGMAProcAli.GMAStartDateTime;
                recGMAProcAli.GMAPadronType := 'PERCEPCIONES';
                recGMAProcAli.GMAJurisdictionCode := 'CABA';
                recGMAProcAli.GMAStatus := recGMAProcAli.GMAStatus::Interrupted;
                recGMAProcAli.Insert(true);
                Commit();
                "GMATreasury Setup".get;
                "GMATreasury Setup".TestField("GMAProvince Code CABA");
                IF ("GMATreasury Setup"."GMATax Historic Activation") then begin
                    //mantiene 2 meses del padron

                    recCustomer.Reset();
                    if recCustomer.FindFirst() then
                        REPEAT
                            //creo la nueva tax area line con el grupo que corresponda
                            recCustomer."VAT Registration No." := DelChr(recCustomer."VAT Registration No.", '=', '_-. ');

                            recPadronCABA.Reset();
                            recPadronCABA.SetCurrentKey("GMAFecha_Pub", GMAN_CUIT);
                            recPadronCABA.SetFilter(GMAN_CUIT, '=%1', recCustomer."VAT Registration No.");
                            if recPadronCABA.FindFirst() then begin
                                recJurisdiccionActual.Reset();
                                recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code CABA");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual.GMACABA, true);
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", FORMAT(recPadronCABA.GMAPercepcion));
                                if recJurisdiccionActual.FindFirst() then begin
                                    PerceptionabyEntity.Reset();
                                    PerceptionabyEntity.SetRange(ProvinceCode, "GMATreasury Setup"."GMAProvince Code CABA");
                                    PerceptionabyEntity.Setfilter(EntityID, '<>%1', '');
                                    if PerceptionabyEntity.FindFirst() then
                                        repeat
                                            TaxArea.Reset();
                                            TaxArea.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                            TaxArea.SetRange(PERCustomerNo, recCustomer."No.");
                                            IF (TaxArea.FindFirst()) THEN
                                                repeat
                                                    recTaxAreaLine.Reset();
                                                    recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                    recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                                    recTaxAreaLine.SetRange(recTaxAreaLine."GMAHigh Risk CABA", true);
                                                    recTaxAreaLine.SetFilter("GMATo Date", '=%1', recPadronCABA.GMAFecha_Hasta);
                                                    recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                                    if not (recTaxAreaLine.FindFirst()) then begin
                                                        recTaxAreaLine.Reset();
                                                        recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                        recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", TaxArea.Code);
                                                        recTaxAreaLine.SetRange(recTaxAreaLine."GMAHigh Risk CABA", true);
                                                        recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                                        if (recTaxAreaLine.FindFirst()) then begin
                                                            linareaimpuestoClienteDelete.Reset();
                                                            linareaimpuestoClienteDelete.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                            linareaimpuestoClienteDelete.SetRange(linareaimpuestoClienteDelete."Tax Area", TaxArea.Code);
                                                            linareaimpuestoClienteDelete.SetRange(linareaimpuestoClienteDelete."GMAHigh Risk CABA", true);
                                                            if (linareaimpuestoClienteDelete.FindFirst()) then begin
                                                                IF (linareaimpuestoClienteDelete.COUNT) >= 2 THEN
                                                                    linareaimpuestoClienteDelete.DELETE;
                                                            end;
                                                        end;
                                                    end;
                                                    recTaxAreaLine.RESET;
                                                    recTaxAreaLine.SETCURRENTKEY("Tax Area", "GMAFrom Date", "Tax Jurisdiction Code");
                                                    recTaxAreaLine.SETRANGE("Tax Area", TaxArea.Code);
                                                    recTaxAreaLine.SETRANGE(recTaxAreaLine."GMAHigh Risk CABA", TRUE);
                                                    recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                                    IF (recTaxAreaLine.FINDFIRST) THEN;
                                                    IF (recTaxAreaLine."Tax Jurisdiction Code" = recJurisdiccionActual.Code) THEN BEGIN
                                                        IF (recTaxAreaLine."GMAFrom Date" = 0D) OR (recTaxAreaLine."GMAFrom Date" > recPadronCABA.GMAFecha_Hasta) THEN
                                                            recTaxAreaLine."GMAFrom Date" := recPadronCABA.GMAFecha_Desde;
                                                        recTaxAreaLine."GMATo Date" := recPadronCABA.GMAFecha_Hasta;
                                                        IF (recTaxAreaLine.MODIFY) THEN;
                                                    END
                                                    ELSE BEGIN
                                                        linareaimpuestoaux.Reset();
                                                        linareaimpuestoaux.init;
                                                        linareaimpuestoaux.validate("Tax Area", TaxArea.Code);
                                                        linareaimpuestoaux.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                                        linareaimpuestoaux.Validate("GMAFrom Date", recPadronCABA.GMAFecha_Desde);
                                                        linareaimpuestoaux.Validate("GMATo Date", recPadronCABA.GMAFecha_Hasta);
                                                        linareaimpuestoaux.EntityID := PerceptionabyEntity.EntityID;
                                                        linareaimpuestoaux."GMAHigh Risk CABA" := true;
                                                        IF (linareaimpuestoaux.Insert()) then begin
                                                            recPadronCABA.GMACliente := recCustomer."No.";
                                                            recPadronCABA.GMAActualizado := true;
                                                            recPadronCABA.Modify();
                                                        end;
                                                    end;
                                                until TaxArea.Next() = 0;
                                        until PerceptionabyEntity.Next() = 0;
                                end
                                else
                                    Error('There is no combination of Province Code %1, CABA Code %2 and CABA is YES', "GMATreasury Setup"."GMAProvince Code CABA", FORMAT(recPadronCABA.GMAPercepcion));
                            end;
                        until recCustomer.Next() = 0;
                    Message('Process ended successfully');
                end
                else begin
                    //solo 1 mantiene el mes actual del padron
                    recCustomer.Reset();
                    if recCustomer.FindFirst() then
                        REPEAT
                            //creo la nueva tax area line con el grupo que corresponda
                            recCustomer."VAT Registration No." := DelChr(recCustomer."VAT Registration No.", '=', '_-. ');

                            recPadronCABA.Reset();
                            recPadronCABA.SetCurrentKey("GMAFecha_Pub", GMAN_CUIT);
                            recPadronCABA.SetFilter(GMAN_CUIT, '=%1', recCustomer."VAT Registration No.");

                            if recPadronCABA.FindFirst() then begin
                                recJurisdiccionActual.Reset();
                                recJurisdiccionActual.SetCurrentKey("GMAProvince Code", GMAARBA, GMATUCUMAN, GMACORDOBA, GMAJUJUY, "GMAARBA Code");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAProvince Code", "GMATreasury Setup"."GMAProvince Code CABA");
                                recJurisdiccionActual.SetRange(recJurisdiccionActual.GMACABA, true);
                                recJurisdiccionActual.SetRange(recJurisdiccionActual."GMAARBA Code", FORMAT(recPadronCABA.GMAPercepcion));
                                if recJurisdiccionActual.FindFirst() then begin
                                    recTaxAreaLine.Reset();
                                    recTaxAreaLine.SetRange(recTaxAreaLine."Tax Area", recCustomer."Tax Area Code");
                                    recTaxAreaLine.SetRange("GMAHigh Risk CABA", true);
                                    recTaxAreaLine.SetRange(EntityID, PerceptionabyEntity.EntityID);
                                    if recTaxAreaLine.FindFirst() then
                                        recTaxAreaLine.DeleteAll;

                                    recTaxAreaLine.Reset();
                                    recTaxAreaLine.validate("Tax Area", recCustomer."Tax Area Code");
                                    recTaxAreaLine.validate("Tax Jurisdiction Code", recJurisdiccionActual.Code);
                                    recTaxAreaLine.Validate("GMAFrom Date", recPadronCABA.GMAFecha_Desde);
                                    recTaxAreaLine.Validate("GMATo Date", recPadronCABA.GMAFecha_Hasta);
                                    recTaxAreaLine.EntityID := PerceptionabyEntity.EntityID;
                                    recTaxAreaLine."GMAHigh Risk CABA" := true;
                                    IF (recTaxAreaLine.Insert()) then begin
                                        recPadronCABA.GMACliente := recCustomer."No.";
                                        recPadronCABA.GMAActualizado := true;
                                        recPadronCABA.Modify();
                                    end;
                                end
                                else
                                    Error('There is no combination of Province Code %1, CABA Code %2 and CABA is YES', "GMATreasury Setup"."GMAProvince Code CABA", FORMAT(recPadronCABA.GMAPercepcion));
                            end;
                        until recCustomer.Next() = 0;
                    Message('Process ended successfully');
                end;
            end;
        end;
    end;
    //Actualizacion de CABA--

    // Validacion de mandatory --
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDocLOC1(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    var
        recCompanyInformation: Record "Company Information";

        recCompanyInfo: Record "Company Information";
        RecLine: Record "Sales Line";
        lclCustomer: Record Customer;
        lclTipoDocAFIP: Record "GMAAFIP - Document type";
        lclCurrency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        Text50002: Label 'Cod. zona fiscal difiere cabecera y lineas \\ Cabecera:%1%2 - Codigo.. zona fiscal:%3 \\ Linea:%4 - Codigo. zona fiscal:%5';
        Text50001: Label 'Imponible difiere cabecera y renglones. Código genial. área fiscal en la cabecera \ \ Cabecera:%1%2 - Sujeto a impuesto:.%3 \ \ Línea:%4 - Sujeto a impuesto:%5';
        recSalesReceivables: Record "Sales & Receivables Setup";
        pageConfirmation: page "GMASales Order Setup II";
        // AW - begin
        vconfventas: Record "Sales & Receivables Setup";
        cduSalesPost: Codeunit "Sales-Post";
        // AW - end
        text010: Label 'La línea %1 - %2 debe tener un código de grupo impuesto';
        Text50003: Label 'No existe Letra con el filtro Punto de venta :%1 Tipo Fiscal:%2 Tipo de documento %3';
        ElectronicInvoice: Codeunit "GMAElectronic Invoice AR";
        // ElectronicInvoiceSaas: Codeunit "GMAElectronic Invoice ARSaas";
        ElectronicInvoiceBC23: Codeunit "GMAElectron Invoice AR_BC23";
        CAETypes: Record "GMAAFIP - Posted CAE";
        ComprobanteARegistrar: Text[20];
        InvoiceSeriesSetup: Record "GMAInvoice Series Setup2";
        gComprobanteARegistrar: Integer;
        PtoVta: Integer;
        TipoCbte: Integer;
        gUltCmpAutorizado: Integer;
        wsfeConfig: Record "GMAWS AFIP Setup";
        EsBatch: Boolean;
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) AND (recCompanyInformation."GMAAct. Electronic Invoice") then begin
            wsfeConfig.get();
            if (PreviewMode) then
                HideProgressWindow := true;

            IF NOT PreviewMode THEN BEGIN
                vconfventas.GET();
                SalesHeader.CALCFIELDS(GMACAI2, "GMAReturn Document Number2");

                //Chequeo que tenga punto de venta y tipo de comprobante MC
                SalesHeader.TestField("GMAAFIP Invoice Voucher Type");
                SalesHeader.TestField("GMAPoint of Sales");
                SalesHeader.TestField("Tax Area Code");
                SalesHeader.TestField("Posting No.");
                SalesHeader.TestField("GMAProvince");
                SalesHeader.TestField("VAT Registration No.");

                //NEWDDS
                IF ((SalesHeader.Ship = true) OR (SalesHeader.Receive = true)) AND (SalesHeader.Invoice = FALSE) THEN
                    SalesHeader."GMAShipment or Invoice" := 'REMITO -'
                ELSE
                    SalesHeader."GMAShipment or Invoice" := 'FACTURA -';

                IF ((SalesHeader.Ship = true) OR (SalesHeader.Receive = true)) AND (SalesHeader.Invoice = true) THEN
                    SalesHeader."GMAShipment or Invoice" := 'REMITO y FACTURA';
                //NEWDDS
                EVALUATE(PtoVta, SalesHeader."GMAPoint of Sales");
                EVALUATE(TipoCbte, SalesHeader."GMAAFIP Invoice Voucher Type");

                // Control de Cod grupo impuesto
                IF vconfventas."GMATax Group Mandatory" = TRUE THEN BEGIN
                    RecLine.RESET;
                    RecLine.SETRANGE(RecLine."Document No.", SalesHeader."No.");
                    RecLine.SETFILTER(RecLine."Qty. to Invoice", '>%1', 0);
                    if RecLine.FindFirst() then
                        REPEAT
                            IF (RecLine."Qty. to Invoice" <> 0) AND (RecLine."Unit Price" <> 0) AND (RecLine."Tax Group Code" = '') THEN BEGIN
                                ERROR(text010, RecLine."Line No.", RecLine.Description);
                                EXIT;
                            END;
                        UNTIL RecLine.NEXT = 0;
                END;

                cduSalesPost.SetSuppressCommit(true);
                CommitIsSuppressed := true;

                vconfventas.GET();
                if (SalesHeader."Shipping No. Series" = '') then begin
                    SalesHeader."Shipping No. Series" := vconfventas."Posted Shipment Nos.";
                end;
                if (SalesHeader."Posting No. Series" = '') then begin
                    SalesHeader."Posting No. Series" := vconfventas."Posted Invoice Nos.";
                end;

                //SalesHeader."Posting No." := '';
                //SalesHeader."Shipping No." := '';
                EsBatch := false;//BatchProcessingMgt.Run(); //ver como identificar si es batch
                recSalesReceivables.Reset();
                recSalesReceivables.Get();
                if recSalesReceivables.GMAShow_confirm_page_posting then begin
                    if not EsBatch then begin
                        if not (PAGE.RUNMODAL(PAGE::"GMASales Order Setup II", SalesHeader) = ACTION::LookupOK) then begin
                            ERROR('Operación Cancelada');
                            exit;
                        end;
                    end
                    else begin
                        //proceso automático, sin pedido de confirmación.
                        pageConfirmation.prepararNumeroDocumento(SalesHeader);
                    end;
                end
                else begin
                    if EsBatch then begin
                        pageConfirmation.prepararNumeroDocumento(SalesHeader);
                    end
                    else begin
                        pageConfirmation.prepararNumeroDocumento(SalesHeader);
                    end;
                end;

                CLEAR(RecLine);
                RecLine.SETRANGE("Document Type", SalesHeader."Document Type");
                RecLine.SETRANGE("Document No.", SalesHeader."No.");
                RecLine.SETFILTER(Quantity, '<>0');
                if RecLine.FINDSET then
                    repeat

                        if RecLine."Tax Area Code" <> SalesHeader."Tax Area Code" then
                            ERROR(Text50002, SalesHeader."Document Type", SalesHeader."No.", SalesHeader."Tax Area Code",
                                           RecLine."Line No.", RecLine."Tax Area Code");

                        if RecLine."Tax Liable" <> SalesHeader."Tax Liable" then
                            ERROR(Text50001, SalesHeader."Document Type", SalesHeader."No.", SalesHeader."Tax Liable",
                                                                  RecLine."Line No.", RecLine."Tax Liable");
                    until RecLine.NEXT = 0;
                recCompanyInfo.GET;
                SalesHeader.CALCFIELDS(GMACAI2, "GMAReturn Document Number2");
                if (SalesHeader."GMAElectronic Invoicing" <> SalesHeader."GMAElectronic Invoicing"::No) then
                    case SalesHeader."GMAElectronic Invoicing" of
                        SalesHeader."GMAElectronic Invoicing"::FE:
                            begin

                                IF (SalesHeader."GMACAI2" = '') THEN
                                    SalesHeader."Posting No." := '';

                                if (SalesHeader."GMAExport Type" = SalesHeader."GMAExport Type"::" ") then
                                    SalesHeader.TESTFIELD(SalesHeader."GMAExport Type");

                                GLSetup.GET;
                                if lclCurrency.GET(SalesHeader."Currency Code") then begin
                                    if lclCurrency."GMAAFIP Code" = '' then
                                        ERROR(STRSUBSTNO('Por favor, informe el Código de AFIP para la moneda %1', SalesHeader."Currency Code"));
                                end
                                else begin
                                    if GLSetup."GMAAFIP LC Code" = '' then
                                        ERROR('Falta configurar el Código de Divisa Local de la AFIP en General Ledger Setup, en caso de ser Pesos informar PES.');
                                end;

                                if (SalesHeader."VAT Registration No." = '') then
                                    ERROR('Debe completar el CUIT en el comprobante.');

                                IF (SalesHeader."GMAShipment or Invoice" <> 'REMITO -') THEN
                                    ValidateFechaCbteVenta(SalesHeader."Posting Date", SalesHeader."GMAElectronic Invoicing");

                                lclCustomer.GET(SalesHeader."Sell-to Customer No.");
                                if lclCustomer."GMAAFIP Document Type" <> '' then begin
                                    if lclTipoDocAFIP.GET(lclCustomer."GMAAFIP Document Type") then begin
                                        if lclTipoDocAFIP."GMAAFIP Code" = '' then
                                            ERROR('Especifique %1 para Tipo Documento AFIP %2.',
                                                  lclTipoDocAFIP.FIELDNAME("GMAAFIP Code"), lclTipoDocAFIP.GMACodigo);
                                    end;
                                end
                                else
                                    ERROR('Por favor, informe %1 en %2', lclCustomer.FIELDNAME("GMAAFIP Document Type"), SalesHeader."Sell-to Customer No.");

                                IF (SalesHeader.GMACAI2 = '') THEN BEGIN
                                    if (((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")) and (SalesHeader.Invoice)) OR
                                       ((SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) AND (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order")) then BEGIN

                                        IF (wsfeConfig.GMABC23) THEN begin
                                            ElectronicInvoiceBC23.FEV1CompUltimoAutorizado(TipoCbte, gUltCmpAutorizado, FORMAT(PtoVta), SalesHeader."GMAAFIP Invoice Voucher Type", SalesHeader."No.", true);//Ultimo parametro si va con Commit TA
                                        end
                                        else begin
                                            ElectronicInvoice.FEV1CompUltimoAutorizado(TipoCbte, gUltCmpAutorizado, FORMAT(PtoVta), SalesHeader."GMAAFIP Invoice Voucher Type", SalesHeader."No.", true);//Ultimo parametro si va con Commit TA
                                        end;

                                        ComprobanteARegistrar := FORMAT(gUltCmpAutorizado);
                                        ComprobanteARegistrar := INCSTR(ComprobanteARegistrar);
                                        EVALUATE(gComprobanteARegistrar, ComprobanteARegistrar);
                                        WHILE STRLEN(ComprobanteARegistrar) < 8 DO
                                            ComprobanteARegistrar := '0' + ComprobanteARegistrar;

                                        InvoiceSeriesSetup.RESET;
                                        InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAFiscal Type", SalesHeader."GMAFiscal Type");
                                        InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMACompany Activity", SalesHeader."GMAPoint of Sales");

                                        IF (SalesHeader."GMADocument Type Loc." = SalesHeader."GMADocument Type Loc."::Invoice) OR
                                          (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
                                            InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAInvoice Type", InvoiceSeriesSetup."GMAInvoice Type"::Factura);

                                        IF (SalesHeader."GMADocument Type Loc." = SalesHeader."GMADocument Type Loc."::"GMANota Debito") THEN
                                            InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAInvoice Type", InvoiceSeriesSetup."GMAInvoice Type"::"Nota Debito");

                                        IF (SalesHeader."GMADocument Type Loc." = SalesHeader."GMADocument Type Loc."::"Credit Memo") OR
                                          (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") THEN
                                            InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAInvoice Type", InvoiceSeriesSetup."GMAInvoice Type"::"Nota Credito");

                                        InvoiceSeriesSetup.SETFILTER(InvoiceSeriesSetup.GMALetter, '<>%1', '');
                                        IF (InvoiceSeriesSetup.FINDFIRST) THEN BEGIN
                                            //ComprobanteARegistrar:= InvoiceSeriesSetup.Letter + InvoiceSeriesSetup."Company Activity"+'-'+ComprobanteARegistrar;
                                            IF (STRLEN(SalesHeader."GMAAFIP Invoice Voucher Type") = 3) THEN begin
                                                InvoiceSeriesSetup.TESTFIELD("GMANo. Serie FCRED");
                                                ComprobanteARegistrar := InvoiceSeriesSetup."GMANo. Serie FCRED" + '-' + ComprobanteARegistrar;
                                            end
                                            ELSE begin
                                                InvoiceSeriesSetup.TESTFIELD("GMANo. Serie");
                                                ComprobanteARegistrar := InvoiceSeriesSetup."GMANo. Serie" + '-' + ComprobanteARegistrar;
                                            end;

                                            SalesHeader."Posting No." := ComprobanteARegistrar;
                                            //VALIDATE("Next Shipment No.");
                                            //SalesHeader."Shipping No.":= "Next Shipment No.";
                                            SalesHeader."GMAAFIP Voucher No." := gComprobanteARegistrar;
                                            CAETypes.Init();
                                            CAETypes."GMADocument Type" := SalesHeader."GMADocument Type Loc.";
                                            CAETypes."GMADocument No." := SalesHeader."No.";
                                            CAETypes."GMAAFIP Voucher No." := gComprobanteARegistrar;
                                            CAETypes."GMAPosting No." := ComprobanteARegistrar;
                                            if not (CAETypes.Insert()) then
                                                CAETypes.Modify();
                                        END
                                        ELSE
                                            ERROR(Text50003, SalesHeader."GMAPoint of Sales", SalesHeader."GMAFiscal Type", SalesHeader."GMADocument Type Loc.");
                                    END;
                                END
                                ELSE BEGIN
                                    CAETypes.RESET;
                                    CAETypes.SETRANGE(CAETypes."GMADocument Type", SalesHeader."GMADocument Type Loc.");
                                    CAETypes.SETRANGE(CAETypes."GMADocument No.", SalesHeader."No.");
                                    IF (CAETypes.FINDFIRST) THEN
                                        SalesHeader."GMAAFIP Voucher No." := CAETypes."GMAAFIP Voucher No.";

                                    SalesHeader."Posting No." := salesHeader."GMAReturn Document Number2";
                                END;
                            end;
                        SalesHeader."GMAElectronic Invoicing"::FEX:
                            begin
                                IF (SalesHeader."GMACAI2" = '') THEN
                                    SalesHeader."Posting No." := '';

                                if (SalesHeader."GMAExport Type" = SalesHeader."GMAExport Type"::" ") then
                                    SalesHeader.TESTFIELD(SalesHeader."GMAExport Type");

                                GLSetup.GET;
                                if lclCurrency.GET(SalesHeader."Currency Code") then begin
                                    if lclCurrency."GMAAFIP Code" = '' then
                                        ERROR(STRSUBSTNO('Por favor, informe el Código de AFIP para la moneda %1', SalesHeader."Currency Code"));
                                end
                                else begin
                                    if GLSetup."GMAAFIP LC Code" = '' then
                                        ERROR('Falta configurar el Código de Divisa Local de la AFIP en General Ledger Setup, en caso de ser Pesos informar PES.');
                                end;

                                if (SalesHeader."VAT Registration No." = '') then
                                    ERROR('Debe completar el CUIT en el comprobante.');

                                IF (SalesHeader."GMAShipment or Invoice" <> 'REMITO -') THEN
                                    ValidateFechaCbteVenta(SalesHeader."Posting Date", SalesHeader."GMAElectronic Invoicing");

                                lclCustomer.GET(SalesHeader."Sell-to Customer No.");
                                if lclCustomer."GMAAFIP Document Type" <> '' then begin
                                    if lclTipoDocAFIP.GET(lclCustomer."GMAAFIP Document Type") then begin
                                        if lclTipoDocAFIP."GMAAFIP Code" = '' then
                                            ERROR('Especifique %1 para Tipo Documento AFIP %2.',
                                                  lclTipoDocAFIP.FIELDNAME("GMAAFIP Code"), lclTipoDocAFIP.GMACodigo);
                                    end;
                                end
                                else
                                    ERROR('Por favor, informe %1 en %2', lclCustomer.FIELDNAME("GMAAFIP Document Type"), SalesHeader."Sell-to Customer No.");

                                IF (SalesHeader.GMACAI2 = '') THEN BEGIN
                                    if (((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")) and (SalesHeader.Invoice)) OR
                                     ((SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) AND (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order")) then BEGIN

                                        IF (wsfeConfig.GMABC23) THEN begin
                                            ElectronicInvoiceBC23.FEXCompUltimoAutorizado(TipoCbte, gUltCmpAutorizado, FORMAT(PtoVta), SalesHeader."GMAAFIP Invoice Voucher Type", SalesHeader."No.", true);//Ultimo parametro si va con Commit TA
                                        end
                                        else begin
                                            ElectronicInvoice.FEXCompUltimoAutorizado(TipoCbte, gUltCmpAutorizado, FORMAT(PtoVta), SalesHeader."GMAAFIP Invoice Voucher Type", SalesHeader."No.", true);//Ultimo parametro si va con Commit TA
                                        end;

                                        ComprobanteARegistrar := FORMAT(gUltCmpAutorizado);
                                        ComprobanteARegistrar := INCSTR(ComprobanteARegistrar);
                                        EVALUATE(gComprobanteARegistrar, ComprobanteARegistrar);
                                        WHILE STRLEN(ComprobanteARegistrar) < 8 DO
                                            ComprobanteARegistrar := '0' + ComprobanteARegistrar;

                                        InvoiceSeriesSetup.RESET;
                                        InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAFiscal Type", SalesHeader."GMAFiscal Type");
                                        InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMACompany Activity", SalesHeader."GMAPoint of Sales");

                                        IF (SalesHeader."GMADocument Type Loc." = SalesHeader."GMADocument Type Loc."::Invoice) OR
                                          (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
                                            InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAInvoice Type", InvoiceSeriesSetup."GMAInvoice Type"::Factura);

                                        IF (SalesHeader."GMADocument Type Loc." = SalesHeader."GMADocument Type Loc."::"GMANota Debito") THEN
                                            InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAInvoice Type", InvoiceSeriesSetup."GMAInvoice Type"::"Nota Debito");

                                        IF (SalesHeader."GMADocument Type Loc." = SalesHeader."GMADocument Type Loc."::"Credit Memo") OR
                                          (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") THEN
                                            InvoiceSeriesSetup.SETRANGE(InvoiceSeriesSetup."GMAInvoice Type", InvoiceSeriesSetup."GMAInvoice Type"::"Nota Credito");

                                        InvoiceSeriesSetup.SETFILTER(InvoiceSeriesSetup.GMALetter, '<>%1', '');
                                        IF (InvoiceSeriesSetup.FINDFIRST) THEN BEGIN
                                            //ComprobanteARegistrar:= InvoiceSeriesSetup.Letter + InvoiceSeriesSetup."Company Activity"+'-'+ComprobanteARegistrar;

                                            InvoiceSeriesSetup.TESTFIELD("GMANo. Serie");
                                            ComprobanteARegistrar := InvoiceSeriesSetup."GMANo. Serie" + '-' + ComprobanteARegistrar;

                                            SalesHeader."Posting No." := ComprobanteARegistrar;

                                            SalesHeader."GMAAFIP Voucher No." := gComprobanteARegistrar;

                                            CAETypes.Init();
                                            CAETypes."GMADocument Type" := SalesHeader."GMADocument Type Loc.";
                                            CAETypes."GMADocument No." := SalesHeader."No.";
                                            CAETypes."GMAAFIP Voucher No." := gComprobanteARegistrar;
                                            CAETypes."GMAPosting No." := ComprobanteARegistrar;
                                            if not (CAETypes.Insert()) then
                                                CAETypes.Modify();
                                        END
                                        ELSE
                                            ERROR(Text50003, SalesHeader."GMAPoint of Sales", SalesHeader."GMAFiscal Type", SalesHeader."GMADocument Type Loc.");
                                    end;
                                END
                                ELSE BEGIN
                                    CAETypes.RESET;
                                    CAETypes.SETRANGE(CAETypes."GMADocument Type", SalesHeader."GMADocument Type Loc.");
                                    CAETypes.SETRANGE(CAETypes."GMADocument No.", SalesHeader."No.");
                                    IF (CAETypes.FINDFIRST) THEN
                                        SalesHeader."GMAAFIP Voucher No." := CAETypes."GMAAFIP Voucher No.";

                                    SalesHeader."Posting No." := salesHeader."GMAReturn Document Number2";
                                END;
                            end;
                    end;
            end
            else begin
                SalesHeader.Validate("GMAPoint of Sales");

                if (SalesHeader."GMA FCRED") then
                    SalesHeader.TestField("GMA TipoFCRED");

                //Chequeo que tenga punto de venta y tipo de comprobante MC
                SalesHeader.TestField("GMAAFIP Invoice Voucher Type");
                SalesHeader.TestField("GMAPoint of Sales");
                SalesHeader.TestField("Tax Area Code");
                SalesHeader.TestField("Posting No.");
                SalesHeader.TestField("GMAProvince");
                SalesHeader.TestField("VAT Registration No.");

                EVALUATE(PtoVta, SalesHeader."GMAPoint of Sales");
                EVALUATE(TipoCbte, SalesHeader."GMAAFIP Invoice Voucher Type");

                // Control de Cod grupo impuesto
                IF vconfventas."GMATax Group Mandatory" = TRUE THEN BEGIN
                    RecLine.RESET;
                    RecLine.SETRANGE(RecLine."Document No.", SalesHeader."No.");
                    RecLine.SETFILTER(RecLine."Qty. to Invoice", '>%1', 0);
                    if RecLine.FindFirst() then
                        REPEAT
                            IF (RecLine."Qty. to Invoice" <> 0) AND (RecLine."Unit Price" <> 0) AND (RecLine."Tax Group Code" = '') THEN BEGIN
                                ERROR(text010, RecLine."Line No.", RecLine.Description);
                                EXIT;
                            END;
                        UNTIL RecLine.NEXT = 0;
                END;

                CLEAR(RecLine);
                RecLine.SETRANGE("Document Type", SalesHeader."Document Type");
                RecLine.SETRANGE("Document No.", SalesHeader."No.");
                RecLine.SETFILTER(Quantity, '<>0');
                if RecLine.FINDSET then
                    repeat

                        if RecLine."Tax Area Code" <> SalesHeader."Tax Area Code" then
                            ERROR(Text50002, SalesHeader."Document Type", SalesHeader."No.", SalesHeader."Tax Area Code",
                                                                  RecLine."Line No.", RecLine."Tax Area Code");

                        if RecLine."Tax Liable" <> SalesHeader."Tax Liable" then
                            ERROR(Text50001, SalesHeader."Document Type", SalesHeader."No.", SalesHeader."Tax Liable",
                                                                  RecLine."Line No.", RecLine."Tax Liable");
                    until RecLine.NEXT = 0;

                IF (SalesHeader."GMAShipment or Invoice" <> 'REMITO -') THEN
                    ValidateFechaCbteVenta(SalesHeader."Posting Date", SalesHeader."GMAElectronic Invoicing");

                lclCustomer.GET(SalesHeader."Sell-to Customer No.");
                if lclCustomer."GMAAFIP Document Type" <> '' then begin
                    if lclTipoDocAFIP.GET(lclCustomer."GMAAFIP Document Type") then begin
                        if lclTipoDocAFIP."GMAAFIP Code" = '' then
                            ERROR('Especifique %1 para Tipo Documento AFIP %2.',
                                  lclTipoDocAFIP.FIELDNAME("GMAAFIP Code"), lclTipoDocAFIP.GMACodigo);
                    end;
                end
                else
                    ERROR('Por favor, informe %1 en %2', lclCustomer.FIELDNAME("GMAAFIP Document Type"), SalesHeader."Sell-to Customer No.");

            end;
        end
        else begin
            IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) AND (recCompanyInformation."GMAAct. Electronic Invoice" = false) then begin
                SalesHeader.validate("GMAPoint of Sales");

                SalesHeader.TestField("GMAAFIP Invoice Voucher Type");
                SalesHeader.TestField("GMAPoint of Sales");
                SalesHeader.TestField("Tax Area Code");
                if SalesHeader."Document Type" = "Sales Document Type"::Invoice then
                    SalesHeader.TestField("Posting No.");
                SalesHeader.TestField("GMAProvince");
                SalesHeader.TestField("VAT Registration No.");
                SalesHeader.TestField("GMAFiscal Type");

                RecLine.RESET;
                RecLine.SETRANGE(RecLine."Document No.", SalesHeader."No.");
                IF (RecLine.FindFirst()) THEN begin
                    RecLine.TestField("Gen. Bus. Posting Group");
                    RecLine.TestField("Gen. Prod. Posting Group");
                    RecLine.TestField("VAT Bus. Posting Group");
                    RecLine.TestField("VAT Prod. Posting Group");
                    RecLine.TestField("Tax Group Code");
                end
            end;
        end;
    end;

    [EventSubscriber(objecttype::Codeunit, 90, 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure GMAOnBeforePostPurchaseDoc(VAR PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        recCompanyInformation: Record "Company Information";
        RecLine: Record "Purchase Line";
        cuArg: codeunit GMAArgentina2;
    begin
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) then begin
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
                cuarg.ControlCodComportamiento(PurchaseHeader);
            if (PurchaseHeader."GMAAFIP Invoice Voucher Type" = '') or (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order) then begin
                purchaseheader.TestField("GMAAFIP Invoice Voucher Type");
                purchaseheader.TestField("Tax Area Code");
                purchaseheader.TestField("GMAFiscal Type");
                purchaseheader.TestField("GMAAFIP Document Type");
                purchaseheader.TestField("GMAProvince");
                purchaseheader.TestField("VAT Registration No.");
                purchaseheader.TestField("GMAWithholding Code");

                RecLine.RESET;
                RecLine.SETRANGE(RecLine."Document No.", purchaseheader."No.");
                IF (RecLine.FindFirst()) THEN begin
                    RecLine.TestField("Gen. Bus. Posting Group");
                    RecLine.TestField("Gen. Prod. Posting Group");
                    RecLine.TestField("VAT Bus. Posting Group");
                    RecLine.TestField("VAT Prod. Posting Group");
                    RecLine.TestField("Tax Group Code");
                    RecLine.TestField("GMAWithholding Code");
                end;
            end;
        end;
    end;

    PROCEDURE ValidateFechaCbteVenta(pFechaComprobante: Date; "GMAElectronic Invoicing": Option "No","FE","FEX","HASAR");
    VAR
        recCompanyInformation: Record "Company Information";

        SalesSetup: Record 311;
        lclDiasPrev: Integer;
        lclDiasPost: Integer;
        Err03: Label 'La fecha de publicación del documento no está permitida. Compruebe la configuración de Ventas y cuentas por cobrar. ';
    BEGIN
        recCompanyInformation.get;
        IF (recCompanyInformation."GMAOption Company" = recCompanyInformation."GMAOption Company"::Argentina) AND (recCompanyInformation."GMAAct. Electronic Invoice") then begin
            IF ("GMAElectronic Invoicing" = "GMAElectronic Invoicing"::FE) OR ("GMAElectronic Invoicing" = "GMAElectronic Invoicing"::FEX) THEN BEGIN
                SalesSetup.GET;
                lclDiasPrev := SalesSetup."GMAAuth Previous Days";
                lclDiasPost := SalesSetup."GMAAuthorization Next Days";

                IF pFechaComprobante <> TODAY THEN
                    IF pFechaComprobante < TODAY THEN BEGIN
                        IF ((TODAY - pFechaComprobante) > lclDiasPrev) THEN BEGIN
                            ERROR(Err03);
                        END;
                    END ELSE BEGIN
                        IF ((pFechaComprobante - TODAY) > lclDiasPost) THEN BEGIN
                            ERROR(Err03);
                        END;
                    END;
            END;
        END;
    end;
    // Validacion mandatory--

    // Actualizacion gen ledger setup dimension--
    [EventSubscriber(ObjectType::Table, 98, 'OnAfterUpdateDimValueGlobalDimNo', '', false, false)]
    local procedure OnAfterUpdateDimValueGlobalDimNo(ShortCutDimNo: Integer; OldDimensionCode: Code[20]; NewDimensionCode: Code[20])
    var
        genledgersetup: Record 98;
        entityextend: Record 34006903;
    begin
        genledgersetup.FindFirst();

        if entityextend.FindSet() then begin
            repeat
                entityextend.Asset := genledgersetup."Shortcut Dimension 2 Code";
                entityextend.Department := genledgersetup."Shortcut Dimension 3 Code";
                entityextend.Intercompany := genledgersetup."Shortcut Dimension 4 Code";
                entityextend.Modify();
            until entityextend.Next() = 0;
        end;
    end;
    // Actualizacion gen ledger setup dimension--

    //Ajuste por tipo de cambio ajuste que mando dylan

    var
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        BssiMEMSystemSetup: Record BssiMEMSystemSetup;
    // Note : These events have been extracted from a codeunit with integration events relevant to other areas and will need to be added to a codeunit to function

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnAdjustCurrencyOnAfterSetBankAccountFilters, '', false, false)]
    local procedure BssiOnAdjustCurrencyOnAfterSetBankAccountFilters(var BankAccount: Record "Bank Account")
    begin
        if (BssiMEMSystemSetup.BssiIsBankAccountSecurityEnabled()) then
            BssiMEMSecurityHelper.Bssi_GetBankFilterBasedonEntityFilter(BankAccount, BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnAdjustCurrencyOnAfterSetBankAccountFiltersInLoop, '', false, false)]
    local procedure BssiOnAdjustCurrencyOnAfterSetBankAccountFiltersInLoop(var BankAccount: Record "Bank Account")
    begin
        if (BssiMEMSystemSetup.BssiIsBankAccountSecurityEnabled()) then
            BssiMEMSecurityHelper.Bssi_GetBankFilterBasedonEntityFilter(BankAccount, BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnProcessBankAccountOnAfterCalcFields, '', false, false)]
    local procedure BssiOnProcessBankAccountOnAfterCalcFields(var BankAccount: Record "Bank Account"; Currency: Record Currency)
    begin

        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            BankAccount.SetFilter("Global Dimension 1 Filter", BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity())
        else
            BankAccount.SetFilter("Global Dimension 2 Filter", BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity());
        BankAccount.CalcFields("Balance at Date", "Balance at Date (LCY)");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnBeforePrepareTempCustLedgEntry, '', false, false)]
    local procedure BssiOnBeforePrepareTempCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary; Customer: Record Customer; var IsHandled: Boolean)
    var
        MEMDisabled: Boolean;
        BssiMEMEntityCustomer: record BssiMEMEntityCustomer;
    begin
        if BssiMEMSystemSetup.BssiIsCustomerSecurityEnabled() then
            if not BssiMEMSecurityHelper.BssiCheckCustomerBasedOnEntityFilter(Customer, BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity()) then begin
                TempCustLedgerEntry.DeleteAll();
                IsHandled := true //skip if no access to customer
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnPrepareTempCustLedgEntryOnAfterSetCustLedgerEntryFilters, '', false, false)]
    local procedure BssiOnPrepareTempCustLedgEntryOnAfterSetCustLedgerEntryFilters(var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        FilterString: Text;
    begin
        FilterString := BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity();

        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            CustLedgerEntry.SetFilter("Global Dimension 1 Code", FilterString)
        else
            CustLedgerEntry.SetFilter("Global Dimension 2 Code", FilterString);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnPrepareTempCustLedgEntryOnAfterSetDtldCustLedgerEntryFilters, '', false, false)]
    local procedure BssiOnPrepareTempCustLedgEntryOnAfterSetDtldCustLedgerEntryFilters(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        FilterString: Text;
    begin
        FilterString := BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity();

        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            DetailedCustLedgEntry.SetFilter("Initial Entry Global Dim. 1", FilterString)
        else
            DetailedCustLedgEntry.SetFilter("Initial Entry Global Dim. 2", FilterString);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnBeforePrepareTempVendLedgEntry, '', false, false)]
    local procedure BssiOnBeforePrepareTempVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; Vendor: Record Vendor; var IsHandled: Boolean)
    var
        MEMDisabled: Boolean;
        BssiMEMEntityCustomer: record BssiMEMEntityCustomer;
    begin
        if BssiMEMSystemSetup.BssiIsVendorSecurityEnabled() then
            if not BssiMEMSecurityHelper.BssiCheckVendorBasedOnEntityFilter(Vendor, BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity()) then begin
                TempVendorLedgerEntry.DeleteAll();
                IsHandled := true; //skip if no access to vendor
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnPrepareTempVendLedgEntryOnAfterSetVendLedgerEntryFilters, '', false, false)]
    local procedure BssiOnPrepareTempVendLedgEntryOnAfterSetVendLedgerEntryFilters(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var

        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        FilterString: Text;
    begin

        FilterString := BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity();

        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            VendorLedgerEntry.SetFilter("Global Dimension 1 Code", FilterString)
        else
            VendorLedgerEntry.SetFilter("Global Dimension 2 Code", FilterString);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnPrepareTempVendLedgEntryOnAfterSetDtldVendLedgerEntryFilters, '', false, false)]
    local procedure BssiOnPrepareTempVendLedgEntryOnAfterSetDtldVendLedgerEntryFilters(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        FilterString: Text;
    begin

        FilterString := BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity();

        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            DetailedVendorLedgEntry.SetFilter("Initial Entry Global Dim. 1", FilterString)
        else
            DetailedVendorLedgEntry.SetFilter("Initial Entry Global Dim. 2", FilterString);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnAfterInitVariablesForSetLedgEntry, '', false, false)]
    local procedure BssiOnAfterInitVariablesForSetLedgEntry(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters"; GenJournalLine: Record "Gen. Journal Line")
    begin

        case ExchRateAdjmtParameters."Dimension Posting" of
            "Exch. Rate Adjmt. Dimensions"::"No Dimensions":
                ExchRateAdjmtParameters."Dimension Posting" := ExchRateAdjmtParameters."Dimension Posting"::"Bssi No Dimensions";
            "Exch. Rate Adjmt. Dimensions"::"G/L Account Dimensions":
                ExchRateAdjmtParameters."Dimension Posting" := ExchRateAdjmtParameters."Dimension Posting"::"Bssi G/L Account Dimensions";
            "Exch. Rate Adjmt. Dimensions"::"Source Entry Dimensions":
                ExchRateAdjmtParameters."Dimension Posting" := ExchRateAdjmtParameters."Dimension Posting"::"Bssi Source Entry Dimensions";
        end;
        BssiMEMSingleInstanceCU.BssiSetBssiMEMDimensionPosting(ExchRateAdjmtParameters."Dimension Posting");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnSetPostingDimensionsElseCase, '', false, false)]
    local procedure BssiOnSetPostingDimensionsElseCase(var GenJournalLine: Record "Gen. Journal Line"; var DimensionSetEntry: Record "Dimension Set Entry")
    var
        DimensionPosting: Enum "Exch. Rate Adjmt. Dimensions";
        BssiMEMExchRateAdjmtProcess: Codeunit PERExchRateAdjmtProcess;
    begin


        DimensionPosting := BssiMEMSingleInstanceCU.BssiGetBssiMEMDimensionPosting();
        BssiMEMExchRateAdjmtProcess.BssiSetPostingDimensions(DimensionPosting, GenJournalLine, DimensionSetEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnBeforeAdjustGLAccountsAndVATEntries, '', false, false)]
    local procedure BssiOnBeforeAdjustGLAccountsAndVATEntries(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters"; var Currency: Record Currency; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        BssiMEMExchRateAdjmtProcess: Codeunit PERExchRateAdjmtProcess;
    begin

        BssiMEMExchRateAdjmtProcess.Run(ExchRateAdjmtParameters);
        ExchRateAdjmtParameters."Adjust G/L Accounts" := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PERExch. Rate Adjmt. Process", OnAfterRunAdjustment, '', false, false)]
    local procedure BssiOnAfterRunAdjustment(var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters" temporary)
    begin


        if BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjHideUI() then
            ExchRateAdjmtParameters."Hide UI" := true;
        BssiMEMSingleInstanceCU.BssiSetExchangeRateAdjEntity('');
    end;

    //Ajuste por tipo de cambio ajuste que mando dylan

}