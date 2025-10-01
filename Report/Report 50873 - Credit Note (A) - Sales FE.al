report 34006873 "PersCredit Note (A) - Sales "
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107873 - Credit Note (A) FE.rdl';
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
            column(Sales_Invoice_Header_PostingDescription; "Sales Invoice Header"."Posting Description")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = FILTER(3));
                    column(FormaPago_Description; FormaPago.Description)
                    {
                    }
                    column(TipoPago; TipoPago)
                    {
                    }
                    column(NoRemito; NoRemito)
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
                    column(CopiaLetra; TipoDocumento)
                    {
                    }
                    column(InfoEmpresa__Phone_No__; InfoEmpresa.BssiBillingPhoneNumber)
                    {
                    }
                    column(InfoEmpresa__N__ingresos_brutos_; InfoEmpresa.BssiGrossIncomeNo)
                    {
                    }
                    column(DocNUMAF; DocNUMAF)
                    {
                    }
                    column(InfoEmpresa_Address; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa.BssiBillingZipCode + ', ' + InfoEmpresa.BssiBillingCountry + ', ' + RecPais.Name)
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
                    column(CUIT_______FORMAT_InfoEmpresa__VAT_Registration_No___; 'CUIT: ' + FORMAT(InfoEmpresa.BssiTaxRegistrationNumber))
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___External_Document_No__; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___Bill_to_Customer_No__; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(gNomVend; gNomVend)
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___Posting_Date_; "Sales Invoice Header"."Posting Date")
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___Payment_Terms_Code_; "Sales Invoice Header"."Payment Terms Code")
                    {
                    }
                    column(gTel; gTel)
                    {
                    }
                    column(gInicio; gInicio)
                    {
                    }
                    column(gProvincia______InfoEmpresa__Country_Region_Code_; gProvincia + ', ' + InfoEmpresa.BssiProvinceCode)
                    {
                    }
                    column(Sales_Invoice_Header__Sales_Invoice_Header___Payment_Method_Code_; "Sales Invoice Header"."Payment Method Code")
                    {
                    }
                    column(NoOfLoops; OutputNo)
                    {
                    }
                    column(Tex; Tex)
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
                    column(ACaption; ACaptionLbl)
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
                    column(Cond__de_ventaCaption; Cond__de_ventaCaptionLbl)
                    {
                    }
                    column(VendedorCaption; VendedorCaptionLbl)
                    {
                    }
                    column(Codigo_01Caption; Codigo_01CaptionLbl)
                    {
                    }
                    column(Inicio_de_ActividadesCaption; Inicio_de_ActividadesCaptionLbl)
                    {
                    }
                    column(Bank__TransferCaption; Bank__TransferCaptionLbl)
                    {
                    }
                    column(TipoCaption; TipoCaptionLbl)
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
                    column(NombreProv; NombreProv)
                    {
                    }
                    column(CompanyCBU; CompanyCBU)
                    {
                    }
                    column(CompanyAlias; CompanyAlias)
                    {
                    }
                    //SL Begin Bug1564
                    column(CompanyImage; "InfoEmpresa".BssiPicture)
                    {
                    }
                    column(InicioActividades; "InfoEmpresa".BssiActivityStratDate)
                    {
                    }
                    column(CAE_Due_Date; "Sales Invoice Header"."GMACAEA Due Date")
                    {
                    }
                    //SL End
                    // AW - BEGIN TFS 1894
                    column(Sales_Invoice_Header_InvDiscountAmount; "Sales Invoice Header"."Invoice Discount Amount")
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
                    column(SalesCurrencyCode; "Sales Invoice Header"."Currency Code")
                    { }


                    dataitem("Sales Invoice Line"; "Sales Cr.Memo Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);
                        column(Sales_Invoice_Line_Description; Description + '  ' + "Sales Invoice Line"."Description 2")
                        {
                        }
                        column(Sales_Invoice_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Invoice_Line__Unit_Price_; "Unit Price")
                        {
                        }
                        column(Sales_Invoice_Line_Amount; gTotalNeto)
                        {
                        }
                        column(Sales_Invoice_Line__No__; NoArticulo)
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
                        column(LineControl; LineControl)
                        {
                        }
                        column(Sales_Invoice_Line__Sales_Invoice_Line___Tax_Group_Code_; "Sales Invoice Line"."Tax Group Code")
                        {
                        }
                        column(leyenda2; leyenda2)
                        {
                        }
                        column(FechaVencimiento; fechavencimiento)
                        {
                        }
                        column(Sales_Invoice_Header__FechaVtoCAI; "Sales Invoice Header"."GMACAI Due Date2")
                        {
                        }
                        column(Sales_Invoice_Header__CAI; "Sales Invoice Header".GMACAI2)
                        {
                        }
                        column(Sales_Invoice_Header___Amount_Including_VAT_; "Sales Invoice Header"."Amount Including VAT")
                        {
                        }
                        column(ImporteLetras; ImporteLetras)
                        {
                        }
                        column(Sales_Invoice_Header__Amount; "Sales Invoice Header".Amount)
                        {
                        }
                        column(barra; barra)
                        {
                        }
                        column(barra_Control1102201018; barra)
                        {
                        }
                        column(barra_Control1102201019; barra)
                        {
                        }
                        column(Barra2; Barra2)
                        {
                        }
                        column(gTotNetoT; gTotNetoT)
                        {
                        }
                        column(gDescuento1; gDescuento1)
                        {
                        }
                        column(Sales_Invoice_Header__Amount_Control1102201063; "Sales Invoice Header".Amount)
                        {
                        }
                        column(ImporIVA1; ImporIVA1)
                        {
                        }
                        // AW - begin
                        column(ImporIVA10; ImporIVA10)
                        {
                        }
                        // AW - end
                        column(ImporIVA4; ImporIVA4)
                        {
                        }
                        column(ImporIVA2; ImporIVA2)
                        {
                        }
                        column(ImporIVA3; ImporIVA3)
                        {
                        }
                        column(TImpuestos1; TImpuestos1)
                        { }
                        column(TImpuestos2; TImpuestos2)
                        { }
                        column(TImpuestos3; TImpuestos3)
                        { }
                        column(TImpuestos4; TImpuestos4)
                        { }
                        column(VImpuestos1; abs(VImpuestos1))
                        { }
                        column(VImpuestos2; abs(VImpuestos2))
                        { }
                        column(VImpuestos3; abs(VImpuestos3))
                        { }
                        column(VImpuestos4; abs(VImpuestos4))
                        { }
                        column(IIBBTImpuestos1; IIBBTImpuestos1)
                        { }
                        column(IIBBTImpuestos2; IIBBTImpuestos2)
                        { }
                        column(IIBBTImpuestos3; IIBBTImpuestos3)
                        { }
                        column(IIBBTImpuestos4; IIBBTImpuestos4)
                        { }
                        column(IIBBVImpuestos1; IIBBVImpuestos1)
                        { }
                        column(IIBBVImpuestos2; IIBBVImpuestos2)
                        { }
                        column(IIBBVImpuestos3; IIBBVImpuestos3)
                        { }
                        column(IIBBVImpuestos4; IIBBVImpuestos4)
                        { }

                        column(ImportesIva_1_2_; ImportesIva[1, 2])
                        {
                        }
                        column(ImportesIva_2_2_; ImportesIva[2, 2])
                        {
                        }
                        column(ImportesIva_3_2_; ImportesIva[3, 2])
                        {
                        }
                        column(ImportesIva_4_2_; ImportesIva[4, 2])
                        {
                        }
                        column(ImportesIva_1_1_; ImportesIva[1, 1])
                        {
                        }
                        column(ImportesIva_2_1_; ImportesIva[2, 1])
                        {
                        }
                        column(ImportesIva_3_1_; ImportesIva[3, 1])
                        {
                        }
                        column(ImportesIva_4_1_; ImportesIva[4, 1])
                        {
                        }
                        column(Iv22; Iv22)
                        {
                        }
                        column(Iv21; Iv21)
                        {
                        }
                        column(CodAlbaran; CodAlbaran)
                        {
                        }
                        column(MatrizIIBBPer_1_2_; MatrizIIBBPer[1, 2])
                        {
                        }
                        column(MatrizIIBBPer_2_2_; MatrizIIBBPer[2, 2])
                        {
                        }
                        column(MatrizIIBBPer_3_2_; MatrizIIBBPer[3, 2])
                        {
                        }
                        column(MatrizIIBBPer_4_2_; MatrizIIBBPer[4, 2])
                        {
                        }
                        column(TotalIvaPerIBB; abs(TotalIvaPerIBB))
                        {
                        }
                        column(porcentajeIVAPerIIBB; porcentajeIVAPerIIBB)
                        {
                        }
                        column(tipoIIBB; tipoIIBB)
                        {
                        }
                        column(porcentajeIVAPer; porcentajeIVAPer)
                        {
                        }
                        column(TotalIvaPer; abs(TotalIvaPer))
                        {
                        }
                        column(PorcentajeIVA; PorcentajeIVA)
                        {
                        }
                        column(sumaporciva; sumaporciva)
                        {
                        }
                        column(Sumaporciibb; Sumaporciibb)
                        {
                        }
                        column(Sales_Invoice_Header___Due_Date_; "Sales Invoice Header"."Due Date")
                        {
                        }
                        column(C_A_E_Caption; C_A_E_CaptionLbl)
                        {
                        }
                        column(Vto__Caption; Vto__CaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(I_V_A__InscriptoCaption; I_V_A__InscriptoCaptionLbl)
                        {
                        }
                        column(I_V_A__No_InscriptoCaption; I_V_A__No_InscriptoCaptionLbl)
                        {
                        }
                        column(Percepcion_I_V_A_Caption; Percepcion_I_V_A_CaptionLbl)
                        {
                        }
                        column(Perc__Ingr__BrutosCaption; Perc__Ingr__BrutosCaptionLbl)
                        {
                        }
                        column(TOTALCaption; TOTALCaptionLbl)
                        {
                        }
                        column(COMPROBANTES_REFERENCIADOS_Caption; COMPROBANTES_REFERENCIADOS_CaptionLbl)
                        {
                        }
                        column(OBSERVACION_Caption; OBSERVACION_CaptionLbl)
                        {
                        }
                        column(Sub_TotalCaption; Sub_TotalCaptionLbl)
                        {
                        }
                        column(DescuentoCaption; DescuentoCaptionLbl)
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
                            DataItemLinkReference = "Sales Invoice Header";
                            DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
                            column(Item_Ledger_Entry__Quantity__1; "Item Ledger Entry".Quantity)
                            {
                            }
                            column(Item_Ledger_Entry__Item_Ledger_Entry___Lot_No__; "Item Ledger Entry"."Lot No.")
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
                        var
                            tex: Text[1024];
                            _recVatEntry: Record "VAT Entry";
                            _recTaxJur: Record "Tax Jurisdiction";
                            _DescripJuris: Text[80];
                            _i: Integer;
                        begin
                            "Unit Price" := ROUND("Unit Price", 0.0001);
                            "Line Discount %" := ROUND("Line Discount %", 0.001);
                            if "Sales Invoice Line".type = "Sales Invoice Line".type::"G/L Account" then
                                NoArticulo := ''
                            else
                                NoArticulo := "Sales Invoice Line"."No.";
                            z += 1;
                            if z mod 20 = 0 then
                                //CurrReport.NEWPAGE;

                                if Primero = true then begin
                                    Line := "Sales Invoice Line"."Line No.";
                                    LineAnt := 0;
                                end else begin
                                    LineAnt := Line;
                                    Line := "Sales Invoice Line"."Line No.";
                                end;

                            LineControl := Line - LineAnt;
                            gDescuento := 0;

                            gDescuento := gDescuento + "Sales Invoice Line"."Inv. Discount Amount";
                            gDescuento1 := gDescuento1 + "Sales Invoice Line"."Inv. Discount Amount";
                            gTotNetoT := +gTotNetoT + Amount + gDescuento1;
                            gTotalNeto := Amount + gDescuento;

                            CLEAR(r);
                            CLEAR(Despacho);

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


                            j := 1;
                            q := 0;
                            Agrego := false;
                            if Entro = false then begin
                                tmoviva2.RESET;
                                tmoviva2.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                                tmoviva2.SETRANGE(Type, tmoviva.Type::Sale);
                                //tmoviva2.SETRANGE("Tax Group Code","Tax Group Code");
                                tmoviva2.SETFILTER("Document Type", '%1', tmoviva."Document Type"::"Credit Memo");
                                if tmoviva2.FINDSET then
                                    repeat
                                        if gPrincipal = true then begin
                                            Auxx := 1;
                                            if (tmoviva2."Tax Group Code" = '') then
                                                tmoviva2."Tax Group Code" := 'IVA EXENTO';
                                            ImportesIva[Auxx, 1] := tmoviva2."Tax Group Code";
                                            if (tmoviva2.Amount <> 0) then
                                                ImpIVas += tmoviva2.Amount * -1
                                            else
                                                ImpIVas += tmoviva2.Base * -1;

                                            ImpIvasText := FORMAT(ImpIVas);
                                            ImportesIva[Auxx, 2] := ImpIvasText;
                                            gPrincipal := false;
                                        end else begin
                                            for j := 1 to 4 do begin
                                                //j+=1;
                                                tex := ImportesIva[j, 1];
                                                if (tmoviva2."Tax Group Code" = '') then
                                                    tmoviva2."Tax Group Code" := 'IVA EXENTO';

                                                if ImportesIva[j, 1] = tmoviva2."Tax Group Code" then begin
                                                    EVALUATE(ImpIVas, ImportesIva[j, 2]);
                                                    if (tmoviva2.Amount <> 0) then
                                                        ImpIVas += tmoviva2.Amount * -1
                                                    else
                                                        ImpIVas += tmoviva2.Base * -1;

                                                    ImpIvasText := FORMAT(ImpIVas);
                                                    ImportesIva[j, 2] := ImpIvasText;
                                                    Agrego := true;
                                                end;
                                            end;
                                            if Agrego = false then begin
                                                ImpIVas := 0;
                                                Auxx += 1;
                                                if (tmoviva2."Tax Group Code" = '') then
                                                    tmoviva2."Tax Group Code" := 'IVA EXENTO';

                                                ImportesIva[Auxx, 1] := tmoviva2."Tax Group Code";
                                                if (tmoviva2.Amount <> 0) then
                                                    ImpIVas += tmoviva2.Amount * -1
                                                else
                                                    ImpIVas += tmoviva2.Base * -1;

                                                ImpIvasText := FORMAT(ImpIVas);
                                                ImportesIva[Auxx, 2] := ImpIvasText;
                                                Agrego := false;
                                            end;
                                        end;
                                        Agrego := false;
                                    until tmoviva2.NEXT = 0;
                                Entro := true;
                            end;
                            //TotalIvaPerIBB := 0;
                            //TotalIvaPerIBB := ImporIVA2[2,2] + ImporIVA2[2,3];
                            Iv21 := ImportesIva[2, 1];
                            Iv22 := ImportesIva[2, 2];


                            //Todo prueba
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
                            CLEAR(nombrePercep);

                            "Sales Invoice Header".CALCFIELDS(Amount);
                            "Sales Invoice Header".CALCFIELDS("Amount Including VAT");
                            varDec := "Sales Invoice Header"."Amount Including VAT";

                            if "Sales Invoice Header"."Currency Factor" <> 0 then
                                factor := "Sales Invoice Header"."Currency Factor"
                            else
                                factor := 1;

                            i := 0;
                            i := 4;//NAVAR1.06001
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
                                //      leyenda := 'EFECTIVO vencimiento '+FORMAT("Sales Invoice Header"."Due Date");
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
                                        end; // Fin si forma de pago es en efectivo.
                                    '20':
                                        begin
                                            if recCliente.GET("Sales Invoice Header"."Bill-to Customer No.") then
                                                leyenda := 'LA SIGUIENTE FACTURA SERA DEBITADA DE SU TARJETA CRÉDITO ';
                                            // + recCliente."CC Type";
                                        end;
                                    '30':
                                        begin
                                            leyenda := 'LA SIGUIENTE FACTURA SERA DEBITADA DE SU C.B.U. INFORMADO';
                                        end;
                                end; // Fin de case.

                                //NAVAR1.06002
                                if ((impuesto[2] + impuesto[3] + impuesto[4]) > 0) then
                                    nombrePercep := 'Percep. II.BB.BS. AS.';
                                //Termina prueba
                            end;

                            NumeroLote := buscarloteserie("Sales Invoice Line");
                            if "Sales Invoice Header"."Currency Code" <> '' then begin
                                Moneda.GET("Sales Invoice Header"."Currency Code");
                                simboloMoneda := Moneda.Symbol;
                            end;
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
                    gTotNetoT := 0;
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
                    NoOfLoops := ABS(NoOfCopies) + 1;  // AW - Modificado para que solo saque original
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);

                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                tex: Text[1024];
                _recVatEntry: Record "VAT Entry";
                _recTaxJur: Record "Tax Jurisdiction";
                _DescripJuris: Text[80];
                _i: Integer;
                recTaxJurisdictions: Record "Tax Jurisdiction";
                arrImpuestos: array[10] of Text[200];
                arrValoresImpuestos: array[10] of Decimal;
                IIBBarrImpuestos: array[10] of Text[200];
                IIBBarrValoresImpuestos: array[10] of Decimal;
                iterArray: Integer;
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

                Entro := false;
                "#InicializaVariables";
                if ("sales invoice header"."GMAElectronic Invoicing" <> "sales invoice header"."GMAElectronic Invoicing"::NO) and ("sales invoice header"."GMAElectronic Invoicing" <> "sales invoice header"."GMAElectronic Invoicing"::HASAR) then
                    wsgrupomas.FE_GenerarQR("sales invoice header"."No.", 2);
                "sales invoice header".CalcFields("GMA QRCode");
                "Sales Invoice Header".CALCFIELDS(Amount);
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
                CLEAR(nombrePercep);
                ok := PaymentTerms.GET("Sales Invoice Header"."Payment Terms Code");
                ok := FormaPago.GET("Sales Invoice Header"."Payment Method Code");
                ok := AreaImp.GET("Sales Invoice Header"."Tax Area Code");
                ok := TipoFisca.GET(AreaImp."GMAFiscal Type");
                "Sales Invoice Header".CALCFIELDS("Amount Including VAT");
                Auxx := 0;
                gPrincipal := true;
                RecProvincia.RESET;
                RecProvincia.SETCURRENTKEY(RecProvincia."GMAProvince Code");
                RecProvincia.SETRANGE("GMAProvince Code", InfoEmpresa.BssiProvinceCode);
                if RecProvincia.FINDFIRST then
                    gProvincia := RecProvincia.GMADescription;


                //WDL - Agregar provincia del cliente

                RecProvincia.RESET;
                RecProvincia.SETCURRENTKEY(RecProvincia."GMAProvince Code");
                RecProvincia.SETRANGE("GMAProvince Code", "Sales Invoice Header".GMAProvince);
                if RecProvincia.FINDFIRST then
                    NombreProv := RecProvincia.GMADescription;
                //WDL




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
                CLEAR(ImporteBase2);
                CLEAR(ImporIVA10);
                tmoviva.RESET;
                tmoviva.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                tmoviva.SETRANGE(Type, tmoviva.Type::Sale);
                tmoviva.SETFILTER("Document Type", '%1', tmoviva."Document Type"::"Credit Memo");
                if tmoviva.FINDFIRST then
                    repeat
                        case tmoviva."GMATax Type Loc" of
                            tmoviva."GMATax Type Loc"::IVA:
                                begin
                                    recTaxJurisdictions.Reset();
                                    recTaxJurisdictions.SetRange(recTaxJurisdictions.Code, tmoviva."Tax Jurisdiction Code");
                                    if recTaxJurisdictions.FindFirst() then begin
                                        acumularImpuesto(arrImpuestos, arrValoresImpuestos, recTaxJurisdictions."GMA VAT Book Code", tmoviva.Amount);
                                    end;
                                end;

                            tmoviva."GMATax Type Loc"::"IVA Percepcion":
                                ImporIVA2 := ImporIVA2 + (tmoviva.Amount * factor * -1);
                            tmoviva."GMATax Type Loc"::"Ingresos Brutos":

                                begin
                                    ImporIVA3 := ImporIVA3 + (tmoviva.Amount * factor * -1);
                                    recTaxJurisdictions.Reset();
                                    recTaxJurisdictions.SetRange(recTaxJurisdictions.Code, tmoviva."Tax Jurisdiction Code");
                                    if recTaxJurisdictions.FindFirst() then begin
                                        IIBBacumularImpuesto(IIBBarrImpuestos, IIBBarrValoresImpuestos, recTaxJurisdictions.Description, tmoviva.Amount);
                                    end;
                                end;
                            tmoviva."GMATax Type Loc"::Otros:
                                ImporIVA4 := ImporIVA4 + (tmoviva.Amount * factor * -1);
                        end;
                    until tmoviva.NEXT = 0;
                TImpuestos1 := arrImpuestos[1];
                TImpuestos2 := arrImpuestos[2];
                TImpuestos3 := arrImpuestos[3];
                TImpuestos4 := arrImpuestos[4];
                vImpuestos1 := arrValoresImpuestos[1] * factor;
                vImpuestos2 := arrValoresImpuestos[2] * factor;
                vImpuestos3 := arrValoresImpuestos[3] * factor;
                vImpuestos4 := arrValoresImpuestos[4] * factor;

                IIBBTImpuestos1 := IIBBarrImpuestos[1];
                IIBBTImpuestos2 := IIBBarrImpuestos[2];
                IIBBTImpuestos3 := IIBBarrImpuestos[3];
                IIBBTImpuestos4 := IIBBarrImpuestos[4];
                IIBBvImpuestos1 := IIBBarrValoresImpuestos[1] * factor;
                IIBBvImpuestos2 := IIBBarrValoresImpuestos[2] * factor;
                IIBBvImpuestos3 := IIBBarrValoresImpuestos[3] * factor;
                IIBBvImpuestos4 := IIBBarrValoresImpuestos[4] * factor;

                CLEAR(PorcentajeIVA);

                ImporteBase1 := ROUND(ImporteBase1, 0.01);
                // AW - begin
                ImporteBase2 := ROUND(ImporteBase2, 0.01);
                // AW - end
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


                //NAVAR1.06003-
                _i := 0;
                _recVatEntry.RESET;
                _recVatEntry.SETCURRENTKEY(_recVatEntry."Document No.", _recVatEntry."Tax Jurisdiction Code");
                _recVatEntry.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                _recVatEntry.SETFILTER("GMATax Type Loc", '<>%1', _recVatEntry."GMATax Type Loc"::IVA);
                begin
                    jurisdiccionactual := '999999';

                    if _recVatEntry.FINDSET then
                        repeat
                            _recTaxJur.RESET;
                            _recTaxJur.SETCURRENTKEY(Code);
                            _recTaxJur.SETRANGE(Code, _recVatEntry."Tax Jurisdiction Code");
                            if _recTaxJur.FINDFIRST then
                                _DescripJuris := _recTaxJur.Description
                            else
                                _DescripJuris := '';
                            _i += 1;

                            _recVatEntry.Amount := ROUND(_recVatEntry.Amount * factor);
                            _recVatEntry.Base := ROUND(_recVatEntry.Base * factor);

                            MatrizIIBBPer[_i, 2] := _DescripJuris + '    Total: ' + "Sales Invoice Header"."Currency Code" + ' ' +
                                                   FORMAT((_recVatEntry.Amount) * -1);

                            ImportePercIIBB := 0;
                            ImportePErcIVa := 0;
                            TotalBase := 0;
                            TotalBaseIVAPer := 0;
                            porcentajeIVAPerIIBB := 0;
                            porcentajeIVAPer := 0;


                            if _recVatEntry."Tax Jurisdiction Code" <> jurisdiccionactual then begin

                                if _recVatEntry."GMATax Type Loc" = _recVatEntry."GMATax Type Loc"::"Ingresos Brutos" then begin
                                    TotalIvaPerIBB += _recVatEntry.Amount;//ACumulador jony
                                    TotalBase := _recVatEntry.Base;
                                    ImportePercIIBB := _recVatEntry.Amount;
                                    TotalBase := ROUND(TotalBase, 0.01);
                                    if TotalBase <> 0 then
                                        porcentajeIVAPerIIBB := ROUND((ImportePercIIBB / TotalBase) * 100, 0.01);

                                    if _DescripJuris <> '' then
                                        tipoIIBB := _DescripJuris;
                                end else begin
                                    TotalIvaPer += _recVatEntry.Amount; //ACumulador jony
                                    ImportePErcIVa := _recVatEntry.Amount; //no se acumula se toma cada basee se saca el porcentaje
                                                                           //y se suman los porcentajes
                                    TotalBaseIVAPer := _recVatEntry.Base;
                                    TotalBaseIVAPer := ROUND(TotalBaseIVAPer, 0.01);
                                    if TotalBaseIVAPer <> 0 then
                                        porcentajeIVAPer := ROUND((ImportePErcIVa / TotalBaseIVAPer) * 100, 0.01);

                                end;

                            end
                            else begin

                                if _recVatEntry."GMATax Type Loc" = _recVatEntry."GMATax Type Loc"::"Ingresos Brutos" then begin
                                    TotalIvaPerIBB += _recVatEntry.Amount;//ACumulador jony
                                end
                                else begin
                                    TotalIvaPer += _recVatEntry.Amount; //ACumulador jony

                                end;
                            end;

                            sumaporciva := sumaporciva + porcentajeIVAPer;
                            Sumaporciibb := Sumaporciibb + porcentajeIVAPerIIBB;


                            jurisdiccionactual := _recVatEntry."Tax Jurisdiction Code";

                        until _recVatEntry.NEXT = 0;

                end;

                //para no tener que tocar roles asigno nuevamente a las variables de los porcenjaes de perc que ya estan en el reporte
                //de reoles
                //NAVAR1.06003+
                porcentajeIVAPer := ABS(sumaporciva);
                porcentajeIVAPerIIBB := ABS(Sumaporciibb);

                TotalIvaPer := ABS(TotalIvaPer);
                TotalIvaPerIBB := ABS(TotalIvaPerIBB);

                fechavencimiento := FORMAT("Sales Invoice Header"."Due Date");


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

                //SL Begin Bug-1564
                // InfoEmpresa.GET();
                // InfoEmpresa.CALCFIELDS(BssiPicture);
                //SL End
                // AW - BEGIN
                // RecPais.RESET;
                // RecPais.GET(InfoEmpresa.BssiProvinceCode);
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
        DocAnterior := ' ';
        ShowAllLine := true;
    end;

    var
        TipoPago: text;
        ShowAllLine: Boolean;
        AgruparUnaLinea: Boolean;
        DescripcionLinea: text[250];
        paramMonedaOriginal: Boolean;
        PaymentTerms: Record "Payment Terms";
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
        nombreimp: array[20] of Code[1024];
        k: Integer;
        factor: Decimal;
        Totimp: Decimal;
        ok: Boolean;
        Contador: Integer;
        varDec: Decimal;
        InfoEmpresa: Record "Dimension Value";
        RecPais: Record "Country/Region";
        "------------------------------": Integer;
        Codigo: Text[100];
        Valor: Integer;
        cadena: Text[100];
        character: Char;
        Convertir: Codeunit "GMAANSI <-> ASCII conve";
        Barra2: Text[100];
        barra: Text[60];
        "----------------------------->": Integer;
        recLineasTemp: Record "Sales Invoice Line" temporary;
        recLineas: Record "Sales Invoice Line";
        cont: Integer;
        recTipoFisca: Record "GMAFiscal Type";
        recAreaImp: Record "Tax Area";
        leyenda: Text[1024];
        recCliente: Record Customer;
        Imprimirsolooriginal: Boolean;
        DocAnterior: Code[1024];
        nombrePercep: Text[1024];
        Despacho: Code[1024];
        Descuento1: Decimal;
        Descuento2: Decimal;
        OrdenDeCompra: Text[1024];
        TipoDocumento: Text[1024];
        gDescuentoCabacera: Decimal;
        gTotalNeto: Decimal;
        gDescuento: Decimal;
        "RecSalesperson/Purchaser": Record "Salesperson/Purchaser";
        gNomVend: Text[50];
        CUCBarras: Codeunit "GMACodigo de barras FE";
        gDescuento1: Decimal;
        gTotNetoT: Decimal;
        tmoviva: Record "VAT Entry";
        ImporIVA1: Decimal;
        // AW - begin
        ImporIVA10: Decimal;
        // AW - end
        ImporIVA2: Decimal;
        ImporIVA3: Decimal;
        ImporIVA4: Decimal;
        ImporIVA5: Decimal;
        RecItemLed: Record "Item Ledger Entry";
        z: Integer;
        Rec18: Record Customer;
        gTel: Text[1024];
        RecActEmpresa: Record "GMACompany Activity";
        gInicio: Date;
        "Return Receipt Header": REcord "Return Receipt Header";
        RecProvincia: Record GMAProvince;
        gProvincia: Text[50];
        gCantidad: Integer;
        r: Integer;
        Line: Decimal;
        LineAnt: Decimal;
        Primero: Boolean;
        LineControl: Decimal;
        aa: Decimal;
        tmoviva2: Record "VAT Entry";
        ImportesIva: array[4, 2] of Code[1024];
        NomIva: array[4] of Code[1024];
        ValIva: array[4] of Decimal;
        j: Integer;
        q: Integer;
        ImpIVas: Decimal;
        ImpIvasText: Code[1024];
        gPrincipal: Boolean;
        Auxx: Integer;
        Agrego: Boolean;
        Iv21: Code[1024];
        Iv22: Code[1024];
        Entro: Boolean;
        Recshipment: Record "Sales Shipment Header";
        CodAlbaran: Code[1024];
        TotalIvaPerIBB: Decimal;
        MatrizIIBBPer: array[100, 2] of Text[1024];
        TotalBase: Decimal;
        porcentajeIVAPerIIBB: Decimal;
        porcentajeIVAPer: Decimal;
        TotalBaseIVAPer: Decimal;
        TotalIvaPer: Decimal;
        ImporteBase1: Decimal;
        // AW - begin
        ImporteBase2: Decimal;
        // AW - end
        PorcentajeIVA: Decimal;
        Sumaporciibb: Decimal;
        sumaporciva: Decimal;
        ImportePercIIBB: Decimal;
        ImportePErcIVa: Decimal;
        jurisdiccionactual: Code[1024];
        "*******": Integer;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[1024];
        OrderNoText: Text[80];
        SalesPersonText: Text[1024];
        VATNoText: Text[80];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        OutputNo: Integer;
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";//"Sales Inv.-Printed";
        Text003: Label 'COPY';
        Text004: Label 'Sales - Invoice %1';
        Text005: Label 'Page %1';
        Tex: Text[1024];
        fechavencimiento: Text[50];
        CP_CaptionLbl: Label 'CP:';
        Fecha_CaptionLbl: Label 'Fecha:';
        Ingresos_Brutos_C_M__CaptionLbl: Label 'Ingresos Brutos C.M.:';
        Tel_CaptionLbl: Label 'Tel:';
        ACaptionLbl: Label 'A';
        Precio_UnitarioCaptionLbl: Label 'Precio';
        Precio_TotalCaptionLbl: Label 'Importe';
        "DescripciónCaptionLbl": Label 'Descripción';
        CantidadCaptionLbl: Label 'Cantidad';
        Nombre_CaptionLbl: Label 'Sres.:';
        Nro_CaptionLbl: Label 'Nro:';
        CodigoCaptionLbl: Label 'Codigo';
        DespachoCaptionLbl: Label 'Despacho';
        Bon__1CaptionLbl: Label 'Bon.';
        Orden_de_Compra_CaptionLbl: Label 'Orden de Compra:';
        Cond__de_ventaCaptionLbl: Label 'Cond. de venta';
        VendedorCaptionLbl: Label 'Vendedor';
        Codigo_01CaptionLbl: Label 'Codigo 01';
        Inicio_de_ActividadesCaptionLbl: Label 'Inicio de Actividades';
        Bank__TransferCaptionLbl: Label 'Forma de Pago';
        TipoCaptionLbl: Label 'Tipo Impuesto';
        C_A_E_CaptionLbl: Label 'C.A.E.';
        Vto__CaptionLbl: Label 'Vencimiento:';
        SubtotalCaptionLbl: Label 'Subtotal';
        I_V_A__InscriptoCaptionLbl: Label 'I.V.A. Inscripto';
        I_V_A__No_InscriptoCaptionLbl: Label 'I.V.A. No Inscripto';
        Percepcion_I_V_A_CaptionLbl: Label 'Percepcion I.V.A.';
        Perc__Ingr__BrutosCaptionLbl: Label 'Perc. Ingr. Brutos';
        TOTALCaptionLbl: Label 'TOTAL';
        COMPROBANTES_REFERENCIADOS_CaptionLbl: Label 'COMPROBANTES REFERENCIADOS:';
        OBSERVACION_CaptionLbl: Label 'OBSERVACION:';
        Sub_TotalCaptionLbl: Label 'Sub Total';
        DescuentoCaptionLbl: Label 'Descuento';
        Total_NetoCaptionLbl: Label 'Total Neto';
        DocNUMAF: Text;
        leyenda2: Text[100];
        NoRemito: Code[1024];
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        NombreProv: Text[200];

        TImpuestos1: Text[200];
        TImpuestos2: Text[200];
        TImpuestos3: Text[200];
        TImpuestos4: Text[200];
        TImpuestos5: Text[200];
        TImpuestos6: Text[200];
        TImpuestos7: Text[200];
        TImpuestos8: Text[200];
        TImpuestos9: Text[200];
        TImpuestos10: Text[200];
        VImpuestos1: Decimal;
        VImpuestos2: Decimal;
        VImpuestos3: Decimal;
        VImpuestos4: Decimal;
        VImpuestos5: Decimal;
        VImpuestos6: Decimal;
        VImpuestos7: Decimal;
        VImpuestos8: Decimal;
        VImpuestos9: Decimal;
        VImpuestos10: Decimal;
        IIBBTImpuestos1: Text[200];
        IIBBTImpuestos2: Text[200];
        IIBBTImpuestos3: Text[200];
        IIBBTImpuestos4: Text[200];
        IIBBVImpuestos1: Decimal;
        IIBBVImpuestos2: Decimal;
        IIBBVImpuestos3: Decimal;
        IIBBVImpuestos4: Decimal;

        tipoIIBB: text[250];
        NumeroLote: code[20];
        tituloLote: Code[50];
        NoArticulo: code[20];

        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        CompanyCBU: Text[250];
        CompanyAlias: Text[250];
        simboloMoneda: text;

    procedure "#InicializaVariables"();
    begin
        gDescuento := 0;
        gDescuento1 := 0;
        gTotNetoT := 0;
        gTotalNeto := 0;
    end;

    procedure acumularImpuesto(var arrImpuestos: array[10] of text[200]; var arrValores: array[10] of decimal; VATBookCode: text[200]; montoIVA: decimal)
    var
        iter: Integer;
        encontro: Boolean;
        salir: Boolean;
    begin

        iter := 1;
        while (iter <= 10) and (not salir) do begin
            if arrImpuestos[iter] = '' then begin
                encontro := false;
                salir := true;
            end
            else begin

                if arrImpuestos[iter] = VATBookCode then begin
                    arrValores[iter] := arrValores[iter] + montoIVA * -1;
                    encontro := true;
                    salir := true;
                end
            end;
            iter := iter + 1;
        end;

        if (not encontro) and (iter <= 10) then begin
            arrImpuestos[iter - 1] := VATBookCode;
            arrValores[iter - 1] := arrValores[iter - 1] + montoIVA * -1;
        end;
    end;

    procedure IIBBacumularImpuesto(var IIBBarrImpuestos: array[10] of text[200]; var IIBBarrValores: array[10] of decimal; VATBookCode: text[200]; montoIVA: decimal)
    var
        iter: Integer;
        encontro: Boolean;
        salir: Boolean;
    begin

        iter := 1;
        while (iter <= 10) and (not salir) do begin
            if IIBBarrImpuestos[iter] = '' then begin
                encontro := false;
                salir := true;
            end
            else begin

                if IIBBarrImpuestos[iter] = VATBookCode then begin
                    IIBBarrValores[iter] := IIBBarrValores[iter] + montoIVA;
                    encontro := true;
                    salir := true;
                end
            end;
            iter := iter + 1;
        end;

        if (not encontro) and (iter <= 10) then begin
            IIBBarrImpuestos[iter - 1] := VATBookCode;
            IIBBarrValores[iter - 1] := IIBBarrValores[iter - 1] + montoIVA;
        end;
    end;

    procedure buscarloteserie(salesLineNo: Record "Sales Cr.Memo Line") numeroLOTSER: text
    var
        valueEntry: Record "Value Entry";
        "Return Receipt Header": Record "Return Receipt Header";
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
                                if (valueEntry."Document No." = salesLineNo."Document No.") then BEGIN
                                    IF ("Item Ledger Entry"."Lot No." <> '') THEN BEGIN
                                        tituloLote := 'LOTE';
                                        numeroLOTSER := numeroLOTSER + "Item Ledger Entry"."Lot No." + "Item Ledger Entry"."Serial No." + '|';
                                    END;
                                    IF ("Item Ledger Entry"."Serial No." <> '') THEN BEGIN
                                        tituloLote := 'SERIE';
                                        numeroLOTSER := numeroLOTSER + "Item Ledger Entry"."Lot No." + "Item Ledger Entry"."Serial No." + '|';
                                    END;
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
}


