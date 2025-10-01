page 34006999 "locExtendedPosting Preview"
{
    PageType = Card;
    Caption = 'Posting Preview';
    SaveValues = true;
    DataCaptionExpression = PostingPreviewTxt;

    layout
    {
        area(Content)
        {


            part(GLEntriesPreviewFlat; "LOCELEntries Part")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;


            }

            part(VATEntriesPreviewFlat; "Vat Entry Part")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;

            }

        }
    }

    actions
    {
        area(Navigation)
        {
            group("Report CITI")
            {
                action("CITI Purchases")
                {
                    ApplicationArea = All;
                    Caption = 'CITI Purchases';
                    Visible = IsFromPurchase;

                    trigger OnAction()
                    begin
                        CITIPurchases();
                    end;
                }

                action("CITI Sales")
                {
                    ApplicationArea = All;
                    Caption = 'CITI Sales';
                    Visible = NOT IsFromPurchase;

                    trigger OnAction()
                    begin
                        CITISales();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.GLEntriesPreviewFlat.Page.setTable();
        CurrPage.VATEntriesPreviewFlat.Page.setTable();
        ResetTempExcelBuff();
    end;

    procedure ResetTempExcelBuff()
    begin
        TempExcelBuff.DELETEALL;
        TempExcelBuffCbte.DeleteAll();
        TempExcelBuffCbtedesp.deleteall();
        TempExcelBuffAlicDespacho.deleteall();
    end;


    procedure CITISales()
    var
        tempSalesHeader: Record "Sales Header" temporary;
        SalesHeader: Record "Sales Header";
        tempglentry: record "G/L Entry" temporary;
        savetempmov: codeunit "SaveTempMov";
        NewDocumentNo: Code[20];
        DocNoFromDescription: Code[20];
        prueba2: integer;
        fiscaltype: record "GMAFiscal Type";
    begin
        ResetTempExcelBuff();
        NumeroLineas := 0;
        TempTotalesCITI.DELETEALL;

        savetempmov.GetLastGenJnlLine(tempglentry);

        if tempglentry.FindFirst() then
            repeat
                DocNoFromDescription := ExtractDocumentNoFromDescription(tempglentry.Description);
                tempSalesHeader.Reset();
                docno := DocNoFromDescription;
                tempSalesHeader.SetRange("No.", DocNoFromDescription);
                IF not (tempSalesHeader.FindFirst()) THEN begin
                    SalesHeader.Reset();
                    NewDocumentNo := DELCHR(docno, '=', '+');
                    SalesHeader.SetRange("No.", NewDocumentNo);
                    IF SalesHeader.FindFirst() THEN BEGIN
                        // Se encontró el registro, verifica duplicados e inserta
                        IF fiscaltype.Get(SalesHeader."GMAFiscal Type") and (fiscaltype."GMASummary in CITI") then begin
                            tempSalesHeader.Reset();
                            tempSalesHeader.SetRange("No.", NewDocumentNo);
                            IF NOT tempSalesHeader.FindFirst() THEN BEGIN
                                tempSalesHeader.Init();
                                tempSalesHeader.Copy(SalesHeader);
                                tempSalesHeader.Insert();
                                tempSalesHeader.CALCFIELDS(Amount, "Amount Including VAT");
                                IF (tempSalesHeader."Amount Including VAT" <> 0) THEN
                                    GenerarFacturasSales(tempSalesHeader);
                            END;
                        end;
                    END ELSE BEGIN
                        IF DocNoFromDescription <> '' THEN BEGIN
                            SalesHeader.Reset();
                            SalesHeader.SetRange("No.", DocNoFromDescription);
                            IF SalesHeader.FindFirst() THEN BEGIN
                                // Se encontró el registro, verifica duplicados e inserta
                                IF fiscaltype.Get(SalesHeader."GMAFiscal Type") and (fiscaltype."GMASummary in CITI") then begin
                                    tempSalesHeader.Reset();
                                    tempSalesHeader.SetRange("No.", DocNoFromDescription);
                                    IF NOT tempSalesHeader.FindFirst() THEN BEGIN
                                        tempSalesHeader.Init();
                                        tempSalesHeader.Copy(SalesHeader);
                                        tempSalesHeader.Insert();
                                        tempSalesHeader.CALCFIELDS(Amount, "Amount Including VAT");
                                        IF (tempSalesHeader."Amount Including VAT" <> 0) THEN
                                            GenerarFacturasSales(tempSalesHeader);
                                    END;
                                end;
                            END;
                        END;
                    END;
                end;
            until tempglentry.Next() = 0;

        if Confirm('Desea generar el .txt de comprobantes?') then begin
            if NumeroLineas = 0 then
                MESSAGE(Text004)
            else begin

                Clear(pFileName);
                pFileName := 'Ventas_Comprobantes';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffCbte);
            end;
        end;
        if Confirm('Desea generar el .txt de alícuotas?') then begin
            if NumeroLineasAlic = 0 then
                MESSAGE(Text004)
            else begin
                Clear(pFileName);
                pFileName := 'Ventas_Alícuotas';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffAlic);
            end;
        end;

    end;

    procedure CITIPurchases()
    var
        tempPurchaseHeader: Record "Purchase Header" temporary;
        PurchaseHeader: Record "Purchase Header";
        tempglentry: record "G/L Entry" temporary;
        savetempmov: codeunit "SaveTempMov";
        NewDocumentNo: Code[20];
        DocNoFromDescription: Code[20];
        fiscaltype: record "GMAFiscal Type";
    begin
        ResetTempExcelBuff();
        NumeroLineas := 0;
        TempTotalesCITI.DELETEALL;

        savetempmov.GetLastGenJnlLine(tempglentry);

        if tempglentry.FindFirst() then
            repeat
                DocNoFromDescription := ExtractDocumentNoFromDescription(tempglentry.Description);
                tempPurchaseHeader.Reset();
                docno := tempglentry."Document No.";


                tempPurchaseHeader.SetRange("Vendor Order No.", tempglentry."External Document No.");
                docNo := tempglentry."External Document No.";



                IF not (tempPurchaseHeader.FindFirst()) THEN begin
                    PurchaseHeader.Reset();
                    NewDocumentNo := DELCHR(tempglentry."Document No.", '=', '+');
                    PurchaseHeader.SetRange("No.", tempglentry."External Document No.");
                    IF PurchaseHeader.FindFirst() THEN BEGIN
                        // Se encontró el registro, verifica duplicados e inserta
                        IF fiscaltype.Get(PurchaseHeader."GMAFiscal Type") and (fiscaltype."GMASummary in CITI") then begin
                            tempPurchaseHeader.Reset();
                            tempPurchaseHeader.SetRange("No.", tempglentry."External Document No.");
                            IF NOT tempPurchaseHeader.FindFirst() THEN BEGIN
                                tempPurchaseHeader.Init();
                                tempPurchaseHeader.Copy(PurchaseHeader);
                                tempPurchaseHeader."Vendor Order No." := tempglentry."External Document No.";
                                tempPurchaseHeader.Insert();
                                tempPurchaseHeader.CALCFIELDS(Amount, "Amount Including VAT");
                                IF (tempPurchaseHeader."Amount Including VAT" <> 0) THEN
                                    GenerarFacturasPurchases(tempPurchaseHeader);
                            END;
                        end;
                    END ELSE BEGIN

                        PurchaseHeader.Reset();
                        IF tempglentry."Document Type" = tempglentry."Document Type"::"Credit Memo" then
                            PurchaseHeader.SetRange(PurchaseHeader."Vendor Cr. Memo No.", tempglentry."External Document No.")
                        else
                            PurchaseHeader.SetRange(PurchaseHeader."Vendor Invoice No.", tempglentry."External Document No.");

                        IF PurchaseHeader.FindFirst() THEN BEGIN
                            // Se encontró el registro, verifica duplicados e inserta
                            tempPurchaseHeader.Reset();

                            IF tempglentry."Document Type" = tempglentry."Document Type"::"Credit Memo" then
                                tempPurchaseHeader.SetRange(tempPurchaseHeader."Vendor Cr. Memo No.", tempglentry."External Document No.")
                            else
                                tempPurchaseHeader.SetRange(tempPurchaseHeader."Vendor Invoice No.", tempglentry."External Document No.");

                            IF fiscaltype.Get(PurchaseHeader."GMAFiscal Type") and (fiscaltype."GMASummary in CITI") then begin
                                IF NOT tempPurchaseHeader.FindFirst() THEN BEGIN
                                    tempPurchaseHeader.Init();
                                    tempPurchaseHeader.Copy(PurchaseHeader);
                                    tempPurchaseHeader."Vendor Order No." := tempglentry."External Document No.";
                                    tempPurchaseHeader.Insert();
                                    tempPurchaseHeader.CALCFIELDS(Amount, "Amount Including VAT");
                                    IF (tempPurchaseHeader."Amount Including VAT" <> 0) THEN
                                        GenerarFacturasPurchases(tempPurchaseHeader);
                                END;
                            end;
                        END;

                    END;
                end;
            until tempglentry.Next() = 0;

        if Confirm('Desea generar el .txt de comprobantes?') then begin
            if NumeroLineas = 0 then
                MESSAGE(Text004)
            else begin

                Clear(pFileName);
                pFileName := 'Compras_Comprobantes';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffCbte);
            end;
        end;
        if Confirm('Desea generar el .txt de comprobantes de Despacho?') then begin
            if NumeroLineas = 0 then
                MESSAGE(Text004)
            else begin

                Clear(pFileName);
                pFileName := 'Compras_Comprobantes_Desp';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffCbtedesp);
            end;
        end;
        if Confirm('Desea generar el .txt de alícuotas?') then begin
            if NumeroLineasAlic = 0 then
                MESSAGE(Text004)
            else begin
                //XMLImportExport."#CargaExcelBuffTemp"(TempExcelBuffAlic);
                //Xmlport.Run(80396, false, false, TempExcelBuffAlic);
                Clear(pFileName);
                pFileName := 'Compras_Alícuotas';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffAlic);
            end;
        end;
        if Confirm('Desea generar el .txt de alícuotas de despacho?') then begin
            //XMLImportExport."#CargaExcelBuffTemp"(TempExcelBuffAlicDespacho);
            //Xmlport.Run(80396, false, false, TempExcelBuffAlicDespacho);
            Clear(pFileName);
            pFileName := 'Compras_AlícuotasDespacho';
            FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
            ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffAlicDespacho);
        end;


    end;

    Procedure GenerarFacturasSales("Sales Header": record "Sales Header")
    VAR
        "AFIP - Tipo Comprobante": Record "GMAAFIP - Voucher Type";
        "Actividad empresa": Record "GMACompany Activity";
        "Tipo fiscal": Record "GMAFiscal Type";
        Currency: Record 4;
        FechaVtoCAIT: Text[8];
        LclTaxGroup: Record 321;
        recCompActivity: Record "GMACompany Activity";
    begin

        EscribirFichero := TRUE;
        CLEAR(Tipocambio);
        CLEAR(Tiporesp);

        NumeroLineas += 1;

        CantidadRegistros += 1;
        IF (CantidadRegistros = 1) THEN BEGIN
            Anio := DATE2DMY("Sales Header"."Posting Date", 3);
            TextoMes := FORMAT(DATE2DMY("Sales Header"."Posting Date", 2));
            WHILE STRLEN(TextoMes) < 2 DO
                TextoMes := '0' + TextoMes;
        END;

        IF ("Sales Header"."Due Date" <> 0D) THEN
            FechaVencimiento := FORMAT("Sales Header"."Due Date", 8, '<Year4><Month,2><Day,2>')
        ELSE
            FechaVencimiento := FORMAT("Sales Header"."Posting Date", 8, '<Year4><Month,2><Day,2>');


        Lineas.RESET;
        Lineas.SETRANGE(Lineas."Document No.", "Sales Header"."No.");

        Taxarea.RESET;
        Taxarea.SETRANGE(Taxarea.Code, "Sales Header"."Tax Area Code");
        Cliente.RESET;
        Cliente.SETRANGE(Cliente."No.", "Sales Header"."Bill-to Customer No.");

        CLEAR(Tipo_de_Comprobante);

        IF ("AFIP - Tipo Comprobante".GET("Sales Header"."GMAAFIP Invoice Voucher Type")) THEN BEGIN
            IF ("AFIP - Tipo Comprobante"."GMACod 3685" = '') THEN
                ERROR(Text005)
            ELSE
                Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMACod 3685"
        END
        ELSE
            Tipo_de_Comprobante := '001';

        CLEAR(Punto_de_Venta);
        IF ("Actividad empresa".GET("Sales Header"."GMAPoint of Sales")) THEN BEGIN
            IF ("Actividad empresa"."GMACod 3685" = '') THEN
                ERROR(Text006)
            ELSE
                Punto_de_Venta := "Actividad empresa"."GMACod 3685"
        END
        ELSE
            Punto_de_Venta := '00001';

        CLEAR(Numero_de_Comprobante);
        IF ("Sales Header"."GMAAFIP Voucher No." <> 0) THEN BEGIN
            WHILE STRLEN(Numero_de_Comprobante + FORMAT("Sales Header"."GMAAFIP Voucher No.")) < 8 DO
                Numero_de_Comprobante := Numero_de_Comprobante + '0';

            Numero_de_Comprobante := Numero_de_Comprobante + FORMAT("Sales Header"."GMAAFIP Voucher No.");
        END
        ELSE BEGIN
            IF (STRLEN("Sales Header"."No.") > 8) THEN
                Numero_de_Comprobante := COPYSTR("Sales Header"."No.", STRLEN("Sales Header"."No.") - 7, 8)
            ELSE BEGIN
                WHILE STRLEN(Numero_de_Comprobante + "Sales Header"."No.") < 8 DO
                    Numero_de_Comprobante := Numero_de_Comprobante + '0';
                Numero_de_Comprobante := Numero_de_Comprobante + "Sales Header"."No.";
            END;
        END;

        Numero_de_Comprobante := DELCHR(Numero_de_Comprobante, '=', '+-_ZXCVBNM¥LKJHGFDSAQWERTYUIOP');

        WHILE STRLEN(Numero_de_Comprobante) < 20 DO
            Numero_de_Comprobante := '0' + Numero_de_Comprobante;

        // CUIT De la Ficha de Cliente

        CLEAR(CUIT);
        IF Cliente.FIND('-') THEN BEGIN
            IF (Cliente."VAT Registration No." <> '') THEN BEGIN
                Cliente."VAT Registration No." := DELCHR(Cliente."VAT Registration No.", '=', '-');
                CUIT := Cliente."VAT Registration No.";
                WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;

            END
            ELSE
                WHILE STRLEN(CUIT) < 20 DO
                    CUIT := '0' + CUIT;

            IF (Cliente."GMAAFIP Document Type" <> '') THEN
                Codigo_de_Documento := Cliente."GMAAFIP Document Type"
            ELSE
                Codigo_de_Documento := '80';
        END;


        TempTotalesCITI.INIT;
        //12896-
        ID_Totals += 1;
        TempTotalesCITI.GMAID := FORMAT(ID_Totals);
        //12896+
        TempTotalesCITI.GMALineNo := NumeroLineas;
        TempTotalesCITI."GMAVoucher No" := "Sales Header"."No.";
        TempTotalesCITI.GMADescription := 'FACTURA';
        // Campo IMPORTE TOTAL CON IMPUESTOS en Divisa de la Factura con dos decimales Redondeados
        // en 15 caracteres sin puntos ni comas
        IF "Sales Header"."Currency Factor" <> 0 THEN
            Tipocambio := ROUND(1 / "Sales Header"."Currency Factor", 0.000001)
        ELSE
            Tipocambio := 1;

        "Sales Header".CALCFIELDS(Amount, "Amount Including VAT");
        Valor12 := "Sales Header"."Amount Including VAT"; // * Tipocambio;

        WHILE STRLEN("Sales Header"."Bill-to Name") < 30 DO
            "Sales Header"."Bill-to Name" := "Sales Header"."Bill-to Name" + ' ';

        IF (STRLEN("Sales Header"."Bill-to Name") > 30) THEN
            "Sales Header"."Bill-to Name" := COPYSTR("Sales Header"."Bill-to Name", 1, 30);

        IF (Valor12 < 1000) THEN BEGIN
            IF ("Tipo fiscal".GET("Sales Header"."GMAFiscal Type")) THEN BEGIN
                IF ("Tipo fiscal"."GMACod 3685" = '') THEN
                    ERROR(Text008);
                IF ("Tipo fiscal"."GMACod 3685" = '5') THEN
                    "Sales Header"."Bill-to Name" := 'CONSUMIDOR FINAL              ';
            END;
        END
        ELSE BEGIN
            IF ("Tipo fiscal".GET("Sales Header"."GMAFiscal Type")) THEN
                IF ("Tipo fiscal"."GMACod 3685" = '') THEN
                    ERROR(Text008);
        END;

        // IMPORTES BASE sin impuestos
        Valor13 := 0; // Conceptos NO Gravados - No generan IVA
        Valor17 := 0; // Siendo Gravado la Operacion esta Excenta   

        IF Lineas.FIND('-') THEN
            REPEAT
                IF (RecProvincia.GET("Sales Header".GMAProvince)) THEN BEGIN
                    IF (RecProvincia."GMACod 3685" = '') THEN
                        ERROR(Text009);
                    IF (RecProvincia."GMACod 3685" = '23') THEN BEGIN
                        Valor17 += Lineas.Amount;// * Tipocambio;
                    END
                    ELSE BEGIN
                        IF ("Tipo fiscal"."GMACod 3685" = '08') OR ("Tipo fiscal"."GMACod 3685" = '09') THEN BEGIN
                            Valor13 += Lineas.Amount;// * Tipocambio
                        END
                        ELSE BEGIN

                            CLEAR(VATBUSPOSTINGGROUP);
                            IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMACalForTaxGroupCode)) THEN begin
                                if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                    Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                                if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                    IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                    IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::"No gravado") THEN
                                        Valor13 += Lineas.Amount// * Tipocambio
                                    ELSE
                                        IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::Exento) THEN
                                            Valor17 += Lineas.Amount;//* Tipocambio;
                                end;

                            end
                            else begin
                                if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                    Valor13 += Lineas."VAT Base Amount";// * Tipocambio;
                            end;


                        END;
                    END
                END
                ELSE BEGIN
                    CLEAR(VATBUSPOSTINGGROUP);
                    IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMACalForTaxGroupCode)) THEN begin
                        if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                            Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                        if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                            IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                            IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::"No gravado") THEN
                                Valor13 += Lineas.Amount// * Tipocambio
                            ELSE
                                IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::Exento) THEN
                                    Valor17 += Lineas.Amount;//* Tipocambio;
                        end;

                    end
                    else begin
                        if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                            Valor13 += Lineas."VAT Base Amount";// * Tipocambio;
                    end;
                END;
            UNTIL Lineas.NEXT = 0;
        // IMPUESTOS

        Valor15 := 0;  // IVA
        Valor16 := 0;  // Percepciones a No Categorizados o RNI
        Valor18 := 0;  // Percepciones Nacionales
        Valor19 := 0;  // Ingresos Brutos
        Valor20 := 0;  // Impuestos Municipales por ahora no hay configurados
        Valor21 := 0;  // Impuestos Internos por ahora no hay configurados  
        CLEAR(GlobalDocumentType);
        GlobalDocumentType := GlobalDocumentType::Invoice;

        calculoImpuestosInvoice("Sales Header"."No.");

        //Campo 9 Importe total de la operaci¢n
        CLEAR(Entero);
        Campo12 := Formatvalor(Valor12, 15);
        EVALUATE(Entero, Campo12);
        Total2_8 += Entero;
        // FIN campo 9

        TempTotalesCITI."GMAOperation total amount" := Valor12;

        //Campo 10 Importe total de conceptos que no integran el precio neto gravado
        CLEAR(Entero);
        Campo13 := Formatvalor(Valor13, 15);
        EVALUATE(Entero, Campo13);
        Total2_9 += Entero;
        TempTotalesCITI."GMAImporte no Gravado" := Valor13;
        // FIN campo10

        //Total2_10+=Entero; 

        // campo 11-Impuesto Liquidado archivo Cabecera
        CLEAR(Entero);
        Campo15 := Formatvalor(Valor15, 15);
        EVALUATE(Entero, Campo15);
        Total2_11 += Entero;
        //Fin campo 11 

        //Campo 11 Percepci¢n a no categorizados comprobante
        CLEAR(Entero);
        Campo16 := Formatvalor(Valor16, 15);
        EVALUATE(Entero, Campo16);
        Total2_12 += Entero;
        TempTotalesCITI."GMANon categorized perceptio" := Valor16;
        //Fin campo1 

        //Campo 12 Importe de operaciones exentas
        CLEAR(Entero);
        Campo17 := Formatvalor(Valor17, 15);
        EVALUATE(Entero, Campo17);
        Total2_13 += Entero;
        TempTotalesCITI."GMANon taxable Amount" := Valor17;
        //Fin Campo 12

        // campo 13   Importe de percepciones o pagos a cuenta de impuestos Nacionales
        CLEAR(Entero);
        Campo18 := Formatvalor(Valor18, 15);
        EVALUATE(Entero, Campo18);
        Total2_14 += Entero;
        TempTotalesCITI."GMANational Perceptions Amou" := Valor18;
        //Fin campo 13   

        //  campo 14 ingresos brutos
        CLEAR(Entero);
        Campo19 := Formatvalor(Valor19, 15);
        EVALUATE(Entero, Campo19);
        Total2_15 += Entero;
        TempTotalesCITI."GMAGIT Amount" := Valor19;
        //Fin campo 14   

        //campo campo 15 Importe de percepciones impuestos Municipales
        Campo20 := Formatvalor(Valor20, 15);
        EVALUATE(Entero, Campo20);
        Total2_16 += Entero;
        TempTotalesCITI."GMACity Perceptions Amount" := Valor20;
        //Fin campo 15  

        // campo 16 Importe impuestos internos
        CLEAR(Entero);
        Campo21 := Formatvalor(Valor21, 15);
        EVALUATE(Entero, Campo21);
        Total2_17 += Entero;
        TempTotalesCITI."GMAInternal Tax Amount" := Valor21;
        //Fin Campo 16  

        IF (Taxarea.GET("Sales Header"."Tax Area Code")) THEN;

        IF ("Tipo fiscal".GET("Sales Header"."GMAFiscal Type")) THEN BEGIN
            IF ("Tipo fiscal"."GMACod 3685" = '') THEN
                ERROR(Text008)
            ELSE
                Tiporesp := "Tipo fiscal"."GMACod 3685";
        END;

        IF (Currency.GET("Sales Header"."Currency Code")) THEN BEGIN
            IF (Currency."GMAAFIP Code" = '') THEN
                ERROR(Text007)
            ELSE
                Moneda := Currency."GMAAFIP Code";
        END
        ELSE
            Moneda := 'PES';
        CLEAR(TipocambioOriginal);
        TipocambioOriginal := Tipocambio;
        TipocambioOriginal := TipocambioOriginal * 1000000;
        Tipocam := FORMAT(TipocambioOriginal, 0, '<Standard Format,1>');
        WHILE STRLEN(Tipocam) < 10 DO Tipocam := '0' + Tipocam;

        Cantiva := 0;
        I105 := 0;
        I21 := 0;
        I27 := 0;
        ImporteI105 := 0;
        ImporteI21 := 0;
        ImporteI27 := 0;
        ImporteBaseI105 := 0;
        ImporteBaseI21 := 0;
        ImporteBaseI27 := 0;
        TextImporteI105 := '';
        TextImporteI21 := '';
        TextImporteI27 := '';
        TextImporteBaseI105 := '';
        TextImporteBaseI21 := '';
        TextImporteBaseI27 := '';
        I5 := 0;
        ImporteI5 := 0;
        ImporteBaseI5 := 0;
        TextImporteI5 := '';
        TextImporteBaseI5 := '';

        calculoImpuestosBaseIVA("Sales Header"."No.");
        Cantiva := I105 + I21 + I27 + I205 + I5;


        IF (I105 <> 0) THEN BEGIN
            TempTotalesCITI."GMAVAT10,5" := ImporteI105;
            TempTotalesCITI.GMABase105 := ImporteBaseI105;
            IF (ImporteI105 <> 0) THEN
                ImporteI105 := ABS(ImporteI105);
            TextImporteI105 := Formatvalor(ImporteI105, 15);
            EVALUATE(Entero, TextImporteI105);
            IF (ImporteBaseI105 <> 0) THEN
                ImporteBaseI105 := ABS(ImporteBaseI105);

            TextImporteBaseI105 := Formatvalor(ImporteBaseI105, 15);
            EVALUATE(Entero, TextImporteBaseI105);

            CLEAR(TextoAlic);
            TextoAlic := (
            FORMAT(Tipo_de_Comprobante) +
            FORMAT(Punto_de_Venta) +
            FORMAT(Numero_de_Comprobante) +
            FORMAT(TextImporteBaseI105) +
            FORMAT('0004') +
            FORMAT(TextImporteI105));


            NumeroLineasAlic += 1;
            "#RellenaExcelBuffAlic"(TextoAlic);

            //    ELSE
            //    "#EscribeFicheroAlic";

        END;

        IF (I5 <> 0) THEN BEGIN
            TempTotalesCITI.GMAVAT5 := ImporteI5;
            TempTotalesCITI.GMABase5 := ImporteBaseI5;
            IF (ImporteI5 <> 0) THEN
                ImporteI5 := ABS(ImporteI5);
            TextImporteI5 := Formatvalor(ImporteI5, 15);
            EVALUATE(Entero, TextImporteI5);

            IF (ImporteBaseI5 <> 0) THEN
                ImporteBaseI5 := ABS(ImporteBaseI5);
            TextImporteBaseI5 := Formatvalor(ImporteBaseI5, 15);
            EVALUATE(Entero, TextImporteBaseI5);

            CLEAR(TextoAlic);
            TextoAlic := (
            FORMAT(Tipo_de_Comprobante) +
            FORMAT(Punto_de_Venta) +
            FORMAT(Numero_de_Comprobante) +
            FORMAT(TextImporteBaseI5) +
            FORMAT('0002') +
            FORMAT(TextImporteI5));


            NumeroLineasAlic += 1;
            "#RellenaExcelBuffAlic"(TextoAlic);

        END;

        IF (I21 <> 0) THEN BEGIN
            TempTotalesCITI.GMAVAT21 := ImporteI21;
            TempTotalesCITI.GMABase21 := ImporteBaseI21;
            IF (ImporteI21 <> 0) THEN
                ImporteI21 := ABS(ImporteI21);
            TextImporteI21 := Formatvalor(ImporteI21, 15);
            EVALUATE(Entero, TextImporteI21);

            IF (ImporteBaseI21 <> 0) THEN
                ImporteBaseI21 := ABS(ImporteBaseI21);
            TextImporteBaseI21 := Formatvalor(ImporteBaseI21, 15);
            EVALUATE(Entero, TextImporteBaseI21);

            CLEAR(TextoAlic);
            TextoAlic := (
            FORMAT(Tipo_de_Comprobante) +
            FORMAT(Punto_de_Venta) +
            FORMAT(Numero_de_Comprobante) +
            FORMAT(TextImporteBaseI21) +
            FORMAT('0005') +
            FORMAT(TextImporteI21));


            NumeroLineasAlic += 1;
            "#RellenaExcelBuffAlic"(TextoAlic);

            //  ELSE
            //  "#EscribeFicheroAlic";

        END;

        IF (I27 <> 0) THEN BEGIN
            TempTotalesCITI.GMAiva27 := ImporteI27;
            TempTotalesCITI.GMABase27 := ImporteBaseI27;
            IF (ImporteI27 <> 0) THEN
                ImporteI27 := ABS(ImporteI27);

            TextImporteI27 := Formatvalor(ImporteI27, 15);
            EVALUATE(Entero, TextImporteI27);
            IF (ImporteBaseI27 <> 0) THEN
                ImporteBaseI27 := ABS(ImporteBaseI27);

            TextImporteBaseI27 := Formatvalor(ImporteBaseI27, 15);
            EVALUATE(Entero, TextImporteBaseI27);

            CLEAR(TextoAlic);
            TextoAlic := (
            FORMAT(Tipo_de_Comprobante) +
            FORMAT(Punto_de_Venta) +
            FORMAT(Numero_de_Comprobante) +
            FORMAT(TextImporteBaseI27) +
            FORMAT('0006') +
            FORMAT(TextImporteI27));


            NumeroLineasAlic += 1;
            "#RellenaExcelBuffAlic"(TextoAlic);

            //        ELSE
            //        "#EscribeFicheroAlic";
        END;

        Codoper := ' ';
        IF (Valor13 <> 0) AND (Valor15 = 0) THEN
            CASE "Sales Header"."Tax Area Code" OF
                'CLI-ZONAFRANCA':
                    Codoper := 'Z';
                'CLI-EXTERIOR':
                    Codoper := 'X';
                'CLI-EXENTO':
                    Codoper := 'E';
                ELSE
                    Codoper := 'N';
            END;

        IF (Cantiva = 0) THEN BEGIN
            TempTotalesCITI."GMAVAT10,5" := ImporteI105;
            TempTotalesCITI.GMABase105 := 0; // es importe total de la factura
            IF (ImporteI105 <> 0) THEN
                ImporteI105 := ABS(ImporteI105);
            TextImporteI105 := Formatvalor(0, 15);
            EVALUATE(Entero, TextImporteI105);

            TextImporteBaseI105 := Formatvalor(0, 15);
            EVALUATE(Entero, TextImporteBaseI105);

            CLEAR(TextoAlic);
            TextoAlic := (
            FORMAT(Tipo_de_Comprobante) +
            FORMAT(Punto_de_Venta) +
            FORMAT(Numero_de_Comprobante) +
            FORMAT(TextImporteBaseI105) +
            FORMAT('0003') +
            FORMAT(TextImporteI105));

            NumeroLineasAlic += 1;


            "#RellenaExcelBuffAlic"(TextoAlic);
        END;

        if (valor13 > 0) and (Valor17 = 0) then
            Codoper := 'N';

        if (Valor17 > 0) then
            Codoper := 'E';

        if (Codoper = ' ') then // AW 
            Codoper := '0';


        IF Cantiva = 0 THEN Cantiva := 1;

        OtrosTributos := '000000000000000';
        IF ("Sales Header".GMACAI2 = '') THEN
            "Sales Header".GMACAI2 := '00000000000000';
        IF ("Sales Header"."GMACAI Due Date2" = 0D) THEN
            FechaVtoCAIT := '00000000'
        ELSE
            FechaVtoCAIT := FORMAT("Sales Header"."GMACAI Due Date2", 8, '<Year4><Month,2><Day,2>');

        TempTotalesCITI.INSERT;
        CLEAR(postingDocDate);
        IF (seePostDate) THEN
            postingDocDate := "Sales Header"."Posting Date"
        else
            postingDocDate := "Sales Header"."Document Date";
        CLEAR(TextoCbte);
        TextoCbte := (
        FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
        FORMAT(Tipo_de_Comprobante) +
        FORMAT(Punto_de_Venta) +
        FORMAT(Numero_de_Comprobante) +
        FORMAT(Numero_de_Comprobante) +
        FORMAT(Codigo_de_Documento) +
        FORMAT(CUIT) +
        FORMAT("Sales Header"."Bill-to Name") +
        FORMAT(Campo12) +
        FORMAT(Campo13) +
        FORMAT(Campo16) +
        FORMAT(Campo17) +
        FORMAT(Campo18) +
        FORMAT(Campo19) +
        FORMAT(Campo20) +
        FORMAT(Campo21) +
        FORMAT(Moneda) +
        FORMAT(Tipocam) +
        FORMAT(Cantiva) +
        FORMAT(Codoper) +
        FORMAT(OtrosTributos) +
        FORMAT(FechaVencimiento));


        "#RellenaExcelBuffCbte"(TextoCbte)


    END;

    PROCEDURE Formatvalor(Importe: Decimal; long: Decimal) strin: Text[30];
    BEGIN
        // Formatea un Decimal con 2 decimales y longitud variable
        Importe := ABS(Importe * 100);
        strin := FORMAT(Importe, 0, '<Precision,0:0><Standard Format,1>');
        WHILE STRLEN(strin) < long DO strin := '0' + strin;
    END;

    PROCEDURE FormatInter(Importe: Decimal; Long: Decimal) strin: Text[30];
    BEGIN
        strin := FORMAT(Importe);
        WHILE STRLEN(strin) < Long DO strin := '0' + strin;
    END;

    PROCEDURE TraeAnioyMes(VAR TMes: Text[2]; VAR TAnio: Integer);
    BEGIN
        ok := EVALUATE(Anio, FORMAT(TAnio));
        //ok:=EVALUATE(Mes,FORMAT(TMes));
        TextoMes := TMes;
    END;

    PROCEDURE TraeDestino(TDestino: Text[100]);
    BEGIN
        ok := EVALUATE(Destino, FORMAT(TDestino));
    END;

    PROCEDURE FormatvalorNC(Importe: Decimal; long: Decimal) strin: Text[30];
    VAR
        esNegativo: Boolean;
    BEGIN
        // Formatea un Decimal con 2 decimales y longitud variable
        IF (Importe > 0) THEN BEGIN
            esNegativo := TRUE;
            long := long - 1;
        END;

        Importe := ABS(Importe * 100);

        strin := FORMAT(Importe, 0, '<Precision,0:0><Standard Format,1>');
        WHILE STRLEN(strin) < long DO strin := '0' + strin;

        IF (esNegativo) THEN
            strin := '-' + strin;
    END;


    PROCEDURE FormatvalorNegativo(Importe: Decimal; long: Decimal) strin: Text[30];
    VAR
        esNegativo: Boolean;
    BEGIN
        // Formatea un Decimal con 2 decimales y longitud variable
        IF (Importe < 0) THEN BEGIN
            esNegativo := TRUE;
            long := long - 1;
        END;

        Importe := ABS(Importe * 100);

        strin := FORMAT(Importe, 0, '<Precision,0:0><Standard Format,1>');
        WHILE STRLEN(strin) < long DO strin := '0' + strin;

        IF (esNegativo) THEN
            strin := '-' + strin;
    END;


    procedure calculoImpuestosInvoice(DocNo: code[20])
    var
        Impuestos: record "VAT Entry" temporary;
        savetempmov: codeunit "SaveTempMov";

    begin
        //  llenar la tabla temporal de Impuestos
        // Calculo los impuestos
        Impuestos.Reset;
        Impuestos.DELETEALL;
        savetempmov.GetLastVatEntry(Impuestos);
        Impuestos.SetCurrentkey("Document No.", "Posting Date");
        Impuestos.SetRange(Impuestos."External Document No.", DocNo);

        if Impuestos.FindSet then
            repeat
                IF (Impuestos."Tax Jurisdiction Code" <> '') THEN begin
                    case Impuestos."GMATax Type Loc" of
                        0:
                            begin
                                Clear(recTaxJurisdiction);
                                recTaxJurisdiction.Reset;
                                recTaxJurisdiction.SetRange(Code, Impuestos."Tax Jurisdiction Code");
                                if recTaxJurisdiction.FindFirst then
                                    case recTaxJurisdiction.GMATipo of
                                        recTaxJurisdiction.GMATipo::IVA21:
                                            Valor15 += (Impuestos.Amount / Tipocambio);

                                        recTaxJurisdiction.GMATipo::"IVA2.5":
                                            Valor15 += (Impuestos.Amount / Tipocambio);

                                        recTaxJurisdiction.GMATipo::"IVA10.5":
                                            Valor15 += (Impuestos.Amount / Tipocambio);

                                        recTaxJurisdiction.GMATipo::IVA27:
                                            Valor15 += (Impuestos.Amount / Tipocambio);


                                        recTaxJurisdiction.GMATipo::" ":
                                            begin
                                                GRUPOREGIVAPROD.Reset;
                                                GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                                                if GRUPOREGIVAPROD.FindFirst then begin
                                                    case GRUPOREGIVAPROD."GMATax Type" of
                                                        0:
                                                            begin
                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '5') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '9') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);
                                                            end;

                                                        1:
                                                            Valor18 += (Impuestos.Amount / Tipocambio);
                                                        2:
                                                            Valor19 += (Impuestos.Amount / Tipocambio);
                                                        3:
                                                            Valor21 += (Impuestos.Amount / Tipocambio);
                                                    end;
                                                end;
                                            end;
                                    end;
                            end;

                        1:
                            Valor18 += (Impuestos.Amount / Tipocambio);
                        2:
                            Valor19 += (Impuestos.Amount / Tipocambio);
                        3:
                            Valor21 += (Impuestos.Amount / Tipocambio);


                    end;
                end
                else begin
                    GRUPOREGIVAPROD.Reset;
                    GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                    if GRUPOREGIVAPROD.FindFirst then begin
                        case GRUPOREGIVAPROD."GMATax Type" of
                            0:
                                begin
                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '5') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '9') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);
                                end;
                            1:
                                Valor18 += (Impuestos.Amount / Tipocambio);
                            2:
                                Valor19 += (Impuestos.Amount / Tipocambio);
                            3:

                                Valor21 += (Impuestos.Amount / Tipocambio);
                        end;
                    end;
                end;
            until Impuestos.Next = 0;
    end;


    procedure calculoImpuestosBaseIVA(DocNo: code[20])
    var
        Impuestos: record "VAT Entry" temporary;
        savetempmov: codeunit "SaveTempMov";
    begin

        //llenar tabla impuestos 


        // Calculo los impuestos
        Impuestos.Reset;
        Impuestos.DELETEALL;
        savetempmov.GetLastVatEntry(Impuestos);
        Impuestos.SetCurrentkey("Document No.", "Posting Date");
        Impuestos.SETRANGE(Impuestos."GMATax Type Loc", Impuestos."GMATax Type Loc"::IVA);

        Impuestos.SetRange(Impuestos."External Document No.", DocNo);
        if Impuestos.FindSet then
            repeat
                IF Impuestos."VAT Calculation Type" <> Impuestos."VAT Calculation Type"::"Full VAT" THEN BEGIN
                    Clear(recTaxJurisdiction);
                    recTaxJurisdiction.Reset;
                    recTaxJurisdiction.SetRange(Code, Impuestos."Tax Jurisdiction Code");
                    if recTaxJurisdiction.FindFirst then begin
                        case recTaxJurisdiction.GMATipo of

                            recTaxJurisdiction.GMATipo::"IVA2.5":
                                begin
                                    I205 := 1;
                                    ImporteI205 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI205 += (Impuestos.Base / Tipocambio);
                                end;

                            recTaxJurisdiction.GMATipo::"IVA10.5":
                                begin
                                    I105 := 1;
                                    ImporteI105 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI105 += (Impuestos.Base / Tipocambio);
                                end;

                            recTaxJurisdiction.GMATipo::"IVA21":
                                begin
                                    I21 := 1;
                                    ImporteI21 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI21 += (Impuestos.Base / Tipocambio);
                                end;
                            recTaxJurisdiction.GMATipo::"IVA27":
                                begin
                                    I27 := 1;
                                    ImporteI27 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI27 += (Impuestos.Base / Tipocambio);
                                end;
                            recTaxJurisdiction.GMATipo::"IVA5":
                                begin
                                    I5 := 1;
                                    ImporteI5 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI5 += (Impuestos.Base / Tipocambio);
                                end;
                            recTaxJurisdiction.GMATipo::" ":
                                begin
                                    GRUPOREGIVAPROD.Reset;
                                    GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                                    if GRUPOREGIVAPROD.FindFirst then begin
                                        case GRUPOREGIVAPROD."GMATax Type" of
                                            0:
                                                begin
                                                    if (GRUPOREGIVAPROD.GMAPorIva = 21) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I21 := 1;
                                                            ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                                ImporteBaseI21 := ImporteBaseI21 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                                        END;

                                                    if (GRUPOREGIVAPROD.GMAPorIva = 10.5) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I105 := 1;
                                                            ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                                ImporteBaseI105 := ImporteBaseI105 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                                        END;

                                                    if (GRUPOREGIVAPROD.GMAPorIva = 2.5) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I205 := 1;
                                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                                        END;

                                                    if (GRUPOREGIVAPROD.GMAPorIva = 27) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I27 := 1;
                                                            ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                                ImporteBaseI27 := ImporteBaseI27 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                                        END;
                                                    if (GRUPOREGIVAPROD.GMAPorIva = 5) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I5 := 1;
                                                            ImporteI5 := ImporteI5 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                                ImporteBaseI5 := ImporteBaseI5 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                                        end;
                                                end;

                                        end;
                                    end;
                                end;
                        end;
                    end;
                end
                else begin
                    GRUPOREGIVAPROD.Reset;
                    GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                    if GRUPOREGIVAPROD.FindFirst then begin
                        case GRUPOREGIVAPROD."GMATax Type" of
                            0:
                                begin
                                    if (GRUPOREGIVAPROD.GMAPorIva = 21) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I21 := 1;
                                            ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                ImporteBaseI21 := ImporteBaseI21 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                        END;

                                    if (GRUPOREGIVAPROD.GMAPorIva = 10.5) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I105 := 1;
                                            ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                ImporteBaseI105 := ImporteBaseI105 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                        END;

                                    if (GRUPOREGIVAPROD.GMAPorIva = 2.5) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I205 := 1;
                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                        END;

                                    if (GRUPOREGIVAPROD.GMAPorIva = 27) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I27 := 1;
                                            ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                ImporteBaseI27 := ImporteBaseI27 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                        END;
                                    if (GRUPOREGIVAPROD.GMAPorIva = 5) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I5 := 1;
                                            ImporteI5 := ImporteI5 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMAPorIva <> 0) then
                                                ImporteBaseI5 := ImporteBaseI5 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) / Tipocambio);
                                        end;
                                end;

                        end;
                    end;
                end;
            UNTIL Impuestos.NEXT = 0;
    end;

    Procedure GenerarFacturasPurchases("Purch. Inv. Header": record "Purchase Header")
    var
        "AFIP - Tipo Comprobante": Record "GMAAFIP - Voucher Type";
        "Actividad empresa": Record "GMACompany Activity";
        "Tipo fiscal": Record "GMAFiscal Type";
        Currency: Record 4;
        FechaVtoCAIT: Text[8];
        LclTaxGroup: Record 321;
        recAuxTipoFiscal: Record "GMAFiscal Type";
    begin
        CLEAR(Tipocambio);
        CLEAR(Tiporesp);

        recAuxTipoFiscal.Reset();
        recAuxTipoFiscal.SetRange(recAuxTipoFiscal.GMACode, "Purch. Inv. Header"."GMAFiscal Type");
        if recAuxTipoFiscal.FindFirst() and (recAuxTipoFiscal."GMASummary in CITI") then begin

            EscribirFichero := TRUE;
            NumeroLineas += 1;
            CantidadRegistros += 1;
            IF (CantidadRegistros = 1) THEN BEGIN
                Anio := DATE2DMY("Purch. Inv. Header"."Posting Date", 3);
                TextoMes := FORMAT(DATE2DMY("Purch. Inv. Header"."Posting Date", 2));
                WHILE STRLEN(TextoMes) < 2 DO
                    TextoMes := '0' + TextoMes;
            END;

            IF ("Purch. Inv. Header"."Due Date" <> 0D) THEN
                FechaVencimiento := FORMAT("Purch. Inv. Header"."Due Date", 8, '<Year4><Month,2><Day,2>')
            ELSE
                FechaVencimiento := FORMAT("Purch. Inv. Header"."Posting Date", 8, '<Year4><Month,2><Day,2>');


            Lineas.RESET;
            Lineas.SETRANGE(Lineas."Document No.", "Purch. Inv. Header"."No.");

            Taxarea.RESET;
            Taxarea.SETRANGE(Taxarea.Code, "Purch. Inv. Header"."Tax Area Code");
            Vendor.RESET;
            Vendor.SETRANGE(Vendor."No.", "Purch. Inv. Header"."Buy-from Vendor No.");

            CLEAR(Tipo_de_Comprobante);
            if (EsFactura = true) then begin
                if "Purch. Inv. Header"."GMAAFIP Invoice Voucher Type" <> '' THEN BEGIN
                    IF ("AFIP - Tipo Comprobante".Get("Purch. Inv. Header"."GMAAFIP Invoice Voucher Type")) THEN begin
                        "AFIP - Tipo Comprobante".testfield("GMACod 3685");
                        Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMACod 3685";
                    end;
                END
                ELSE BEGIN
                    IF (COPYSTR("Purch. Inv. Header"."No.", 1, 3) = 'PIP') THEN BEGIN
                        CASE COPYSTR("Purch. Inv. Header"."Vendor Invoice No.", 1, 1) OF
                            'A':
                                Tipo_de_Comprobante := '002';
                            'B':
                                Tipo_de_Comprobante := '007';
                            'C':
                                Tipo_de_Comprobante := '012';
                            ELSE
                                Tipo_de_Comprobante := '002';
                        END;
                    END ELSE BEGIN
                        CASE COPYSTR("Purch. Inv. Header"."Vendor Invoice No.", 1, 1) OF
                            'A':
                                Tipo_de_Comprobante := '001';
                            'B':
                                Tipo_de_Comprobante := '006';
                            'C':
                                Tipo_de_Comprobante := '011';
                            ELSE
                                Tipo_de_Comprobante := '001';
                        END;
                    END;
                END;
            end;
            if (EsFactura = false) then begin
                if "Purch. Inv. Header"."GMAAFIP Invoice Voucher Type" <> '' THEN BEGIN
                    IF ("AFIP - Tipo Comprobante".Get("Purch. Inv. Header"."GMAAFIP Invoice Voucher Type")) THEN begin
                        "AFIP - Tipo Comprobante".testfield("GMACod 3685");
                        Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMACod 3685";
                    end;
                END
                ELSE BEGIN
                    CASE COPYSTR("Purch. Inv. Header"."Vendor Invoice No.", 1, 1) OF
                        'A':
                            Tipo_de_Comprobante := '003';
                        'B':
                            Tipo_de_Comprobante := '008';
                        'C':
                            Tipo_de_Comprobante := '013';
                        ELSE
                            Tipo_de_Comprobante := '003';
                    END;
                END;
            end;

            CLEAR(Punto_de_Venta);
            "Purch. Inv. Header"."Vendor Invoice No." := DELCHR("Purch. Inv. Header"."Vendor Invoice No.", '=', ' ');
            // Nestor solicita sacar el 0 para tomar 5 digitos reales
            Punto_de_Venta := '' + COPYSTR("Purch. Inv. Header"."Vendor Invoice No.", 2, 5);
            Punto_de_Venta := DELCHR(Punto_de_Venta, '=', ' ,-');

            WHILE STRLEN(Punto_de_Venta) < 5 DO
                Punto_de_Venta := '0' + Punto_de_Venta;

            //VALIDACIONES
            IF (Punto_de_Venta = '00000') THEN
                Punto_de_Venta := '00001';
            //VALIDACIONES

            CLEAR(Numero_de_Comprobante);
            CLEAR(NUMCOMP);
            if "Purch. Inv. Header"."GMAImport Dispatch" = '' then
                NUMCOMP := COPYSTR("Purch. Inv. Header"."Vendor Invoice No.", 1, 20)
            else
                NUMCOMP := "Purch. Inv. Header"."Vendor Invoice No.";


            NUMCOMP := DELCHR(NUMCOMP, '=', '+-_ZXCVBNM¥LKJHGFDSAQWERTYUIOP');

            IF (STRLEN(NUMCOMP) > 8) THEN
                Numero_de_Comprobante := COPYSTR(NUMCOMP,
                                                                STRLEN(NUMCOMP) - 7, 8)
            ELSE BEGIN
                WHILE STRLEN(Numero_de_Comprobante + NUMCOMP) < 8 DO
                    Numero_de_Comprobante := Numero_de_Comprobante + '0';
                Numero_de_Comprobante := Numero_de_Comprobante + NUMCOMP;
            END;

            IF "Purch. Inv. Header"."GMAImport Dispatch" <> '' THEN
                Numero_de_Comprobante := '0';


            WHILE STRLEN(Numero_de_Comprobante) < 20 DO
                Numero_de_Comprobante := '0' + Numero_de_Comprobante;

            //12198-
            //Despacho
            CLEAR(DespachoImportacion);
            IF "Purch. Inv. Header"."GMAImport Dispatch" <> '' THEN BEGIN
                DespachoImportacion := COPYSTR("Purch. Inv. Header"."GMAImport Dispatch", 1, 16);

                WHILE STRLEN(DespachoImportacion) < 16 DO
                    DespachoImportacion := DespachoImportacion + '0';
            END ELSE
                WHILE STRLEN(DespachoImportacion) < 16 DO
                    DespachoImportacion := DespachoImportacion + ' ';
            //12198+

            //END;
            // CUIT De la Ficha de Vendor

            CLEAR(CUIT);
            IF Vendor.FIND('-') THEN BEGIN
                IF (Vendor."VAT Registration No." <> '') THEN BEGIN
                    Vendor."VAT Registration No." := DELCHR(Vendor."VAT Registration No.", '=', '-');
                    CUIT := Vendor."VAT Registration No.";
                    WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
                END
                else begin
                    CUIT := DELCHR("Purch. Inv. Header"."VAT Registration No.", '=', '-');
                    WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
                end;
            end
            ELSE BEGIN
                IF ("Purch. Inv. Header"."VAT Registration No." <> '') THEN BEGIN
                    CUIT := DELCHR("Purch. Inv. Header"."VAT Registration No.", '=', '-');
                    WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
                END
                ELSE
                    WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
            END;

            Codigo_de_Documento := '80';

            //Se genera la tabla decontrol
            TempTotalesCITI.INIT;
            //12896 (03)-
            TempTotalesCITI.GMAID := FORMAT(NumeroLineas);
            //12896 (03)+
            TempTotalesCITI.GMALineNo := NumeroLineas;
            TempTotalesCITI."GMAVoucher No" := "Purch. Inv. Header"."No.";
            TempTotalesCITI."GMAInvoice Vendor" := "Purch. Inv. Header"."Vendor Invoice No.";
            TempTotalesCITI.GMADescription := 'FACTURA COMPRA';


            WHILE STRLEN("Purch. Inv. Header"."Buy-from Vendor Name") < 30 DO
                "Purch. Inv. Header"."Buy-from Vendor Name" := "Purch. Inv. Header"."Buy-from Vendor Name" + ' ';

            IF (STRLEN("Purch. Inv. Header"."Buy-from Vendor Name") > 30) THEN
                "Purch. Inv. Header"."Buy-from Vendor Name" := COPYSTR("Purch. Inv. Header"."Buy-from Vendor Name", 1, 30);

            // Campo IMPORTE TOTAL CON IMPUESTOS en Divisa de la Factura con dos decimales Redondeados
            // en 15 caracteres sin puntos ni comas
            IF "Purch. Inv. Header"."Currency Factor" <> 0 THEN
                Tipocambio := ROUND(1 / "Purch. Inv. Header"."Currency Factor", 0.000001)
            ELSE
                Tipocambio := 1;

            "Purch. Inv. Header".CALCFIELDS(Amount, "Amount Including VAT");
            Valor12 := "Purch. Inv. Header"."Amount Including VAT";//* Tipocambio;


            // IMPORTES BASE sin impuestos
            Valor13 := 0; // Conceptos NO Gravados - No generan IVA
            Valor14 := 0; // Conceptos    Gravados -    Generan IVA
            Valor17 := 0; // Siendo Gravado la Operacion esta Exenta

            IF ("Tipo fiscal".GET("Purch. Inv. Header"."GMAFiscal Type")) THEN BEGIN
                IF ("Tipo fiscal"."GMACod 3685" = '') THEN
                    ERROR(Text008);
            END;

            IF Lineas.FIND('-') THEN
                REPEAT
                    IF (RecProvincia.GET("Purch. Inv. Header".GMAProvince)) THEN BEGIN
                        IF (RecProvincia."GMACod 3685" = '') THEN
                            ERROR(Text009);
                        IF (RecProvincia."GMACod 3685" = '23') THEN BEGIN
                            Valor17 += Lineas.Amount;//* Tipocambio;
                        END
                        ELSE BEGIN
                            IF ("Tipo fiscal"."GMACod 3685" = '08') OR ("Tipo fiscal"."GMACod 3685" = '09') THEN BEGIN
                                Valor13 += Lineas.Amount;//* Tipocambio
                            END
                            ELSE BEGIN


                                CLEAR(VATBUSPOSTINGGROUP);
                                IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMACalForTaxGroupCode)) THEN begin
                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += Lineas."VAT Base Amount"; //* Tipocambio;



                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                        IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                        IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::"No gravado") THEN
                                            Valor13 += Lineas.Amount// * Tipocambio
                                        ELSE
                                            IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::Exento) THEN
                                                Valor17 += Lineas.Amount;//* Tipocambio;
                                    end;

                                end
                                else begin
                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += Lineas."VAT Base Amount"; //* Tipocambio;
                                end;


                            END;
                        END;
                    END
                    ELSE BEGIN

                        CLEAR(VATBUSPOSTINGGROUP);
                        IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMACalForTaxGroupCode)) THEN begin
                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                Valor13 += Lineas."VAT Base Amount"; // * Tipocambio;



                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::"No gravado") THEN
                                    Valor13 += Lineas.Amount// * Tipocambio
                                ELSE
                                    IF (LclTaxGroup."GMARes 3685" = LclTaxGroup."GMARes 3685"::Exento) THEN
                                        Valor17 += Lineas.Amount;//* Tipocambio;
                            end;

                        end
                        else begin
                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                Valor13 += Lineas."VAT Base Amount"; //* Tipocambio;
                        end;

                    END;
                UNTIL Lineas.NEXT = 0;

            // IMPUESTOS

            Valor15 := 0;  // IVA
            Valor16 := 0;  // Percepciones a No Categorizados o RNI
            Valor18 := 0;  // Percepciones Nacionales
            Valor19 := 0;  // Ingresos Brutos
            Valor20 := 0;  // Impuestos Municipales por ahora no hay configurados
            Valor21 := 0;  // Impuestos Internos por ahora no hay configurados 

            calculoImpuestosInvoice(docno);

            Cantiva := 0;
            I105 := 0;
            I21 := 0;
            I27 := 0;
            ImporteI105 := 0;
            ImporteI21 := 0;
            ImporteI27 := 0;
            ImporteBaseI105 := 0;
            ImporteBaseI21 := 0;
            ImporteBaseI27 := 0;
            TextImporteI105 := '';
            TextImporteI21 := '';
            TextImporteI27 := '';
            TextImporteBaseI105 := '';
            TextImporteBaseI21 := '';
            TextImporteBaseI27 := '';
            I5 := 0;
            ImporteI5 := 0;
            ImporteBaseI5 := 0;
            TextImporteI5 := '';
            TextImporteBaseI5 := '';
            I205 := 0;
            ImporteI205 := 0;
            ImporteBaseI205 := 0;
            TextImporteI205 := '';
            TextImporteBaseI205 := '';

            calculoImpuestosBaseIVA(docno);
            if "Purch. Inv. Header"."GMAImport Dispatch" <> '' then
                Valor12 += ImporteBaseI105 + ImporteBaseI21 + ImporteBaseI27 + ImporteBaseI205 + ImporteBaseI5;

            //Campo 9 Importe total de la operaci¢n
            CLEAR(Entero);
            Campo12 := Formatvalor(Valor12, 15);
            EVALUATE(Entero, Campo12);
            Total2_8 += Entero;
            // FIN campo 9

            TempTotalesCITI."GMAOperation total amount" := Valor12;

            //Campo 10 Importe total de conceptos que no integran el precio neto gravado
            IF (Tipo_de_Comprobante = '007') OR (Tipo_de_Comprobante = '012') OR (Tipo_de_Comprobante = '006') OR (Tipo_de_Comprobante = '011') THEN
                Valor13 := 0;
            CLEAR(Entero);
            Campo13 := FormatvalorNegativo(Valor13, 15);
            EVALUATE(Entero, Campo13);
            Total2_9 += Entero;
            TempTotalesCITI."GMAImporte no Gravado" := Valor13;
            // FIN campo10   

            //Total2_10+=Entero;

            // campo 11-Impuesto Liquidado archivo Cabecera
            CLEAR(Entero);
            Campo15 := Formatvalor(Valor15, 15);
            EVALUATE(Entero, Campo15);
            Total2_11 += Entero;
            //Fin campo 11

            //Campo 11 Percepci¢n a no categorizados comprobante
            CLEAR(Entero);
            Campo16 := Formatvalor(Valor16, 15);
            EVALUATE(Entero, Campo16);
            Total2_12 += Entero;
            TempTotalesCITI."GMANon categorized perceptio" := Valor16;
            //Fin campo1   

            //Campo 12 Importe de operaciones exentas
            IF (Tipo_de_Comprobante = '007') OR (Tipo_de_Comprobante = '012') OR (Tipo_de_Comprobante = '006') OR (Tipo_de_Comprobante = '011') THEN
                Valor17 := 0;
            CLEAR(Entero);
            Campo17 := FormatvalorNegativo(Valor17, 15);
            EVALUATE(Entero, Campo17);
            Total2_13 += Entero;
            TempTotalesCITI."GMANon taxable Amount" := Valor17;
            //Fin Campo 12

            // campo 13   Importe de percepciones o pagos a cuenta de impuestos Nacionales
            CLEAR(Entero);
            Campo18 := Formatvalor(Valor18, 15);
            EVALUATE(Entero, Campo18);
            Total2_14 += Entero;
            TempTotalesCITI."GMANational Perceptions Amou" := Valor18;
            //Fin campo 13   

            //  campo 14 ingresos brutos
            CLEAR(Entero);
            Campo19 := Formatvalor(Valor19, 15);
            EVALUATE(Entero, Campo19);
            Total2_15 += Entero;
            TempTotalesCITI."GMAGIT Amount" := Valor19;
            //Fin campo 14

            //campo campo 15 Importe de percepciones impuestos Municipales
            Campo20 := Formatvalor(Valor20, 15);
            EVALUATE(Entero, Campo20);
            Total2_16 += Entero;
            TempTotalesCITI."GMACity Perceptions Amount" := Valor20;
            //Fin campo 15

            // campo 16 Importe impuestos internos
            CLEAR(Entero);
            Campo21 := Formatvalor(Valor21, 15);
            EVALUATE(Entero, Campo21);
            Total2_17 += Entero;
            TempTotalesCITI."GMAInternal Tax Amount" := Valor21;
            //Fin Campo 16     


            IF (Taxarea.GET("Purch. Inv. Header"."Tax Area Code")) THEN;

            IF ("Tipo fiscal".GET("Purch. Inv. Header"."GMAFiscal Type")) THEN BEGIN
                IF ("Tipo fiscal"."GMACod 3685" = '') THEN
                    ERROR(Text008)
                ELSE
                    Tiporesp := "Tipo fiscal"."GMACod 3685";
            END;

            IF (Currency.GET("Purch. Inv. Header"."Currency Code")) THEN BEGIN
                IF (Currency."GMAAFIP Code" = '') THEN
                    ERROR(Text007)
                ELSE
                    Moneda := Currency."GMAAFIP Code";
            END
            ELSE
                Moneda := 'PES';

            CLEAR(TipocambioOriginal);
            TipocambioOriginal := Tipocambio;
            TipocambioOriginal := TipocambioOriginal * 1000000;
            Tipocam := FORMAT(TipocambioOriginal, 0, '<Standard Format,1>');
            WHILE STRLEN(Tipocam) < 10 DO Tipocam := '0' + Tipocam;

            Cantiva := I105 + I21 + I27 + I205 + I5;

            if Tipo_de_Comprobante = '066' then begin

                CLEAR(Entero);
                Campo13 := FormatvalorNegativo(Valor13 - abs(ImporteBaseI105 + ImporteBaseI21 + ImporteBaseI205 + ImporteBaseI27), 15);
                EVALUATE(Entero, Campo13);
                Total2_9 += Entero;
                TempTotalesCITI."GMAImporte no Gravado" := -Valor13;
            end;

            IF (I205 <> 0) THEN BEGIN
                TempTotalesCITI.GMAIva205 := ImporteI205;
                TempTotalesCITI.GMABase205 := ImporteBaseI205;
                //IF(ImporteI105 <> 0)THEN
                //  ImporteI105 := ABS(ImporteI105);
                TextImporteI205 := FormatvalorNegativo(ImporteI205, 15);
                EVALUATE(Entero, TextImporteI205);
                // IF(ImporteBaseI105 <> 0)THEN
                //  ImporteBaseI105 := ABS(ImporteBaseI105);

                TextImporteBaseI205 := FormatvalorNegativo(ImporteBaseI205, 15);
                EVALUATE(Entero, TextImporteBaseI205);

                //12198-
                IF "Purch. Inv. Header"."gmaImport Dispatch" <> '' THEN begin
                    CLEAR(TextoAlicDespacho);
                    TextoAlicDespacho := (
                    FORMAT(DespachoImportacion) +
                    FORMAT(TextImporteBaseI205) +
                    FORMAT('0009') +
                    FORMAT(TextImporteI205));


                    NumeroLineasAlicDespacho += 1;
                    "#RellenaExcelBuffAlicDespacho"(TextoAlicDespacho);

                END ELSE BEGIN
                    CLEAR(TextoAlic);
                    TextoAlic := (
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT(TextImporteBaseI205) +
                    FORMAT('0009') +
                    FORMAT(TextImporteI205));

                    NumeroLineasAlic += 1;
                    "#RellenaExcelBuffAlic"(TextoAlic);

                END;
                //12198-
            END;

            IF (I5 <> 0) THEN BEGIN
                TempTotalesCITI.GMAVAT5 := ImporteI5;
                TempTotalesCITI.GMABase5 := ImporteBaseI5;
                //IF(ImporteI105 <> 0)THEN
                //  ImporteI105 := ABS(ImporteI105);
                TextImporteI5 := FormatvalorNegativo(ImporteI5, 15);
                EVALUATE(Entero, TextImporteI5);
                // IF(ImporteBaseI105 <> 0)THEN
                //  ImporteBaseI105 := ABS(ImporteBaseI105);

                TextImporteBaseI5 := FormatvalorNegativo(ImporteBaseI5, 15);
                EVALUATE(Entero, TextImporteBaseI5);

                //12198-
                IF "Purch. Inv. Header"."gmaImport Dispatch" <> '' THEN begin
                    CLEAR(TextoAlicDespacho);
                    TextoAlicDespacho := (
                    FORMAT(DespachoImportacion) +
                    FORMAT(TextImporteBaseI5) +
                    FORMAT('0003') +
                    FORMAT(TextImporteI5));


                    NumeroLineasAlicDespacho += 1;
                    "#RellenaExcelBuffAlicDespacho"(TextoAlicDespacho);

                END ELSE BEGIN
                    CLEAR(TextoAlic);
                    TextoAlic := (
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT(TextImporteBaseI5) +
                    FORMAT('0003') +
                    FORMAT(TextImporteI5));

                    NumeroLineasAlic += 1;
                    "#RellenaExcelBuffAlic"(TextoAlic);

                END;
                //12198+
            END;

            IF (I105 <> 0) THEN BEGIN
                TempTotalesCITI."GMAVAT10,5" := ImporteI105;
                TempTotalesCITI.GMABase105 := ImporteBaseI105;
                //IF(ImporteI105 <> 0)THEN
                //  ImporteI105 := ABS(ImporteI105);
                TextImporteI105 := FormatvalorNegativo(ImporteI105, 15);
                EVALUATE(Entero, TextImporteI105);
                // IF(ImporteBaseI105 <> 0)THEN
                //  ImporteBaseI105 := ABS(ImporteBaseI105);

                TextImporteBaseI105 := FormatvalorNegativo(ImporteBaseI105, 15);
                EVALUATE(Entero, TextImporteBaseI105);

                //12198-
                IF "Purch. Inv. Header"."gmaImport Dispatch" <> '' THEN begin
                    CLEAR(TextoAlicDespacho);
                    TextoAlicDespacho := (
                    FORMAT(DespachoImportacion) +
                    FORMAT(TextImporteBaseI105) +
                    FORMAT('0004') +
                    FORMAT(TextImporteI105));


                    NumeroLineasAlicDespacho += 1;
                    "#RellenaExcelBuffAlicDespacho"(TextoAlicDespacho);

                END ELSE BEGIN
                    CLEAR(TextoAlic);
                    TextoAlic := (
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT(TextImporteBaseI105) +
                    FORMAT('0004') +
                    FORMAT(TextImporteI105));

                    NumeroLineasAlic += 1;
                    "#RellenaExcelBuffAlic"(TextoAlic);

                END;
                //12198+
            END;


            IF (I21 <> 0) THEN BEGIN
                TempTotalesCITI.GMAVAT21 := ImporteI21;
                TempTotalesCITI.GMABase21 := ImporteBaseI21;
                // IF(ImporteI21 <> 0)THEN
                //  ImporteI21 := ABS(ImporteI21);
                TextImporteI21 := FormatvalorNegativo(ImporteI21, 15);
                EVALUATE(Entero, TextImporteI21);

                // IF(ImporteBaseI21 <> 0)THEN
                //  ImporteBaseI21 := ABS(ImporteBaseI21);
                TextImporteBaseI21 := FormatvalorNegativo(ImporteBaseI21, 15);
                EVALUATE(Entero, TextImporteBaseI21);

                //12198-
                IF "Purch. Inv. Header"."gmaImport Dispatch" <> '' THEN begin
                    CLEAR(TextoAlicDespacho);
                    TextoAlicDespacho := (
                    FORMAT(DespachoImportacion) +
                    FORMAT(TextImporteBaseI21) +
                    FORMAT('0005') +
                    FORMAT(TextImporteI21));


                    NumeroLineasAlicDespacho += 1;
                    "#RellenaExcelBuffAlicDespacho"(TextoAlicDespacho);

                END
                ELSE BEGIN
                    CLEAR(TextoAlic);
                    TextoAlic := (
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT(TextImporteBaseI21) +
                    FORMAT('0005') +
                    FORMAT(TextImporteI21));

                    NumeroLineasAlic += 1;
                    "#RellenaExcelBuffAlic"(TextoAlic);

                END;
                //12198+
            END;

            IF (I27 <> 0) THEN BEGIN
                TempTotalesCITI.GMAiva27 := ImporteI27;
                TempTotalesCITI.GMABase27 := ImporteBaseI27;
                //IF(ImporteI27 <> 0)THEN
                //  ImporteI27 := ABS(ImporteI27);

                TextImporteI27 := FormatvalorNegativo(ImporteI27, 15);
                EVALUATE(Entero, TextImporteI27);
                // IF(ImporteBaseI27 <> 0)THEN
                //  ImporteBaseI27 := ABS(ImporteBaseI27);

                TextImporteBaseI27 := FormatvalorNegativo(ImporteBaseI27, 15);
                EVALUATE(Entero, TextImporteBaseI27);

                //12198-
                IF "Purch. Inv. Header"."gmaImport Dispatch" <> '' THEN begin
                    CLEAR(TextoAlicDespacho);
                    TextoAlicDespacho := (
                    FORMAT(DespachoImportacion) +
                    FORMAT(TextImporteBaseI27) +
                    FORMAT('0006') +
                    FORMAT(TextImporteI27));


                    NumeroLineasAlicDespacho += 1;
                    "#RellenaExcelBuffAlicDespacho"(TextoAlicDespacho);

                END
                ELSE BEGIN
                    CLEAR(TextoAlic);
                    TextoAlic := (
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT(TextImporteBaseI27) +
                    FORMAT('0006') +
                    FORMAT(TextImporteI27));

                    NumeroLineasAlic += 1;
                    "#RellenaExcelBuffAlic"(TextoAlic);

                END;
                //12198+
            END;

            //SE GENERA SI NO HAY IVA


            Codoper := ' ';
            IF (Valor13 <> 0) AND (Valor15 = 0) THEN
                CASE "Purch. Inv. Header"."Tax Area Code" OF
                    'CLI-ZONAFRANCA':
                        Codoper := 'Z';
                    'CLI-EXTERIOR':
                        Codoper := 'X';
                    'CLI-EXENTO':
                        Codoper := 'E';
                    ELSE
                        Codoper := 'N';
                END;

            IF Tipo_de_Comprobante = '066' THEN
                Codoper := 'N';

            IF (Cantiva = 0) AND (Tipo_de_Comprobante <> '011') AND (Tipo_de_Comprobante <> '012') AND (Tipo_de_Comprobante <> '066') THEN BEGIN
                TempTotalesCITI."GMAVAT10,5" := ImporteI105;
                TempTotalesCITI.GMABase105 := 0; // es importe total de la factura
                                                 // IF(ImporteI105 <> 0)THEN
                                                 //  ImporteI105 := ABS(ImporteI105);
                TextImporteI105 := Formatvalor(0, 15);
                EVALUATE(Entero, TextImporteI105);

                TextImporteBaseI105 := Formatvalor(0, 15);
                EVALUATE(Entero, TextImporteBaseI105);

                CLEAR(TextoAlic);
                TextoAlic := (
                FORMAT(Tipo_de_Comprobante) +
                FORMAT(Punto_de_Venta) +
                FORMAT(Numero_de_Comprobante) +
                FORMAT(Codigo_de_Documento) +
                FORMAT(CUIT) +
                FORMAT(TextImporteBaseI105) +
                FORMAT('0003') +
                FORMAT(TextImporteI105));

                NumeroLineasAlic += 1;


                "#RellenaExcelBuffAlic"(TextoAlic);

                Codoper := 'E';
            END;


            //FIN SE GENERA NO HAY IVA


            IF Cantiva = 0 THEN Cantiva := 1;  // Se debe indicar 1 aun cuando la operaci¢n sea Exenta

            IF (Tipo_de_Comprobante = '007') OR (Tipo_de_Comprobante = '012') OR (Tipo_de_Comprobante = '006') OR (Tipo_de_Comprobante = '011') THEN
                Cantiva := 0;

            OtrosTributos := '000000000000000';
            IF (CUIT = '') THEN
                CUIT := '00000000000000000000';

            IF (Empresa.GET) THEN;

            // 1-CUIT del Informante
            IF Empresa.FIND('-') THEN BEGIN
                Empresa."VAT Registration No." := DELCHR(Empresa."VAT Registration No.", '=', '-');

                CUITEmisor := Empresa."VAT Registration No.";
                WHILE STRLEN(CUITEmisor) < 11 DO CUITEmisor := '0' + CUITEmisor;

                WHILE STRLEN(Empresa.Name) < 30 DO
                    Empresa.Name := Empresa.Name + ' ';

                IF STRLEN(Empresa.Name) > 30 THEN
                    Empresa.Name := COPYSTR(Empresa.Name, 1, 30);
            END;

            IVAComision := '000000000000000';

            //LAC Actualización 06052024 
            IF Tipo_de_Comprobante = '066' THEN
                Punto_de_Venta := '00000';




            CLEAR(CreditoFiscalComputabledec);
            Campo12 := Formatvalor(Valor12, 15);
            EVALUATE(Entero, Campo12);
            TempTotalesCITI."GMAOperation total amount" := Valor12;
            CreditoFiscalComputabledec := ABS(ImporteI105 + ImporteI21 + ImporteI27 + ImporteI205);
            CreditoFiscalComputable := Formatvalor(CreditoFiscalComputabledec, 15);
            EVALUATE(Entero, CreditoFiscalComputable);
            // suma campo12(9) campo 13(10) campo 16(11) campo 17(12)  campo 18(13) campo 19(14)
            TempTotalesCITI.INSERT;

            CLEAR(EsProveedorGenerico);
            EsProveedorGenerico := argentina.genericVendor("Purch. Inv. Header"."Buy-from Vendor No.");
            IF (EsProveedorGenerico) and ("Purch. Inv. Header"."Buy-from Vendor Name 2" <> '') THEN
                "Purch. Inv. Header"."Buy-from Vendor Name" := "Purch. Inv. Header"."Buy-from Vendor Name 2";

            CLEAR(TextoCbte);
            CLEAR(postingDocDate);
            IF (seePostDate) THEN
                postingDocDate := "Purch. Inv. Header"."Posting Date"
            else
                postingDocDate := "Purch. Inv. Header"."Document Date";
            IF "Purch. Inv. Header"."GMAImport Dispatch" <> '' THEN begin
                TextoCbte := (
                FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                FORMAT(Tipo_de_Comprobante) +
                FORMAT(Punto_de_Venta) +
                FORMAT(Numero_de_Comprobante) +
                FORMAT(DespachoImportacion) +
                FORMAT(Codigo_de_Documento) +
                FORMAT(CUIT) +
                FORMAT("Purch. Inv. Header"."Buy-from Vendor Name") +
                FORMAT(Campo12) +
                FORMAT(Campo13) +
                FORMAT(Campo17) +
                FORMAT(Campo18) +
                FORMAT(Campo21) +
                FORMAT(Campo19) +
                FORMAT(Campo20) +
                FORMAT(Campo16) +
                FORMAT(Moneda) +
                FORMAT(Tipocam) +
                FORMAT(Cantiva) +
                FORMAT(Codoper) +
                FORMAT(CreditoFiscalComputable) +
                FORMAT(OtrosTributos) +
                FORMAT('00000000000') +
                FORMAT('                              ') +
                FORMAT(IVAComision));

                "#RellenaExcelBuffCbteDesp"(TextoCbte)
            end
            else begin
                TextoCbte := (
                FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                FORMAT(Tipo_de_Comprobante) +
                FORMAT(Punto_de_Venta) +
                FORMAT(Numero_de_Comprobante) +
                FORMAT(DespachoImportacion) +
                FORMAT(Codigo_de_Documento) +
                FORMAT(CUIT) +
                FORMAT("Purch. Inv. Header"."Buy-from Vendor Name") +
                FORMAT(Campo12) +
                FORMAT(Campo13) +
                FORMAT(Campo17) +
                FORMAT(Campo18) +
                FORMAT(Campo21) +
                FORMAT(Campo19) +
                FORMAT(Campo20) +
                FORMAT(Campo16) +
                FORMAT(Moneda) +
                FORMAT(Tipocam) +
                FORMAT(Cantiva) +
                FORMAT(Codoper) +
                FORMAT(CreditoFiscalComputable) +
                FORMAT(OtrosTributos) +
                FORMAT('00000000000') +
                FORMAT('                              ') +
                FORMAT(IVAComision));


                "#RellenaExcelBuffCbte"(TextoCbte)
            end;
        end;
    end;

    PROCEDURE "#RellenaExcelBuff"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuff.INIT;
        TempExcelBuff."Row No." := NumeroLineas;
        TempExcelBuff."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuff.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuff.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuff.INSERT;
    END;

    PROCEDURE "#RellenaExcelBuffCbte"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuffCbte.INIT;
        TempExcelBuffCbte."Row No." := NumeroLineas;
        TempExcelBuffCbte."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuffCbte.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuffCbte.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuffCbte.INSERT;
    END;


    PROCEDURE "#RellenaExcelBuffCbteDesp"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuffCbtedesp.INIT;
        TempExcelBuffCbtedesp."Row No." := NumeroLineas;
        TempExcelBuffCbtedesp."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuffCbtedesp.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuffCbtedesp.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuffCbtedesp.INSERT;
    END;

    PROCEDURE "#RellenaExcelBuffAlic"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuffAlic.INIT;
        TempExcelBuffAlic."Row No." := NumeroLineasAlic;
        TempExcelBuffAlic."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuffAlic.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuffAlic.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuffAlic.INSERT;
    END;

    PROCEDURE "#RellenaExcelBuffAlicDespacho"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuffAlicDespacho.INIT;
        TempExcelBuffAlicDespacho."Row No." := NumeroLineasAlicDespacho;
        TempExcelBuffAlicDespacho."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuffAlicDespacho.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuffAlicDespacho.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuffAlicDespacho.INSERT;
    END;

    procedure ExtractDocumentNoFromDescription(Description: Text): Code[20]
    var
        InvoicePrefix: Text[8];
        FacturaPrefix: Text[8];
        CreditMemoPrefix: Text[12];
        Result: Text[20];
    begin
        InvoicePrefix := 'INVOICE ';
        FacturaPrefix := 'FACTURA ';
        CreditMemoPrefix := 'CREDIT MEMO ';

        Description := UPPERCASE(Description);
        InvoicePrefix := UPPERCASE(InvoicePrefix);
        FacturaPrefix := UPPERCASE(FacturaPrefix);
        CreditMemoPrefix := UPPERCASE(CreditMemoPrefix);

        IF (STRPOS(Description, InvoicePrefix) = 1) OR (STRPOS(Description, FacturaPrefix) = 1) THEN
            EsFactura := TRUE
        ELSE
            EsFactura := FALSE;

        IF STRPOS(Description, InvoicePrefix) = 1 THEN
            Result := COPYSTR(Description, STRLEN(InvoicePrefix) + 1, STRLEN(Description) - STRLEN(InvoicePrefix))
        ELSE IF STRPOS(Description, FacturaPrefix) = 1 THEN
            Result := COPYSTR(Description, STRLEN(FacturaPrefix) + 1, STRLEN(Description) - STRLEN(FacturaPrefix))
        ELSE IF STRPOS(Description, CreditMemoPrefix) = 1 THEN
            Result := COPYSTR(Description, STRLEN(CreditMemoPrefix) + 1, STRLEN(Description) - STRLEN(CreditMemoPrefix));

        IF STRLEN(Result) > 20 THEN
            Result := COPYSTR(Result, 1, 20);

        IF Result <> '' THEN
            EXIT(Result);
        EXIT('');
    end;

    procedure SetFromPurchase(Value: Boolean)
    begin
        IsFromPurchase := Value;
    end;

    var
        EsFactura: Boolean;
        VATBUSPOSTINGGROUP: record "VAT Business Posting Group";
        XMLImportExport: XmlPort "GMAXML ImportExport";
        Text003: label 'The date must be less or equal than to date',;
        Text01: label 'File cannot be created',;
        Text004: label 'There is no records to generate the report',;
        Text005: label 'You have to configure the field Cod 3685 in the table AFIP Voucher Type',;
        Text006: label 'You have to configure the field Cod 3685 in the table Company Activity',;
        Text007: label 'You have to configure field AFIP Code in the table Currency',;
        Text008: label 'You have to configure field Cod 3685 in the table Fiscal Type',;
        Text009: label 'You have to configure the field Cod 3685 in the table Province',;
        FechaDesde: Date;
        FechaHasta: Date;
        Anio: Integer;
        TextoMes: Text[2];
        Destino: Text[100];
        Periodo: Text[6];
        Lineas: Record "Purchase Line";
        LineasCredito: Record "Purchase Line";
        Empresa: Record "Company Information";

        Taxarea: Record "Tax Area";
        Detalleimpuesto: Record "Tax Detail";
        Vendor: Record Vendor;
        FiltroFecha: Text[30];
        Tipo_de_Registro: Integer;
        Tipo_de_Comprobante: Text[3];
        Controlador_Fiscal: Text[1];
        Punto_de_Venta: Text[5];
        Numero_de_Comprobante: Text[20];
        TC: Text[2];
        Cantidad_de_hojas: Text[3];
        Codigo_de_Documento: Text[2];
        CUIT: Text[20];
        Valor12: Decimal;
        Campo12: Text[15];
        Valor13: Decimal;
        Campo13: Text[15];
        Valor14: Decimal;
        Campo14: Text[15];
        Valor15: Decimal;
        Campo15: Text[15];
        Valor16: Decimal;
        Campo16: Text[15];
        Valor17: Decimal;
        Campo17: Text[15];
        Valor18: Decimal;
        Campo18: Text[15];
        Valor19: Decimal;
        Campo19: Text[15];
        Valor20: Decimal;
        Campo20: Text[15];
        Valor21: Decimal;
        Campo21: Text[15];
        Tiporesp: Text[2];
        Moneda: Text[3];
        Tipocambio: Decimal;
        TipocambioOriginal: Decimal;
        Tipocam: Text[10];
        Cantiva: Decimal;
        FechaVencimiento: Text[8];
        I105: Decimal;
        I21: Decimal;
        I27: Decimal;
        I5: Decimal;
        ImporteI5: Decimal;
        ImporteI105: Decimal;
        ImporteI21: Decimal;
        ImporteI27: Decimal;
        ImporteBaseI105: Decimal;
        ImporteBaseI21: Decimal;
        ImporteBaseI27: Decimal;
        ImporteBaseI5: Decimal;
        Codoper: Text[30];
        CantidadRegistros: Integer;
        I205: Decimal;
        ImporteI205: Decimal;
        ImporteBaseI205: Decimal;

        Tipo2_1: Text[11];
        Tipo2_2: Text[6];
        Tipo2_3: Text[2];
        Tipo2_4: Text[1];
        Tipo2_5: Text[1];
        Tipo2_6: Text[1];
        Tipo2_7: Text[15];
        Tipo2_8: Text[15];
        Tipo2_9: Text[15];
        Tipo2_10: Text[15];
        Tipo2_11: Text[15];
        Tipo2_12: Text[15];
        Total2_8: Decimal;
        Total2_9: Decimal;
        Total2_10: Decimal;
        Total2_11: Decimal;
        Total2_12: Decimal;
        Total2_13: Decimal;
        Total2_14: Decimal;
        Total2_15: Decimal;
        Total2_16: Decimal;
        Total2_17: Decimal;
        Entero: Decimal;
        ok: Boolean;

        OtrosTributos: Text[15];

        Texto: Text[1024];

        TextoCbte: Text[1024];

        TextoAlic: Text[1024];
        NumeroLineas: Integer;
        NumeroLineasAlic: Integer;
        EscribirFichero: Boolean;

        TempExcelBuff: Record 370 TEMPORARY;
        TempExcelBuffCbte: Record 370 TEMPORARY;
        TempExcelBuffCbtedesp: Record 370 TEMPORARY;
        TempExcelBuffAlic: Record 370 TEMPORARY;
        RBMgt: Codeunit 419;
        CR: Char;
        FL: Char;
        TextoBis: BigText;
        TextoBisCbte: BigText;
        TextoBisAlic: BigText;
        InfoEmpresa: Record 79;
        ExistCab: Boolean;
        ExistCbte: Boolean;
        ExistAlic: Boolean;
        NumLincab: Integer;
        DespachoImportacion: Text[16];
        CUITEmisor: Text[11];
        denominaciondeEmisor: Text[30];
        IVAComision: Text[15];
        CreditoFiscalComputabledec: Decimal;
        CreditoFiscalComputable: Text[15];
        TextImporteI5: Text[15];
        TextImporteBaseI5: Text[15];
        TextImporteI205: Text[15];
        TextImporteI105: Text[15];
        TextImporteI21: Text[15];
        TextImporteI27: Text[15];
        TextImporteBaseI205: Text[15];
        TextImporteBaseI105: Text[15];
        TextImporteBaseI21: Text[15];
        TextImporteBaseI27: Text[15];
        NUMCOMP: Code[20];
        "//Totales": Integer;
        ExistTotal: Boolean;
        TextoBisTOTAL: BigText;

        FileNameTotal: Text[250];
        TextoTOTAL: Text[1024];
        OutFileTOTAL: File;
        NumLinTotal: Integer;
        "//Fin totales": Integer;
        TempTotalesCITI: Record "GMAAFIP - Concept Type" temporary;
        RecProvincia: Record GMAProvince;
        "VAT Product Posting Group": Record 324;
        ExistAlicDespacho: Boolean;
        TextoBisAlicDespacho: BigText;
        TempExcelBuffAlicDespacho: Record 370 TEMPORARY;
        NumeroLineasAlicDespacho: Integer;
        TextoAlicDespacho: Text[1024];
        OutFileAlicDespacho: File;
        FileNameAlicDespacho: Text[250];
        ExportaTxt: Codeunit "GMAExporta TXT";
        FileName: Text;
        pFileName: Text;
        postingDocDate: Date;
        seePostDate: Boolean;
        Argentina: codeunit GMAArgentina2;
        EsProveedorGenerico: Boolean;
        recTaxJurisdiction: Record "Tax Jurisdiction";
        GlobalDocumentType: Enum "Gen. Journal Document Type";
        GRUPOREGIVAPROD: Record "VAT Product Posting Group";
        docno: Text;
        IsFromPurchase: Boolean;
        PostingPreviewTxt: Label 'Posting Preview';
        xmlport1: XmlPort "GMAXML ImportExport";
        xmlport2: XmlPort "GMAXML ImportExport";
        SLineas: Record "Service Invoice Line";
        SLineasCredito: Record "Service Cr.Memo Line";
        Impuestos: Record "VAT Entry";
        Cliente: Record Customer;
        "-- -Export to CSV ----------": Integer;
        OutFile: File;
        FileNameCbte: Text[250];
        FileNameAlic: Text[250];
        OutFileCbte: File;
        OutFileAlic: File;
        ID_Totals: Integer;
}