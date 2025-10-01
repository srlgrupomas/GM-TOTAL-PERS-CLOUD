report 34006905 "PERS SUSS"
{
    caption = 'SIRE - SUSS';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
            dataitem("GMAWithholding Ledger Entry"; "GMAWithholding Ledger Entry")
            {
                DataItemTableView = SORTING("GMANo.") ORDER(Ascending) WHERE("GMAWithholding Type" = FILTER(Realizada));

                trigger OnPreDataItem()
                begin
                    IF (fechaposting) Then
                        "GMAWithholding Ledger Entry".SetRange("GMAWithholding Ledger Entry"."GMAWithholding Date", FechaDesde, FechaHasta)
                    else
                        "GMAWithholding Ledger Entry".SetRange("GMAWithholding Ledger Entry".GMADocumentDate, FechaDesde, FechaHasta);
                    "GMAWithholding Ledger Entry".SetFilter("GMAWithholding Ledger Entry"."GMAShortcut Dimension 1", BssiDimension);
                    "GMAWithholding Ledger Entry".SetFilter("GMAWithholding Ledger Entry"."GMATax Code", '%1', '*SUSS*');

                    // JCG Segun la fecha elegida cambia el campo
                    "GMAWithholding Ledger Entry".CalcFields(GMADocumentDate);
                end;

                trigger OnAfterGetRecord()
                var
                    CompPago: Record "GMAPosted Payment Ord Vouch";
                    PIH: Record "Purch. Inv. Header";
                    PICM: Record "Purch. Cr. Memo Hdr.";
                    vatentry: record "VAT Entry";
                    "GMAPosted Payment Order Valu": Record "GMAPosted Payment Order Valu";
                    "Hist Cab OPago": Record "GMAPosted Payment Order";
                begin
                    Campo1 := '';
                    Campo2 := '';
                    Campo3 := '';
                    Campo4 := '';
                    Campo5 := '';
                    Campo6 := '';
                    Campo7 := '';
                    Campo8 := '';
                    Campo9 := '';
                    Campo10 := '';
                    Campo11 := '';
                    Campo12 := '';
                    Campo13 := '';
                    Campo14 := '';
                    Campo15 := '';
                    Campo16 := '';
                    Campo17 := '';

                    EscribirFichero := TRUE;
                    NumeroLineas += 1;

                    //Formulario (fijo)
                    Campo1 := '2004';

                    //Version (fijo)
                    Campo2 := '0100';

                    //Código de Trazabilidad (Uso no Fiscal) (vacio)
                    Campo3 := '          ';

                    InfoEmpresa.Reset();
                    InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    InfoEmpresa.SetFilter(Code, BssiDimension);
                    IF (InfoEmpresa.FindFirst()) THEN;

                    //CUIT AGENTE
                    Campo4 := delchr(InfoEmpresa.BssiTaxRegistrationNumber, '=', '-');

                    //Impuesto (fijo)
                    Campo5 := '353';

                    //Regimen
                    Campo6 := CompletarEspaciosADerecha(COPYSTR("GMAWithholding Ledger Entry"."GMATax System", 1, 3), 3);

                    //CUIT RETENIDO
                    Proveedor.RESET;
                    Proveedor.SETRANGE(Proveedor."No.", "GMAWithholding Ledger Entry"."GMAVendor Code");
                    IF Proveedor.FINDFIRST THEN BEGIN
                        IF Proveedor."VAT Registration No." <> '' THEN BEGIN
                            IF STRLEN(Proveedor."VAT Registration No.") > 13 THEN BEGIN
                                Campo7 := COPYSTR(DELCHR(FORMAT(Proveedor."VAT Registration No."), '=', '-.'), 1, 13);
                            END
                            ELSE BEGIN
                                Campo7 := DELCHR(Proveedor."VAT Registration No.", '=', '-.');
                            END;
                        END
                        else begin
                            CompPago.reset();
                            CompPago.SetRange(CompPago."GMAPayment Order No.", "GMAWithholding Ledger Entry"."GMAVoucher Number");
                            if CompPago.findfirst() then
                                repeat
                                    IF (PIH.GET(CompPago."GMAVoucher No.") and (PIH."VAT Registration No." <> '')) THEN begin
                                        IF STRLEN(PIH."VAT Registration No.") > 13 THEN
                                            Campo7 := COPYSTR(DELCHR(FORMAT(PIH."VAT Registration No."), '=', '-.'), 1, 13)
                                        else
                                            Campo7 := DELCHR(PIH."VAT Registration No.", '=', '-.');
                                    end
                                    else begin
                                        IF (PICM.GET(CompPago."GMAVoucher No.") and (PICM."VAT Registration No." <> '')) THEN begin
                                            IF STRLEN(PICM."VAT Registration No.") > 13 THEN
                                                Campo7 := COPYSTR(DELCHR(FORMAT(PICM."VAT Registration No."), '=', '-.'), 1, 13)
                                            else
                                                Campo7 := DELCHR(PICM."VAT Registration No.", '=', '-.');
                                        end;
                                    end;
                                until (CompPago.Next() = 0) OR (Campo7 <> '');
                        end;
                    end
                    else
                        campo7 := "GMAWithholding Ledger Entry"."GMAVendor Code";

                    "GMAWithholding Ledger Entry".CalcFields(GMADocumentDate);

                    //Fecha retencion
                    // JCG Se solicita mostrar solo la Document date
                    // if fechaposting = true then
                    //     Campo8 := FORMAT("GMAWithholding Ledger Entry"."GMAWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>')
                    // else
                    Campo8 := FORMAT("GMAWithholding Ledger Entry".GMADocumentDate, 10, '<Day,2>/<Month,2>/<Year4>');

                    //Tipo de comprobante
                    Campo9 := '06';

                    //Fecha de comprobante
                    // JCG Se solicita mostrar solo la Document date
                    Campo10 := FORMAT("GMAWithholding Ledger Entry"."GMADocumentDate", 10, '<Day,2>/<Month,2>/<Year4>');

                    //Numero de comprobante
                    campo11 := CompletarEspaciosADerecha(GetLastNCharacters(DelChr("GMAWithholding Ledger Entry"."GMAVoucher Number", '=', '-+'), 12), 16);

                    //Importe de comprobante
                    if format("GMAWithholding Ledger Entry"."GMAVoucher Amount").Contains('-') then
                        campo12 := '-' + CompletarCerosAIzquierda(DelChr(format("GMAWithholding Ledger Entry"."GMAVoucher Amount"), '=', '-'), 13)
                    else
                        campo12 := CompletarCerosAIzquierda(format("GMAWithholding Ledger Entry"."GMAVoucher Amount"), 14);

                    //Importe de retencion
                    if format("GMAWithholding Ledger Entry"."GMAWithholding Amount").Contains('-') then
                        campo13 := '-' + CompletarCerosAIzquierda(DelChr(format("GMAWithholding Ledger Entry"."GMAWithholding Amount"), '=', '-'), 13)
                    else
                        campo13 := CompletarCerosAIzquierda(format("GMAWithholding Ledger Entry"."GMAWithholding Amount"), 14);

                    //certificado original numero
                    Campo14 := '                         ';

                    //certificado original fecha retencion
                    Campo15 := '          ';

                    //cerificado original importe
                    Campo16 := FORMAT('              ');

                    //otros datos
                    Campo17 := '                              ';

                    CLEAR(Texto);
                    Texto := (
                    FORMAT(Campo1) +
                    FORMAT(Campo2) +
                    FORMAT(Campo3) +
                    FORMAT(Campo4) +
                    FORMAT(Campo5) +
                    FORMAT(Campo6) +
                    FORMAT(Campo7) +
                    FORMAT(Campo8) +
                    FORMAT(Campo9) +
                    FORMAT(Campo10) +
                    FORMAT(Campo11) +
                    FORMAT(Campo12) +
                    FORMAT(Campo13) +
                    FORMAT(Campo14) +
                    FORMAT(Campo15) +
                    FORMAT(Campo16) +
                    FORMAT(Campo17));
                    "#RellenaExcelBuff"(Texto)
                end;

            }
            dataitem("VAT Entry"; "VAT Entry")
            {
                DataItemTableView = SORTING("Document No.") ORDER(Ascending) WHERE(type = FILTER("Sale"));

                trigger OnPreDataItem()
                var

                begin

                    "VAT Entry".SetFilter("Posting Date", '%1..%2', FechaDesde, FechaHasta);
                    "VAT Entry".SetRange(Type, type::Sale);
                    "VAT Entry".SetRange("Document Type", "Document Type"::Invoice);
                    "VAT Entry".SetFilter("VAT Entry"."Tax Jurisdiction Code", '%1', 'SUSS');

                end;

                trigger OnAfterGetRecord()
                var
                    recTaxJurisdictions: Record "Tax Jurisdiction";
                    recCliente: Record Customer;
                    recFacturaAplicada: Record "Sales Invoice Header";
                    recDetCustLE: Record "Detailed Cust. Ledg. Entry";
                    recCLE: Record "Cust. Ledger Entry";
                begin
                    Campo1 := '';
                    Campo2 := '';
                    Campo3 := '';
                    Campo4 := '';
                    Campo5 := '';
                    Campo6 := '';
                    Campo7 := '';
                    Campo8 := '';
                    Campo9 := '';
                    Campo10 := '';
                    Campo11 := '';
                    Campo12 := '';
                    Campo13 := '';
                    Campo14 := '';
                    Campo15 := '';
                    Campo16 := '';
                    Campo17 := '';

                    EscribirFichero := TRUE;
                    NumeroLineas += 1;

                    //Formulario (fijo)
                    Campo1 := '2004';

                    //Version (fijo)
                    Campo2 := '0100';

                    //Código de Trazabilidad (Uso no Fiscal) (vacio)
                    Campo3 := '          ';

                    InfoEmpresa.Reset();
                    InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    InfoEmpresa.SetFilter(Code, BssiDimension);
                    IF (InfoEmpresa.FindFirst()) THEN;

                    //CUIT AGENTE
                    Campo4 := delchr(InfoEmpresa.BssiTaxRegistrationNumber, '=', '-');

                    //Impuesto (fijo)
                    Campo5 := '353';

                    //Regimen
                    recTaxJurisdictions.Reset();
                    recTaxJurisdictions.SetRange(recTaxJurisdictions.Code, "VAT Entry"."Tax Jurisdiction Code");
                    if recTaxJurisdictions.FindFirst() then
                        Campo6 := CompletarEspaciosADerecha(COPYSTR(recTaxJurisdictions."GMAARBA Code", 1, 3), 3);

                    //CUIT PERCEPCION
                    recCliente.RESET;
                    recCliente.SETRANGE(recCliente."No.", "VAT Entry"."Bill-to/Pay-to No.");
                    IF recCliente.FINDFIRST THEN BEGIN
                        IF recCliente."VAT Registration No." <> '' THEN BEGIN
                            IF STRLEN(recCliente."VAT Registration No.") > 13 THEN BEGIN
                                Campo7 := DELCHR(COPYSTR(FORMAT(recCliente."VAT Registration No."), 1, 13), '=', '-');
                            END
                            ELSE BEGIN
                                Campo7 := DELCHR(recCliente."VAT Registration No.", '=', '-');
                            END;
                        END
                        ELSE
                            Campo7 := recCliente."No."
                    END;

                    //Fecha percepcion
                    // JCG Se solicita mostrar solo la Document date
                    Campo8 := FORMAT("VAT Entry"."Document Date", 10, '<Day,2>/<Month,2>/<Year4>');
                    // Campo8 := FORMAT("VAT Entry"."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

                    //Tipo de comprobante
                    case "VAT Entry"."GMADocument Type Loc." of
                        "VAT Entry"."GMADocument Type Loc."::Invoice:
                            campo9 := '01';
                        "VAT Entry"."GMADocument Type Loc."::"Credit Memo":
                            campo9 := '03';
                        "VAT Entry"."GMADocument Type Loc."::"GMANota Debito":
                            campo9 := '04';
                    end;

                    //Fecha de comprobante
                    Campo10 := FORMAT("VAT Entry"."Document Date", 10, '<Day,2>/<Month,2>/<Year4>');

                    //Numero de comprobante
                    campo11 := CompletarEspaciosADerecha(GetLastNCharacters(DelChr("VAT Entry"."Document No.", '=', '-+'), 12), 16);


                    //Importe de comprobante
                    campo12 := CompletarCerosAIzquierda(format(abs("VAT Entry".Base)), 14);

                    //Importe de percepcion
                    campo13 := CompletarCerosAIzquierda(format(abs("VAT Entry".Amount)), 14);


                    if "VAT Entry"."GMADocument Type Loc." = "VAT Entry"."GMADocument Type Loc."::"Credit Memo" then begin
                        recDetCustLE.Reset();
                        recDetCustLE.SetRange("Document No.", "VAT Entry"."Document No.");
                        recDetCustLE.SetFilter("Applied Cust. Ledger Entry No.", '<>0');
                        recDetCustLE.SetRange("Entry Type", recDetCustLE."Entry Type"::Application);
                        if recDetCustLE.FindFirst() then begin
                            recCLE.Reset();
                            recCLE.SetRange(recCLE."Entry No.", recDetCustLE."Cust. Ledger Entry No.");
                            recCLE.FindFirst();
                            //certificado original numero
                            Campo14 := CompletarEspaciosADerecha(recCLE."Document No.", 14);

                            //certificado original fecha percepcion
                            Campo15 := FORMAT(recDetCustLE."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

                            //cerificado original importe
                            campo16 := CompletarCerosAIzquierda(formaT(abs(recDetCustLE.Amount)), 14);
                        end
                        else begin
                            //certificado original numero
                            Campo14 := '                         ';

                            //certificado original fecha percepcion
                            Campo15 := '          ';

                            //cerificado original importe
                            Campo16 := FORMAT('              ');
                        end;

                    end
                    else begin

                        //certificado original numero
                        Campo14 := '                         ';

                        //certificado original fecha percepcion
                        Campo15 := '          ';

                        //cerificado original importe
                        Campo16 := FORMAT('              ');
                    end;
                    //otros datos
                    Campo17 := '                              ';

                    CLEAR(Texto);
                    Texto := (
               FORMAT(Campo1) +
               FORMAT(Campo2) +
               FORMAT(Campo3) +
               FORMAT(Campo4) +
               FORMAT(Campo5) +
               FORMAT(Campo6) +
               FORMAT(Campo7) +
               FORMAT(Campo8) +
               FORMAT(Campo9) +
               FORMAT(Campo10) +
               FORMAT(Campo11) +
               FORMAT(Campo12) +
               FORMAT(Campo13) +
               FORMAT(Campo14) +
               FORMAT(Campo15) +
               FORMAT(Campo16) +
               FORMAT(Campo17));
                    "#RellenaExcelBuff"(Texto)
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GMAOptions)
                {
                    Caption = 'Options';

                    field(FechaDesde; FechaDesde)
                    {
                        Caption = 'From date',;
                        ApplicationArea = All;
                    }

                    field(FechaHasta; FechaHasta)
                    {
                        caption = 'To date',;
                        ApplicationArea = all;
                    }

                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        Importance = Promoted;

                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            SecurityHelper: Codeunit BssiMEMSecurityHelper;
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            SecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;

                        trigger OnValidate()
                        var
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;
                    }
                    field(fechaposting; fechaposting)
                    {
                        Caption = 'Use Posting Date';
                        ApplicationArea = ALL;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CR := 13;
        FL := 10;
    end;

    trigger OnPostReport();
    begin
        if NumeroLineas = 0 then
            MESSAGE(Text004)
        else begin
            //La ultima linea debe ser vacia.
            CLEAR(Texto);
            Texto := '';
            NumeroLineas := NumeroLineas + 1;
            "#RellenaExcelBuff"(Texto);

            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuff);
            Xmlport.Run(34006396, false, false, TempExcelBuff);
        end;

    end;

    var
        XMLImporExport: XmlPort "GMAXML ImportExport";
        Campo1: Text[4];
        Campo2: Text[4];
        Campo3: Text[10];
        Campo4: Text[11];
        Campo5: Text[3];
        Campo6: Text[3];
        Campo7: Text[11];
        Campo8: Text[10];
        Campo9: Text[2];
        Campo10: Text[10];
        Campo10Bis: Text[1];
        CAmpo11aux: Text[16];
        Campo11: Text[16];
        Campo12: Text[14];
        Campo13: Text[14];
        Campo14: Text[25];
        Campo15: Text[10];
        Campo16: Text[14];
        Campo17: Text[32];
        FechaDesde: Date;
        FechaHasta: Date;
        Proveedor: Record 23;
        InfoEmpresa: Record "Dimension Value";
        Texto: Text[1024];
        NumeroLineas: Integer;
        EscribirFichero: Boolean;
        TempExcelBuff: Record 370 TEMPORARY;
        CR: Char;
        FL: Char;
        Text004: label 'There are no records to generate the report.',;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMDimensionsOneTwoVisible: Boolean;
        BssiMEMDefaultEntity: record BssiMEMDefaultEntity;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        fechaposting: Boolean;

    PROCEDURE "#RellenaExcelBuff"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuff.INIT;
        TempExcelBuff."Row No." := NumeroLineas;
        TempExcelBuff."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuff.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuff.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuff.INSERT;
    END;

    procedure CompletarCerosAIzquierda(texto: Text; Length: Integer) retorno: Text;
    var
        aux: Integer;
        parteEntera: Integer;
        parteDecimal: Decimal;
        cantDecimales: Integer;
        numeroOriginal: Decimal;
        strParteDecimal: Text;
    begin
        //la cantidad de decimales es la que falta especificar.
        cantDecimales := 2;
        Evaluate(numeroOriginal, texto);
        parteEntera := round(numeroOriginal, 1, '<');
        parteDecimal := numeroOriginal - parteEntera;
        if strlen(Format(parteDecimal)) > 1 then
            strParteDecimal := CopyStr(Format(parteDecimal), 3, 100)
        else
            strpartedecimal := '0';


        if strlen(strParteDecimal) < 2 then
            strParteDecimal := strParteDecimal + '0';

        texto := format(parteEntera) + ',' + CopyStr(strParteDecimal, 1, cantDecimales);


        aux := StrLen(copystr(texto, 1, StrLen(texto)));
        retorno := texto;
        while aux < Length do begin
            retorno := '0' + retorno;
            aux += 1;
        end;
    end;

    procedure CompletarEspaciosADerecha(texto: Text; Length: Integer) retorno: Text;
    var
        aux: Integer;
    begin
        texto := CopyStr(texto, 1, Length);
        aux := StrLen(copystr(texto, 1, StrLen(texto)));
        retorno := texto;
        while aux < Length do begin
            retorno += ' ';
            aux += 1;
        end;
    end;

    procedure GetLastNCharacters(texto: Text; N: Integer) retorno: Text;
    begin
        if StrLen(texto) <= N then
            retorno := texto
        else
            retorno := CopyStr(texto, StrLen(texto) - N + 1, N);
    end;
}
