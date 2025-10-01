report 34006894 "PersEarning Withhoding Certif"
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
        dataitem("Movimiento Retenciones"; "GMAWithholding Ledger Entry")
        {
            DataItemTableView = SORTING("GMANo.");
            //RequestFilterFields = "GMANo.";
            RequestFilterFields = "GMAWithh. Certificate No.";
            column(Descripcion; Descripcion)
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_; "Movimiento Retenciones"."GMACalculation Base")
            {
            }
            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_; "Movimiento Retenciones"."GMAWithholding Amount")
            {
            }
            column(alicuota; alicuota)
            {
            }
            column(minimo; minimo)
            {
            }
            column(Movimiento_Retenciones_No_; "GMANo.")
            {
            }
            column(Movimiento_Retenciones_Voucher_Number; "GMAVoucher Number")
            {
            }
            column(GMAPictureSign; "GMATreasury Setup".GMASignPicture)
            {
            }
            column(Movimiento_Retenciones___Fecha_comprobante_; "Movimiento Retenciones".GMADocumentDate)
            {
            }
            dataitem(Copia; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(DetRetencion_Titulo; DetRetencion.GMATitle)
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
                column(Proveedor__No_ingresos_brutos_; Proveedor."GMAGross Income Tax No")
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
                column(Movimiento_Retenciones___Nro_Certificado_Retencion_; "Movimiento Retenciones"."GMAWithh. Certificate No.")
                {
                }
                column(Tipo_fiscal__Description; "Tipo fiscal".GMADescription)
                {
                }

                column(Movimiento_Retenciones___Numero_comprobante_; "Movimiento Retenciones"."GMAVoucher Number")
                {
                }
                column(tipoCond; tipoCond)
                {
                }
                column(DetRetencion__Agente_de_Retencion_; DetRetencion."GMAWithholding Agent")
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
                    column(Movimiento_Retenciones___Importe_retencion_; "Movimiento Retenciones"."GMAWithholding Amount")
                    {
                    }
                    column(decRetenAnt; decRetenAnt)
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100; decRetenAnt + "Movimiento Retenciones"."GMAWithholding Amount")
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100_2; "Movimiento Retenciones"."GMAWithholding Amount")
                    {
                    }
                    column(FORMAT_alicuota______; FORMAT(alicuota) + ' %')
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp; "Movimiento Retenciones".GMABase + decPagosAnt - decMinimoNoImp)
                    {
                    }
                    column(decMinimoNoImp; decMinimoNoImp)
                    {
                    }
                    column(Movimiento_Retenciones__Base_decPagosAnt; "Movimiento Retenciones".GMABase + decPagosAnt)
                    {
                    }
                    column(decPagosAnt; decPagosAnt)
                    {
                    }
                    column(MontoFijo; MontoFijo)
                    {
                    }
                    column(Movimiento_Retenciones__Base; "Movimiento Retenciones".GMABase)
                    {
                    }
                    column("Régimen__________DetRetencion_Regimen__________DetRetencion_Descripcion"; 'Régimen' + '  ' + DetRetencion."GMATax System" + ' - ' + DetRetencion.GMADescription)
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

                    dataitem("Posted Payment Order Vouchers"; "GMAPosted Payment Ord Vouch")
                    {
                        DataItemLink = "GMAPayment Order No." = FIELD("GMAVoucher Number");
                        DataItemLinkReference = "Movimiento Retenciones";
                        DataItemTableView = SORTING("GMAPayment Order No.", "GMAVoucher No.") ORDER(Ascending);
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
                        column(Posted_Payment_Order_Vouchers_Payment_Order_No_; "GMAPayment Order No.")
                        {
                        }
                        column(Posted_Payment_Order_Vouchers_Voucher_No_; "GMAVoucher No.")
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
                            if ("Posted Payment Order Vouchers"."GMADocument Type" = "Posted Payment Order Vouchers"."GMADocument Type"::Invoice) or
                              ("Posted Payment Order Vouchers"."GMADocument Type" = "Posted Payment Order Vouchers"."GMADocument Type"::"GMANota Debito") then begin
                                Facturas.RESET;
                                Facturas.SETRANGE(Facturas."No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                                if Facturas.FindSet() then begin
                                    Facturas.CALCFIELDS("Amount Including VAT");
                                    //Calculo porcentaje del pago sobre el total de la factura
                                    if Facturas."Currency Factor" <> 0 then
                                        PorcMonto := (("GMAAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                                    else
                                        PorcMonto := (("GMAAmount (LCY)" * 100) / Facturas."Amount Including VAT");
                                    if ("Posted Payment Order Vouchers".GMACrMemoAppliedExists) then
                                        PorcMonto := 100;

                                    LineasFactura.RESET;
                                    LineasFactura.SETRANGE("Document No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                                    if LineasFactura.FindSet() then begin
                                        repeat
                                            Comportamiento.RESET;
                                            Comportamiento.SETRANGE(Comportamiento."GMAWithholding Code", LineasFactura."GMAWithholding Code");
                                            Comportamiento.SETRANGE(Comportamiento."GMATax System", "Movimiento Retenciones"."GMATax System");
                                            Comportamiento.SETRANGE(Comportamiento."GMAWithholding No.", "Movimiento Retenciones"."GMAWithholding No.");//NAVAR1.06
                                            if Comportamiento.FindSet() then begin
                                                DetRetencion.RESET;
                                                DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", Comportamiento."GMAWithholding No.");
                                                if DetRetencion.FindSet() then begin

                                                    ///Control de Valor en Detalle de Retención
                                                    //if DetRetencion.GMAValue = '' then
                                                    //    ControlValor := false
                                                    //else
                                                    ControlValor := true;

                                                    if ControlValor then begin

                                                        ///Controlo que sea una retencion de la empresa
                                                        retencionesempresa.RESET;
                                                        retencionesempresa.SETRANGE(retencionesempresa."GMATax Code", DetRetencion."GMATax Code");
                                                        if retencionesempresa.FindSet() then
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
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMATax Code", DetRetencion."GMATax Code");
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMAVendor Code", "Posted Payment Order Vouchers".GMAVendor);
                                                        if CondImpuesto.FindSet() then
                                                            CodCondicion := CondImpuesto."GMATax Condition";

                                                        if ControlProv then begin
                                                            Escala.RESET;
                                                            Escala.SETRANGE(Escala."GMAScale Code", DetRetencion."GMAScale Code");
                                                            Escala.SETRANGE(Escala."GMAWithholding Condition", CodCondicion);
                                                            if Escala.FindSet() then begin
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

                                        until LineasFactura.NEXT = 0;
                                    end;

                                end;
                            end;
                            if ("Posted Payment Order Vouchers"."GMADocument Type" = "Posted Payment Order Vouchers"."GMADocument Type"::"Credit Memo") then begin
                                Facturas2.RESET;
                                Facturas2.SETRANGE("No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                                if Facturas2.FindSet() then begin
                                    Facturas2.CALCFIELDS("Amount Including VAT");
                                    //Calculo porcentaje del pago sobre el total de la factura
                                    if Facturas2."Currency Factor" <> 0 then
                                        PorcMonto := (("GMAAmount (LCY)" * 100) / (Facturas2."Amount Including VAT" / Facturas2."Currency Factor"))
                                    else
                                        PorcMonto := (("GMAAmount (LCY)" * 100) / Facturas2."Amount Including VAT");

                                    LineasFactura2.RESET;
                                    LineasFactura2.SETRANGE("Document No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                                    if LineasFactura2.FindSet() then begin
                                        repeat
                                            Comportamiento.RESET;
                                            Comportamiento.SETRANGE(Comportamiento."GMAWithholding Code", LineasFactura2."GMAWithholding Code");
                                            Comportamiento.SETRANGE(Comportamiento."GMATax System", "Movimiento Retenciones"."GMATax System");
                                            if Comportamiento.FindSet() then begin
                                                DetRetencion.RESET;
                                                DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", Comportamiento."GMAWithholding No.");
                                                if DetRetencion.FindSet() then begin

                                                    ///Control de Valor en Detalle de Retención
                                                    //if DetRetencion.GMAValue = '' then
                                                    //    ControlValor := false
                                                    //else
                                                    ControlValor := true;

                                                    if ControlValor then begin

                                                        ///Controlo que sea una retencion de la empresa
                                                        retencionesempresa.RESET;
                                                        retencionesempresa.SETRANGE(retencionesempresa."GMATax Code", DetRetencion."GMATax Code");
                                                        if retencionesempresa.FindSet() then
                                                            if retencionesempresa.GMARetains = true then begin

                                                                ControlProv := false;
                                                                if retencionesempresa.GMAProvince = '' then
                                                                    ControlProv := true
                                                                else
                                                                    if (Facturas2.GMAProvince <> '') and (Facturas2.GMAProvince = retencionesempresa.GMAProvince) then
                                                                        ControlProv := true
                                                            end;

                                                        ///Control de la condicion de retencion del proveedor
                                                        CondImpuesto.RESET;
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMATax Code", DetRetencion."GMATax Code");
                                                        CondImpuesto.SETRANGE(CondImpuesto."GMAVendor Code", "Posted Payment Order Vouchers".GMAVendor);
                                                        if CondImpuesto.FindSet() then
                                                            CodCondicion := CondImpuesto."GMATax Condition";

                                                        if ControlProv then begin
                                                            Escala.RESET;
                                                            Escala.SETRANGE(Escala."GMAScale Code", DetRetencion."GMAScale Code");
                                                            Escala.SETRANGE(Escala."GMAWithholding Condition", CodCondicion);
                                                            if Escala.FindSet() then begin
                                                                case DetRetencion."GMAWithholding Base Type" of
                                                                    DetRetencion."GMAWithholding Base Type"::"Sin Impuestos":
                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                            Acumulado -= ((PorcMonto * (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor")) / 100)

                                                                        else
                                                                            Acumulado -= ((PorcMonto * LineasFactura2."VAT Base Amount") / 100);

                                                                    DetRetencion."GMAWithholding Base Type"::"Importe Impuestos":
                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                            Acumulado -= ((PorcMonto * ((LineasFactura2."Amount Including VAT" / Facturas2."Currency Factor")
                                                                                                - (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor"))) / 100)
                                                                        else
                                                                            Acumulado -= ((PorcMonto * (LineasFactura2."Amount Including VAT"
                                                                                                 - LineasFactura2."VAT Base Amount")) / 100);

                                                                    DetRetencion."GMAWithholding Base Type"::"Importe Total":
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
                            movfac.SETRANGE(movfac."Document No.", "Posted Payment Order Vouchers"."GMAVoucher No.");
                            ok := movfac.FindSet();

                            //NAVAR1.06002-
                            CLEAR(ImporteNC);
                            tipocomp := '';
                            if (movfac."Document Type" = movfac."Document Type"::Invoice) then begin
                                tipocomp := 'FC';
                                ImporteNC := FindApplicCreditMemo("Posted Payment Order Vouchers"."GMAVoucher No.");
                            end;

                            if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                tipocomp := 'NC';

                            if (movfac."Document Type" = movfac."GMADocument Type Loc."::"GMANota Debito") then
                                tipocomp := 'ND';

                            if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                Acumulado := -Acumulado;

                            Acumulado := ROUND(Acumulado, 0.01);

                            CLEAR(TOTAL);

                            if (HOPago."GMANew Payment") then
                                Acumulado := "Posted Payment Order Vouchers".GMACancelled;

                            AcumTotal := AcumTotal + Acumulado;

                            if ("Posted Payment Order Vouchers".GMACrMemoAppliedExists) then
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
                HLinCompPago: Record "GMAPosted Payment Ord Vouch";
                MovProveedor: Record "Vendor Ledger Entry";
                i: Integer;
                Dia: Text[2];
                Mes: Text[30];
                Anio: Text[4];
            begin
                DetRetencion.RESET;
                DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", "Movimiento Retenciones"."GMAWithholding No.");
                if DetRetencion.FindSet() then
                    Descripcion := DetRetencion.GMADescription;

                //GMDataScale MC +
                //Se deben sacar estos datos del historico de retenciones, no de la escala, esta puede cambiar.
                //Dejo para retenciones ya generadas

                if ("Movimiento Retenciones".GMAFrom = 0) and ("Movimiento Retenciones"."GMAFixed Amount" = 0) and ("Movimiento Retenciones"."GMABase Amount" = 0) then begin
                    Escala.RESET;
                    Escala.SETRANGE(Escala."GMAScale Code", "Movimiento Retenciones"."GMAScale Code");
                    Escala.SETRANGE(Escala."GMAWithholding Condition", "Movimiento Retenciones"."GMACondition Code");
                    Escala.SETRANGE(Escala."GMATax Code", "Movimiento Retenciones"."GMATax Code");
                    if Escala.FindSet() then
                        repeat
                            if (Escala.GMAFrom <= "Movimiento Retenciones"."GMACalculation Base") then begin
                                alicuota := Escala."GMAExcedent %";
                                minimo := Escala.GMAFrom;
                                MontoFijo := Escala."GMAFixed Amount";
                                decMinimoNoImp := Escala."GMABase Amount";
                            end;
                        until Escala.NEXT = 0;
                end
                else begin
                    alicuota := "Movimiento Retenciones"."GMAWithholding%";
                    minimo := "Movimiento Retenciones".GMAFrom;
                    MontoFijo := "Movimiento Retenciones"."GMAFixed Amount";
                    decMinimoNoImp := "Movimiento Retenciones"."GMABase Amount";
                end;
                //GMDataScale MC -


                //11807+
                "Withholding Kind Line".RESET;
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMAWithholding Code", "GMAWithholding Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMATax Code", "GMATax Code");
                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMAIs vendor withholding", true);
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

                if "Tipo fiscal".Get(Proveedor."GMAFiscal Type") then;

                //Proveedor.GET("Movimiento Retenciones"."GMAVendor Code"); //11807

                HOPago.GET("Movimiento Retenciones"."GMAVoucher Number");
                HOPago.CALCFIELDS("GMAPaid Amount (LCY)");
                HLinCompPago.SETRANGE("GMAPayment Order No.", HOPago."GMAPayment O. No.");
                HLinCompPago.FindFirst();
                for i := 1 to 60 do
                    txtNroComprobantes[i] := ' ';
                i := 1;
                repeat
                    Contador += 1;
                    if MovProveedor.GET(HLinCompPago."GMAEntry No.") then begin
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

                Dia := FORMAT(DATE2DMY("Movimiento Retenciones"."GMAWithholding Date", 1));
                Anio := FORMAT(DATE2DMY("Movimiento Retenciones"."GMAWithholding Date", 3));
                Mes := FORMAT("Movimiento Retenciones"."GMAWithholding Date", 0, '<Month Text>');
                txtLugarYFecha := 'Buenos Aires, ' + Dia + ' de ' + Mes + ' de ' + Anio + '.';
                txtDeclaracion := 'La presente retención se informará en la DDJJ correspondiente al mes de ' + Mes + ' del año ' + Anio + '.';

                if (HOPago."GMANew Payment") then begin
                    "Hist Lin Valor OPago".SETRANGE("GMAPayment Order No.", HOPago."GMAPayment O. No."); // "Posted Payment Order Vouchers"."Payment Order No."
                    "Hist Lin Valor OPago".SETRANGE("Hist Lin Valor OPago".GMAValue, "Movimiento Retenciones".GMAValue);
                    "Hist Lin Valor OPago".SETRANGE("Hist Lin Valor OPago"."GMAWithholding No.", "Movimiento Retenciones"."GMAWithholding No.");
                    if ("Hist Lin Valor OPago".FINDFIRST()) then begin
                        //IF("Hist Lin Valor OPago"."Pagos Anteriores" <> 0)THEN
                        decPagosAnt := "Hist Lin Valor OPago"."GMAPrevious Payments";
                        // IF("Hist Lin Valor OPago"."Retenciones Anteriores" <> 0)THEN
                        decRetenAnt := "Hist Lin Valor OPago"."GMAPrevious Withholdings";
                    end;
                end;
                if (alicuota = 0) then
                    if ("Movimiento Retenciones"."GMAWithholding%" <> 0) then
                        alicuota := "Movimiento Retenciones"."GMAWithholding%"
                    else begin
                        if ("Movimiento Retenciones"."GMACalculation Base" <> 0) and ("Movimiento Retenciones"."GMAWithholding Amount" <> 0) then
                            alicuota := ("Movimiento Retenciones"."GMAWithholding Amount" /
                            ("Movimiento Retenciones"."GMACalculation Base" + decPagosAnt - decMinimoNoImp)) * 100;
                    end;


                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Movimiento Retenciones"."GMAShortcut Dimension 1");
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
                RecProvincia.SETCURRENTKEY(RecProvincia."GMAProvince Code");
                RecProvincia.SETRANGE("GMAProvince Code", InfoEmpresa.BssiProvinceCode);
                if RecProvincia.FINDFIRST then
                    gProvincia := RecProvincia.GMADescription;

            end;

            trigger OnPreDataItem();
            begin
                /*ok := InfoEmpresa.FINDFIRST;
                InfoEmpresa.CALCFIELDS(GMAPicture2);*/
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
        "GMATreasury Setup": Record "GMATreasury Setup";
        InfoEmpresa: Record "Dimension Value";
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
        HOPago: Record "GMAPosted Payment Order";
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
        Temp_PagosProcesados: Record "GMAPosted Payment Order" temporary;
        txtNroC: array[30] of Text[250];
        Contador: Integer;
        "Hist Lin Valor OPago": Record "GMAPosted Payment Order Valu";
        tipocomp: Text[30];
        DescRet: Text[250];
        "Tipo fiscal": Record "GMAFiscal Type";
        globImpuestos: Record GMATaxes;
        tipoCond: Text[30];
        AcumTotal: Decimal;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        numero: Integer;
        ImporteNC: Decimal;
        TOTAL: Decimal;
        TOTALNC: Decimal;
        "Withholding Kind Line": Record "GMAWithholding Kind Line";
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
        RecProvincia: Record GMAProvince;
        direccionProveedor: Text[250];
        direccionEmpresa: Text[250];
        maestroPais: Record "Country/Region";

    procedure Fun_BaseRetGanHOP(NroHOPago: Code[20]) Dec_BaseHOP: Decimal;
    var
        HCabOP: Record "GMAPosted Payment Order";
        LinComprobanteOP: Record "GMAPosted Payment Ord Vouch";
        LineasFactura: Record "Purch. Inv. Line";
        LineasAbono: Record "Purch. Cr. Memo Line";
        Comportamiento: Record "GMAWithholding Kind Line";
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

        LinComprobanteOP.SETRANGE(LinComprobanteOP."GMAVoucher No.", NroHOPago);
        if LinComprobanteOP.FINDFIRST then begin
            HCabOP.GET(NroHOPago);
            HCabOP.CALCFIELDS("GMAPaid Amount (LCY)");
            Dec_PctAnulacion := LinComprobanteOP."GMAAmount (LCY)" / HCabOP."GMAPaid Amount (LCY)" * 100 * -1;
        end;

        if Dec_PctAnulacion = 100 then begin
            Dec_BaseHOP := 0;
            exit;
        end;

        CLEAR(LinComprobanteOP);
        LinComprobanteOP.SETRANGE("GMAPayment Order No.", NroHOPago);
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
        LinComprobanteOP.SETFILTER("GMADocument Type", '<>%1', LinComprobanteOP."GMADocument Type"::"Credit Memo");
        if LinComprobanteOP.FindSet() then
            repeat

                Dec_BaseDocu := 0;
                Dec_ImporteMov := 0;

                //Calculo porcentaje del pago sobre el total de la factura

                if Rec_MovProveedor.GET(LinComprobanteOP."GMAEntry No.") then begin
                    Rec_MovProveedor.CALCFIELDS("Amount (LCY)");
                    Dec_ImporteMov := Rec_MovProveedor."Amount (LCY)";
                end;

                if Dec_ImporteMov <> 0 then
                    if LinComprobanteOP."GMAExchange Rate" <> 0 then
                        PorcMonto := ((LinComprobanteOP."GMAAmount (LCY)" * 100) / (Dec_ImporteMov / LinComprobanteOP."GMAExchange Rate")) * -1
                    else
                        PorcMonto := ((LinComprobanteOP.GMAAmount * 100) / Dec_ImporteMov) * -1
                else
                    PorcMonto := 1;

                //Sumo el importe base de las líneas que aplican
                LineasFactura.RESET;
                LineasFactura.SETRANGE("Document No.", LinComprobanteOP."GMAVoucher No.");
                if LineasFactura.FindSet() then
                    repeat
                        Comportamiento.RESET;
                        Comportamiento.SETRANGE(Comportamiento."GMAWithholding Code", LineasFactura."GMAWithholding Code");
                        Comportamiento.SETRANGE(Comportamiento."GMATax Code", 'GANANCIAS');
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
        LinComprobanteOP.SETFILTER("GMADocument Type", '=%1', LinComprobanteOP."GMADocument Type"::"Credit Memo");
        if LinComprobanteOP.FindSet() then
            repeat

                Dec_BaseDocu := 0;
                Dec_ImporteMov := 0;

                //Calculo porcentaje del pago sobre el total de la factura

                if Rec_MovProveedor.GET(LinComprobanteOP."GMAEntry No.") then begin
                    Rec_MovProveedor.CALCFIELDS("Amount (LCY)");
                    Dec_ImporteMov := Rec_MovProveedor."Amount (LCY)";
                end;
                if Dec_ImporteMov <> 0 then
                    if LinComprobanteOP."GMAExchange Rate" <> 0 then
                        PorcMonto := ((LinComprobanteOP."GMAAmount (LCY)" * 100) / (Dec_ImporteMov / LinComprobanteOP."GMAExchange Rate")) * -1
                    else
                        PorcMonto := ((LinComprobanteOP.GMAAmount * 100) / Dec_ImporteMov) * -1
                else
                    PorcMonto := 1;

                //Resto el importe base de las líneas que aplican
                LineasAbono.RESET;
                LineasAbono.SETRANGE("Document No.", LinComprobanteOP."GMAVoucher No.");
                if LineasAbono.FindSet() then
                    repeat
                        Comportamiento.RESET;
                        Comportamiento.SETRANGE(Comportamiento."GMAWithholding Code", LineasAbono."GMAWithholding Code");
                        Comportamiento.SETRANGE(Comportamiento."GMATax Code", 'GANANCIAS');
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
                    recPCMH.SETRANGE("Pay-to Vendor No.", "Posted Payment Order Vouchers".GMAVendor);
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
