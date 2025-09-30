report 80885 "PER R.G. 3685 CITI Compras"
{
    Caption = 'R.G. 3685 CITI Compras';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Date; Date)
        {
            DataItemTableView = SORTING("Period Type", "Period Start");

            dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
            {
                DataItemTableView = SORTING("Posting Date", "No.");

                DataItemLink = "Posting Date" = FIELD("Period Start");

                trigger OnPreDataItem()
                begin
                    if (BssiDimension <> '') then
                        if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                            "Purch. Inv. Header".SetFilter("Shortcut dimension 1 code", BssiDimension)
                        else
                            "Purch. Inv. Header".SetFilter("Shortcut dimension 2 code", BssiDimension);
                    //SETRANGE("Posting Date",Date."Period Start");
                    if FiltrarPorDocumentDate then begin
                        "Purch. Inv. Header".SetRange("Document Date", FechaDesde, FechaHasta);
                    end else begin
                        "Purch. Inv. Header".SetRange("Posting Date", FechaDesde, FechaHasta);
                    end;
                end;

                trigger OnAfterGetRecord()
                var
                    "AFIP - Tipo Comprobante": Record "GMLocAFIP - Voucher Type";
                    "Actividad empresa": Record "GMLocCompany Activity";
                    "Tipo fiscal": Record "GMLocFiscal Type";
                    Currency: Record 4;
                    FechaVtoCAIT: Text[8];
                    LclTaxGroup: Record 321;
                    recAuxTipoFiscal: Record "GMLocFiscal Type";
                begin
                    CLEAR(Tipocambio);
                    CLEAR(Tiporesp);

                    "Purch. Inv. Header".CALCFIELDS(Amount, "Amount Including VAT");
                    IF ("Purch. Inv. Header"."Amount Including VAT" = 0) THEN
                        CurrReport.SKIP;

                    if ("Purch. Inv. Header"."GMLocFiscal Type" = '90-NO LIBRO IVA') then
                        CurrReport.skip();

                    recAuxTipoFiscal.Reset();
                    recAuxTipoFiscal.SetRange(recAuxTipoFiscal.GMLocCode, "Purch. Inv. Header"."GMLocFiscal Type");
                    if recAuxTipoFiscal.FindFirst() and not (recAuxTipoFiscal."GMLocSummary in CITI") then
                        CurrReport.Skip();


                    EscribirFichero := TRUE;
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
                    Lineas.SETRANGE(Lineas."Document No.", "Purch. Inv. Header"."No.");

                    Taxarea.RESET;
                    Taxarea.SETRANGE(Taxarea.Code, "Purch. Inv. Header"."Tax Area Code");
                    Vendor.RESET;
                    Vendor.SETRANGE(Vendor."No.", "Purch. Inv. Header"."Buy-from Vendor No.");

                    CLEAR(Tipo_de_Comprobante);
                    if "GMLocAFIP Invoice Voucher Type" <> '' THEN BEGIN
                        IF ("AFIP - Tipo Comprobante".Get("GMLocAFIP Invoice Voucher Type")) THEN begin
                            "AFIP - Tipo Comprobante".testfield("GMLocCod 3685");
                            Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMLocCod 3685";
                        end;
                    END
                    ELSE BEGIN


                        IF (COPYSTR("No.", 1, 3) = 'PIP') THEN BEGIN
                            CASE COPYSTR("Vendor Invoice No.", 1, 1) OF
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
                            CASE COPYSTR("Vendor Invoice No.", 1, 1) OF
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
                    if "GMLocImport Dispatch" = '' then
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

                    IF "GMLocImport Dispatch" <> '' THEN
                        Numero_de_Comprobante := '0';


                    WHILE STRLEN(Numero_de_Comprobante) < 20 DO
                        Numero_de_Comprobante := '0' + Numero_de_Comprobante;

                    //12198-
                    //Despacho
                    CLEAR(DespachoImportacion);
                    IF "GMLocImport Dispatch" <> '' THEN BEGIN
                        DespachoImportacion := COPYSTR("GMLocImport Dispatch", 1, 16);

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
                    // IF(Vendor."Tipo Documento AFIP" <> '')THEN
                    //  Codigo_de_Documento:=Vendor."Tipo Documento AFIP"
                    // ELSE
                    Codigo_de_Documento := '80';
                    //END;
                    //Se genera la tabla decontrol
                    TempTotalesCITI.INIT;
                    //12896 (03)-
                    TempTotalesCITI.GMLocID := FORMAT(NumeroLineas);
                    //12896 (03)+
                    TempTotalesCITI.GMLocLineNo := NumeroLineas;
                    TempTotalesCITI."GMLocVoucher No" := "Purch. Inv. Header"."No.";
                    TempTotalesCITI."GMLocInvoice Vendor" := "Purch. Inv. Header"."Vendor Invoice No.";
                    TempTotalesCITI.GMLocDescription := 'FACTURA COMPRA';


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

                    IF ("Tipo fiscal".GET("Purch. Inv. Header"."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR(Text008);
                    END;

                    IF Lineas.FIND('-') THEN
                        REPEAT
                            IF (RecProvincia.GET("Purch. Inv. Header".GMLocProvince)) THEN BEGIN
                                IF (RecProvincia."GMLocCod 3685" = '') THEN
                                    ERROR(Text009);
                                IF (RecProvincia."GMLocCod 3685" = '23') THEN BEGIN
                                    Valor17 += Lineas.Amount;//* Tipocambio;
                                END
                                ELSE BEGIN
                                    IF ("Tipo fiscal"."GMLocCod 3685" = '08') OR ("Tipo fiscal"."GMLocCod 3685" = '09') THEN BEGIN
                                        Valor13 += Lineas.Amount;//* Tipocambio
                                    END
                                    ELSE BEGIN
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
                                END;
                            END
                            ELSE BEGIN

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

                    //CalculoImpuesto Facturas
                    CLEAR(GlobalDocumentType);
                    GlobalDocumentType := GlobalDocumentType::Invoice;
                    calculoImpuestosInvoice("Purch. Inv. Header"."No.");

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
                    I205 := 0;
                    ImporteI205 := 0;
                    ImporteBaseI205 := 0;
                    TextImporteI205 := '';
                    TextImporteBaseI205 := '';
                    I5 := 0;
                    ImporteI5 := 0;
                    ImporteBaseI5 := 0;
                    TextImporteI5 := '';
                    TextImporteBaseI5 := '';

                    calculoImpuestosBaseIVA("Purch. Inv. Header"."No.");
                    if "GMLocImport Dispatch" <> '' then
                        Valor12 += ImporteBaseI105 + ImporteBaseI21 + ImporteBaseI27 + ImporteBaseI205 + ImporteBaseI5;

                    //Campo 9 Importe total de la operaci¢n
                    CLEAR(Entero);
                    Campo12 := Formatvalor(Valor12, 15);
                    EVALUATE(Entero, Campo12);
                    Total2_8 += Entero;
                    // FIN campo 9

                    TempTotalesCITI."GMLocOperation total amount" := Valor12;

                    //Campo 10 Importe total de conceptos que no integran el precio neto gravado
                    IF (Tipo_de_Comprobante = '007') OR (Tipo_de_Comprobante = '012') OR (Tipo_de_Comprobante = '006') OR (Tipo_de_Comprobante = '011') THEN
                        Valor13 := 0;
                    CLEAR(Entero);
                    Campo13 := FormatvalorNegativo(Valor13, 15);
                    EVALUATE(Entero, Campo13);
                    Total2_9 += Entero;
                    TempTotalesCITI."GMLocImporte no Gravado" := Valor13;
                    // FIN campo10   

                    //Total2_10+=Entero;
                    // {
                    // Campo14:=Formatvalor(Valor14,15);
                    // EVALUATE(Entero,Campo14);
                    // Total2_10+=Entero;
                    // }
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
                    IF (Tipo_de_Comprobante = '007') OR (Tipo_de_Comprobante = '012') OR (Tipo_de_Comprobante = '006') OR (Tipo_de_Comprobante = '011') THEN
                        Valor17 := 0;
                    CLEAR(Entero);
                    Campo17 := FormatvalorNegativo(Valor17, 15);
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


                    IF (Taxarea.GET("Purch. Inv. Header"."Tax Area Code")) THEN;

                    IF ("Tipo fiscal".GET("Purch. Inv. Header"."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR(Text008)
                        ELSE
                            Tiporesp := "Tipo fiscal"."GMLocCod 3685";
                    END;

                    IF (Currency.GET("Purch. Inv. Header"."Currency Code")) THEN BEGIN
                        IF (Currency."GMLocAFIP Code" = '') THEN
                            ERROR(Text007)
                        ELSE
                            Moneda := Currency."GMLocAFIP Code";
                    END
                    ELSE
                        Moneda := 'PES';
                    //       {
                    //   IF "Purch. Inv. Header"."Currency Factor" <>0
                    //       THEN Tipocambio:=ROUND(1/"Purch. Inv. Header"."Currency Factor",0.000001)
                    //       ELSE Tipocambio:=1;
                    //       }
                    CLEAR(TipocambioOriginal);
                    TipocambioOriginal := Tipocambio;
                    TipocambioOriginal := TipocambioOriginal * 1000000;
                    Tipocam := FORMAT(TipocambioOriginal, 0, '<Standard Format,1>');
                    WHILE STRLEN(Tipocam) < 10 DO Tipocam := '0' + Tipocam;

                    Cantiva := I105 + I21 + I27 + I205 + I5;

                    IF (I5 <> 0) THEN BEGIN
                        TempTotalesCITI.GMLocVAT5 := ImporteI5;
                        TempTotalesCITI.GMLocBase5 := ImporteBaseI5;
                        //IF(ImporteI105 <> 0)THEN
                        //  ImporteI105 := ABS(ImporteI105);
                        TextImporteI5 := FormatvalorNegativo(ImporteI5, 15);
                        EVALUATE(Entero, TextImporteI5);
                        // IF(ImporteBaseI105 <> 0)THEN
                        //  ImporteBaseI105 := ABS(ImporteBaseI105);

                        TextImporteBaseI5 := FormatvalorNegativo(ImporteBaseI5, 15);
                        EVALUATE(Entero, TextImporteBaseI5);

                        //12198-
                        IF "Purch. Inv. Header"."gmlocImport Dispatch" <> '' THEN begin
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

                    IF (I205 <> 0) THEN BEGIN
                        TempTotalesCITI.GMLocIva205 := ImporteI205;
                        TempTotalesCITI.GMLocBase205 := ImporteBaseI205;
                        //IF(ImporteI105 <> 0)THEN
                        //  ImporteI105 := ABS(ImporteI105);
                        TextImporteI205 := FormatvalorNegativo(ImporteI205, 15);
                        EVALUATE(Entero, TextImporteI205);
                        // IF(ImporteBaseI105 <> 0)THEN
                        //  ImporteBaseI105 := ABS(ImporteBaseI105);

                        TextImporteBaseI205 := FormatvalorNegativo(ImporteBaseI205, 15);
                        EVALUATE(Entero, TextImporteBaseI205);

                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
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

                    IF (I105 <> 0) THEN BEGIN
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := ImporteBaseI105;
                        //IF(ImporteI105 <> 0)THEN
                        //  ImporteI105 := ABS(ImporteI105);
                        TextImporteI105 := FormatvalorNegativo(ImporteI105, 15);
                        EVALUATE(Entero, TextImporteI105);
                        // IF(ImporteBaseI105 <> 0)THEN
                        //  ImporteBaseI105 := ABS(ImporteBaseI105);

                        TextImporteBaseI105 := FormatvalorNegativo(ImporteBaseI105, 15);
                        EVALUATE(Entero, TextImporteBaseI105);

                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
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
                        TempTotalesCITI.GMLocVAT21 := ImporteI21;
                        TempTotalesCITI.GMLocBase21 := ImporteBaseI21;
                        // IF(ImporteI21 <> 0)THEN
                        //  ImporteI21 := ABS(ImporteI21);
                        TextImporteI21 := FormatvalorNegativo(ImporteI21, 15);
                        EVALUATE(Entero, TextImporteI21);

                        // IF(ImporteBaseI21 <> 0)THEN
                        //  ImporteBaseI21 := ABS(ImporteBaseI21);
                        TextImporteBaseI21 := FormatvalorNegativo(ImporteBaseI21, 15);
                        EVALUATE(Entero, TextImporteBaseI21);

                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
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
                        TempTotalesCITI.GMLociva27 := ImporteI27;
                        TempTotalesCITI.GMLocBase27 := ImporteBaseI27;
                        //IF(ImporteI27 <> 0)THEN
                        //  ImporteI27 := ABS(ImporteI27);

                        TextImporteI27 := FormatvalorNegativo(ImporteI27, 15);
                        EVALUATE(Entero, TextImporteI27);
                        // IF(ImporteBaseI27 <> 0)THEN
                        //  ImporteBaseI27 := ABS(ImporteBaseI27);

                        TextImporteBaseI27 := FormatvalorNegativo(ImporteBaseI27, 15);
                        EVALUATE(Entero, TextImporteBaseI27);

                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
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
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := 0; // es importe total de la factura
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
                    TempTotalesCITI."GMLocOperation total amount" := Valor12;
                    CreditoFiscalComputabledec := ABS(ImporteI105 + ImporteI21 + ImporteI27 + ImporteI205);
                    CreditoFiscalComputable := Formatvalor(CreditoFiscalComputabledec, 15);
                    EVALUATE(Entero, CreditoFiscalComputable);
                    // suma campo12(9) campo 13(10) campo 16(11) campo 17(12)  campo 18(13) campo 19(14)
                    TempTotalesCITI.INSERT;

                    CLEAR(EsProveedorGenerico);
                    EsProveedorGenerico := argentina.genericVendor("Buy-from Vendor No.");
                    IF (EsProveedorGenerico) and ("Buy-from Vendor Name 2" <> '') THEN begin
                        "Buy-from Vendor Name" := "Buy-from Vendor Name 2";
                        WHILE STRLEN("Buy-from Vendor Name") < 30 DO
                            "Buy-from Vendor Name" := "Buy-from Vendor Name" + ' ';

                        IF (STRLEN("Buy-from Vendor Name") > 30) THEN
                            "Buy-from Vendor Name" := COPYSTR("Buy-from Vendor Name", 1, 30);
                    end;
                    CLEAR(TextoCbte);
                    CLEAR(postingDocDate);
                    IF (seePostDate) THEN
                        postingDocDate := "Posting Date"
                    else
                        postingDocDate := "Document Date";
                    IF "GMLocImport Dispatch" <> '' THEN begin
                        TextoCbte := (
                        FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                        FORMAT(Tipo_de_Comprobante) +
                        FORMAT(Punto_de_Venta) +
                        FORMAT(Numero_de_Comprobante) +
                        FORMAT(DespachoImportacion) +
                        FORMAT(Codigo_de_Documento) +
                        FORMAT(CUIT) +
                        FORMAT("Buy-from Vendor Name") +
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

                        "#RellenaExcelBuffCbteDesp"(TextoCbte);

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
                        FORMAT("Buy-from Vendor Name") +
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


                        "#RellenaExcelBuffCbte"(TextoCbte);
                    end;

                    //  ELSE
                    //  "#EscribeFicheroCbte";  
                end;

            }

            dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
            {
                DataItemTableView = SORTING("Posting Date", "No.");

                DataItemLink = "Posting Date" = FIELD("Period Start");

                trigger OnPreDataItem()
                begin
                    if (BssiDimension <> '') then
                        if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                            "Purch. Cr. Memo Hdr.".SetFilter("Shortcut Dimension 1 Code", BssiDimension)
                        else
                            "Purch. Cr. Memo Hdr.".SetFilter("Shortcut dimension 2 code", BssiDimension);
                    //SETRANGE("Posting Date",Date."Period Start");
                    if FiltrarPorDocumentDate then begin
                        "Purch. Cr. Memo Hdr.".SetRange("Document Date", FechaDesde, FechaHasta);
                    end else begin
                        "Purch. Cr. Memo Hdr.".SetRange("Posting Date", FechaDesde, FechaHasta);
                    end;
                end;


                trigger OnAfterGetRecord()
                var
                    "AFIP - Tipo Comprobante": Record "GMLocAFIP - Voucher Type";
                    "Actividad empresa": Record "GMLocCompany Activity";
                    "Tipo fiscal": Record "GMLocFiscal Type";
                    Currency: Record 4;
                    FechaVtoCAIT: Text[8];
                    LclTaxGroup: Record 321;
                    recAuxTipoFiscal: Record "GMLocFiscal Type";
                begin
                    CLEAR(Tipocambio);
                    CLEAR(Tiporesp);

                    CALCFIELDS(Amount, "Amount Including VAT");
                    IF ("Amount Including VAT" = 0) THEN
                        CurrReport.SKIP;

                    if ("Purch. Cr. Memo Hdr."."GMLocFiscal Type" = '90-NO LIBRO IVA') then
                        CurrReport.skip();

                    recAuxTipoFiscal.Reset();
                    recAuxTipoFiscal.SetRange(recAuxTipoFiscal.GMLocCode, "Purch. Cr. Memo Hdr."."GMLocFiscal Type");
                    if recAuxTipoFiscal.FindFirst() and not (recAuxTipoFiscal."GMLocSummary in CITI") then
                        CurrReport.Skip();


                    EscribirFichero := TRUE;

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


                    LineasCredito.RESET;
                    LineasCredito.SETRANGE(LineasCredito."Document No.", "Purch. Cr. Memo Hdr."."No.");

                    Taxarea.RESET;
                    Taxarea.SETRANGE(Taxarea.Code, "Purch. Cr. Memo Hdr."."Tax Area Code");
                    Vendor.RESET;
                    Vendor.SETRANGE(Vendor."No.", "Purch. Cr. Memo Hdr."."Buy-from Vendor No.");


                    CLEAR(Tipo_de_Comprobante);
                    if "GMLocAFIP Invoice Voucher Type" <> '' THEN BEGIN
                        IF ("AFIP - Tipo Comprobante".Get("GMLocAFIP Invoice Voucher Type")) THEN begin
                            "AFIP - Tipo Comprobante".testfield("GMLocCod 3685");
                            Tipo_de_Comprobante := "AFIP - Tipo Comprobante"."GMLocCod 3685";
                        end;
                    END
                    ELSE BEGIN

                        CASE COPYSTR("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", 1, 1) OF

                            'A':
                                Tipo_de_Comprobante := '003';
                            'B':
                                Tipo_de_Comprobante := '008';
                            'C':
                                Tipo_de_Comprobante := '013';
                            ELSE
                                Tipo_de_Comprobante := '003';
                        END;
                    end;

                    CLEAR(Punto_de_Venta);
                    "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No." := DELCHR("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", '=', ' ');
                    // Nestor solicita sacar el 0 para tomar 5 digitos reales
                    Punto_de_Venta := '' + COPYSTR("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", 2, 5);

                    Punto_de_Venta := DELCHR(Punto_de_Venta, '=', ' ,-');

                    WHILE STRLEN(Punto_de_Venta) < 5 DO
                        Punto_de_Venta := '0' + Punto_de_Venta;

                    //VALIDACIONES
                    IF (Punto_de_Venta = '00000') THEN
                        Punto_de_Venta := '00001';
                    //VALIDACIONES 


                    CLEAR(Numero_de_Comprobante);
                    CLEAR(NUMCOMP);

                    if "GMLocImport Dispatch" = '' then
                        NUMCOMP := COPYSTR("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", 1, 20)
                    else
                        NUMCOMP := "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.";

                    NUMCOMP := DELCHR(NUMCOMP, '=', '+-_ZXCVBNM¥LKJHGFDSAQWERTYUIOP');

                    IF (STRLEN(NUMCOMP) > 8) THEN
                        Numero_de_Comprobante := COPYSTR(NUMCOMP,
                                                                        STRLEN(NUMCOMP) - 7, 8)
                    ELSE BEGIN
                        WHILE STRLEN(Numero_de_Comprobante + NUMCOMP) < 8 DO
                            Numero_de_Comprobante := Numero_de_Comprobante + '0';
                        Numero_de_Comprobante := Numero_de_Comprobante + NUMCOMP;
                    END;

                    IF "GMLocImport Dispatch" <> '' THEN
                        Numero_de_Comprobante := '0';


                    WHILE STRLEN(Numero_de_Comprobante) < 20 DO
                        Numero_de_Comprobante := '0' + Numero_de_Comprobante;

                    //12198-
                    //Despacho
                    CLEAR(DespachoImportacion);
                    IF "GMLocImport Dispatch" <> '' THEN BEGIN
                        DespachoImportacion := COPYSTR("GMLocImport Dispatch", 1, 16);

                        WHILE STRLEN(DespachoImportacion) < 16 DO
                            DespachoImportacion := DespachoImportacion + '0';
                    END ELSE
                        WHILE STRLEN(DespachoImportacion) < 16 DO
                            DespachoImportacion := DespachoImportacion + ' ';
                    //12198+   

                    // CUIT De la Ficha de Vendor
                    CLEAR(CUIT);
                    IF Vendor.FIND('-') THEN BEGIN
                        IF (Vendor."VAT Registration No." <> '') THEN BEGIN
                            Vendor."VAT Registration No." := DELCHR(Vendor."VAT Registration No.", '=', '-');
                            CUIT := Vendor."VAT Registration No.";
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
                        END
                        else begin
                            CUIT := DELCHR("Purch. Cr. Memo Hdr."."VAT Registration No.", '=', '-');
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
                        end;
                    end
                    ELSE BEGIN
                        IF ("Purch. Cr. Memo Hdr."."VAT Registration No." <> '') THEN BEGIN
                            CUIT := DELCHR("Purch. Cr. Memo Hdr."."VAT Registration No.", '=', '-');
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
                        END
                        ELSE
                            WHILE STRLEN(CUIT) < 20 DO CUIT := '0' + CUIT;
                    END;
                    Codigo_de_Documento := '80';

                    TempTotalesCITI.INIT;
                    //12896 (03)-
                    TempTotalesCITI.GMLocID := FORMAT(NumeroLineas);
                    //12896 (03)+
                    TempTotalesCITI.GMLocLineNo := NumeroLineas;
                    TempTotalesCITI."GMLocVoucher No" := "Purch. Cr. Memo Hdr."."No.";
                    TempTotalesCITI.GMLocDescription := 'N/C Compras';


                    TempTotalesCITI."GMLocInvoice Vendor" := "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.";
                    WHILE STRLEN("Purch. Cr. Memo Hdr."."Buy-from Vendor Name") < 30 DO
                        "Purch. Cr. Memo Hdr."."Buy-from Vendor Name" := "Purch. Cr. Memo Hdr."."Buy-from Vendor Name" + ' ';

                    IF (STRLEN("Purch. Cr. Memo Hdr."."Buy-from Vendor Name") > 30) THEN
                        "Purch. Cr. Memo Hdr."."Buy-from Vendor Name" := COPYSTR("Purch. Cr. Memo Hdr."."Buy-from Vendor Name", 1, 30);

                    // Campo IMPORTE TOTAL CON IMPUESTOS en Divisa de la Factura con dos decimales Redondeados
                    // en 15 caracteres sin puntos ni comas
                    IF "Purch. Cr. Memo Hdr."."Currency Factor" <> 0 THEN
                        Tipocambio := ROUND(1 / "Purch. Cr. Memo Hdr."."Currency Factor", 0.000001)
                    ELSE
                        Tipocambio := 1;

                    "Purch. Cr. Memo Hdr.".CALCFIELDS(Amount, "Amount Including VAT");
                    Valor12 := "Purch. Cr. Memo Hdr."."Amount Including VAT";//* Tipocambio;


                    // IMPORTES BASE sin impuestos
                    Valor13 := 0; // Conceptos NO Gravados - No generan IVA
                                  //Valor14:=0; // Conceptos    Gravados -    Generan IVA
                    Valor17 := 0; // Siendo Gravado la Operacion esta Excenta
                    IF ("Tipo fiscal".GET("Purch. Cr. Memo Hdr."."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR('Debe Configurar en tipo fiscal Cod  3685');
                    END;

                    IF LineasCredito.FIND('-') THEN
                        REPEAT
                            IF (RecProvincia.GET("Purch. Cr. Memo Hdr.".GMLocProvince)) THEN BEGIN
                                IF (RecProvincia."GMLocCod 3685" = '') THEN
                                    ERROR(Text009);
                                IF (RecProvincia."GMLocCod 3685" = '23') THEN BEGIN
                                    Valor17 += LineasCredito.Amount// * Tipocambio;
                                END
                                ELSE BEGIN
                                    IF ("Tipo fiscal"."GMLocCod 3685" = '08') OR ("Tipo fiscal"."GMLocCod 3685" = '09') THEN BEGIN
                                        Valor13 += LineasCredito.Amount// * Tipocambio
                                    END
                                    ELSE BEGIN
                                        CLEAR(VATBUSPOSTINGGROUP);
                                        IF (VATBUSPOSTINGGROUP.GET(LineasCredito."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                            if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Normal VAT") then
                                                Valor13 += LineasCredito."VAT Base Amount";// * Tipocambio;



                                            if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Sales Tax") then begin
                                                IF (LclTaxGroup.GET(LineasCredito."Tax Group Code")) THEN;

                                                IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                                    Valor13 += LineasCredito.Amount// * Tipocambio
                                                ELSE
                                                    IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                        Valor17 += LineasCredito.Amount;//* Tipocambio;
                                            end;

                                        end
                                        else begin
                                            if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Normal VAT") then
                                                Valor13 += LineasCredito."VAT Base Amount";// * Tipocambio;
                                        end;
                                    END;
                                END
                            END
                            ELSE BEGIN
                                CLEAR(VATBUSPOSTINGGROUP);
                                IF (VATBUSPOSTINGGROUP.GET(LineasCredito."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMLocCalForTaxGroupCode)) THEN begin
                                    if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += LineasCredito."VAT Base Amount";// * Tipocambio;



                                    if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Sales Tax") then begin
                                        IF (LclTaxGroup.GET(LineasCredito."Tax Group Code")) THEN;

                                        IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::"No gravado") THEN
                                            Valor13 += LineasCredito.Amount// * Tipocambio
                                        ELSE
                                            IF (LclTaxGroup."GMLocRes 3685" = LclTaxGroup."GMLocRes 3685"::Exento) THEN
                                                Valor17 += LineasCredito.Amount;//* Tipocambio;
                                    end;

                                end
                                else begin
                                    if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Normal VAT") then
                                        Valor13 += LineasCredito."VAT Base Amount";// * Tipocambio;
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
                                   // Calculo los impuestos
                    CLEAR(GlobalDocumentType);
                    GlobalDocumentType := GlobalDocumentType::"Credit Memo";
                    calculoImpuestosInvoice("Purch. Cr. Memo Hdr."."No.");

                    //Campo 9 Importe total de la operaci¢n
                    CLEAR(Entero);

                    Campo12 := Formatvalor(Valor12, 15);
                    EVALUATE(Entero, Campo12);
                    Total2_8 += Entero;
                    // FIN campo 9  

                    TempTotalesCITI."GMLocOperation total amount" := -Valor12;
                    IF (Tipo_de_Comprobante = '008') OR (Tipo_de_Comprobante = '013') THEN
                        Valor13 := 0;
                    //Campo 10 Importe total de conceptos que no integran el precio neto gravado
                    CLEAR(Entero);
                    Campo13 := Formatvalor(Valor13, 15);
                    EVALUATE(Entero, Campo13);
                    Total2_9 += Entero;
                    TempTotalesCITI."GMLocImporte no Gravado" := -Valor13;
                    // FIN campo10

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
                    IF (Tipo_de_Comprobante = '008') OR (Tipo_de_Comprobante = '013') THEN
                        Valor17 := 0;

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


                    IF (Taxarea.GET("Purch. Cr. Memo Hdr."."Tax Area Code")) THEN;

                    IF ("Tipo fiscal".GET("Purch. Cr. Memo Hdr."."GMLocFiscal Type")) THEN BEGIN
                        IF ("Tipo fiscal"."GMLocCod 3685" = '') THEN
                            ERROR(Text008)
                        ELSE
                            Tiporesp := "Tipo fiscal"."GMLocCod 3685";
                    END;

                    IF (Currency.GET("Purch. Cr. Memo Hdr."."Currency Code")) THEN BEGIN
                        IF (Currency."GMLocAFIP Code" = '') THEN
                            ERROR(Text007)
                        ELSE
                            Moneda := Currency."GMLocAFIP Code";
                    END
                    ELSE
                        Moneda := 'PES';
                    // {
                    // IF "Purch. Cr. Memo Hdr."."Currency Factor" <>0
                    //     THEN Tipocambio:=ROUND(1/"Purch. Cr. Memo Hdr."."Currency Factor",0.000001)
                    //     ELSE Tipocambio:=1;
                    // }

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
                    I205 := 0;
                    ImporteI205 := 0;
                    ImporteBaseI205 := 0;
                    TextImporteI205 := '';
                    TextImporteBaseI205 := '';
                    calculoImpuestosBaseIVA("Purch. Cr. Memo Hdr."."No.");

                    Cantiva := I105 + I21 + I27 + I205 + I5;


                    IF (I205 <> 0) THEN BEGIN
                        TempTotalesCITI.GMLocIva205 := ImporteI205;
                        TempTotalesCITI.GMLocBase205 := ImporteBaseI205;
                        //IF(ImporteI105 <> 0)THEN
                        //  ImporteI105 := ABS(ImporteI105);
                        TextImporteI205 := FormatvalorNegativo(ImporteI205, 15);
                        EVALUATE(Entero, TextImporteI205);
                        // IF(ImporteBaseI105 <> 0)THEN
                        //  ImporteBaseI105 := ABS(ImporteBaseI105);

                        TextImporteBaseI205 := FormatvalorNegativo(ImporteBaseI205, 15);
                        EVALUATE(Entero, TextImporteBaseI205);
                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
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
                        //12198+
                    END;

                    IF (I105 <> 0) THEN BEGIN
                        TempTotalesCITI."GMLocVAT10,5" := ImporteI105;
                        TempTotalesCITI.GMLocBase105 := ImporteBaseI105;
                        //IF(ImporteI105 <> 0)THEN
                        //  ImporteI105 := ABS(ImporteI105);
                        TextImporteI105 := FormatvalorNC(ImporteI105, 15);
                        EVALUATE(Entero, TextImporteI105);
                        //  IF(ImporteBaseI105 <> 0)THEN
                        //  ImporteBaseI105 := ABS(ImporteBaseI105);

                        TextImporteBaseI105 := FormatvalorNC(ImporteBaseI105, 15);
                        EVALUATE(Entero, TextImporteBaseI105);
                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
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
                        TempTotalesCITI.GMLocVAT21 := ImporteI21;
                        TempTotalesCITI.GMLocBase21 := ImporteBaseI21;
                        //  IF(ImporteI21 <> 0)THEN
                        //  ImporteI21 := ABS(ImporteI21);
                        TextImporteI21 := FormatvalorNC(ImporteI21, 15);
                        EVALUATE(Entero, TextImporteI21);

                        // IF(ImporteBaseI21 <> 0)THEN
                        //  ImporteBaseI21 := ABS(ImporteBaseI21);
                        TextImporteBaseI21 := FormatvalorNC(ImporteBaseI21, 15);
                        EVALUATE(Entero, TextImporteBaseI21);

                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
                            CLEAR(TextoAlicDespacho);
                            TextoAlicDespacho := (
                            FORMAT(DespachoImportacion) +
                            FORMAT(TextImporteBaseI21) +
                            FORMAT('0005') +
                            FORMAT(TextImporteI21));


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
                            FORMAT(TextImporteBaseI21) +
                            FORMAT('0005') +
                            FORMAT(TextImporteI21));


                            NumeroLineasAlic += 1;
                            "#RellenaExcelBuffAlic"(TextoAlic);

                        END;
                        //12198+
                    END;


                    IF (I27 <> 0) THEN BEGIN
                        TempTotalesCITI.GMLociva27 := ImporteI27;
                        TempTotalesCITI.GMLocBase27 := ImporteBaseI27;
                        //  IF(ImporteI27 <> 0)THEN
                        //   ImporteI27 := ABS(ImporteI27);

                        TextImporteI27 := FormatvalorNC(ImporteI27, 15);
                        EVALUATE(Entero, TextImporteI27);
                        // IF(ImporteBaseI27 <> 0)THEN
                        //   ImporteBaseI27 := ABS(ImporteBaseI27);

                        TextImporteBaseI27 := FormatvalorNC(ImporteBaseI27, 15);
                        EVALUATE(Entero, TextImporteBaseI27);
                        //12198-
                        IF "GMLocImport Dispatch" <> '' THEN begin
                            CLEAR(TextoAlicDespacho);
                            TextoAlicDespacho := (
                            FORMAT(DespachoImportacion) +
                            FORMAT(TextImporteBaseI27) +
                            FORMAT('0006') +
                            FORMAT(TextImporteI27));


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
                            FORMAT(TextImporteBaseI27) +
                            FORMAT('0006') +
                            FORMAT(TextImporteI27));


                            NumeroLineasAlic += 1;
                            "#RellenaExcelBuffAlic"(TextoAlic);

                        END;
                        //12198+
                    END;

                    Codoper := ' ';
                    IF (Valor13 <> 0) AND (Valor15 = 0) THEN
                        CASE "Purch. Cr. Memo Hdr."."Tax Area Code" OF
                            'CLI-ZONAFRANCA':
                                Codoper := 'Z';
                            'CLI-EXTERIOR':
                                Codoper := 'X';
                            'CLI-EXENTO':
                                Codoper := 'E';
                            ELSE
                                Codoper := 'N';
                        END;

                    IF (Cantiva = 0) AND (Tipo_de_Comprobante <> '013') THEN BEGIN
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
                        FORMAT(Codigo_de_Documento) +
                        FORMAT(CUIT) +
                        FORMAT(TextImporteBaseI105) +
                        FORMAT('0003') +
                        FORMAT(TextImporteI105));

                        NumeroLineasAlic += 1;


                        "#RellenaExcelBuffAlic"(TextoAlic);

                        Codoper := 'E';
                    END;

                    IF Cantiva = 0 THEN Cantiva := 1;  // Se debe indicar 1 aun cuando la operaci¢n sea Exenta

                    IF (Tipo_de_Comprobante = '008') OR (Tipo_de_Comprobante = '013') THEN
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

                    CreditoFiscalComputabledec := ABS(ImporteI105 + ImporteI21 + ImporteI27 + ImporteI205);
                    CreditoFiscalComputable := Formatvalor(CreditoFiscalComputabledec, 15);
                    EVALUATE(Entero, CreditoFiscalComputable);

                    TempTotalesCITI.INSERT;
                    NumeroLineas += 1;

                    CLEAR(EsProveedorGenerico);
                    EsProveedorGenerico := argentina.genericVendor("Buy-from Vendor No.");
                    IF (EsProveedorGenerico) and ("Buy-from Vendor Name 2" <> '') THEN begin
                        "Buy-from Vendor Name" := "Buy-from Vendor Name 2";

                        WHILE STRLEN("Buy-from Vendor Name") < 30 DO
                            "Buy-from Vendor Name" := "Buy-from Vendor Name" + ' ';

                        IF (STRLEN("Buy-from Vendor Name") > 30) THEN
                            "Buy-from Vendor Name" := COPYSTR("Buy-from Vendor Name", 1, 30);
                    end;
                    CLEAR(TextoCbte);
                    CLEAR(postingDocDate);
                    IF (seePostDate) THEN
                        postingDocDate := "Posting Date"
                    else
                        postingDocDate := "Document Date";
                    IF "GMLocImport Dispatch" <> '' THEN begin
                        TextoCbte := (
                        FORMAT(postingDocDate, 8, '<Year4><Month,2><Day,2>') +
                        FORMAT(Tipo_de_Comprobante) +
                        FORMAT(Punto_de_Venta) +
                        FORMAT(Numero_de_Comprobante) +
                        FORMAT(DespachoImportacion) +
                        FORMAT(Codigo_de_Documento) +
                        FORMAT(CUIT) +
                        FORMAT("Buy-from Vendor Name") +
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

                        "#RellenaExcelBuffCbteDesp"(TextoCbte);

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
                        FORMAT("Buy-from Vendor Name") +
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
                        //ELSE
                        //"#EscribeFicheroCbte";
                    end;
                end;

            }

            trigger OnPreDataItem()
            begin
                Date.SETRANGE(Date."Period Type", Date."Period Type"::Date);
                Date.SETFILTER(Date."Period Start", '%1..%2', FechaDesde, FechaHasta);
                IF (Date.FINDFIRST) THEN
                    TempTotalesCITI.DELETEALL;
                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        "Purch. Cr. Memo Hdr.".SetFilter("Shortcut dimension 1 code", BssiDimension)
                    else
                        "Purch. Cr. Memo Hdr.".SetFilter("Shortcut dimension 2 code", BssiDimension);
                if FiltrarPorDocumentDate then begin
                    "Purch. Cr. Memo Hdr.".SetRange("Document Date", FechaDesde, FechaHasta);
                end else begin
                    "Purch. Cr. Memo Hdr.".SetRange("Posting Date", FechaDesde, FechaHasta);
                end;
            end;
        }

        dataitem("ARCHIVO REGINFO_CV_CABECERA"; Integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));

            trigger OnPreDataItem()
            begin
                IF (Empresa.GET) THEN;

                // 1-CUIT del Informante
                IF Empresa.FIND('-') THEN BEGIN
                    CUIT := COPYSTR(Empresa."VAT Registration No.", 1, 2);
                    CUIT := CUIT + COPYSTR(Empresa."VAT Registration No.", 4, 8);
                    CUIT := CUIT + COPYSTR(Empresa."VAT Registration No.", 13, 1);
                    WHILE STRLEN(CUIT) < 11 DO CUIT := '0' + CUIT;

                END;

                Tipo2_1 := CUIT;

                // 2-Per¡odo
                Tipo2_2 := FORMAT(Anio) + TextoMes;

                // 3-Secuencia Original (00), Rectificativas (01, 02..)
                Tipo2_3 := '00';

                // 4-Sin Movimiento SI (S) / NO (N)
                IF (CantidadRegistros > 1) THEN
                    Tipo2_4 := 'N'
                ELSE
                    Tipo2_4 := 'S';

                // 5-Prorratear Cr‚dito Fiscal Computable   SI (S) / NO (N)
                Tipo2_5 := 'N';
                //ELSE
                // Tipo2_4 := 'N';

                //6 Cr‚dito Fiscal Computable Global ¢ Por Comprobante  Global (1)  ¢ Por Comprobante (2)
                Tipo2_6 := '2';

                // 7-Importe Cr‚dito Fiscal Computable Global 13 enteros 2 decimales sin punto decimal
                Tipo2_7 := Formatvalor(Total2_8, 15);

                // 9-Importe Total de conceptos que no integran el precio neto gravado
                //Tipo2_9:=Formatvalor(Total2_9,15);
                // 8 - Importe Cr‚dito Fiscal Computable, con asignaci¢n directa. 13 enteros 2 decimales sin punto decimal
                Tipo2_8 := Formatvalor(Total2_9, 15);

                //9 -Importe Cr‚dito Fiscal Computable, determinado por prorrateo. 13 enteros 2 decimales sin punto decimal
                Tipo2_9 := Formatvalor(Total2_9, 15);


                // 10-Importe Cr‚dito Fiscal no Computable Global  13 enteros 2 decimales sin punto decimal
                Tipo2_10 := Formatvalor(Total2_10, 15);

                // 11-Impuesto Liquidado
                Tipo2_11 := Formatvalor(Total2_11, 15);

                // 12-Impuesto Liquidado a RNI o percepciones a no categorizados
                Tipo2_12 := Formatvalor(Total2_12, 15);

                CLEAR(Texto);
                Texto := (
                FORMAT(Tipo2_1) +
                FORMAT(Tipo2_2) +
                FORMAT(Tipo2_3) +
                FORMAT(Tipo2_4) +
                FORMAT(Tipo2_5) +
                FORMAT(Tipo2_6) +
                FORMAT(Tipo2_7) +
                FORMAT(Tipo2_8) +
                FORMAT(Tipo2_9) +
                FORMAT(Tipo2_10) +
                FORMAT(Tipo2_11) +
                FORMAT(Tipo2_12));
                NumeroLineas += 1;


                "#RellenaExcelBuff"(Texto)
                //    ELSE
                //        "#EscribeFichero";   
            end;
        }

        dataitem("ARCHIVO TOTALES"; integer)
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));

            trigger OnPreDataItem()
            begin
                IF (Empresa.GET) THEN;

                // 1-CUIT del Informante
                IF Empresa.FIND('-') THEN BEGIN
                    CUIT := COPYSTR(Empresa."VAT Registration No.", 1, 2);
                    CUIT := CUIT + COPYSTR(Empresa."VAT Registration No.", 4, 8);
                    CUIT := CUIT + COPYSTR(Empresa."VAT Registration No.", 13, 1);
                    WHILE STRLEN(CUIT) < 11 DO CUIT := '0' + CUIT;

                END;

                Tipo2_1 := CUIT;

                // 2-Per¡odo
                Tipo2_2 := FORMAT(Anio) + TextoMes;

                // 3-Secuencia Original (00), Rectificativas (01, 02..)
                Tipo2_3 := '00';

                // 4-Sin Movimiento SI (S) / NO (N)
                IF (CantidadRegistros > 1) THEN
                    Tipo2_4 := 'N'
                ELSE
                    Tipo2_4 := 'S';

                // 5-Prorratear Cr‚dito Fiscal Computable   SI (S) / NO (N)
                Tipo2_5 := 'N';
                //ELSE
                // Tipo2_4 := 'N';

                //6 Cr‚dito Fiscal Computable Global ¢ Por Comprobante  Global (1)  ¢ Por Comprobante (2)
                Tipo2_6 := '2';

                // 7-Importe Cr‚dito Fiscal Computable Global 13 enteros 2 decimales sin punto decimal
                Tipo2_7 := Formatvalor(Total2_8, 15);

                // 9-Importe Total de conceptos que no integran el precio neto gravado
                //Tipo2_9:=Formatvalor(Total2_9,15);
                // 8 - Importe Cr‚dito Fiscal Computable, con asignaci¢n directa. 13 enteros 2 decimales sin punto decimal
                Tipo2_8 := Formatvalor(Total2_9, 15);

                //9 -Importe Cr‚dito Fiscal Computable, determinado por prorrateo. 13 enteros 2 decimales sin punto decimal
                Tipo2_9 := Formatvalor(Total2_12, 15);


                // 10-Importe Cr‚dito Fiscal no Computable Global  13 enteros 2 decimales sin punto decimal
                Tipo2_10 := Formatvalor(Total2_13, 15);

                // 11-Impuesto Liquidado
                Tipo2_11 := Formatvalor(Total2_14, 15);

                // 12-Impuesto Liquidado a RNI o percepciones a no categorizados
                Tipo2_12 := Formatvalor(Total2_15, 15);

                NumeroLineas += 1;  // AW


                CLEAR(TextoTOTAL);
                TextoTOTAL := (
                FORMAT(Tipo2_1) +
                FORMAT(Tipo2_2) +
                FORMAT(Tipo2_3) +
                FORMAT(Tipo2_4) +
                FORMAT(Tipo2_5) +
                FORMAT(Tipo2_6) +
                FORMAT(Tipo2_7) +
                FORMAT(Tipo2_8) +
                FORMAT(Tipo2_9) +
                FORMAT(Tipo2_10) +
                FORMAT(Tipo2_11) +
                FORMAT(Tipo2_12));


                "#RellenaExcelBuff"(TextoTOTAL) //  estaba comentado
                                                // ELSE
                                                //      "#EscribeTOTALES";
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
                    field(FiltrarPorDocumentDate; FiltrarPorDocumentDate)
                    {
                        Caption = 'Filtrar por Fecha Documento';
                        ApplicationArea = All;
                        ToolTip = 'Si se activa, se filtra por la fecha del documento en lugar de la fecha de contabilización.';
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
        TempExcelBuffCbte.DeleteAll();
        TempExcelBuffCbtedesp.deleteall();
        TempExcelBuffAlicDespacho.deleteall();

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

    begin

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
            if Confirm('Desea generar el .txt de alícuotas de despacho?') then begin
                //XMLImportExport."#CargaExcelBuffTemp"(TempExcelBuffAlicDespacho);
                //Xmlport.Run(80396, false, false, TempExcelBuffAlicDespacho);
                Clear(pFileName);
                pFileName := 'Compras_AlícuotasDespacho';
                FileName := pFileName + '_' + FORMAT(DELCHR(FORMAT(TODAY), '=', '-:/;')) + FORMAT(DELCHR(FORMAT(TIME), '=', '.,:;'));
                ExportaTxt."#ExportarTxtMC"(FileName, TempExcelBuffAlicDespacho);
            end;
        end;

    end;

    var
        VATBUSPOSTINGGROUP: record "VAT Business Posting Group";
        XMLImportExport: XmlPort "GMLocXML ImportExport";
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
        Lineas: Record "Purch. Inv. Line";
        LineasCredito: Record "Purch. Cr. Memo Line";
        Empresa: Record "Company Information";
        Impuestos: Record "VAT Entry";
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
        ImporteI105: Decimal;
        ImporteI21: Decimal;
        ImporteI27: Decimal;
        ImporteBaseI105: Decimal;
        ImporteBaseI21: Decimal;
        ImporteBaseI27: Decimal;
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
        TempTotalesCITI: Record "GMLocAFIP - Concept Type" temporary;
        RecProvincia: Record GMLocProvince;
        "VAT Product Posting Group": Record 324;
        ExistAlicDespacho: Boolean;
        TextoBisAlicDespacho: BigText;
        TempExcelBuffAlicDespacho: Record 370 TEMPORARY;
        NumeroLineasAlicDespacho: Integer;
        TextoAlicDespacho: Text[1024];
        OutFileAlicDespacho: File;
        FileNameAlicDespacho: Text[250];
        ExportaTxt: Codeunit "GMLocExporta TXT";
        FileName: Text;
        pFileName: Text;
        postingDocDate: Date;
        seePostDate: Boolean;
        Argentina: codeunit GMLocArgentina2;
        EsProveedorGenerico: Boolean;
        recTaxJurisdiction: Record "Tax Jurisdiction";
        GlobalDocumentType: Enum "Gen. Journal Document Type";
        GRUPOREGIVAPROD: Record "VAT Product Posting Group";
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
        FiltrarPorDocumentDate: Boolean;

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

    begin

        // Calculo los impuestos
        Impuestos.Reset;
        Impuestos.SetCurrentkey("Document No.", "Posting Date");
        Impuestos.SetRange(Impuestos."Document Type", GlobalDocumentType);
        Impuestos.SetRange(Impuestos."Document No.", DocNo);
        Impuestos.setrange(type, impuestos.type::Purchase);
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
        impuestos.setrange(type, impuestos.type::Purchase);
        Impuestos.SetRange(Impuestos."Document No.", DocNo);
        if Impuestos.FindSet then
            repeat
                IF (Impuestos."Tax Jurisdiction Code" <> '') THEN BEGIN
                    Clear(recTaxJurisdiction);
                    recTaxJurisdiction.Reset;
                    recTaxJurisdiction.SetRange(Code, Impuestos."Tax Jurisdiction Code");
                    if recTaxJurisdiction.FindFirst then begin
                        case recTaxJurisdiction.GMLocTipo of

                            recTaxJurisdiction.GMLocTipo::"IVA2.5":
                                begin
                                    I205 := 1;
                                    ImporteI205 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI205 += (Impuestos.Base / Tipocambio);
                                end;

                            recTaxJurisdiction.GMLocTipo::"IVA5":
                                begin
                                    I205 := 1;
                                    ImporteI205 += (Impuestos.Amount / Tipocambio);
                                    ImporteBaseI205 += (Impuestos.Base / Tipocambio);
                                end;

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

                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 2.5) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I205 := 1;
                                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                        END;

                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 5) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I205 := 1;
                                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                        END;

                                                    if (GRUPOREGIVAPROD.GMLocPorIva = 27) then
                                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                                            I27 := 1;
                                                            ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                                ImporteBaseI27 := ImporteBaseI27 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                                        END;
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

                                    if (GRUPOREGIVAPROD.GMLocPorIva = 2.5) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I205 := 1;
                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                        END;

                                    if (GRUPOREGIVAPROD.GMLocPorIva = 5) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I205 := 1;
                                            ImporteI205 := ImporteI205 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                ImporteBaseI205 := ImporteBaseI205 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                        END;

                                    if (GRUPOREGIVAPROD.GMLocPorIva = 27) then
                                        IF (Impuestos.Amount <> 0) THEN BEGIN
                                            I27 := 1;
                                            ImporteI27 := ImporteI27 + (Impuestos.Amount / Tipocambio);
                                            if (GRUPOREGIVAPROD.GMLocPorIva <> 0) then
                                                ImporteBaseI27 := ImporteBaseI27 + (ROUND((Impuestos.Amount / GRUPOREGIVAPROD.GMLocPorIva) * 100, 0.01) / Tipocambio);
                                        END;
                                end;

                        end;
                    end;
                end;
            UNTIL Impuestos.NEXT = 0;
    end;


}

