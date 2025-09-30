report 80886 "PER R.G. 3685 CITI Ventas"
{
    Caption = 'R.G. 3685 Ventas Comprobante';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Date; Date)
        {
            DataItemTableView = SORTING("Period Type", "Period Start");

            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemTableView = SORTING("Posting Date");

                DataItemLink = "Posting Date" = FIELD("Period Start");

                trigger OnPreDataItem()
                begin
                    Tipo_de_Registro := 1;
                    FiltroFecha := GETFILTER("Posting Date");
                    Controlador_Fiscal := ' ';
                    if (BssiDimension <> '') then
                        if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                            "Sales Invoice Header".SetFilter("Shortcut dimension 1 code", BssiDimension)
                        else
                            "Sales Invoice Header".SetFilter("Shortcut dimension 2 code", BssiDimension);
                end;

                trigger OnAfterGetRecord()
                VAR
                    "AFIP - Tipo Comprobante": Record "GMLocAFIP - Voucher Type";
                    "Actividad empresa": Record "GMLocCompany Activity";
                    "Tipo fiscal": Record "GMLocFiscal Type";
                    Currency: Record 4;
                    FechaVtoCAIT: Text[8];
                    LclTaxGroup: Record 321;
                    recCompActivity: Record "GMLocCompany Activity";
                    recAuxTipoFiscal: Record "GMLocFiscal Type";
                begin
                    recCompActivity.Reset();
                    recCompActivity.SetRange(recCompActivity."GMLocActivity Code", "Sales Invoice Header"."GMLocPoint of Sales");
                    if recCompActivity.FindFirst() then begin
                        if recCompActivity.GMLocInternalPOS then
                            CurrReport.Skip();
                    end;


                    recAuxTipoFiscal.Reset();
                    recAuxTipoFiscal.SetRange(recAuxTipoFiscal.GMLocCode, "Sales Invoice Header"."GMLocFiscal Type");
                    if recAuxTipoFiscal.FindFirst() then
                        if not recAuxTipoFiscal."GMLocSummary in CITI" then
                            CurrReport.Skip();


                    EscribirFichero := TRUE;
                    CLEAR(Tipocambio);
                    CLEAR(Tiporesp);

                    NumeroLineas += 1;

                    CantidadRegistros += 1;
                    IF (CantidadRegistros = 1) THEN BEGIN
                        Anio := DATE2DMY("Posting Date", 3);
                        TextoMes := FORMAT(DATE2DMY("Posting Date", 2));
                        WHILE STRLEN(TextoMes) < 2 DO
                            TextoMes := '0' + TextoMes;
                    END;

                    IF ("Due Date" <> 0D) THEN
                        FechaVencimiento := FORMAT("Due Date", 8, '<Year4><Month,2><Day,2>')
                    ELSE
                        FechaVencimiento := FORMAT("Posting Date", 8, '<Year4><Month,2><Day,2>');


                    Lineas.RESET;
                    Lineas.SETRANGE(Lineas."Document No.", "Sales Invoice Header"."No.");

                    Taxarea.RESET;
                    Taxarea.SETRANGE(Taxarea.Code, "Sales Invoice Header"."Tax Area Code");
                    Cliente.RESET;
                    Cliente.SETRANGE(Cliente."No.", "Sales Invoice Header"."Bill-to Customer No.");

                    CLEAR(Tipo_de_Comprobante);

                    IF ("AFIP - Tipo Comprobante".GET("Sales Invoice Header"."GMLocAFIP Voucher Type")) THEN BEGIN
                        IF ("AFIP - Tipo Comprobante"."GMLocCod 3685" = '') THEN
                            ERROR(Text005)
                        ELSE
                            Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMLocCod 3685"
                    END
                    ELSE
                        Tipo_de_Comprobante := '001';

                    CLEAR(Punto_de_Venta);
                    IF ("Actividad empresa".GET("Sales Invoice Header"."GMLocPoint of Sales")) THEN BEGIN
                        IF ("Actividad empresa"."GMLocCod 3685" = '') THEN
                            ERROR(Text006)
                        ELSE
                            Punto_de_Venta := "Actividad empresa"."GMLocCod 3685"
                    END
                    ELSE
                        Punto_de_Venta := '00001';

                    CLEAR(Numero_de_Comprobante);
                    IF ("Sales Invoice Header"."GMLocAFIP Voucher No." <> 0) THEN BEGIN
                        WHILE STRLEN(Numero_de_Comprobante + FORMAT("Sales Invoice Header"."GMLocAFIP Voucher No.")) < 8 DO
                            Numero_de_Comprobante := Numero_de_Comprobante + '0';

                        Numero_de_Comprobante := Numero_de_Comprobante + FORMAT("Sales Invoice Header"."GMLocAFIP Voucher No.");
                    END
                    ELSE BEGIN
                        IF (STRLEN("Sales Invoice Header"."No.") > 8) THEN
                            Numero_de_Comprobante := COPYSTR("Sales Invoice Header"."No.", STRLEN("Sales Invoice Header"."No.") - 7, 8)
                        ELSE BEGIN
                            WHILE STRLEN(Numero_de_Comprobante + "Sales Invoice Header"."No.") < 8 DO
                                Numero_de_Comprobante := Numero_de_Comprobante + '0';
                            Numero_de_Comprobante := Numero_de_Comprobante + "Sales Invoice Header"."No.";
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
                            //     {
                            //     CUIT := COPYSTR(Cliente."CUIT Argentina", 1, 2);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 4, 8);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 13, 1);
                            //     }
                            CUIT := Cliente."VAT Registration No.";
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;

                        END
                        ELSE
                            WHILE STRLEN(CUIT) < 20 DO
                                CUIT := '0' + CUIT;

                        IF (Cliente."GMLocAFIP Document Type" <> '') THEN
                            Codigo_de_Documento := Cliente."GMLocAFIP Document Type"
                        ELSE
                            Codigo_de_Documento := '80';
                    END;


                    TempTotalesCITI.INIT;
                    //12896-
                    ID_Totals += 1;
                    TempTotalesCITI.GMLocID := FORMAT(ID_Totals);
                    //12896+
                    TempTotalesCITI.GMLocLineNo := NumeroLineas;
                    TempTotalesCITI."GMLocVoucher No" := "Sales Invoice Header"."No.";
                    TempTotalesCITI.GMLocDescription := 'FACTURA';
                    // Campo IMPORTE TOTAL CON IMPUESTOS en Divisa de la Factura con dos decimales Redondeados
                    // en 15 caracteres sin puntos ni comas
                    IF "Sales Invoice Header"."Currency Factor" <> 0 THEN
                        Tipocambio := ROUND(1 / "Sales Invoice Header"."Currency Factor", 0.000001)
                    ELSE
                        Tipocambio := 1;

                    "Sales Invoice Header".CALCFIELDS(Amount, "Amount Including VAT");
                    Valor12 := "Sales Invoice Header"."Amount Including VAT"; // * Tipocambio;

                    WHILE STRLEN("Sales Invoice Header"."Bill-to Name") < 30 DO
                        "Sales Invoice Header"."Bill-to Name" := "Sales Invoice Header"."Bill-to Name" + ' ';

                    IF (STRLEN("Sales Invoice Header"."Bill-to Name") > 30) THEN
                        "Sales Invoice Header"."Bill-to Name" := COPYSTR("Sales Invoice Header"."Bill-to Name", 1, 30);

                    IF (Valor12 < 1000) THEN BEGIN
                        IF ("Tipo fiscal".GET("Sales Invoice Header"."GMLocFiscal Type")) THEN BEGIN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                            IF ("Tipo fiscal"."GMLocCod 3685" = '5') THEN
                                "Sales Invoice Header"."Bill-to Name" := 'CONSUMIDOR FINAL              ';
                        END;
                    END
                    ELSE BEGIN
                        IF ("Tipo fiscal".GET("Sales Invoice Header"."GMLocFiscal Type")) THEN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                    END;

                    // IMPORTES BASE sin impuestos
                    Valor13 := 0; // Conceptos NO Gravados - No generan IVA
                    Valor17 := 0; // Siendo Gravado la Operacion esta Excenta   

                    IF Lineas.FIND('-') THEN
                        REPEAT
                            IF (RecProvincia.GET("Sales Invoice Header".GMLocProvince)) THEN BEGIN
                                IF (RecProvincia."GMLocCod 3685" = '') THEN
                                    ERROR(Text009);
                                IF (RecProvincia."GMLocCod 3685" = '23') THEN BEGIN
                                    Valor17 += Lineas.Amount;// * Tipocambio;
                                END
                                ELSE BEGIN
                                    IF ("Tipo fiscal"."GMLocCod 3685" = '08') OR ("Tipo fiscal"."GMLocCod 3685" = '09') THEN BEGIN
                                        Valor13 += Lineas.Amount;// * Tipocambio
                                    END
                                    ELSE BEGIN
                                        /* IF (Lineas."Tax Liable") THEN BEGIN
                                             IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;
                                             IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                 Valor13 += Lineas.Amount * Tipocambio
                                             ELSE
                                                 IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                     Valor17 += Lineas.Amount * Tipocambio;
                                         END
                                         ELSE BEGIN
                                             Valor17 += Lineas.Amount * Tipocambio;
                                         END;*/
                                        CLEAR(VATBUSPOSTINGGROUP);
                                        IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                                Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                                IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                                IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                    Valor13 += Lineas.Amount// * Tipocambio
                                                ELSE
                                                    IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
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
                                /*IF (Lineas."Tax Liable") THEN BEGIN
                                    IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;
                                    IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado" THEN
                                        Valor13 += Lineas.Amount * Tipocambio
                                    ELSE
                                        IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento THEN
                                            Valor17 += Lineas.Amount * Tipocambio;
                                END
                                ELSE BEGIN
                                    Valor17 += Lineas.Amount * Tipocambio;
                                END;*/
                                CLEAR(VATBUSPOSTINGGROUP);
                                IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                        IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                        IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                            Valor13 += Lineas.Amount// * Tipocambio
                                        ELSE
                                            IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
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

                    calculoImpuestosInvoice("Sales Invoice Header"."No.");
                    /*
				    Impuestos.RESET;
                    Impuestos.SETRANGE(Impuestos."Document No.", "Sales Invoice Header"."No.");

                    Impuestos.SetRange(Impuestos."GMLocDocument Type Loc.", "Sales Invoice Header"."GMLocDocument Type Loc.");
                    IF Impuestos.FIND('-') THEN
                        REPEAT
                            IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::IVA) THEN
                                Valor15 += (Impuestos.Amount / Tipocambio)
                            ELSE BEGIN
                                IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"Ingresos Brutos") THEN
                                    Valor19 += (Impuestos.Amount / Tipocambio)
                                ELSE BEGIN
                                    IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"IVA Percepcion") THEN
                                        Valor18 += (Impuestos.Amount / Tipocambio)
                                    ELSE BEGIN
                                        IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::Otros) THEN
                                            Valor21 += (Impuestos.Amount / Tipocambio)
                                    END;
                                END;
                            END;
                        UNTIL Impuestos.NEXT = 0;
					 */
                    //Campo 9 Importe total de la operaci¢n
                    CLEAR(Entero);
                    Campo12 := Formatvalor(Valor12, 15);
                    EVALUATE(Entero, Campo12);
                    Total2_8 += Entero;
                    // FIN campo 9

                    TempTotalesCITI."GMLocOperation total amount" := Valor12;

                    //Campo 10 Importe total de conceptos que no integran el precio neto gravado
                    CLEAR(Entero);
                    Campo13 := Formatvalor(Valor13, 15);
                    EVALUATE(Entero, Campo13);
                    Total2_9 += Entero;
                    TempTotalesCITI."GMLocImporte no Gravado" := Valor13;
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
                    TempTotalesCITI."GMLocNon categorized perceptio" := Valor16;
                    //Fin campo1 

                    //Campo 12 Importe de operaciones exentas
                    CLEAR(Entero);
                    Campo17 := Formatvalor(Valor17, 15);
                    EVALUATE(Entero, Campo17);
                    Total2_13 += Entero;
                    TempTotalesCITI."GMLocNon taxable Amount" := Valor17;
                    //Fin Campo 12

                    // campo 13   Importe de percepciones o pagos a cuenta de impuestos Nacionales
                    CLEAR(Entero);
                    Campo18 := Formatvalor(Valor18, 15);
                    EVALUATE(Entero, Campo18);
                    Total2_14 += Entero;
                    TempTotalesCITI."GMLocNational Perceptions Amou" := Valor18;
                    //Fin campo 13   

                    //  campo 14 ingresos brutos
                    CLEAR(Entero);
                    Campo19 := Formatvalor(Valor19, 15);
                    EVALUATE(Entero, Campo19);
                    Total2_15 += Entero;
                    TempTotalesCITI."GMLocGIT Amount" := Valor19;
                    //Fin campo 14   

                    //campo campo 15 Importe de percepciones impuestos Municipales
                    Campo20 := Formatvalor(Valor20, 15);
                    EVALUATE(Entero, Campo20);
                    Total2_16 += Entero;
                    TempTotalesCITI."GMLocCity Perceptions Amount" := Valor20;
                    //Fin campo 15  

                    // campo 16 Importe impuestos internos
                    CLEAR(Entero);
                    Campo21 := Formatvalor(Valor21, 15);
                    EVALUATE(Entero, Campo21);
                    Total2_17 += Entero;
                    TempTotalesCITI."GMLocInternal Tax Amount" := Valor21;
                    //Fin Campo 16  

                    IF (Taxarea.GET("Sales Invoice Header"."Tax Area Code")) THEN;

                    IF ("Tipo fiscal".GET("Sales Invoice Header"."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR(Text008)
                        ELSE
                            Tiporesp := "Tipo fiscal"."GMLocCod 3685";
                    END;

                    IF (Currency.GET("Sales Invoice Header"."Currency Code")) THEN BEGIN
                        IF (Currency."GMLocAFIP Code" = '') THEN
                            ERROR(Text007)
                        ELSE
                            Moneda := Currency."GMLocAFIP Code";
                    END
                    ELSE
                        Moneda := 'PES';
                    // {
                    // IF "Sales Invoice Header"."Currency Factor" <>0 THEN
                    // Tipocambio:=ROUND(1/"Sales Invoice Header"."Currency Factor",0.000001)
                    // ELSE
                    // Tipocambio:=1;
                    // }
                    /*Tipocambio := Tipocambio * 1000000;
                    Tipocam := FORMAT(Tipocambio, 0, '<Standard Format,1>');
                    WHILE STRLEN(Tipocam) < 10 DO Tipocam := '0' + Tipocam;
                */
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

                    calculoImpuestosBaseIVA("Sales Invoice Header"."No.");
                    Cantiva := I105 + I21 + I27 + I5;
                    /*
                    Impuestos.SETRANGE(Impuestos."GMLocTax Type Loc", Impuestos."GMLocTax Type Loc"::IVA);
                    IF Impuestos.FIND('-') THEN
                        REPEAT
                            Detalleimpuesto.RESET;
                            Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Jurisdiction Code", Impuestos."Tax Jurisdiction Code");
                            Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Group Code", Impuestos."Tax Group Code");
                            IF (Detalleimpuesto.FINDFIRST) THEN BEGIN
                                IF Detalleimpuesto."Tax Below Maximum" = 10.5 THEN BEGIN
                                    I105 := 1;
                                    ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI105 := ImporteBaseI105 + Impuestos.Base;
                                END;
                                IF Detalleimpuesto."Tax Below Maximum" = 21 THEN BEGIN
                                    I21 := 1;
                                    ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI21 := ImporteBaseI21 + Impuestos.Base;
                                END;
                                IF Detalleimpuesto."Tax Below Maximum" = 27 THEN BEGIN
                                    I27 := 1;
                                    ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI27 := ImporteBaseI27 + Impuestos.Base;
                                END;
                            END;
                        UNTIL Impuestos.NEXT = 0;
                    */
                    Cantiva := I105 + I21 + I27;


                    IF (I105 <> 0) THEN BEGIN
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := ImporteBaseI105;
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
                        TempTotalesCITI.GMLocVAT5 := ImporteI5;
                        TempTotalesCITI.GMLocBase5 := ImporteBaseI5;
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
                        TempTotalesCITI.GMLocVAT21 := ImporteI21;
                        TempTotalesCITI.GMLocBase21 := ImporteBaseI21;
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
                        TempTotalesCITI.GMLociva27 := ImporteI27;
                        TempTotalesCITI.GMLocBase27 := ImporteBaseI27;
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
                        CASE "Sales Invoice Header"."Tax Area Code" OF
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
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := 0; // es importe total de la factura
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


                    //---------------- COMPROBANTE ---------------
                    IF Cantiva = 0 THEN Cantiva := 1;  // Se debe indicar 1 aun cuando la operaci¢n sea Exenta

                    OtrosTributos := '000000000000000';
                    IF (GMLocCAI2 = '') THEN
                        GMLocCAI2 := '00000000000000';
                    IF ("GMLocCAI Due Date2" = 0D) THEN
                        FechaVtoCAIT := '00000000'
                    ELSE
                        FechaVtoCAIT := FORMAT("GMLocCAI Due Date2", 8, '<Year4><Month,2><Day,2>');

                    TempTotalesCITI.INSERT;
                    CLEAR(postingDocDate);
                    IF (seePostDate) THEN
                        postingDocDate := "Sales Invoice Header"."Posting Date"
                    else
                        postingDocDate := "Sales Invoice Header"."Document Date";
                    CLEAR(TextoCbte);
                    TextoCbte := (
                    FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT("Bill-to Name") +
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


            }
            dataitem("Service Invoice Header"; "Service Invoice Header")
            {
                DataItemTableView = SORTING("Posting Date");

                DataItemLink = "Posting Date" = FIELD("Period Start");

                trigger OnPreDataItem()
                begin
                    Tipo_de_Registro := 1;
                    FiltroFecha := GETFILTER("Posting Date");
                    Controlador_Fiscal := ' ';
                    if (BssiDimension <> '') then
                        if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                            "Sales Invoice Header".SetFilter("Shortcut dimension 1 code", BssiDimension)
                        else
                            "Sales Invoice Header".SetFilter("Shortcut dimension 2 code", BssiDimension);
                end;

                trigger OnAfterGetRecord()
                VAR
                    "AFIP - Tipo Comprobante": Record "GMLocAFIP - Voucher Type";
                    "Actividad empresa": Record "GMLocCompany Activity";
                    "Tipo fiscal": Record "GMLocFiscal Type";
                    Currency: Record 4;
                    FechaVtoCAIT: Text[8];
                    LclTaxGroup: Record 321;
                    recCompActivity: Record "GMLocCompany Activity";
                    recAuxTipoFiscal: Record "GMLocFiscal Type";
                begin

                    if ("Shortcut Dimension 1 Code" = '') or ("Shortcut Dimension 2 Code" = '') then
                        CurrReport.Skip();
                    if not ("Shortcut Dimension 1 Code" = BssiDimension) or not ("Shortcut Dimension 2 Code" = BssiDimension) then
                        CurrReport.Skip();

                    if ("Service Invoice Header"."GMLocFiscal Type" = '90-NO LIBRO IVA') then
                        CurrReport.skip();

                    recCompActivity.Reset();
                    recCompActivity.SetRange(recCompActivity."GMLocActivity Code", "Service Invoice Header"."GMLocPoint of Sales");
                    if recCompActivity.FindFirst() then begin
                        if recCompActivity.GMLocInternalPOS then
                            CurrReport.Skip();
                    end;


                    recAuxTipoFiscal.Reset();
                    recAuxTipoFiscal.SetRange(recAuxTipoFiscal.GMLocCode, "Service Invoice Header"."GMLocFiscal Type");
                    if recAuxTipoFiscal.FindFirst() then
                        if not recAuxTipoFiscal."GMLocSummary in CITI" then
                            CurrReport.Skip();


                    EscribirFichero := TRUE;
                    CLEAR(Tipocambio);
                    CLEAR(Tiporesp);

                    NumeroLineas += 1;

                    CantidadRegistros += 1;
                    IF (CantidadRegistros = 1) THEN BEGIN
                        Anio := DATE2DMY("Posting Date", 3);
                        TextoMes := FORMAT(DATE2DMY("Posting Date", 2));
                        WHILE STRLEN(TextoMes) < 2 DO
                            TextoMes := '0' + TextoMes;
                    END;

                    IF ("Due Date" <> 0D) THEN
                        FechaVencimiento := FORMAT("Due Date", 8, '<Year4><Month,2><Day,2>')
                    ELSE
                        FechaVencimiento := FORMAT("Posting Date", 8, '<Year4><Month,2><Day,2>');


                    SLineas.RESET;
                    SLineas.SETRANGE(SLineas."Document No.", "Service Invoice Header"."No.");

                    Taxarea.RESET;
                    Taxarea.SETRANGE(Taxarea.Code, "Service Invoice Header"."Tax Area Code");
                    Cliente.RESET;
                    Cliente.SETRANGE(Cliente."No.", "Service Invoice Header"."Bill-to Customer No.");

                    CLEAR(Tipo_de_Comprobante);

                    IF ("AFIP - Tipo Comprobante".GET("Service Invoice Header"."GMLocAFIP Voucher Type")) THEN BEGIN
                        IF ("AFIP - Tipo Comprobante"."GMLocCod 3685" = '') THEN
                            ERROR(Text005)
                        ELSE
                            Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMLocCod 3685"
                    END
                    ELSE
                        Tipo_de_Comprobante := '001';

                    CLEAR(Punto_de_Venta);
                    IF ("Actividad empresa".GET("Service Invoice Header"."GMLocPoint of Sales")) THEN BEGIN
                        IF ("Actividad empresa"."GMLocCod 3685" = '') THEN
                            ERROR(Text006)
                        ELSE
                            Punto_de_Venta := "Actividad empresa"."GMLocCod 3685"
                    END
                    ELSE
                        Punto_de_Venta := '00001';

                    CLEAR(Numero_de_Comprobante);
                    IF ("Service Invoice Header"."GMLocAFIP Voucher No." <> 0) THEN BEGIN
                        WHILE STRLEN(Numero_de_Comprobante + FORMAT("Service Invoice Header"."GMLocAFIP Voucher No.")) < 8 DO
                            Numero_de_Comprobante := Numero_de_Comprobante + '0';

                        Numero_de_Comprobante := Numero_de_Comprobante + FORMAT("Service Invoice Header"."GMLocAFIP Voucher No.");
                    END
                    ELSE BEGIN
                        IF (STRLEN("Service Invoice Header"."No.") > 8) THEN
                            Numero_de_Comprobante := COPYSTR("Service Invoice Header"."No.", STRLEN("Service Invoice Header"."No.") - 7, 8)
                        ELSE BEGIN
                            WHILE STRLEN(Numero_de_Comprobante + "Service Invoice Header"."No.") < 8 DO
                                Numero_de_Comprobante := Numero_de_Comprobante + '0';
                            Numero_de_Comprobante := Numero_de_Comprobante + "Service Invoice Header"."No.";
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
                            //     {
                            //     CUIT := COPYSTR(Cliente."CUIT Argentina", 1, 2);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 4, 8);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 13, 1);
                            //     }
                            CUIT := Cliente."VAT Registration No.";
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;

                        END
                        ELSE
                            WHILE STRLEN(CUIT) < 20 DO
                                CUIT := '0' + CUIT;

                        IF (Cliente."GMLocAFIP Document Type" <> '') THEN
                            Codigo_de_Documento := Cliente."GMLocAFIP Document Type"
                        ELSE
                            Codigo_de_Documento := '80';
                    END;


                    TempTotalesCITI.INIT;
                    //12896-
                    ID_Totals += 1;
                    TempTotalesCITI.GMLocID := FORMAT(ID_Totals);
                    //12896+
                    TempTotalesCITI.GMLocLineNo := NumeroLineas;
                    TempTotalesCITI."GMLocVoucher No" := "Service Invoice Header"."No.";
                    TempTotalesCITI.GMLocDescription := 'FACTURA';
                    // Campo IMPORTE TOTAL CON IMPUESTOS en Divisa de la Factura con dos decimales Redondeados
                    // en 15 caracteres sin puntos ni comas
                    IF "Service Invoice Header"."Currency Factor" <> 0 THEN
                        Tipocambio := ROUND(1 / "Service Invoice Header"."Currency Factor", 0.000001)
                    ELSE
                        Tipocambio := 1;

                    "Service Invoice Header".CALCFIELDS(Amount, "Amount Including VAT");
                    Valor12 := "Service Invoice Header"."Amount Including VAT"; // * Tipocambio;

                    WHILE STRLEN("Service Invoice Header"."Bill-to Name") < 30 DO
                        "Service Invoice Header"."Bill-to Name" := "Service Invoice Header"."Bill-to Name" + ' ';

                    IF (STRLEN("Service Invoice Header"."Bill-to Name") > 30) THEN
                        "Service Invoice Header"."Bill-to Name" := COPYSTR("Service Invoice Header"."Bill-to Name", 1, 30);

                    IF (Valor12 < 1000) THEN BEGIN
                        IF ("Tipo fiscal".GET("Service Invoice Header"."GMLocFiscal Type")) THEN BEGIN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                            IF ("Tipo fiscal"."GMLocCod 3685" = '5') THEN
                                "Service Invoice Header"."Bill-to Name" := 'CONSUMIDOR FINAL              ';
                        END;
                    END
                    ELSE BEGIN
                        IF ("Tipo fiscal".GET("Service Invoice Header"."GMLocFiscal Type")) THEN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                    END;

                    // IMPORTES BASE sin impuestos
                    Valor13 := 0; // Conceptos NO Gravados - No generan IVA
                    Valor17 := 0; // Siendo Gravado la Operacion esta Excenta   

                    IF SLineas.FIND('-') THEN
                        REPEAT
                            IF (RecProvincia.GET("Service Invoice Header".GMLocProvince)) THEN BEGIN
                                IF (RecProvincia."GMLocCod 3685" = '') THEN
                                    ERROR(Text009);
                                IF (RecProvincia."GMLocCod 3685" = '23') THEN BEGIN
                                    Valor17 += SLineas.Amount;// * Tipocambio;
                                END
                                ELSE BEGIN
                                    IF ("Tipo fiscal"."GMLocCod 3685" = '08') OR ("Tipo fiscal"."GMLocCod 3685" = '09') THEN BEGIN
                                        Valor13 += SLineas.Amount;// * Tipocambio
                                    END
                                    ELSE BEGIN
                                        /* IF (SLineas."Tax Liable") THEN BEGIN
                                             IF (LclTaxGroup.GET(SLineas."Tax Group Code")) THEN;
                                             IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                 Valor13 += SLineas.Amount * Tipocambio
                                             ELSE
                                                 IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                     Valor17 += SLineas.Amount * Tipocambio;
                                         END
                                         ELSE BEGIN
                                             Valor17 += SLineas.Amount * Tipocambio;
                                         END;*/
                                        CLEAR(VATBUSPOSTINGGROUP);
                                        IF (VATBUSPOSTINGGROUP.GET(SLineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                            if (SLineas."VAT Calculation Type" = SLineas."VAT Calculation Type"::"Normal VAT") then
                                                Valor13 += SLineas."VAT Base Amount";// * Tipocambio;



                                            if (SLineas."VAT Calculation Type" = SLineas."VAT Calculation Type"::"Sales Tax") then begin
                                                IF (LclTaxGroup.GET(SLineas."Tax Group Code")) THEN;

                                                IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                    Valor13 += SLineas.Amount// * Tipocambio
                                                ELSE
                                                    IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                        Valor17 += SLineas.Amount;//* Tipocambio;
                                            end;

                                        end
                                        else begin
                                            if (SLineas."VAT Calculation Type" = SLineas."VAT Calculation Type"::"Normal VAT") then
                                                Valor13 += SLineas."VAT Base Amount";// * Tipocambio;
                                        end;


                                    END;
                                END
                            END
                            ELSE BEGIN
                                /*IF (SLineas."Tax Liable") THEN BEGIN
                                    IF (LclTaxGroup.GET(SLineas."Tax Group Code")) THEN;
                                    IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado" THEN
                                        Valor13 += SLineas.Amount * Tipocambio
                                    ELSE
                                        IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento THEN
                                            Valor17 += SLineas.Amount * Tipocambio;
                                END
                                ELSE BEGIN
                                    Valor17 += SLineas.Amount * Tipocambio;
                                END;*/
                                CLEAR(VATBUSPOSTINGGROUP);
                                IF (VATBUSPOSTINGGROUP.GET(SLineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                    if (SLineas."VAT Calculation Type" = SLineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += SLineas."VAT Base Amount";// * Tipocambio;



                                    if (SLineas."VAT Calculation Type" = SLineas."VAT Calculation Type"::"Sales Tax") then begin
                                        IF (LclTaxGroup.GET(SLineas."Tax Group Code")) THEN;

                                        IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                            Valor13 += SLineas.Amount// * Tipocambio
                                        ELSE
                                            IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                Valor17 += SLineas.Amount;//* Tipocambio;
                                    end;

                                end
                                else begin
                                    if (SLineas."VAT Calculation Type" = SLineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += SLineas."VAT Base Amount";// * Tipocambio;
                                end;
                            END;
                        UNTIL SLineas.NEXT = 0;
                    // IMPUESTOS

                    Valor15 := 0;  // IVA
                    Valor16 := 0;  // Percepciones a No Categorizados o RNI
                    Valor18 := 0;  // Percepciones Nacionales
                    Valor19 := 0;  // Ingresos Brutos
                    Valor20 := 0;  // Impuestos Municipales por ahora no hay configurados
                    Valor21 := 0;  // Impuestos Internos por ahora no hay configurados
                    CLEAR(GlobalDocumentType);
                    GlobalDocumentType := GlobalDocumentType::Invoice;
                    calculoImpuestosInvoice("Service Invoice Header"."No.");
                    /*
                    Impuestos.RESET;
                    Impuestos.SETRANGE(Impuestos."Document No.", "Service Invoice Header"."No.");

                    Impuestos.SetRange(Impuestos."GMLocDocument Type Loc.", "Service Invoice Header"."GMLocDocument Type Loc.");
                    IF Impuestos.FIND('-') THEN
                        REPEAT
                            IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::IVA) THEN
                                Valor15 += (Impuestos.Amount / Tipocambio)
                            ELSE BEGIN
                                IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"Ingresos Brutos") THEN
                                    Valor19 += (Impuestos.Amount / Tipocambio)
                                ELSE BEGIN
                                    IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"IVA Percepcion") THEN
                                        Valor18 += (Impuestos.Amount / Tipocambio)
                                    ELSE BEGIN
                                        IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::Otros) THEN
                                            Valor21 += (Impuestos.Amount / Tipocambio)
                                    END;
                                END;
                            END;
                        UNTIL Impuestos.NEXT = 0;
                     */
                    //Campo 9 Importe total de la operaci¢n
                    CLEAR(Entero);
                    Campo12 := Formatvalor(Valor12, 15);
                    EVALUATE(Entero, Campo12);
                    Total2_8 += Entero;
                    // FIN campo 9

                    TempTotalesCITI."GMLocOperation total amount" := Valor12;

                    //Campo 10 Importe total de conceptos que no integran el precio neto gravado
                    CLEAR(Entero);
                    Campo13 := Formatvalor(Valor13, 15);
                    EVALUATE(Entero, Campo13);
                    Total2_9 += Entero;
                    TempTotalesCITI."GMLocImporte no Gravado" := Valor13;
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
                    TempTotalesCITI."GMLocNon categorized perceptio" := Valor16;
                    //Fin campo1 

                    //Campo 12 Importe de operaciones exentas
                    CLEAR(Entero);
                    Campo17 := Formatvalor(Valor17, 15);
                    EVALUATE(Entero, Campo17);
                    Total2_13 += Entero;
                    TempTotalesCITI."GMLocNon taxable Amount" := Valor17;
                    //Fin Campo 12

                    // campo 13   Importe de percepciones o pagos a cuenta de impuestos Nacionales
                    CLEAR(Entero);
                    Campo18 := Formatvalor(Valor18, 15);
                    EVALUATE(Entero, Campo18);
                    Total2_14 += Entero;
                    TempTotalesCITI."GMLocNational Perceptions Amou" := Valor18;
                    //Fin campo 13   

                    //  campo 14 ingresos brutos
                    CLEAR(Entero);
                    Campo19 := Formatvalor(Valor19, 15);
                    EVALUATE(Entero, Campo19);
                    Total2_15 += Entero;
                    TempTotalesCITI."GMLocGIT Amount" := Valor19;
                    //Fin campo 14   

                    //campo campo 15 Importe de percepciones impuestos Municipales
                    Campo20 := Formatvalor(Valor20, 15);
                    EVALUATE(Entero, Campo20);
                    Total2_16 += Entero;
                    TempTotalesCITI."GMLocCity Perceptions Amount" := Valor20;
                    //Fin campo 15  

                    // campo 16 Importe impuestos internos
                    CLEAR(Entero);
                    Campo21 := Formatvalor(Valor21, 15);
                    EVALUATE(Entero, Campo21);
                    Total2_17 += Entero;
                    TempTotalesCITI."GMLocInternal Tax Amount" := Valor21;
                    //Fin Campo 16  

                    IF (Taxarea.GET("Service Invoice Header"."Tax Area Code")) THEN;

                    IF ("Tipo fiscal".GET("Service Invoice Header"."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR(Text008)
                        ELSE
                            Tiporesp := "Tipo fiscal"."GMLocCod 3685";
                    END;

                    IF (Currency.GET("Service Invoice Header"."Currency Code")) THEN BEGIN
                        IF (Currency."GMLocAFIP Code" = '') THEN
                            ERROR(Text007)
                        ELSE
                            Moneda := Currency."GMLocAFIP Code";
                    END
                    ELSE
                        Moneda := 'PES';
                    // {
                    // IF "Sales Invoice Header"."Currency Factor" <>0 THEN
                    // Tipocambio:=ROUND(1/"Sales Invoice Header"."Currency Factor",0.000001)
                    // ELSE
                    // Tipocambio:=1;
                    // }
                    /*Tipocambio := Tipocambio * 1000000;
                    Tipocam := FORMAT(Tipocambio, 0, '<Standard Format,1>');
                    WHILE STRLEN(Tipocam) < 10 DO Tipocam := '0' + Tipocam;
*/
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

                    calculoImpuestosBaseIVA("Service Invoice Header"."No.");
                    /*
                                        Impuestos.SETRANGE(Impuestos."GMLocTax Type Loc", Impuestos."GMLocTax Type Loc"::IVA);
                                        IF Impuestos.FIND('-') THEN
                                            REPEAT
                                                Detalleimpuesto.RESET;
                                                Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Jurisdiction Code", Impuestos."Tax Jurisdiction Code");
                                                Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Group Code", Impuestos."Tax Group Code");
                                                IF (Detalleimpuesto.FINDFIRST) THEN BEGIN
                                                    IF Detalleimpuesto."Tax Below Maximum" = 10.5 THEN BEGIN
                                                        I105 := 1;
                                                        ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI105 := ImporteBaseI105 + Impuestos.Base;
                                                    END;
                                                    IF Detalleimpuesto."Tax Below Maximum" = 21 THEN BEGIN
                                                        I21 := 1;
                                                        ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI21 := ImporteBaseI21 + Impuestos.Base;
                                                    END;
                                                    IF Detalleimpuesto."Tax Below Maximum" = 27 THEN BEGIN
                                                        I27 := 1;
                                                        ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI27 := ImporteBaseI27 + Impuestos.Base;
                                                    END;
                                                END;
                                            UNTIL Impuestos.NEXT = 0;
                                            */
                    Cantiva := I105 + I21 + I27;


                    IF (I105 <> 0) THEN BEGIN
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := ImporteBaseI105;
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

                    IF (I21 <> 0) THEN BEGIN
                        TempTotalesCITI.GMLocVAT21 := ImporteI21;
                        TempTotalesCITI.GMLocBase21 := ImporteBaseI21;
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
                        TempTotalesCITI.GMLociva27 := ImporteI27;
                        TempTotalesCITI.GMLocBase27 := ImporteBaseI27;
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
                        CASE "Service Invoice Header"."Tax Area Code" OF
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
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := 0; // es importe total de la factura
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


                    //---------------- COMPROBANTE ---------------
                    IF Cantiva = 0 THEN Cantiva := 1;  // Se debe indicar 1 aun cuando la operaci¢n sea Exenta

                    OtrosTributos := '000000000000000';
                    IF (GMLocCAI2 = '') THEN
                        GMLocCAI2 := '00000000000000';
                    IF ("GMLocCAI Due Date2" = 0D) THEN
                        FechaVtoCAIT := '00000000'
                    ELSE
                        FechaVtoCAIT := FORMAT("GMLocCAI Due Date2", 8, '<Year4><Month,2><Day,2>');

                    TempTotalesCITI.INSERT;
                    CLEAR(postingDocDate);
                    IF (seePostDate) THEN
                        postingDocDate := "Service Invoice Header"."Posting Date"
                    else
                        postingDocDate := "Service Invoice Header"."Document Date";
                    CLEAR(TextoCbte);
                    TextoCbte := (
                    FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT("Bill-to Name") +
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


            }
            dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
            {
                DataItemTableView = SORTING("Posting Date");


                DataItemLink = "Posting Date" = FIELD("Period Start");

                trigger OnAfterGetRecord()
                var
                    "AFIP - Tipo Comprobante": Record "GMLocAFIP - Voucher Type";
                    "Actividad empresa": Record "GMLocCompany Activity";
                    "Tipo fiscal": Record "GMLocFiscal Type";
                    Currency: Record 4;
                    FechaVtoCAIT: Text[8];
                    LclTaxGroup: Record 321;

                    recCompActivity: Record "GMLocCompany Activity";
                    recAuxTipoFiscal: Record "GMLocFiscal Type";
                begin
                    if ("Shortcut Dimension 1 Code" = '') or ("Shortcut Dimension 2 Code" = '') then
                        CurrReport.Skip();
                    if not ("Shortcut Dimension 1 Code" = BssiDimension) or not ("Shortcut Dimension 2 Code" = BssiDimension) then
                        CurrReport.Skip();

                    if ("Sales Cr.Memo Header"."GMLocFiscal Type" = '90-NO LIBRO IVA') then
                        CurrReport.skip();

                    recCompActivity.Reset();
                    recCompActivity.SetRange(recCompActivity."GMLocActivity Code", "Sales Cr.Memo Header"."GMLocPoint of Sales");
                    if recCompActivity.FindFirst() then begin
                        if recCompActivity.GMLocInternalPOS then
                            CurrReport.Skip();
                    end;


                    recAuxTipoFiscal.Reset();
                    recAuxTipoFiscal.SetRange(recAuxTipoFiscal.GMLocCode, "Sales Cr.Memo Header"."GMLocFiscal Type");
                    if recAuxTipoFiscal.FindFirst() then
                        if not recAuxTipoFiscal."GMLocSummary in CITI" then
                            CurrReport.Skip();

                    CLEAR(Tipocambio);
                    CLEAR(Tiporesp);
                    NumeroLineas += 1;
                    CantidadRegistros += 1;
                    LineasCredito.RESET;
                    LineasCredito.SETRANGE(LineasCredito."Document No.", "Sales Cr.Memo Header"."No.");

                    Taxarea.RESET;
                    Taxarea.SETRANGE(Taxarea.Code, "Sales Cr.Memo Header"."Tax Area Code");
                    Cliente.RESET;
                    Cliente.SETRANGE(Cliente."No.", "Sales Cr.Memo Header"."Sell-to Customer No.");

                    CLEAR(Tipo_de_Comprobante);

                    IF ("AFIP - Tipo Comprobante".GET("Sales Cr.Memo Header"."GMLocAFIP Voucher Type")) THEN BEGIN
                        IF ("AFIP - Tipo Comprobante"."GMLocCod 3685" = '') THEN
                            ERROR(Text005)
                        ELSE
                            Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMLocCod 3685"
                    END
                    ELSE
                        Tipo_de_Comprobante := '003';
                    // Fin Tipo de comprobante

                    // 22) Fecha de Vencimiento Pago
                    FechaVencimiento := '00000000';
                    // Fin Fecha de Vencimiento Pago

                    // 3) Punto de venta
                    CLEAR(Punto_de_Venta);

                    IF ("Actividad empresa".GET("Sales Cr.Memo Header"."GMLocPoint of Sales")) THEN BEGIN
                        IF ("Actividad empresa"."GMLocCod 3685" = '') THEN
                            ERROR(Text006)
                        ELSE
                            Punto_de_Venta := "Actividad empresa"."GMLocCod 3685"
                    END
                    ELSE
                        Punto_de_Venta := '00001';

                    CLEAR(Numero_de_Comprobante);
                    IF ("Sales Cr.Memo Header"."GMLocAFIP Voucher No." <> 0) THEN BEGIN
                        WHILE STRLEN(Numero_de_Comprobante + FORMAT("Sales Cr.Memo Header"."GMLocAFIP Voucher No.")) < 8 DO
                            Numero_de_Comprobante := Numero_de_Comprobante + '0';

                        Numero_de_Comprobante := Numero_de_Comprobante + FORMAT("Sales Cr.Memo Header"."GMLocAFIP Voucher No.");


                    END
                    ELSE BEGIN
                        IF (STRLEN("Sales Cr.Memo Header"."No.") > 8) THEN
                            Numero_de_Comprobante := COPYSTR("Sales Cr.Memo Header"."No.",
                                                                            STRLEN("Sales Cr.Memo Header"."No.") - 7, 8)
                        ELSE BEGIN
                            WHILE STRLEN(Numero_de_Comprobante + "Sales Cr.Memo Header"."No.") < 8 DO
                                Numero_de_Comprobante := Numero_de_Comprobante + '0';
                            Numero_de_Comprobante := Numero_de_Comprobante + "Sales Cr.Memo Header"."No.";
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
                            //           {
                            //           CUIT := COPYSTR(Cliente."CUIT Argentina", 1, 2);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 4, 8);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 13, 1);
                            //           }
                            CUIT := Cliente."VAT Registration No.";
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;

                        END
                        ELSE
                            WHILE STRLEN(CUIT) < 20 DO
                                CUIT := '0' + CUIT;

                        IF (Cliente."GMLocAFIP Document Type" <> '') THEN
                            Codigo_de_Documento := Cliente."GMLocAFIP Document Type"
                        ELSE
                            Codigo_de_Documento := '80';
                    END;


                    TempTotalesCITI.INIT;
                    //12896-
                    ID_Totals += 1;
                    TempTotalesCITI.GMLocID := FORMAT(ID_Totals);
                    //12896+
                    TempTotalesCITI.GMLocLineNo := NumeroLineas;
                    TempTotalesCITI."GMLocVoucher No" := "Sales Cr.Memo Header"."No.";
                    TempTotalesCITI.GMLocDescription := 'N/C';

                    // Campo IMPORTE TOTAL CON IMPUESTOS en Divisa de la Factura con dos decimales Redondeados
                    // en 15 caracteres sin puntos ni comas
                    IF "Sales Cr.Memo Header"."Currency Factor" <> 0 THEN
                        Tipocambio := ROUND(1 / "Sales Cr.Memo Header"."Currency Factor", 0.000001)
                    ELSE
                        Tipocambio := 1;

                    "Sales Cr.Memo Header".CALCFIELDS(Amount, "Amount Including VAT");
                    Valor12 := "Sales Cr.Memo Header"."Amount Including VAT";// * Tipocambio;

                    WHILE STRLEN("Bill-to Name") < 30 DO
                        "Bill-to Name" := "Bill-to Name" + ' ';

                    IF (STRLEN("Bill-to Name") > 30) THEN
                        "Bill-to Name" := COPYSTR("Bill-to Name", 1, 30);

                    IF (Valor12 < 1000) THEN BEGIN
                        IF ("Tipo fiscal".GET("Sales Cr.Memo Header"."GMLocFiscal Type")) THEN BEGIN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                            IF ("Tipo fiscal"."GMLocCod 3685" = '5') THEN
                                "Sales Cr.Memo Header"."Bill-to Name" := 'CONSUMIDOR FINAL              ';
                        END;
                    END
                    ELSE BEGIN
                        IF ("Tipo fiscal".GET("Sales Cr.Memo Header"."GMLocFiscal Type")) THEN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                    END;

                    // IMPORTES BASE sin impuestos
                    Valor13 := 0; // Conceptos NO Gravados - No generan IVA
                    Valor17 := 0; // Siendo Gravado la Operacion esta Excenta  

                    IF LineasCredito.FIND('-') THEN
                        REPEAT
                            IF (RecProvincia.GET("Sales Cr.Memo Header".GMLocProvince)) THEN BEGIN
                                IF (RecProvincia."GMLocCod 3685" = '') THEN
                                    ERROR(Text009);
                                IF (RecProvincia."GMLocCod 3685" = '23') THEN BEGIN
                                    Valor17 += LineasCredito.Amount;// * Tipocambio;
                                END
                                ELSE BEGIN
                                    IF ("Tipo fiscal"."GMLocCod 3685" = '08') OR ("Tipo fiscal"."GMLocCod 3685" = '09') THEN BEGIN
                                        Valor13 += LineasCredito.Amount;// * Tipocambio
                                    END
                                    ELSE BEGIN
                                        /*IF (LineasCredito."Tax Liable") THEN BEGIN
                                            IF (LclTaxGroup.GET(LineasCredito."Tax Group Code")) THEN;
                                            IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                Valor13 += LineasCredito.Amount * Tipocambio
                                            ELSE
                                                IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                    Valor17 += LineasCredito.Amount * Tipocambio;
                                        END
                                        ELSE BEGIN
                                            Valor17 += LineasCredito.Amount * Tipocambio;
                                        END;*/
                                        CLEAR(VATBUSPOSTINGGROUP);
                                        IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                                Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                                IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                                IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                    Valor13 += Lineas.Amount// * Tipocambio
                                                ELSE
                                                    IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
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
                                /*IF (LineasCredito."Tax Liable") THEN BEGIN
                                    IF (LclTaxGroup.GET(LineasCredito."Tax Group Code")) THEN;
                                    IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado" THEN
                                        Valor13 += LineasCredito.Amount * Tipocambio
                                    ELSE
                                        IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento THEN
                                            Valor17 += LineasCredito.Amount * Tipocambio;
                                END
                                ELSE BEGIN
                                    Valor17 += LineasCredito.Amount * Tipocambio;
                                END;*/
                                CLEAR(VATBUSPOSTINGGROUP);
                                IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                        IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                        IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                            Valor13 += Lineas.Amount// * Tipocambio
                                        ELSE
                                            IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                Valor17 += Lineas.Amount;//* Tipocambio;
                                    end;

                                end
                                else begin
                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += Lineas."VAT Base Amount";// * Tipocambio;
                                end;
                            END;
                        UNTIL LineasCredito.NEXT = 0;

                    // IMPUESTOS

                    Valor15 := 0;  // IVA
                    Valor16 := 0;  // Percepciones a No Categorizados o RNI
                    Valor18 := 0;  // Percepciones Nacionales
                    Valor19 := 0;  // Ingresos Brutos
                    Valor20 := 0;  // Impuestos Municipales por ahora no hay configurados
                    Valor21 := 0;  // Impuestos Internos por ahora no hay configurados

                    CLEAR(GlobalDocumentType);
                    GlobalDocumentType := GlobalDocumentType::"Credit Memo";
                    calculoImpuestosInvoice("Sales Cr.Memo Header"."No.");
                    /*
				    Impuestos.RESET;
                    Impuestos.SETRANGE(Impuestos."Document No.", "Sales Cr.Memo Header"."No.");

                    Impuestos.SetRange(Impuestos."GMLocDocument Type Loc.", "Sales Cr.Memo Header"."GMLocDocument Type Loc.");
                    IF Impuestos.FIND('-') THEN
                        REPEAT
                            IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::IVA) THEN
                                Valor15 += (Impuestos.Amount / Tipocambio)
                            ELSE BEGIN
                                IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"Ingresos Brutos") THEN
                                    Valor19 += (Impuestos.Amount / Tipocambio)
                                ELSE BEGIN
                                    IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"IVA Percepcion") THEN
                                        Valor18 += (Impuestos.Amount / Tipocambio)
                                    ELSE BEGIN
                                        IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::Otros) THEN
                                            Valor21 += (Impuestos.Amount / Tipocambio)
                                    END;
                                END;
                            END;
                        UNTIL Impuestos.NEXT = 0;
					 */
                    //Campo 9 Importe total de la operaci¢n
                    CLEAR(Entero);
                    Campo12 := Formatvalor(Valor12, 15);
                    EVALUATE(Entero, Campo12);
                    Total2_8 += Entero;
                    // FIN campo 9

                    TempTotalesCITI."GMLocOperation total amount" := -Valor12;

                    //Campo 10 Importe total de conceptos que no integran el precio neto gravado
                    CLEAR(Entero);
                    Campo13 := Formatvalor(Valor13, 15);
                    EVALUATE(Entero, Campo13);
                    Total2_9 += Entero;
                    TempTotalesCITI."GMLocImporte no Gravado" := -Valor13;
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
                    Total2_12 -= Entero;
                    TempTotalesCITI."GMLocNon categorized perceptio" := Valor16;
                    //Fin campo1

                    //Campo 12 Importe de operaciones exentas
                    CLEAR(Entero);
                    Campo17 := Formatvalor(Valor17, 15);
                    EVALUATE(Entero, Campo17);
                    Total2_13 -= Entero;
                    TempTotalesCITI."GMLocNon taxable Amount" := -Valor17;
                    //Fin Campo 12

                    // campo 13   Importe de percepciones o pagos a cuenta de impuestos Nacionales
                    CLEAR(Entero);
                    Campo18 := Formatvalor(Valor18, 15);
                    EVALUATE(Entero, Campo18);
                    Total2_14 -= Entero;
                    TempTotalesCITI."GMLocNational Perceptions Amou" := Valor18;
                    //Fin campo 13  

                    //  campo 14 ingresos brutos
                    CLEAR(Entero);
                    Campo19 := Formatvalor(Valor19, 15);
                    EVALUATE(Entero, Campo19);
                    Total2_15 -= Entero;
                    TempTotalesCITI."GMLocGIT Amount" := Valor19;
                    //Fin campo 14

                    //campo campo 15 Importe de percepciones impuestos Municipales
                    Campo20 := Formatvalor(Valor20, 15);
                    EVALUATE(Entero, Campo20);
                    Total2_16 += Entero;
                    TempTotalesCITI."GMLocCity Perceptions Amount" := Valor20;
                    //Fin campo 15

                    // campo 16 Importe impuestos internos
                    CLEAR(Entero);
                    Campo21 := Formatvalor(Valor21, 15);
                    EVALUATE(Entero, Campo21);
                    Total2_17 += Entero;
                    TempTotalesCITI."GMLocInternal Tax Amount" := Valor21;
                    //Fin Campo 16  

                    IF (Taxarea.GET("Sales Cr.Memo Header"."Tax Area Code")) THEN;

                    IF ("Tipo fiscal".GET("Sales Cr.Memo Header"."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR(Text008)
                        ELSE
                            Tiporesp := "Tipo fiscal"."GMLocCod 3685";
                    END;

                    IF (Currency.GET("Sales Cr.Memo Header"."Currency Code")) THEN BEGIN
                        IF (Currency."GMLocAFIP Code" = '') THEN
                            ERROR(Text007)
                        ELSE
                            Moneda := Currency."GMLocAFIP Code";
                    END
                    ELSE
                        Moneda := 'PES';
                    // {
                    // IF "Sales Cr.Memo Header"."Currency Factor" <>0
                    //     THEN Tipocambio:=ROUND(1/"Sales Cr.Memo Header"."Currency Factor",0.000001)
                    //     ELSE Tipocambio:=1;
                    //     }
                    /*Tipocambio := Tipocambio * 1000000;
                    Tipocam := FORMAT(Tipocambio, 0, '<Standard Format,1>');
                    WHILE STRLEN(Tipocam) < 10 DO Tipocam := '0' + Tipocam;
*/
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

                    calculoImpuestosBaseIVA("Sales Cr.Memo Header"."No.");
                    /*
                                        Impuestos.SETRANGE(Impuestos."GMLocTax Type Loc", Impuestos."GMLocTax Type Loc"::IVA);
                                        IF Impuestos.FIND('-') THEN
                                            REPEAT
                                                Detalleimpuesto.RESET;
                                                Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Jurisdiction Code", Impuestos."Tax Jurisdiction Code");
                                                Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Group Code", Impuestos."Tax Group Code");
                                                IF (Detalleimpuesto.FINDFIRST) THEN BEGIN
                                                    IF Detalleimpuesto."Tax Below Maximum" = 10.5 THEN BEGIN
                                                        I105 := 1;
                                                        ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI105 := ImporteBaseI105 + Impuestos.Base;
                                                    END;
                                                    IF Detalleimpuesto."Tax Below Maximum" = 21 THEN BEGIN
                                                        I21 := 1;
                                                        ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI21 := ImporteBaseI21 + Impuestos.Base;
                                                    END;
                                                    IF Detalleimpuesto."Tax Below Maximum" = 27 THEN BEGIN
                                                        I27 := 1;
                                                        ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI27 := ImporteBaseI27 + Impuestos.Base;
                                                    END;
                                                END;
                                            UNTIL Impuestos.NEXT = 0;
                                            */
                    Cantiva := I105 + I21 + I27;


                    IF (I105 <> 0) THEN BEGIN
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := ImporteBaseI105;
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

                    IF (I21 <> 0) THEN BEGIN
                        TempTotalesCITI.GMLocVAT21 := ImporteI21;
                        TempTotalesCITI.GMLocBase21 := ImporteBaseI21;
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
                        TempTotalesCITI.GMLociva27 := ImporteI27;
                        TempTotalesCITI.GMLOcBase27 := ImporteBaseI27;
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
                        CASE "Sales Cr.Memo Header"."Tax Area Code" OF
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
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := 0; // es importe total de la factura
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

                        if valor13 > 0 then
                            Codoper := 'N'
                        else
                            Codoper := 'E';  // 20) Código operación
                    END;

                    if (Codoper = ' ') then // AW 
                        Codoper := '0';


                    //---------------- COMPROBANTE ---------------
                    IF Cantiva = 0 THEN Cantiva := 1;  // Se debe indicar 1 aun cuando la operaci¢n sea Exenta

                    OtrosTributos := '000000000000000';
                    IF (GMLocCAI2 = '') THEN
                        GMLocCAI2 := '00000000000000';
                    IF ("GMLocCAI Due Date2" = 0D) THEN
                        FechaVtoCAIT := '00000000'
                    ELSE
                        FechaVtoCAIT := FORMAT("GMLocCAI Due Date2", 8, '<Year4><Month,2><Day,2>');

                    TempTotalesCITI.INSERT;
                    CLEAR(postingDocDate);
                    IF (seePostDate) THEN
                        postingDocDate := "Sales Cr.Memo Header"."Posting Date"
                    else
                        postingDocDate := "Sales Cr.Memo Header"."Document Date";
                    CLEAR(TextoCbte);
                    TextoCbte := (
                    FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT("Bill-to Name") +
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


            }
            dataitem("Service Cr.Memo Header"; "Service Cr.Memo Header")
            {
                DataItemTableView = SORTING("Posting Date");


                DataItemLink = "Posting Date" = FIELD("Period Start");

                trigger OnAfterGetRecord()
                var
                    "AFIP - Tipo Comprobante": Record "GMLocAFIP - Voucher Type";
                    "Actividad empresa": Record "GMLocCompany Activity";
                    "Tipo fiscal": Record "GMLocFiscal Type";
                    Currency: Record 4;
                    FechaVtoCAIT: Text[8];
                    LclTaxGroup: Record 321;

                    recCompActivity: Record "GMLocCompany Activity";
                    recAuxTipoFiscal: Record "GMLocFiscal Type";
                begin
                    recCompActivity.Reset();
                    recCompActivity.SetRange(recCompActivity."GMLocActivity Code", "Service Cr.Memo Header"."GMLocPoint of Sales");
                    if recCompActivity.FindFirst() then begin
                        if recCompActivity.GMLocInternalPOS then
                            CurrReport.Skip();
                    end;


                    recAuxTipoFiscal.Reset();
                    recAuxTipoFiscal.SetRange(recAuxTipoFiscal.GMLocCode, "Service Cr.Memo Header"."GMLocFiscal Type");
                    if recAuxTipoFiscal.FindFirst() then
                        if not recAuxTipoFiscal."GMLocSummary in CITI" then
                            CurrReport.Skip();

                    CLEAR(Tipocambio);
                    CLEAR(Tiporesp);
                    NumeroLineas += 1;
                    CantidadRegistros += 1;
                    SLineasCredito.RESET;
                    SLineasCredito.SETRANGE(SLineasCredito."Document No.", "Service Cr.Memo Header"."No.");

                    Taxarea.RESET;
                    Taxarea.SETRANGE(Taxarea.Code, "Service Cr.Memo Header"."Tax Area Code");
                    Cliente.RESET;
                    Cliente.SETRANGE(Cliente."No.", "Service Cr.Memo Header"."Bill-to Customer No.");

                    CLEAR(Tipo_de_Comprobante);

                    IF ("AFIP - Tipo Comprobante".GET("Service Cr.Memo Header"."GMLocAFIP Voucher Type")) THEN BEGIN
                        IF ("AFIP - Tipo Comprobante"."GMLocCod 3685" = '') THEN
                            ERROR(Text005)
                        ELSE
                            Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMLocCod 3685"
                    END
                    ELSE
                        Tipo_de_Comprobante := '003';
                    // Fin Tipo de comprobante

                    // 22) Fecha de Vencimiento Pago
                    FechaVencimiento := '00000000';
                    // Fin Fecha de Vencimiento Pago

                    // 3) Punto de venta
                    CLEAR(Punto_de_Venta);

                    IF ("Actividad empresa".GET("Service Cr.Memo Header"."GMLocPoint of Sales")) THEN BEGIN
                        IF ("Actividad empresa"."GMLocCod 3685" = '') THEN
                            ERROR(Text006)
                        ELSE
                            Punto_de_Venta := "Actividad empresa"."GMLocCod 3685"
                    END
                    ELSE
                        Punto_de_Venta := '00001';

                    CLEAR(Numero_de_Comprobante);
                    IF ("Service Cr.Memo Header"."GMLocAFIP Voucher No." <> 0) THEN BEGIN
                        WHILE STRLEN(Numero_de_Comprobante + FORMAT("Service Cr.Memo Header"."GMLocAFIP Voucher No.")) < 8 DO
                            Numero_de_Comprobante := Numero_de_Comprobante + '0';

                        Numero_de_Comprobante := Numero_de_Comprobante + FORMAT("Service Cr.Memo Header"."GMLocAFIP Voucher No.");


                    END
                    ELSE BEGIN
                        IF (STRLEN("Service Cr.Memo Header"."No.") > 8) THEN
                            Numero_de_Comprobante := COPYSTR("Service Cr.Memo Header"."No.",
                                                                            STRLEN("Service Cr.Memo Header"."No.") - 7, 8)
                        ELSE BEGIN
                            WHILE STRLEN(Numero_de_Comprobante + "Service Cr.Memo Header"."No.") < 8 DO
                                Numero_de_Comprobante := Numero_de_Comprobante + '0';
                            Numero_de_Comprobante := Numero_de_Comprobante + "Service Cr.Memo Header"."No.";
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
                            //           {
                            //           CUIT := COPYSTR(Cliente."CUIT Argentina", 1, 2);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 4, 8);
                            // CUIT := CUIT + COPYSTR(Cliente."CUIT Argentina", 13, 1);
                            //           }
                            CUIT := Cliente."VAT Registration No.";
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;

                        END
                        ELSE
                            WHILE STRLEN(CUIT) < 20 DO
                                CUIT := '0' + CUIT;

                        IF (Cliente."GMLocAFIP Document Type" <> '') THEN
                            Codigo_de_Documento := Cliente."GMLocAFIP Document Type"
                        ELSE
                            Codigo_de_Documento := '80';
                    END;


                    TempTotalesCITI.INIT;
                    //12896-
                    ID_Totals += 1;
                    TempTotalesCITI.GMLocID := FORMAT(ID_Totals);
                    //12896+
                    TempTotalesCITI.GMLocLineNo := NumeroLineas;
                    TempTotalesCITI."GMLocVoucher No" := "Service Cr.Memo Header"."No.";
                    TempTotalesCITI.GMLocDescription := 'N/C';

                    // Campo IMPORTE TOTAL CON IMPUESTOS en Divisa de la Factura con dos decimales Redondeados
                    // en 15 caracteres sin puntos ni comas
                    IF "Service Cr.Memo Header"."Currency Factor" <> 0 THEN
                        Tipocambio := ROUND(1 / "Service Cr.Memo Header"."Currency Factor", 0.000001)
                    ELSE
                        Tipocambio := 1;

                    "Service Cr.Memo Header".CALCFIELDS(Amount, "Amount Including VAT");
                    Valor12 := "Service Cr.Memo Header"."Amount Including VAT";// * Tipocambio;

                    WHILE STRLEN("Bill-to Name") < 30 DO
                        "Bill-to Name" := "Bill-to Name" + ' ';

                    IF (STRLEN("Bill-to Name") > 30) THEN
                        "Bill-to Name" := COPYSTR("Bill-to Name", 1, 30);

                    IF (Valor12 < 1000) THEN BEGIN
                        IF ("Tipo fiscal".GET("Service Cr.Memo Header"."GMLocFiscal Type")) THEN BEGIN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                            IF ("Tipo fiscal"."GMLocCod 3685" = '5') THEN
                                "Service Cr.Memo Header"."Bill-to Name" := 'CONSUMIDOR FINAL              ';
                        END;
                    END
                    ELSE BEGIN
                        IF ("Tipo fiscal".GET("Service Cr.Memo Header"."GMLocFiscal Type")) THEN
                            IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                                ERROR(Text008);
                    END;

                    // IMPORTES BASE sin impuestos
                    Valor13 := 0; // Conceptos NO Gravados - No generan IVA
                    Valor17 := 0; // Siendo Gravado la Operacion esta Excenta  

                    IF SLineasCredito.FIND('-') THEN
                        REPEAT
                            IF (RecProvincia.GET("Service Cr.Memo Header".GMLocProvince)) THEN BEGIN
                                IF (RecProvincia."GMLocCod 3685" = '') THEN
                                    ERROR(Text009);
                                IF (RecProvincia."GMLocCod 3685" = '23') THEN BEGIN
                                    Valor17 += SLineasCredito.Amount;// * Tipocambio;
                                END
                                ELSE BEGIN
                                    IF ("Tipo fiscal"."GMLocCod 3685" = '08') OR ("Tipo fiscal"."GMLocCod 3685" = '09') THEN BEGIN
                                        Valor13 += SLineasCredito.Amount;// * Tipocambio
                                    END
                                    ELSE BEGIN
                                        /*IF (SLineasCredito."Tax Liable") THEN BEGIN
                                            IF (LclTaxGroup.GET(SLineasCredito."Tax Group Code")) THEN;
                                            IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                Valor13 += SLineasCredito.Amount * Tipocambio
                                            ELSE
                                                IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                    Valor17 += SLineasCredito.Amount * Tipocambio;
                                        END
                                        ELSE BEGIN
                                            Valor17 += SLineasCredito.Amount * Tipocambio;
                                        END;*/
                                        CLEAR(VATBUSPOSTINGGROUP);
                                        IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                                Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                                            if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                                IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                                IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                    Valor13 += Lineas.Amount// * Tipocambio
                                                ELSE
                                                    IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
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
                                /*IF (SLineasCredito."Tax Liable") THEN BEGIN
                                    IF (LclTaxGroup.GET(SLineasCredito."Tax Group Code")) THEN;
                                    IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado" THEN
                                        Valor13 += SLineasCredito.Amount * Tipocambio
                                    ELSE
                                        IF LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento THEN
                                            Valor17 += SLineasCredito.Amount * Tipocambio;
                                END
                                ELSE BEGIN
                                    Valor17 += SLineasCredito.Amount * Tipocambio;
                                END;*/
                                CLEAR(VATBUSPOSTINGGROUP);
                                IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += Lineas."VAT Base Amount";// * Tipocambio;



                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                        IF (LclTaxGroup.GET(Lineas."Tax Group Code")) THEN;

                                        IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                            Valor13 += Lineas.Amount// * Tipocambio
                                        ELSE
                                            IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                Valor17 += Lineas.Amount;//* Tipocambio;
                                    end;

                                end
                                else begin
                                    if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += Lineas."VAT Base Amount";//* Tipocambio;
                                end;
                            END;
                        UNTIL SLineasCredito.NEXT = 0;

                    // IMPUESTOS

                    Valor15 := 0;  // IVA
                    Valor16 := 0;  // Percepciones a No Categorizados o RNI
                    Valor18 := 0;  // Percepciones Nacionales
                    Valor19 := 0;  // Ingresos Brutos
                    Valor20 := 0;  // Impuestos Municipales por ahora no hay configurados
                    Valor21 := 0;  // Impuestos Internos por ahora no hay configurados

                    CLEAR(GlobalDocumentType);
                    GlobalDocumentType := GlobalDocumentType::"Credit Memo";
                    calculoImpuestosInvoice("Service Cr.Memo Header"."No.");
                    /*
				    Impuestos.RESET;
                    Impuestos.SETRANGE(Impuestos."Document No.", "Service Cr.Memo Header"."No.");

                    Impuestos.SetRange(Impuestos."GMLocDocument Type Loc.", "Sales Cr.Memo Header"."GMLocDocument Type Loc.");
                    IF Impuestos.FIND('-') THEN
                        REPEAT
                            IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::IVA) THEN
                                Valor15 += (Impuestos.Amount / Tipocambio)
                            ELSE BEGIN
                                IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"Ingresos Brutos") THEN
                                    Valor19 += (Impuestos.Amount / Tipocambio)
                                ELSE BEGIN
                                    IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::"IVA Percepcion") THEN
                                        Valor18 += (Impuestos.Amount / Tipocambio)
                                    ELSE BEGIN
                                        IF (Impuestos."GMLocTax Type Loc" = Impuestos."GMLocTax Type Loc"::Otros) THEN
                                            Valor21 += (Impuestos.Amount / Tipocambio)
                                    END;
                                END;
                            END;
                        UNTIL Impuestos.NEXT = 0;
					 */
                    //Campo 9 Importe total de la operaci¢n
                    CLEAR(Entero);
                    Campo12 := Formatvalor(Valor12, 15);
                    EVALUATE(Entero, Campo12);
                    Total2_8 += Entero;
                    // FIN campo 9

                    TempTotalesCITI."GMLocOperation total amount" := -Valor12;

                    //Campo 10 Importe total de conceptos que no integran el precio neto gravado
                    CLEAR(Entero);
                    Campo13 := Formatvalor(Valor13, 15);
                    EVALUATE(Entero, Campo13);
                    Total2_9 += Entero;
                    TempTotalesCITI."GMLocImporte no Gravado" := -Valor13;
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
                    Total2_12 -= Entero;
                    TempTotalesCITI."GMLocNon categorized perceptio" := Valor16;
                    //Fin campo1

                    //Campo 12 Importe de operaciones exentas
                    CLEAR(Entero);
                    Campo17 := Formatvalor(Valor17, 15);
                    EVALUATE(Entero, Campo17);
                    Total2_13 -= Entero;
                    TempTotalesCITI."GMLocNon taxable Amount" := -Valor17;
                    //Fin Campo 12

                    // campo 13   Importe de percepciones o pagos a cuenta de impuestos Nacionales
                    CLEAR(Entero);
                    Campo18 := Formatvalor(Valor18, 15);
                    EVALUATE(Entero, Campo18);
                    Total2_14 -= Entero;
                    TempTotalesCITI."GMLocNational Perceptions Amou" := Valor18;
                    //Fin campo 13  

                    //  campo 14 ingresos brutos
                    CLEAR(Entero);
                    Campo19 := Formatvalor(Valor19, 15);
                    EVALUATE(Entero, Campo19);
                    Total2_15 -= Entero;
                    TempTotalesCITI."GMLocGIT Amount" := Valor19;
                    //Fin campo 14

                    //campo campo 15 Importe de percepciones impuestos Municipales
                    Campo20 := Formatvalor(Valor20, 15);
                    EVALUATE(Entero, Campo20);
                    Total2_16 += Entero;
                    TempTotalesCITI."GMLocCity Perceptions Amount" := Valor20;
                    //Fin campo 15

                    // campo 16 Importe impuestos internos
                    CLEAR(Entero);
                    Campo21 := Formatvalor(Valor21, 15);
                    EVALUATE(Entero, Campo21);
                    Total2_17 += Entero;
                    TempTotalesCITI."GMLocInternal Tax Amount" := Valor21;
                    //Fin Campo 16  

                    IF (Taxarea.GET("Service Cr.Memo Header"."Tax Area Code")) THEN;

                    IF ("Tipo fiscal".GET("Service Cr.Memo Header"."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR(Text008)
                        ELSE
                            Tiporesp := "Tipo fiscal"."GMLocCod 3685";
                    END;

                    IF (Currency.GET("Service Cr.Memo Header"."Currency Code")) THEN BEGIN
                        IF (Currency."GMLocAFIP Code" = '') THEN
                            ERROR(Text007)
                        ELSE
                            Moneda := Currency."GMLocAFIP Code";
                    END
                    ELSE
                        Moneda := 'PES';
                    // {
                    // IF "Sales Cr.Memo Header"."Currency Factor" <>0
                    //     THEN Tipocambio:=ROUND(1/"Sales Cr.Memo Header"."Currency Factor",0.000001)
                    //     ELSE Tipocambio:=1;
                    //     }
                    /*Tipocambio := Tipocambio * 1000000;
                    Tipocam := FORMAT(Tipocambio, 0, '<Standard Format,1>');
                    WHILE STRLEN(Tipocam) < 10 DO Tipocam := '0' + Tipocam;
*/
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

                    calculoImpuestosBaseIVA("Service Cr.Memo Header"."No.");
                    /*
                                        Impuestos.SETRANGE(Impuestos."GMLocTax Type Loc", Impuestos."GMLocTax Type Loc"::IVA);
                                        IF Impuestos.FIND('-') THEN
                                            REPEAT
                                                Detalleimpuesto.RESET;
                                                Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Jurisdiction Code", Impuestos."Tax Jurisdiction Code");
                                                Detalleimpuesto.SETRANGE(Detalleimpuesto."Tax Group Code", Impuestos."Tax Group Code");
                                                IF (Detalleimpuesto.FINDFIRST) THEN BEGIN
                                                    IF Detalleimpuesto."Tax Below Maximum" = 10.5 THEN BEGIN
                                                        I105 := 1;
                                                        ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI105 := ImporteBaseI105 + Impuestos.Base;
                                                    END;
                                                    IF Detalleimpuesto."Tax Below Maximum" = 21 THEN BEGIN
                                                        I21 := 1;
                                                        ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI21 := ImporteBaseI21 + Impuestos.Base;
                                                    END;
                                                    IF Detalleimpuesto."Tax Below Maximum" = 27 THEN BEGIN
                                                        I27 := 1;
                                                        ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                                        ImporteBaseI27 := ImporteBaseI27 + Impuestos.Base;
                                                    END;
                                                END;
                                            UNTIL Impuestos.NEXT = 0;
                                            */
                    Cantiva := I105 + I21 + I27;


                    IF (I105 <> 0) THEN BEGIN
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := ImporteBaseI105;
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

                    IF (I21 <> 0) THEN BEGIN
                        TempTotalesCITI.GMLocVAT21 := ImporteI21;
                        TempTotalesCITI.GMLocBase21 := ImporteBaseI21;
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
                        TempTotalesCITI.GMLociva27 := ImporteI27;
                        TempTotalesCITI.GMLOcBase27 := ImporteBaseI27;
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
                        CASE "Service Cr.Memo Header"."Tax Area Code" OF
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
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := 0; // es importe total de la factura
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

                        if valor13 > 0 then
                            Codoper := 'N'
                        else
                            Codoper := 'E';  // 20) Código operación
                    END;

                    if (Codoper = ' ') then // AW 
                        Codoper := '0';


                    //---------------- COMPROBANTE ---------------
                    IF Cantiva = 0 THEN Cantiva := 1;  // Se debe indicar 1 aun cuando la operaci¢n sea Exenta

                    OtrosTributos := '000000000000000';
                    IF (GMLocCAI2 = '') THEN
                        GMLocCAI2 := '00000000000000';
                    IF ("GMLocCAI Due Date2" = 0D) THEN
                        FechaVtoCAIT := '00000000'
                    ELSE
                        FechaVtoCAIT := FORMAT("GMLocCAI Due Date2", 8, '<Year4><Month,2><Day,2>');

                    TempTotalesCITI.INSERT;
                    CLEAR(postingDocDate);
                    IF (seePostDate) THEN
                        postingDocDate := "Service Cr.Memo Header"."Posting Date"
                    else
                        postingDocDate := "Service Cr.Memo Header"."Document Date";
                    CLEAR(TextoCbte);
                    TextoCbte := (
                    FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                    FORMAT(Tipo_de_Comprobante) +
                    FORMAT(Punto_de_Venta) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Numero_de_Comprobante) +
                    FORMAT(Codigo_de_Documento) +
                    FORMAT(CUIT) +
                    FORMAT("Bill-to Name") +
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


            }



            trigger OnPreDataItem()
            begin
                Date.SETRANGE(Date."Period Type", Date."Period Type"::Date);
                Date.SETFILTER(Date."Period Start", '%1..%2', FechaDesde, FechaHasta);
                IF (Date.FINDFIRST) THEN
                    TempTotalesCITI.DELETEALL;
                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "Service Cr.Memo Header".SetFilter("Shortcut dimension 1 code", BssiDimension)
                    else
                        "Service Cr.Memo Header".SetFilter("Shortcut dimension 2 code", BssiDimension);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("GMLocOptions")
                {
                    caption = 'Options',;
                    field(FechaDesde; FechaDesde)
                    {
                        Caption = 'From date',;
                        ApplicationArea = All;
                    }

                    field(FechaHasta; FechaHasta)
                    {
                        Caption = 'To date',;
                        ApplicationArea = All;
                    }
                    field(seePostDate; seePostDate)
                    {
                        Caption = 'Generar con Fecha Registro';
                        ApplicationArea = All;
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
        TempExcelBuff.DELETEALL;
        TempExcelBuffAlic.DeleteAll();
        TempExcelBuffCbte.DeleteAll();

    end;

    trigger OnInitReport()
    begin
        seePostDate := false;
    end;

    trigger OnPostReport()
    var
        d: Text[30];
        t: Text[30];
        Archivo: Text[1024];
        ExportaTxt: Codeunit "GMLocExporta TXT";
        pFileName: Text;
    begin
        if NumeroLineas = 0 then
            MESSAGE(Text004)
        else begin

            if Confirm('Desea generar el .txt de comprobantes?') then begin
                Clear(pFileName);
                pFileName := 'Ventas_Comprobantes';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffCbte);
            end;
        end;

        if NumeroLineasAlic = 0 then
            MESSAGE(Text004)
        else begin

            if Confirm('Desea generar el .txt de alícuotas?') then begin
                Clear(pFileName);
                pFileName := 'Ventas_Alicuotas';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffAlic);
            end;
        end;


    end;

    var
        postingDocDate: Date;
        seePostDate: Boolean;
        xmlport1: XmlPort "GMLocXML ImportExport";
        xmlport2: XmlPort "GMLocXML ImportExport";
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
        Lineas: Record "Sales Invoice Line";
        SLineas: Record "Service Invoice Line";
        LineasCredito: Record "Sales Cr.Memo Line";
        SLineasCredito: Record "Service Cr.Memo Line";
        Empresa: Record "Company Information";
        Impuestos: Record "VAT Entry";
        Taxarea: Record "Tax Area";
        Detalleimpuesto: Record "Tax Detail";
        Cliente: Record Customer;
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
        Tipocam: Text[10];
        Cantiva: Decimal;
        FechaVencimiento: Text[8];
        I105: Decimal;
        I21: Decimal;
        I27: Decimal;
        ImporteI105: Decimal;
        ImporteI21: Decimal;
        ImporteI27: Decimal;
        TextImporteI105: Text[15];
        TextImporteI21: Text[15];
        TextImporteI27: Text[15];
        ImporteBaseI105: Decimal;
        ImporteBaseI21: Decimal;
        ImporteBaseI27: Decimal;
        TextImporteBaseI105: Text[15];
        TextImporteBaseI21: Text[15];
        TextImporteBaseI27: Text[15];
        Codoper: Text[30];
        CantidadRegistros: Integer;
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
        "-- -Export to CSV ----------": Integer;
        OutFile: File;
        Texto: Text[1024];
        FileName: Text[250];
        FileNameCbte: Text[250];
        FileNameAlic: Text[250];
        OutFileCbte: File;
        TextoCbte: Text[1024];
        OutFileAlic: File;
        TextoAlic: Text[1024];
        NumeroLineas: Integer;
        EscribirFichero: Boolean;
        ExportaTxt: Codeunit "GMLocExporta TXT";
        TempExcelBuff: Record 370 temporary;
        TempExcelBuffCbte: Record 370 temporary;
        TempExcelBuffAlic: Record 370 temporary;
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
        "//Totales": Integer;
        ExistTotal: Boolean;
        TextoBisTOTAL: BigText;
        FileNameTotal: Text[250];
        TextoTOTAL: Text[1024];
        OutFileTOTAL: File;
        NumLinTotal: Integer;
        "//Fin totales": Integer;
        TempTotalesCITI: Record "GMLocAFIP - Concept Type" temporary;
        RecProvincia: Record GMLocProvince;
        NumeroLineasAlic: Integer;
        ID_Totals: Integer;
        TipocambioOriginal: Decimal;
        VATBUSPOSTINGGROUP: Record "VAT Business Posting Group";
        recTaxJurisdiction: Record "Tax Jurisdiction";

        GRUPOREGIVAPROD: Record "VAT Product Posting Group";
        GlobalDocumentType: Enum "Gen. Journal Document Type";
        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        I5: Decimal;
        ImporteI5: Decimal;
        ImporteBaseI5: Decimal;
        TextImporteI5: Text[15];
        TextImporteBaseI5: Text[15];

    PROCEDURE "#RellenaExcelBuffCbte"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuffCbte.INIT;
        TempExcelBuffCbte."Row No." := NumeroLineas;
        TempExcelBuffCbte."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuffCbte.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuffCbte.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuffCbte.INSERT;
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

    procedure calculoImpuestosInvoice(DocNo: code[20])
    var

    begin

        // Calculo los impuestos
        Impuestos.Reset;
        Impuestos.SetCurrentkey("Document No.", "Posting Date");
        Impuestos.Setrange(Impuestos."Document Type", GlobalDocumentType);
        Impuestos.SetRange(Impuestos."Document No.", DocNo);
        Impuestos.setrange(type, impuestos.type::Sale);
        if Impuestos.FindSet then
            repeat
                IF (Impuestos."Tax Jurisdiction Code" <> '') THEN begin
                    case Impuestos."GMLocTax Type Loc" of
                        0:
                            begin
                                Clear(recTaxJurisdiction);
                                recTaxJurisdiction.Reset;
                                recTaxJurisdiction.SetRange(Code, Impuestos."Tax Jurisdiction Code");
                                if recTaxJurisdiction.FindFirst then
                                    case recTaxJurisdiction.GMLocTipo of
                                        recTaxJurisdiction.GMLocTipo::IVA21:
                                            Valor15 += (Impuestos.Amount / Tipocambio);

                                        recTaxJurisdiction.GMLocTipo::"IVA2.5":
                                            Valor15 += (Impuestos.Amount / Tipocambio);

                                        recTaxJurisdiction.GMLocTipo::"IVA5":
                                            Valor15 += (Impuestos.Amount / Tipocambio);

                                        recTaxJurisdiction.GMLocTipo::"IVA10.5":
                                            Valor15 += (Impuestos.Amount / Tipocambio);

                                        recTaxJurisdiction.GMLocTipo::IVA27:
                                            Valor15 += (Impuestos.Amount / Tipocambio);


                                        recTaxJurisdiction.GMLocTipo::" ":
                                            begin
                                                GRUPOREGIVAPROD.Reset;
                                                GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                                                if GRUPOREGIVAPROD.FindFirst then begin
                                                    case GRUPOREGIVAPROD."GMLocTax Type" of
                                                        0:
                                                            begin
                                                                if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '5') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);

                                                                if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '9') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);

                                                                if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '4') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);

                                                                if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '6') then
                                                                    Valor15 += (Impuestos.Amount / Tipocambio);

                                                                if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '8') then
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
                        case GRUPOREGIVAPROD."GMLocTax Type" of
                            0:
                                begin
                                    if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '5') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);

                                    if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '9') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);

                                    if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '4') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);

                                    if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '6') then
                                        Valor15 += (Impuestos.Amount / Tipocambio);

                                    if (GRUPOREGIVAPROD."GMLocAFIP VAT Type Code" = '8') then
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
    begin

        // Calculo los impuestos
        Impuestos.Reset;
        Impuestos.SetCurrentkey("Document No.", "Posting Date");
        Impuestos.SetRange(Impuestos."Document Type", GlobalDocumentType);
        Impuestos.SETRANGE(Impuestos."GMLocTax Type Loc", Impuestos."GMLocTax Type Loc"::IVA);
        Impuestos.SetRange(Impuestos."Document No.", DocNo);
        Impuestos.setrange(type, impuestos.type::Sale);
        if Impuestos.FindSet then
            repeat
                IF Impuestos."VAT Calculation Type" <> Impuestos."VAT Calculation Type"::"Full VAT" THEN BEGIN
                    Clear(recTaxJurisdiction);
                    recTaxJurisdiction.Reset;
                    recTaxJurisdiction.SetRange(Code, Impuestos."Tax Jurisdiction Code");
                    if recTaxJurisdiction.FindFirst then begin
                        case recTaxJurisdiction.GMLocTipo of
                            //no va para ventas
                            /*
                                                                    recTaxJurisdiction.GMLocTipo::"IVA2.5":
                                                                        begin
                                                                            I205 := 1;
                                                                            ImporteI205 += (Impuestos.Amount / Tipocambio);
                                                                            ImporteBaseI205 += (Impuestos.Base / Tipocambio);
                                                                        end;
                            */
                            recTaxJurisdiction.GMLocTipo::"IVA10.5":
                                begin
                                    I105 := 1;
                                    ImporteI105 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI105 += (Impuestos.Base / Tipocambio);
                                end;

                            recTaxJurisdiction.GMLocTipo::"IVA21":
                                begin
                                    I21 := 1;
                                    ImporteI21 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI21 += (Impuestos.Base / Tipocambio);
                                end;
                            recTaxJurisdiction.GMLocTipo::"IVA27":
                                begin
                                    I27 := 1;
                                    ImporteI27 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI27 += (Impuestos.Base / Tipocambio);
                                end;
                            recTaxJurisdiction.GMLocTipo::"IVA5":
                                begin
                                    I5 := 1;
                                    ImporteI5 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI5 += (Impuestos.Base / Tipocambio);
                                end;
                            recTaxJurisdiction.GMLocTipo::" ":
                                begin
                                    GRUPOREGIVAPROD.Reset;
                                    GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                                    if GRUPOREGIVAPROD.FindFirst then begin
                                        case GRUPOREGIVAPROD."GMLocTax Type" of
                                            0:
                                                begin
                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 21) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I21 := 1;
                                                            ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                ImporteBaseI21 := ImporteBaseI21 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                        END;

                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 10.5) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I105 := 1;
                                                            ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                ImporteBaseI105 := ImporteBaseI105 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                        END;
                                                    //no va para ventas
                                                    /*
                                                                                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 2.5) then
                                                                                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                                                                                            I205 := 1;
                                                                                                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                                                                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                                                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                                                                                        END;
                                                    */
                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 27) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I27 := 1;
                                                            ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                ImporteBaseI27 := ImporteBaseI27 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                        END;
                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 5) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I5 := 1;
                                                            ImporteI5 := ImporteI5 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                ImporteBaseI5 := ImporteBaseI5 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
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
                        case GRUPOREGIVAPROD."GMLocTax Type" of
                            0:
                                begin
                                    if (GRUPOREGIVAPROD.GMLocPorIva = 21) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I21 := 1;
                                            ImporteI21 := ImporteI21 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                ImporteBaseI21 := ImporteBaseI21 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                        END;

                                    if (GRUPOREGIVAPROD.GMLocPorIva = 10.5) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I105 := 1;
                                            ImporteI105 := ImporteI105 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                ImporteBaseI105 := ImporteBaseI105 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                        END;
                                    //no va para ventas
                                    /*
                                                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 2.5) then
                                                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                                                            I205 := 1;
                                                                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                                                        END;
                                    */
                                    if (GRUPOREGIVAPROD.GMLocPorIva = 27) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I27 := 1;
                                            ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                ImporteBaseI27 := ImporteBaseI27 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                        END;
                                    if (GRUPOREGIVAPROD.GMLocPorIva = 5) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I5 := 1;
                                            ImporteI5 := ImporteI5 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                ImporteBaseI5 := ImporteBaseI5 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                        end;
                                end;

                        end;
                    end;
                end;
            UNTIL Impuestos.NEXT = 0;
    end;


}
