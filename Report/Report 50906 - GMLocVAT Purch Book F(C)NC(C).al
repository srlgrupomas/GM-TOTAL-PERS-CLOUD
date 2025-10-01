report 34006906 "PersVAT Purch Book F(C)NC(C)"
{
    // version SDTNOBORRAR

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107497 - GMAVAT Purch Book F(C)NC(C).rdl';
    Caption = 'Libro IVA Compras F(C) NC(C)';
    dataset
    {
        dataitem(DimensionValue; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code);
            PrintOnlyIfDetail = true;
            column(BssiMEMCode; Code)
            {
            }
            column(BssiMEMName; Name)
            {
            }
            column(BssiEntityLegalName; BssiLegalNameFull)
            {
            }
            column(BssiEntityTaxRegistrationNumber; BssiTaxRegistrationNumber)
            {
            }
            column(BssiEntityPicture; BssiPicture)
            {
            }
            column(BssiEntityEmail; BssiEmail)
            {
            }
            column(BssiEntityHomePage; BssiHomePage)
            {
            }
            column(BssiEntityBankAccount; BssiBankAccount)
            {
            }
            column(BssiEntityIntercompanyCustomerNo; BssiIntercompanyCustomerNo)
            {
            }
            column(BssiEntityIntercompanyVendorNo; BssiIntercompanyVendorNo)
            {
            }
            column(BssiEntityIntercompanyLocationNo; BssiIntercompanyLocationNo)
            {
            }
            column(BssiEntityApprovarUser; BssiApprovarUser)
            {
            }
            column(BssiEntityBillingAddr1; BssiBillingAddr1)
            {
            }
            column(BssiEntityBillingAddress2; BssiBillingAddress2)
            {
            }
            column(BssiEntityBillingCity; BssiBillingCity)
            {
            }
            column(BssiEntityBillingState; BssiBillingState)
            {
            }
            column(BssiEntityBillingZipCode; BssiBillingZipCode)
            {
            }
            column(BssiEntityBillingCountry; BssiBillingCountry)
            {
            }
            column(BssiEntityBillingContactName; BssiBillingContactName)
            {
            }
            column(BssiEntityBillingPhoneNumber; BssiBillingPhoneNumber)
            {
            }
            column(BssiEntityShippingAddr1; BssiShippingAddr1)
            {
            }
            column(BssiEntityShippingAddress2; BssiShippingAddress2)
            {
            }
            column(BssiEntityShippingCity; BssiShippingCity)
            {
            }
            column(BssiEntityShippingState; BssiShippingState)
            {
            }
            column(BssiEntityShippingZipCode; BssiShippingZipCode)
            {
            }
            column(BssiEntityShippingCountry; BssiShippingCountry)
            {
            }
            column(BssiEntityShippingContactName; BssiShippingContactName)
            {
            }
            column(BssiEntityShippingPhoneNumber; BssiShippingPhoneNumber)
            {
            }
            column(BssiMEMPrint; BssiPrint)
            {
            }
            dataitem(Cabecera; "Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
                column(ReportForNavId_6592; 6592)
                {
                }
                column(Folio; Folio)
                {
                }
                column(Empresa_City; Empresa.BssiBillingCity)
                {
                }
                column(Empresa__VAT_Registration_No__; Empresa.BssiRegistrationNo)
                {
                }
                column(Empresa_Name; Empresa.Name)
                {
                }
                // column(Empresa_Name; '')
                // {
                // }
                column(Empresa_Address; Empresa.BssiBillingAddr1)
                {
                }
                // column(Empresa_Address; '')
                // {
                // }
                column(Empresa__Post_Code_; Empresa.BssiBillingZipCode)
                {
                }
                column(Desde; Desde)
                {
                }
                column(Hasta; Hasta)
                {
                }
                column(Folio_Caption; Folio_CaptionLbl)
                {
                }
                column(LIBRO_IVA_COMPRASCaption; LIBRO_IVA_COMPRASCaptionLbl)
                {
                }
                column(CUIT_Caption; CUIT_CaptionLbl)
                {
                }
                column("Período_Caption"; Período_CaptionLbl)
                {
                }
                column(FromCaption; FromCaptionLbl)
                {
                }
                column(ToCaption; ToCaptionLbl)
                {
                }
                column(Cabecera_Number; Number)
                {
                }
                dataitem(Facturas; "Purch. Inv. Header")
                {
                    DataItemTableView = sorting("Posting Date", "No.") order(ascending);
                    RequestFilterFields = "GMAFiscal Type";

                    dataitem(AFacturas; "Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1));


                        trigger OnAfterGetRecord()
                        begin
                            if Number > Alicant then CurrReport.Break;
                            // Calculo las Bases No Gravadas y Excentas
                            Lineas.Reset;
                            Lineas.SetRange(Lineas."Document No.", Facturas."No.");
                            if Lineas.FindSet then
                                repeat
                                    CLEAR(VATBUSPOSTINGGROUP);
                                    IF (VATBUSPOSTINGGROUP.GET(Lineas."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMACalForTaxGroupCode)) THEN begin
                                        if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                            BaseNoGravado += Lineas."VAT Base Amount" * Tipocambio;

                                        if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Full VAT") then begin
                                            GRUPOREGIVAPROD.reset;
                                            GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, lineas."VAT Prod. Posting Group");
                                            if GRUPOREGIVAPROD.FindFirst then begin
                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') or (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '5') or (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then begin
                                                    BaseGravado += (ROUND((Lineas.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) * Tipocambio);
                                                    TotalFactura += (ROUND((Lineas.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) * Tipocambio);

                                                end;
                                            end;
                                        end;

                                        if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Sales Tax") then begin
                                            taxGroup.reset;
                                            taxGroup.setRange(code, Lineas."Tax Group Code");
                                            IF (taxGroup.findfirst) THEN begin
                                                if (TaxGroup."GMARes 3685" = TaxGroup."GMARes 3685"::"No gravado") or (TaxGroup."GMARes 3685" = TaxGroup."GMARes 3685"::Exento) then begin
                                                    BaseNoGravado += Lineas."VAT Base Amount" * Tipocambio;
                                                end else begin
                                                    BaseGravado += Lineas.Amount * Tipocambio
                                                end;
                                            end;
                                        end;
                                    end
                                    else begin

                                        if (lineas."VAT Calculation Type" = lineas."VAT Calculation Type"::"Normal VAT") then
                                            BaseNoGravado += Lineas."VAT Base Amount" * Tipocambio
                                        else
                                            BaseGravado += Lineas."VAT Base Amount" * Tipocambio;
                                    end;
                                until Lineas.Next = 0;

                            //CalculoImpuesto Facturas
                            calculoImpuestosInvoice(Facturas."No.");

                            BaseTotal := ROUND(BaseTotal, 0.0001);
                            BaseGravado := ROUND(BaseGravado, 0.001);
                            BaseNoGravado := ROUND(BaseNoGravado, 0.001);
                            BaseExcento := ROUND(BaseExcento, 0.001);
                            TotalFactura := ROUND(TotalFactura, 0.001);

                            //Inserto datos en TEMP
                            keyTempDatos += 1;
                            recTempDatos.Reset;
                            recTempDatos.SetRange(GMAPostingdate, Facturas."Posting Date");
                            recTempDatos.SetRange(GMAInvoiceNumber, Facturas."No.");
                            if not recTempDatos.FindFirst then begin
                                recTempDatos.GMAKey := keyTempDatos;
                                recTempDatos.GMAPostingdate := Facturas."Document Date";
                                recTempDatos.GMAInvoiceNumber := Facturas."Vendor Invoice No.";
                                FacturaVisibilidad := true;


                                if Facturas."GMADocument Type Loc." = Facturas."GMADocument Type Loc."::Invoice then begin
                                    RecTempDatos.GMAtipodocumento := 'Factura';

                                end else begin
                                    RecTempDatos.GMAtipodocumento := 'Nota Débito';
                                end;

                                case Facturas."GMAAFIP Invoice Voucher Type" of
                                    '66':
                                        RecTempDatos.GMAtipodocumento := 'Despacho Importación';
                                    '81':
                                        RecTempDatos.GMAtipodocumento := 'Tique-Factura "A"';
                                    '51':
                                        RecTempDatos.GMAtipodocumento := 'Factura "M"';
                                    '17':
                                        RecTempDatos.GMAtipodocumento := 'Liquidación de servicios públicos clase "A"';
                                end;

                                cleaR(EsProveedorGenerico);
                                EsProveedorGenerico := argentina.genericVendor(Facturas."Buy-from Vendor No.");
                                IF (EsProveedorGenerico) and (Facturas."Buy-from Vendor Name 2" <> '') THEN
                                    Facturas."Buy-from Vendor Name" := Facturas."Buy-from Vendor Name 2";

                                recTempDatos.GMACustomerName := Facturas."Buy-from Vendor Name";
                                recTempDatos.GMAVATRegistrationNo := Facturas."VAT Registration No.";
                                recTempDatos.GMAFiscalType := Facturas."GMAFiscal Type";
                                recTempDatos.GMAExternalDocumentNo := Facturas."Vendor Invoice No.";
                                recTempDatos.GMADocumentDate := Facturas."Document Date";
                                recTempDatos.GMABaseAmount := BaseGravado;
                                recTempDatos.GMAVAT25 := ABS(decIVA25);
                                recTempDatos.GMAVAT105 := ABS(decIVA105);
                                recTempDatos.GMAVAT21 := ABS(decIVA21);
                                recTempDatos.GMAVAT27 := ABS(decIVA27);
                                recTempDatos.GMAVATPercep := ABS(IPer);
                                recTempDatos.GMAIIBB := ABS(IIB);
                                recTempDatos.GMAGAN := ABS(IGA);
                                recTempDatos.GMASpecial := ABS(IOP);
                                recTempDatos.GMANoBaseAmount := BaseNoGravado + BaseExcento;
                                recTempDatos.GMAInvoiceAmount := TotalFactura;
                                recTempDatos.GMAProvince := Facturas.GMAProvince;
                                recTempDatos.Insert(false);
                            end else begin
                                recTempDatos.GMAVAT25 += ABS(decIVA25);
                                recTempDatos.GMAVAT105 += ABS(decIVA105);
                                recTempDatos.GMAVAT21 += ABS(decIVA21);
                                recTempDatos.GMAVAT27 += ABS(decIVA27);
                                recTempDatos.GMAVATPercep += IPer;
                                recTempDatos.GMAIIBB += IIB;
                                recTempDatos.GMAGAN += IGA;
                                recTempDatos.GMASpecial += IOP;
                                recTempDatos.Modify(false);
                            end;

                        end;

                        trigger OnPostDataItem()
                        begin
                            SumaBG += BaseGravado;
                            SumaBNG += BaseNoGravado;
                            SumaBE += BaseExcento;
                            SumaIIVA += IIVA;
                            SumaIPer += IPer;
                            SumaIIB += IIB;
                            SumaIOP += IOP;
                            SumaIGA += IGA;

                            // Acumula el IVA por Alícuota
                            Alic[Number, 2] += IIVA;

                            // Si es última Alícuota pone la Dif. Redondeo puntero en última línea
                            Entero := 0;
                            if Number <> 10 then
                                for I := Number + 1 to Alicant do
                                    Entero += IvasFactura[I];

                            if Entero = 0 then begin
                                DifRed := ROUND(ABS(TotalFactura), 0.01) - ROUND(ABS(SumaBG), 0.01) - ROUND(ABS(SumaBNG), 0.01) - ROUND(ABS(SumaBE), 0.01)
                                         - ROUND(ABS(SumaIIVA), 0.01) - ROUND(ABS(SumaIPer), 0.01) - ROUND(ABS(SumaIIB), 0.01) - ROUND(ABS(SumaIOP), 0.01) - ROUND(ABS(SumaIGA), 0.01);
                                Number := 10;
                            end;

                            BaseTotal := BaseGravado + BaseNoGravado + BaseExcento;

                            // Si la Línea esta en Blanco no la muestra
                            if (BaseTotal = 0) and (decIVA105 + decIVA21 + decIVA27 + decIVA25 = 0) and (IPer = 0) and (IIB = 0) and (IOP = 0) then
                                CurrReport.Skip;

                            GTotalBaseGravado += BaseGravado;
                            GTotalBaseNoGravado += BaseNoGravado;
                            GTotalBaseExcento += BaseExcento;
                            GTotalBaseTotal += BaseTotal;
                            GTotalIIVA += decIVA105 + decIVA21 + decIVA27 + decIVA25;
                            GTotalIPer += ABS(IPer);
                            GTotalIIB += ABS(IIB);
                            GTotalIOP += ABS(IOP);
                            GTotalIGA += ABS(IGA);
                            GTdecIVA105 += ABS(decIVA105);
                            GTdecIVA21 += ABS(decIVA21);
                            GTdecIVA27 += ABS(decIVA27);
                            GTdecIVA25 += ABS(decIVA25);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SumaBG := 0;
                            SumaBNG := 0;
                            SumaBE := 0;
                            SumaIIVA := 0;
                            SumaIPer := 0;
                            SumaIIB := 0;
                            SumaIOP := 0;
                            SumaIGA := 0;
                            decIVA105 := 0;
                            decIVA27 := 0;
                            decIVA21 := 0;
                            decIVA25 := 0;
                            BaseGravado := 0;
                            BaseNoGravado := 0;
                            BaseExcento := 0;
                            BaseTotal := 0;
                            IIVA := 0;
                            IPer := 0;
                            IIB := 0;
                            IGA := 0;
                            IOP := 0;
                        end;
                    }


                    trigger OnAfterGetRecord()
                    begin
                        //---Determina que Facturas deben tratarse como No Gravadas o Exentas o No aparecer en el Libro IVA Compras---
                        jDesAfipTipo := '';

                        if (Facturas."Quote No." = '') and (Facturas."Order No." = '') and ("Vendor Invoice No." = '') then
                            CurrReport.Skip;

                        TipoIVAcero := 'NoGravado';

                        recTipoFiscal.Reset;
                        recTipoFiscal.SetRange(GMACode, Facturas."GMAFiscal Type");
                        if recTipoFiscal.FindFirst then begin
                            if recTipoFiscal.GMATipo = recTipoFiscal.GMATipo::Exento then
                                TipoIVAcero := 'EXENTO'
                            else
                                if (recTipoFiscal."GMASummary in VAT Book" = false) then
                                    CurrReport.Skip;          //No debe aparecer en el Libro de Compras
                        end;


                        Facturas.CalcFields(Facturas."Amount Including VAT");
                        if Facturas."Currency Factor" <> 0 then
                            Tipocambio := ROUND(1 / Facturas."Currency Factor", 0.000001)
                        else
                            Tipocambio := 1;

                        TotalFactura := Facturas."Amount Including VAT" * Tipocambio;
                        GTotalFactura += TotalFactura;
                        Clear(IvasFactura);
                        Lineas.Reset;
                        Lineas.SetCurrentkey("Document No.", "Line No.");
                        Lineas.SetRange(Lineas."Document No.", Facturas."No.");
                        if Lineas.FindSet then
                            repeat
                                if (Lineas.Amount <> 0) or (Lineas."Amount Including VAT" <> 0) then begin
                                    Alicuota := numeroiva(alicuotaiva(Lineas."Tax Group Code"));
                                    if Alicuota <> 1 then begin     // La alícuota no es CERO (no es la primera)
                                        Impuestos.Reset;
                                        Impuestos.SetCurrentkey("Entry No.");
                                        Impuestos.SetRange(Impuestos."Document No.", Facturas."No.");
                                        Impuestos.SetFilter(Impuestos."Document Type", '%1', Impuestos."document type"::Invoice);
                                        Impuestos.SetRange(Impuestos."Tax Group Code", Lineas."Tax Group Code");
                                        Impuestos.SetRange(Impuestos."GMATax Type Loc", Impuestos."GMATax Type Loc"::IVA);
                                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                            Impuestos.SetRange("Bssi Shortcut Dimension 1 Code", DimensionValue.Code)
                                        else
                                            Impuestos.SetRange("Bssi Shortcut Dimension 2 Code", DimensionValue.Code);
                                        if Impuestos.FindSet then begin
                                            Decimal := 0;
                                            repeat
                                                Decimal += Impuestos.Amount;
                                            until Impuestos.Next = 0;
                                            if Decimal = 0 then
                                                Alicuota := 1;
                                        end else
                                            Alicuota := 1;
                                    end;
                                    IvasFactura[Alicuota] := 1;
                                end;
                            until Lineas.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if Desde < 20130720D then
                            Desde := 20130720D;

                        Facturas.SetRange("Posting Date", Desde, Hasta);
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            SetFilter("Shortcut Dimension 1 Code", DimensionValue.Code)
                        else
                            SetFilter("Shortcut Dimension 2 Code", DimensionValue.Code);
                    end;
                }
                dataitem(NotasDeCredito; "Purch. Cr. Memo Hdr.")
                {
                    DataItemTableView = sorting("No.") order(ascending);

                    dataitem(ACreditos; "Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1));


                        trigger OnAfterGetRecord()
                        begin
                            if Number > Alicant then CurrReport.Break;

                            LineasCredito.Reset;
                            LineasCredito.SetRange(LineasCredito."Document No.", NotasDeCredito."No.");
                            if LineasCredito.FindSet then
                                repeat
                                    CLEAR(VATBUSPOSTINGGROUP);
                                    IF (VATBUSPOSTINGGROUP.GET(LineasCredito."VAT Bus. Posting Group") AND (VATBUSPOSTINGGROUP.GMACalForTaxGroupCode)) THEN begin
                                        if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Normal VAT") then
                                            BaseNoGravado += LineasCredito."VAT Base Amount" * Tipocambio;

                                        if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Full VAT") then begin
                                            GRUPOREGIVAPROD.reset;
                                            GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, lineas."VAT Prod. Posting Group");
                                            if GRUPOREGIVAPROD.FindFirst then begin
                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') or (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '5') or (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then begin
                                                    BaseGravado += (ROUND((Lineas.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) * Tipocambio);
                                                    TotalFactura += (ROUND((Lineas.Amount / GRUPOREGIVAPROD.GMAPorIva) * 100, 0.01) * Tipocambio);

                                                end;
                                            end;
                                        end;

                                        if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Sales Tax") then begin
                                            taxGroup.reset;
                                            taxGroup.setRange(code, LineasCredito."Tax Group Code");
                                            IF (taxGroup.findfirst) THEN begin
                                                if (TaxGroup."GMARes 3685" = TaxGroup."GMARes 3685"::"No gravado") or (TaxGroup."GMARes 3685" = TaxGroup."GMARes 3685"::Exento) then begin
                                                    BaseNoGravado += LineasCredito."VAT Base Amount" * Tipocambio;
                                                end else begin
                                                    BaseGravado += LineasCredito.Amount * Tipocambio
                                                end;
                                            end;
                                        end;
                                    end
                                    else begin

                                        if (LineasCredito."VAT Calculation Type" = LineasCredito."VAT Calculation Type"::"Normal VAT") then
                                            BaseNoGravado += LineasCredito."VAT Base Amount" * Tipocambio
                                        else
                                            BaseGravado += LineasCredito."VAT Base Amount" * Tipocambio;
                                    end;
                                until LineasCredito.Next = 0;

                            // Calculo los impuestos

                            // Calculo los impuestos
                            calculoImpuestosCreditMemo(NotasDeCredito."No.");

                            BaseTotal := ROUND(BaseTotal, 0.0001);
                            BaseGravado := ROUND(BaseGravado, 0.001);
                            BaseNoGravado := ROUND(BaseNoGravado, 0.001);
                            BaseExcento := ROUND(BaseExcento, 0.001);
                            TotalFactura := ROUND(TotalFactura, 0.001);


                            //Inserto datos en TEMP
                            keyTempDatos += 1;
                            recTempDatos.Reset;
                            recTempDatos.SetRange(GMAPostingdate, NotasDeCredito."Posting Date");
                            recTempDatos.SetRange(GMAInvoiceNumber, NotasDeCredito."No.");
                            if not recTempDatos.FindFirst then begin
                                recTempDatos.GMAKey := keyTempDatos;
                                recTempDatos.GMAPostingdate := NotasDeCredito."Document Date";
                                recTempDatos.GMAInvoiceNumber := NotasDeCredito."Vendor Cr. Memo No.";
                                recTempDatos.GMAtipodocumento := 'Notas de Credito'; //FORMAT(NotasDeCredito."GMADocument Type Loc.");

                                case NotasDeCredito."GMAAFIP Invoice Voucher Type" of
                                    '17C':
                                        RecTempDatos.GMAtipodocumento := 'Abono Liq. Serv. Publicos';
                                end;

                                FacturaVisibilidad := false;

                                recTempDatos.GMACustomerName := NotasDeCredito."Buy-from Vendor Name";
                                recTempDatos.GMAVATRegistrationNo := NotasDeCredito."VAT Registration No.";
                                recTempDatos.GMAFiscalType := NotasDeCredito."GMAFiscal Type";
                                //recTempDatos.GMAExternalDocumentNo := NotasDeCredito."Ex";
                                recTempDatos.GMADocumentDate := NotasDeCredito."Document Date";
                                recTempDatos.GMABaseAmount := BaseGravado;
                                recTempDatos.GMAVAT25 := ABS(decIVA25);
                                recTempDatos.GMAVAT105 := ABS(decIVA105);
                                recTempDatos.GMAVAT21 := ABS(decIVA21);
                                recTempDatos.GMAVAT27 := ABS(decIVA27);
                                recTempDatos.GMAVATPercep := ABS(IPer);
                                recTempDatos.GMAIIBB := ABS(IIB);
                                recTempDatos.GMAGAN := ABS(IGA);
                                recTempDatos.GMASpecial := ABS(IOP);
                                recTempDatos.GMANoBaseAmount := (BaseNoGravado + BaseExcento);
                                recTempDatos.GMAInvoiceAmount := TotalFactura;
                                recTempDatos.GMAProvince := NotasDeCredito.GMAProvince;
                                recTempDatos.Insert(false);
                            end else begin
                                recTempDatos.GMAVAT25 += ABS(decIVA25);
                                recTempDatos.GMAVAT105 += ABS(decIVA105);
                                recTempDatos.GMAVAT21 += ABS(decIVA21);
                                recTempDatos.GMAVAT27 += ABS(decIVA27);
                                recTempDatos.Modify(false);
                            end;

                        end;

                        trigger OnPostDataItem()
                        begin
                            SumaBG += BaseGravado;
                            SumaBNG += BaseNoGravado;
                            SumaBE += BaseExcento;
                            SumaIIVA += IIVA;
                            SumaIPer += IPer;
                            SumaIIB += IIB;
                            SumaIOP += IOP;
                            SumaIGA += IGA;

                            // Acumula el IVA por Alícuota
                            Alic[Number, 2] += IIVA;

                            // Si es última Alícuota pone la Dif. Redondeo puntero en última línea
                            Entero := 0;
                            if Number <> 10 then
                                for I := Number + 1 to Alicant do
                                    Entero += IvasFactura[I];

                            if Entero = 0 then begin
                                DifRed := ROUND(ABS(TotalFactura), 0.01) - ROUND(ABS(SumaBG), 0.01) - ROUND(ABS(SumaBNG), 0.01) - ROUND(ABS(SumaBE), 0.01)
                                         - ROUND(ABS(SumaIIVA), 0.01) - ROUND(ABS(SumaIPer), 0.01) - ROUND(ABS(SumaIIB), 0.01) - ROUND(ABS(SumaIOP), 0.01) - ROUND(ABS(SumaIGA), 0.01);
                                Number := 10;
                            end;

                            BaseTotal := BaseGravado + BaseNoGravado + BaseExcento;

                            // Si la Línea esta en Blanco no la muestra
                            if (BaseTotal = 0) and (decIVA105 + decIVA21 + decIVA27 + decIVA25 = 0) and (IPer = 0) and (IIB = 0) and (IOP = 0) then
                                CurrReport.Skip;

                            GTotalBaseGravadoC += BaseGravado;
                            GTotalBaseNoGravadoC += BaseNoGravado;
                            GTotalBaseExcentoC += BaseExcento;
                            GTotalBaseTotalC += BaseTotal;
                            GTotalIIVAC += ABS(decIVA105 + decIVA21 + decIVA27 + decIVA25);
                            GTotalIPerC += ABS(IPer);
                            GTotalIIBC += ABS(IIB);
                            GTotalIOPC += ABS(IOP);
                            GTotalIGAC += ABS(IGA);
                            GTdecIVA105C += ABS(decIVA105);
                            GTdecIVA21C += ABS(decIVA21);
                            GTdecIVA27C += ABS(decIVA27);
                            GTdecIVA25C += ABS(decIVA25);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SumaBG := 0;
                            SumaBNG := 0;
                            SumaBE := 0;
                            SumaIIVA := 0;
                            SumaIPer := 0;
                            SumaIIB := 0;
                            SumaIOP := 0;
                            SumaIGA := 0;
                            BaseGravado := 0;
                            BaseNoGravado := 0;
                            BaseExcento := 0;
                            BaseTotal := 0;
                            IIVA := 0;
                            IPer := 0;
                            IIB := 0;
                            IGA := 0;
                            IOP := 0;
                            decIVA21 := 0;
                            decIVA105 := 0;
                            decIVA27 := 0;
                            decIVA25 := 0;
                        end;
                    }


                    trigger OnAfterGetRecord()
                    begin
                        //---Determina que Facturas deben tratarse como No Gravadas o Exentas o No aparecer en el Libro IVA Compras---
                        TipoIVAcero := 'NoGravado';
                        NotasDeCredito."No." := NotasDeCredito."No.";

                        recTipoFiscal.Reset;
                        recTipoFiscal.SetRange(GMACode, NotasDeCredito."GMAFiscal Type");
                        if recTipoFiscal.FindFirst then begin
                            if recTipoFiscal.GMATipo = recTipoFiscal.GMATipo::Exento then
                                TipoIVAcero := 'EXENTO'
                            else
                                if (recTipoFiscal."GMASummary in VAT Book" = false) then
                                    CurrReport.Skip;
                        end;

                        NotasDeCredito.CalcFields(NotasDeCredito."Amount Including VAT");

                        if NotasDeCredito."Currency Factor" <> 0 then
                            Tipocambio := ROUND(1 / NotasDeCredito."Currency Factor", 0.000001)
                        else
                            Tipocambio := 1;

                        TotalFactura := NotasDeCredito."Amount Including VAT" * Tipocambio;
                        GTotalFacturaC += TotalFactura;  // cesar

                        Clear(IvasFactura);
                        LineasCredito.Reset;
                        LineasCredito.SetRange(LineasCredito."Document No.", NotasDeCredito."No.");
                        if LineasCredito.FindSet then
                            repeat
                                if LineasCredito.Amount <> 0 then begin
                                    Alicuota := numeroiva(alicuotaiva(LineasCredito."Tax Group Code"));
                                    if Alicuota <> 1 then begin
                                        Impuestos.Reset;
                                        Impuestos.SetCurrentkey("Entry No.");
                                        Impuestos.SetRange(Impuestos."Document Type", Impuestos."document type"::"Credit Memo");
                                        Impuestos.SetRange(Impuestos."Document No.", NotasDeCredito."No.");
                                        Impuestos.SetRange(Impuestos."Tax Group Code", LineasCredito."Tax Group Code");
                                        Impuestos.SetRange(Impuestos."GMATax Type Loc", Impuestos."GMATax Type Loc"::IVA);
                                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                            Impuestos.SetRange("Bssi Shortcut Dimension 1 Code", DimensionValue.Code)
                                        else
                                            Impuestos.SetRange("Bssi Shortcut Dimension 2 Code", DimensionValue.Code);
                                        if Impuestos.FindSet then begin
                                            Decimal := 0;
                                            repeat
                                                Decimal += Impuestos.Amount;
                                            until Impuestos.Next = 0;

                                            if Decimal = 0 then
                                                Alicuota := 1;
                                        end else
                                            Alicuota := 1;
                                    end;

                                    IvasFactura[Alicuota] := 1;
                                end;
                            until LineasCredito.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if Desde < 20130720D then
                            Desde := 20130720D;

                        NotasDeCredito.SetRange("Posting Date", Desde, Hasta);
                        Tipo := 'Nota Crédito';
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            SetFilter("Shortcut Dimension 1 Code", DimensionValue.Code)
                        else
                            SetFilter("Shortcut Dimension 2 Code", DimensionValue.Code);
                    end;
                }
                dataitem(DatosTemporal; "Integer")
                {
                    column(ReportForNavId_5680; 5680)
                    {
                    }
                    column(recTempDatos__Fecha_Registros_; recTempDatos.GMAPostingdate)
                    {
                    }
                    column(recTempDatos__Num_Documento_Externo_; recTempDatos.GMAExternalDocumentNo)
                    {
                    }
                    column(recTempDatos__Razon_Social_; recTempDatos.GMACustomerName)
                    {
                    }
                    column(recTempDatos_CUIT; recTempDatos.GMAVATRegistrationNo)
                    {
                    }
                    column(recTempDatos__Total_Factura_; recTempDatos.GMAInvoiceAmount)
                    {
                    }
                    column(recTempDatos__IVA_10_5_; recTempDatos.GMAVAT105)
                    {
                    }
                    column(recTempDatos__IVA_2_5_; recTempDatos.GMAVAT25)
                    {
                    }
                    column(recTempDatos_IIBB; recTempDatos.GMAIIBB)
                    {
                    }
                    column(recTempDatos__Impuestos_Internos_; recTempDatos.GMASpecial)
                    {
                    }
                    column(recTempDatos_Gravado; recTempDatos.GMABaseAmount)
                    {
                    }
                    column(recTempDatos__No_Gravado___Exento_; recTempDatos.GMANoBaseAmount)
                    {
                    }
                    column(recTempDatos__Fecha_Documento_; recTempDatos.GMADocumentDate)
                    {
                    }
                    column(recTempDatos__Numero_Interno_; recTempDatos.GMAInvoiceNumber)
                    {
                    }
                    column(recTempDatos_GAN; recTempDatos.GMAGAN)
                    {
                    }
                    column(recTempDatos__Tipo_Fiscal_; recTempDatos.GMAFiscalType)
                    {
                    }
                    column(recTempDatos__IVA_27_; recTempDatos.GMAVAT27)
                    {
                    }
                    column(recTempDatos__Tipo_Documento_; recTempDatos."GMAtipodocumento")
                    {
                    }
                    column(FacturaVisibilidad; FacturaVisibilidad)
                    {
                    }
                    column(recTempDatos__IVA_Percep_; recTempDatos.GMAVATPercep)
                    {
                    }
                    column(recTempDatos__IVA_21_; recTempDatos.GMAVAT21)
                    {
                    }
                    column(Fecha_Reg_Caption; Fecha_Reg_CaptionLbl)
                    {
                    }
                    column(N___InternoCaption; N___InternoCaptionLbl)
                    {
                    }
                    column(Impuesto_IVACaption; Impuesto_IVACaptionLbl)
                    {
                    }
                    column(Base_GravadoCaption; Base_GravadoCaptionLbl)
                    {
                    }
                    column(Doc_TypeCaption; Doc_TypeCaptionLbl)
                    {
                    }
                    column(CUITCaption; CUITCaptionLbl)
                    {
                    }
                    column("Razón_SocialCaption"; Razón_SocialCaptionLbl)
                    {
                    }
                    column(Doc__Nr_Caption; Doc__Nr_CaptionLbl)
                    {
                    }
                    column(Fecha_Doc_Caption; Fecha_Doc_CaptionLbl)
                    {
                    }
                    column(Tipo_FiscalCaption; Tipo_FiscalCaptionLbl)
                    {
                    }
                    column(Tipo_DocumentoCaption; Tipo_DocumentoCaptionLbl)
                    {
                    }
                    column(Imp__internosCaption; Imp__internosCaptionLbl)
                    {
                    }
                    column(Ingresos_BrutosCaption; Ingresos_BrutosCaptionLbl)
                    {
                    }
                    column(IVA_Percep_Caption; IVA_Percep_CaptionLbl)
                    {
                    }
                    column(No_Grav____ExentoCaption; No_Grav____ExentoCaptionLbl)
                    {
                    }
                    column(Ganan_Caption; Ganan_CaptionLbl)
                    {
                    }
                    column(Impuesto_IVACaption_Control1102201001; Impuesto_IVACaption_Control1102201001Lbl)
                    {
                    }
                    column(Impuesto_IVACaption_Control1102201005; Impuesto_IVACaption_Control1102201005Lbl)
                    {
                    }
                    column(Impuesto_IVACaption_Control1102201005_1; Impuesto_IVACaption_Control1102201005_1Lbl)
                    {
                    }
                    column(Total_FacturaCaption; Total_FacturaCaptionLbl)
                    {
                    }
                    column(DatosTemporal_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        recTempDatos.reset();
                        if Number = 1 then
                            recTempDatos.FindFirst
                        else
                            recTempDatos.Next;
                    end;

                    trigger OnPreDataItem()
                    begin
                        recTempDatos.Reset;
                        recTempDatos.setfilter("GMAInvoiceType", '=%1|=%2', recTempDatos.GMAInvoiceType::"GMANota Debito", recTempDatos.GMAInvoiceType::Invoice);
                        if not recTempDatos.FindFirst then begin
                            keyTempDatos += 1;
                            recTempDatos.Init;
                            recTempDatos.GMAKey := keyTempDatos;
                            recTempDatos.GMAtipodocumento := FORMAT(recTempDatos.GMAInvoiceType);
                            recTempDatos.Insert;
                        end;

                        recTempDatos.Reset;
                        SetRange(Number, 1, recTempDatos.Count);
                    end;
                }
                dataitem(Totales; "Integer")
                {
                    DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
                    column(ReportForNavId_3788; 3788)
                    {
                    }
                    column(GTotalBaseGravado; GTotalBaseGravado)
                    {
                    }
                    column(GTdecIVA105_GTdecIVA21_GTdecIVA27; GTdecIVA105 + GTdecIVA21 + GTdecIVA27 + GTdecIVA25)
                    {
                    }
                    column(GTotalIPer; GTotalIPer)
                    {
                    }
                    column(GTotalIIB; GTotalIIB)
                    {
                    }
                    column(GTotalIOP; GTotalIOP)
                    {
                    }
                    column(GTotalFactura; GTotalFactura)
                    {
                    }
                    column(V0; 0)
                    {
                    }
                    column(GTotalBaseNoGravado; GTotalBaseNoGravado)
                    {
                    }
                    column(GTotalBaseExcento; GTotalBaseExcento)
                    {
                    }
                    column(GTotalIGA; GTotalIGA)
                    {
                    }
                    column(GTdecIVA105; GTdecIVA105 - GTdecIVA105C)
                    {
                    }
                    column(GTdecIVA21; GTdecIVA21 - GTdecIVA21C)
                    {
                    }
                    column(GTdecIVA27; GTdecIVA27 - GTdecIVA27C)
                    {
                    }
                    column(GTdecIVA25; GTdecIVA25 - GTdecIVA25C)
                    {
                    }
                    column(GTotalBaseGravadoC; GTotalBaseGravadoC)
                    {
                    }
                    column(GTdecIVA105_GTdecIVA21_GTdecIVA27C; (GTdecIVA105C + GTdecIVA21C + GTdecIVA27C + GTdecIVA25C))
                    {
                    }
                    column(GTotalIPerC; GTotalIPerC)
                    {
                    }
                    column(GTotalIIBC; GTotalIIBC)
                    {
                    }
                    column(GTotalBaseNoGravadoC; GTotalBaseNoGravadoC)
                    {
                    }
                    column(GTotalBaseExcentoC; GTotalBaseExcentoC)
                    {
                    }
                    column(GTotalIOPC; GTotalIOPC)
                    {
                    }
                    column(GTotalIGAC; GTotalIGAC)
                    {
                    }
                    column(GTotalFacturaC; GTotalFacturaC)
                    {
                    }
                    column(GTdecIVA21_Control1000000124; GTdecIVA21)
                    {
                    }
                    column(GTdecIVA105_Control1000000125; GTdecIVA105)
                    {
                    }
                    column(GTdecIVA27_Control1000000126; GTdecIVA27)
                    {
                    }
                    column(GTdecIVA105C; GTdecIVA105C)
                    {
                    }
                    column(GTdecIVA21C; GTdecIVA21C)
                    {
                    }
                    column(GTdecIVA27C; GTdecIVA27C)
                    {
                    }
                    column(GTdecIVA27C_1; GTdecIVA25C)
                    {
                    }

                    column(Total_Compras_Base_GravadasCaption; Total_Compras_Base_GravadasCaptionLbl)
                    {
                    }
                    column(Total_IVA_ComprasCaption; Total_IVA_ComprasCaptionLbl)
                    {
                    }
                    column("Total_IVA_Percepción_ComprasCaption"; Total_IVA_Percepción_ComprasCaptionLbl)
                    {
                    }
                    column("Total_Percepción_Ingresos_BrutosCaption"; Total_Percepción_Ingresos_BrutosCaptionLbl)
                    {
                    }
                    column(Total_Impuestos_InternosCaption; Total_Impuestos_InternosCaptionLbl)
                    {
                    }
                    column(Total_Compras_con_ImpuestosCaption; Total_Compras_con_ImpuestosCaptionLbl)
                    {
                    }
                    column(Diferencia_RedondeoCaption; Diferencia_RedondeoCaptionLbl)
                    {
                    }
                    column(TotalsCaption; TotalsCaptionLbl)
                    {
                    }
                    column(Total_Compras_Base_No_GravadasCaption; Total_Compras_Base_No_GravadasCaptionLbl)
                    {
                    }
                    column(Total_Compras_Base_ExentasCaption; Total_Compras_Base_ExentasCaptionLbl)
                    {
                    }
                    column(Total_GananciasCaption; Total_GananciasCaptionLbl)
                    {
                    }
                    column(No_Caption_Control1102201055; No_Caption_Control1102201055Lbl)
                    {
                    }
                    column(Impuesto_IVACaption_Control1102201057; Impuesto_IVACaption_Control1102201057Lbl)
                    {
                    }
                    column(Impuesto_IVACaption_Control1102201058; Impuesto_IVACaption_Control1102201058Lbl)
                    {
                    }
                    column(Impuesto_IVACaption_Control1102201064; Impuesto_IVACaption_Control1102201064Lbl)
                    {
                    }
                    column(Total_Compras_Base_GravadasCaptionC; Total_Compras_Base_GravadasCaptionCLbl)
                    {
                    }
                    column(Total_Compras_Base_No_GravadasCaptionC; Total_Compras_Base_No_GravadasCaptionCLbl)
                    {
                    }
                    column(Total_Compras_Base_ExentasCaptionC; Total_Compras_Base_ExentasCaptionCLbl)
                    {
                    }
                    column(Total_IVA_ComprasCaptionC; Total_IVA_ComprasCaptionCLbl)
                    {
                    }
                    column("Total_IVA_Percepción_ComprasCaptionC"; Total_IVA_Percepción_ComprasCaptionCLbl)
                    {
                    }
                    column("Total_Percepción_Ingresos_BrutosCaptionC"; Total_Percepción_Ingresos_BrutosCaptionCLbl)
                    {
                    }
                    column(Total_Impuestos_InternosCaptionC; Total_Impuestos_InternosCaptionCLbl)
                    {
                    }
                    column(Total_GananciasCaptionC; Total_GananciasCaptionCLbl)
                    {
                    }
                    column(Diferencia_RedondeoCaptionC; Diferencia_RedondeoCaptionCLbl)
                    {
                    }
                    column(Total_Compras_con_ImpuestosCaptionC; Total_Compras_con_ImpuestosCaptionCLbl)
                    {
                    }
                    column(Impuesto_IVACaption_Control1102201064_1; Impuesto_IVACaption_Control1102201064_1Lbl)
                    {
                    }
                    column(Totales_Number; Number)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        GTotalDifRed := -(ROUND(GTotalBaseTotal, 0.01) + ROUND(GTotalIIVA, 0.01) + ROUND(GTotalIPer, 0.01) +
                                          ROUND(GTotalIIB, 0.01) + ROUND(GTotalIOP, 0.01) - ROUND(GTotalFactura, 0.01));
                    end;
                }
                dataitem(IVAS; "Integer")
                {
                    DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1 .. 10));


                    trigger OnAfterGetRecord()
                    begin
                        if Number > Alicant then
                            CurrReport.Break;

                        IVA := Format(Alic[IVAS.Number, 1], 0, '<Precision,2:2><Standard Format,1>') + '%';
                        Decimal += Alic[IVAS.Number, 2];
                    end;
                }

                trigger OnPreDataItem()
                begin
                    Empresa.Reset();
                    Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    Empresa.SetFilter(Code, DimensionValue.Code);
                    IF (Empresa.FindFirst()) THEN;
                    //CurrReport.CreateTotals(decIVA105,decIVA21,decIVA27);

                    // Calcula la Cantidad de Alicuotas de IVA y las almacena en Alic[x] la Alic[1,1] siempre es cero
                    Jurisdiccion.Reset;
                    Jurisdiccion.SetCurrentkey(Code);
                    Jurisdiccion.SetRange(Jurisdiccion."GMAType of Tax", 0);
                    Alicant := 1;   // La primera siempre es CERO
                    if Jurisdiccion.FindFirst then
                        repeat
                            Detalleimpuesto.Reset;
                            Detalleimpuesto.SetCurrentkey("Tax Jurisdiction Code", "Tax Group Code", "Tax Type", "Effective Date");
                            Detalleimpuesto.SetRange(Detalleimpuesto."Tax Jurisdiction Code", Jurisdiccion.Code);
                            if Detalleimpuesto.FindSet then
                                repeat
                                    if Detalleimpuesto."Tax Below Maximum" <> 0 then begin
                                        Entero := 1;
                                        for I := 1 to Alicant do
                                            if Alic[I, 1] = Detalleimpuesto."Tax Below Maximum" then
                                                Entero := 0;
                                        if Entero = 1 then begin   //Encontro nueva alícuota de IVA
                                            if Alicant = 10 then begin
                                                Message(TEXT0001);
                                                CurrReport.Quit;
                                            end;
                                            Alicant += 1;
                                            Alic[Alicant, 1] := Detalleimpuesto."Tax Below Maximum";
                                        end;
                                    end;
                                until Detalleimpuesto.Next = 0;
                        until Jurisdiccion.Next = 0;

                    // Ordena las alícuotas de IVA de menor a mayor
                    for I := 1 to Alicant - 1 do begin
                        for Entero := I + 1 to Alicant do begin
                            if Alic[I, 1] > Alic[Entero, 1] then begin
                                Decimal := Alic[I, 1];
                                Alic[I, 1] := Alic[Entero, 1];
                                Alic[Entero, 1] := Decimal;
                            end;
                        end;
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                SetFilter(Code, BssiDimensionForRestriction);
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
                    field(Desde; Desde)
                    {
                        ApplicationArea = Basic;
                        Caption = 'From';
                    }
                    field(Hasta; Hasta)
                    {
                        ApplicationArea = Basic;
                        Caption = 'To';
                    }
                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        Importance = Additional;
                        ToolTip = 'Specifies the entity range for which to restrict the suggested vendor payment information.';
                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;

                        trigger OnValidate()
                        var
                            BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        var
            Bssi_Handled: Boolean;
        begin
            BssiMEMReportEvents.Bssi_RegKeyValidationCoreCUEvents(Bssi_Handled);
            if Bssi_Handled then
                Error('');

            if BssiDimension <> '' then
                BssiDimensionForRestriction := BssiDimension
            else
                BssiDimensionForRestriction := BssiMEMSecurityHelper.Bssi_tGetUserSecurityFilterText();
        end;
    }

    labels
    {
    }

    var
        Empresa: Record "Dimension Value";
        Folio: Integer;
        Desde: Date;
        Hasta: Date;
        Tipo: Text[12];
        Lineas: Record "Purch. Inv. Line";
        //1LineasCredito: Record "Sales Cr.Memo Line";
        LineasCredito: Record "Purch. Cr. Memo Line";
        Impuestos: Record "VAT Entry";
        Taxarea: Record "Tax Area";
        Tipofiscal: Record "GMAFiscal Type";

        TaxGroup: Record "Tax Group";
        Detalleimpuesto: Record "Tax Detail";
        Tipocambio: Decimal;
        Alicuota: Integer;
        Decimal: Decimal;
        Entero: Integer;
        BaseGravado: Decimal;
        BaseNoGravado: Decimal;
        BaseExcento: Decimal;
        BaseTotal: Decimal;
        IVA: Text[7];
        IIVA: Decimal;
        IPer: Decimal;
        IIB: Decimal;
        IOP: Decimal;
        IGA: Decimal;
        TotalFactura: Decimal;
        SumaBG: Decimal;
        SumaBNG: Decimal;
        SumaBE: Decimal;
        SumaIIVA: Decimal;
        SumaIPer: Decimal;
        SumaIIB: Decimal;
        SumaIOP: Decimal;
        SumaIGA: Decimal;
        DifRed: Decimal;
        GTotalFactura: Decimal;
        GTotalBaseGravado: Decimal;
        GTotalBaseNoGravado: Decimal;
        GTotalBaseExcento: Decimal;
        GTotalBaseTotal: Decimal;
        GTotalIIVA: Decimal;
        GTotalIPer: Decimal;
        GTotalIIB: Decimal;
        GTotalIOP: Decimal;
        GTotalIGA: Decimal;
        GTotalDifRed: Decimal;
        Alic: array[10, 2] of Decimal;
        Jurisdiccion: Record "Tax Jurisdiction";
        Alicant: Integer;
        Text53801: label 'Exportando datos a MS Office Excel.\@1@@@@@@@@@@@@';
        TEXT0001: label 'Hay mas de 10 Alícotas de IVA';
        I: Integer;
        IvasFactura: array[10] of Decimal;
        Flag: Integer;
        cod: Code[10];
        TipoIVAcero: Text[30];
        decIVA105: Decimal;
        decIVA21: Decimal;
        decIVA25: Decimal;
        decIVA27: Decimal;
        strTF: Text[30];
        strTD: Text[30];
        GTdecIVA105: Decimal;
        GTdecIVA21: Decimal;
        GTdecIVA25: Decimal;
        GTdecIVA27: Decimal;

        jDesAfipTipo: Text[50];

        Desde2: Date;
        GRUPOREGIVAPROD: Record "VAT Product Posting Group";
        VATBUSPOSTINGGROUP: record "VAT Business Posting Group";
        GTotalFacturaC: Decimal;
        GTotalBaseGravadoC: Decimal;
        GTotalBaseNoGravadoC: Decimal;
        GTotalBaseExcentoC: Decimal;
        GTdecIVA105C: Decimal;
        GTdecIVA21C: Decimal;
        GTdecIVA25C: Decimal;
        GTdecIVA27C: Decimal;
        GTotalIIVAC: Decimal;
        GTotalIPerC: Decimal;
        GTotalIIBC: Decimal;
        GTotalIOPC: Decimal;
        GTotalIGAC: Decimal;
        GTotalBaseTotalC: Decimal;
        t: Decimal;
        recTipoFiscal: Record "GMAFiscal Type";
        recTaxJurisdiction: Record "Tax Jurisdiction";
        recTempDatos: Record GMAVatBookTmp temporary;
        keyTempDatos: Integer;
        Folio_CaptionLbl: label 'Folio:';
        LIBRO_IVA_COMPRASCaptionLbl: label 'LIBRO IVA COMPRAS';
        CUIT_CaptionLbl: label 'CUIT:';
        "Período_CaptionLbl": label 'Período:';
        FromCaptionLbl: label 'From';
        ToCaptionLbl: label 'To';
        Fecha_Reg_CaptionLbl: label 'Fecha Reg.';
        N___InternoCaptionLbl: label 'Nº. Interno';
        Impuesto_IVACaptionLbl: label 'IVA 10,5';
        Base_GravadoCaptionLbl: label 'Base Gravado';
        Doc_TypeCaptionLbl: label 'Doc Type';
        CUITCaptionLbl: label 'CUIT';
        "Razón_SocialCaptionLbl": label 'Razón Social';
        Doc__Nr_CaptionLbl: label 'Doc. Nr.';
        Fecha_Doc_CaptionLbl: label 'Fecha Doc.';
        Tipo_FiscalCaptionLbl: label 'Tipo Fiscal';
        Tipo_DocumentoCaptionLbl: label 'Tipo Documento';
        Imp__internosCaptionLbl: label 'Imp. internos';
        Ingresos_BrutosCaptionLbl: label 'Ingresos Brutos';
        IVA_Percep_CaptionLbl: label 'IVA Percep.';
        No_Grav____ExentoCaptionLbl: label 'No Grav. / Exento';
        Ganan_CaptionLbl: label 'Ganan.';
        Impuesto_IVACaption_Control1102201001Lbl: label 'IVA 21';
        Impuesto_IVACaption_Control1102201005Lbl: label 'IVA 27';
        Impuesto_IVACaption_Control1102201005_1Lbl: label 'IVA Adic'; // Cesar
        Total_FacturaCaptionLbl: label 'Total Factura';
        Total_Compras_Base_GravadasCaptionLbl: label 'Total Compras Base Gravadas';
        Total_IVA_ComprasCaptionLbl: label 'Total IVA Compras';
        "Total_IVA_Percepción_ComprasCaptionLbl": label 'Total IVA Percepción Compras';
        "Total_Percepción_Ingresos_BrutosCaptionLbl": label 'Total Percepción Ingresos Brutos';
        Total_Impuestos_InternosCaptionLbl: label 'Total Impuestos Internos';
        Total_Compras_con_ImpuestosCaptionLbl: label 'Total Compras con Impuestos';
        Diferencia_RedondeoCaptionLbl: label 'Diferencia Redondeo';
        TotalsCaptionLbl: label 'Totals';
        Total_Compras_Base_No_GravadasCaptionLbl: label 'Total Compras Base No Gravadas';
        Total_Compras_Base_ExentasCaptionLbl: label 'Total Compras Base Exentas';
        Total_GananciasCaptionLbl: label 'Total Ganancias';
        No_Caption_Control1102201055Lbl: label 'No.';
        Impuesto_IVACaption_Control1102201057Lbl: label 'IVA 10,5';
        Impuesto_IVACaption_Control1102201058Lbl: label 'IVA 21';
        Impuesto_IVACaption_Control1102201064Lbl: label 'IVA 27';
        Total_Compras_Base_GravadasCaptionCLbl: label 'Total Compras Base Gravadas';
        Total_Compras_Base_No_GravadasCaptionCLbl: label 'Total Compras Base No Gravadas';
        Total_Compras_Base_ExentasCaptionCLbl: label 'Total Compras Base Exentas';
        Total_IVA_ComprasCaptionCLbl: label 'Total IVA Compras';
        "Total_IVA_Percepción_ComprasCaptionCLbl": label 'Total IVA Percepción Compras';
        "Total_Percepción_Ingresos_BrutosCaptionCLbl": label 'Total Percepción Ingresos Brutos';
        Total_Impuestos_InternosCaptionCLbl: label 'Total Impuestos Internos';
        Total_GananciasCaptionCLbl: label 'Total Ganancias';
        Diferencia_RedondeoCaptionCLbl: label 'Diferencia Redondeo';
        Total_Compras_con_ImpuestosCaptionCLbl: label 'Total Compras con Impuestos';
        Impuesto_IVACaption_Control1102201064_1Lbl: label 'IVA Adic';  // Cesar

        Argentina: codeunit GMAArgentina2;
        EsProveedorGenerico: Boolean;
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
        Bssi_Handled: Boolean;
        BssiDimension, BssiDimensionForRestriction : Text;
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        BssiMEMReportEvents: Codeunit BssiReportEvents;
        BssiPrint: Boolean;
        FacturaVisibilidad: Boolean;

    procedure alicuotaiva(grupo: Code[10]) valor: Decimal
    begin
        // Calcula la alícuota de IVA del Grupo
        valor := 0;
        Detalleimpuesto.Reset;
        Detalleimpuesto.SetCurrentkey("Tax Jurisdiction Code", "Tax Group Code", "Tax Type", "Effective Date");
        Detalleimpuesto.SetRange(Detalleimpuesto."Tax Group Code", grupo);
        if Detalleimpuesto.FindSet then
            repeat
                Jurisdiccion.Get(Detalleimpuesto."Tax Jurisdiction Code");
                if (Jurisdiccion."GMAType of Tax" = Jurisdiccion."GMAType of Tax"::IVA) and (valor = 0) then
                    valor := Detalleimpuesto."Tax Below Maximum";
            until Detalleimpuesto.Next = 0;
    end;


    procedure numeroiva(valor: Decimal) numero: Integer
    begin
        for I := 1 to Alicant do
            if Alic[I, 1] = valor then
                numero := I;
    end;


    procedure tratarivacero(grupo: Code[10]; numdoc: Code[20]) SINO: Boolean
    begin
        SINO := false;
        Impuestos.Reset;
        Impuestos.SetCurrentkey("Entry No.");
        Impuestos.SetRange(Impuestos."Document No.", numdoc);
        Impuestos.SetRange(Impuestos."Tax Group Code", grupo);
        Impuestos.SetRange(Impuestos."GMATax Type Loc", 0);
        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            Impuestos.SetRange("Bssi Shortcut Dimension 1 Code", DimensionValue.Code)
        else
            Impuestos.SetRange("Bssi Shortcut Dimension 2 Code", DimensionValue.Code);
        Decimal := 0;
        if Impuestos.FindSet then
            repeat
                Decimal += Impuestos.Amount;
            until Impuestos.Next = 0;

        if Decimal = 0 then
            SINO := true;
    end;

    procedure calculoImpuestosCreditMemo(DocNo: code[20])
    var

    begin

        // Calculo los impuestos
        Impuestos.Reset;
        Impuestos.SetCurrentkey("Entry No.");
        Impuestos.SetFilter(Impuestos."Document Type", '%1', Impuestos."document type"::"Credit Memo");
        Impuestos.SetRange(Impuestos."Document No.", DocNo);
        impuestos.setrange(type, impuestos.type::Purchase);
        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            Impuestos.SetRange("Bssi Shortcut Dimension 1 Code", DimensionValue.Code)
        else
            Impuestos.SetRange("Bssi Shortcut Dimension 2 Code", DimensionValue.Code);
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
                                            decIVA21 += Impuestos.Amount;

                                        recTaxJurisdiction.GMATipo::"IVA2.5":
                                            decIVA25 += Impuestos.Amount;

                                        recTaxJurisdiction.GMATipo::"IVA10.5":
                                            decIVA105 += Impuestos.Amount;

                                        recTaxJurisdiction.GMATipo::IVA27:
                                            decIVA27 += Impuestos.Amount;


                                        recTaxJurisdiction.GMATipo::" ":
                                            begin
                                                GRUPOREGIVAPROD.Reset;
                                                GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                                                if GRUPOREGIVAPROD.FindFirst then begin
                                                    case GRUPOREGIVAPROD."GMATax Type" of
                                                        0:
                                                            begin
                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '5') then
                                                                    decIVA21 += Impuestos.Amount;

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '9') then
                                                                    decIVA25 += Impuestos.Amount;

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') then
                                                                    decIVA105 += Impuestos.Amount;

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then
                                                                    decIVA27 += Impuestos.Amount;
                                                            end;

                                                        1:
                                                            IPer += Impuestos.Amount;
                                                        2:
                                                            IIB += Impuestos.Amount;
                                                        3:

                                                            IOP += Impuestos.Amount;
                                                    end;
                                                end;
                                            end;
                                    end;
                            end;

                        1:
                            IPer += Impuestos.Amount;
                        2:
                            IIB += Impuestos.Amount;
                        3:
                            IOP += Impuestos.Amount

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
                                        decIVA21 += Impuestos.Amount;

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '9') then
                                        decIVA25 += Impuestos.Amount;

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') then
                                        decIVA105 += Impuestos.Amount;

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then
                                        decIVA27 += Impuestos.Amount;
                                end;
                            1:
                                IPer += Impuestos.Amount;
                            2:
                                IIB += Impuestos.Amount;
                            3:

                                IOP += Impuestos.Amount;
                        end;
                    end;
                end;
            until Impuestos.Next = 0;
    end;

    procedure calculoImpuestosInvoice(DocNo: code[20])
    var

    begin

        // Calculo los impuestos
        Impuestos.Reset;
        Impuestos.SetCurrentkey("Entry No.");
        Impuestos.SetFilter(Impuestos."Document Type", '%1', Impuestos."document type"::Invoice);
        Impuestos.SetRange(Impuestos."Document No.", DocNo);
        impuestos.setrange(type, impuestos.type::Purchase);
        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            Impuestos.SetRange("Bssi Shortcut Dimension 1 Code", DimensionValue.Code)
        else
            Impuestos.SetRange("Bssi Shortcut Dimension 2 Code", DimensionValue.Code);
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
                                            decIVA21 += Impuestos.Amount;

                                        recTaxJurisdiction.GMATipo::"IVA2.5":
                                            decIVA25 += Impuestos.Amount;

                                        recTaxJurisdiction.GMATipo::"IVA10.5":
                                            decIVA105 += Impuestos.Amount;

                                        recTaxJurisdiction.GMATipo::IVA27:
                                            decIVA27 += Impuestos.Amount;


                                        recTaxJurisdiction.GMATipo::" ":
                                            begin
                                                GRUPOREGIVAPROD.Reset;
                                                GRUPOREGIVAPROD.SetRange(GRUPOREGIVAPROD.Code, Impuestos."VAT Prod. Posting Group");
                                                if GRUPOREGIVAPROD.FindFirst then begin
                                                    case GRUPOREGIVAPROD."GMATax Type" of
                                                        0:
                                                            begin
                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '5') then
                                                                    decIVA21 += Impuestos.Amount;

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '9') then
                                                                    decIVA25 += Impuestos.Amount;

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') then
                                                                    decIVA105 += Impuestos.Amount;

                                                                if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then
                                                                    decIVA27 += Impuestos.Amount;
                                                            end;

                                                        1:
                                                            IPer += Impuestos.Amount;
                                                        2:
                                                            IIB += Impuestos.Amount;
                                                        3:

                                                            IOP += Impuestos.Amount;
                                                    end;
                                                end;
                                            end;
                                    end;
                            end;

                        1:
                            IPer += Impuestos.Amount;
                        2:
                            IIB += Impuestos.Amount;
                        3:
                            IOP += Impuestos.Amount

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
                                        decIVA21 += Impuestos.Amount;

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '9') then
                                        decIVA25 += Impuestos.Amount;

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '4') then
                                        decIVA105 += Impuestos.Amount;

                                    if (GRUPOREGIVAPROD."GMAAFIP VAT Type Code" = '6') then
                                        decIVA27 += Impuestos.Amount;
                                end;
                            1:
                                IPer += Impuestos.Amount;
                            2:
                                IIB += Impuestos.Amount;
                            3:

                                IOP += Impuestos.Amount;
                        end;
                    end;
                end;
            until Impuestos.Next = 0;
    end;
}


