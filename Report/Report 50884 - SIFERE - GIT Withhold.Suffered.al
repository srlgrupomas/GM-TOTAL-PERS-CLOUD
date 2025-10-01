report 34006884 "PERSIFERE - GIT With. Suff."
{
    Caption = 'SIFERE - GIT Withhold. Suffered';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("GMAValues Entry"; "GMAValues Entry")
        {
            DataItemTableView = SORTING("GMAEntry No.") ORDER(Ascending) WHERE("GMADocument Type" = FILTER(1));

            trigger OnPreDataItem()
            begin
                FechaDesde := DMY2DATE(1, Mes, Anio);
                EVALUATE(FechaHasta, FORMAT(CALCDATE('+1M', FechaDesde) - 1));
                if UseDocumentDate then
                    "GMAValues Entry".SETRANGE("GMADocument Date", FechaDesde, FechaHasta)
                else
                    "GMAValues Entry".SETRANGE("GMAPosting Date", FechaDesde, FechaHasta);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "GMAValues Entry".SetFilter("GMAGlobal Dimension 1", BssiDimension)
                    else
                        "GMAValues Entry".SetFilter("GMAGlobal Dimension 2", BssiDimension);
            end;

            trigger OnAfterGetRecord()
            begin
                IF recValor.GET("GMAValues Entry".GMAValue) THEN
                    IF (recValor."GMAIs Withholding") AND (recValor."GMAIs GGII") THEN BEGIN
                        EscribirFichero := TRUE;
                        NumeroLineas += 1;
                        IF NOT (EXIST) then
                            "#MovValores";
                    END;
            end;
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
                    caption = 'Options',;
                    field(Anio; Anio)
                    {
                        caption = 'Year',;
                        ApplicationArea = All;
                    }

                    field(Mes; Mes)
                    {
                        caption = 'Month',;
                        ApplicationArea = all;
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
        Campo1: Text[3];
        Campo2: Text[13];
        Campo3: Text[10];
        Campo4: Text[4];
        Campo5: Text[16];
        Campo6: Text[1];
        Campo7: Text[1];
        Campo8: Text[20];
        Campo9: Text[11];
        TextTemp: Text[20];
        FechaDesde: Date;
        FechaHasta: Date;
        CabRecibo: Record "GMAPosted Receipt";
        Cliente: Record 18;
        EscribirFichero: Boolean;
        NumeroLineas: Integer;
        Anio: Integer;
        Mes: Integer;
        Texto: Text[1024];
        TempExcelBuff: Record 370 TEMPORARY;
        recValor: Record GMAValues;
        Text004: label 'There is no records to generate the report',;

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


    PROCEDURE "#MovValores"();
    var
        TempBlob: Codeunit "Temp Blob";
        DataCompression: Codeunit "Data Compression";
        ValuesEntryLocal: Record "GMAValues Entry";
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
    BEGIN
        EXIST := true;
        // Obtener información de la empresa
        infEmpresa.Get();
        cuit := DELCHR(infEmpresa."VAT Registration No.", '=', '-');
        periodo := FORMAT(FechaDesde, 0, '<Year4>') + FORMAT(FechaDesde, 0, '<Month,2>');
        lote := FORMAT(FechaDesde, 0, '<Year4>') + '-' + FORMAT(FechaDesde, 0, '<Month,2>');
        Evaluate(dia, FORMAT(FechaHasta, 0, '<Day,2>'));

        // Generar nombre del archivo ZIP
        ZipFileName := 'SIFERE-Retenciones' + '.zip';
        createzip();

        DimensionValue.Reset();
        DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        DimensionValue.SetFilter(code, BssiDimension);
        if DimensionValue.FindFirst() then
            repeat

                FechaDesde := DMY2DATE(1, Mes, Anio);
                EVALUATE(FechaHasta, FORMAT(CALCDATE('+1M', FechaDesde) - 1));
                ValuesEntryLocal.Reset();
                ValuesEntryLocal.SetFilter(ValuesEntryLocal."GMADocument Type", '=%1', ValuesEntryLocal."GMADocument Type"::Recibo);
                // JCG usa la fecha adecuada
                if UseDocumentDate then
                    ValuesEntryLocal.SETRANGE("GMADocument Date", FechaDesde, FechaHasta)
                else
                    ValuesEntryLocal.SETRANGE("GMAPosting Date", FechaDesde, FechaHasta);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        ValuesEntryLocal.SetFilter("GMAGlobal Dimension 1", BssiDimension)
                    else
                        ValuesEntryLocal.SetFilter("GMAGlobal Dimension 2", BssiDimension);

                if ValuesEntryLocal.FindFirst() then begin
                    // Generar un nombre único para cada archivo dentro del zip
                    FileName := 'SIFERE-' + ValuesEntryLocal."GMADocument No." + '.txt';

                    Clear(LONGTEXT);
                    repeat
                        IF recValor.GET(ValuesEntryLocal.GMAValue) THEN
                            IF (recValor."GMAIs Withholding") AND (recValor."GMAIs GGII") THEN BEGIN
                                Campo1 := '';
                                Campo2 := '';
                                Campo3 := '';
                                Campo4 := '';
                                Campo5 := '';
                                Campo6 := '';
                                Campo7 := '';
                                Campo8 := '';
                                Campo9 := '';
                                TextTemp := '';

                                Campo1 := recValor.GMAProvince;

                                //CUIT del Agente de Retenci¢n
                                CabRecibo.RESET;
                                CabRecibo.SETCURRENTKEY("GMANro Recibo");
                                CabRecibo.SETRANGE(CabRecibo."GMANro Recibo", ValuesEntryLocal."GMADocument No.");
                                IF CabRecibo.FINDFIRST THEN BEGIN
                                    Cliente.RESET;
                                    Cliente.SETCURRENTKEY("No.");
                                    Cliente.SETRANGE(Cliente."No.", CabRecibo."GMACustomer No.");
                                    IF Cliente.FINDFIRST THEN BEGIN
                                        Campo2 := DELCHR(Cliente."VAT Registration No.", '=', '-');
                                        Campo2 := INSSTR(Campo2, '-', 3);
                                        Campo2 := INSSTR(Campo2, '-', 12);
                                    END;
                                END;

                                //Fecha de la retenci¢n
                                Campo3 := FORMAT(ValuesEntryLocal."GMADocument Date", 10, '<Day,2>/<Month,2>/<Year4>');

                                //Num Sucursal
                                Campo4 := '0000';

                                //N£mero de constancia
                                IF (ValuesEntryLocal."GMADocument No." = '') THEN
                                    Campo5 := '0000000000000000'
                                ELSE
                                    WHILE STRLEN(Campo5) + STRLEN(DELCHR(ValuesEntryLocal."GMADocument No.", '=', 'ZXCVBNMASDFGHJKLPOIUYTREWQ-_')) < 16 DO Campo5 += '0';
                                Campo5 += DELCHR(ValuesEntryLocal."GMADocument No.", '=', 'ZXCVBNMASDFGHJKLPOIUYTREWQ-_');

                                //Tipo de comprobante
                                Campo6 := 'R';

                                //Letra del comprobante
                                Campo7 := 'A';

                                //N£mero de comprobante original
                                WHILE STRLEN(Campo8) + STRLEN(ValuesEntryLocal."GMAValue No.") < 20 DO Campo8 += '0';
                                Campo8 += ValuesEntryLocal."GMAValue No.";

                                //Importe Retenido
                                WHILE STRLEN(Campo9) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(ValuesEntryLocal."GMAAmount (LCY)", 0.01), 0,
                                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 DO Campo9 += '0';
                                BEGIN
                                    Campo9 += CONVERTSTR(DELCHR(FORMAT(ROUND(ValuesEntryLocal."GMAAmount (LCY)", 0.01), 0,
                                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                                END;

                                CR := 13;
                                FL := 10;
                                CLEAR(Texto);
                                Texto := (
                                FORMAT(Campo1, 3, '<Text>') +
                                FORMAT(Campo2, 13, '<Text>') +
                                FORMAT(Campo3, 10, '<Text>') +
                                FORMAT(Campo4, 4, '<Text>') +
                                FORMAT(Campo5, 16, '<Text>') +
                                FORMAT(Campo6, 1, '<Text>') +
                                FORMAT(Campo7, 1, '<Text>') +
                                FORMAT(Campo8, 20, '<Text>') +
                                FORMAT(Campo9, 11, '<Text>'));

                                LONGTEXT.AddText(Texto);
                                LONGTEXT.AddText(FORMAT(CR) + FORMAT(FL));
                            end;
                    until ValuesEntryLocal.Next() = 0;
                    addbigtext(LONGTEXT, FileName);
                end;
            until DimensionValue.Next() = 0;
        addzip(ZipFileName);

    END;

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