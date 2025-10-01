report 34006888 "PERARBA Perception"
{
    Caption = 'ARBA Percepciones Percibidas';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = "Reportsandanalysis";

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = SORTING("Entry No.");
            trigger OnAfterGetRecord();
            begin
                IF "VAT Entry"."GMATax Type Loc" = "VAT Entry"."GMATax Type Loc"::"Ingresos Brutos" THEN
                    IF NOT (EXIST) then
                        "#VatEntry3"
            end;

            trigger OnPreDataItem();
            begin
                FiltroJur := 'IIBB-BA*';
                if UseDocumentDate then
                    "VAT Entry".SETRANGE("Document Date", FechaDesde, FechaHasta)
                else
                    "VAT Entry".SETRANGE("Posting Date", FechaDesde, FechaHasta);

                "VAT Entry".SETFILTER("Document Type", '%1|%2', "Document Type"::Invoice, "Document Type"::"Credit Memo");
                "VAT Entry".SETRANGE("VAT Entry".Type, "VAT Entry".Type::Sale);
                "VAT Entry".SETFILTER("VAT Entry"."Tax Jurisdiction Code", FiltroJur);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GMAOptions)
                {
                    Caption = 'Options';
                    field(FechaDesde; FechaDesde)
                    {
                        Caption = 'From Date';
                        ApplicationArea = ALL;
                    }
                    field(FechaHasta; FechaHasta)
                    {
                        Caption = 'To Date';
                        ApplicationArea = ALL;
                    }
                    field(UseDocumentDate; UseDocumentDate)
                    {
                        Caption = 'Use Document Date';
                        ApplicationArea = ALL;
                        ToolTip = 'If enabled, filters by Document Date; otherwise, filters by Posting Date.';
                    }
                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = ALL;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        ToolTip = 'Select the Entity to restrict the report.';
                        Importance = Promoted;

                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
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
                }
            }
        }
        trigger OnOpenPage()
        var
        begin
            BssiMEMSingleInstanceCU.Bssi_SetCurrentHeaderEntity('');
            BssiMEMSingleInstanceCU.Bssi_SetCurrentEntity('');
            BssiMEMSystemSetup.Get();

            if BssiDimension <> '' then
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension)
            else
                BssiDimensionForRestriction := BssiMEMSecurityHelper.Bssi_tGetUserSecurityFilterText();
        end;
    }

    var
        EXIST: Boolean;
        FechaDesde: Date;
        FechaHasta: Date;
        Texto: Text[1024];
        Campo1: Text[13];
        Campo2: Text[10];
        Campo3: Text[1];
        Campo4: Text[1];
        Campo5: Text[4];
        Campo6: Text[8];
        Campo7: Text[14];
        CAMPO8: Text[13];
        CAMPO9: Text[1];
        Text005: Label 'Error de CUIT Cliente %1';
        Text006: Label 'El CUIT supera 13 Caracteres.';
        auxvatentry: Record "VAT Entry";
        importesumado: Decimal;
        RecCustomer: Record Customer;
        importesumado2: Decimal;
        aux2: Integer;
        DocNum: Text[30];
        tempvatentry: Record "VAT Entry" temporary;
        aux: Integer;
        FiltroJur: Code[20];
        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        CR: char;
        FL: Char;
        GlobalDataCompression: Codeunit "Data Compression";
        UseDocumentDate: Boolean;

    procedure "#VatEntry3"();
    var
    begin
        ExportVatEntriesAsZip();
    end;

    procedure ExportVatEntriesAsZip()
    var
        TempBlob: Codeunit "Temp Blob";
        DataCompression: Codeunit "Data Compression";
        VATentryLocal: Record "VAT Entry";
        DimensionValue: Record "Dimension value";
        InS: InStream;
        OutS: OutStream;
        ZipFileName: Text[1024];
        infEmpresa: Record "Company Information";
        cuit: Text;
        periodo: Text;
        lote: Text;
        FileName: Text[1024];
        LONGTEXT: BigText;
        dia: Integer;
    begin
        EXIST := true;
        // Obtener información de la empresa
        infEmpresa.Get();
        cuit := DELCHR(infEmpresa."VAT Registration No.", '=', '-');
        periodo := FORMAT(FechaDesde, 0, '<Year4>') + FORMAT(FechaDesde, 0, '<Month,2>');
        lote := FORMAT(FechaDesde, 0, '<Year4>') + '-' + FORMAT(FechaDesde, 0, '<Month,2>');
        Evaluate(dia, FORMAT(FechaHasta, 0, '<Day,2>'));

        // Generar nombre del archivo ZIP
        ZipFileName := 'AR-' + cuit + '-' + periodo + '0-P7-' + lote + '.zip';
        createzip();

        //itero por dimension
        DimensionValue.Reset();
        DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        DimensionValue.SetFilter(code, BssiDimension);
        if DimensionValue.FindFirst() then
            repeat
                FiltroJur := 'IIBB-BA*';
                VATentryLocal.Reset();
                VATentryLocal.SETRANGE("Posting Date", FechaDesde, FechaHasta);
                VATentryLocal.SETFILTER("Document Type", '%1|%2', VATentryLocal."Document Type"::Invoice, VATentryLocal."Document Type"::"Credit Memo");
                VATentryLocal.SETRANGE(VATentryLocal.Type, VATentryLocal.Type::Sale);
                VATentryLocal.SETFILTER(VATentryLocal."Tax Jurisdiction Code", FiltroJur);

                if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                    VATentryLocal.SETRANGE("Bssi Shortcut Dimension 1 Code", DimensionValue.Code)
                else
                    VATentryLocal.SETRANGE("Bssi Shortcut Dimension 2 Code", DimensionValue.Code);

                if VATentryLocal.FindFirst() then begin
                    // Generar un nombre único para cada archivo dentro del zip
                    FileName := 'AR-' + DimensionValue.Code + '-' + cuit + '-' + periodo + '0-' +
                            VATentryLocal."Document No." + '-' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) +
                            FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;')) + '.txt';

                    Clear(LONGTEXT);
                    repeat
                        // Crear el contenido del archivo
                        Campo1 := '';
                        Campo2 := '';
                        Campo3 := '';
                        Campo4 := '';
                        Campo5 := '';
                        Campo6 := '';
                        Campo7 := '';
                        CAMPO8 := '';
                        CAMPO9 := '';

                        tempvatentry.RESET();
                        tempvatentry.SETRANGE(tempvatentry."Document No.", VATentryLocal."Document No.");
                        IF (tempvatentry.FINDFIRST) THEN
                            CurrReport.SKIP
                        ELSE BEGIN
                            tempvatentry.INIT;
                            aux += 1;
                            tempvatentry."Entry No." := aux;
                            tempvatentry."Document No." := VATentryLocal."Document No.";
                            tempvatentry."Tax Jurisdiction Code" := VATentryLocal."Tax Jurisdiction Code";
                            tempvatentry.INSERT;
                        END;
                        // cuit
                        RecCustomer.RESET;
                        RecCustomer.SETCURRENTKEY("No.");
                        RecCustomer.SETRANGE("No.", VATentryLocal."Bill-to/Pay-to No.");
                        IF RecCustomer.FINDFIRST THEN BEGIN

                            IF (STRLEN(RecCustomer."VAT Registration No.") > 13) THEN
                                ERROR(Text006);

                            IF (RecCustomer."VAT Registration No." = '') THEN
                                ERROR(Text005, RecCustomer."No.");

                            Campo1 := RecCustomer."VAT Registration No.";

                            campo1 := DELCHR(Campo1, '=', '-');

                            if campo1 <> '' then
                                campo1 := INSSTR((INSSTR(campo1, '-', 3)), '-', 12);
                        END;
                        // Fecha de retención (DD/MM/YYYY).
                        // JCG Segun la fecha elegida cambia el campo
                        if UseDocumentDate then
                            Campo2 := FORMAT(VATentryLocal."Document Date", 10, '<Day,2>/<Month,2>/<Year4>')
                        else
                            Campo2 := FORMAT(VATentryLocal."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');
                        // JCG Segun la fecha elegida cambia el campo

                        IF (VATentryLocal."GMADocument Type Loc." = VATentryLocal."GMADocument Type Loc."::Invoice) THEN
                            Campo3 := 'F';
                        IF (VATentryLocal."GMADocument Type Loc." = VATentryLocal."GMADocument Type Loc."::"Credit Memo") THEN
                            Campo3 := 'C';
                        IF (VATentryLocal."GMADocument Type Loc." = VATentryLocal."GMADocument Type Loc."::"GMANota Debito") THEN
                            Campo3 := 'D';

                        // Letra de comprobante
                        Campo4 := 'A';

                        // Numero sucursal        
                        IF (STRLEN(VATentryLocal."Document No.") > 10) THEN
                            Campo5 := '000' + (COPYSTR(VATentryLocal."Document No.", STRLEN(VATentryLocal."Document No.") - 9, 1))
                        ELSE
                            Campo5 := '0000';

                        CLEAR(DocNum);
                        DocNum := VATentryLocal."Document No.";
                        DocNum := DELCHR(DocNum, '=', '.,;_/ \+-ZXCVBNMASFGHJKLQWERTYUIOP');

                        IF STRLEN(DocNum) > 8 THEN BEGIN
                            DocNum := COPYSTR(DocNum, STRLEN(DocNum) - 7, 8);
                            Campo6 := DocNum;
                        END ELSE BEGIN

                            WHILE STRLEN(Campo6) + STRLEN(DocNum) < 8 DO
                                Campo6 += '0';
                            Campo6 += (DocNum);
                        END;

                        CLEAR(importesumado);
                        CLEAR(importesumado2);
                        CLEAR(aux2);
                        auxvatentry.RESET;
                        auxvatentry.SETRANGE(auxvatentry."Document No.", VATentryLocal."Document No.");
                        auxvatentry.SETRANGE(auxvatentry."GMATax Type Loc", auxvatentry."GMATax Type Loc"::"Ingresos Brutos");
                        auxvatentry.SETFILTER("Tax Jurisdiction Code", FiltroJur);
                        IF (auxvatentry.FINDSET) THEN
                            REPEAT
                                importesumado := importesumado + auxvatentry.Amount;
                                importesumado2 := importesumado2 + auxvatentry.Base;
                                aux2 += 1;
                            UNTIL auxvatentry.NEXT = 0;
                        //DDS Se comento ya que sumaria base de distintas lineas de IIBB y cuando se divide sacaria mal la base. Revisar con ejemplos
                        //IF (aux2 > 0) THEN
                        //    importesumado2 := importesumado2 / aux2;

                        WHILE STRLEN(Campo7) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado2, 0.01), 0,
                        '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 DO Campo7 += '0';
                        BEGIN
                            Campo7 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado2, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                        END;

                        WHILE STRLEN(CAMPO8) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                        '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 DO CAMPO8 += '0';
                        BEGIN
                            CAMPO8 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                        END;

                        IF (Campo3 = 'C') THEN BEGIN
                            Campo7 := '-' + COPYSTR(Campo7, 2, 11);
                            CAMPO8 := '-' + COPYSTR(CAMPO8, 2, 10);
                        END;
                        CAMPO9 := 'A';
                        CR := 13;
                        FL := 10;
                        CLEAR(Texto);
                        Texto := (
                          FORMAT(Campo1, 13, '<Text>') +
                          FORMAT(Campo2, 10, '<Text>') +
                          FORMAT(Campo3, 1, '<Text>') +
                          FORMAT(Campo4, 1, '<Text>') +
                          FORMAT(Campo5, 4, '<Text>') +
                          FORMAT(Campo6, 8, '<Text>') +
                          FORMAT(Campo7, 12, '<Text>') +
                          FORMAT(CAMPO8, 11, '<Text>') +
                          FORMAT(CAMPO9, 1, '<Text>'));

                        LONGTEXT.AddText(Texto);
                        LONGTEXT.AddText(FORMAT(CR) + FORMAT(FL));

                    until VATentryLocal.Next() = 0;
                    addbigtext(LONGTEXT, FileName);
                end;
            until DimensionValue.Next() = 0;
        addzip(ZipFileName);
    end;

    procedure addbigtext(LoctextBlob: BigText; FileName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
    begin
        // Escribir contenido en el TempBlob
        TempBlob.CreateOutStream(OutS);
        LoctextBlob.Write(OutS);

        // Leer desde el TempBlob para añadir al zip
        TempBlob.CreateInStream(InS);
        GlobalDataCompression.AddEntry(InS, FileName);

        Clear(TempBlob);
    end;

    procedure addzip(ZipFileName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
    begin
        // Guardar el archivo ZIP con el nombre generado
        TempBlob.CreateOutStream(OutS);
        GlobalDataCompression.SaveZipArchive(OutS);
        TempBlob.CreateInStream(InS);
        DownloadFromStream(InS, '', '', '', ZipFileName);
    end;

    procedure createzip()
    var
    begin
        GlobalDataCompression.CreateZipArchive();
    end;
}