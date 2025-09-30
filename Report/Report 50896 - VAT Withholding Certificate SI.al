report 80896 "PersVAT Withholding Certifica"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    GMLocDescription
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107501 - VAT Withholding Certificate SI.rdl';


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
            column(InfoEmpresa_City_______InfoEmpresa_Provincia_______InfoEmpresa__Cod__Pais_Argentina_; InfoEmpresa.BssiBillingCity + ' - ' + InfoEmpresa.BssiProvinceCode + ' - ' + InfoEmpresa.BssiBillingCountry)
            {
            }
            column(InfoEmpresa__VAT_Registration_No__; InfoEmpresa.BssiRegistrationNo)
            {
            }
            column(InfoEmpresa__Withholding_Agent_No__; InfoEmpresa."BssiGrossIncomeNo")
            {
            }
            column(InfoEmpresa_Provincia; InfoEmpresa.BssiProvinceCode)
            {
            }
            column(Proveedor__No_ingresos_brutos_; Proveedor."GMLocGross Income Tax No")
            {
            }
            column(Proveedor__VAT_Registration_No__; Proveedor."VAT Registration No.")
            {
            }
            column("Proveedor_Address_______Proveedor_City_______Proveedor__Cód__Provincia_"; direccionProveedor)
            {
            }
            column(Proveedor_Name; Proveedor.Name)
            {
            }
            column(Movimiento_Retenciones__Withholding_Certification_No__; "GMLocWithh. Certificate No.")
            {
            }
            column(Movimiento_Retenciones__Fecha_comprobante_; GMLocDocumentDate)
            {
            }
            column("Provincia_Descripción"; Provincia.GMLocDescription)
            {
            }
            column(Descripcion; Descripcion)
            {
            }
            column(FORMAT_vbase_; '$ ' + FORMAT(vbase))
            {
            }
            column(FORMAT__Movimiento_Retenciones___Importe_retencion__; '$ ' + FORMAT("Withholding Ledger Entry"."GMLocWithholding Amount"))
            {
            }
            column(FORMAT_alicuota______; FORMAT(alicuota) + ' %')
            {
            }
            column(minimo; minimo)
            {
            }
            column(Movimiento_Retenciones_Regimen; "GMLocTax System")
            {
            }
            column(CERTIFICADO_DE_RETENCION_IVACaption; CERTIFICADO_DE_RETENCION_IVACaptionLbl)
            {
            }
            column(AGENTE_DE_RETENCIONCaption; AGENTE_DE_RETENCIONCaptionLbl)
            {
            }
            column("DirecciónCaption"; DirecciónCaptionLbl)
            {
            }
            column(Nro__de_CUITCaption; Nro__de_CUITCaptionLbl)
            {
            }
            column("Agente_RetenciónCaption"; Agente_RetenciónCaptionLbl)
            {
            }
            column("JurisdicciónCaption"; JurisdicciónCaptionLbl)
            {
            }
            column(Nro__de_IIBBCaption; Nro__de_IIBBCaptionLbl)
            {
            }
            column(Nro__de_CUITCaption_Control1000000018; Nro__de_CUITCaption_Control1000000018Lbl)
            {
            }
            column("DirecciónCaption_Control1000000021"; DirecciónCaption_Control1000000021Lbl)
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
            column("JurisdicciónCaption_Control1000000016"; JurisdicciónCaption_Control1000000016Lbl)
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
            column(REGIMEN_N_Caption; REGIMEN_N_CaptionLbl)
            {
            }
            column("Firma_del_Agente_de_RetenciónCaption"; Firma_del_Agente_de_RetenciónCaptionLbl)
            {
            }
            column("Aclaración_Caption"; Aclaración_CaptionLbl)
            {
            }
            column(Cargo_Caption; Cargo_CaptionLbl)
            {
            }
            column(Withholding_Ledger_Entry_No_; "GMLocNo.")
            {
            }
            column(Withholding_Ledger_Entry_Voucher_Number; "GMLocVoucher Number")
            {
            }
            // AW - Begin
            column(Withholding_Ledger_Entry_GMLocCalculation_Base; "Withholding Ledger Entry"."GMLocCalculation Base")
            { }
            // AW - End
            column(GMLocPictureSign; "GMLocTreasury Setup".GMLocSignPicture)
            {
            }
            dataitem("GMLocPosted Payment Order Vouchers"; "GMLocPosted Payment Ord Vouch")
            {
                DataItemLink = "GMLocPayment Order No." = FIELD("GMLocVoucher Number");
                DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.") ORDER(Ascending);
                column(Movimiento_Retenciones__Valor; "Withholding Ledger Entry".GMLocValue)
                {
                }
                column(FORMAT_Acumulado_; '$ ' + FORMAT(Acumulado))
                {
                }
                column(Hist_Lin_Comp_OPago__Nro_Comprobante_; "GMLocVoucher No.")
                {
                }
                column(movfac__External_Document_No__; movfac."External Document No.")
                {
                }
                column(ReferenciaCaption; ReferenciaCaptionLbl)
                {
                }
                column("Cod__RetenciónCaption"; Cod__RetenciónCaptionLbl)
                {
                }
                column(ImponibleCaption; ImponibleCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000047; EmptyStringCaption_Control1000000047Lbl)
                {
                }
                column(Nro__FacturaCaption; Nro__FacturaCaptionLbl)
                {
                }
                column("Declaración_en_la_que_se_informará_la_retencion__Caption"; Declaración_en_la_que_se_informará_la_retencion__CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control1000000049; EmptyStringCaption_Control1000000049Lbl)
                {
                }
                column(Posted_Payment_Order_Vouchers_Payment_Order_No_; "GMLocPayment Order No.")
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
                begin
                    Acumulado := 0;
                    ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                    movfac.RESET;
                    movfac.SETRANGE(movfac."Document No.", "GMLocPosted Payment Order Vouchers"."GMLocVoucher No.");
                    if movfac.FindSet() then begin
                        movfac.CALCFIELDS("Original Amt. (LCY)");
                        Acumulado := -movfac."Original Amt. (LCY)";

                        DetRetencion.RESET;
                        DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", "Withholding Ledger Entry"."GMLocWithholding No.");
                        if DetRetencion.FindSet() then;

                    end;

                    Acumulado := 0;
                    LineasFactura.RESET;
                    LineasFactura.SETCURRENTKEY("Document No.", "Line No.");
                    LineasFactura.SETRANGE("Document No.", "GMLocPosted Payment Order Vouchers"."GMLocVoucher No.");
                    if LineasFactura.FINDFIRST then begin
                        repeat
                            Acumulado := Acumulado + LineasFactura."VAT Base Amount";
                        until LineasFactura.NEXT = 0;
                        Acumulado := ROUND(Acumulado, 0.01);
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            var
                BssiMEMSystemSetup: record BssiMEMSystemSetup;
            begin
                DetRetencion.RESET;
                DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", "Withholding Ledger Entry"."GMLocWithholding No.");
                if DetRetencion.FindSet() then
                    Descripcion := DetRetencion.GMLocDescription;

                Escala.RESET;
                Escala.SETRANGE(Escala."GMLocScale Code", "Withholding Ledger Entry"."GMLocScale Code");
                Escala.SETRANGE(Escala."GMLocWithholding Condition", "Withholding Ledger Entry"."GMLocCondition Code");
                Escala.SETRANGE(Escala."GMLocTax Code", "Withholding Ledger Entry"."GMLocTax Code");
                if Escala.FindSet() then
                    repeat
                        if (Escala.GMLocFrom <= "Withholding Ledger Entry"."GMLocCalculation Base") then begin
                            alicuota := Escala."GMLocExcedent %";
                            minimo := Escala.GMLocFrom;
                        end;
                    until Escala.NEXT = 0;
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
                    if maestroPais.FindFirst() then direccionProveedor := direccionProveedor + ', ' + maestroPais.GetNameInCurrentLanguage();
                end;

                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Withholding Ledger Entry"."GMLocShortcut Dimension 1");
                IF (InfoEmpresa.FindFirst()) THEN;
                InfoEmpresa.CALCFIELDS(InfoEmpresa.BssiPicture);
                Provincia.RESET;
                Provincia.SETCURRENTKEY(Provincia."GMLocProvince Code");
                Provincia.SETRANGE("GMLocProvince Code", InfoEmpresa.BssiProvinceCode);
                if Provincia.FINDFIRST then
                    gProvincia := Provincia.GMLocDescription;
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
                ok := InfoEmpresa.FindSet();
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
        vbase: Decimal;
        "Withholding Kind Line": Record "GMLocWithholding Kind Line";
        CERTIFICADO_DE_RETENCION_IVACaptionLbl: Label 'CERTIFICADO DE RETENCION IVA';
        AGENTE_DE_RETENCIONCaptionLbl: Label 'AGENTE DE RETENCION';
        "DirecciónCaptionLbl": Label 'Dirección';
        Nro__de_CUITCaptionLbl: Label 'Nro. de CUIT';
        "Agente_RetenciónCaptionLbl": Label 'Agente Retención';
        "JurisdicciónCaptionLbl": Label 'Jurisdicción';
        Nro__de_IIBBCaptionLbl: Label 'Nro. de IIBB';
        Nro__de_CUITCaption_Control1000000018Lbl: Label 'Nro. de CUIT';
        "DirecciónCaption_Control1000000021Lbl": Label 'Dirección';
        SUJETO_DE_RETENCIONCaptionLbl: Label 'SUJETO DE RETENCION';
        Certificado_N_CaptionLbl: Label 'Certificado Nº';
        FechaCaptionLbl: Label 'Fecha';
        "JurisdicciónCaption_Control1000000016Lbl": Label 'Jurisdicción';
        RETENCIONCaptionLbl: Label 'RETENCION';
        B__IMPONIBLECaptionLbl: Label 'B. IMPONIBLE';
        ALICUOTACaptionLbl: Label 'ALICUOTA';
        MINIMOCaptionLbl: Label 'MINIMO';
        RETENIDOCaptionLbl: Label 'RETENIDO';
        EmptyStringCaptionLbl: Label '*';
        EmptyStringCaption_Control1000000041Lbl: Label '*';
        EmptyStringCaption_Control1000000042Lbl: Label '-';
        EmptyStringCaption_Control1000000046Lbl: Label '-';
        REGIMEN_N_CaptionLbl: Label 'REGIMEN Nº';
        "Firma_del_Agente_de_RetenciónCaptionLbl": Label 'Firma del Agente de Retención';
        "Aclaración_CaptionLbl": Label 'Aclaración:';
        Cargo_CaptionLbl: Label 'Cargo:';
        ReferenciaCaptionLbl: Label 'Referencia';
        "Cod__RetenciónCaptionLbl": Label 'Cod. Retención';
        ImponibleCaptionLbl: Label 'Imponible';
        EmptyStringCaption_Control1000000047Lbl: Label '-';
        Nro__FacturaCaptionLbl: Label 'Nro. Factura';
        "Declaración_en_la_que_se_informará_la_retencion__CaptionLbl": Label 'Declaración en la que se informará la retencion :';
        EmptyStringCaption_Control1000000049Lbl: Label '*';
        gProvincia: Text[50];
        direccionProveedor: Text[250];
        direccionEmpresa: Text[250];
        maestroPais: Record "Country/Region";
        "GMLocTreasury Setup": Record "GMLocTreasury Setup";
}

