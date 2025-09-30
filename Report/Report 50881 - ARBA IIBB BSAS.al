report 80881 "PERARBA IIBB BSAS"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = "Reportsandanalysis";
    dataset
    {
        dataitem("GMLocWithholding Ledger Entry"; "GMLocWithholding Ledger Entry")
        {
            DataItemTableView = SORTING("GMLocNo.") ORDER(Ascending) WHERE("GMLocWithholding Type" = FILTER(Realizada));

            trigger OnAfterGetRecord();
            var
                WithholdingLedgerEntryTemp: record "GMLocWithholding Ledger Entry";
            begin
                IF ("GMLocWithholding Ledger Entry"."GMLocWithholding Amount" >= 0) THEN BEGIN
                    WithholdingLedgerEntryTemp.RESET;
                    WithholdingLedgerEntryTemp.SETFILTER("GMLocWithholding Serie Code", '%1', "GMLocWithholding Ledger Entry"."GMLocWithholding Serie Code");
                    WithholdingLedgerEntryTemp.SETFILTER("GMLocWithholding Amount", '%1', "GMLocWithholding Ledger Entry"."GMLocWithholding Amount" * -1);
                    IF (NOT WithholdingLedgerEntryTemp.FindFirst()) THEN
                        IF NOT (EXIST) then
                            "#WithholdingLedgerEntry";

                END;
            end;


            trigger OnPreDataItem();
            begin
                IF (fechaposting) Then
                    "GMLocWithholding Ledger Entry".SetRange("GMLocWithholding Ledger Entry"."GMLocWithholding Date", FechaDesde, FechaHasta)
                else
                    "GMLocWithholding Ledger Entry".SetRange("GMLocWithholding Ledger Entry".GMLocDocumentDate, FechaDesde, FechaHasta);

                "GMLocWithholding Ledger Entry".SETFILTER("GMLocWithholding Ledger Entry"."GMLocTax Code", 'IB-BAS');
                "GMLocWithholding Ledger Entry".SETFILTER("GMLocWithholding Ledger Entry"."GMLocProvince Code", '902');

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "GMLocWithholding Ledger Entry".SetFilter("GMLocShortcut Dimension 1", BssiDimension)
                    else
                        "GMLocWithholding Ledger Entry".SetFilter("GMLocShortcut Dimension 2", BssiDimension);
                // JCG Segun la fecha elegida cambia el campo
                "GMLocWithholding Ledger Entry".CalcFields(GMLocDocumentDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(GMLocOptions)
                {
                    Caption = 'Options';
                    field(FechaDesde; FechaDesde)
                    {
                        Caption = 'Date From',
                                    ;
                        ApplicationArea = ALL;
                    }
                    field(FechaHasta; FechaHasta)
                    {
                        Caption = 'Date To',
                                    ;
                        ApplicationArea = ALL;
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
                    field(fechaposting; fechaposting)
                    {
                        Caption = 'Use Posting Date';
                        ApplicationArea = ALL;
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
        Campo1: Text[13];
        Campo2: Text[10];
        Campo3: Text[4];
        Campo4: Text[8];
        Campo5: Text[11];
        Campo6: Text[1];
        FechaDesde: Date;
        FechaHasta: Date;
        Proveedor: Record Vendor;
        Texto: Text[1024];
        NumeroLineas: Integer;
        Text005: Label 'Error de CUIT Proveedor %1';
        GMLocWithhCertificateNo: Text[30];
        GMLocWithhCertificateNoLen: Integer;
        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        CR: char;
        FL: Char;
        GlobalDataCompression: Codeunit "Data Compression";
        fechaposting: Boolean;

    procedure "#WithholdingLedgerEntry"()
    var
        TempBlob: Codeunit "Temp Blob";
        DataCompression: Codeunit "Data Compression";
        ledgerEntryLocal: record "GMLocWithholding Ledger Entry";
        DimensionValue: Record "Dimension value";
        InS: InStream;
        OutS: OutStream;
        ZipFileName: Text[1024];
        infEmpresa: Record "Dimension Value";
        cuit: Text;
        periodo: Text;
        lote: Text;
        FileName: Text[1024];
        LONGTEXT: BigText;
        dia: Integer;
        "GMLocPosted Payment Order Valu": Record "GMLocPosted Payment Order Valu";
        "Hist Cab OPago": Record "GMLocPosted Payment Order";
    begin
        EXIST := true;
        // Obtener información de la empresa
        infEmpresa.Reset();
        infEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        infEmpresa.SetFilter(code, BssiDimension);
        infEmpresa.FindFirst();
        cuit := DELCHR(infEmpresa.BssiTaxRegistrationNumber, '=', '-');
        periodo := FORMAT(FechaDesde, 0, '<Year4>') + FORMAT(FechaDesde, 0, '<Month,2>');
        lote := 'R' + FORMAT(FechaDesde, 0, '<Year4>') + '-' + FORMAT(FechaDesde, 0, '<Month,2>');
        Evaluate(dia, FORMAT(FechaHasta, 0, '<Day,2>'));

        if dia <= 15 then
            ZipFileName := 'AR-' + cuit + '-' + periodo + '1-6-' + lote + '.zip'
        else
            ZipFileName := 'AR-' + cuit + '-' + periodo + '2-6-' + lote + '.zip';

        createzip();

        DimensionValue.Reset();
        DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        DimensionValue.SetFilter(code, BssiDimension);
        if DimensionValue.FindFirst() then
            repeat

                ledgerEntryLocal.Reset();
                ledgerEntryLocal.SETRANGE(ledgerEntryLocal."GMLocVoucher Date", FechaDesde, FechaHasta);
                ledgerEntryLocal.SETFILTER(ledgerEntryLocal."GMLocTax Code", 'IB-BAS');
                ledgerEntryLocal.SETFILTER(ledgerEntryLocal."GMLocProvince Code", '902');

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        ledgerEntryLocal.SetFilter("GMLocShortcut Dimension 1", BssiDimension)
                    else
                        ledgerEntryLocal.SetFilter("GMLocShortcut Dimension 2", BssiDimension);

                if ledgerEntryLocal.FindFirst() then begin


                    // Generar un nombre único para cada archivo dentro del zip
                    if dia <= 15 then
                        FileName := 'AR-' + cuit + '-' + periodo + '1-6-' + lote + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) +
                                        FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;')) + '.txt'
                    else
                        FileName := 'AR-' + cuit + '-' + periodo + '2-6-' + lote + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) +
                                        FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;')) + '.txt';


                    Clear(LONGTEXT);
                    repeat

                        NumeroLineas += 1;
                        Campo1 := '';
                        Campo2 := '';
                        // Número de sucursal.
                        Campo3 := '0001';
                        Campo4 := '';
                        Campo5 := '';
                        Campo6 := '';

                        // Cuit contribuyente retenido.
                        Proveedor.RESET;
                        Proveedor.SETRANGE(Proveedor."No.", ledgerEntryLocal."GMLocVendor Code");
                        if Proveedor.FIND('-') then begin
                            Campo1 := Proveedor."VAT Registration No.";

                            IF (Proveedor."VAT Registration No." = '') THEN
                                ERROR(Text005, Proveedor."No.");

                            campo1 := DELCHR(Campo1, '=', '-');

                            if Campo1 <> '' then
                                Campo1 := INSSTR((INSSTR(Campo1, '-', 3)), '-', 12);
                        end;

                        "GMLocWithholding Ledger Entry".CalcFields(GMLocDocumentDate);

                        // Fecha de retención (DD/MM/YYYY).
                        // JCG Se solicita mostrar solo la posting date
                        // if fechaposting = true then
                        //     Campo2 := FORMAT("GMLocWithholding Ledger Entry"."GMLocWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>')
                        // else
                        Campo2 := FORMAT("GMLocWithholding Ledger Entry".GMLocDocumentDate, 10, '<Day,2>/<Month,2>/<Year4>');

                        // Número de sucursal.
                        //Número de emisión
                        GMLocWithhCertificateNo := DELCHR(ledgerEntryLocal."GMLocWithh. Certificate No.", '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');
                        GMLocWithhCertificateNo := DELCHR(GMLocWithhCertificateNo, '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');
                        GMLocWithhCertificateNo := DELCHR(GMLocWithhCertificateNo, '=', '-+qwertyuiopasdfghjklñzxcvbnm');
                        GMLocWithhCertificateNoLen := STRLEN(GMLocWithhCertificateNo);

                        if GMLocWithhCertificateNoLen <= 8 then
                            Campo4 := GMLocWithhCertificateNo
                        else
                            Campo4 := CopyStr(GMLocWithhCertificateNo, GMLocWithhCertificateNoLen - 7, 8);

                        Campo4 := Campo4.PadLeft(8, ' ');

                        //Importe de la retencion
                        WHILE STRLEN(Campo5) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(ledgerEntryLocal."GMLocWithholding Amount", 0.01), 0,
                        '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 DO Campo5 += '0';
                        BEGIN
                            Campo5 += CONVERTSTR(DELCHR(FORMAT(ROUND(ledgerEntryLocal."GMLocWithholding Amount", 0.01), 0,
                            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                        END;

                        // Tipo Operación
                        Campo6 := 'A';

                        CR := 13;
                        FL := 10;
                        CLEAR(Texto);
                        Texto := (
                        FORMAT(Campo1, 13, '<Text>') +
                        FORMAT(Campo2, 10, '<Text>') +
                        FORMAT(Campo3, 4, '<Text>') +
                        FORMAT(Campo4, 8, '<Text>') +
                        FORMAT(Campo5, 11, '<Text>') +
                        FORMAT(Campo6, 1, '<Text>'));

                        LONGTEXT.AddText(Texto);
                        LONGTEXT.AddText(FORMAT(CR) + FORMAT(FL));

                    until ledgerEntryLocal.Next() = 0;
                    addbigtext(LONGTEXT, FileName);
                end;
            until DimensionValue.Next() = 0;
        addzip(ZipFileName);
    end;

    procedure addbigtext(LoctextBlob: BigText;
        FileName: Text)
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