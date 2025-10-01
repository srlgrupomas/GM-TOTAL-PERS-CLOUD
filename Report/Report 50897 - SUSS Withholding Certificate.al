report 34006897 "PersSUSS Withholding Certific"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107480 - SUSS Withholding Certificate.rdl';


    dataset
    {
        dataitem("Withholding Ledger Entry"; "GMAWithholding Ledger Entry")
        {
            DataItemTableView = SORTING("GMANo.")
                                WHERE("GMATax Code" = const('SUSS'));
            //RequestFilterFields = "GMANo.";
            RequestFilterFields = "GMAWithh. Certificate No.";
            column(InfoEmpresa_Name; InfoEmpresa.BssiLegalNameFull)
            {
            }
            column(InfoEmpresa_Picture; InfoEmpresa.BssiPicture)
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
            column(InfoEmpresa__N__agente_retenci_n_; InfoEmpresa."BssiGrossIncomeNo")
            {
            }
            column(InfoEmpresa_Provincia; InfoEmpresa.BssiProvinceCode)
            {
            }
            column(Proveedor__No__ingresos_brutos_; Proveedor."GMAGross Income Tax No")
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
            column(Movimiento_Retenciones__N__Certificado_Retencion_; "GMAWithh. Certificate No.")
            {
            }
            column(Movimiento_Retenciones__Fecha_comprobante_; GMADocumentDate)
            {
            }
            column(Provincia__Descripci_n_; InfoEmpresa.BssiProvinceCode)
            {
            }
            column(Descripcion; Descripcion)
            {
            }
            column(Retencion_TaxSystem; Retencion_TaxSystem)
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_; "Withholding Ledger Entry"."GMACalculation Base")
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_; "Withholding Ledger Entry"."GMAWithholding Amount")
            {
            }
            column(alicuota; alicuota)
            {
            }
            column(minimo; minimo)
            {
            }
            column(CERTIFICADO_DE_RETENCION_SUSSCaption; CERTIFICADO_DE_RETENCION_SUSSCaptionLbl)
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
            column(Withholding_Ledger_Entry_No_; "GMANo.")
            {
            }
            column(Withholding_Ledger_Entry_Voucher_Number; "GMAVoucher Number")
            {
            }
            column("FIRMA_DEL_AGENTE_DE_RETENCIÓNCaption"; FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl)
            {
            }
            column(Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaption; Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl)
            {
            }
            column(que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_Caption; que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl)
            {
            }
            column("alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_Caption"; alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_CaptionLbl)
            {
            }
            column(InfoEmpresa_Picture2; InfoEmpresa.BssiPicture)
            {
            }
            column("ACLARACIÓN_CARGOCaption"; ACLARACIÓN_CARGOCaptionLbl)
            {
            }
            column(GMAPictureSign; "GMATreasury Setup".GMASignPicture)
            {
            }
            dataitem("Posted Payment Order Vouchers"; "GMAPosted Payment Ord Vouch")
            {
                DataItemLink = "GMAPayment Order No." = FIELD("GMAVoucher Number");
                DataItemTableView = SORTING("GMAPayment Order No.", "GMAVoucher No.") ORDER(Ascending);
                column(Movimiento_Retenciones__Valor; "Withholding Ledger Entry".GMAValue)
                {
                }
                column(Acumulado; Acumulado)
                {
                }
                column(Hist_Lin_Comp_OPago__Nro_Comprobante_; "GMAVoucher No.")
                {
                }
                column(movfac__External_Document_No__; movfac."External Document No.")
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
                column(Declaraci_n_en_la_que_se_informar__la_retencion__Caption; Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000049; EmptyStringCaption_Control1000000049Lbl)
                {
                }
                column(Posted_Payment_Order_Vouchers_Payment_Order_No_; "GMAPayment Order No.")
                {
                }
                column(Posted_Payment_Order_Vouchers_Entry_No_; "GMAEntry No.")
                {
                }

                trigger OnAfterGetRecord();
                var
                    Facturas: Record "Purch. Inv. Header";
                    LineasFactura: Record "Purch. Inv. Line";
                    Comportamiento: Record "GMAWithholding Kind Line";
                    DetRetencion: Record "GMAWithholding Datail";
                    retencion: Record "GMAWithholding Calculation";
                    ControlProv: Boolean;
                    Escala: Record "GMAWithholding Scale";
                    caja: Code[20];
                    Valores: Record GMAValues;
                    retencionesempresa: Record GMATaxes;
                    CodCondicion: Code[20];
                    CondImpuesto: Record "GMAVendor Condition";
                    PorcMonto: Decimal;
                    MovRetencion: Record "GMAWithholding Ledger Entry";
                    act_retencion: Record "GMAWithholding Calculation";
                    exencion: Record "GMAWithholding Exention";
                    CondImpositiva: Record "GMATax Conditions";
                    CodCondSICORE: Code[3];
                    inicio_mes: Date;
                    fin_mes: Date;
                    ProximoMovimiento: Integer;
                    ControlValor: Boolean;
                    LinValores: Record "GMAPayment Order Value Line";
                begin
                    Acumulado := 0;
                    ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                    Facturas.RESET;
                    Facturas.SETCURRENTKEY("No.");
                    Facturas.SETRANGE(Facturas."No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                    if Facturas.FINDFIRST then begin
                        Facturas.CALCFIELDS("Amount Including VAT");
                        //Calculo porcentaje del pago sobre el total de la factura
                        if Facturas."Currency Factor" <> 0 then
                            PorcMonto := (("GMAAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                        else
                            PorcMonto := (("GMAAmount (LCY)" * 100) / Facturas."Amount Including VAT");

                        LineasFactura.RESET;
                        LineasFactura.SETCURRENTKEY("Document No.", "Line No.");
                        LineasFactura.SETRANGE("Document No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                        if LineasFactura.FINDFIRST then begin
                            repeat
                                Comportamiento.RESET;
                                Comportamiento.SETCURRENTKEY("GMAWithholding No.", "GMAWithholding Code");
                                Comportamiento.SETRANGE(Comportamiento."GMAWithholding Code", LineasFactura."GMAWithholding Code");
                                Comportamiento.SETRANGE(Comportamiento."GMATax System", "Withholding Ledger Entry"."GMATax System");
                                Comportamiento.SETRANGE(Comportamiento."GMAWithholding No.", "Withholding Ledger Entry"."GMAWithholding No.");//NAVAR1.06
                                if Comportamiento.FINDFIRST then begin
                                    DetRetencion.RESET;
                                    DetRetencion.SETCURRENTKEY("GMAWithholding No.", "GMATax Code", "GMATax System");
                                    DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", Comportamiento."GMAWithholding No.");
                                    if DetRetencion.FINDFIRST then begin
                                        ///Control de Valor en Detalle de Retención
                                        if DetRetencion.GMAValue = '' then
                                            ControlValor := false
                                        else
                                            ControlValor := true;

                                        if ControlValor then begin

                                            ///Controlo que sea una retencion de la empresa
                                            retencionesempresa.RESET;
                                            retencionesempresa.SETCURRENTKEY("GMATax Code");
                                            retencionesempresa.SETRANGE(retencionesempresa."GMATax Code", DetRetencion."GMATax Code");
                                            if retencionesempresa.FINDFIRST then
                                                if retencionesempresa.GMARetains = true then begin
                                                    ControlProv := false;
                                                    if retencionesempresa.GMAProvince = '' then
                                                        ControlProv := true
                                                    else
                                                        if (Facturas.GMAProvince <> '') and (Facturas.GMAProvince = retencionesempresa.GMAProvince) then
                                                            ControlProv := true
                                                end;

                                            ///Control de la condicion de retencion del proveedor
                                            CondImpuesto.RESET;
                                            CondImpuesto.SETCURRENTKEY("GMAVendor Code", "GMATax Code", "GMATax Condition");
                                            CondImpuesto.SETRANGE(CondImpuesto."GMATax Code", DetRetencion."GMATax Code");
                                            CondImpuesto.SETRANGE(CondImpuesto."GMAVendor Code", "Posted Payment Order Vouchers".GMAVendor);
                                            if CondImpuesto.FINDFIRST then
                                                CodCondicion := CondImpuesto."GMATax Condition";
                                            if ControlProv then begin
                                                Escala.RESET;
                                                Escala.SETCURRENTKEY("GMAScale Code", "GMAWithholding Condition", "GMATax Code", GMAFrom);
                                                Escala.SETRANGE(Escala."GMAScale Code", DetRetencion."GMAScale Code");
                                                Escala.SETRANGE(Escala."GMAWithholding Condition", CodCondicion);
                                                if Escala.FINDFIRST then begin
                                                    case DetRetencion."GMAWithholding Base Type" of
                                                        DetRetencion."GMAWithholding Base Type"::"Sin Impuestos":
                                                            if Facturas."Currency Factor" <> 0 then
                                                                Acumulado := ((PorcMonto * (LineasFactura."VAT Base Amount" / Facturas."Currency Factor")) / 100) +
                                                                                         Acumulado
                                                            else
                                                                Acumulado := ((PorcMonto * LineasFactura."VAT Base Amount") / 100) +
                                                                                    Acumulado;

                                                        DetRetencion."GMAWithholding Base Type"::"Importe Impuestos":
                                                            if Facturas."Currency Factor" <> 0 then
                                                                Acumulado := ((PorcMonto * ((LineasFactura."Amount Including VAT" / Facturas."Currency Factor")
                                                                                    - (LineasFactura."VAT Base Amount" / Facturas."Currency Factor"))) / 100) +
                                                                                       Acumulado
                                                            else
                                                                Acumulado := ((PorcMonto * (LineasFactura."Amount Including VAT"
                                                                                     - LineasFactura."VAT Base Amount")) / 100) + Acumulado;

                                                        DetRetencion."GMAWithholding Base Type"::"Importe Total":
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
                    movfac.SETRANGE(movfac."Document No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                    ok := movfac.FINDFIRST;
                    tipocomp := '';
                    if (movfac."Document Type" = movfac."Document Type"::Invoice) then begin
                        tipocomp := 'FC';
                        //ImporteNC := FindApplicCreditMemo("Hist Lin Comp OPago"."Nro Comprobante");
                    end;
                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                        tipocomp := 'NC';

                    if (movfac."Document Type" = movfac."GMADocument Type Loc."::"GMANota Debito") then
                        tipocomp := 'ND';

                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                        Acumulado := -Acumulado;

                    CLEAR(TOTAL);

                    //IF("Hist Lin Comp OPago"."Existe ApplNC")THEN
                    // TOTAL := Acumulado
                    //ELSE
                    // TOTAL := Acumulado + ImporteNC;
                    if (HOPago.GET("Posted Payment Order Vouchers"."GMAPayment Order No.")) then
                        if (HOPago."GMANew Payment") then
                            Acumulado := "Posted Payment Order Vouchers".GMACancelled;

                    //AcumTotal := AcumTotal + Acumulado;

                    "Withholding Ledger Entry"."GMACalculation Base" := ROUND("Withholding Ledger Entry"."GMACalculation Base");

                    if Acumulado = 0 then
                        CurrReport.SKIP;
                end;
            }

            trigger OnAfterGetRecord();
            var
                BssiMEMSystemSetup: record BssiMEMSystemSetup;
            begin
                if (COPYSTR("Withholding Ledger Entry"."GMATax Code", 1, 2) = 'IB') then begin
                    Text1 := 'JURISDICCION:';
                    if (glbImpuestos.GET("Withholding Ledger Entry"."GMATax Code")) then
                        if (prov.GET(glbImpuestos.GMAProvince)) then
                            Text2 := prov.GMADescription;
                end;


                gblProvincia := '';
                DetRetencion.RESET;
                DetRetencion.SETCURRENTKEY("GMAWithholding No.", "GMATax Code", "GMATax System");
                DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", "Withholding Ledger Entry"."GMAWithholding No.");
                if DetRetencion.FINDFIRST then
                    Descripcion := DetRetencion.GMADescription;
                Retencion_TaxSystem := DetRetencion."GMATax System";
                Escala.RESET;
                Escala.SETCURRENTKEY("GMAScale Code", "GMAWithholding Condition", "GMATax Code", GMAFrom);
                Escala.SETRANGE(Escala."GMAScale Code", "Withholding Ledger Entry"."GMAScale Code");
                Escala.SETRANGE(Escala."GMAWithholding Condition", "Withholding Ledger Entry"."GMACondition Code");
                Escala.SETRANGE(Escala."GMATax Code", "Withholding Ledger Entry"."GMATax Code");
                if Escala.FINDFIRST then
                    repeat
                        if (Escala.GMAFrom <= "Withholding Ledger Entry"."GMACalculation Base") then begin
                            alicuota := Escala."GMAExcedent %";
                            minimo := Escala.GMAFrom;
                        end;
                    until Escala.NEXT = 0;


                //NAVAR1.06001-
                Provincia.RESET;
                Provincia.SETCURRENTKEY("GMAProvince Code");
                Provincia.SETRANGE("GMAProvince Code", "GMAProvince Code");
                if Provincia.FINDFIRST then;

                gProvincia := Provincia.GMADescription;
                //11807+
                "Withholding Kind Line".RESET;
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMAWithholding Code", "Withholding Ledger Entry"."GMAWithholding Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMATax Code", "Withholding Ledger Entry"."GMATax Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMAIs vendor withholding", true);
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
                        Proveedor.SETRANGE("No.", "GMAVendor Code");
                        if Proveedor.FINDFIRST then;
                    end;
                end
                else begin
                    Proveedor.RESET;
                    Proveedor.SETCURRENTKEY("No.");
                    Proveedor.SETRANGE("No.", "GMAVendor Code");
                    if Proveedor.FINDFIRST then;
                end;
                //11807-
                if (Proveedor.Address <> '') then direccionProveedor := Proveedor.Address;
                if (Proveedor.City <> '') then direccionProveedor := direccionProveedor + ',  ' + Proveedor.City;
                if (Proveedor."Post Code" <> '') then direccionProveedor := direccionProveedor + ', C.P. ' + Proveedor."Post Code";
                if (Proveedor."Country/Region Code" <> '') then begin
                    maestroPais.Reset();
                    maestroPais.SetFilter(Code, Proveedor."Country/Region Code");
                    if maestroPais.FindFirst() then direccionProveedor := direccionProveedor + ', ' + maestroPais.GetNameInCurrentLanguage();
                end;
                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Withholding Ledger Entry"."GMAShortcut Dimension 1");
                IF (InfoEmpresa.FindFirst()) THEN;
                InfoEmpresa.CALCFIELDS(InfoEmpresa.BssiPicture);
                Provincia.RESET;
                Provincia.SETCURRENTKEY(Provincia."GMAProvince Code");
                Provincia.SETRANGE("GMAProvince Code", InfoEmpresa.BssiProvinceCode);
                if Provincia.FINDFIRST then
                    gProvincia := Provincia.GMADescription;

                if (InfoEmpresa.BssiBillingAddr1 <> '') then direccionEmpresa := InfoEmpresa.BssiBillingAddr1;
                if (InfoEmpresa.BssiBillingCity <> '') then direccionEmpresa := direccionEmpresa + ',  ' + InfoEmpresa.BssiBillingCity;
                if (InfoEmpresa.BssiBillingZipCode <> '') then direccionEmpresa := direccionEmpresa + ', C.P. ' + InfoEmpresa.BssiBillingZipCode;
                if (InfoEmpresa.BssiBillingCountry <> '') then begin
                    maestroPais.Reset();
                    maestroPais.SetFilter(Code, InfoEmpresa.BssiBillingCountry);
                    if maestroPais.FindFirst() then direccionEmpresa := direccionEmpresa + ', ' + maestroPais.Name;
                end;

            end;

            trigger OnPreDataItem();
            begin
                ok := InfoEmpresa.FINDFIRST;
                "GMATreasury Setup".GET();
                "GMATreasury Setup".CALCFIELDS(GMASignPicture);
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
        "GMATreasury Setup": Record "GMATreasury Setup";
        Proveedor: Record Vendor;
        ok: Boolean;
        Descripcion: Text[100];
        DetRetencion: Record "GMAWithholding Datail";
        Escala: Record "GMAWithholding Scale";
        alicuota: Decimal;
        minimo: Decimal;
        Provincia: Record GMAProvince;
        Retenciones: Codeunit GMARetenciones;
        retencion: Record "GMAWithholding Calculation";
        Acumulado: Decimal;
        movfac: Record "Vendor Ledger Entry";
        "Withholding Kind Line": Record "GMAWithholding Kind Line";
        CERTIFICADO_DE_RETENCION_SUSSCaptionLbl: Label 'CERTIFICADO DE RETENCION SUSS';
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
        ReferenciaCaptionLbl: Label 'Referencia';
        Cod__Retenci_nCaptionLbl: Label 'Cod. Retención';
        Base_ImponibleCaptionLbl: Label 'Base Imponible';
        EmptyStringCaption_Control1000000047Lbl: Label '-';
        Nro__FacturaCaptionLbl: Label 'Nro. Factura';
        Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl: Label 'Declaración en la que se informará la retencion :';
        EmptyStringCaption_Control1000000049Lbl: Label '*';
        gProvincia: Text[50];
        direccionProveedor: Text[250];
        direccionEmpresa: Text[250];
        maestroPais: Record "Country/Region";
        Retencion_TaxSystem: Code[10];
        "FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl": Label 'FIRMA DEL AGENTE DE RETENCIÓN';
        Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl: Label 'Declaro que los datos consignados en este certificado son correctos y completos, y';
        que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl: Label 'que he confeccionado la presente sin omitir ni falsear dato';
        "alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_CaptionLbl": Label 'alguno que deba contener, siendo fiel expresión de la verdad.';
        "ACLARACIÓN_CARGOCaptionLbl": Label 'ACLARACIÓN/CARGO';
        gblProvincia: Text[50];
        "Tipo fiscal": Record "GMAFiscal Type";
        globImpuestos: Record GMATaxes;
        Text1: Text[30];
        Text2: Text[30];
        glbImpuestos: Record GMATaxes;
        prov: Record GMAProvince;
        TOTAL: Decimal;
        TOTALNC: Decimal;
        tipocomp: Text[30];
        HOPago: Record "GMAPosted Payment Order";
}

