report 34006887 "PER EARCIBA RET PERC"
{
    caption = 'E-ARCIBA RET PERC';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("GMAWithholding Ledger Entry"; "GMAWithholding Ledger Entry")
        {
            DataItemTableView = SORTING("GMAVoucher Date") ORDER(Ascending) WHERE("GMAWithholding Type" = FILTER(Realizada));

            trigger OnPreDataItem()
            begin
                if UseDocumentDate then
                    "GMAWithholding Ledger Entry".SETRANGE("GMAWithholding Date", FechaDesde, FechaHasta)
                else
                    "GMAWithholding Ledger Entry".SETRANGE("GMAVoucher Date", FechaDesde, FechaHasta);

                "GMAWithholding Ledger Entry".SETFILTER("GMATax Code", '%1', 'IB*');
                "GMAWithholding Ledger Entry".SETFILTER(GMAValue, TipoRetencion);
                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "GMAWithholding Ledger Entry".SetFilter("GMAShortcut Dimension 1", BssiDimension)
                    else
                        "GMAWithholding Ledger Entry".SetFilter("GMAShortcut Dimension 2", BssiDimension);
            end;

            trigger OnAfterGetRecord()
            var
                WithholdingLedgerEntryTemp: record "GMAWithholding Ledger Entry";
            BEGIN

                IF (Valores.GET("GMAWithholding Ledger Entry".GMAValue)) THEN
                    IF (Valores.GMAProvince = '901') AND (Valores."GMAIs Withholding") AND (Valores."GMAIs GGII") THEN BEGIN

                        IF ("GMAWithholding Ledger Entry"."GMAWithholding Amount" >= 0) THEN BEGIN
                            WithholdingLedgerEntryTemp.RESET;
                            WithholdingLedgerEntryTemp.SETFILTER("GMAWithholding Serie Code", '%1', "GMAWithholding Ledger Entry"."GMAWithholding Serie Code");
                            WithholdingLedgerEntryTemp.SETFILTER("GMAWithholding Amount", '%1', "GMAWithholding Ledger Entry"."GMAWithholding Amount" * -1);
                            IF (NOT WithholdingLedgerEntryTemp.FindFirst()) THEN
                                "#GMAWithholdingLedgerEntry";
                        END;
                    END;
            END;
        }

        dataitem("VAT Entry"; "VAT Entry")
        {
            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", FechaDesde, FechaHasta);
                SETRANGE(Type, "VAT Entry".Type::Sale);
                SETFILTER("Document Type", '%1', "Document Type"::Invoice);
                SETRANGE("GMATax Type Loc", "VAT Entry"."GMATax Type Loc"::"Ingresos Brutos");

                AuxTempVatEntry.CopyFilters("VAT Entry");

                if (AuxTempVatEntry.FindFirst()) then begin
                    repeat
                        TempVatEntry.TRANSFERFIELDS(AuxTempVatEntry);
                        TempVatEntry.INSERT(TRUE);
                    until AuxTempVatEntry.NEXT = 0;
                end;

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);

            end;

            trigger OnAfterGetRecord()

            begin

                IF (not TempVatEntry.Get("VAT Entry"."Entry No.")) THEN
                    CurrReport.Skip();

                TaxJurisdiction.reset;
                TaxJurisdiction.SETRANGE(code, "Tax Jurisdiction Code");
                IF (TaxJurisdiction.FindFirst()) THEN
                    if (TaxJurisdiction."GMAProvince Code" = '901') then begin
                        NumeroLineas += 1;
                        "#VatEntry";
                    end;
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
                    Caption = 'Options',;

                    field(FechaDesde; FechaDesde)
                    {
                        caption = 'From date',;
                        ApplicationArea = All;
                    }

                    field(FechaHasta; FechaHasta)
                    {
                        caption = 'To date',;
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

    trigger OnPreReport()
    begin
        CR := 13;
        FL := 10;
        GMADocTypeLocalizatiInvoice := 2;
        GMADocTypeLocalizatiDebMemo := 16;
    end;



    trigger OnPostReport()
    var
        i: integer;
    begin
        i := 0;
        if NumeroLineas = 0 then
            MESSAGE(Text004)
        else begin

            /*se ordena por fecha de transaccion*/
            TempExcelBuff.SetCurrentKey(GMADate);
            TempExcelBuff.FindFirst();
            repeat
                TempExcelBuff_2.INIT;
                TempExcelBuff_2."Row No." := i;
                TempExcelBuff_2."Cell Value as Text" := TempExcelBuff."Cell Value as Text";
                TempExcelBuff_2.Comment := '';
                TempExcelBuff_2.GMADate := TempExcelBuff.GMADate;
                TempExcelBuff_2.Formula := TempExcelBuff.Formula;
                TempExcelBuff_2.INSERT;
                i := i + 1;
            until TempExcelBuff.NEXT = 0;

            //La ultima linea debe ser vacia.
            TempExcelBuff_2.INIT;
            TempExcelBuff_2."Row No." := i;
            TempExcelBuff_2."Cell Value as Text" := '';
            TempExcelBuff_2.Comment := '';
            TempExcelBuff_2.Formula := '';
            TempExcelBuff_2.INSERT;

            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuff_2);
            Xmlport.Run(XmlPort::"GMAXML ImportExport", false, false, TempExcelBuff_2);
        end;
    end;


    var
        XMLImporExport: XmlPort "GMAXML ImportExport";
        Campo1: Text[1];
        Campo2: Text[3];
        Campo3: Text[10];
        Campo4: Text[2];
        Campo5: Text[1];
        Campo5Aux: Text[20];
        Campo6: Text[16];
        FechaDesde: Date;
        Campo10Bis: Text[1];
        FechaHasta: Date;
        Proveedor: Record 23;

        InfoEmpresa: Record 79;
        Text003: label 'The date must be less or equal than to date',;
        Desde: Date;
        Hasta: Date;
        "-- -Export to CSV ----------": Integer;
        OutFile: File;
        Texto: Text[1024];
        FileName: Text[250];
        "--NAVAR1.06001": Integer;
        Anio: Integer;
        Mes: Integer;
        MesNombre: Text[30];
        NumeroLineas: Integer;
        EscribirFichero: Boolean;
        Text01: label 'File cannot be created',;
        TextoBis: BigText;
        ExportaTxt: Codeunit "GMAExporta TXT";
        TempExcelBuff: Record 370 TEMPORARY;
        TempExcelBuff_2: Record 370 TEMPORARY;
        RBMgt: Codeunit 419;
        CR: Char;
        FL: Char;
        GMADocTypeLocalizatiInvoice: Integer;
        GMADocTypeLocalizatiDebMemo: Integer;
        Valores: Record GMAValues;
        TipoRetencion: Code[50];
        alicuota: Decimal;
        Campo7: Text[10];
        CAMPO8: Text[16];
        CAMPO9: Text[16];
        CAMPO10: Text[1];
        CAMPO11: Text[11];
        CAMPO12: Text[1];
        CAMPO13: Text[11];
        CAMPO14: Text[1];
        CAMPO15: Text[30];
        CAMPO16: Text[16];
        CAMPO17: Text[16];
        CAMPO18: Text[16];
        CAMPO19: Text[5];
        CAMPO20: Text[16];
        CAMPO21: Text[16];
        CAMPO22: Text[1];
        CAMPO23: Text[10];
        Text004: label 'There is no records to generate the report',;
        nroig: Code[10];
        baseretencion: Decimal;
        otrosconceptos: Decimal;
        TextTemp: Text[20];
        TempVatEntry: Record 254 TEMPORARY;
        AuxTempVatEntry: Record 254;
        aux: Integer;
        AuxVATEntry: Record 254;
        importesumado: Decimal;
        montocomprobante: Decimal;
        RecCustomer: Record 18;
        RecGMAPostedPaymentOrder: Record "GMAPosted Payment Order";
        GMAPostedPaymentOrdVouch: Record "GMAPosted Payment Ord Vouch";
        PurchInvLine: Record "Purch. Inv. Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Purch_Inv_Header: Record "Purch. Inv. Header";
        recMovRete: Record "GMAWithholding Ledger Entry";
        GMAFiscalType: Record "GMAFiscal Type";
        TaxDetail: Record "Tax Detail";
        PurchInvAmount: Decimal;
        GMAVoucherNo_: Code[20];
        GMATaxConditions: record "GMATax Conditions";
        TaxJurisdiction: record "Tax Jurisdiction";
        calculodeverificacion: Decimal;
        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        UseDocumentDate: Boolean;


    PROCEDURE "#RellenaExcelBuff"(pTexto: Text[1024]; FechaOrden: Date);
    BEGIN
        TempExcelBuff.INIT;
        TempExcelBuff."Row No." := NumeroLineas;
        TempExcelBuff."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuff.GMADate := FechaOrden;//se guarda en este campo la fecha para luego ordernar por dicho campo
        TempExcelBuff.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuff.INSERT;
    END;

    PROCEDURE CalSalesInvAmount(DocumentNo_: Code[20]) ReturnSalesInvAmount: Decimal;
    BEGIN
        SalesInvoiceLine.RESET;
        SalesInvoiceLine.SETRANGE("Document No.", DocumentNo_);
        IF SalesInvoiceLine.FindSet() THEN
            REPEAT
                ReturnSalesInvAmount := ReturnSalesInvAmount + SalesInvoiceLine.Amount;
            UNTIL SalesInvoiceLine.NEXT = 0;
    END;



    PROCEDURE "#VatEntry"();
    var
        GMAAFIPVoucherType: Code[3];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    BEGIN

        Campo1 := '';
        Campo2 := '';
        Campo3 := '';
        Campo4 := '';
        Campo5 := '';
        Campo5Aux := '';
        Campo6 := '';
        Campo7 := '';
        CAMPO8 := '';
        CAMPO9 := '';
        CAMPO10 := '';
        CAMPO11 := '';
        CAMPO12 := '';
        CAMPO13 := '';
        CAMPO14 := '';
        CAMPO15 := '';
        CAMPO16 := '';
        CAMPO17 := '';
        CAMPO18 := '';
        CAMPO19 := '';
        CAMPO20 := '';
        CAMPO21 := '';
        CAMPO22 := '';
        CAMPO23 := '';
        importesumado := 0;
        montocomprobante := 0;
        GMAAFIPVoucherType := '';

        if ("VAT Entry"."GMADocument Type Loc." = "VAT Entry"."GMADocument Type Loc."::Invoice)
        or ("VAT Entry"."GMADocument Type Loc." = "VAT Entry"."GMADocument Type Loc."::"GMANota Debito") then begin
            if (SalesInvoiceHeader.GET("VAT Entry"."Document No.")) then
                GMAAFIPVoucherType := SalesInvoiceHeader."GMAAFIP Voucher Type"
        end
        else begin
            if (SalesCrMemoHeader.GET("VAT Entry"."Document No.")) then
                GMAAFIPVoucherType := SalesCrMemoHeader."GMAAFIP Voucher Type"
        end;


        //1 -Tipo de operación
        Campo1 := '2';

        //2 - Codigo de Norma
        Campo2 := '029';

        // 3 - Fecha de la percepción
        Campo3 := FORMAT("VAT Entry"."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        // 4 - Tipo de Comprobante


        IF "VAT Entry"."GMADocument Type Loc." = "VAT Entry"."GMADocument Type Loc."::Invoice THEN begin
            case GMAAFIPVoucherType of
                '001', '006', '011', '019', '051':
                    Campo4 := '01';
                '201', '206', '211':
                    Campo4 := '10';
                else
                    Campo4 := '09';
            end
        end;
        IF "VAT Entry"."GMADocument Type Loc." = "VAT Entry"."GMADocument Type Loc."::"GMANota Debito" THEN begin
            case GMAAFIPVoucherType of
                '202', '207', '212':
                    Campo4 := '13';
                else
                    Campo4 := '09';
            end
        end;


        //5 - Letra de Comprobante
        if ((Campo4 = '01') or (Campo4 = '10')) then begin
            RecCustomer.RESET;
            RecCustomer.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
            IF RecCustomer.FIND('-') THEN begin
                GMAFiscalType.RESET;
                GMAFiscalType.SETCURRENTKEY(GMACode);
                GMAFiscalType.SETRANGE(GMAFiscalType.GMACode, RecCustomer."GMAFiscal Type");

                IF GMAFiscalType.FIND('-') THEN BEGIN
                    Campo5 := GMAFiscalType."GMAInvoice Letter";
                END;
            end;
        end;

        //6 - nro comprobante
        Campo6 := "VAT Entry"."Document No.";
        Campo6 := DELCHR(Campo6, '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');
        Campo6 := DELCHR(Campo6, '=', '-+qwertyuiopasdfghjklñzxcvbnm');
        IF STRLEN(Campo6) > 16 THEN
            Campo6 := COPYSTR(Campo6, 1, 16);
        Campo6 := Campo6.PadLeft(16, '0');


        //7 - Fecha de Comprobante
        Campo7 := FORMAT("VAT Entry"."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //8 -Monto del comprobante
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Document No.", "GMADocument Type Loc.", "Customer No.", "Transaction No.");

        CustLedgerEntry.SetRange("Document No.", "VAT Entry"."Document No.");
        CustLedgerEntry.SetRange("GMADocument Type Loc.", "VAT Entry"."GMADocument Type Loc.");
        CustLedgerEntry.SetRange("Customer No.", "VAT Entry"."Bill-to/Pay-to No.");
        CustLedgerEntry.SetRange("Transaction No.", "VAT Entry"."Transaction No.");

        if (CustLedgerEntry.FindFirst()) then begin
            CustLedgerEntry.CALCFIELDS("Amount (LCY)");
            montocomprobante := ROUND(CustLedgerEntry."Amount (LCY)", 0.01);
        end;
        WHILE STRLEN(CAMPO8) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(montocomprobante, 0.01), 0,
         '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO8 += '0';
        BEGIN
            Campo8 += CONVERTSTR(DELCHR(FORMAT(ROUND(montocomprobante, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;

        //9 - Nro Certificado Propio
        Campo9 := Campo9.PadLeft(16, ' ');

        //10 - Tipo de documento del retenido
        RecCustomer.RESET;
        RecCustomer.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
        IF RecCustomer.FIND('-') THEN begin
            IF (RecCustomer."GMAAFIP Document Type" = '80') THEN
                CAMPO10 := '3';
            IF (RecCustomer."GMAAFIP Document Type" = '86') THEN
                CAMPO10 := '2';
            IF (RecCustomer."GMAAFIP Document Type" = '87') THEN
                CAMPO10 := '1';
        end;

        //11 - Número de documento
        RecCustomer.RESET;
        RecCustomer.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
        IF RecCustomer.FIND('-') THEN
            CAMPO11 := COPYSTR(DELCHR(RecCustomer."VAT Registration No.", '=', '-'), 1, 11);

        //12 - situacion iibb
        IF (COPYSTR(RecCustomer."GMAIIBB Code", 1, 3) = '901') OR
        (COPYSTR(RecCustomer."GMAIIBB Code", 1, 3) = '902') THEN BEGIN
            CAMPO12 := '2';

            IF STRLEN(COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(RecCustomer."GMAIIBB Code", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 10)
            ) <> 10 THEN BEGIN
                CAMPO12 := '4';
            END;
        END
        ELSE BEGIN
            IF COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(RecCustomer."GMAIIBB Code", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 1) = '0' THEN BEGIN
                CAMPO12 := '1';
                IF STRLEN(COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(RecCustomer."GMAIIBB Code", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 10)
                ) <> 10 THEN BEGIN
                    CAMPO12 := '4';
                END;
            END
            ELSE BEGIN
                CAMPO12 := '4';
            END;
        END;

        //13 - Nro Inscripción de IIBB
        RecCustomer.RESET;
        RecCustomer.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
        IF RecCustomer.FIND('-') THEN begin
            IF CAMPO12 <> '4' THEN BEGIN
                nroig := COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(RecCustomer."GMAIIBB Code", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 10)
            END
            ELSE BEGIN
                nroig := '0';
            END;
            WHILE STRLEN(CAMPO13) + STRLEN(nroig) < 11 DO CAMPO13 += '0';
            BEGIN
                CAMPO13 += nroig;
            END;
        end;

        //14 - SITUACION IVA
        GMAFiscalType.RESET;
        GMAFiscalType.SETCURRENTKEY(GMACode);
        GMAFiscalType.SETRANGE(GMAFiscalType.GMACode, RecCustomer."GMAFiscal Type");

        IF GMAFiscalType.FIND('-') THEN BEGIN

            case GMAFiscalType."GMACod 3685" of
                '01':
                    CAMPO14 := '1';
                '04':
                    CAMPO14 := '3';
                '06', '13':
                    CAMPO14 := '4';
            end;

        END;

        //15 - Razón Social del retenido
        RecCustomer.RESET;
        RecCustomer.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
        IF RecCustomer.FIND('-') THEN
            CAMPO15 := COPYSTR(DELCHR(RecCustomer.Name, '=', ','), 1, 30);

        CLEAR(importesumado);
        TempVatEntry.RESET;
        TempVatEntry.SETRANGE("Document No.", "VAT Entry"."Document No.");
        TempVatEntry.SetFilter("GMATax Type Loc", '<>%1', "VAT Entry"."GMATax Type Loc"::IVA);
        TempVatEntry.SETRANGE("Document Type", AuxVATEntry."Document Type"::Invoice);

        IF (TempVatEntry.FINDSET) THEN
            REPEAT

                IF (TempVatEntry."Entry No." <> "VAT Entry"."Entry No.") then begin
                    if TempVatEntry.Get(TempVatEntry."Entry No.") then begin
                        importesumado := importesumado + TempVatEntry.Amount;
                        TempVatEntry.delete;
                    end;
                end;

            UNTIL TempVatEntry.NEXT = 0;

        importesumado := importesumado + "VAT Entry".Amount;

        if (TempVatEntry.Get("VAT Entry"."Entry No.")) then
            TempVatEntry.delete;

        //16 - Otros Conceptos   
        otrosconceptos := ROUND(importesumado, 0.01);
        WHILE STRLEN(CAMPO16) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(otrosconceptos, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO16 += '0';
        BEGIN
            CAMPO16 += CONVERTSTR(DELCHR(FORMAT(ROUND(otrosconceptos, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;

        //17 - IVA
        AuxVATEntry.RESET;
        AuxVATEntry.SETRANGE(AuxVATEntry."Document No.", "VAT Entry"."Document No.");
        AuxVATEntry.SETRANGE(AuxVATEntry."Document Type", AuxVATEntry."Document Type"::Invoice);
        AuxVATEntry.SETRANGE(AuxVATEntry."GMATax Type Loc", "VAT Entry"."GMATax Type Loc"::IVA);

        importesumado := 0;
        IF (AuxVATEntry.FINDSET) THEN
            REPEAT
                importesumado := importesumado + ABS(AuxVATEntry.Amount);
            UNTIL AuxVATEntry.NEXT = 0;


        importesumado := ROUND(importesumado, 0.01);

        WHILE STRLEN(CAMPO17) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
           '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO17 += '0';
        BEGIN
            CAMPO17 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;
        Clear(calculodeverificacion);
        calculodeverificacion := ROUND(importesumado, 0.01);
        //O * P/100 = Q y R
        //18 - Monto sujeto a percep
        AuxVATEntry.RESET;
        AuxVATEntry.SETRANGE(AuxVATEntry."Document No.", "VAT Entry"."Document No.");
        AuxVATEntry.SETRANGE(AuxVATEntry."Document Type", AuxVATEntry."Document Type"::Invoice);
        AuxVATEntry.SETRANGE(AuxVATEntry."GMATax Type Loc", "VAT Entry"."GMATax Type Loc"::"Ingresos Brutos");
        importesumado := 0;
        IF (AuxVATEntry.FINDSET) THEN BEGIN
            REPEAT
                TaxJurisdiction.reset;
                TaxJurisdiction.SETRANGE(code, AuxVATEntry."Tax Jurisdiction Code");
                IF (TaxJurisdiction.FindFirst()) THEN
                    if (TaxJurisdiction."GMAProvince Code" = '901') then
                        importesumado := importesumado + ABS(AuxVATEntry.Base);
            UNTIL AuxVATEntry.NEXT = 0;
        END;

        IF (ABS(montocomprobante) - ABS(otrosconceptos) - ABS(calculodeverificacion)) <> importesumado THEN
            importesumado := (ABS(montocomprobante) - ABS(otrosconceptos) - ABS(calculodeverificacion));
        //DDS0507
        Clear(calculodeverificacion);
        calculodeverificacion := ROUND(importesumado, 0.01);
        WHILE STRLEN(CAMPO18) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
           '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO18 += '0';
        BEGIN
            CAMPO18 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;

        //20 - IMPORTE Percepcion

        AuxVATEntry.RESET;
        AuxVATEntry.SETRANGE(AuxVATEntry."Document No.", "VAT Entry"."Document No.");
        AuxVATEntry.SETRANGE(AuxVATEntry."Document Type", AuxVATEntry."Document Type"::Invoice);
        AuxVATEntry.SETRANGE(AuxVATEntry."GMATax Type Loc", "VAT Entry"."GMATax Type Loc"::"Ingresos Brutos");
        importesumado := 0;
        IF (AuxVATEntry.FINDSET) THEN BEGIN
            REPEAT
                TaxJurisdiction.reset;
                TaxJurisdiction.SETRANGE(code, AuxVATEntry."Tax Jurisdiction Code");
                IF (TaxJurisdiction.FindFirst()) THEN
                    if (TaxJurisdiction."GMAProvince Code" = '901') then
                        importesumado := importesumado + (AuxVATEntry.Amount);// antes ABS(AuxVATEntry.Amount)
            UNTIL AuxVATEntry.NEXT = 0;
        END;
        //solo para prueba
        //if (Confirm('debuger', false)) then;

        //solo para prueba
        //19 - Alicuota
        TaxDetail.RESET;
        TaxDetail.SETCURRENTKEY("Tax Jurisdiction Code", "Tax Group Code");
        TaxDetail.SETRANGE("Tax Jurisdiction Code", "VAT Entry"."Tax Jurisdiction Code");
        TaxDetail.SETRANGE("Tax Group Code", "VAT Entry"."Tax Group Code");

        IF (TaxDetail.FIND('-')) THEN BEGIN
            WHILE STRLEN(CAMPO19) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(TaxDetail."Tax Above Maximum", 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 5 DO CAMPO19 += '0';
            BEGIN
                CAMPO19 += CONVERTSTR(DELCHR(FORMAT(ROUND(TaxDetail."Tax Above Maximum", 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
            END;
            IF (ROUND(calculodeverificacion, 0.01) * ROUND(TaxDetail."Tax Above Maximum", 0.01) / 100) <> ROUND(importesumado, 0.01) THEN
                importesumado := ROUND(ROUND(calculodeverificacion, 0.01) * ROUND(TaxDetail."Tax Above Maximum", 0.01) / 100, 0.01);
        END;



        WHILE STRLEN(CAMPO20) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO20 += '0';
        BEGIN
            CAMPO20 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;

        //21 - TOTAL MONTO RETENIDO
        WHILE STRLEN(CAMPO21) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
      '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO21 += '0';
        BEGIN
            CAMPO21 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;


        /////////////////wdl archivo agip//////////////////////////

        CLEAR(Texto);
        Texto := (
        FORMAT(Campo1, 1, '<Text>') +
        FORMAT(Campo2, 3, '<Text>') +
        FORMAT(Campo3, 10, '<Text>') +
        FORMAT(Campo4, 2, '<Text>') +
        FORMAT(Campo5, 1, '<Text>') +
        FORMAT(Campo6, 16, '<Text>') +
        FORMAT(Campo7, 10, '<Text>') +
        FORMAT(CAMPO8, 16, '<Text>') +
        FORMAT(CAMPO9, 16, '<Text>') +
        FORMAT(CAMPO10, 1, '<Text>') +
        FORMAT(CAMPO11, 11, '<Text>') +
        FORMAT(CAMPO12, 1, '<Text>') +
        FORMAT(CAMPO13, 11, '<Text>') +
        FORMAT(CAMPO14, 1, '<Text>') +
        FORMAT(CAMPO15, 30, '<Text>') +
        FORMAT(CAMPO16, 16, '<Text>') +
        FORMAT(CAMPO17, 16, '<Text>') +
        FORMAT(CAMPO18, 16, '<Text>') +
        FORMAT(CAMPO19, 5, '<Text>') +
        FORMAT(CAMPO20, 16, '<Text>') +
        FORMAT(CAMPO21, 16, '<Text>') +
        FORMAT(CAMPO22, 1, '<Text>') +
        FORMAT(CAMPO23, 10, '<Text>')
        );


        "#RellenaExcelBuff"(Texto, "VAT Entry"."Posting Date")

    END;

    PROCEDURE "#GMAWithholdingLedgerEntry"();
    VAR
        GMAPostingDate: date;
    BEGIN
        NumeroLineas += 1;
        Campo1 := '';
        Campo2 := '';
        Campo3 := '';
        Campo4 := '';
        Campo5 := '';
        Campo5Aux := '';
        Campo6 := '';
        Campo7 := '';
        CAMPO8 := '';
        CAMPO9 := '';
        CAMPO10 := '';
        CAMPO11 := '';
        CAMPO12 := '';
        CAMPO13 := '';
        CAMPO14 := '';
        CAMPO15 := '';
        CAMPO16 := '';
        CAMPO17 := '';
        CAMPO18 := '';
        CAMPO19 := '';
        CAMPO20 := '';
        CAMPO21 := '';
        CAMPO22 := '';
        CAMPO23 := '';
        GMAPostingDate := 0D;



        GMAPostedPaymentOrdVouch.RESET;
        GMAPostedPaymentOrdVouch.SETCURRENTKEY("GMAPayment Order No.");
        GMAPostedPaymentOrdVouch.SetRange("GMAPayment Order No.", "GMAWithholding Ledger Entry"."GMAVoucher Number");
        if (GMAPostedPaymentOrdVouch.FindFirst()) then;

        RecGMAPostedPaymentOrder.Reset();
        RecGMAPostedPaymentOrder.SetRange("GMAPayment O. No.", "GMAWithholding Ledger Entry"."GMAVoucher Number");
        if (RecGMAPostedPaymentOrder.FindFirst()) then
            GMAPostingDate := RecGMAPostedPaymentOrder."GMAPosting Date";



        /////////////////wdl archivo agip//////////////////////////

        //1 - Tipo de operación
        Campo1 := '1';

        //2 - Codigo de Norma
        Campo2 := '029';

        //3 - fecha retencion
        Campo3 := FORMAT("GMAWithholding Ledger Entry"."GMAWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //4 - Tipo de Comprobante
        Campo4 := '03';

        //5 - Letra de Comprobante
        Campo5 := ' ';

        //6 - nro comprobante
        Campo6 := "GMAWithholding Ledger Entry"."GMAVoucher Number";
        Campo6 := DELCHR(Campo6, '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');
        Campo6 := DELCHR(Campo6, '=', '-+qwertyuiopasdfghjklñzxcvbnm');
        Campo6 := Campo6.PadLeft(16, '0');

        //7 - fechacomprobante
        if (Campo4 = '03') then //si tipo de cbte es 03
            Campo7 := FORMAT(GMAPostingDate, 10, '<Day,2>/<Month,2>/<Year4>')
        else
            Campo7 := FORMAT("GMAWithholding Ledger Entry"."GMAVoucher Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //8 - monto
        if (Campo4 = '03') then //si tipo de cbte es 03
        begin
            WHILE STRLEN(CAMPO8) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMACalculation Base", 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO8 += '0';
            BEGIN
                CAMPO8 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMACalculation Base", 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
            END;
        end
        else begin
            WHILE STRLEN(CAMPO8) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(GMAPostedPaymentOrdVouch.GMAAmount, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO8 += '0';
            BEGIN
                CAMPO8 += CONVERTSTR(DELCHR(FORMAT(ROUND(GMAPostedPaymentOrdVouch.GMAAmount, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
            END;
        end;

        //9 - NRO  CERTIFICADO
        WHILE STRLEN(CAMPO9) + STRLEN("GMAWithholding Ledger Entry"."GMAWithh. Certificate No.") < 16 DO CAMPO9 += ' ';
        BEGIN
            CAMPO9 += "GMAWithholding Ledger Entry"."GMAWithh. Certificate No.";
        END;

        //10 - tipo documento
        Proveedor.RESET;
        Proveedor.SETRANGE(Proveedor."No.", "GMAWithholding Ledger Entry"."GMAVendor Code");
        IF Proveedor.FIND('-') THEN BEGIN
            IF (Proveedor."GMAAFIP Document Type" = '80') THEN
                CAMPO10 := '3';
            IF (Proveedor."GMAAFIP Document Type" = '86') THEN
                CAMPO10 := '2';
            IF (Proveedor."GMAAFIP Document Type" = '87') THEN
                CAMPO10 := '1';
        END;


        //11 - Número de documento
        Proveedor.RESET;
        Proveedor.SETRANGE(Proveedor."No.", "GMAWithholding Ledger Entry"."GMAVendor Code");
        IF Proveedor.FIND('-') THEN
            CAMPO11 := COPYSTR(DELCHR(Proveedor."VAT Registration No.", '=', '-'), 1, 11);

        //12 - situacion iibb
        Proveedor.RESET;
        Proveedor.SETRANGE(Proveedor."No.", "GMAWithholding Ledger Entry"."GMAVendor Code");
        IF Proveedor.FIND('-') THEN;

        IF (COPYSTR(Proveedor."GMAGross Income Tax No", 1, 3) = '901') OR
        (COPYSTR(Proveedor."GMAGross Income Tax No", 1, 3) = '902') THEN BEGIN
            CAMPO12 := '2';

            IF STRLEN(COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(Proveedor."GMAGross Income Tax No", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 10)
            ) <> 10 THEN BEGIN
                CAMPO12 := '4';
            END;
        END
        ELSE BEGIN
            IF COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(Proveedor."GMAGross Income Tax No", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 1) = '0' THEN BEGIN
                CAMPO12 := '1';
                IF STRLEN(COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(Proveedor."GMAGross Income Tax No", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 10)
                ) <> 10 THEN BEGIN
                    CAMPO12 := '4';
                END;
            END
            ELSE BEGIN
                CAMPO12 := '4';
            END;
        END;

        //13 - Nro Inscripción de IIBB
        Proveedor.RESET;
        Proveedor.SETRANGE(Proveedor."No.", "GMAWithholding Ledger Entry"."GMAVendor Code");
        IF Proveedor.FIND('-') THEN BEGIN

            IF CAMPO12 <> '4' THEN BEGIN
                nroig := COPYSTR(DELCHR(DELCHR(DELCHR(DELCHR(Proveedor."GMAGross Income Tax No", '=', ','), '=', '-'), '=', '.'), '=', '/'), 1, 10)
            END
            ELSE BEGIN
                nroig := '0'
            END;
        END;

        WHILE STRLEN(CAMPO13) + STRLEN(nroig) < 11 DO CAMPO13 += '0';
        BEGIN
            CAMPO13 += nroig;
        END;

        //14 - SITUACION IVA
        GMAFiscalType.RESET;
        GMAFiscalType.SETCURRENTKEY(GMACode);
        GMAFiscalType.SETRANGE(GMAFiscalType.GMACode, Proveedor."GMAFiscal Type");

        IF GMAFiscalType.FIND('-') THEN BEGIN

            case GMAFiscalType."GMACod 3685" of
                '01':
                    CAMPO14 := '1';
                '04':
                    CAMPO14 := '3';
                '06', '13':
                    CAMPO14 := '4';
            end;

        END;

        //15 - Razón Social del retenido
        Proveedor.RESET;
        Proveedor.SETRANGE(Proveedor."No.", "GMAWithholding Ledger Entry"."GMAVendor Code");
        IF Proveedor.FIND('-') THEN
            CAMPO15 := COPYSTR(DELCHR(Proveedor.Name, '=', ','), 1, 30);

        //16 - Otros Conceptos
        if (Campo4 = '03') then //si tipo de cbte es 03
        begin
            CAMPO16 += CONVERTSTR(DELCHR(FORMAT(ROUND(0, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
            Campo16 := Campo16.PadLeft(16, '0');
        end
        else begin
            otrosconceptos := GMAPostedPaymentOrdVouch.GMAAmount - "GMAWithholding Ledger Entry"."GMACalculation Base";
            WHILE STRLEN(CAMPO16) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(otrosconceptos, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO16 += '0';
            BEGIN
                CAMPO16 += CONVERTSTR(DELCHR(FORMAT(ROUND(otrosconceptos, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
            END;
        end;

        //17 - IVA
        CAMPO17 := '0000000000000,00';



        //18 - BASE DE CALCULO
        WHILE STRLEN(CAMPO18) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMACalculation Base", 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO18 += '0';
        BEGIN
            CAMPO18 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMACalculation Base", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;

        GMATaxConditions.RESET;
        GMATaxConditions.SetRange("GMATax Code", "GMAWithholding Ledger Entry"."GMATax Code");
        GMATaxConditions.SetRange("GMACondition Code", "GMAWithholding Ledger Entry"."GMACondition Code");

        //19 - ALICUOTA
        if (Campo4 = '03') then //si tipo de cbte es 03
        begin
            CAMPO19 := CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMAWithholding%", 0.01), 0,
                        '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
            CAMPO19 := CAMPO19.PadLeft(5, '0');
        end
        else begin
            IF GMATaxConditions.FindFirst() THEN BEGIN
                /* WHILE STRLEN(CAMPO19) + STRLEN(GMATaxConditions."GMAAGIP GGII Code") < 5 DO CAMPO19 += '0';
                 BEGIN
                     CAMPO19 += GMATaxConditions."GMAAGIP GGII Code", 0.01;
                 END;*/
                CAMPO19 := CONVERTSTR(CAMPO19, '.', ',');
                CAMPO19 := GMATaxConditions."GMAAGIP GGII Code";
                CAMPO19 := CAMPO19.PadLeft(5, '0');
            END;
        end;

        //20 - IMPORTE RETENCION
        WHILE STRLEN(CAMPO20) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMAWithholding Amount", 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO20 += '0';
        BEGIN
            CAMPO20 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMAWithholding Amount", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;

        //21 - TOTAL MONTO RETENIDO
        WHILE STRLEN(CAMPO21) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMAWithholding Amount", 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',')) < 16 DO CAMPO21 += '0';
        BEGIN
            CAMPO21 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMAWithholding Ledger Entry"."GMAWithholding Amount", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), '.', ',');
        END;

        /////////////////wdl archivo agip//////////////////////////

        CLEAR(Texto);
        Texto := (
        FORMAT(Campo1, 1, '<Text>') +
        FORMAT(Campo2, 3, '<Text>') +
        FORMAT(Campo3, 10, '<Text>') +
        FORMAT(Campo4, 2, '<Text>') +
        FORMAT(Campo5, 1, '<Text>') +
        FORMAT(Campo6, 16, '<Text>') +
        FORMAT(Campo7, 10, '<Text>') +
        FORMAT(CAMPO8, 16, '<Text>') +
        FORMAT(CAMPO9, 16, '<Text>') +
        FORMAT(CAMPO10, 1, '<Text>') +
        FORMAT(CAMPO11, 11, '<Text>') +
        FORMAT(CAMPO12, 1, '<Text>') +
        FORMAT(CAMPO13, 11, '<Text>') +
        FORMAT(CAMPO14, 1, '<Text>') +
        FORMAT(CAMPO15, 30, '<Text>') +
        FORMAT(CAMPO16, 16, '<Text>') +
        FORMAT(CAMPO17, 16, '<Text>') +
        FORMAT(CAMPO18, 16, '<Text>') +
        FORMAT(CAMPO19, 5, '<Text>') +
        FORMAT(CAMPO20, 16, '<Text>') +
        FORMAT(CAMPO21, 16, '<Text>') +
        FORMAT(CAMPO22, 1, '<Text>') +
        FORMAT(CAMPO23, 10, '<Text>')
        );

        "#RellenaExcelBuff"(Texto, "GMAWithholding Ledger Entry"."GMAWithholding Date")

    END;

}
