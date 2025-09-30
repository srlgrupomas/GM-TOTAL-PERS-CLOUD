report 80894 "PersEarning Withhoding Certif"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107535 - Earning Withholding Certificate GEN.rdl';

    Caption = 'Earning Withhoding Certif. GEN',
                ;

    dataset
    {
        dataitem("Movimiento Retenciones"; "GMLocWithholding Ledger Entry")
        {
            DataItemTableView = SORTING("GMLocNo.");
            //RequestFilterFields = "GMLocNo.";
            RequestFilterFields = "GMLocWithh. Certificate No.";
            column(Descripcion; Descripcion)
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_; "Movimiento Retenciones"."GMLocCalculation Base")
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_; "Movimiento Retenciones"."GMLocWithholding Amount")
            {
            }
            column(alicuota; alicuota)
            {
            }
            column(minimo; minimo)
            {
            }
            column(Movimiento_Retenciones_No_; "GMLocNo.")
            {
            }
            column(Movimiento_Retenciones_Voucher_Number; "GMLocVoucher Number")
            {
            }
            column(GMLocPictureSign; "GMLocTreasury Setup".GMLocSignPicture)
            {
            }
            column(Movimiento_Retenciones___Fecha_comprobante_; "Movimiento Retenciones".GMLocDocumentDate)
            {
            }
            dataitem(Copia; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(DetRetencion_Titulo; DetRetencion.GMLocTitle)
                {
                }
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
                column(InfoEmpresa__Home_Page_; '')
                {
                }
                column(InfoEmpresa_Address_______InfoEmpresa_City____C_P____InfoEmpresa__Post_Code_; direccionEmpresa)
                {
                }
                column(InfoEmpresa__Address_2_; InfoEmpresa.BssiBillingAddress2)
                {
                }
                column(InfoEmpresa__VAT_Registration_No__; InfoEmpresa.BssiRegistrationNo)
                {
                }
                column(Proveedor__No_ingresos_brutos_; Proveedor."GMLocGross Income Tax No")
                {
                }
                column(Proveedor__VAT_Registration_No__; Proveedor."VAT Registration No.")
                {
                }
                column(Proveedor_Address_______Proveedor_City____C_P____Proveedor__Post_Code________Proveedor__Address_2_; direccionProveedor)
                {
                }
                column(Proveedor_Name; Proveedor.Name)
                {
                }
                column(Movimiento_Retenciones___Nro_Certificado_Retencion_; "Movimiento Retenciones"."GMLocWithh. Certificate No.")
                {
                }
                column(Tipo_fiscal__Description; "Tipo fiscal".GMLocDescription)
                {
                }

                column(Movimiento_Retenciones___Numero_comprobante_; "Movimiento Retenciones"."GMLocVoucher Number")
                {
                }
                column(tipoCond; tipoCond)
                {
                }
                column(DetRetencion__Agente_de_Retencion_; DetRetencion."GMLocWithholding Agent")
                {
                }
                column("CERTIFICADO_DE_RETENCIÓN_N_Caption"; CERTIFICADO_DE_RETENCIÓN_N_CaptionLbl)
                {
                }
                column(DATOS_DEL_AGENTE_DE_RETENCIONCaption; DATOS_DEL_AGENTE_DE_RETENCIONCaptionLbl)
                {
                }
                column(Domicilio_Caption; Domicilio_CaptionLbl)
                {
                }
                column(Nro__de_CUIT_Caption; Nro__de_CUIT_CaptionLbl)
                {
                }
                column(Ag__de_Ret__N__Caption; Ag__de_Ret__N__CaptionLbl)
                {
                }
                column(Nro__de_IIBBCaption; Nro__de_IIBBCaptionLbl)
                {
                }
                column(Nro__de_CUIT_Caption_Control1000000052; Nro__de_CUIT_Caption_Control1000000052Lbl)
                {
                }
                column("Dirección_Caption"; Dirección_CaptionLbl)
                {
                }
                column(DATOS_DEL_SUJETO_RETENIDOCaption; DATOS_DEL_SUJETO_RETENIDOCaptionLbl)
                {
                }
                column(FECHA_Caption; FECHA_CaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000088; EmptyStringCaption_Control1000000088Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000089; EmptyStringCaption_Control1000000089Lbl)
                {
                }
                column("Razón_Social_Caption"; Razón_Social_CaptionLbl)
                {
                }
                column(Tipo_de_ContribuyenteCaption; Tipo_de_ContribuyenteCaptionLbl)
                {
                }
                column("Razón_Social_Caption_Control1000000092"; Razón_Social_Caption_Control1000000092Lbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(ORDEN_DE_PAGO_N__Caption; ORDEN_DE_PAGO_N__CaptionLbl)
                {
                }
                column(Sit__ante_IVA_Caption; Sit__ante_IVA_CaptionLbl)
                {
                }
                column(Copia_Number; Number)
                {
                }
                dataitem(Pagina; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(Movimiento_Retenciones___Importe_retencion_; "Movimiento Retenciones"."GMLocWithholding Amount")
                    {
                    }
                    column(decRetenAnt; decRetenAnt)
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100; decRetenAnt + "Movimiento Retenciones"."GMLocWithholding Amount")
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100_2; "Movimiento Retenciones"."GMLocWithholding Amount")
                    {
                    }
                    column(FORMAT_alicuota______; FORMAT(alicuota) + ' %')
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp; "Movimiento Retenciones".GMLocBase + decPagosAnt - decMinimoNoImp)
                    {
                    }
                    column(decMinimoNoImp; decMinimoNoImp)
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt; "Movimiento Retenciones".GMLocBase + decPagosAnt)
                    {
                    }
                    column(decPagosAnt; decPagosAnt)
                    {
                    }
                    column(MontoFijo; MontoFijo)
                    {
                    }
                    column(Movimiento_Retenciones__Base; "Movimiento Retenciones".GMLocBase)
                    {
                    }
                    column("Régimen__________DetRetencion_Regimen__________DetRetencion_Descripcion"; 'Régimen' + '  ' + DetRetencion."GMLocTax System" + ' - ' + DetRetencion.GMLocDescription)
                    {
                    }
                    column(InfoEmpresa_Picture2; InfoEmpresa.BssiPicture)
                    {
                    }
                    column(EmptyStringCaption_Control1000000081; EmptyStringCaption_Control1000000081Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000080; EmptyStringCaption_Control1000000080Lbl)
                    {
                    }
                    column(Retenciones_anterioresCaption; Retenciones_anterioresCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000079; EmptyStringCaption_Control1000000079Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000078; EmptyStringCaption_Control1000000078Lbl)
                    {
                    }
                    column("Monto_Sujeto_a_RetenciónCaption"; Monto_Sujeto_a_RetenciónCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000077; EmptyStringCaption_Control1000000077Lbl)
                    {
                    }
                    column("Mínimo_No_imponibleCaption"; Mínimo_No_imponibleCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000076; EmptyStringCaption_Control1000000076Lbl)
                    {
                    }
                    column("MONTO_DE_LA_RETENCIÓNCaption"; MONTO_DE_LA_RETENCIÓNCaptionLbl)
                    {
                    }
                    column("AlícuotaCaption"; AlícuotaCaptionLbl)
                    {
                    }
                    column(Pagos_anterioresCaption; Pagos_anterioresCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000075; EmptyStringCaption_Control1000000075Lbl)
                    {
                    }
                    column(Pago_de_la_fechaCaption; Pago_de_la_fechaCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000074; EmptyStringCaption_Control1000000074Lbl)
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }
                    column("DATOS_DE_LA_RETENCIÓN_PRACTICADACaption"; DATOS_DE_LA_RETENCIÓN_PRACTICADACaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102201001; EmptyStringCaption_Control1102201001Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102201005; EmptyStringCaption_Control1102201005Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102201006; EmptyStringCaption_Control1102201006Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1102201007; EmptyStringCaption_Control1102201007Lbl)
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
                    column("FIRMA_DEL_AGENTE_DE_RETENCIÓNCaption"; FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000006; EmptyStringCaption_Control1000000006Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000007; EmptyStringCaption_Control1000000007Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000008; EmptyStringCaption_Control1000000008Lbl)
                    {
                    }
                    column(Pago_en_concepto_de___Caption; Pago_en_concepto_de___CaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control1000000018; EmptyStringCaption_Control1000000018Lbl)
                    {
                    }
                    column("ACLARACIÓN_CARGOCaption"; ACLARACIÓN_CARGOCaptionLbl)
                    {
                    }
                    column(Pagina_Number; Number)
                    {
                    }

                    dataitem("Posted Payment Order Vouchers"; "GMLocPosted Payment Ord Vouch")
                    {
                        DataItemLink = "GMLocPayment Order No." = FIELD("GMLocVoucher Number");
                        DataItemLinkReference = "Movimiento Retenciones";
                        DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.") ORDER(Ascending);
                        column(tipocomp; tipocomp)
                        {
                        }
                        column(TOTAL; TOTAL)
                        {
                        }
                        column(movfac__External_Document_No__; movfac."External Document No.")
                        {
                        }
                        column(AcumTotal; AcumTotal)
                        {
                        }
                        column(Tipo_CompCaption; Tipo_CompCaptionLbl)
                        {
                        }
                        column(Base_ImponibleCaption; Base_ImponibleCaptionLbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000009; EmptyStringCaption_Control1000000009Lbl)
                        {
                        }
                        column(Nro__ComprobanteCaption; Nro__ComprobanteCaptionLbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000022; EmptyStringCaption_Control1000000022Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000023; EmptyStringCaption_Control1000000023Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000049; EmptyStringCaption_Control1000000049Lbl)
                        {
                        }
                        column(TOTAL_IMPONIBLECaption; TOTAL_IMPONIBLECaptionLbl)
                        {
                        }
                        column(Posted_Payment_Order_Vouchers_Payment_Order_No_; "GMLocPayment Order No.")
                        {
                        }
                        column(Posted_Payment_Order_Vouchers_Voucher_No_; "GMLocVoucher No.")
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
                            Facturas2: Record "Purch. Cr. Memo Hdr.";
                            LineasFactura2: Record "Purch. Cr. Memo Line";
                        begin
                            /*
                            CLEAR(numero);
                            IF("Hist Lin Comp OPago"."Tipo Doc" <> "Hist Lin Comp OPago"."Tipo Doc"::"Credit Memo")THEN
                            BEGIN
                              VendorLedgerEntry.RESET;
                              VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Document No.","Hist Lin Comp OPago"."Nro Comprobante");
                              VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Vendor No.",HOPago."Nro Proveedor");
                              IF(VendorLedgerEntry.FINDFIRST)THEN
                               numero := VendorLedgerEntry."Entry No.";
                            
                            END
                            ELSE BEGIN
                              VendorLedgerEntry.RESET;
                              VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Document No.",'Ninguno');
                              VendorLedgerEntry.SETRANGE(VendorLedgerEntry."Vendor No.",'Ninguno');
                              IF(VendorLedgerEntry.FINDFIRST)THEN;
                            END;
                            */
                            ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                            Acumulado := 0;
                            if ("Posted Payment Order Vouchers"."GMLocDocument Type" = "Posted Payment Order Vouchers"."GMLocDocument Type"::Invoice) or
                              ("Posted Payment Order Vouchers"."GMLocDocument Type" = "Posted Payment Order Vouchers"."GMLocDocument Type"::"Nota Débito") then begin
                                Facturas.RESET;
                                Facturas.SETRANGE(Facturas."No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                                if Facturas.FindSet() then begin
                                    Facturas.CALCFIELDS("Amount Including VAT");
                                    //Calculo porcentaje del pago sobre el total de la factura
                                    if Facturas."Currency Factor" <> 0 then
                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                                    else
                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / Facturas."Amount Including VAT");
                                    if ("Posted Payment Order Vouchers".GMLocCrMemoAppliedExists) then
                                        PorcMonto := 100;

                                    LineasFactura.RESET;
                                    LineasFactura.SETRANGE("Document No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                                    if LineasFactura.FindSet() then begin
                                        repeat
                                            Comportamiento.RESET;
                                            Comportamiento.SETRANGE(Comportamiento."GMLocWithholding Code", LineasFactura."GMLocWithholding Code");
                                            Comportamiento.SETRANGE(Comportamiento."GMLocTax System", "Movimiento Retenciones"."GMLocTax System");
                                            Comportamiento.SETRANGE(Comportamiento."GMLocWithholding No.", "Movimiento Retenciones"."GMLocWithholding No.");//NAVAR1.06
                                            if Comportamiento.FindSet() then begin
                                                DetRetencion.RESET;
                                                DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", Comportamiento."GMLocWithholding No.");
                                                if DetRetencion.FindSet() then begin

                                                    ///Control de Valor en Detalle de Retención
                                                    //if DetRetencion.GMLocValue = '' then
                                                    //    ControlValor := false
                                                    //else
                                                    ControlValor := true;

                                                    if ControlValor then begin

                                                        ///Controlo que sea una retencion de la empresa
                                                        retencionesempresa.RESET;
                                                        retencionesempresa.SETRANGE(retencionesempresa."GMLocTax Code", DetRetencion."GMLocTax Code");
                                                        if retencionesempresa.FindSet() then
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
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMLocTax Code", DetRetencion."GMLocTax Code");
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMLocVendor Code", "Posted Payment Order Vouchers".GMLocVendor);
                                                        if CondImpuesto.FindSet() then
                                                            CodCondicion := CondImpuesto."GMLocTax Condition";

                                                        if ControlProv then begin
                                                            Escala.RESET;
                                                            Escala.SETRANGE(Escala."GMLocScale Code", DetRetencion."GMLocScale Code");
                                                            Escala.SETRANGE(Escala."GMLocWithholding Condition", CodCondicion);
                                                            if Escala.FindSet() then begin
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

                                        until LineasFactura.NEXT = 0;
                                    end;

                                end;
                            end;
                            if ("Posted Payment Order Vouchers"."GMLocDocument Type" = "Posted Payment Order Vouchers"."GMLocDocument Type"::"Credit Memo") then begin
                                Facturas2.RESET;
                                Facturas2.SETRANGE("No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                                if Facturas2.FindSet() then begin
                                    Facturas2.CALCFIELDS("Amount Including VAT");
                                    //Calculo porcentaje del pago sobre el total de la factura
                                    if Facturas2."Currency Factor" <> 0 then
                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / (Facturas2."Amount Including VAT" / Facturas2."Currency Factor"))
                                    else
                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / Facturas2."Amount Including VAT");

                                    LineasFactura2.RESET;
                                    LineasFactura2.SETRANGE("Document No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                                    if LineasFactura2.FindSet() then begin
                                        repeat
                                            Comportamiento.RESET;
                                            Comportamiento.SETRANGE(Comportamiento."GMLocWithholding Code", LineasFactura2."GMLocWithholding Code");
                                            Comportamiento.SETRANGE(Comportamiento."GMLocTax System", "Movimiento Retenciones"."GMLocTax System");
                                            if Comportamiento.FindSet() then begin
                                                DetRetencion.RESET;
                                                DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", Comportamiento."GMLocWithholding No.");
                                                if DetRetencion.FindSet() then begin

                                                    ///Control de Valor en Detalle de Retención
                                                    //if DetRetencion.GMLocValue = '' then
                                                    //    ControlValor := false
                                                    //else
                                                    ControlValor := true;

                                                    if ControlValor then begin

                                                        ///Controlo que sea una retencion de la empresa
                                                        retencionesempresa.RESET;
                                                        retencionesempresa.SETRANGE(retencionesempresa."GMLocTax Code", DetRetencion."GMLocTax Code");
                                                        if retencionesempresa.FindSet() then
                                                            if retencionesempresa.GMLocRetains = true then begin

                                                                ControlProv := false;
                                                                if retencionesempresa.GMLocProvince = '' then
                                                                    ControlProv := true
                                                                else
                                                                    if (Facturas2.GMLocProvince <> '') and (Facturas2.GMLocProvince = retencionesempresa.GMLocProvince) then
                                                                        ControlProv := true
                                                            end;

                                                        ///Control de la condicion de retencion del proveedor
                                                        CondImpuesto.RESET;
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMLocTax Code", DetRetencion."GMLocTax Code");
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMLocVendor Code", "Posted Payment Order Vouchers".GMLocVendor);
                                                        if CondImpuesto.FindSet() then
                                                            CodCondicion := CondImpuesto."GMLocTax Condition";

                                                        if ControlProv then begin
                                                            Escala.RESET;
                                                            Escala.SETRANGE(Escala."GMLocScale Code", DetRetencion."GMLocScale Code");
                                                            Escala.SETRANGE(Escala."GMLocWithholding Condition", CodCondicion);
                                                            if Escala.FindSet() then begin
                                                                case DetRetencion."GMLocWithholding Base Type" of
                                                                    DetRetencion."GMLocWithholding Base Type"::"Sin Impuestos":
                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                            Acumulado -= ((PorcMonto * (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor")) / 100)

                                                                        else
                                                                            Acumulado -= ((PorcMonto * LineasFactura2."VAT Base Amount") / 100);

                                                                    DetRetencion."GMLocWithholding Base Type"::"Importe Impuestos":
                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                            Acumulado -= ((PorcMonto * ((LineasFactura2."Amount Including VAT" / Facturas2."Currency Factor")
                                                                                                - (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor"))) / 100)
                                                                        else
                                                                            Acumulado -= ((PorcMonto * (LineasFactura2."Amount Including VAT"
                                                                                                 - LineasFactura2."VAT Base Amount")) / 100);

                                                                    DetRetencion."GMLocWithholding Base Type"::"Importe Total":
                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                            Acumulado -= ((PorcMonto * (LineasFactura2."Amount Including VAT" / Facturas2."Currency Factor")) / 100)
                                                                        else
                                                                            Acumulado -= ((PorcMonto * LineasFactura2."Amount Including VAT") / 100);
                                                                end;

                                                            end;
                                                        end;
                                                    end;
                                                end;

                                            end;

                                        until LineasFactura2.NEXT = 0;
                                    end;

                                end;
                            end;

                            movfac.RESET;
                            movfac.SETRANGE(movfac."Document No.", "Posted Payment Order Vouchers"."GMLocVoucher No.");
                            ok := movfac.FindSet();

                            //NAVAR1.06002-
                            CLEAR(ImporteNC);
                            tipocomp := '';
                            if (movfac."Document Type" = movfac."Document Type"::Invoice) then begin
                                tipocomp := 'FC';
                                ImporteNC := FindApplicCreditMemo("Posted Payment Order Vouchers"."GMLocVoucher No.");
                            end;

                            if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                tipocomp := 'NC';

                            if (movfac."Document Type" = movfac."GMLocDocument Type Loc."::"Nota Débito") then
                                tipocomp := 'ND';

                            if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                Acumulado := -Acumulado;

                            Acumulado := ROUND(Acumulado, 0.01);

                            CLEAR(TOTAL);

                            if (HOPago."GMLocNew Payment") then
                                Acumulado := "Posted Payment Order Vouchers".GMLocCancelled;

                            AcumTotal := AcumTotal + Acumulado;

                            if ("Posted Payment Order Vouchers".GMLocCrMemoAppliedExists) then
                                TOTAL := Acumulado
                            else
                                TOTAL := Acumulado + ImporteNC;

                            //NAVAR1.06002+

                            if Acumulado = 0 then
                                CurrReport.SKIP;

                        end;
                    }
                }

                trigger OnPreDataItem();
                begin
                    case optCopias of
                        optCopias::"Sólo original":
                            SETRANGE(Number, 1, 1);
                        optCopias::Duplicado:
                            SETRANGE(Number, 1, 2);
                        optCopias::Triplicado:
                            SETRANGE(Number, 1, 3);
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            var
                BssiMEMSystemSetup: record BssiMEMSystemSetup;
                HLinCompPago: Record "GMLocPosted Payment Ord Vouch";
                MovProveedor: Record "Vendor Ledger Entry";
                i: Integer;
                Dia: Text[2];
                Mes: Text[30];
                Anio: Text[4];
            begin
                DetRetencion.RESET;
                DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", "Movimiento Retenciones"."GMLocWithholding No.");
                if DetRetencion.FindSet() then
                    Descripcion := DetRetencion.GMLocDescription;

                //GMDataScale MC +
                //Se deben sacar estos datos del historico de retenciones, no de la escala, esta puede cambiar.
                //Dejo para retenciones ya generadas

                if ("Movimiento Retenciones".GMLocFrom = 0) and ("Movimiento Retenciones"."GMLocFixed Amount" = 0) and ("Movimiento Retenciones"."GMLocBase Amount" = 0) then begin
                    Escala.RESET;
                    Escala.SETRANGE(Escala."GMLocScale Code", "Movimiento Retenciones"."GMLocScale Code");
                    Escala.SETRANGE(Escala."GMLocWithholding Condition", "Movimiento Retenciones"."GMLocCondition Code");
                    Escala.SETRANGE(Escala."GMLocTax Code", "Movimiento Retenciones"."GMLocTax Code");
                    if Escala.FindSet() then
                        repeat
                            if (Escala.GMLocFrom <= "Movimiento Retenciones"."GMLocCalculation Base") then begin
                                alicuota := Escala."GMLocExcedent %";
                                minimo := Escala.GMLocFrom;
                                MontoFijo := Escala."GMLocFixed Amount";
                                decMinimoNoImp := Escala."GMLocBase Amount";
                            end;
                        until Escala.NEXT = 0;
                end
                else begin
                    alicuota := "Movimiento Retenciones"."GMLocWithholding%";
                    minimo := "Movimiento Retenciones".GMLocFrom;
                    MontoFijo := "Movimiento Retenciones"."GMLocFixed Amount";
                    decMinimoNoImp := "Movimiento Retenciones"."GMLocBase Amount";
                end;
                //GMDataScale MC -


                //11807+
                "Withholding Kind Line".RESET;
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocWithholding Code", "GMLocWithholding Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocTax Code", "GMLocTax Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocIs vendor withholding", true);
                if ("Withholding Kind Line".FINDFIRST) then begin
                    if ("Vendor withholding" <> '') then begin
                        Proveedor.RESET;
                        Proveedor.SETCURRENTKEY("No.");
                        Proveedor.SETRANGE("No.", "Vendor withholding");
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
                    if maestroPais.FindFirst() then direccionProveedor := direccionProveedor + ', ' + maestroPais.GetNameInCurrentLanguage();
                end;

                if "Tipo fiscal".Get(Proveedor."GMLocFiscal Type") then;

                //Proveedor.GET("Movimiento Retenciones"."GMLocVendor Code"); //11807

                HOPago.GET("Movimiento Retenciones"."GMLocVoucher Number");
                HOPago.CALCFIELDS("GMLocPaid Amount (LCY)");
                HLinCompPago.SETRANGE("GMLocPayment Order No.", HOPago."GMLocPayment O. No.");
                HLinCompPago.FindFirst();
                for i := 1 to 60 do
                    txtNroComprobantes[i] := ' ';
                i := 1;
                repeat
                    Contador += 1;
                    if MovProveedor.GET(HLinCompPago."GMLocEntry No.") then begin
                        if (MovProveedor."Document Type" = MovProveedor."Document Type"::Invoice) then
                            txtNroComprobantes[i] += 'FC  ' + MovProveedor."External Document No.";
                        if (MovProveedor."Document Type" = MovProveedor."Document Type"::"Credit Memo") then
                            txtNroComprobantes[i] += 'NC  ' + MovProveedor."External Document No.";
                        if (MovProveedor."Document Type" <> MovProveedor."Document Type"::Invoice) and
                         (MovProveedor."Document Type" <> MovProveedor."Document Type"::Invoice) then
                            txtNroComprobantes[i] += MovProveedor."External Document No.";


                        i += 1;
                    end;
                until (HLinCompPago.NEXT = 0) or (Contador = 150);

                Dia := FORMAT(DATE2DMY("Movimiento Retenciones"."GMLocWithholding Date", 1));
                Anio := FORMAT(DATE2DMY("Movimiento Retenciones"."GMLocWithholding Date", 3));
                Mes := FORMAT("Movimiento Retenciones"."GMLocWithholding Date", 0, '<Month Text>');
                txtLugarYFecha := 'Buenos Aires, ' + Dia + ' de ' + Mes + ' de ' + Anio + '.';
                txtDeclaracion := 'La presente retención se informará en la DDJJ correspondiente al mes de ' + Mes + ' del año ' + Anio + '.';

                if (HOPago."GMLocNew Payment") then begin
                    "Hist Lin Valor OPago".SETRANGE("GMLocPayment Order No.", HOPago."GMLocPayment O. No."); // "Posted Payment Order Vouchers"."Payment Order No."
                    "Hist Lin Valor OPago".SETRANGE("Hist Lin Valor OPago".GMLocValue, "Movimiento Retenciones".GMLocValue);
                    "Hist Lin Valor OPago".SETRANGE("Hist Lin Valor OPago"."GMLocWithholding No.", "Movimiento Retenciones"."GMLocWithholding No.");
                    if ("Hist Lin Valor OPago".FINDFIRST()) then begin
                        //IF("Hist Lin Valor OPago"."Pagos Anteriores" <> 0)THEN
                        decPagosAnt := "Hist Lin Valor OPago"."GMLocPrevious Payments";
                        // IF("Hist Lin Valor OPago"."Retenciones Anteriores" <> 0)THEN
                        decRetenAnt := "Hist Lin Valor OPago"."GMLocPrevious Withholdings";
                    end;
                end;
                if (alicuota = 0) then
                    if ("Movimiento Retenciones"."GMLocWithholding%" <> 0) then
                        alicuota := "Movimiento Retenciones"."GMLocWithholding%"
                    else begin
                        if ("Movimiento Retenciones"."GMLocCalculation Base" <> 0) and ("Movimiento Retenciones"."GMLocWithholding Amount" <> 0) then
                            alicuota := ("Movimiento Retenciones"."GMLocWithholding Amount" /
                            ("Movimiento Retenciones"."GMLocCalculation Base" + decPagosAnt - decMinimoNoImp)) * 100;
                    end;


                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Movimiento Retenciones"."GMLocShortcut Dimension 1");
                IF (InfoEmpresa.FindFirst()) THEN;
                InfoEmpresa.CALCFIELDS(InfoEmpresa.BssiPicture);
                InfoEmpresa.CALCFIELDS(BssiPicture);
                if (InfoEmpresa.BssiBillingAddr1 <> '') then direccionEmpresa := InfoEmpresa.BssiBillingAddr1;
                if (InfoEmpresa.BssiBillingCity <> '') then direccionEmpresa := direccionEmpresa + ',  ' + InfoEmpresa.BssiBillingCity;
                if (InfoEmpresa."BssiBillingZipCode" <> '') then direccionEmpresa := direccionEmpresa + ', C.P. ' + InfoEmpresa.BssiBillingZipCode;
                if (InfoEmpresa.BssiBillingCountry <> '') then begin
                    maestroPais.Reset();
                    maestroPais.SetFilter(Code, InfoEmpresa.BssiBillingCountry);
                    if maestroPais.FindFirst() then direccionEmpresa := direccionEmpresa + ', ' + maestroPais.Name;
                end;
                RecProvincia.RESET;
                RecProvincia.SETCURRENTKEY(RecProvincia."GMLocProvince Code");
                RecProvincia.SETRANGE("GMLocProvince Code", InfoEmpresa.BssiProvinceCode);
                if RecProvincia.FINDFIRST then
                    gProvincia := RecProvincia.GMLocDescription;

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

    trigger OnInitReport();
    begin
        optCopias := optCopias::"Sólo original";
    end;

    trigger OnPreReport();
    begin
        textoCopia[1] := 'ORIGINAL';
        textoCopia[2] := 'DUPLICADO';
        textoCopia[3] := 'TRIPLICADO';
    end;

    var
        "GMLocTreasury Setup": Record "GMLocTreasury Setup";
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
        HOPago: Record "GMLocPosted Payment Order";
        InicioMes: Date;
        blnEncontroRetencionesAnt: Boolean;
        txtLugarYFecha: Text[250];
        txtNroComprobantes: array[150] of Text[250];
        txtDeclaracion: Text[250];
        decPagosAnt: Decimal;
        decRetenAnt: Decimal;
        decMinimoNoImp: Decimal;
        optCopias: Option "Sólo original",Duplicado,Triplicado;
        textoCopia: array[3] of Text[50];
        Temp_PagosProcesados: Record "GMLocPosted Payment Order" temporary;
        txtNroC: array[30] of Text[250];
        Contador: Integer;
        "Hist Lin Valor OPago": Record "GMLocPosted Payment Order Valu";
        tipocomp: Text[30];
        DescRet: Text[250];
        "Tipo fiscal": Record "GMLocFiscal Type";
        globImpuestos: Record GMLocTaxes;
        tipoCond: Text[30];
        AcumTotal: Decimal;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        numero: Integer;
        ImporteNC: Decimal;
        TOTAL: Decimal;
        TOTALNC: Decimal;
        "Withholding Kind Line": Record "GMLocWithholding Kind Line";
        "CERTIFICADO_DE_RETENCIÓN_N_CaptionLbl": Label 'CERTIFICADO DE RETENCIÓN Nº';
        DATOS_DEL_AGENTE_DE_RETENCIONCaptionLbl: Label 'DATOS DEL AGENTE DE RETENCION';
        Domicilio_CaptionLbl: Label 'Domicilio:';
        Nro__de_CUIT_CaptionLbl: Label 'Nro. de CUIT:';
        Ag__de_Ret__N__CaptionLbl: Label 'Ag. de Ret. N°:';
        Nro__de_IIBBCaptionLbl: Label 'Nro. de IIBB';
        Nro__de_CUIT_Caption_Control1000000052Lbl: Label 'Nro. de CUIT:';
        "Dirección_CaptionLbl": Label 'Dirección:';
        DATOS_DEL_SUJETO_RETENIDOCaptionLbl: Label 'DATOS DEL SUJETO RETENIDO';
        FECHA_CaptionLbl: Label 'FECHA:';
        EmptyStringCaptionLbl: Label '-';
        EmptyStringCaption_Control1000000088Lbl: Label '-';
        EmptyStringCaption_Control1000000089Lbl: Label '-';
        "Razón_Social_CaptionLbl": Label 'Razón Social:';
        Tipo_de_ContribuyenteCaptionLbl: Label 'Tipo de Contribuyente';
        "Razón_Social_Caption_Control1000000092Lbl": Label 'Razón Social:';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        ORDEN_DE_PAGO_N__CaptionLbl: Label 'ORDEN DE PAGO Nº:';
        Sit__ante_IVA_CaptionLbl: Label 'Sit. ante IVA:';
        EmptyStringCaption_Control1000000081Lbl: Label '$';
        EmptyStringCaption_Control1000000080Lbl: Label '$';
        Retenciones_anterioresCaptionLbl: Label 'Retenciones anteriores';
        EmptyStringCaption_Control1000000079Lbl: Label '$';
        EmptyStringCaption_Control1000000078Lbl: Label '$';
        "Monto_Sujeto_a_RetenciónCaptionLbl": Label 'Base retencion por alicuota';
        EmptyStringCaption_Control1000000077Lbl: Label '$';
        "Mínimo_No_imponibleCaptionLbl": Label 'Mínimo Escala';
        EmptyStringCaption_Control1000000076Lbl: Label '$';
        "MONTO_DE_LA_RETENCIÓNCaptionLbl": Label 'MONTO DE LA RETENCIÓN';
        "AlícuotaCaptionLbl": Label 'Alícuota';
        Pagos_anterioresCaptionLbl: Label 'Pagos anteriores';
        EmptyStringCaption_Control1000000075Lbl: Label '$';
        Pago_de_la_fechaCaptionLbl: Label 'Pago de la fecha';
        EmptyStringCaption_Control1000000074Lbl: Label '$';
        TotalCaptionLbl: Label 'Total';
        "DATOS_DE_LA_RETENCIÓN_PRACTICADACaptionLbl": Label 'DATOS DE LA RETENCIÓN PRACTICADA';
        EmptyStringCaption_Control1102201001Lbl: Label '-';
        EmptyStringCaption_Control1102201005Lbl: Label '(';
        EmptyStringCaption_Control1102201006Lbl: Label ')';
        EmptyStringCaption_Control1102201007Lbl: Label '-';
        Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl: Label 'Declaro que los datos consignados en este certificado son correctos y completos, y';
        que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl: Label 'que he confeccionado la presente sin omitir ni falsear dato ';
        "alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_CaptionLbl": Label 'alguno que deba contener, siendo fiel expresión de la verdad.';
        "FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl": Label 'FIRMA DEL AGENTE DE RETENCIÓN';
        EmptyStringCaption_Control1000000006Lbl: Label '____________________________________';
        EmptyStringCaption_Control1000000007Lbl: Label '(';
        EmptyStringCaption_Control1000000008Lbl: Label ')';
        Pago_en_concepto_de___CaptionLbl: Label 'Pago en concepto de:  ';
        EmptyStringCaption_Control1000000018Lbl: Label '-';
        "ACLARACIÓN_CARGOCaptionLbl": Label 'ACLARACIÓN/CARGO';
        EmptyStringCaption_Control1000000072Lbl: Label '$';
        EmptyStringCaption_Control1000000073Lbl: Label '$';
        EmptyStringCaption_Control1100240000Lbl: Label '-';
        Tipo_CompCaptionLbl: Label 'Tipo Comp';
        Base_ImponibleCaptionLbl: Label 'Base Imponible';
        EmptyStringCaption_Control1000000009Lbl: Label '-';
        Nro__ComprobanteCaptionLbl: Label 'Nro. Comprobante';
        EmptyStringCaption_Control1000000022Lbl: Label '$';
        EmptyStringCaption_Control1000000023Lbl: Label '$';
        EmptyStringCaption_Control1000000049Lbl: Label '-';
        TOTAL_IMPONIBLECaptionLbl: Label 'TOTAL IMPONIBLE';
        MontoFijo: Decimal;
        gProvincia: Text[50];
        RecProvincia: Record GMLocProvince;
        direccionProveedor: Text[250];
        direccionEmpresa: Text[250];
        maestroPais: Record "Country/Region";

    procedure Fun_BaseRetGanHOP(NroHOPago: Code[20]) Dec_BaseHOP: Decimal;
    var
        HCabOP: Record "GMLocPosted Payment Order";
        LinComprobanteOP: Record "GMLocPosted Payment Ord Vouch";
        LineasFactura: Record "Purch. Inv. Line";
        LineasAbono: Record "Purch. Cr. Memo Line";
        Comportamiento: Record "GMLocWithholding Kind Line";
        PorcMonto: Decimal;
        Dec_ImporteMov: Decimal;
        Rec_MovProveedor: Record "Vendor Ledger Entry";
        Dec_BaseDocu: Decimal;
        Dec_PctAnulacion: Decimal;
    begin
        /*
        ==================================================================================================================================
        
          VERIFICO QUE NO ESTÉ ANULADA
        ==================================================================================================================================
        
        */

        LinComprobanteOP.SETRANGE(LinComprobanteOP."GMLocVoucher No.", NroHOPago);
        if LinComprobanteOP.FINDFIRST then begin
            HCabOP.GET(NroHOPago);
            HCabOP.CALCFIELDS("GMLocPaid Amount (LCY)");
            Dec_PctAnulacion := LinComprobanteOP."GMLocAmount (LCY)" / HCabOP."GMLocPaid Amount (LCY)" * 100 * -1;
        end;

        if Dec_PctAnulacion = 100 then begin
            Dec_BaseHOP := 0;
            exit;
        end;

        CLEAR(LinComprobanteOP);
        LinComprobanteOP.SETRANGE("GMLocPayment Order No.", NroHOPago);
        /*
                            ================================================================================================================
        ==
        ==
        ==
        ==
        ==
        ==
        ==
        ==
        ==
        ==
          FAC ND
                            ================================================================================================================
        ==
        ==
        ==
        ==
        ==
        ==
        ==
        ==
        ==
        ==
        */
        LinComprobanteOP.SETFILTER("GMLocDocument Type", '<>%1', LinComprobanteOP."GMLocDocument Type"::"Credit Memo");
        if LinComprobanteOP.FindSet() then
            repeat

                Dec_BaseDocu := 0;
                Dec_ImporteMov := 0;

                //Calculo porcentaje del pago sobre el total de la factura

                if Rec_MovProveedor.GET(LinComprobanteOP."GMLocEntry No.") then begin
                    Rec_MovProveedor.CALCFIELDS("Amount (LCY)");
                    Dec_ImporteMov := Rec_MovProveedor."Amount (LCY)";
                end;

                if Dec_ImporteMov <> 0 then
                    if LinComprobanteOP."GMLocExchange Rate" <> 0 then
                        PorcMonto := ((LinComprobanteOP."GMLocAmount (LCY)" * 100) / (Dec_ImporteMov / LinComprobanteOP."GMLocExchange Rate")) * -1
                    else
                        PorcMonto := ((LinComprobanteOP.GMLocAmount * 100) / Dec_ImporteMov) * -1
                else
                    PorcMonto := 1;

                //Sumo el importe base de las líneas que aplican
                LineasFactura.RESET;
                LineasFactura.SETRANGE("Document No.", LinComprobanteOP."GMLocVoucher No.");
                if LineasFactura.FindSet() then
                    repeat
                        Comportamiento.RESET;
                        Comportamiento.SETRANGE(Comportamiento."GMLocWithholding Code", LineasFactura."GMLocWithholding Code");
                        Comportamiento.SETRANGE(Comportamiento."GMLocTax Code", 'GANANCIAS');
                        if Comportamiento.FindSet() then
                            Dec_BaseDocu += LineasFactura."VAT Base Amount";
                    until LineasFactura.NEXT = 0;

                Dec_BaseDocu := Dec_BaseDocu * PorcMonto / 100;
                Dec_BaseHOP += Dec_BaseDocu;

            until LinComprobanteOP.NEXT = 0;
        /*
        ==================================================================================================================================
        
          NC
        ==================================================================================================================================
        
        */
        LinComprobanteOP.SETFILTER("GMLocDocument Type", '=%1', LinComprobanteOP."GMLocDocument Type"::"Credit Memo");
        if LinComprobanteOP.FindSet() then
            repeat

                Dec_BaseDocu := 0;
                Dec_ImporteMov := 0;

                //Calculo porcentaje del pago sobre el total de la factura

                if Rec_MovProveedor.GET(LinComprobanteOP."GMLocEntry No.") then begin
                    Rec_MovProveedor.CALCFIELDS("Amount (LCY)");
                    Dec_ImporteMov := Rec_MovProveedor."Amount (LCY)";
                end;
                if Dec_ImporteMov <> 0 then
                    if LinComprobanteOP."GMLocExchange Rate" <> 0 then
                        PorcMonto := ((LinComprobanteOP."GMLocAmount (LCY)" * 100) / (Dec_ImporteMov / LinComprobanteOP."GMLocExchange Rate")) * -1
                    else
                        PorcMonto := ((LinComprobanteOP.GMLocAmount * 100) / Dec_ImporteMov) * -1
                else
                    PorcMonto := 1;

                //Resto el importe base de las líneas que aplican
                LineasAbono.RESET;
                LineasAbono.SETRANGE("Document No.", LinComprobanteOP."GMLocVoucher No.");
                if LineasAbono.FindSet() then
                    repeat
                        Comportamiento.RESET;
                        Comportamiento.SETRANGE(Comportamiento."GMLocWithholding Code", LineasAbono."GMLocWithholding Code");
                        Comportamiento.SETRANGE(Comportamiento."GMLocTax Code", 'GANANCIAS');
                        if Comportamiento.FindSet() then
                            Dec_BaseDocu += LineasAbono."VAT Base Amount";
                    until LineasAbono.NEXT = 0;

                Dec_BaseDocu := Dec_BaseDocu * PorcMonto / 100;
                Dec_BaseHOP -= Dec_BaseDocu;

            until LinComprobanteOP.NEXT = 0;

        if Dec_PctAnulacion <> 0 then
            Dec_BaseHOP := Dec_BaseHOP * Dec_PctAnulacion / 100;

    end;

    procedure FindApplicCreditMemo(DocNum: Code[20]) ImporteNC: Decimal;
    var
        LclMovProv: Record "Vendor Ledger Entry";
    begin
        LclMovProv.SETRANGE(LclMovProv."Document No.", DocNum);     // PARA ORDEN DE PAGA YA QUE EL DOCUMENTO NO ESTA PENDIENTE
        LclMovProv.SETRANGE(LclMovProv.Open, false);
        if (LclMovProv.FINDFIRST) then
            ImporteNC := FindAppliNC(LclMovProv."Entry No.", LclMovProv."Vendor No.");
    end;

    procedure FindAppliNC(EntryNum: Integer; Prov: Code[20]) ImporteNC: Decimal;
    var
        LclMovProv: Record "Vendor Ledger Entry";
        recPCMH: Record "Purch. Cr. Memo Hdr.";
    begin
        LclMovProv.RESET;
        LclMovProv.SETCURRENTKEY("Vendor No.", Open, Positive);
        LclMovProv.SETRANGE("Vendor No.", Prov);
        LclMovProv.SETRANGE(LclMovProv."Closed by Entry No.", EntryNum);
        if (LclMovProv.FINDSET) then
            repeat
                if (LclMovProv."Document Type" = LclMovProv."Document Type"::"Credit Memo") then begin

                    recPCMH.RESET;
                    recPCMH.SETRANGE("Pay-to Vendor No.", "Posted Payment Order Vouchers".GMLocVendor);
                    recPCMH.SETRANGE(recPCMH."No.", LclMovProv."Document No.");
                    if recPCMH.FINDFIRST then begin
                        recPCMH.CALCFIELDS(Amount, "Amount Including VAT");
                        ImporteNC += recPCMH.Amount;
                        if recPCMH."Currency Code" <> '' then
                            ImporteNC := ImporteNC / recPCMH."Currency Factor";
                    end;

                    //LclMovProv.CALCFIELDS(LclMovProv.Amount);
                    //ImporteNC += LclMovProv.Amount;

                end;
            until LclMovProv.NEXT = 0;
    end;
}
