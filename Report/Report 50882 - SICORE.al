report 80882 "PER SICORE"
{
    Caption = 'SICORE';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("GMLocWithholding Ledger Entry"; "GMLocWithholding Ledger Entry")
        {

            trigger OnPreDataItem()
            begin
                Desde := DMY2DATE(1, Mes, Anio);
                "GMLocWithholding Ledger Entry".SetCurrentKey("GMLocNo.");
                SETRANGE("GMLocWithholding Ledger Entry"."GMLocWithholding Type", "GMLocWithholding Ledger Entry"."GMLocWithholding Type"::Realizada);
                EVALUATE(Hasta, FORMAT(CALCDATE('+1M', Desde) - 1));
                // if UseDocumentDate then
                //     SETRANGE("GMLocWithholding Date", Desde, Hasta)
                // else
                //     SETRANGE("GMLocVoucher Date", Desde, Hasta);
                //DDS03072025
                "GMLocWithholding Ledger Entry".CalcFields(GMLocDocumentDate);
                //DDS03072025
                IF (fechaposting) Then
                    "GMLocWithholding Ledger Entry".SetRange("GMLocWithholding Ledger Entry"."GMLocWithholding Date", Desde, Hasta)
                else
                    "GMLocWithholding Ledger Entry".SetRange("GMLocWithholding Ledger Entry".GMLocDocumentDate, Desde, Hasta);

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "GMLocWithholding Ledger Entry".SetFilter("GMLocShortcut Dimension 1", BssiDimension)
                    else
                        "GMLocWithholding Ledger Entry".SetFilter("GMLocShortcut Dimension 2", BssiDimension);
            end;

            trigger OnAfterGetRecord()
            var
                WithholdingLedgerEntryTemp: record "GMLocWithholding Ledger Entry";
            BEGIN
                IF ("GMLocWithholding Ledger Entry"."GMLocSICORE Code" <> '') THEN BEGIN
                    IF (("GMLocWithholding Ledger Entry"."GMLocSICORE Code" = '217') OR
                    ("GMLocWithholding Ledger Entry"."GMLocSICORE Code" = '218') OR
                    ("GMLocWithholding Ledger Entry"."GMLocSICORE Code" = '767')) THEN BEGIN
                        IF ("GMLocWithholding Ledger Entry"."GMLocWithholding Amount" >= 0) THEN BEGIN
                            WithholdingLedgerEntryTemp.RESET;
                            WithholdingLedgerEntryTemp.SETFILTER("GMLocWithholding Serie Code", '%1', "GMLocWithholding Ledger Entry"."GMLocWithholding Serie Code");
                            WithholdingLedgerEntryTemp.SETFILTER("GMLocWithholding Amount", '%1', "GMLocWithholding Ledger Entry"."GMLocWithholding Amount" * -1);
                            IF (NOT WithholdingLedgerEntryTemp.FindFirst()) THEN
                                "#LedgerEntry";
                        END;
                    END;
                END;
            END;
        }

        dataitem("VAT Entry"; "VAT Entry")
        {
            trigger OnPreDataItem()
            var
            begin

                FechaDesde := DMY2DATE(1, Mes, Anio);
                EVALUATE(FechaHasta, FORMAT(CALCDATE('+1M', FechaDesde) - 1));
                SETRANGE("Posting Date", FechaDesde, FechaHasta);
                SETRANGE(Type, "VAT Entry".Type::Sale);
                SETFILTER("Document Type", '%1|%2|%3', "Document Type"::Invoice, "Document Type"::"Credit Memo", "GMLocDocument Type Loc."::"Nota Débito");
                Clear(txtVar);
                txtVar := GetFilter("GMLocTax Type Loc");
                if txtVar = '' then SETRANGE("GMLocTax Type Loc", "VAT Entry"."GMLocTax Type Loc"::"IVA Percepcion");

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        "VAT Entry".SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
            end;

            trigger OnAfterGetRecord()
            begin
                NumeroLineas += 1;
                "#VatEntry";
            end;
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
                        ApplicationArea = All;
                        Caption = 'Year';
                        trigger OnValidate()
                        begin
                            Separador := '.';

                        end;
                    }
                    field(Mes; Mes)
                    {
                        ApplicationArea = all;
                        Caption = 'Month',;
                    }
                    // field(UseDocumentDate; UseDocumentDate)
                    // {
                    //     Caption = 'Use Document Date';
                    //     ApplicationArea = ALL;
                    //     ToolTip = 'If enabled, filters by Document Date; otherwise, filters by Posting Date.';
                    // }
                    field(separador; separador)
                    {
                        ApplicationArea = all;
                        Caption = 'Separador';
                        trigger OnValidate()
                        begin
                            IF (Separador <> ',') AND (Separador <> '.') THEN
                                ERROR('El separador debe ser o punto(.) o coma(,)');

                        end;
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

    trigger OnPreReport()
    begin
        CR := 13;
        FL := 10;
        CodCbteNotaCredito := '03';
        CodCbteRecSueldo := '08';
        GMLocGrossIncomeVendorType := 1;
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
            Xmlport.Run(80396, false, false);
        end;
    end;

    var
        InfoEmpresa: Record "Dimension Value";
        XMLImporExport: XmlPort "GMLocXML ImportExport";
        Campo1: Text[2];
        Campo2: Text[10];
        Campo3: Text[16];
        Campo4: Text[16];
        Campo5: Text[4];
        Campo6: Text[3];
        Campo7: Text[1];
        Campo8: Text[14];
        Campo9: Text[10];
        Campo10: Text[2];
        Campo10Aux: Text[50];
        Campo10Bis: Text[1];
        Campo11: Text[14];
        Campo12: Text[6];
        Campo13: Text[10];
        Campo14: Text[2];
        Campo15: Text[20];
        Campo16: Text[14];
        Campo17: Text[30];
        Campo18: Text[1];
        Campo19: Text[11];
        Campo20: Text[11];
        FechaDesde: Date;
        FechaHasta: Date;
        Proveedor: Record 23;
        Desde: Date;
        Hasta: Date;
        Texto: Text[1024];
        Anio: Integer;
        Mes: Integer;
        NumeroLineas: Integer;
        TempExcelBuff: Record 370 TEMPORARY;
        CR: Char;
        FL: Char;
        Text004: label 'There is no records to generate the report',;
        TextTemp: Text[20];
        RecVendor: Record 23;
        RecCustomer: Record 18;
        importesumado: Decimal;
        auxvatentry: Record 254;
        CodCbteNotaCredito: Text[2];
        CodCbteRecSueldo: Text[2];
        GMLocGrossIncomeVendorType: Integer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMHeader: Record "Sales Cr.Memo Header";
        separador: Text[1];
        nroComprobante: text;
        txtVar: Text;
        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        UseDocumentDate: Boolean;
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

    PROCEDURE "#VatEntry"();
    BEGIN
        //12198-
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
        Campo10Aux := '';
        Campo11 := '';
        Campo12 := '';
        Campo13 := '';
        Campo14 := '';
        Campo15 := '';
        Campo16 := '';
        Campo17 := '';
        Campo18 := '';
        Campo19 := '';
        Campo20 := '';

        TextTemp := '';



        //Codigo de Comprobante
        SalesInvoiceHeader.RESET;
        SalesInvoiceHeader.SETCURRENTKEY("No.");
        SalesInvoiceHeader.SETRANGE("No.", "VAT Entry"."Document No.");
        IF SalesInvoiceHeader.FINDFIRST THEN
            if (StrLen(SalesInvoiceHeader."GMLocAFIP Voucher Type") = 3) then
                Campo1 := DelStr(SalesInvoiceHeader."GMLocAFIP Voucher Type", 1, 1)
            else
                Campo1 := SalesInvoiceHeader."GMLocAFIP Voucher Type"
        else begin
            SalesCrMHeader.Reset();
            SalesCrMHeader.SetCurrentKey("No.");
            SalesCrMHeader.SetRange("No.", "VAT Entry"."Document No.");
            if SalesCrMHeader.FindFirst() then
                if (StrLen(SalesCrMHeader."GMLocAFIP Voucher Type") = 3) then
                    Campo1 := DelStr(SalesCrMHeader."GMLocAFIP Voucher Type", 1, 1)
                else
                    Campo1 := SalesCrMHeader."GMLocAFIP Voucher Type"
        end;

        //Fecha de emisión del comprobante 
        Campo2 := FORMAT("VAT Entry"."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //Número del comprobante
        Campo3 := "VAT Entry"."Document No.";
        Campo3 := DELCHR(Campo3, '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');
        Campo3 := DELCHR(Campo3, '=', '-+qwertyuiopasdfghjklñzxcvbnm');
        Campo3 := Campo3.PadLeft(16, ' ');

        auxvatentry.RESET;
        auxvatentry.SETRANGE(auxvatentry."Document No.", "VAT Entry"."Document No.");

        IF (auxvatentry.FINDSET) THEN
            REPEAT
                importesumado := importesumado + auxvatentry.Amount;
            UNTIL auxvatentry.NEXT = 0;
        importesumado := importesumado + "VAT Entry".Base;

        //Importe del Comprobante
        WHILE STRLEN(Campo4) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
         '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 16 DO Campo4 += ' ';
        BEGIN
            Campo4 += CONVERTSTR(DELCHR(FORMAT(ROUND(importesumado, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        END;

        //Codigo de Impuesto
        Campo5 := '0767';

        //Codigo de Regimen
        Campo6 := '493';

        //Codigo de Operación
        Campo7 := '2';


        WHILE STRLEN(Campo8) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("VAT Entry".Base, 0.01), 0,
             '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 14 DO Campo8 += ' ';
        BEGIN
            Campo8 += CONVERTSTR(DELCHR(FORMAT(ROUND("VAT Entry".Base, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        END;

        Campo9 := FORMAT("VAT Entry"."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');


        //C¢digo de condici¢n
        RecCustomer.RESET;
        RecCustomer.SETCURRENTKEY("No.");
        IF RecCustomer.FINDFIRST THEN BEGIN
            Campo10Aux := RecCustomer."GMLocFiscal Type";
            Campo10 := Campo10Aux.Substring(1, 2);
            case Campo10 of
                '04':
                    Campo10 := '10';
                '05', '07':
                    Campo10 := '03';
                '06', '11', '12':
                    Campo10 := '01';
                '08', '09':
                    Campo10 := '00';
            end;

        END;

        // AW - Retención practicada [1]
        Campo10Bis := '0';

        //Importe de la retencion (percepcion)
        WHILE STRLEN(Campo11) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("VAT Entry".Amount, 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 14 DO Campo11 += '0';
        BEGIN
            Campo11 += CONVERTSTR(DELCHR(FORMAT(ROUND("VAT Entry".Amount, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        END;
        //Porcentaje de exclusi¢n
        Campo12 := '000,00';//actulmente no esta implmenteado en la Loc para ingresar este dato

        //Fecha de emision del boletin
        Campo13 := '01/01/1900'; //actulmente no esta implmenteado en Loc para ingresar este dato

        //Tipo de documento del retenido
        Campo14 := RecVendor."GMLocAFIP Document Type";

        //N£mero de documento del retenido
        RecCustomer.RESET;
        RecCustomer.SETCURRENTKEY("No.");
        RecCustomer.SETRANGE("No.", "VAT Entry"."Bill-to/Pay-to No.");
        IF RecCustomer.FINDFIRST THEN BEGIN
            Campo15 := DELCHR(RecCustomer."VAT Registration No.", '=', '-');
            Campo15 := DELCHR(Campo15, '=', '-');
            Campo15 := Campo15.PadLeft(20, '0');
        END;


        CLEAR(Texto);
        Texto := (
        FORMAT(Campo1, 2, '<Text>') +
        FORMAT(Campo2, 10, '<Text>') +
        FORMAT(Campo3, 16, '<Text>') +
        FORMAT(Campo4, 16, '<Text>') +
        FORMAT(Campo5, 4, '<Text>') +
        FORMAT(Campo6, 3, '<Text>') +
        FORMAT(Campo7, 1, '<Text>') +
        FORMAT(Campo8, 14, '<Text>') +
        FORMAT(Campo9, 10, '<Text>') +
        FORMAT(Campo10, 2, '<Text>') +
        //>> NAVAR1.06001
        FORMAT(Campo10Bis, 1, '<Text>') +
        //<< NAVAR1.06001
        FORMAT(Campo11, 14, '<Text>') +
        FORMAT(Campo12, 6, '<Text>') +
        FORMAT(Campo13, 10, '<Text>') +
        FORMAT(Campo14, 2, '<Text>') +
        FORMAT(Campo15, 20, '<Text>') +

        //>> NAVAR1.06001
        //El formato requiere que los siguientes campos se impriman vacios

        FORMAT(Campo16, 14, '<Text>') +
        FORMAT(Campo17, 30, '<Text>') +
        FORMAT(Campo18, 1, '<Text>') +
        FORMAT(Campo19, 11, '<Text>') +
        FORMAT(Campo20, 11, '<Text>'));
        //<< NAVAR1.06001

        "#RellenaExcelBuff"(Texto)

        //12198+
    END;

    PROCEDURE "#LedgerEntry"();
    var
        CompPago: Record "GMLocPosted Payment Ord Vouch";
        PIH: Record "Purch. Inv. Header";
        PICM: Record "Purch. Cr. Memo Hdr.";
        "GMLocPosted Payment Order Valu": Record "GMLocPosted Payment Order Valu";
        "Hist Cab OPago": Record "GMLocPosted Payment Order";
    BEGIN
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
        Campo10Aux := '';
        Campo11 := '';
        Campo12 := '';
        Campo13 := '';
        Campo14 := '';
        Campo15 := '';
        Campo16 := '';
        Campo17 := '';
        Campo18 := '';
        Campo19 := '';
        Campo20 := '';

        NumeroLineas += 1;

        //>> NAVAR1.06001
        Campo10Bis := '';
        //<< NAVAR1.06001

        //Codigo de comprobante
        Campo1 := "GMLocWithholding Ledger Entry"."GMLocVoucher Code";

        "GMLocWithholding Ledger Entry".CalcFields(GMLocDocumentDate);

        //Fecha de emision del comprobante (DD/MM/YYYY)
        // JCG Se solicita mostrar solo la posting date
        // if fechaposting = true then
        //     Campo2 := FORMAT("GMLocWithholding Ledger Entry"."GMLocWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>')
        // else
        Campo2 := FORMAT("GMLocWithholding Ledger Entry".GMLocDocumentDate, 10, '<Day,2>/<Month,2>/<Year4>');


        //N£mero del comprobante
        CLEAR(nroComprobante);
        nroComprobante := DELCHR("GMLocWithholding Ledger Entry"."GMLocVoucher Number", '=', 'QWERTYUIOPLKJHGFDSAZXCVBNM');
        WHILE STRLEN(Campo3) + STRLEN(COPYSTR(nroComprobante, 5, STRLEN(
        nroComprobante))) < 16 DO Campo3 += '0';
        Campo3 += COPYSTR(nroComprobante, 5, STRLEN(nroComprobante));
        Campo3 := DELCHR(Campo3, '=', '-+QWERTYUIOPASDFGHJKLÑZXCVBNM');



        //Importe del comprobante
        /*WHILE STRLEN(Campo4) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocVoucher Amount", 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador)) < 16 DO Campo4 += '0';
        BEGIN
            Campo4 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocVoucher Amount", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador);
        END;*/

        //Se está utilizando el valor del Amount, se pidió que se utilice el valor de la Base. LAC 08022024
        WHILE STRLEN(Campo4) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocBase", 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador)) < 16 DO Campo4 += '0';
        BEGIN
            Campo4 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocBase", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador);
        END;


        //C¢digo de impuesto
        WHILE STRLEN(Campo5) + STRLEN("GMLocWithholding Ledger Entry"."GMLocSicore Code") < 4 DO Campo5 += '0';
        Campo5 += "GMLocWithholding Ledger Entry"."GMLocSicore Code";
        //C¢digo de regimen
        IF "GMLocWithholding Ledger Entry"."GMLocTax System" = '27' THEN BEGIN
            Campo6 := '078';
        END ELSE BEGIN

            IF STRLEN("GMLocWithholding Ledger Entry"."GMLocTax System") > 3 THEN
                Campo6 := COPYSTR("GMLocWithholding Ledger Entry"."GMLocTax System", STRLEN("GMLocWithholding Ledger Entry"."GMLocTax System") - 3, 3)
            ELSE BEGIN
                WHILE STRLEN(Campo6) + STRLEN("GMLocWithholding Ledger Entry"."GMLocTax System") < 3 DO Campo6 += '0';
                Campo6 += "GMLocWithholding Ledger Entry"."GMLocTax System";
            END;
        END;

        //C¢digo de operaci¢n
        IF ("GMLocWithholding Ledger Entry"."GMLocOperation Code" = 0) THEN
            campo7 := '1'
        else
            Campo7 := FORMAT("GMLocWithholding Ledger Entry"."GMLocOperation Code");

        //Base de calculo
        //>> NAVAR1.06001
        IF "GMLocWithholding Ledger Entry"."GMLocCalculation Base" <> 0 THEN BEGIN
            WHILE STRLEN(Campo8) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocCalculation Base", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador)) < 14 DO Campo8 += '0';
            BEGIN
                Campo8 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocCalculation Base", 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador);
            END;
        END ELSE
            Campo8 := '00000000000000';
        //<< NAVAR1.06001

        //Fecha de emision de la retencion (DD/MM/YYYY)
        Campo9 := FORMAT("GMLocWithholding Ledger Entry"."GMLocWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //C¢digo de condici¢n
        /*
        RecVendor.RESET;
        RecVendor.SETCURRENTKEY("No.");
        IF RecVendor.FINDFIRST THEN BEGIN
            Campo10Aux := RecVendor."GMLocFiscal Type";
            RecVendor.TestField("GMLocFiscal Type");
            Campo10 := Campo10Aux.Substring(1, 2);
            case Campo10 of
                '04':
                    Campo10 := '10';
                '05', '07':
                    Campo10 := '03';
                '06', '11', '12':
                    Campo10 := '01';
                '08', '09':
                    Campo10 := '00';
            end;

        END;

        // Retenci¢n practicada a sujetos suspendidos según:
        Campo10Bis := '0';
        */// se comento y se paso como estaba en deloitte art
          //Código de condición
          //from deloitte
        Campo10 := '01';


        // Retención practicada a sujetos suspendidos según:
        IF (Campo10 <> '17') AND (Campo10 <> '16') THEN // Ninguno
            Campo10Bis := '0';
        IF Campo10 = '16' THEN // Art. 40 Inciso A
            Campo10Bis := '1';
        IF Campo10 = '17' THEN // Art. 40 Inciso B
            Campo10Bis := '2';
        //from deloitte

        //Importe de la retencion
        WHILE STRLEN(Campo11) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocWithholding Amount", 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador)) < 14 DO Campo11 += '0';
        BEGIN
            Campo11 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocWithholding Amount", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador);
        END;

        //Porcentaje de exclusión
        WHILE STRLEN(Campo12) + STRLEN(CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocExemption %", 0.01), 0,
        '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador)) < 6 DO Campo12 += '0';
        BEGIN
            Campo12 += CONVERTSTR(DELCHR(FORMAT(ROUND("GMLocWithholding Ledger Entry"."GMLocExemption %", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', Separador);
        END;

        //Fecha de emision del boletin
        IF "GMLocWithholding Ledger Entry"."GMLocBulletin Date" <> 0D THEN
            Campo13 := FORMAT("GMLocWithholding Ledger Entry"."GMLocBulletin Date", 10, '<Day,2>/<Month,2>/<Year4>')
        ELSE
            Campo13 := FORMAT("GMLocWithholding Ledger Entry"."GMLocWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //Tipo de documento del retenido
        Proveedor.RESET;
        Proveedor.SETCURRENTKEY("No.");
        Proveedor.SETRANGE(Proveedor."No.", "GMLocWithholding Ledger Entry"."GMLocVendor Code");
        IF Proveedor.FINDFIRST THEN
            Campo14 := Proveedor."GMLocAFIP Document Type";

        //Número de documento del retenido
        Proveedor.RESET;
        Proveedor.SETCURRENTKEY("No.");
        Proveedor.SETRANGE(Proveedor."No.", "GMLocWithholding Ledger Entry"."GMLocVendor Code");
        IF Proveedor.FINDFIRST THEN BEGIN
            //
            IF Proveedor."VAT Registration No." <> '' THEN BEGIN
                Campo15 := Proveedor."VAT Registration No.";
            END
            else begin
                CompPago.reset();
                CompPago.SetRange(CompPago."GMLocPayment Order No.", "GMLocWithholding Ledger Entry"."GMLocVoucher Number");
                if CompPago.findfirst() then
                    repeat
                        IF (PIH.GET(CompPago."GMLocVoucher No.") and (PIH."VAT Registration No." <> '')) THEN begin
                            Campo15 := PIH."VAT Registration No.";
                        end
                        else begin
                            IF (PICM.GET(CompPago."GMLocVoucher No.") and (PICM."VAT Registration No." <> '')) THEN begin
                                Campo15 := PICM."VAT Registration No.";
                            end;
                        end;
                    until (CompPago.Next() = 0) OR (Campo15 <> '');
            end;
        end
        else
            Campo15 := "GMLocWithholding Ledger Entry"."GMLocVendor Code";

        //
        //Campo15 := Proveedor."VAT Registration No.";
        //Proveedor.TestField("VAT Registration No.");
        Campo15 := DELCHR(Campo15, '=', '-');
        Campo15 := Campo15.PadLeft(20, '0');

        //Número certificado original
        CLEAR(nroComprobante);
        nroComprobante := DELCHR("GMLocWithholding Ledger Entry"."GMLocWithh. Certificate No.", '=', 'QAZWSXEDCRFVTGBNHYUJMKIOLP-_/Ñ*');
        WHILE STRLEN(Campo16) + STRLEN(nrocomprobante) < 14 DO Campo16 += '0';
        Campo16 += DELCHR(nroComprobante, '=', 'QAZWSXEDCRFVTGBNHYUJMKIOLP-_/Ñ*');

        Campo17 := '00002020';
        WHILE STRLEN(Campo17) + STRLEN(nroComprobante) < 22 DO Campo17 += '0';
        Campo17 += nroComprobante;

        Campo18 := ' ';
        Campo19 := '           ';
        InfoEmpresa.Reset();
        InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        InfoEmpresa.SetFilter(code, BssiDimension);
        InfoEmpresa.FindFirst();

        Campo20 := DELCHR(InfoEmpresa.BssiTaxRegistrationNumber, '=', '-');
        CLEAR(Texto);
        Texto := (
        FORMAT(Campo1, 2, '<Text>') +
        FORMAT(Campo2, 10, '<Text>') +
        FORMAT(Campo3, 16, '<Text>') +
        FORMAT(Campo4, 16, '<Text>') +
        FORMAT(Campo5, 4, '<Text>') +
        FORMAT(Campo6, 3, '<Text>') +
        FORMAT(Campo7, 1, '<Text>') +
        FORMAT(Campo8, 14, '<Text>') +
        FORMAT(Campo9, 10, '<Text>') +
        FORMAT(Campo10, 2, '<Text>') +
        //>> NAVAR1.06001
        FORMAT(Campo10Bis, 1, '<Text>') +
        //<< NAVAR1.06001
        FORMAT(Campo11, 14, '<Text>') +
        FORMAT(Campo12, 6, '<Text>') +
        FORMAT(Campo13, 10, '<Text>') +
        FORMAT(Campo14, 2, '<Text>') +
        FORMAT(Campo15, 20, '<Text>') +
        //>> NAVAR1.06001
        //El formato requiere que los siguientes campos se impriman vacios
        FORMAT(Campo16, 14, '<Text>') +
        FORMAT(Campo17, 30, '<Text>') +
        FORMAT(Campo18, 1, '<Text>') +
        FORMAT(Campo19, 11, '<Text>') +
        FORMAT(Campo20, 11, '<Text>'));
        //<< NAVAR1.06001

        //>> NAVAR1.06001
        "#RellenaExcelBuff"(Texto)
        //<< NAVAR1.06001
    END;
}