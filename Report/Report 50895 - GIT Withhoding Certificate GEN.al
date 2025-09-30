report 80895 "PersGIT Withhoding Certificat"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107534 - GIT Withholding Certificate GEN.rdl';

    Caption = 'Certificado de IIBB GEN',
                ;

    dataset
    {
        dataitem("Withholding Ledger Entry"; "GMLocWithholding Ledger Entry")
        {
            DataItemTableView = SORTING("GMLocNo.");
            //RequestFilterFields = "GMLocNo.";
            RequestFilterFields = "GMLocWithh. Certificate No.";
            column(InfoEmpresa_Name; InfoEmpresa.BssiLegalNameFull)
            {
            }
            column(InfoEmpresa_Picture_hdr; InfoEmpresa.BssiPicture)
            {
            }
            column(InfoEmpresa_LocARAddress; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa.BssiBillingZipCode + ', ' + InfoEmpresa.BssiBillingCity + ', ' + gProvincia + ', ' + InfoEmpresa.BssiBillingCountry)
            {
            }
            column(InfoEmpresa__Phone_No__; InfoEmpresa.BssiBillingPhoneNumber)
            {
            }
            column(InfoEmpresa__E_Mail_; InfoEmpresa.BssiEmail)
            {
            }
            column(InfoEmpresa__Home_Page_; InfoEmpresa.BssiHomePage)
            {
            }
            column(InfoEmpresa_Address; direccionEmpresa)
            {
            }
            column(InfoEmpresa__Address_2_; InfoEmpresa.BssiBillingAddress2)
            {
            }
            column(InfoEmpresa__VAT_Registration_No__; InfoEmpresa.BssiRegistrationNo)
            {
            }
            column(InfoEmpresa__N__agente_retenci_n_; InfoEmpresa.BssiGrossIncomeNo)
            {
            }
            column(InfoEmpresa_Provincia; InfoEmpresa.BssiProvinceCode)
            {
            }
            column(Proveedor__No__ingresos_brutos_; Proveedor."GMLocGross Income Tax No")
            {
            }
            column(Proveedor__VAT_Registration_No__; Proveedor."VAT Registration No.")
            {
            }
            column(Proveedor_Address; direccionProveedor)
            {
            }
            column(Proveedor_Name; Proveedor.Name)
            {
            }
            column(Movimiento_Retenciones__N__Certificado_Retencion_; prueba)
            {
            }
            column(Movimiento_Retenciones__Fecha_comprobante_; GMLocDocumentDate)
            {
            }
            column(Provincia__Descripci_n_; InfoEmpresa.BssiProvinceCode)
            {
            }
            column(DetRetencion_Titulo; DetRetencion.GMLocTitle)
            {
            }
            column(Text1; Text1)
            {
            }
            column(Text2; Text2)
            {
            }
            column(Tipo_fiscal__Description; "Tipo fiscal".GMLocDescription)
            {
            }
            column(Descripcion; Descripcion)
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_; "Withholding Ledger Entry"."GMLocCalculation Base")
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_; "Withholding Ledger Entry"."GMLocWithholding Amount")
            {
            }
            column(alicuota; alicuota)
            {
            }
            column(minimo; minimo)
            {
            }
            column(gblProvincia; gblProvincia)
            {
            }
            column(AGENTE_DE_RETENCIONCaption; AGENTE_DE_RETENCIONCaptionLbl)
            {
            }
            column(Direcci_nCaption; Direcci_nCaptionLbl)
            {
            }
            column(Nro__de_CUITCaption; Nro__de_CUITCaptionLbl)
            {
            }
            column(Agente_Retenci_nCaption; Agente_Retenci_nCaptionLbl)
            {
            }
            column(Juridisdicci_nCaption; Juridisdicci_nCaptionLbl)
            {
            }
            column(Nro__de_IIBBCaption; Nro__de_IIBBCaptionLbl)
            {
            }
            column(Nro__de_CUITCaption_Control1000000018; Nro__de_CUITCaption_Control1000000018Lbl)
            {
            }
            column(Direcci_nCaption_Control1000000021; Direcci_nCaption_Control1000000021Lbl)
            {
            }
            column(SUJETO_DE_RETENCIONCaption; SUJETO_DE_RETENCIONCaptionLbl)
            {
            }
            column(Certificado_N_Caption; Certificado_N_CaptionLbl)
            {
            }
            column(FechaCaption; FechaCaptionLbl)
            {
            }
            column(Jurisdicci_nCaption; Jurisdicci_nCaptionLbl)
            {
            }
            column(RETENCIONCaption; RETENCIONCaptionLbl)
            {
            }
            column(B__IMPONIBLECaption; B__IMPONIBLECaptionLbl)
            {
            }
            column(ALICUOTACaption; ALICUOTACaptionLbl)
            {
            }
            column(MINIMOCaption; MINIMOCaptionLbl)
            {
            }
            column(RETENIDOCaption; RETENIDOCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000041; EmptyStringCaption_Control1000000041Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000042; EmptyStringCaption_Control1000000042Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000046; EmptyStringCaption_Control1000000046Lbl)
            {
            }
            column("jurisdicciónCaption"; jurisdicciónCaptionLbl)
            {
            }
            column(Sit__ante_IVA_Caption; Sit__ante_IVA_CaptionLbl)
            {
            }
            column(Withholding_Ledger_Entry_No_; "GMLocNo.")
            {
            }
            column(Withholding_Ledger_Entry_Voucher_Number; "GMLocVoucher Number")
            {
            }
            column(GMLocPictureSign; "GMLocTreasury Setup".GMLocSignPicture)
            {
            }
            dataitem("Posted Payment Order Vouchers"; "GMLocPosted Payment Ord Vouch")
            {
                DataItemLink = "GMLocPayment Order No." = FIELD("GMLocVoucher Number");
                DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.") ORDER(Ascending);
                column(Movimiento_Retenciones__Valor; "Withholding Ledger Entry".GMLocValue)
                {
                }
                column(Acumulado; Acumulado)
                {
                }
                column(Hist_Lin_Comp_OPago__Nro_Comprobante_; "GMLocVoucher No.")
                {
                }
                column(movfac__External_Document_No__; movfac."External Document No.")
                {
                }
                column(tipocomp; tipocomp)
                {
                }
                column(Hist_Lin_Comp_OPago__Nro_O_Pago_; "GMLocPayment Order No.")
                {
                }
                column("Movimiento_Retenciones__NombreRetención"; "Withholding Ledger Entry".GMLocWithholdingName)
                {
                }
                column(Movimiento_Retenciones__Valor_Control1000000056; "Withholding Ledger Entry".GMLocValue)
                {
                }
                column(Movimiento_Retenciones___Base_de_calculo_; "Withholding Ledger Entry"."GMLocCalculation Base")
                {
                }
                column(alicuota_Control1000000066; alicuota)
                {
                }
                column(Movimiento_Retenciones___Importe_retencion_; "Withholding Ledger Entry"."GMLocWithholding Amount")
                {
                }
                column(Movimiento_Retenciones___Base_de_calculo__Control1000000068; "Withholding Ledger Entry"."GMLocCalculation Base")
                {
                }
                column(InfoEmpresa_Picture2; InfoEmpresa.BssiPicture)
                {
                }
                column(ReferenciaCaption; ReferenciaCaptionLbl)
                {
                }
                column(Cod__Retenci_nCaption; Cod__Retenci_nCaptionLbl)
                {
                }
                column(Base_ImponibleCaption; Base_ImponibleCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000047; EmptyStringCaption_Control1000000047Lbl)
                {
                }
                column(Nro__FacturaCaption; Nro__FacturaCaptionLbl)
                {
                }
                column(Tipo_CompCaption; Tipo_CompCaptionLbl)
                {
                }
                column(Hist_Lin_Comp_OPago__Nro_O_Pago_Caption; FIELDCAPTION("GMLocPayment Order No."))
                {
                }
                column(Declaraci_n_en_la_que_se_informar__la_retencion__Caption; Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl)
                {
                }
                column(RETENCIONCaption_Control1000000055; RETENCIONCaption_Control1000000055Lbl)
                {
                }
                column(ALICUOTACaption_Control1000000057; ALICUOTACaption_Control1000000057Lbl)
                {
                }
                column(B__IMPONIBLECaption_Control1000000058; B__IMPONIBLECaption_Control1000000058Lbl)
                {
                }
                column(TOTAL_IMPONIBLECaption; TOTAL_IMPONIBLECaptionLbl)
                {
                }
                column(MONTO_RETENIDOCaption; MONTO_RETENIDOCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000061; EmptyStringCaption_Control1000000061Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000062; EmptyStringCaption_Control1000000062Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000064; EmptyStringCaption_Control1000000064Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000069; EmptyStringCaption_Control1000000069Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000070; EmptyStringCaption_Control1000000070Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000071; EmptyStringCaption_Control1000000071Lbl)
                {
                }
                column(DataItem1000000072; Declaro_que_los_datos_consignados_en_este_certific)
                {
                }
                column("alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_Caption"; alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_CaptionLbl)
                {
                }
                column("FIRMA_DEL_AGENTE_DE_RETENCIÓNCaption"; FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000006; EmptyStringCaption_Control1000000006Lbl)
                {
                }
                column("ACLARACIÓN_CARGOCaption"; ACLARACIÓN_CARGOCaptionLbl)
                {
                }
                column(Posted_Payment_Order_Vouchers_Entry_No_; "GMLocEntry No.")
                {
                }

                trigger OnAfterGetRecord();
                var
                    Facturas: Record "Purch. Inv. Header";
                    LineasFactura: Record "Purch. Inv. Line";
                    Comportamiento: Record "GMLocWithholding Kind Line";
                    DetRetencion: Record "GMLocWithholding Datail";
                    retencion: Record "GMLocWithholding Calculation";
                    ControlProv: Boolean;
                    Escala: Record "GMLocWithholding Scale";
                    caja: Code[20];
                    Valores: Record GMLocValues;
                    retencionesempresa: Record GMLocTaxes;
                    CodCondicion: Code[20];
                    CondImpuesto: Record "GMLocVendor Condition";
                    PorcMonto: Decimal;
                    MovRetencion: Record "GMLocWithholding Ledger Entry";
                    act_retencion: Record "GMLocWithholding Calculation";
                    exencion: Record "GMLocWithholding Exention";
                    CondImpositiva: Record "GMLocTax Conditions";
                    CodCondSICORE: Code[3];
                    inicio_mes: Date;
                    fin_mes: Date;
                    ProximoMovimiento: Integer;
                    ControlValor: Boolean;
                    LinValores: Record "GMLocPayment Order Value Line";
                    PaymentOrderValue: record "GMLocPosted Payment Order Valu";
                begin
                    Acumulado := 0;
                    ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                    PaymentOrderValue.Reset();
                    PaymentOrderValue.SetFilter("GMLocPayment Order No.", "Withholding Ledger Entry"."GMLocVoucher Number");
                    PaymentOrderValue.SetFilter(PaymentOrderValue."GMLocSeries Code", "Withholding Ledger Entry"."GMLocWithholding Serie Code");
                    if (PaymentOrderValue.FindFirst()) then
                        prueba := PaymentOrderValue."GMLocValue No.";

                    Facturas.RESET;
                    Facturas.SETCURRENTKEY("No.");
                    Facturas.SETRANGE(Facturas."No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                    if Facturas.FINDFIRST then begin
                        Facturas.CALCFIELDS("Amount Including VAT");
                        //Calculo porcentaje del pago sobre el total de la factura
                        if Facturas."Currency Factor" <> 0 then
                            PorcMonto := (("GMLocAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                        else
                            PorcMonto := (("GMLocAmount (LCY)" * 100) / Facturas."Amount Including VAT");

                        LineasFactura.RESET;
                        LineasFactura.SETCURRENTKEY("Document No.", "Line No.");
                        LineasFactura.SETRANGE("Document No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                        if LineasFactura.FINDFIRST then begin
                            repeat
                                Comportamiento.RESET;
                                Comportamiento.SETCURRENTKEY("GMLocWithholding No.", "GMLocWithholding Code");
                                Comportamiento.SETRANGE(Comportamiento."GMLocWithholding Code", LineasFactura."GMLocWithholding Code");
                                Comportamiento.SETRANGE(Comportamiento."GMLocTax System", "Withholding Ledger Entry"."GMLocTax System");
                                Comportamiento.SETRANGE(Comportamiento."GMLocWithholding No.", "Withholding Ledger Entry"."GMLocWithholding No.");//NAVAR1.06
                                if Comportamiento.FINDFIRST then begin
                                    DetRetencion.RESET;
                                    DetRetencion.SETCURRENTKEY("GMLocWithholding No.", "GMLocTax Code", "GMLocTax System");
                                    DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", Comportamiento."GMLocWithholding No.");
                                    if DetRetencion.FINDFIRST then begin
                                        ///Control de Valor en Detalle de Retención
                                        //if DetRetencion.GMLocValue = '' then
                                        //    ControlValor := false
                                        //else
                                        ControlValor := true;

                                        if ControlValor then begin

                                            ///Controlo que sea una retencion de la empresa
                                            retencionesempresa.RESET;
                                            retencionesempresa.SETCURRENTKEY("GMLocTax Code");
                                            retencionesempresa.SETRANGE(retencionesempresa."GMLocTax Code", DetRetencion."GMLocTax Code");
                                            if retencionesempresa.FINDFIRST then
                                                if retencionesempresa.GMLocRetains = true then begin
                                                    ControlProv := false;
                                                    if retencionesempresa.GMLocProvince = '' then
                                                        ControlProv := true
                                                    else
                                                        if (Facturas.GMLocProvince <> '') and (Facturas.GMLocProvince = retencionesempresa.GMLocProvince) then
                                                            ControlProv := true
                                                end;

                                            ///Control de la condicion de retencion del proveedor
                                            CondImpuesto.RESET;
                                            CondImpuesto.SETCURRENTKEY("GMLocVendor Code", "GMLocTax Code", "GMLocTax Condition");
                                            CondImpuesto.SETRANGE(CondImpuesto."GMLocTax Code", DetRetencion."GMLocTax Code");
                                            CondImpuesto.SETRANGE(CondImpuesto."GMLocVendor Code", "Posted Payment Order Vouchers".GMLocVendor);
                                            if CondImpuesto.FINDFIRST then
                                                CodCondicion := CondImpuesto."GMLocTax Condition";

                                            if ControlProv then begin
                                                Escala.RESET;
                                                Escala.SETCURRENTKEY("GMLocScale Code", "GMLocWithholding Condition", "GMLocTax Code", GMLocFrom);
                                                Escala.SETRANGE(Escala."GMLocScale Code", DetRetencion."GMLocScale Code");
                                                Escala.SETRANGE(Escala."GMLocWithholding Condition", CodCondicion);
                                                if Escala.FINDFIRST then begin
                                                    case DetRetencion."GMLocWithholding Base Type" of
                                                        DetRetencion."GMLocWithholding Base Type"::"Sin Impuestos":
                                                            if Facturas."Currency Factor" <> 0 then
                                                                Acumulado := ((PorcMonto * (LineasFactura."VAT Base Amount" / Facturas."Currency Factor")) / 100) +
                                                                                         Acumulado
                                                            else
                                                                Acumulado := ((PorcMonto * LineasFactura."VAT Base Amount") / 100) +
                                                                                    Acumulado;

                                                        DetRetencion."GMLocWithholding Base Type"::"Importe Impuestos":
                                                            if Facturas."Currency Factor" <> 0 then
                                                                Acumulado := ((PorcMonto * ((LineasFactura."Amount Including VAT" / Facturas."Currency Factor")
                                                                                    - (LineasFactura."VAT Base Amount" / Facturas."Currency Factor"))) / 100) +
                                                                                       Acumulado
                                                            else
                                                                Acumulado := ((PorcMonto * (LineasFactura."Amount Including VAT"
                                                                                     - LineasFactura."VAT Base Amount")) / 100) + Acumulado;

                                                        DetRetencion."GMLocWithholding Base Type"::"Importe Total":
                                                            if Facturas."Currency Factor" <> 0 then
                                                                Acumulado := ((PorcMonto * (LineasFactura."Amount Including VAT" / Facturas."Currency Factor")) / 100) +
                                                                                         Acumulado
                                                            else
                                                                Acumulado := ((PorcMonto * LineasFactura."Amount Including VAT") / 100) +
                                                                                     Acumulado;
                                                    end;

                                                end;
                                            end;
                                        end;
                                    end;

                                end;
                                //NAVAR1.06002-
                                Acumulado := ROUND(Acumulado, 0.01);
                            //NAVAR1.06002+
                            until LineasFactura.NEXT = 0;
                        end;

                    end;

                    movfac.RESET;
                    movfac.SETCURRENTKEY("Entry No.");
                    movfac.SETRANGE(movfac."Document No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                    ok := movfac.FINDFIRST;

                    tipocomp := '';
                    if (movfac."Document Type" = movfac."Document Type"::Invoice) then begin
                        tipocomp := 'FC';
                        //ImporteNC := FindApplicCreditMemo("Hist Lin Comp OPago"."Nro Comprobante");
                    end;
                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                        tipocomp := 'NC';

                    if (movfac."Document Type" = movfac."GMLocDocument Type Loc."::"Nota Débito") then
                        tipocomp := 'ND';

                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                        Acumulado := -Acumulado;

                    CLEAR(TOTAL);

                    //IF("Hist Lin Comp OPago"."Existe ApplNC")THEN
                    // TOTAL := Acumulado
                    //ELSE
                    // TOTAL := Acumulado + ImporteNC;
                    if (HOPago.GET("Posted Payment Order Vouchers"."GMLocPayment Order No.")) then
                        if (HOPago."GMLocNew Payment") then
                            Acumulado := "Posted Payment Order Vouchers".GMLocCancelled;

                    //AcumTotal := AcumTotal + Acumulado;

                    "Withholding Ledger Entry"."GMLocCalculation Base" := ROUND("Withholding Ledger Entry"."GMLocCalculation Base");
                    if Acumulado = 0 then
                        CurrReport.SKIP;
                end;
            }

            trigger OnAfterGetRecord();
            var
                BssiMEMSystemSetup: record BssiMEMSystemSetup;
            begin

                if (COPYSTR("Withholding Ledger Entry"."GMLocTax Code", 1, 2) = 'IB') then begin
                    Text1 := 'JURISDICCION:';
                    if (prov.GET("Withholding Ledger Entry"."GMLocProvince Code")) then
                        Text2 := prov.GMLocDescription;

                    /*if (glbImpuestos.GET("Withholding Ledger Entry"."GMLocTax Code")) then
                        if (prov.GET(glbImpuestos.GMLocProvince)) then
                            Text2 := prov.GMLocDescription;*/
                end;


                gblProvincia := '';
                DetRetencion.RESET;
                DetRetencion.SETCURRENTKEY("GMLocWithholding No.", "GMLocTax Code", "GMLocTax System");
                DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", "Withholding Ledger Entry"."GMLocWithholding No.");
                if DetRetencion.FINDFIRST then
                    Descripcion := DetRetencion.GMLocDescription;

                Escala.RESET;
                Escala.SETCURRENTKEY("GMLocScale Code", "GMLocWithholding Condition", "GMLocTax Code", GMLocFrom);
                Escala.SETRANGE(Escala."GMLocScale Code", "Withholding Ledger Entry"."GMLocScale Code");
                Escala.SETRANGE(Escala."GMLocWithholding Condition", "Withholding Ledger Entry"."GMLocCondition Code");
                Escala.SETRANGE(Escala."GMLocTax Code", "Withholding Ledger Entry"."GMLocTax Code");
                if Escala.FINDFIRST then
                    repeat
                        if (Escala.GMLocFrom <= "Withholding Ledger Entry"."GMLocCalculation Base") then begin
                            alicuota := Escala."GMLocExcedent %";
                            minimo := Escala.GMLocFrom;
                        end;
                    until Escala.NEXT = 0;

                //NAVAR1.06001-
                Provincia.RESET;
                Provincia.SETCURRENTKEY("GMLocProvince Code");
                Provincia.SETRANGE("GMLocProvince Code", "GMLocProvince Code");
                if Provincia.FINDFIRST then
                    gblProvincia := Provincia.GMLocDescription
                else
                    gblProvincia := '';
                //11807+
                "Withholding Kind Line".RESET;
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocWithholding Code", "Withholding Ledger Entry"."GMLocWithholding Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocTax Code", "Withholding Ledger Entry"."GMLocTax Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocIs vendor withholding", true);
                if ("Withholding Kind Line".FINDFIRST) then begin
                    if ("Withholding Ledger Entry"."Vendor withholding" <> '') then begin
                        Proveedor.RESET;
                        Proveedor.SETCURRENTKEY("No.");
                        Proveedor.SETRANGE("No.", "Withholding Ledger Entry"."Vendor withholding");
                        if Proveedor.FINDFIRST then;
                    end
                    else begin
                        Proveedor.RESET;
                        Proveedor.SETCURRENTKEY("No.");
                        Proveedor.SETRANGE("No.", "GMLocVendor Code");
                        if Proveedor.FINDFIRST then;
                    end;
                end
                else begin
                    Proveedor.RESET;
                    Proveedor.SETCURRENTKEY("No.");
                    Proveedor.SETRANGE("No.", "GMLocVendor Code");
                    if Proveedor.FINDFIRST then;
                end;
                //11807-

                if (Proveedor.Address <> '') then direccionProveedor := Proveedor.Address;
                if (Proveedor.City <> '') then direccionProveedor := direccionProveedor + ',  ' + Proveedor.City;
                if (Proveedor."Post Code" <> '') then direccionProveedor := direccionProveedor + ', C.P. ' + Proveedor."Post Code";
                if (Proveedor."Country/Region Code" <> '') then begin
                    maestroPais.Reset();
                    maestroPais.SetFilter(Code, Proveedor."Country/Region Code");
                    if maestroPais.FindFirst() then direccionProveedor := direccionProveedor + ', ' + maestroPais.Name;
                end;

                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Withholding Ledger Entry"."GMLocShortcut Dimension 1");
                IF (InfoEmpresa.FindFirst()) THEN;
                InfoEmpresa.CALCFIELDS(InfoEmpresa.BssiPicture);
                InfoEmpresa.CALCFIELDS(BssiPicture);

                RecProvincia.RESET;
                RecProvincia.SETCURRENTKEY(RecProvincia."GMLocProvince Code");
                RecProvincia.SETRANGE("GMLocProvince Code", InfoEmpresa.BssiProvinceCode);
                if RecProvincia.FINDFIRST then
                    gProvincia := RecProvincia.GMLocDescription;

                if (InfoEmpresa.BssiBillingAddr1 <> '') then direccionEmpresa := InfoEmpresa.BssiBillingAddr1;
                if (InfoEmpresa.BssiBillingCity <> '') then direccionEmpresa := direccionEmpresa + ',  ' + InfoEmpresa.BssiBillingCity;
                if (InfoEmpresa."BssiBillingZipCode" <> '') then direccionEmpresa := direccionEmpresa + ', C.P. ' + InfoEmpresa.BssiBillingZipCode;
                if (InfoEmpresa.BssiBillingCountry <> '') then begin
                    maestroPais.Reset();
                    maestroPais.SetFilter(Code, InfoEmpresa.BssiBillingCountry);
                    if maestroPais.FindFirst() then direccionEmpresa := direccionEmpresa + ', ' + maestroPais.Name;
                end;

                //NAVAR1.06001+
                if ("Tipo fiscal".GET(Proveedor."GMLocFiscal Type")) then;
            end;

            trigger OnPreDataItem();
            begin
                /*ok := InfoEmpresa.FINDFIRST;
                InfoEmpresa.CALCFIELDS(GMLocPicture2);*/
                "GMLocTreasury Setup".GET();
                "GMLocTreasury Setup".CALCFIELDS(GMLocSignPicture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        InfoEmpresa: Record "Dimension Value";
        Proveedor: Record Vendor;
        ok: Boolean;
        Descripcion: Text[100];
        DetRetencion: Record "GMLocWithholding Datail";
        Escala: Record "GMLocWithholding Scale";
        alicuota: Decimal;
        minimo: Decimal;
        Provincia: Record GMLocProvince;
        Retenciones: Codeunit GMLocRetenciones;
        retencion: Record "GMLocWithholding Calculation";
        Acumulado: Decimal;
        movfac: Record "Vendor Ledger Entry";
        "GMLocTreasury Setup": Record "GMLocTreasury Setup";
        gblProvincia: Text[50];
        "Tipo fiscal": Record "GMLocFiscal Type";
        globImpuestos: Record GMLocTaxes;
        Text1: Text[30];
        Text2: Text[30];
        glbImpuestos: Record GMLocTaxes;
        prov: Record GMLocProvince;
        TOTAL: Decimal;
        TOTALNC: Decimal;
        tipocomp: Text[30];
        HOPago: Record "GMLocPosted Payment Order";
        "Withholding Kind Line": Record "GMLocWithholding Kind Line";
        AGENTE_DE_RETENCIONCaptionLbl: Label 'AGENTE DE RETENCION';
        Direcci_nCaptionLbl: Label 'Dirección';
        Nro__de_CUITCaptionLbl: Label 'Nro. de CUIT';
        Agente_Retenci_nCaptionLbl: Label 'Agente Retención';
        Juridisdicci_nCaptionLbl: Label 'jurisdicción';
        Nro__de_IIBBCaptionLbl: Label 'Nro. de IIBB';
        Nro__de_CUITCaption_Control1000000018Lbl: Label 'Nro. de CUIT';
        Direcci_nCaption_Control1000000021Lbl: Label 'Dirección';
        SUJETO_DE_RETENCIONCaptionLbl: Label 'SUJETO DE RETENCION';
        Certificado_N_CaptionLbl: Label 'Certificado Nº';
        FechaCaptionLbl: Label 'Fecha';
        Jurisdicci_nCaptionLbl: Label 'Jurisdicción';
        RETENCIONCaptionLbl: Label 'RETENCION';
        B__IMPONIBLECaptionLbl: Label 'B. IMPONIBLE';
        ALICUOTACaptionLbl: Label 'ALICUOTA';
        MINIMOCaptionLbl: Label 'MINIMO';
        RETENIDOCaptionLbl: Label 'RETENIDO';
        EmptyStringCaptionLbl: Label '*';
        EmptyStringCaption_Control1000000041Lbl: Label '*';
        EmptyStringCaption_Control1000000042Lbl: Label '-';
        EmptyStringCaption_Control1000000046Lbl: Label '-';
        "jurisdicciónCaptionLbl": Label 'JURISDICCIÓN';
        Sit__ante_IVA_CaptionLbl: Label 'Sit. ante IVA:';
        ReferenciaCaptionLbl: Label 'Referencia';
        Cod__Retenci_nCaptionLbl: Label 'Cod. Retención';
        Base_ImponibleCaptionLbl: Label 'Base Imponible';
        EmptyStringCaption_Control1000000047Lbl: Label '-';
        Nro__FacturaCaptionLbl: Label 'Nro. Factura';
        Tipo_CompCaptionLbl: Label 'Tipo Comp';
        Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl: Label 'Declaración en la que se informará la retencion :';
        RETENCIONCaption_Control1000000055Lbl: Label 'RETENCION';
        ALICUOTACaption_Control1000000057Lbl: Label 'ALICUOTA';
        B__IMPONIBLECaption_Control1000000058Lbl: Label 'B. IMPONIBLE';
        TOTAL_IMPONIBLECaptionLbl: Label 'TOTAL IMPONIBLE';
        MONTO_RETENIDOCaptionLbl: Label 'MONTO RETENIDO';
        EmptyStringCaption_Control1000000061Lbl: Label '-';
        EmptyStringCaption_Control1000000062Lbl: Label '-';
        EmptyStringCaption_Control1000000064Lbl: Label '$';
        EmptyStringCaption_Control1000000069Lbl: Label '$';
        EmptyStringCaption_Control1000000070Lbl: Label '$';
        EmptyStringCaption_Control1000000071Lbl: Label '%';
        Declaro_que_los_datos_consignados_en_este_certific: Label 'Declaro que los datos consignados en este certificado son correctos y completos, y que he confeccionado la presente sin omitir ni falsear dato ';
        "alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_CaptionLbl": Label 'alguno que deba contener, siendo fiel expresión de la verdad.';
        "FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl": Label 'FIRMA DEL AGENTE DE RETENCIÓN';
        EmptyStringCaption_Control1000000006Lbl: Label '____________________________________';
        "ACLARACIÓN_CARGOCaptionLbl": Label 'ACLARACIÓN/CARGO';
        gProvincia: Text[50];
        RecProvincia: Record GMLocProvince;
        direccionProveedor: Text[250];
        direccionEmpresa: Text[250];
        maestroPais: Record "Country/Region";
        prueba: Text[50];
}

