report 34006881 "PERARBA IIBB BSAS"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = "Reportsandanalysis";
    dataset
    {
        dataitem("GMAWithholding Ledger Entry"; "GMAWithholding Ledger Entry")
        {
            DataItemTableView = SORTING("GMANo.") ORDER(Ascending) WHERE("GMAWithholding Type" = FILTER(Realizada));

            trigger OnAfterGetRecord();
            var
                WithholdingLedgerEntryTemp: record "GMAWithholding Ledger Entry";
            begin
                IF ("GMAWithholding Ledger Entry"."GMAWithholding Amount" >= 0) THEN BEGIN
                    WithholdingLedgerEntryTemp.RESET;
                    WithholdingLedgerEntryTemp.SETFILTER("GMAWithholding Serie Code", '%1', "GMAWithholding Ledger Entry"."GMAWithholding Serie Code");
                    WithholdingLedgerEntryTemp.SETFILTER("GMAWithholding Amount", '%1', "GMAWithholding Ledger Entry"."GMAWithholding Amount" * -1);
                    IF (NOT WithholdingLedgerEntryTemp.FindFirst()) THEN
                        IF NOT (EXIST) then
                            "#WithholdingLedgerEntry";

                END;
            end;


            trigger OnPreDataItem();
            begin
                IF (fechaposting) Then
                    "GMAWithholding Ledger Entry".SetRange("GMAWithholding Ledger Entry"."GMAWithholding Date", FechaDesde, FechaHasta)
                else
                    "GMAWithholding Ledger Entry".SetRange("GMAWithholding Ledger Entry".GMADocumentDate, FechaDesde, FechaHasta);

                "GMAWithholding Ledger Entry".SETFILTER("GMAWithholding Ledger Entry"."GMATax Code", 'IB-BAS');
                "GMAWithholding Ledger Entry".SETFILTER("GMAWithholding Ledger Entry"."GMAProvince Code", '902');

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "GMAWithholding Ledger Entry".SetFilter("GMAShortcut Dimension 1", BssiDimension)
                    else
                        "GMAWithholding Ledger Entry".SetFilter("GMAShortcut Dimension 2", BssiDimension);
                // JCG Segun la fecha elegida cambia el campo
                "GMAWithholding Ledger Entry".CalcFields(GMADocumentDate);
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
        GMAWithhCertificateNo: Text[30];
        GMAWithhCertificateNoLen: Integer;
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
        ledgerEntryLocal: record "GMAWithholding Ledger Entry";
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
        "GMAPosted Payment Order Valu": Record "GMAPosted Payment Order Valu";
        "Hist Cab OPago": Record "GMAPosted Payment Order";
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
                ledgerEntryLocal.SETRANGE(ledgerEntryLocal."GMAVoucher Date", FechaDesde, FechaHasta);
                ledgerEntryLocal.SETFILTER(ledgerEntryLocal."GMATax Code", 'IB-BAS');
                ledgerEntryLocal.SETFILTER(ledgerEntryLocal."GMAProvince Code", '902');

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        ledgerEntryLocal.SetFilter("GMAShortcut Dimension 1", BssiDimension)
                    else
                        ledgerEntryLocal.SetFilter("GMAShortcut Dimension 2", BssiDimension);

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
                        Proveedor.SETRANGE(Proveedor."No.", ledgerEntryLocal."GMAVendor Code");
                        if Proveedor.FIND('-') then begin
                            Campo1 := Proveedor."VAT Registration No.";

                            IF (Proveedor."VAT Registration No." = '') THEN
                                ERROR(Text005, Proveedor."No.");

                            campo1 := DELCHR(Campo1, '=', '-');

                            if Campo1 <> '' then
                                Campo1 := INSSTR((INSSTR(Campo1, '-', 3)), '-', 12);
                        end;

                        "GMAWithholding Ledger Entry".CalcFields(GMADocumentDate);

                        // Fecha de retención (DD/MM/YYYY).
                        // JCG Se solicita mostrar solo la posting date
                        // if fechaposting = true then
                        //     Campo2 := FORMAT("GMAWithholding Ledger Entry"."GMAWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>')
                        // else
                        Campo2 := FORMAT("GMAWithholding Ledger Entry".GMADocumentDate, 10, '<Day,2>/<Month,2>/<Year4>');

                        // Número de sucursal.
                        //Número de emisión
                        GMAWithhCertificateNo := DELCHR(ledgerEntryLocal."GMAWithh. Certificate No.", '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');
                        GMAWithhCertificateNo := DELCHR(GMAWithhCertificateNo, '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');
                        GMAWithhCertificateNo := DELCHR(GMAWithhCertificateNo, '=', '-+qwertyuiopasdfghjklñzxcvbnm');
                        GMAWithhCertificateNoLen := STRLEN(GMAWithhCertificateNo);

                        if GMAWithhCertificateNoLen <= 8 then
                            Campo4 := GMAWithhCertificateNo
                        else
                            Campo4 := CopyStr(GMAWithhCertificateNo, GMAWithhCertificateNoLen - 7, 8);

                        Campo4 := Campo4.PadLeft(8, ' ');

                        //Importe de la retencion
                        WHILE STRLEN(Campo5) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(ledgerEntryLocal."GMAWithholding Amount", 0.01), 0,
                        '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 DO Campo5 += '0';
                        BEGIN
                            Campo5 += CONVERTSTR(DELCHR(FORMAT(ROUND(ledgerEntryLocal."GMAWithholding Amount", 0.01), 0,
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