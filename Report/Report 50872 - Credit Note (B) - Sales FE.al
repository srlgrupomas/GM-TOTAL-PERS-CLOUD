report 34006872 "PersCredit Note (B) - Sales "
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107872 - Credit Note (B) FE.rdl';
    EnableHyperlinks = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(Sales_Invoice_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                PrintOnlyIfDetail = false;
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = FILTER(3));
                    column(FormaPago_Description; FormaPago.Description)
                    {
                    }
                    column(TipoPago; TipoPago)
                    {
                    }
                    column(Sales_Invoice_Header___VAT_Registration_No__; "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(TipoFisca_Description; TipoFisca.GMADescription)
                    {
                    }
                    column(Sales_Invoice_Header___Bill_to_Name_; "Sales Invoice Header"."Bill-to Name")
                    {
                    }
                    column(Sales_Invoice_Header___Bill_to_Address_________Sales_Invoice_Header___Bill_to_City_; "Sales Invoice Header"."Bill-to Address" + ' - ' + "Sales Invoice Header"."Bill-to City")
                    {
                    }
                    column(Sales_Invoice_Header___Sell_to_Post_Code_; "Sales Invoice Header"."Sell-to Post Code")
                    {
                    }
                    column(Sales_Invoice_Header___Posting_Date_; "Sales Invoice Header"."Posting Date")
                    {
                    }
                    column(CopiaLetra; TipoDocumento)
                    {
                    }
                    column(DocNUMAF; DocNUMAF)
                    {
                    }
                    column(InfoEmpresa__Phone_No__; InfoEmpresa.BssiBillingPhoneNumber)
                    {
                    }
                    column(InfoEmpresa__N__ingresos_brutos_; InfoEmpresa.BssiGrossIncomeNo)
                    {
                    }
                    column(InfoEmpresa_Name; InfoEmpresa.BssiLegalNameFull)
                    {
                    }
                    column(recTipoFisca_Description; recTipoFisca.GMADescription)
                    {
                    }
                    column(Sales_Invoice_Header___No__; "Sales Invoice Header"."No.")
                    {
                    }
                    column(InfoEmpresa_Picture; InfoEmpresa.BssiPicture)
                    {
                    }
                    column(CUIT_______FORMAT_InfoEmpresa__VAT_Registration_No___; FORMAT(InfoEmpresa.BssiTaxRegistrationNumber))
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___Bill_to_Customer_No__; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___External_Document_No__; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(gTel; gTel)
                    {
                    }
                    column(gInicio; gInicio)
                    {
                    }
                    column(InfoEmpresa_Address; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa.BssiBillingZipCode + ', ' + InfoEmpresa.BssiBillingCountry + ', ' + RecPais.Name)
                    {
                    }
                    column(gProvincia______InfoEmpresa__Country_Region_Code_; gProvincia + ', ' + InfoEmpresa.BssiProvinceCode)
                    {
                    }
                    column(gNomVend; gNomVend)
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___Payment_Terms_Code_; "Sales Invoice Header"."Payment Terms Code")
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___Payment_Method_Code_; "Sales Invoice Header"."Payment Method Code")
                    {
                    }
                    column(CodAlbaran; CodAlbaran)
                    {
                    }
                    column(Tex; Tex)
                    {
                    }
                    column(NoOfLoops; OutputNo)
                    {
                    }
                    column(CP_Caption; CP_CaptionLbl)
                    {
                    }
                    column(Fecha_Caption; Fecha_CaptionLbl)
                    {
                    }
                    column(Ingresos_Brutos_C_M__Caption; Ingresos_Brutos_C_M__CaptionLbl)
                    {
                    }
                    column(Tel_Caption; Tel_CaptionLbl)
                    {
                    }
                    column(Precio_UnitarioCaption; Precio_UnitarioCaptionLbl)
                    {
                    }
                    column(Precio_TotalCaption; Precio_TotalCaptionLbl)
                    {
                    }
                    column("DescripciónCaption"; DescripciónCaptionLbl)
                    {
                    }
                    column(CantidadCaption; CantidadCaptionLbl)
                    {
                    }
                    column(Nombre_Caption; Nombre_CaptionLbl)
                    {
                    }
                    column(Nro_Caption; Nro_CaptionLbl)
                    {
                    }
                    column(CodigoCaption; CodigoCaptionLbl)
                    {
                    }
                    column(DespachoCaption; DespachoCaptionLbl)
                    {
                    }
                    column(Bon__1Caption; Bon__1CaptionLbl)
                    {
                    }
                    column(Orden_de_Compra_Caption; Orden_de_Compra_CaptionLbl)
                    {
                    }
                    column(BCaption; BCaptionLbl)
                    {
                    }
                    column(Codigo_006Caption; Codigo_006CaptionLbl)
                    {
                    }
                    column(Inicio_de_ActividadesCaption; Inicio_de_ActividadesCaptionLbl)
                    {
                    }
                    column(Cond__de_ventaCaption; Cond__de_ventaCaptionLbl)
                    {
                    }
                    column(VendedorCaption; VendedorCaptionLbl)
                    {
                    }
                    column(Bank__TransferCaption; Bank__TransferCaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(ShiptoAddress; "Sales Invoice Header"."Ship-to Address")
                    {
                    }
                    column(ShiptoAddress2; "Sales Invoice Header"."Ship-to Address 2")
                    {
                    }
                    column(ShiptoCity; "Sales Invoice Header"."Ship-to City")
                    {
                    }
                    column(GMAProvince; "Sales Invoice Header".GMAProvince)
                    {
                    }
                    column(CompanyCBU; CompanyCBU)
                    {
                    }
                    column(CompanyAlias; CompanyAlias)
                    {
                    }
                    //SL Begin Bug1564
                    column(InicioActividades; "InfoEmpresa".BssiActivityStratDate)
                    {
                    }
                    //SL End
                    // AW - BEGIN TFS 1894
                    column(Sales_Invoice_Header_InvDiscountAmount; "Sales Invoice Header"."Invoice Discount Amount")
                    { }
                    column(SalesCurrencyCode; "Sales Invoice Header"."Currency Code")
                    { }
                    column(leyenda2; leyenda2)
                    {
                    }
                    // AW - END 
                    dataitem("Sales Invoice Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
                        column(Sales_Invoice_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Invoice_Line__No__; NoArticulo)
                        {
                        }
                        column(Sales_Invoice_Line_Description; Description)
                        {
                        }
                        column(Sales_Invoice_Line__Unit_Price_; gPrecioIva)
                        {
                        }
                        column(Sales_Invoice_Line_Amount; gPrecioIvaIncl)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Line_Discount___; "Sales Invoice Line"."Line Discount %")
                        {
                        }
                        column(Despacho; Despacho)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Line_No__; "Sales Invoice Line"."Line No.")
                        {
                        }
                        column(Sales_Invoice_Header___Amount_Including_VAT_; "Sales Invoice Header"."Amount Including VAT")
                        {
                        }
                        column(ImporteLetras; ImporteLetras)
                        {
                        }
                        column(Sales_Invoice_Header___No___Control1000000022; "Sales Invoice Header"."No.")
                        {
                        }
                        column(barra; barra)
                        {
                        }
                        column(barra_Control1100240009; barra)
                        {
                        }
                        column(barra_Control1100240010; barra)
                        {
                        }
                        column(Barra2; Barra2)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Tax_Group_Code_; "Sales Invoice Line"."Tax Group Code")
                        {
                        }
                        column(leyenda; leyenda)
                        {
                        }
                        column(Sales_Invoice_Header__FechaVtoCAI; "Sales Invoice Header"."GMACAI Due Date2")
                        {
                        }
                        column(Sales_Invoice_Header__CAI; "Sales Invoice Header".GMACAI2)
                        {
                        }
                        column(gTotNetoT; gTotPrecioIvaIncl)
                        {
                        }
                        column(gDescuento1; gDescuento)
                        {
                        }
                        column(Sales_Invoice_Header__Amount_Control1102201063; "Sales Invoice Header"."Amount Including VAT")
                        {
                        }
                        column(Sales_Invoice_Header__Amount; "Sales Invoice Header"."Amount Including VAT")
                        {
                        }
                        column(Sales_Invoice_Header___Due_Date_; "Sales Invoice Header"."Due Date")
                        {
                        }
                        column(TOTALCaption; TOTALCaptionLbl)
                        {
                        }
                        column(C_A_E_Caption; C_A_E_CaptionLbl)
                        {
                        }
                        column(Vto__Caption; Vto__CaptionLbl)
                        {
                        }
                        column(Sub_TotalCaption; Sub_TotalCaptionLbl)
                        {
                        }
                        column(DescuentoCaption; DescuentoCaptionLbl)
                        {
                        }
                        column(PorcentajeIVA; PorcentajeIVA)
                        {
                        }
                        column(Total_NetoCaption; Total_NetoCaptionLbl)
                        {
                        }
                        column(Sales_Invoice_Line_Document_No_; "Document No.")
                        {
                        }
                        // AW - BEGIN TFS 1894
                        column(Sales_Invoice_Line_LineDiscountAmount; "Sales Invoice Line"."Line Discount Amount")
                        { }
                        // AW - END

                        column(QRCode; "Sales Invoice Header"."GMA QRCode")
                        {
                        }
                        column(AgruparUnaLinea; AgruparUnaLinea)
                        {
                        }

                        column(ShowAllLine; ShowAllLine)
                        {
                        }
                        column(Sales_Invoice_Linea_Print; "Sales Invoice Line".GMAPrint)
                        { }
                        column(Sales_Invoice_Linea_Lote; NumeroLote)
                        { }
                        column(tituloLote; tituloLote)
                        { }
                        column(simboloMoneda; simboloMoneda)
                        { }
                        dataitem("Item Ledger Entry"; "Item Ledger Entry")
                        {
                            column(Item_Ledger_Entry__Item_Ledger_Entry___Lot_No__; "Item Ledger Entry"."Lot No.")
                            {
                            }
                            column(Item_Ledger_Entry__Quantity__1; "Item Ledger Entry".Quantity)
                            {
                            }
                            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
                            {
                            }

                            trigger OnAfterGetRecord();
                            begin
                                Quantity := ROUND(Quantity, 0.1, '<') * -1;

                                if (r = 1) then
                                    CurrReport.SKIP;
                            end;

                            trigger OnPreDataItem();
                            begin
                                "Item Ledger Entry".RESET;
                                "Item Ledger Entry".SETCURRENTKEY("Entry No.");
                                "Item Ledger Entry".SETRANGE("Entry Type", RecItemLed."Entry Type"::Sale);
                                "Item Ledger Entry".SETRANGE("Document No.", "Return Receipt Header"."No.");
                                "Item Ledger Entry".SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
                                "Item Ledger Entry".SETRANGE("Item No.", "Sales Invoice Line"."No.");
                                "Item Ledger Entry".SETFILTER("Lot No.", '<>%1', '');
                                if not ("Item Ledger Entry".FINDFIRST) then
                                    CurrReport.SKIP;
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            z += 1;
                            if z mod 20 = 0 then;
                            //CurrReport.NEWPAGE;

                            if "Sales Invoice Line".type = "Sales Invoice Line".type::"G/L Account" then
                                NoArticulo := ''
                            else
                                NoArticulo := "Sales Invoice Line"."No.";
                            gPrecioIva := 0;
                            gDescuento := 0;
                            gTotalNeto := 0;

                            RecItemLed.RESET;
                            RecItemLed.SETCURRENTKEY("Entry No.");
                            RecItemLed.SETRANGE("Entry Type", RecItemLed."Entry Type"::Sale);
                            RecItemLed.SETRANGE("Document No.", "Return Receipt Header"."No.");
                            RecItemLed.SETRANGE("Document Line No.", "Line No.");
                            RecItemLed.SETFILTER("Lot No.", '<>%1', '');
                            RecItemLed.SETRANGE("Item No.", "No.");
                            if RecItemLed.FINDFIRST then
                                repeat
                                    r += 1;
                                until RecItemLed.NEXT = 0;

                            if (r = 1) then
                                Despacho := RecItemLed."Lot No.";

                            RecSLIne.RESET;
                            RecSLIne.SETCURRENTKEY("Document No.", "Line No.");
                            RecSLIne.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                            if RecSLIne.FINDFIRST then
                                repeat
                                    gDescuento := gDescuento + RecSLIne."Inv. Discount Amount";
                                    gTotalNeto := "Sales Invoice Header".Amount + gDescuento;
                                until RecSLIne.NEXT = 0;
                            //fDif := "Sales Invoice Header"."Amount Including VAT" - gTotalNeto;//Saco la diferencia del iva
                            //IF gTotalNeto <> 0 THEN
                            //gPorsIva := (100 * fDif) / gTotalNeto;  //saco el pors. de iva
                            //gPrecioIva := ("Sales Invoice Line"."Unit Price" * gPorsIva) / 100
                            //+ "Sales Invoice Line"."Unit Price";   //calculo el precio con el iva incluido
                            //CalcDes:=("Sales Invoice Line".Quantity * gPrecioIva)*("Line Discount %"/100);
                            //gPrecioIvaIncl := ROUND(("Sales Invoice Line".Quantity * gPrecioIva)-CalcDes,0.001,'<'); // cantidad * precio iva incl
                            if Quantity <> 0 then
                                gPrecioIva := ((("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price") * ("Sales Invoice Line"."VAT %" / 100)) + ("Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price")) / "Sales Invoice Line".Quantity;
                            //gPrecioIva := "Sales Invoice Line"."Amount Including VAT" / Quantity;
                            CalcDes := ("Sales Invoice Line".Quantity * gPrecioIva) * ("Line Discount %" / 100);
                            gPrecioIvaIncl := "Sales Invoice Line"."Amount Including VAT";   //("Sales Invoice Line".Quantity * gPrecioIva);//-CalcDes; // cantidad * precio iva incl 

                            gTotPrecioIvaIncl += gPrecioIvaIncl;

                            gPrecioIva := ROUND(gPrecioIva, 0.00001);
                            "Line Discount %" := ROUND("Line Discount %", 0.001);
                            //----------------------------------------------------------------------------------------------------------------------------------
                            CLEAR(factor);
                            CLEAR(nombreimp[1]);
                            CLEAR(nombreimp[2]);
                            CLEAR(nombreimp[3]);
                            CLEAR(nombreimp[4]);
                            CLEAR(impuesto[1]);
                            CLEAR(impuesto[2]);
                            CLEAR(impuesto[3]);
                            CLEAR(impuesto[4]);
                            CLEAR(barra);
                            CLEAR(Barra2);
                            CLEAR(cadena);
                            CLEAR(Codigo);

                            "Sales Invoice Header".CALCFIELDS(Amount);
                            "Sales Invoice Header".CALCFIELDS("Amount Including VAT");
                            varDec := "Sales Invoice Header"."Amount Including VAT";

                            if "Sales Invoice Header"."Currency Factor" <> 0 then
                                factor := "Sales Invoice Header"."Currency Factor"
                            else
                                factor := 1;

                            i := 0;
                            Totimp := 0;
                            k := i;
                            if i <> 0 then begin
                                repeat
                                    if impuesto[k] < impuesto[i] then
                                        k := i;

                                    Totimp += impuesto[i];
                                    i -= 1;
                                until i = 0;

                                impuesto[k] += ROUND("Sales Invoice Header"."Amount Including VAT") - ROUND("Sales Invoice Header".Amount) - Totimp;
                            end;

                            //Comentado hasta que implementes facturacion electronica-
                            if ("Sales Invoice Header".GMACAI2 <> '') then begin

                                leyenda := '';
                                //        leyenda := 'EFECTIVO vencimiento '+FORMAT("Sales Invoice Header"."Due Date");
                                //--Codifico a Interleaved 2of5
                                barra := CUCBarras.CodigoBarrasNC("Sales Invoice Header");
                                Codigo := barra;
                                Barra2 := Codigo;
                                i := 1;
                                cadena := '(';

                                while i < STRLEN(Codigo) do begin
                                    EVALUATE(Valor, COPYSTR(Codigo, i, 2));
                                    if Valor < 50 then begin
                                        character := Valor + 48;
                                        cadena := cadena + FORMAT(character);
                                    end else begin
                                        character := Valor + 142;
                                        cadena := cadena + FORMAT(character);
                                    end;
                                    i += 2;
                                end;

                                cadena += ')';
                                //cadena:=Convertir.Ansi2Ascii(cadena);
                                barra := cadena;

                                //Comentado hasta que implementes facturacion electronica+

                                case FormaPago.Code of
                                    'CASH':
                                        begin
                                            leyenda := 'EFECTIVO vencimiento ' + FORMAT("Sales Invoice Header"."Due Date");
                                            //--Codifico a Interleaved 2of5
                                            barra := CUCBarras.CodigoBarrasNC("Sales Invoice Header");
                                            Codigo := barra;
                                            Barra2 := Codigo;
                                            i := 1;
                                            cadena := '(';

                                            while i < STRLEN(Codigo) do begin
                                                EVALUATE(Valor, COPYSTR(Codigo, i, 2));
                                                if Valor < 50 then begin
                                                    character := Valor + 48;
                                                    cadena := cadena + FORMAT(character);
                                                end
                                                else begin
                                                    character := Valor + 142;
                                                    cadena := cadena + FORMAT(character);
                                                end;
                                                i += 2;
                                            end;

                                            cadena += ')';
                                            cadena := Convertir.Ansi2Ascii(cadena);
                                            barra := cadena;
                                            //++Interleaved
                                        end; // Fin si forma de pago es en efectivo
                                    '20':
                                        begin
                                        end;
                                    '30':
                                        begin
                                            leyenda := 'LA SIGUIENTE FACTURA SERA DEBITADA DE SU C.B.U. INFORMADO';
                                        end;
                                end; // Fin de case.
                            end;
                            NumeroLote := buscarloteserie("Sales Invoice Line");
                            if "Sales Invoice Header"."Currency Code" <> '' then begin
                                Moneda.GET("Sales Invoice Header"."Currency Code");
                                simboloMoneda := Moneda.Symbol;
                            end;
                        end;

                        trigger OnPreDataItem();
                        begin
                            "Sales Invoice Header".CALCFIELDS(Amount, "Amount Including VAT");
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if Number > 1 then begin
                        CopyText := Text003;

                        OutputNo += 1;
                    end;
                    //CurrReport.PAGENO := 1;
                    Tex := Tex + '*';
                    //gTotNetoT:= 0;
                    //TotalInvoiceDiscountAmount := 0;
                    //TotalAmount := 0;
                    //TotalAmountVAT := 0;
                    //TotalAmountInclVAT := 0;
                    //TotalPaymentDiscountOnVAT := 0;
                end;

                trigger OnPostDataItem();
                begin
                    //IF NOT CurrReport.PREVIEW THEN
                    // SalesInvCountPrinted.RUN("Sales Invoice Header");
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);

                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                tipoDocAFIP: record "GMAAFIP - Voucher Type";
                wsgrupomas: Codeunit GMAws_GrupoMAS_FE;
                EntitySetUpExtend: record EntitySetUpExtend;
            begin
                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Sales Invoice Header"."Shortcut Dimension 1 Code");
                IF (InfoEmpresa.FindFirst()) THEN;
                InfoEmpresa.CalcFields(BssiPicture);

                if "Sales Invoice Header"."GMAAFIP Voucher Type" = '' then
                    "Sales Invoice Header"."GMAAFIP Voucher Type" := '00';

                EntitySetUpExtend.SetFilter("Dimension Code", InfoEmpresa.Code);
                EntitySetUpExtend.FindFirst();
                CompanyCBU := EntitySetUpExtend.CompanyCBU;
                CompanyAlias := EntitySetUpExtend.CompanyAlias;

                RecPais.RESET;
                RecPais.GET(InfoEmpresa.BssiBillingCountry);

                gTotalNeto := 0;
                fDif := 0;
                gPrecioIva := 0;
                gDifIva := 0;
                gDescuento := 0;
                gPrecioIvaIncl := 0;
                gPorsIva := 0;
                gTotPrecioIvaIncl := 0;
                CLEAR(factor);
                CLEAR(nombreimp[1]);
                CLEAR(nombreimp[2]);
                CLEAR(nombreimp[3]);
                CLEAR(nombreimp[4]);
                CLEAR(impuesto[1]);
                CLEAR(impuesto[2]);
                CLEAR(impuesto[3]);
                CLEAR(impuesto[4]);
                CLEAR(barra);
                CLEAR(Barra2);
                CLEAR(cadena);
                CLEAR(Contador);
                CLEAR(TipoDocumento);
                CLEAR(Codigo);

                if ("sales invoice header"."GMAElectronic Invoicing" <> "sales invoice header"."GMAElectronic Invoicing"::NO) and ("sales invoice header"."GMAElectronic Invoicing" <> "sales invoice header"."GMAElectronic Invoicing"::HASAR) then
                    wsgrupomas.FE_GenerarQR("sales invoice header"."No.", 2);
                "sales invoice header".CalcFields("GMA QRCode");
                //IF("Sales Invoice Header"."Tipo Factura" = "Sales Invoice Header"."Tipo Factura"::Factura)THEN
                // TipoDocumento := 'FACTURA'
                //ELSE
                TipoDocumento := 'NOTA DE CREDITO';
                DocNUMAF := '08';
                if "Sales Invoice Header"."GMAAFIP Voucher Type" = '203' then begin
                    TipoDocumento := 'NOTA DE CREDITO PYME ELECTRONICA';
                    DocNUMAF := '208'
                end;

                DocNUMAF := "Sales Invoice Header"."GMAAFIP Voucher Type";
                tipoDocAFIP.reset;
                tipoDocAFIP.SetRange(GMAID, "Sales Invoice Header"."GMAAFIP Voucher Type");
                if tipoDocAFIP.FindFirst() then
                    TipoDocumento := tipoDocAFIP.GMADescription;

                RecProvincia.RESET;
                RecProvincia.SETCURRENTKEY(RecProvincia."GMAProvince Code");
                RecProvincia.SETRANGE("GMAProvince Code", InfoEmpresa.BssiProvinceCode);
                if RecProvincia.FINDFIRST then
                    gProvincia := RecProvincia.GMADescription;


                //"RecSales Shipment Header".RESET;
                //"RecSales Shipment Header".SETCURRENTKEY("Order No.");
                //"RecSales Shipment Header".SETRANGE("Order No.","Sales Invoice Header"."Order No.");
                //IF "RecSales Shipment Header".FINDFIRST THEN;

                //ok:=PaymentTerms.GET("Sales Invoice Header"."Payment Terms Code");
                ok := FormaPago.GET("Sales Invoice Header"."Payment Method Code");
                ok := AreaImp.GET("Sales Invoice Header"."Tax Area Code");
                ok := TipoFisca.GET(AreaImp."GMAFiscal Type");
                "Sales Invoice Header".CALCFIELDS("Amount Including VAT");

                "RecSalesperson/Purchaser".RESET;
                "RecSalesperson/Purchaser".SETCURRENTKEY(Code);
                "RecSalesperson/Purchaser".SETRANGE(Code, "Salesperson Code");
                if "RecSalesperson/Purchaser".FINDFIRST then
                    gNomVend := "RecSalesperson/Purchaser".Name;


                if "Language Code" = 'ENU' then begin
                    Convierto.FormatNoText(NumberText, ROUND("Sales Invoice Header"."Amount Including VAT", 0.01),
                    "Sales Invoice Header"."Currency Code");
                end
                else begin
                    Convierto.FormatNoText(NumberText, ROUND("Sales Invoice Header"."Amount Including VAT", 0.01),
                    '');
                end;

                //Calculo de distintos IVAs
                if "Currency Factor" <> 0 then
                    factor := "Currency Factor"
                else
                    factor := 1;

                if "Sales Invoice Header"."Currency Code" <> '' then begin
                    ok := Moneda.GET("Sales Invoice Header"."Currency Code");
                    if "Sales Invoice Header"."Currency Code" <> '' then begin
                        Moneda.GET("Sales Invoice Header"."Currency Code");
                        simboloMoneda := Moneda.Symbol;
                    end;
                    if ("Currency Factor" <> 0) then
                        leyenda2 := 'TC $ ' + FORMAT(ROUND(1 / "Currency Factor", 0.01, '='));
                    //   leyenda2 := 'Al solo  efecto impositivo el tipo de cambio aplicado es de $ ' + FORMAT(ROUND(1 / "Currency Factor", 0.0001, '=')) +
                    //            'por cada ' + Moneda.Description;

                    ImporteLetras := 'Son ' + Moneda.Description + ': ' + NumberText[1] + NumberText[2] /*+ '  a TC: ' + FORMAT(ROUND(1/factor,0.0001,'='))*/;
                end
                else
                    ImporteLetras := 'Son Pesos: ' + NumberText[1] + NumberText[2];


                //NAVAR1.0600*-
                CLEAR(ImporteBase1);
                tmoviva.RESET;
                tmoviva.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                tmoviva.SETRANGE(Type, tmoviva.Type::Sale);
                tmoviva.SETFILTER("Document Type", '%1|%2', tmoviva."Document Type"::Invoice, tmoviva."GMADocument Type Loc."::"GMANota Debito");
                if tmoviva.FINDFIRST then
                    repeat
                        case tmoviva."GMATax Type Loc" of
                            tmoviva."GMATax Type Loc"::IVA:
                                begin
                                    ImporIVA1 := ImporIVA1 + (tmoviva.Amount * factor * -1);
                                    ImporteBase1 := ImporteBase1 + (tmoviva.Base * factor * -1)
                                end;
                            tmoviva."GMATax Type Loc"::"IVA Percepcion":
                                ImporIVA2 := ImporIVA2 + (tmoviva.Amount * factor * -1);
                            tmoviva."GMATax Type Loc"::"Ingresos Brutos":
                                ImporIVA3 := ImporIVA3 + (tmoviva.Amount * factor * -1);
                            tmoviva."GMATax Type Loc"::Otros:
                                ImporIVA4 := ImporIVA4 + (tmoviva.Amount * factor * -1);
                        end;
                    until tmoviva.NEXT = 0;
                CLEAR(PorcentajeIVA);

                ImporteBase1 := ROUND(ImporteBase1, 0.01);
                if ImporteBase1 <> 0 then
                    PorcentajeIVA := ABS(ROUND((ImporIVA1 / ImporteBase1) * 100, 0.01));


                if (PorcentajeIVA <> 21) and (PorcentajeIVA <> 10.5) then begin
                    PorcentajeIVA := 0;
                end;

                //NAVAR1.0600*+
                Rec18.RESET;
                Rec18.SETCURRENTKEY("No.");
                Rec18.SETRANGE("No.", "Bill-to Customer No.");
                if Rec18.FINDFIRST then
                    gTel := Rec18."Phone No.";

                RecActEmpresa.RESET;
                RecActEmpresa.SETCURRENTKEY("GMAActivity Code");
                RecActEmpresa.SETRANGE("GMAActivity Code", "GMAPoint of Sales");
                if RecActEmpresa.FINDFIRST then
                    gInicio := RecActEmpresa."GMAActivity Starting Date";

                Recshipment.RESET;
                Recshipment.SETRANGE("Applies-to Doc. No.", "Sales Invoice Header"."Applies-to Doc. No.");
                if Recshipment.FINDFIRST then
                    CodAlbaran := Recshipment."No.";


                //MC Tipo pago


                if PaymentTerms.GET("Sales Invoice Header"."Payment Terms Code") then begin
                    /* //Version Española
                    PaymentTerms.calcfields("No. of Installments");
                    if PaymentTerms."No. of Installments" > 0 then
                        TipoPago := 'CUOTAS'
                    else
                        */ //Version Española
                    TipoPago := 'TRANSFER'
                end;

                //MC FIn   
            end;

            trigger OnPreDataItem();
            begin
                // InfoEmpresa.GET();
                ok := recAreaImp.GET('CLI-RI');
                if ok then
                    ok := recTipoFisca.GET(recAreaImp."GMAFiscal Type");

                //SL BUG1564
                // InfoEmpresa.GET();
                // InfoEmpresa.CALCFIELDS(BssiPicture);
                // AW - BEGIN 
                // RecPais.Reset();
                // recpais.get(infoempresa.BssiProvinceCode);
                // AW - END
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                field(paramMonedaOriginal; paramMonedaOriginal)
                {
                    Caption = 'Imprime en moneda original documento';
                    ApplicationArea = ALL;
                }
                field(ShowAllLine; ShowAllLine)
                {
                    Caption = 'Mostrar todas las lineas';
                    ApplicationArea = ALL;
                }
                field(AgruparUnaLinea; AgruparUnaLinea)
                {
                    Caption = 'Agrupar en una sola linea';
                    ApplicationArea = ALL;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin

        Contador := 0;
        ShowAllLine := true;
    end;

    var
        TipoPago: text[30];
        PaymentTerms: Record "Payment Terms";
        leyenda2: Text[100];
        ShowAllLine: Boolean;
        AgruparUnaLinea: Boolean;
        DescripcionLinea: text[250];
        paramMonedaOriginal: Boolean;
        b: Record "Payment Terms";
        FormaPago: Record "Payment Method";
        TipoFisca: Record "GMAFiscal Type";
        AreaImp: Record "Tax Area";
        ImporteLetras: Text[256];
        Convierto: Codeunit GMAConvierteNoAText;
        NumberText: array[2] of Text[256];
        Moneda: Record Currency;
        MovIVA: Record "VAT Entry";
        TaxJur: Record "Tax Jurisdiction";
        impuesto: array[20] of Decimal;
        i: Integer;
        nombreimp: array[20] of Code[20];
        k: Integer;
        factor: Decimal;
        Totimp: Decimal;
        ok: Boolean;
        Contador: Integer;
        varDec: Decimal;
        TipoDocumento: Text[150];
        DocNUMAF: Text;
        InfoEmpresa: Record "Dimension Value";
        "------------------------------": Integer;
        Codigo: Text[100];
        Valor: Integer;
        cadena: Text[100];
        character: Char;
        Convertir: Codeunit "GMAANSI <-> ASCII conve";
        Barra2: Text[100];
        barra: Text[60];
        "----------------------------->": Integer;
        recLineasTemp: Record "Sales Cr.Memo Line" temporary;
        recLineas: Record "Sales Cr.Memo Line";
        cont: Integer;
        recTipoFisca: Record "GMAFiscal Type";
        recAreaImp: Record "Tax Area";
        leyenda: Text[250];
        recCliente: Record Customer;
        DocAnterior: Code[20];
        Imprimirsolooriginal: Boolean;
        BillingDescription: Text[100];
        Despacho: Code[20];
        Descuento1: Decimal;
        gDescuentoCabacera: Decimal;
        gTotalNeto: Decimal;
        gDescuento: Decimal;
        "RecSalesperson/Purchaser": Record "Salesperson/Purchaser";
        gNomVend: Text[50];
        gDifIva: Decimal;
        gPorsIva: Decimal;
        gPrecioIvaIncl: Decimal;
        gPrecioIva: Decimal;
        fDif: Decimal;
        RecSLIne: Record "Sales Cr.Memo Line";
        CUCBarras: Codeunit "GMACodigo de barras FE";
        gTotPrecioIvaIncl: Decimal;
        RecItemLed: Record "Item Ledger Entry";
        z: Integer;
        Rec18: Record Customer;
        gTel: Text[30];
        RecActEmpresa: Record "GMACompany Activity";
        gInicio: Date;
        "Return Receipt Header": REcord "Return Receipt Header";
        gProvincia: Text[50];
        RecProvincia: Record GMAProvince;
        r: Integer;
        CalcDes: Decimal;
        Recshipment: Record "Return Receipt Header";
        CodAlbaran: Code[20];
        "*******": Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        OutputNo: Integer;
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        Tex: Text[30];
        Text003: Label 'COPY';
        Text004: Label 'Sales - Invoice %1';
        Text005: Label 'Page %1';
        CP_CaptionLbl: Label 'CP:';
        Fecha_CaptionLbl: Label 'Fecha:';
        Ingresos_Brutos_C_M__CaptionLbl: Label 'Ingresos Brutos C.M.:';
        Tel_CaptionLbl: Label 'Tel:';
        Precio_UnitarioCaptionLbl: Label 'Precio';
        Precio_TotalCaptionLbl: Label 'Importe';
        "DescripciónCaptionLbl": Label 'Descripción';
        CantidadCaptionLbl: Label 'Cantidad';
        Nombre_CaptionLbl: Label 'Sres.:';
        Nro_CaptionLbl: Label 'Nro:';
        CodigoCaptionLbl: Label 'Codigo';
        DespachoCaptionLbl: Label 'Despacho';
        Bon__1CaptionLbl: Label 'Bon. ';
        Orden_de_Compra_CaptionLbl: Label 'Orden de Compra:';
        BCaptionLbl: Label 'B';
        Codigo_006CaptionLbl: Label 'Codigo 006';
        Inicio_de_ActividadesCaptionLbl: Label 'Inicio de Actividades';
        Cond__de_ventaCaptionLbl: Label 'Cond. de venta';
        VendedorCaptionLbl: Label 'Vendedor';
        Bank__TransferCaptionLbl: Label 'Forma de Pago';
        TOTALCaptionLbl: Label 'TOTAL';
        C_A_E_CaptionLbl: Label 'C.A.E.';
        Vto__CaptionLbl: Label 'Vto.:';
        Sub_TotalCaptionLbl: Label 'Sub Total';
        DescuentoCaptionLbl: Label 'Descuento';
        Total_NetoCaptionLbl: Label 'Total';
        PorcentajeIVA: Decimal;
        ImporteBase1: Decimal;
        tmoviva: Record "VAT Entry";
        ImporIVA1: Decimal;
        ImporIVA2: Decimal;
        ImporIVA3: Decimal;
        ImporIVA4: Decimal;
        TituloLote: code[20];
        NoArticulo: code[20];

        // AW - BEGIN 
        RecPais: record "Country/Region";
        NumeroLote: code[50];

        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        CompanyCBU: Text[250];
        CompanyAlias: Text[250];
        simboloMoneda: text;

    procedure buscarloteserie(salesLineNo: Record "Sales Cr.Memo Line") numeroLOTSER: text
    var
        valueEntry: Record "Value Entry";

    begin

        //1 si la factura se registro con el remito

        //filtras el remito
        IF ("Sales Invoice Header"."Return Order No." <> '') THEN BEGIN
            "Return Receipt Header".RESET;
            "Return Receipt Header".SETCURRENTKEY("Return Order No.");
            "Return Receipt Header".SETRANGE("Return Order No.", "Sales Invoice Header"."Return Order No.");
            "Return Receipt Header".SETRANGE("Posting Date", "Sales Invoice Header"."Posting Date");
            if "Return Receipt Header".FINDFIRST then
                repeat
                    "Item Ledger Entry".RESET;
                    "Item Ledger Entry".SETCURRENTKEY("Entry No.");
                    "Item Ledger Entry".SETRANGE("Entry Type", RecItemLed."Entry Type"::Sale);
                    "Item Ledger Entry".SETRANGE("Document No.", "Return Receipt Header"."No.");
                    "Item Ledger Entry".SETRANGE("Document Line No.", salesLineNo."Line No.");
                    "Item Ledger Entry".SETRANGE("Item No.", salesLineNo."No.");
                    IF ("Item Ledger Entry".findfirst) THEN
                        repeat
                            valueEntry.reset;
                            valueEntry.setrange("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                            IF (valueEntry.findfirst) then begin
                                IF ("Item Ledger Entry"."Lot No." <> '') THEN BEGIN
                                    tituloLote := 'LOTE';
                                    numeroLOTSER := numeroLOTSER + "Item Ledger Entry"."Lot No." + "Item Ledger Entry"."Serial No." + '|';
                                END;
                                IF ("Item Ledger Entry"."Serial No." <> '') THEN BEGIN
                                    tituloLote := 'SERIE';
                                    numeroLOTSER := numeroLOTSER + "Item Ledger Entry"."Lot No." + "Item Ledger Entry"."Serial No." + '|';
                                END;
                            end;
                        until "Item Ledger Entry".next() = 0;

                UNTIL "Return Receipt Header".next() = 0;

        end
        else begin
            "Item Ledger Entry".RESET;
            "Item Ledger Entry".SETCURRENTKEY("Entry No.");
            "Item Ledger Entry".SETRANGE("Entry Type", RecItemLed."Entry Type"::Sale);
            "Item Ledger Entry".SETRANGE("Document No.", salesLineNo."Document No.");
            "Item Ledger Entry".SETRANGE("Document Line No.", salesLineNo."Line No.");
            "Item Ledger Entry".SETRANGE("Item No.", salesLineNo."No.");
            IF ("Item Ledger Entry".findfirst) THEN
                repeat
                    IF ("Item Ledger Entry"."Lot No." <> '') THEN BEGIN
                        tituloLote := 'LOTE';
                        numeroLOTSER := numeroLOTSER + "Item Ledger Entry"."Lot No." + "Item Ledger Entry"."Serial No." + '|';
                    END;
                    IF ("Item Ledger Entry"."Serial No." <> '') THEN BEGIN
                        tituloLote := 'SERIE';
                        numeroLOTSER := numeroLOTSER + "Item Ledger Entry"."Lot No." + "Item Ledger Entry"."Serial No." + '|';
                    END;
                until "Item Ledger Entry".next() = 0;
        end


    end;
    // AW - END 
}

