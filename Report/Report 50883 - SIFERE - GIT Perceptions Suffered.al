report 80883 "PERSIFERE - GIT Perc. Suff."
{
    caption = 'SIFERE - GIT Perceptions Suffered';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = SORTING("Posting Date", Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", Reversed, "G/L Acc. No.")
                                ORDER(Ascending)
                                WHERE(Type = CONST(Purchase));

            RequestFilterFields = "VAT Registration No.";

            trigger OnPreDataItem()
            begin
                FechaDesde := DMY2DATE(1, Mes, Anio);
                EVALUATE(FechaHasta, FORMAT(CALCDATE('+1M', FechaDesde) - 1));
                if UseDocumentDate then
                    "VAT Entry".SETRANGE("Document Date", FechaDesde, FechaHasta)
                else
                    "VAT Entry".SETRANGE("Posting Date", FechaDesde, FechaHasta);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
            end;

            trigger OnAfterGetRecord()
            VAR
                "VAT Product Posting Group": Record 324;
                PurchInvHeader: Record 122;
                PurchCrMemoHdr: Record 124;
            BEGIN
                //NAVAR1.06004-
                if ("VAT Entry"."GMLocTax Type Loc" = "VAT Entry"."GMLocTax Type Loc"::"IVA Percepcion") then
                    CurrReport.Skip();

                IF "VAT Entry".Amount = 0 THEN
                    CurrReport.SKIP;

                IF "VAT Entry"."VAT Calculation Type" = "VAT Entry"."VAT Calculation Type"::"Sales Tax" THEN BEGIN
                    RecTaxJur.RESET;
                    RecTaxJur.SETCURRENTKEY(Code);
                    RecTaxJur.SETRANGE(Code, "Tax Jurisdiction Code");
                    IF RecTaxJur.FINDFIRST THEN
                        IF RecTaxJur."GMLocIs GIT" THEN BEGIN
                            IF "VAT Entry".Amount <> 0 THEN BEGIN
                                EscribirFichero := TRUE;

                                CLEAR(CUITGlobal);

                                IF (PurchInvHeader.GET("VAT Entry"."Document No.")) THEN BEGIN
                                    RecVendor.GET(PurchInvHeader."Buy-from Vendor No.");
                                    IF (PurchInvHeader."VAT Registration No." <> '') THEN
                                        CUITGlobal := PurchInvHeader."VAT Registration No."
                                    ELSE
                                        CUITGlobal := RecVendor."VAT Registration No.";

                                END
                                ELSE BEGIN
                                    IF (PurchCrMemoHdr.GET("VAT Entry"."Document No.")) THEN
                                        RecVendor.GET(PurchCrMemoHdr."Buy-from Vendor No.");
                                    IF (PurchCrMemoHdr."VAT Registration No." <> '') THEN
                                        CUITGlobal := PurchCrMemoHdr."VAT Registration No."
                                    ELSE
                                        CUITGlobal := RecVendor."VAT Registration No.";
                                END;
                                if (RecVendor."GMLocExlude SIFERE GIt Per" = false) then begin
                                    IF (RecVendor."GMLocGross Income Vendor Type" = RecVendor."GMLocGross Income Vendor Type"::" ") THEN BEGIN
                                        NumeroLineas += 1;
                                        IF NOT (EXIST) then
                                            "#VatEntry";
                                    END;
                                    IF (RecVendor."GMLocGross Income Vendor Type" = RecVendor."GMLocGross Income Vendor Type"::Aduaneras) THEN BEGIN
                                        NumeroLineasadu += 1;
                                        IF NOT (EXISTADUANA) then
                                            "#VatEntryAduana";
                                    END;
                                    IF (RecVendor."GMLocGross Income Vendor Type" = RecVendor."GMLocGross Income Vendor Type"::Bancarias) THEN BEGIN
                                        NumeroLineasBanc += 1;
                                        IF NOT (EXISTBANCO) then
                                            "#VatEntryBanco";
                                    END;
                                end;
                            END;
                        END;
                END;

                IF "VAT Entry"."VAT Calculation Type" <> "VAT Entry"."VAT Calculation Type"::"Sales Tax" THEN BEGIN

                    IF (VATProductPostingGroup.GET("VAT Entry"."VAT Prod. Posting Group")) THEN begin

                        if (VATProductPostingGroup."GMLocTax Type" = VATProductPostingGroup."GMLocTax Type"::"Ingresos Brutos") then begin

                            CLEAR(Campo1FULLVAT);//21/10/16
                            IF (VATProductPostingGroup.GMLocProvince = '') THEN//21/10/16
                                ERROR('Debe configurar Provincia en Grupo Registro IVA Prod. %1 ', VATProductPostingGroup.Code);//21/10/16
                            Campo1FULLVAT := VATProductPostingGroup.GMLocProvince;//21/10/16
                            EscribirFichero := TRUE;

                            CLEAR(CUITGlobal);
                            IF (PurchInvHeader.GET("VAT Entry"."Document No.")) THEN BEGIN
                                RecVendor.GET(PurchInvHeader."Buy-from Vendor No.");
                                IF (PurchInvHeader."VAT Registration No." <> '') THEN
                                    CUITGlobal := PurchInvHeader."VAT Registration No."
                                ELSE
                                    CUITGlobal := RecVendor."VAT Registration No.";

                            END
                            ELSE BEGIN
                                IF (PurchCrMemoHdr.GET("VAT Entry"."Document No.")) THEN
                                    RecVendor.GET(PurchCrMemoHdr."Buy-from Vendor No.");
                                IF (PurchCrMemoHdr."VAT Registration No." <> '') THEN
                                    CUITGlobal := PurchCrMemoHdr."VAT Registration No."
                                ELSE
                                    CUITGlobal := RecVendor."VAT Registration No.";
                            END;
                            if (RecVendor."GMLocExlude SIFERE GIt Per" = false) then begin
                                IF (RecVendor."GMLocGross Income Vendor Type" = RecVendor."GMLocGross Income Vendor Type"::" ") THEN BEGIN
                                    NumeroLineas += 1;
                                    IF NOT (EXIST) then
                                        "#VatEntry";
                                END;
                                IF (RecVendor."GMLocGross Income Vendor Type" = RecVendor."GMLocGross Income Vendor Type"::Aduaneras) THEN BEGIN
                                    NumeroLineasadu += 1;
                                    IF NOT (EXISTADUANA) then
                                        "#VatEntryAduana";
                                END;
                                IF (RecVendor."GMLocGross Income Vendor Type" = RecVendor."GMLocGross Income Vendor Type"::Bancarias) THEN BEGIN
                                    NumeroLineasBanc += 1;
                                    IF NOT (EXISTBANCO) then
                                        "#VatEntryBanco";
                                END;
                            end;
                        end;
                    end;
                END;
            END;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GMLocOptions)
                {
                    Caption = 'Options',;
                    field(Anio; Anio)
                    {
                        Caption = 'Year',;
                        ApplicationArea = All;
                    }

                    field(Mes; Mes)
                    {
                        Caption = 'Month',;
                        ApplicationArea = All;
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
        EXISTADUANA: Boolean;
        EXISTBANCO: Boolean;
        Campo1: Text[3];
        Campo2: Text[14];
        Campo3: Text[10];
        Campo4: Text[4];
        Campo5: Text[20];
        Campo6: Text[1];
        Campo7: Text[1];
        Campo8: Text[11];
        Campo9: Text[20];
        TextTemp: Text[20];
        Destino: Text[250];
        Destinoadu: Text[250];
        Destinobanc: Text[250];
        FechaDesde: Date;
        FechaHasta: Date;


        EscribirFichero: Boolean;
        NumeroLineas: Integer;
        NumeroLineasadu: Integer;
        NumeroLineasBanc: Integer;

        Anio: Integer;
        Mes: Integer;

        Texto: Text[1024];
        Textoadu: Text[1024];
        Textobanc: Text[1024];
        ExportaTxt: Codeunit "GMLocExporta TXT";
        TempExcelBuff: Record 370 TEMPORARY;
        TempExcelBuffadu: Record 370 TEMPORARY;
        TempExcelBuffbanc: Record 370 TEMPORARY;
        recValor: Record GMLocValues;
        TextoBis: BigText;
        Text004: label 'There is no records to generate the perceptions report',;
        Text005: label 'There is no records to generate the perceptions bank report',;
        Text006: label 'There is no records to generate the perceptions customs report',;  // Customs = aduana
        TextoBisadu: BigText;
        TextoBisbanc: BigText;
        RecTaxJur: Record 320;
        RecVatProdPostingGroup: Record "VAT Product Posting Group";
        RecMovRetencion: Record "GMLocWithholding Ledger Entry";
        RecVendor: Record 23;
        RecHistLinValorOP: Record "GMLocPosted Payment Order Valu";
        facturasCompra: Record 122;
        NCCompra: Record 124;
        tempvatentry: Record 254 TEMPORARY;
        auxVatEntry: Record 254;
        importesumado: Decimal;
        aux: Integer;
        VATProductPostingGroup: Record 324;
        "21/10/16": Integer;
        Campo1FULLVAT: Text[3];
        "*Banco*": Integer;
        BCampo1: Text[3];
        BCampo2: Text[13];
        BCampo3: Text[7];
        BCampo4: Text[22];
        BCampo5: Text[2];
        BCampo6: Text[1];
        BCampo7: Text[10];
        BCampo8: Text[20];
        "*Aduana": Integer;
        ACampo1: Text[3];
        ACampo2: Text[13];
        ACampo3: Text[10];
        ACampo4: Text[20];
        ACampo5: Text[10];
        ACampo6: Text[20];
        Archivo: Text[1024];
        CUITGlobal: Code[20];

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

    PROCEDURE "#VatEntry"();
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
    BEGIN
        EXIST := true;
        infEmpresa.Get();
        cuit := DELCHR(infEmpresa."VAT Registration No.", '=', '-');
        periodo := FORMAT(FechaDesde, 0, '<Year4>') + FORMAT(FechaDesde, 0, '<Month,2>');
        lote := FORMAT(FechaDesde, 0, '<Year4>') + '-' + FORMAT(FechaDesde, 0, '<Month,2>');
        Evaluate(dia, FORMAT(FechaHasta, 0, '<Day,2>'));

        // Generar nombre del archivo ZIP
        ZipFileName := 'SIFERE-Percepciones' + '.zip';
        createzip();

        DimensionValue.Reset();
        DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        DimensionValue.SetFilter(code, BssiDimension);
        if DimensionValue.FindFirst() then
            repeat


                FechaDesde := DMY2DATE(1, Mes, Anio);
                EVALUATE(FechaHasta, FORMAT(CALCDATE('+1M', FechaDesde) - 1));
                //NAVAR1.06001+

                // JCG usa la fecha adecuada
                if UseDocumentDate then
                    VATentryLocal.SETRANGE("Document Date", FechaDesde, FechaHasta)
                else
                    VATentryLocal.SETRANGE("Posting Date", FechaDesde, FechaHasta);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        VATentryLocal.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        VATentryLocal.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);

                VATentryLocal.SETRANGE("GMLocTax Type Loc", VATentryLocal."GMLocTax Type Loc"::"Ingresos Brutos");
                if VATentryLocal.FindFirst() then begin
                    // Generar un nombre único para cada archivo dentro del zip
                    FileName := 'SIFERE-' + VATentryLocal."Document No." + '.txt';

                    Clear(LONGTEXT);
                    repeat



                        Campo1 := '';
                        Campo2 := '';
                        Campo3 := '';
                        Campo4 := '';
                        Campo5 := '';
                        Campo6 := '';
                        Campo7 := '';
                        Campo8 := '';
                        Campo9 := '';

                        CLEAR(Texto);
                        tempvatentry.RESET();
                        tempvatentry.SETRANGE("Document No.", VATentryLocal."Document No.");
                        IF VATentryLocal."VAT Calculation Type" = VATentryLocal."VAT Calculation Type"::"Full VAT" THEN
                            tempvatentry.SETRANGE("VAT Prod. Posting Group", VATentryLocal."VAT Prod. Posting Group")
                        ELSE
                            tempvatentry.SETRANGE("Tax Jurisdiction Code", VATentryLocal."Tax Jurisdiction Code");
                        IF (tempvatentry.FINDFIRST) THEN
                            CurrReport.SKIP
                        ELSE BEGIN
                            tempvatentry.INIT;
                            aux += 1;
                            tempvatentry."Entry No." := aux;
                            tempvatentry."Document No." := VATentryLocal."Document No.";
                            tempvatentry."Tax Jurisdiction Code" := VATentryLocal."Tax Jurisdiction Code";
                            tempvatentry."VAT Prod. Posting Group" := VATentryLocal."VAT Prod. Posting Group";
                            tempvatentry.INSERT;
                        END;

                        //Jurisdiccion
                        IF RecTaxJur.GET(VATentryLocal."Tax Jurisdiction Code") THEN
                            Campo1 := RecTaxJur."GMLocProvince Code";

                        IF Campo1 = '' THEN BEGIN
                            IF RecVatProdPostingGroup.GET(VATentryLocal."VAT Bus. Posting Group") THEN
                                Campo1 := RecVatProdPostingGroup."GMLocProvince";
                        END;

                        RecVendor.RESET;
                        RecVendor.SETCURRENTKEY("No.");
                        RecVendor.SETRANGE("No.", VATentryLocal."Bill-to/Pay-to No.");
                        IF RecVendor.FINDFIRST THEN BEGIN
                            Campo2 := DELCHR(CUITGlobal, '=', '-');
                            Campo2 := INSSTR(Campo2, '-', 3);
                            Campo2 := INSSTR(Campo2, '-', 12);
                        END;

                        //Fecha de la retenci¢n
                        // JCG usa la fecha adecuada
                        if UseDocumentDate then
                            Campo3 := FORMAT(VATentryLocal."Document Date", 10, '<Day,2>/<Month,2>/<Year4>')
                        else
                            Campo3 := FORMAT(VATentryLocal."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

                        //N£mero de sucursal + N£mero de constancia
                        Campo4 := '0000';


                        //N£mero de constancia ANTA0005-00011440
                        IF (VATentryLocal."External Document No." = '') THEN
                            Campo5 := '00000000'
                        ELSE BEGIN
                            IF (STRLEN(VATentryLocal."External Document No.") < 8) THEN BEGIN
                                WHILE STRLEN(Campo5) + STRLEN(COPYSTR(VATentryLocal."External Document No.", STRLEN(VATentryLocal."External Document No.") - 7, 8)) < 8 DO
                                    Campo5 += '0';
                            END
                            ELSE BEGIN
                                Campo5 += COPYSTR(VATentryLocal."External Document No.", STRLEN(VATentryLocal."External Document No.") - 7, 8);
                                // Campo5 := CONVERTSTR(Campo5,'-','0');
                            END;
                        END;
                        //Tipo de comprobante
                        IF (VATentryLocal."Document Type" = VATentryLocal."Document Type"::Invoice) OR (VATentryLocal."GMLocDocument Type Loc." = VATentryLocal."GMLocDocument Type Loc."::"Nota Débito") THEN
                            Campo6 := 'F'
                        ELSE
                            Campo6 := 'C';

                        //Letra del comprobante
                        Campo7 := 'A';

                        CLEAR(importesumado);


                        auxVatEntry.RESET;
                        auxVatEntry.SETRANGE("Document No.", VATentryLocal."Document No.");
                        //auxVatEntry.SETRANGE("External Document No.","VAT Entry"."External Document No.");
                        auxVatEntry.SETRANGE("GMLocTax Type Loc", auxVatEntry."GMLocTax Type Loc"::"Ingresos Brutos");
                        IF VATentryLocal."VAT Calculation Type" = VATentryLocal."VAT Calculation Type"::"Full VAT" THEN
                            auxVatEntry.SETRANGE("VAT Prod. Posting Group", VATentryLocal."VAT Prod. Posting Group")
                        ELSE
                            auxVatEntry.SETRANGE("Tax Jurisdiction Code", VATentryLocal."Tax Jurisdiction Code");
                        IF (auxVatEntry.FINDSET) THEN
                            REPEAT
                                importesumado := importesumado + auxVatEntry.Amount;
                            UNTIL auxVatEntry.NEXT = 0;

                        IF (importesumado < 0) THEN
                            Campo6 := 'C';


                        IF Campo6 = 'C' THEN BEGIN
                            //Importe Retenido
                            WHILE STRLEN(Campo8) + STRLEN('-') + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 DO Campo8 += '0';
                            BEGIN
                                Campo8 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                                Campo8 := '-' + Campo8;
                            END;
                        END
                        ELSE BEGIN
                            WHILE STRLEN(Campo8) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 DO Campo8 += '0';
                            BEGIN
                                Campo8 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                            END;
                        END;

                        CR := 13;
                        FL := 10;

                        IF RecTaxJur.GET(VATentryLocal."Tax Jurisdiction Code") THEN
                            Campo1 := RecTaxJur."GMLocProvince Code";

                        IF Campo1 = '' THEN BEGIN
                            IF RecVatProdPostingGroup.GET(VATentryLocal."VAT Bus. Posting Group") THEN
                                Campo1 := RecVatProdPostingGroup."GMLocProvince";
                        END;

                        CLEAR(Texto);
                        Texto := (
                            FORMAT(Campo1, 3, '<Text>') +
                            FORMAT(Campo2, 13, '<Text>') +
                            FORMAT(Campo3, 10, '<Text>') +
                            FORMAT(Campo4, 4, '<Text>') +
                            FORMAT(Campo5, 8, '<Text>') +
                            FORMAT(Campo6, 1, '<Text>') +
                            FORMAT(Campo7, 1, '<Text>') +
                            FORMAT(Campo8, 11, '<Text>') +
                            FORMAT(Campo9, 3, '<Text>')
                        );

                        LONGTEXT.AddText(Texto);
                        LONGTEXT.AddText(FORMAT(CR) + FORMAT(FL));

                    until VATentryLocal.Next() = 0;
                    addbigtext(LONGTEXT, FileName);
                end;
            until DimensionValue.Next() = 0;
        addzip(ZipFileName);
    END;


    PROCEDURE "#VatEntryAduana"();
    VAR
        PurchInvHeader: Record 122;
        PurchCrMemoHdr: Record 124;
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
    BEGIN
        EXISTADUANA := true;
        infEmpresa.Get();
        cuit := DELCHR(infEmpresa."VAT Registration No.", '=', '-');
        periodo := FORMAT(FechaDesde, 0, '<Year4>') + FORMAT(FechaDesde, 0, '<Month,2>');
        lote := FORMAT(FechaDesde, 0, '<Year4>') + '-' + FORMAT(FechaDesde, 0, '<Month,2>');
        Evaluate(dia, FORMAT(FechaHasta, 0, '<Day,2>'));

        // Generar nombre del archivo ZIP
        ZipFileName := 'SIFERE-Percepciones' + '.zip';
        createzip();

        DimensionValue.Reset();
        DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        DimensionValue.SetFilter(code, BssiDimension);
        if DimensionValue.FindFirst() then
            repeat


                FechaDesde := DMY2DATE(1, Mes, Anio);
                EVALUATE(FechaHasta, FORMAT(CALCDATE('+1M', FechaDesde) - 1));
                //NAVAR1.06001+

                // JCG usa la fecha adecuada
                if UseDocumentDate then
                    VATentryLocal.SETRANGE("Document Date", FechaDesde, FechaHasta)
                else
                    VATentryLocal.SETRANGE("Posting Date", FechaDesde, FechaHasta);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        VATentryLocal.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        VATentryLocal.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
                if VATentryLocal.FindFirst() then begin
                    // Generar un nombre único para cada archivo dentro del zip
                    FileName := 'SIFERE-' + VATentryLocal."Document No." + '.txt';

                    Clear(LONGTEXT);
                    repeat

                        ACampo1 := '';
                        ACampo2 := '';
                        ACampo3 := '';
                        ACampo4 := '';
                        ACampo5 := '';
                        ACampo6 := '';
                        CLEAR(Textoadu);
                        tempvatentry.RESET();
                        tempvatentry.SETRANGE("Document No.", "VAT Entry"."Document No.");
                        IF "VAT Entry"."VAT Calculation Type" = "VAT Entry"."VAT Calculation Type"::"Full VAT" THEN
                            tempvatentry.SETRANGE("VAT Prod. Posting Group", "VAT Entry"."VAT Prod. Posting Group")
                        ELSE
                            tempvatentry.SETRANGE("Tax Jurisdiction Code", "VAT Entry"."Tax Jurisdiction Code");
                        IF (tempvatentry.FINDFIRST) THEN
                            CurrReport.SKIP
                        ELSE BEGIN
                            tempvatentry.INIT;
                            aux += 1;
                            tempvatentry."Entry No." := aux;
                            tempvatentry."Document No." := "VAT Entry"."Document No.";
                            tempvatentry."Tax Jurisdiction Code" := "VAT Entry"."Tax Jurisdiction Code";
                            tempvatentry."VAT Prod. Posting Group" := "VAT Entry"."VAT Prod. Posting Group";
                            tempvatentry.INSERT;
                        END;

                        //Jurisdiccion
                        IF RecTaxJur.GET("VAT Entry"."Tax Jurisdiction Code") THEN
                            ACampo1 := RecTaxJur."GMLocProvince Code";

                        IF ACampo1 = '' THEN BEGIN
                            IF RecVatProdPostingGroup.GET("VAT Entry"."VAT Bus. Posting Group") THEN
                                ACampo1 := RecVatProdPostingGroup."GMLocProvince";
                        END;

                        RecVendor.RESET;
                        RecVendor.SETCURRENTKEY("No.");
                        RecVendor.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
                        IF RecVendor.FINDFIRST THEN BEGIN
                            ACampo2 := DELCHR(CUITGlobal, '=', '-');
                            ACampo2 := INSSTR(ACampo2, '-', 3);
                            ACampo2 := INSSTR(ACampo2, '-', 12);
                        END;

                        //Fecha de la retenci¢n
                        // JCG usa la fecha adecuada
                        if UseDocumentDate then
                            ACampo3 := FORMAT("VAT Entry"."Document Date", 10, '<Day,2>/<Month,2>/<Year4>')
                        else
                            ACampo3 := FORMAT("VAT Entry"."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

                        //N£mero de sucursal + N£mero de constancia

                        IF (PurchInvHeader.GET("VAT Entry"."Document No.")) THEN BEGIN
                            IF (PurchInvHeader."GMLocImport Dispatch" <> '') THEN BEGIN
                                WHILE STRLEN(ACampo4) + STRLEN(PurchInvHeader."GMLocImport Dispatch") < 20 DO ACampo4 += '0';
                                BEGIN
                                    ACampo4 += PurchInvHeader."GMLocImport Dispatch";
                                END;
                            END;
                        END
                        ELSE BEGIN
                            IF (PurchCrMemoHdr.GET("VAT Entry"."Document No.")) THEN BEGIN
                                IF (PurchCrMemoHdr."GMLocImport Dispatch" <> '') THEN BEGIN
                                    WHILE STRLEN(ACampo4) + STRLEN(PurchCrMemoHdr."GMLocImport Dispatch") < 20 DO ACampo4 += '0';
                                    BEGIN
                                        ACampo4 += PurchCrMemoHdr."GMLocImport Dispatch";
                                    END;
                                END;
                            END;
                        END;

                        IF (ACampo4 = '') THEN
                            ACampo4 := '00000000000000000000';

                        CLEAR(importesumado);

                        auxVatEntry.RESET;
                        auxVatEntry.SETRANGE("Document No.", "VAT Entry"."Document No.");
                        auxVatEntry.SETRANGE("GMLocTax Type Loc", auxVatEntry."GMLocTax Type Loc"::"Ingresos Brutos");
                        IF "VAT Entry"."VAT Calculation Type" = "VAT Entry"."VAT Calculation Type"::"Full VAT" THEN
                            auxVatEntry.SETRANGE("VAT Prod. Posting Group", "VAT Entry"."VAT Prod. Posting Group")
                        ELSE
                            auxVatEntry.SETRANGE("Tax Jurisdiction Code", "VAT Entry"."Tax Jurisdiction Code");
                        IF (auxVatEntry.FINDSET) THEN
                            REPEAT
                                importesumado := importesumado + auxVatEntry.Amount;
                            UNTIL auxVatEntry.NEXT = 0;

                        IF (importesumado < 0) THEN BEGIN
                            //Importe Retenido
                            WHILE STRLEN(ACampo5) + STRLEN('-') + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 10 DO ACampo5 += '0';
                            BEGIN
                                ACampo5 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                                ACampo5 := '-' + ACampo5;
                            END;
                        END
                        ELSE BEGIN
                            WHILE STRLEN(ACampo5) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 10 DO ACampo5 += '0';
                            BEGIN
                                ACampo5 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                            END;
                        END;

                        CR := 13;
                        FL := 10;

                        IF RecTaxJur.GET("VAT Entry"."Tax Jurisdiction Code") THEN
                            ACampo6 := RecTaxJur."GMLocProvince Code";

                        IF ACampo6 = '' THEN BEGIN
                            IF RecVatProdPostingGroup.GET("VAT Entry"."VAT Bus. Posting Group") THEN
                                ACampo6 := RecVatProdPostingGroup."GMLocProvince";
                        END;

                        CLEAR(Textoadu);
                        Textoadu := (
                            FORMAT(ACampo1, 3, '<Text>') +
                            FORMAT(ACampo2, 13, '<Text>') +
                            FORMAT(ACampo3, 10, '<Text>') +
                            FORMAT(ACampo4, 20, '<Text>') +
                            FORMAT(ACampo5, 10, '<Text>') +
                            FORMAT(ACampo6, 3, '<Text>')
                        );

                        LONGTEXT.AddText(Texto);
                        LONGTEXT.AddText(FORMAT(CR) + FORMAT(FL));

                    until VATentryLocal.Next() = 0;
                    addbigtext(LONGTEXT, FileName);
                end;
            until DimensionValue.Next() = 0;
        addzip(ZipFileName);
    END;



    PROCEDURE "#VatEntryBanco"();
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
    BEGIN
        EXISTBANCO := true;
        infEmpresa.Get();
        cuit := DELCHR(infEmpresa."VAT Registration No.", '=', '-');
        periodo := FORMAT(FechaDesde, 0, '<Year4>') + FORMAT(FechaDesde, 0, '<Month,2>');
        lote := FORMAT(FechaDesde, 0, '<Year4>') + '-' + FORMAT(FechaDesde, 0, '<Month,2>');
        Evaluate(dia, FORMAT(FechaHasta, 0, '<Day,2>'));

        // Generar nombre del archivo ZIP
        ZipFileName := 'SIFERE-Percepciones' + '.zip';
        createzip();

        DimensionValue.Reset();
        DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        DimensionValue.SetFilter(code, BssiDimension);
        if DimensionValue.FindFirst() then
            repeat


                FechaDesde := DMY2DATE(1, Mes, Anio);
                EVALUATE(FechaHasta, FORMAT(CALCDATE('+1M', FechaDesde) - 1));
                //NAVAR1.06001+

                // JCG usa la fecha adecuada
                if UseDocumentDate then
                    VATentryLocal.SETRANGE("Document Date", FechaDesde, FechaHasta)
                else
                    VATentryLocal.SETRANGE("Posting Date", FechaDesde, FechaHasta);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        VATentryLocal.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        VATentryLocal.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
                if VATentryLocal.FindFirst() then begin
                    // Generar un nombre único para cada archivo dentro del zip
                    FileName := 'SIFERE-' + VATentryLocal."Document No." + '.txt';

                    Clear(LONGTEXT);
                    repeat
                        BCampo1 := '';
                        BCampo2 := '';
                        BCampo3 := '';
                        BCampo4 := '';
                        BCampo5 := '';
                        BCampo6 := '';
                        BCampo7 := '';
                        CLEAR(Textobanc);
                        tempvatentry.RESET();
                        tempvatentry.SETRANGE("Document No.", "VAT Entry"."Document No.");
                        IF "VAT Entry"."VAT Calculation Type" = "VAT Entry"."VAT Calculation Type"::"Full VAT" THEN
                            tempvatentry.SETRANGE("VAT Prod. Posting Group", "VAT Entry"."VAT Prod. Posting Group")
                        ELSE
                            tempvatentry.SETRANGE("Tax Jurisdiction Code", "VAT Entry"."Tax Jurisdiction Code");
                        IF (tempvatentry.FINDFIRST) THEN
                            CurrReport.SKIP
                        ELSE BEGIN
                            tempvatentry.INIT;
                            aux += 1;
                            tempvatentry."Entry No." := aux;
                            tempvatentry."Document No." := "VAT Entry"."Document No.";
                            tempvatentry."Tax Jurisdiction Code" := "VAT Entry"."Tax Jurisdiction Code";
                            tempvatentry."VAT Prod. Posting Group" := "VAT Entry"."VAT Prod. Posting Group";
                            tempvatentry.INSERT;
                        END;

                        //Jurisdiccion
                        IF RecTaxJur.GET("VAT Entry"."Tax Jurisdiction Code") THEN
                            BCampo1 := RecTaxJur."GMLocProvince Code";

                        IF BCampo1 = '' THEN BEGIN
                            IF RecVatProdPostingGroup.GET("VAT Entry"."VAT Bus. Posting Group") THEN
                                BCampo1 := RecVatProdPostingGroup."GMLocProvince";
                        END;

                        RecVendor.RESET;
                        RecVendor.SETCURRENTKEY("No.");
                        RecVendor.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
                        IF RecVendor.FINDFIRST THEN BEGIN
                            BCampo2 := DELCHR(CUITGlobal, '=', '-');
                            BCampo2 := INSSTR(BCampo2, '-', 3);
                            BCampo2 := INSSTR(BCampo2, '-', 12);
                        END;

                        //Fecha de la retenci¢n
                        // JCG usa la fecha adecuada
                        if UseDocumentDate then
                            BCampo3 := FORMAT("VAT Entry"."Document Date", 7, '<Year4>/<Month,2>')
                        else
                            BCampo3 := FORMAT("VAT Entry"."Posting Date", 7, '<Year4>/<Month,2>');

                        //N£mero de sucursal + N£mero de constancia
                        IF (RecVendor.GMLocCBU2 <> '') THEN
                            BCampo4 := RecVendor.GMLocCBU2
                        ELSE
                            BCampo4 := '0000000000000000000000';

                        IF (RecVendor."GMLocAccount Type2" <> RecVendor."GMLocAccount Type2"::" ") THEN
                            Campo5 := FORMAT(RecVendor."GMLocAccount Type2");

                        BCampo6 := 'P';

                        CLEAR(importesumado);

                        auxVatEntry.RESET;
                        auxVatEntry.SETRANGE("Document No.", "VAT Entry"."Document No.");
                        auxVatEntry.SETRANGE("GMLocTax Type Loc", auxVatEntry."GMLocTax Type Loc"::"Ingresos Brutos");
                        IF "VAT Entry"."VAT Calculation Type" = "VAT Entry"."VAT Calculation Type"::"Full VAT" THEN
                            auxVatEntry.SETRANGE("VAT Prod. Posting Group", "VAT Entry"."VAT Prod. Posting Group")
                        ELSE
                            auxVatEntry.SETRANGE("Tax Jurisdiction Code", "VAT Entry"."Tax Jurisdiction Code");
                        IF (auxVatEntry.FINDSET) THEN
                            REPEAT
                                importesumado := importesumado + auxVatEntry.Amount;
                            UNTIL auxVatEntry.NEXT = 0;

                        IF (importesumado < 0) THEN BEGIN
                            //Importe Retenido
                            WHILE STRLEN(BCampo7) + STRLEN('-') + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 10 DO BCampo7 += '0';
                            BEGIN
                                BCampo7 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                                BCampo7 := '-' + BCampo7;
                            END;
                        END
                        ELSE BEGIN
                            WHILE STRLEN(BCampo7) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 10 DO BCampo7 += '0';
                            BEGIN
                                BCampo7 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
                                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                            END;
                        END;

                        CR := 13;
                        FL := 10;

                        IF RecTaxJur.GET("VAT Entry"."Tax Jurisdiction Code") THEN
                            BCampo8 := RecTaxJur."GMLocProvince Code";

                        IF BCampo8 = '' THEN BEGIN
                            IF RecVatProdPostingGroup.GET("VAT Entry"."VAT Bus. Posting Group") THEN
                                BCampo8 := RecVatProdPostingGroup."GMLocProvince";
                        END;
                        CLEAR(Textobanc);
                        Textobanc := (
                           FORMAT(BCampo1, 3, '<Text>') +
                           FORMAT(BCampo2, 13, '<Text>') +
                           FORMAT(BCampo3, 7, '<Text>') +
                           FORMAT(BCampo4, 22, '<Text>') +
                           FORMAT(BCampo5, 2, '<Text>') +
                           FORMAT(BCampo6, 1, '<Text>') +
                           FORMAT(BCampo7, 10, '<Text>') +
                           FORMAT(BCampo8, 3, '<Text>')
                       );

                        LONGTEXT.AddText(Texto);
                        LONGTEXT.AddText(FORMAT(CR) + FORMAT(FL));

                    until VATentryLocal.Next() = 0;
                    addbigtext(LONGTEXT, FileName);
                end;
            until DimensionValue.Next() = 0;
        addzip(ZipFileName);
    END;

}