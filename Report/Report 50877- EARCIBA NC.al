report 80877 "PER EARCIBA NC"
{
    caption = 'E-ARCIBA NC';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    // No. yyyy.mm.dd  Developer Company       DocNo.         Version         Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2020 09 01  DDS       MAS           Loc-Arg        NAVAR1.06       Localizacion Argentina



    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = sorting("Posting Date") order(ascending);

            trigger OnPreDataItem()
            begin
                if UseDocumentDate then
                    SetRange("Document Date", FechaDesde, FechaHasta)
                else
                    SetRange("Posting Date", FechaDesde, FechaHasta);

                SetRange("Document Type", "document type"::"Credit Memo");
                SetRange(Type, Type::Sale);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
            end;

            trigger OnAfterGetRecord()
            var
                TaxJurisdiction: Record "Tax Jurisdiction";

            begin

                If TaxJurisdiction.Get("Tax Jurisdiction Code") and (TaxJurisdiction."GMLocProvince Code" = '901') then
                    if "GMlocTax Type Loc" = "GMloctax type loc"::"Ingresos Brutos" then begin
                        recTempVatEntry.Reset;
                        recTempVatEntry.SetRange("Document No.", "External Document No.");
                        if not recTempVatEntry.FindFirst then begin
                            recTempVatEntry.Init;
                            recTempVatEntry.TransferFields("VAT Entry");
                            recTempVatEntry.Insert(false);
                        end else begin
                            recTempVatEntry.Amount += Amount;
                            recTempVatEntry.Base += Base;
                            recTempVatEntry.Modify(false);
                        end;
                    end;

            end;

            trigger OnPostDataItem()
            var
                num1: Decimal;
                num2: Decimal;
                result: Decimal;
                dec: Text[1];
                cont: Integer;
                copycont: Integer;
                cont2: Integer;
                Encontro: Boolean;
            begin
            end;


        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);

            trigger OnPreDataItem()
            begin

                recTempVatEntry.Reset;
                SetRange(Number, 1, recTempVatEntry.Count);

            end;

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    recTempVatEntry.FindFirst
                else
                    recTempVatEntry.Next;


                if recTempVatEntry.Amount <> 0 then begin
                    EscribirFichero := true;
                    NumeroLineas += 1;
                    "#VatEntry2Nuevo";
                end;

            end;


        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FechaDesde; FechaDesde)
                    {
                        ApplicationArea = Basic;
                        Caption = 'From Date';
                    }
                    field(FechaHasta; FechaHasta)
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Date';
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

    labels
    {
    }

    trigger OnPostReport()
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
            Xmlport.Run(80396, false, false, TempExcelBuff);
        end;
    end;

    trigger OnPreReport()
    begin
        CR := 13;
        FL := 10;
    end;

    var
        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        XMLImporExport: XmlPort "GMLocXML ImportExport";
        FechaDesde: Date;
        Campo10Bis: Text[1];
        FechaHasta: Date;

        Texto: Text[1024];

        NumeroLineas: Integer;
        EscribirFichero: Boolean;

        TempExcelBuff: Record "Excel Buffer" temporary;

        CR: Char;
        FL: Char;
        UseDocumentDate: Boolean;

        alicuota: Decimal;
        Campo1: Text[20];
        Campo2: Text[20];
        Campo3: Text[20];
        Campo4: Text[20];
        Campo5: Text[20];
        Campo6: Text[20];
        Campo7: Text[20];
        CAMPO8: Text[20];
        CAMPO9: Text[20];
        CAMPO10: Text[20];
        CAMPO11: Text[20];
        CAMPO12: Text[20];
        CAMPO13: Text[20];
        CAMPO14: Text[20];
        CAMPO15: Text[30];
        CAMPO16: Text[20];
        CAMPO17: Text[20];
        CAMPO18: Text[20];
        CAMPO19: Text[20];
        CAMPO20: Text[20];
        CAMPO21: Text[20];
        Text004: label 'There are no records to generate the file.';

        baseretencion: Decimal;

        importesumado: Decimal;
        RecCustomer: Record Customer;
        recTempVatEntry: Record "VAT Entry" temporary;
        importesumado2: Decimal;
        CheckImporteRetencion: Decimal;
        DocNum: Text[20];


    procedure "#RellenaExcelBuff"(pTexto: Text[1024])
    begin

        TempExcelBuff.Init;
        TempExcelBuff."Row No." := NumeroLineas;
        TempExcelBuff."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuff.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuff.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuff.Insert;
    end;





    procedure "#VatEntry2Nuevo"()
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        _recSalesInvHeader: Record "Sales Cr.Memo Header";
        _recSalesCRMemoHeader: Record "Sales Cr.Memo Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        montocomprobante: Decimal;
    begin

        EscribirFichero := true;
        NumeroLineas += 1;

        Campo1 := '';
        Campo2 := '';
        Campo3 := '';
        Campo4 := '';
        Campo5 := '';
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


        //Tipo Operacion 1 REtencion 2 percepcion

        Campo1 := '2';

        Campo2 := recTempVatEntry."Document No.";
        Campo2 := DelChr(Campo2, '=', '- +QWERTYUIOPASDFGHJKLÑZXCVBNM');
        Campo2 := DelChr(Campo2, '=', 'qwertyuiopasdfghjklñzxcvbnm.-!"#$%&/()=+?¡/');
        while StrLen(Campo2) < 12 do
            Campo2 += '0';

        //fecha retencion
        Campo3 := Format(recTempVatEntry."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //Tipo Comprobante
        //13082-
        CLEAR(montocomprobante);
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Document No.", "GMLocDocument Type Loc.", "Customer No.", "Transaction No.");

        CustLedgerEntry.SetRange("Document No.", "VAT Entry"."Document No.");
        CustLedgerEntry.SetRange("Document Type", "VAT Entry"."Document Type");
        if (CustLedgerEntry.FindFirst()) then begin
            CustLedgerEntry.CALCFIELDS("Amount (LCY)");
            montocomprobante := CustLedgerEntry."Amount (LCY)";
        end;

        _recSalesCRMemoHeader.Reset;
        _recSalesCRMemoHeader.SetRange("No.", recTempVatEntry."Document No.");
        if _recSalesCRMemoHeader.FindFirst then;
        //_recSalesCRMemoHeader.CalcFields(Amount);

        while StrLen(Campo4) + StrLen(ConvertStr(DelChr(Format(ROUND(montocomprobante, 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 16 do Campo4 += '0';
        begin
            Campo4 += ConvertStr(DelChr(Format(ROUND(montocomprobante, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        end;


        Campo5 := '0000000000000000';
        Campo6 := '01';
        case _recSalesCRMemoHeader."GMlocAFIP Voucher Type" of
            '08':
                Campo7 := 'B';
            else
                Campo7 := 'A';
        end;

        Clear(DocNum);

        DocNum := "#FindDocument"(recTempVatEntry."Document No.", _recSalesCRMemoHeader."Pre-Assigned No.");

        DocNum := DelChr(DocNum, '=', '- QWERTYUIOPASDFGHJKLÑZXCVBNM');
        DocNum := DelChr(DocNum, '=', 'qwertyuiopasdfghjklñzxcvbnm');
        while StrLen(DocNum) < 16 do

            DocNum := '0' + DocNum;


        CAMPO8 := DocNum;


        //CUIT
        RecCustomer.Reset;
        RecCustomer.SetCurrentkey("No.");
        RecCustomer.SetRange("No.", recTempVatEntry."Bill-to/Pay-to No.");
        if RecCustomer.FindFirst then
            CAMPO9 := CopyStr(DelChr(RecCustomer."VAT Registration No.", '=', '-'), 1, 11);
        while StrLen(CAMPO9) < 11 do
            CAMPO9 += '0' + CAMPO9;

        Clear(importesumado);
        Clear(importesumado2);
        Clear(baseretencion);
        Clear(alicuota);

        importesumado := recTempVatEntry.Amount;
        importesumado2 := recTempVatEntry.Base;
        baseretencion := recTempVatEntry.Base;


        if importesumado2 <> 0 then
            alicuota := (importesumado / importesumado2) * 100
        else
            alicuota := (importesumado / 1) * 100;

        case ROUND(alicuota, 1) of

            0.01:
                CAMPO10 := '002';
            0.1:
                CAMPO10 := '003';
            0.2:
                CAMPO10 := '004';
            0.5:
                CAMPO10 := '005';
            0.75:
                CAMPO10 := '006';
            1.0:
                CAMPO10 := '007';
            1.5:
                CAMPO10 := '008';
            2.0:
                CAMPO10 := '009';
            2.5:
                CAMPO10 := '010';
            3.0:
                CAMPO10 := '011';
            3.5:
                CAMPO10 := '012';
            4.0:
                CAMPO10 := '013';
            4.5:
                CAMPO10 := '014';
            5.0:
                CAMPO10 := '015';
            6.0:
                CAMPO10 := '016';
            else
                CAMPO10 := '001';
        end;
        CAMPO10 := '029';


        if (CAMPO11 = '') then
            CAMPO11 := Campo3;

        //IMPORTE RETENCION

        CheckImporteRetencion := ROUND(((ROUND(baseretencion, 0.01) * ROUND(alicuota, 0.01)) / 100), 0.01);
        if CheckImporteRetencion <> importesumado then
            if (Abs(CheckImporteRetencion - importesumado)) < 0.2 then
                importesumado := CheckImporteRetencion;

        while StrLen(CAMPO12) + StrLen(ConvertStr(DelChr(Format(ROUND(importesumado, 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 16 do CAMPO12 += '0';
        begin
            CAMPO12 += ConvertStr(DelChr(Format(ROUND(importesumado, 0.01), 0,
           '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        end;

        //ALICUOTA
        while StrLen(CAMPO13) + StrLen(ConvertStr(DelChr(Format(ROUND(alicuota, 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 5 do CAMPO13 += '0';
        begin
            CAMPO13 += ConvertStr(DelChr(Format(ROUND(alicuota, 0.01), 0,
           '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        end;

        Clear(Texto);
        Texto := (
        Format(Campo1, 1, '<Text>') +
        Format(Campo2, 12, '<Text>') +
        Format(Campo3, 10, '<Text>') +
        Format(Campo4, 16, '<Text>') +
        Format(Campo5, 16, '<Text>') +
        Format(Campo6, 2, '<Text>') +
        Format(Campo7, 1, '<Text>') +
        Format(CAMPO8, 16, '<Text>') +
        Format(CAMPO9, 11, '<Text>') +
        Format(CAMPO10, 3, '<Text>') +
        Format(CAMPO11, 10, '<Text>') +
        Format(CAMPO12, 16, '<Text>') +
        Format(CAMPO13, 5, '<Text>'));


        "#RellenaExcelBuff"(Texto);

    end;


    procedure "#FindDocument"(DocNC: Code[20]; PreAssignedNo: code[20]) ReturnValue: Text[20]
    var
        LocCustLedgerEntry: Record "Cust. Ledger Entry";
        LocCustLedgerEntry2: Record "Cust. Ledger Entry";
        ValueEntry: Record "Value Entry";
        ItemAplicationEntry: Record "Item Application Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        GMLocInvoicingRelatedDocs: Record "GMLoc Invoicing Related Docs";
    begin
        if (PreAssignedNo <> '') then BEGIN
            GMLocInvoicingRelatedDocs.Reset();
            GMLocInvoicingRelatedDocs.SetRange(GMLocInvoicingRelatedDocs."GMLoc Document No.", PreAssignedNo);
            IF GMLocInvoicingRelatedDocs.FindFirst() then begin
                SalesInvoiceHeader.Reset();
                SalesInvoiceHeader.SetRange(SalesInvoiceHeader."No.", GMLocInvoicingRelatedDocs."GMLoc Related Document No.");
                IF SalesInvoiceHeader.FindFirst() then
                    ReturnValue := GMLocInvoicingRelatedDocs."GMLoc Related Document No.";
                Clear(CAMPO11);
                CAMPO11 := Format(SalesInvoiceHeader."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');
            end;
        END
        else begin
            LocCustLedgerEntry.Reset;
            LocCustLedgerEntry.SetRange(LocCustLedgerEntry."Document No.", DocNC);
            LocCustLedgerEntry.SetRange(LocCustLedgerEntry."Document Type", LocCustLedgerEntry."document type"::Invoice);
            LocCustLedgerEntry.SetRange(LocCustLedgerEntry."Document Type", LocCustLedgerEntry."document type"::"Credit Memo");
            if (LocCustLedgerEntry.FindFirst) then begin
                LocCustLedgerEntry2.Reset;
                LocCustLedgerEntry2.SetRange(LocCustLedgerEntry2."Closed by Entry No.", LocCustLedgerEntry."Entry No.");
                if (LocCustLedgerEntry2.FindFirst) then begin
                    ReturnValue := LocCustLedgerEntry2."Document No.";
                    Clear(CAMPO11);
                    CAMPO11 := Format(LocCustLedgerEntry2."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');
                end
                else begin
                    //++@r ARIBM.FVA-070601 @v 29598 @m 1
                    ValueEntry.Reset;
                    ValueEntry.SetCurrentkey("Document No.", "Posting Date");
                    ValueEntry.SetRange(ValueEntry."Document No.", DocNC);
                    ValueEntry.SetFilter(ValueEntry."Item Ledger Entry Quantity", '<>%1', 0);
                    if (ValueEntry.FindFirst) then begin
                        ItemAplicationEntry.Reset;
                        ItemAplicationEntry.SetCurrentkey("Item Ledger Entry No.", "Output Completely Invd. Date");
                        ItemAplicationEntry.SetRange("Item Ledger Entry No.", ValueEntry."Item Ledger Entry No.");
                        if (ItemAplicationEntry.FindFirst) then begin
                            if (ItemLedgerEntry.Get(ItemAplicationEntry."Outbound Item Entry No.")) then
                                if (ItemLedgerEntry."Order No." <> '') then begin
                                    SalesInvoiceHeader.Reset;
                                    SalesInvoiceHeader.SetCurrentkey("Order No.");
                                    SalesInvoiceHeader.SetRange("Order No.", ItemLedgerEntry."Order No.");
                                    if (SalesInvoiceHeader.FindLast) then begin
                                        ReturnValue := SalesInvoiceHeader."No.";
                                        Clear(CAMPO11);
                                        CAMPO11 := Format(SalesInvoiceHeader."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');
                                    end;
                                end;
                        end;
                    end
                    else

                        if (LocCustLedgerEntry."Closed by Entry No." <> 0) then begin
                            LocCustLedgerEntry2.Reset;
                            LocCustLedgerEntry2.SetRange(LocCustLedgerEntry2."Entry No.", LocCustLedgerEntry."Closed by Entry No.");
                            if (LocCustLedgerEntry2.FindFirst) then begin
                                ReturnValue := LocCustLedgerEntry2."Document No.";
                                Clear(CAMPO11);
                                CAMPO11 := Format(LocCustLedgerEntry2."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');
                            end;
                        end
                        else
                            ReturnValue := '';
                end;
            end;

        end;
    end;
}

