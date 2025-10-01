namespace ALProject.ALProject;
using Microsoft.Projects.Project.Job;
using Microsoft.Purchases.Document;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Journal;
using System.Security.AccessControl;
using System.Automation;
using Microsoft.Purchases.Payables;
using Microsoft.Finance.Dimension;
using System.Utilities;
using Microsoft.Purchases.Vendor;
using Microsoft.Bank.BankAccount;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.Company;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Purchases.History;
//DDS15082025 se agrego el aprobador y se cambio el layout ocultando la firma en OP y agregando el aprobador
report 34006890 "PersPayment Order"
{
    Caption = 'PersPayment Order';
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107485 - Payment Order.rdl';
    dataset
    {
        dataitem("Hist Cab OPago"; "GMAPosted Payment Order")
        {
            RequestFilterFields = "GMAPayment O. No.", "GMAExternal Document No.";
            column(FIRMA_SOLICITANTECaption; FIRMA_SOLICITANTECaptionLbl) { }
            column(FIRMA_GERENTE_FINANCIEROCaption; FIRMA_GERENTE_FINANCIEROCaptionLbl) { }
            column(GMAPictureSign; "GMATreasury Setup".GMASignPicture) { }
            column(FIRMA_GERENTE_GENERALCaption; FIRMA_GERENTE_GENERALCaptionLbl) { }
            column(Hist_Cab_OPago_Payment_O__No_; "GMAPayment O. No.") { }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    column(Hist_Cab_OPago_Nombre; "Hist Cab OPago".GMAName) { }
                    column(Hist_Cab_OPago_Domicilio; "Hist Cab OPago".GMAAddress) { }
                    column(Proveedor__Post_Code_; Proveedor."Post Code") { }
                    column(Proveedor_City; Proveedor.City) { }
                    column(Proveedor_County; Proveedor.County) { }
                    column(Proveedor_Phone; Proveedor."Phone No.") { }
                    column(Proveedor_Fax; Proveedor."Fax No.") { }
                    column(Hist_Cab_OPago__Hist_Cab_OPago___Fecha_de_O__Pago_; FechaReporte) { }
                    column(Hist_Cab_OPago_LocARCUIT; "Hist Cab OPago".GMACUIT) { }
                    column(Hist_Cab_OPago__Hist_Cab_OPago___Nro_Proveedor_; "Hist Cab OPago"."GMAVendor No.") { }
                    column(Proveedor__No__ingresos_brutos_; Proveedor."GMAGross Income Tax No") { }
                    column(InfoEmpresa__Phone_No__; InfoEmpresa.BssiBillingPhoneNumber) { }
                    column(InfoEmpresa__E_Mail_; InfoEmpresa.BssiEmail) { }
                    column(InfoEmpresa__Post_Code_; InfoEmpresa.BssiBillingZipCode) { }
                    column(gProvincia______InfoEmpresa__Country_Region_Code_; gProvincia + ', ' + InfoEmpresa.BssiBillingCountry) { }
                    column(InfoEmpresa_LocARAddress; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa.BssiBillingZipCode + ', ' + InfoEmpresa.BssiBillingCity + ', ' + InfoEmpresa.BssiBillingCountry + ', ' + RecPais.Name)//InfoEmpresa."Country/Region Code")
                    {
                    }
                    column(InfoEmpresa_Fax; '') { }
                    column(Hist_Cab_OPago__Hist_Cab_OPago___Nro_O_Pago_; "Hist Cab OPago"."GMAPayment O. No.") { }
                    column(InfoEmpresa_LocARName; InfoEmpresa.BssiLegalNameFull) { }
                    column(OutputNo; OutputNo) { }
                    column(Hist_Cab_OPago_Usuario; "Hist Cab OPago"."GMAUser Id") { }
                    column(InfoEmpresa_Picture; InfoEmpresa.BssiPicture) { }
                    column(Hist_Cab_OPago___Create_OP_User_; "Hist Cab OPago"."GMACreate OP User") { }
                    column(Fecha_Caption; Fecha_CaptionLbl) { }
                    column(SE_ORES_Caption; SE_ORES_CaptionLbl) { }
                    column(C_U_I_T___Caption; C_U_I_T___CaptionLbl) { }
                    column(Proveedor_N___Caption; Proveedor_N___CaptionLbl) { }
                    column(INGRESOS_BRUTOS_N__Caption; INGRESOS_BRUTOS_N__CaptionLbl) { }
                    column(Tel_Caption; Tel_CaptionLbl) { }
                    column(E_mailCaption; E_mailCaptionLbl) { }
                    column(O_R_D_E_N___D_E___P_A_G_OCaption; O_R_D_E_N___D_E___P_A_G_OCaptionLbl) { }
                    column(C_P_Caption; C_P_CaptionLbl) { }
                    column(N__Caption; N__CaptionLbl) { }
                    column(PageLoop_Number; number) { }
                    column(ImporteLetras; ImporteLetras) { }
                    column(ImporteLetrasBanco; ImporteLetrasBanco) { }
                    column(UserAprovalName; UserAprovalName) { }
                    column(leyenda2; leyenda2) { }
                    column(DiferenciaDeCambio; DiferenciaDeCambio) { }
                    column(EsDolar; EsDolar) { }
                    column(CuentaDifDeCambio; CuentaDifDeCambio) { }
                    column(SimboloMonedaFuncional; SimboloMonedaFuncional) { }
                    column(Proveedor_CUIT; Proveedor."VAT Registration No.") { }
                    column(InfoEmpresa__CUIT; InfoEmpresa.BssiTaxRegistrationNumber) { }
                    dataitem("GMAPosted Payment Ord Vouch"; "GMAPosted Payment Ord Vouch")
                    {
                        DataItemLink = "GMAPayment Order No." = FIELD("GMAPayment O. No.");
                        DataItemLinkReference = "Hist Cab OPago";
                        DataItemTableView = SORTING("GMAPayment Order No.", "GMAVoucher No.");
                        MaxIteration = 0;
                        column(Hist_Cab_OPago___En_concepto_de_; "Hist Cab OPago"."GMABy way of") { }
                        column(NumFacProveedor; NumFacProveedor) { }
                        column(Hist_Lin_Comp_OPago_Fecha; DocumentDate) { }
                        column(Hist_Lin_Comp_OPago_Importe; GMAAmount) { }
                        column(Valordivisa; Valordivisa) { }
                        column(Hist_Lin_Comp_OPago_Cancelado; GMACancelled) { }
                        column(Importepesos; Importepesos) { }
                        column(CodProyecto; CodProyecto) { }
                        column(txtSaldoCuentaC; txtSaldoCuentaC) { }
                        column(txtSaldoSi; txtSaldoSi) { }
                        column(NombreObra; NombreObra) { }
                        column(Hist_Lin_Comp_OPago_Importe_Control1000000027; GMAAmount) { }
                        column(Hist_Lin_Comp_OPago_Cancelado_Control1000000028; GMACancelled) { }
                        column(Totalpesos; Totalpesos) { }
                        column(DATOS_DE_FACTURAS_O_N__DEBITOSCaption; DATOS_DE_FACTURAS_O_N__DEBITOSCaptionLbl) { }
                        column(ComprobanteCaption; ComprobanteCaptionLbl) { }
                        column(Hist_Lin_Comp_OPago_FechaCaption; FIELDCAPTION(GMADate)) { }
                        column(Hist_Lin_Comp_OPago_ImporteCaption; FIELDCAPTION(GMAAmount)) { }
                        column(DivisaCaption; DivisaCaptionLbl) { }
                        column(Su_PagoCaption; Su_PagoCaptionLbl) { }
                        column(En_PesosCaption; En_PesosCaptionLbl) { }
                        column(EN_CONCEPTO_DECaption; EN_CONCEPTO_DECaptionLbl) { }
                        column(Job_NoCaption; Job_NoCaptionLbl) { }
                        column(T_O_T_A_L_E_S_Caption; T_O_T_A_L_E_S_CaptionLbl) { }
                        column(EmptyStringCaption; EmptyStringCaptionLbl) { }
                        column(Posted_Payment_Order_Vouchers_Payment_Order_No_; "GMAPayment Order No.") { }
                        column(Posted_Payment_Order_Vouchers_Voucher_No_; "GMAVoucher No.") { }
                        column(Posted_Payment_Order_Vouchers_Entry_No_; "GMAEntry No.") { }
                        column(Facturas_Total; Facturas."Amount Including VAT") { }
                        column(TipoDocumento; TipoDocumento) { }
                        column(SimboloMonedaVoucher; SimboloMonedaVoucher) { }
                        column(FlagVoucher; FlagVoucher) { }
                        trigger OnAfterGetRecord();
                        begin
                            //   if "GMACurrency Code" <> '' then
                            //   CambioMoneda.GET("GMACurrency Code", GMADate);

                            if "GMAPosted Payment Ord Vouch"."GMACurrency Code" = '' then
                                Valordivisa := 'PESO ARG'
                            else
                                Valordivisa := "GMAPosted Payment Ord Vouch"."GMACurrency Code";

                            if "GMACurrency Code" <> '' then //"GMAExchange Rate" <> 0 then
                                Importepesos := "GMATo be Cancelled (LCY)" //* CambioMoneda."Relational Exch. Rate Amount" // "GMAExchange Rate"
                            else
                                Importepesos := GMACancelled;

                            Totalpesos := Totalpesos + Importepesos;

                            if Facturas.GET("GMAPosted Payment Ord Vouch"."GMAVoucher No.") then
                                IF (Facturas."Vendor Invoice No." = '') THEN
                                    NumFacProveedor := "GMAPosted Payment Ord Vouch"."GMAVoucher No."
                                else
                                    NumFacProveedor := Facturas."Vendor Invoice No."
                            else begin
                                RecPurchCRMemoInv2.RESET;
                                if RecPurchCRMemoInv2.GET("GMAPosted Payment Ord Vouch"."GMAVoucher No.") then
                                    IF (Facturas."Vendor Invoice No." = '') THEN
                                        NumFacProveedor := "GMAPosted Payment Ord Vouch"."GMAVoucher No."
                                    else
                                        NumFacProveedor := RecPurchCRMemoInv2."Vendor Cr. Memo No."
                                else
                                    //CMD(21/05/14)Pongo en nro externo en la linea de la op
                                    if "GMAPosted Payment Ord Vouch"."GMADocument No" <> '' then
                                        NumFacProveedor := "GMAPosted Payment Ord Vouch"."GMADocument No"
                                    else
                                        if ("GMAPosted Payment Ord Vouch"."GMAAmount (LCY)" <> 0) then
                                            NumFacProveedor := 'PAGO A CUENTA';
                            end;
                            DocumentDate := Facturas."Document Date";
                            if ("GMAPosted Payment Ord Vouch"."GMADocument Type" = "GMAPosted Payment Ord Vouch"."GMADocument Type"::Payment) then
                                NumFacProveedor := "GMAPosted Payment Ord Vouch"."GMAVoucher No.";
                            //Busco Proyecto en Los Distintos documentos--
                            CLEAR(CodProyecto);
                            Encontro := false;
                            case "GMADocument Type" of
                                "GMADocument Type"::Invoice:
                                    begin
                                        RecPurchHeaderInv.RESET;
                                        RecPurchHeaderInv.SETCURRENTKEY("No.");
                                        RecPurchHeaderInv.SETRANGE("No.", "GMAVoucher No.");
                                        if RecPurchHeaderInv.FINDFIRST then begin

                                            //CodProyecto := RecPurchHeaderInv."Job No.";
                                            //
                                            if CodProyecto <> '' then begin
                                                //      Obra.SETFILTER(Obra."No.",CodProyecto);
                                                //         IF Obra.FINDFIRST THEN
                                                //          NombreObra:=Obra.Description
                                                //       ELSE
                                                NombreObra := '';
                                                //
                                                Encontro := true;
                                            end
                                        end else
                                            CodProyecto := '';
                                    end;
                                "GMADocument Type"::"Credit Memo":
                                    begin
                                        RecPurchCRMemoInv.RESET;
                                        RecPurchCRMemoInv.SETCURRENTKEY("No.");
                                        RecPurchCRMemoInv.SETRANGE("No.", "GMAVoucher No.");
                                        if RecPurchCRMemoInv.FINDFIRST then begin
                                            //CodProyecto := RecPurchCRMemoInv."Job No.";
                                            //Obra.SETFILTER(Obra."No.",CodProyecto);
                                            // Obra.FINDFIRST;
                                            // NombreObra:=Obra.Description;

                                            Encontro := true;
                                        end else
                                            CodProyecto := '';
                                    end
                            end;
                            if not Encontro then begin
                                RecPurchHeader.RESET;
                                RecPurchHeader.SETCURRENTKEY("No.");
                                RecPurchHeader.SETRANGE("No.", "GMAVoucher No.");
                                if RecPurchHeader.FINDFIRST then
                                    CodProyecto := ''
                                else
                                    CodProyecto := '';
                            end;
                            //Busco Proyecto en Los Distintos documentos++
                            //NAVAR1.06002-
                            if not "Calc&ShowLin" then begin
                                AuxRecHistLinCOP.RESET;
                                AuxRecHistLinCOP.SETCURRENTKEY("GMAPayment Order No.", "GMAVoucher No.", "GMAEntry No.");
                                AuxRecHistLinCOP.SETRANGE("GMAPayment Order No.", "Hist Cab OPago"."GMAPayment O. No.");
                                if AuxRecHistLinCOP.FINDSET then
                                    repeat
                                        if AuxRecHistLinCOP."GMAExchange Rate" <> 0 then
                                            AuxImportePesos := AuxRecHistLinCOP."GMATo be Cancelled (LCY)"
                                        else
                                            AuxImportePesos := AuxRecHistLinCOP.GMACancelled;

                                        AuxTotalPesos += AuxImportePesos;
                                    until AuxRecHistLinCOP.NEXT = 0;
                                CLEAR(TotalConfirmadoCuenta);
                                txtSaldoCuentaC := Text001 + ' ' + FORMAT(TODAY) + ' $' + FORMAT(CuentaC, 0, '<Sign><Integer Thousand><Decimals,3>');
                                TotalConfirmadoCuenta := CuentaC - AuxTotalPesos;
                                txtSaldoSi := Text002 + ' $' + FORMAT(TotalConfirmadoCuenta, 0, '<Sign><Integer Thousand><Decimals,3>');
                                "Calc&ShowLin" := true;
                            end;

                            if "GMAPosted Payment Ord Vouch"."GMADocument Type" = "GMAPosted Payment Ord Vouch"."GMADocument Type"::" " then
                                TipoDocumento := '';
                            if "GMAPosted Payment Ord Vouch"."GMADocument Type" = "GMAPosted Payment Ord Vouch"."GMADocument Type"::Payment then
                                TipoDocumento := 'OP';
                            if "GMAPosted Payment Ord Vouch"."GMADocument Type" = "GMAPosted Payment Ord Vouch"."GMADocument Type"::Invoice then
                                TipoDocumento := 'FC';
                            if "GMAPosted Payment Ord Vouch"."GMADocument Type" = "GMAPosted Payment Ord Vouch"."GMADocument Type"::"Credit Memo" then
                                TipoDocumento := 'NC';
                            if "GMAPosted Payment Ord Vouch"."GMADocument Type" = "GMAPosted Payment Ord Vouch"."GMADocument Type"::"GMANota Debito" then
                                TipoDocumento := 'ND';
                            if "GMAPosted Payment Ord Vouch"."GMADocument Type" = "GMAPosted Payment Ord Vouch"."GMADocument Type"::GMARecibo then
                                TipoDocumento := 'RC';

                            if "GMAPosted Payment Ord Vouch"."GMACurrency Code" = '' then
                                SimboloMonedaVoucher := '$'
                            else begin
                                VoucherMoneda.GET("GMAPosted Payment Ord Vouch"."GMACurrency Code");
                                SimboloMonedaVoucher := VoucherMoneda.Symbol;
                            end;

                            if (SimboloMonedaVoucherVoucherAnterior <> '') and (SimboloMonedaVoucherVoucherAnterior <> SimboloMonedaVoucher) then begin
                                SimboloMonedaVoucherVoucherAnterior := SimboloMonedaVoucher;
                                FlagVoucher := 0;
                            end
                            else begin
                                FlagVoucher := 1;
                                SimboloMonedaVoucherVoucherAnterior := SimboloMonedaVoucher;
                            end;

                            //NAVAR1.06002+
                            /*Language_Code := 'ESP';
                            if Language_Code = 'ENU' then begin
                                Convierto.FormatNoText(NumberText, ROUND("GMAPosted Payment Ord Vouch".GMAAmount, 0.01),
                                "GMAPosted Payment Ord Vouch"."GMACurrency Code");
                                end
                             else begin
                                Convierto.FormatNoText(NumberText, ROUND("GMAPosted Payment Ord Vouch".GMAAmount, 0.01),
                                '');
                            end;


                            if "GMAPosted Payment Order Valu"."GMACurrency Code" <> '' then begin
                                ok := Moneda.GET("GMAPosted Payment Order Valu"."GMACurrency Code");
                            if (Moneda."Currency Factor" <> 0) then
                                leyenda2 := 'Al solo  efecto impositivo el tipo de cambio aplicado es de $ ' + FORMAT(ROUND(1 / Moneda."Currency Factor", 0.0001, '=')) +
                                'por cada ' + Moneda.Description;

                            ImporteLetras := 'Son ' + Moneda.Description + ': ' + NumberText[1] + NumberText[2] /*+ '  a TC: ' + FORMAT(ROUND(1/factor,0.0001,'='))*/
                            ;
                            //end
                            //else ImporteLetras := 'Son Pesos: ' + NumberText[1] + NumberText[2];																	
                        end;

                        trigger OnPreDataItem();
                        begin
                            Totalpesos := 0;
                        end;
                    }
                    dataitem("GMAPosted Payment Order Valu"; "GMAPosted Payment Order Valu")
                    {
                        DataItemLink = "GMAPayment Order No." = FIELD("GMAPayment O. No.");
                        DataItemLinkReference = "Hist Cab OPago";
                        DataItemTableView = SORTING("GMAPayment Order No.", "GMALine No.");
                        column(Hist_Lin_Valor_OPago__N__Valor_; "GMAValue No.") { }
                        column(Valores_Descripcion; Valores.GMADescription) { }
                        column(Hist_Lin_Valor_OPago_Entidad; GMAEntity) { }
                        column(Hist_Lin_Valor_OPago__A_Fecha_; "GMATo Date") { }
                        column(Hist_Lin_Valor_OPago_Importe; GMAAmount) { }
                        column(Valordivisa_Control1000000044; Valordivisa) { }
                        column(Importepesos_Control1000000046; Importepesos) { }
                        column(ImportepesosSum; ImportepesosSum) { }
                        column(Hist_Lin_Valor_OPago_ImporteSum; Hist_Lin_Valor_OPago_ImporteSum) { }
                        column(Hist_Lin_Valor_OPago_Caja; "GMACash/Bank") { }
                        column(Hist_Lin_Valor_OPago_Importe_Control1000000048; GMAAmount) { }
                        column(Totalpesos_Control1000000053; Totalpesos) { }
                        column(N_meroCaption; N_meroCaptionLbl) { }
                        column(S_E_G_U_N___D_E_T_A_L_L_E_Caption; S_E_G_U_N___D_E_T_A_L_L_E_CaptionLbl) { }
                        column(ValorCaption; ValorCaptionLbl) { }
                        column(Hist_Lin_Valor_OPago_EntidadCaption; FIELDCAPTION(GMAEntity)) { }
                        column(Hist_Lin_Valor_OPago__A_Fecha_Caption; FIELDCAPTION("GMATo Date")) { }
                        column(Hist_Lin_Valor_OPago_ImporteCaption; FIELDCAPTION(GMAAmount)) { }
                        column(DivisaCaption_Control1000000045; DivisaCaption_Control1000000045Lbl) { }
                        column(En_PesosCaption_Control1000000047; En_PesosCaption_Control1000000047Lbl) { }
                        column(CajaCaption; CajaCaptionLbl) { }
                        column(EmptyStringCaption_Control1000000034; EmptyStringCaption_Control1000000034Lbl) { }
                        column(T_O_T_A_L_E_S_Caption_Control1000000035; T_O_T_A_L_E_S_Caption_Control1000000035Lbl) { }
                        column(Posted_Payment_Order_Values_Payment_Order_No_; "GMAPayment Order No.") { }
                        column(Posted_Payment_Order_Values_Line_No_; "GMALine No.") { }
                        column(Banco_Nombre; Banco.GMADescription) { }
                        column(Banco_Sucursal; BankMaster."Bank Branch No.") { }
                        column(SimboloMonedaValue; SimboloMonedaValue) { }
                        column(FlagValue; FlagValue) { }

                        //Reporte de IIBB
                        dataitem(GMAWithholdingLedgerEntry; "GMAWithholding Ledger Entry")
                        {
                            DataItemLink = "GMAVoucher Number" = field("GMAPayment Order No."), "GMAWithholding No." = field("GMAWithholding No.");
                            DataItemLinkReference = "GMAPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMANo.");

                            //RequestFilterFields = "GMANo.";
                            RequestFilterFields = "GMAWithh. Certificate No.";
                            column(InfoEmpresa_Name; DimensionValue.BssiLegalNameFull) { }
                            column(ValueType; ValueType) { }
                            column(GMAWithholdingNo; "GMAWithholding No.") { }
                            column(InfoEmpresa_Picture_hdr; DimensionValue.BssiPicture) { }
                            column(InfoEmpresa_LocARAddress2; DimensionValue.BssiBillingAddr1 + ', ' + DimensionValue.BssiBillingZipCode + ', ' + DimensionValue.BssiBillingCity + ', ' + gProvincia + ', ' + DimensionValue.BssiBillingCountry) { }
                            column(InfoEmpresa__Phone_No__2; DimensionValue.BssiBillingPhoneNumber) { }
                            column(InfoEmpresa__E_Mail_2; DimensionValue.BssiEmail) { }
                            column(InfoEmpresa__Home_Page_; DimensionValue.BssiHomePage) { }
                            column(InfoEmpresa_Address; direccionEmpresa) { }
                            column(InfoEmpresa__Address_2_; DimensionValue.BssiBillingAddress2) { }
                            column(InfoEmpresa__VAT_Registration_No__; DimensionValue.BssiRegistrationNo) { }
                            column(InfoEmpresa__N__agente_retenci_n_; DimensionValue.BssiGrossIncomeNo) { }
                            column(InfoEmpresa_Provincia; DimensionValue.BssiProvinceCode) { }
                            column(Proveedor__No__ingresos_brutos_2; Proveedor."GMAGross Income Tax No") { }
                            column(Proveedor__VAT_Registration_No__; Proveedor."VAT Registration No.") { }
                            column(Proveedor_Address; direccionProveedor) { }
                            column(Proveedor_Name; Proveedor.Name) { }
                            column(Movimiento_Retenciones__N__Certificado_Retencion_; "GMAWithh. Certificate No.") { }
                            column(Movimiento_Retenciones__Fecha_comprobante_; "GMAVoucher Date") { }
                            column(Provincia__Descripci_n_; DimensionValue.BssiProvinceCode) { }
                            column(DetRetencion_Titulo; DetRetencion.GMATitle) { }
                            column(Text1; Text1) { }
                            column(Text2; Text2) { }
                            column(Tipo_fiscal__Description; "Tipo fiscal".GMADescription) { }
                            column(Descripcion; Descripcion) { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_; "GMACalculation Base") { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_; "GMAWithholding Amount") { }
                            column(alicuota; alicuota) { }
                            column(minimo; minimo) { }
                            column(gblProvincia; gblProvincia) { }
                            column(AGENTE_DE_RETENCIONCaption; AGENTE_DE_RETENCIONCaptionLbl) { }
                            column(Direcci_nCaption; Direcci_nCaptionLbl) { }
                            column(Nro__de_CUITCaption; Nro__de_CUITCaptionLbl) { }
                            column(Agente_Retenci_nCaption; Agente_Retenci_nCaptionLbl) { }
                            column(Juridisdicci_nCaption; Juridisdicci_nCaptionLbl) { }
                            column(Nro__de_IIBBCaption; Nro__de_IIBBCaptionLbl) { }
                            column(Nro__de_CUITCaption_Control1000000018; Nro__de_CUITCaption_Control1000000018Lbl) { }
                            column(Direcci_nCaption_Control1000000021; Direcci_nCaption_Control1000000021Lbl) { }
                            column(SUJETO_DE_RETENCIONCaption; SUJETO_DE_RETENCIONCaptionLbl) { }
                            column(Certificado_N_Caption; Certificado_N_CaptionLbl) { }
                            column(FechaCaption; FechaCaptionLbl) { }
                            column(Jurisdicci_nCaption; Jurisdicci_nCaptionLbl) { }
                            column(RETENCIONCaption; RETENCIONCaptionLbl) { }
                            column(B__IMPONIBLECaption; B__IMPONIBLECaptionLbl) { }
                            column(ALICUOTACaption; ALICUOTACaptionLbl) { }
                            column(MINIMOCaption; MINIMOCaptionLbl) { }
                            column(RETENIDOCaption; RETENIDOCaptionLbl) { }
                            column(EmptyStringCaption2; EmptyStringCaptionLbl) { }
                            column(EmptyStringCaption_Control1000000041; EmptyStringCaption_Control1000000041Lbl) { }
                            column(EmptyStringCaption_Control1000000042; EmptyStringCaption_Control1000000042Lbl) { }
                            column(EmptyStringCaption_Control1000000046; EmptyStringCaption_Control1000000046Lbl) { }
                            column("jurisdicciónCaption"; jurisdicciónCaptionLbl) { }
                            column(Sit__ante_IVA_Caption; Sit__ante_IVA_CaptionLbl) { }
                            column(Withholding_Ledger_Entry_No_; "GMANo.") { }
                            column(Withholding_Ledger_Entry_Voucher_Number; "GMAVoucher Number") { }
                            column(GMAPictureSign2; "GMATreasury Setup".GMASignPicture) { }
                            dataitem("Posted Payment Order Vouchers"; "GMAPosted Payment Ord Vouch")
                            {
                                DataItemLink = "GMAPayment Order No." = FIELD("GMAVoucher Number");
                                DataItemTableView = SORTING("GMAPayment Order No.", "GMAVoucher No.") ORDER(Ascending);
                                column(Movimiento_Retenciones__Valor; GMAWithholdingLedgerEntry.GMAValue) { }
                                column(Acumulado; Acumulado) { }
                                column(Hist_Lin_Comp_OPago__Nro_Comprobante_; "GMAVoucher No.") { }
                                column(movfac__External_Document_No__; movfac."External Document No.") { }
                                column(tipocomp; tipocomp) { }
                                column(Hist_Lin_Comp_OPago__Nro_O_Pago_; "GMAPayment Order No.") { }
                                column("Movimiento_Retenciones__NombreRetención"; GMAWithholdingLedgerEntry.GMAWithholdingName) { }
                                column(Movimiento_Retenciones__Valor_Control1000000056; GMAWithholdingLedgerEntry.GMAValue) { }
                                column(Movimiento_Retenciones___Base_de_calculo_; GMAWithholdingLedgerEntry."GMACalculation Base") { }
                                column(alicuota_Control1000000066; alicuota) { }
                                column(Movimiento_Retenciones___Importe_retencion_; GMAWithholdingLedgerEntry."GMAWithholding Amount") { }
                                column(Movimiento_Retenciones___Base_de_calculo__Control1000000068; GMAWithholdingLedgerEntry."GMACalculation Base") { }
                                column(InfoEmpresa_Picture2; DimensionValue.BssiPicture) { }
                                column(ReferenciaCaption; ReferenciaCaptionLbl) { }
                                column(Cod__Retenci_nCaption; Cod__Retenci_nCaptionLbl) { }
                                column(Base_ImponibleCaption; Base_ImponibleCaptionLbl) { }
                                column(EmptyStringCaption_Control1000000047; EmptyStringCaption_Control1000000047Lbl) { }
                                column(Nro__FacturaCaption; Nro__FacturaCaptionLbl) { }
                                column(Tipo_CompCaption; Tipo_CompCaptionLbl) { }
                                column(Hist_Lin_Comp_OPago__Nro_O_Pago_Caption; FIELDCAPTION("GMAPayment Order No.")) { }
                                column(Declaraci_n_en_la_que_se_informar__la_retencion__Caption; Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl) { }
                                column(RETENCIONCaption_Control1000000055; RETENCIONCaption_Control1000000055Lbl) { }
                                column(ALICUOTACaption_Control1000000057; ALICUOTACaption_Control1000000057Lbl) { }
                                column(B__IMPONIBLECaption_Control1000000058; B__IMPONIBLECaption_Control1000000058Lbl) { }
                                column(TOTAL_IMPONIBLECaption; TOTAL_IMPONIBLECaptionLbl) { }
                                column(MONTO_RETENIDOCaption; MONTO_RETENIDOCaptionLbl) { }
                                column(EmptyStringCaption_Control1000000061; EmptyStringCaption_Control1000000061Lbl) { }
                                column(EmptyStringCaption_Control1000000062; EmptyStringCaption_Control1000000062Lbl) { }
                                column(EmptyStringCaption_Control1000000064; EmptyStringCaption_Control1000000064Lbl) { }
                                column(EmptyStringCaption_Control1000000069; EmptyStringCaption_Control1000000069Lbl) { }
                                column(EmptyStringCaption_Control1000000070; EmptyStringCaption_Control1000000070Lbl) { }
                                column(EmptyStringCaption_Control1000000071; EmptyStringCaption_Control1000000071Lbl) { }
                                column(DataItem1000000072; Declaro_que_los_datos_consignados_en_este_certific) { }
                                column("alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_Caption"; alguno_que_deba_contener__siendo_fiel_expresión_de_la_verdad_CaptionLbl) { }
                                column("FIRMA_DEL_AGENTE_DE_RETENCIÓNCaption"; FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl) { }
                                column(EmptyStringCaption_Control1000000006; EmptyStringCaption_Control1000000006Lbl) { }
                                column("ACLARACIÓN_CARGOCaption"; ACLARACIÓN_CARGOCaptionLbl) { }
                                column(Posted_Payment_Order_Vouchers_Entry_No_2; "GMAEntry No.") { }

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
                                                Comportamiento.SETRANGE(Comportamiento."GMATax System", GMAWithholdingLedgerEntry."GMATax System");
                                                Comportamiento.SETRANGE(Comportamiento."GMAWithholding No.", GMAWithholdingLedgerEntry."GMAWithholding No.");//NAVAR1.06
                                                if Comportamiento.FINDFIRST then begin
                                                    DetRetencion.RESET;
                                                    DetRetencion.SETCURRENTKEY("GMAWithholding No.", "GMATax Code", "GMATax System");
                                                    DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", Comportamiento."GMAWithholding No.");
                                                    if DetRetencion.FINDFIRST then begin
                                                        ///Control de Valor en Detalle de Retención
                                                        //if DetRetencion.GMAValue = '' then
                                                        //    ControlValor := false
                                                        //else
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
                                        if (HOPago."GMANew Payment") then begin
                                            alicuota := GMAWithholdingLedgerEntry."GMAWithholding%";
                                            Acumulado := "Posted Payment Order Vouchers"."GMATo be Cancelled (LCY)";
                                        end;

                                    //AcumTotal := AcumTotal + Acumulado;

                                    GMAWithholdingLedgerEntry."GMACalculation Base" := ROUND(GMAWithholdingLedgerEntry."GMACalculation Base");
                                    if Acumulado = 0 then
                                        CurrReport.SKIP;
                                end;
                            }

                            trigger OnAfterGetRecord();
                            var
                                BssiMEMSystemSetup: record BssiMEMSystemSetup;
                            begin
                                IF (ValueType <> 1) THEN
                                    CurrReport.sKIP;
                                IF (printWitholding(GMAWithholdingLedgerEntry)) then
                                    CurrReport.sKIP;


                                if (COPYSTR(GMAWithholdingLedgerEntry."GMATax Code", 1, 2) = 'IB') then begin
                                    Text1 := 'JURISDICCION:';
                                    if (prov.GET(GMAWithholdingLedgerEntry."GMAProvince Code")) then
                                        Text2 := prov.GMADescription;


                                end;


                                gblProvincia := '';
                                DetRetencion.RESET;
                                DetRetencion.SETCURRENTKEY("GMAWithholding No.", "GMATax Code", "GMATax System");
                                DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", GMAWithholdingLedgerEntry."GMAWithholding No.");
                                if DetRetencion.FINDFIRST then
                                    Descripcion := DetRetencion.GMADescription;

                                Escala.RESET;
                                Escala.SETCURRENTKEY("GMAScale Code", "GMAWithholding Condition", "GMATax Code", GMAFrom);
                                Escala.SETRANGE(Escala."GMAScale Code", GMAWithholdingLedgerEntry."GMAScale Code");
                                Escala.SETRANGE(Escala."GMAWithholding Condition", GMAWithholdingLedgerEntry."GMACondition Code");
                                Escala.SETRANGE(Escala."GMATax Code", GMAWithholdingLedgerEntry."GMATax Code");
                                if Escala.FINDFIRST then
                                    repeat
                                        if (Escala.GMAFrom <= GMAWithholdingLedgerEntry."GMACalculation Base") then begin
                                            alicuota := Escala."GMAExcedent %";
                                            minimo := Escala.GMAFrom;
                                        end;
                                    until Escala.NEXT = 0;

                                //NAVAR1.06001-
                                Provincia.RESET;
                                Provincia.SETCURRENTKEY("GMAProvince Code");
                                Provincia.SETRANGE("GMAProvince Code", "GMAProvince Code");
                                if Provincia.FINDFIRST then
                                    gblProvincia := Provincia.GMADescription
                                else
                                    gblProvincia := '';
                                //11807+
                                "Withholding Kind Line".RESET;
                                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMAWithholding Code", GMAWithholdingLedgerEntry."GMAWithholding Code");
                                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMATax Code", GMAWithholdingLedgerEntry."GMATax Code");
                                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMAIs vendor withholding", true);
                                if ("Withholding Kind Line".FINDFIRST) then begin
                                    if (GMAWithholdingLedgerEntry."Vendor withholding" <> '') then begin
                                        Proveedor.RESET;
                                        Proveedor.SETCURRENTKEY("No.");
                                        Proveedor.SETRANGE("No.", GMAWithholdingLedgerEntry."Vendor withholding");
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
                                    if maestroPais.FindFirst() then direccionProveedor := direccionProveedor + ', ' + maestroPais.Name;
                                end;

                                DimensionValue.Reset();
                                DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                                DimensionValue.SetFilter(Code, GMAWithholdingLedgerEntry."GMAShortcut Dimension 1");
                                IF (DimensionValue.FindFirst()) THEN;
                                DimensionValue.CALCFIELDS(DimensionValue.BssiPicture);
                                DimensionValue.CALCFIELDS(BssiPicture);

                                RecProvincia.RESET;
                                RecProvincia.SETCURRENTKEY(RecProvincia."GMAProvince Code");
                                RecProvincia.SETRANGE("GMAProvince Code", DimensionValue.BssiProvinceCode);
                                if RecProvincia.FINDFIRST then
                                    gProvincia := RecProvincia.GMADescription;

                                if (DimensionValue.BssiBillingAddr1 <> '') then direccionEmpresa := DimensionValue.BssiBillingAddr1;
                                if (DimensionValue.BssiBillingCity <> '') then direccionEmpresa := direccionEmpresa + ',  ' + DimensionValue.BssiBillingCity;
                                if (DimensionValue."BssiBillingZipCode" <> '') then direccionEmpresa := direccionEmpresa + ', C.P. ' + DimensionValue.BssiBillingZipCode;
                                if (DimensionValue.BssiBillingCountry <> '') then begin
                                    maestroPais.Reset();
                                    maestroPais.SetFilter(Code, DimensionValue.BssiBillingCountry);
                                    if maestroPais.FindFirst() then direccionEmpresa := direccionEmpresa + ', ' + maestroPais.Name;
                                end;

                                //NAVAR1.06001+
                                if ("Tipo fiscal".GET(Proveedor."GMAFiscal Type")) then;
                            end;


                            trigger OnPreDataItem()
                            var
                                MovRet: record "GMAWithholding Ledger Entry";
                                Valores2: record GMAValues;

                            begin
                                ValueType := 0;
                                "GMATreasury Setup".GET();
                                "GMATreasury Setup".CALCFIELDS(GMASignPicture);
                                Valores2.Reset();
                                Valores2.GET("GMAPosted Payment Order Valu".GMAValue);
                                if Valores2."GMAReport ID" = 34006895 then
                                    ValueType := 1
                                else
                                    CurrReport.Skip();
                                GMAWithholdingLedgerEntry.SETRANGE(GMAWithholdingLedgerEntry.GMAValue, Valores2.GMACode);
                                if GMAWithholdingLedgerEntry.FINDFIRST then;
                            end;

                        }



                        //Reporte de Ganancias
                        dataitem("Movimiento Retenciones"; "GMAWithholding Ledger Entry")
                        {
                            DataItemLink = "GMAVoucher Number" = field("GMAPayment Order No."), "GMAWithholding No." = field("GMAWithholding No.");
                            DataItemLinkReference = "GMAPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMANo.");
                            //RequestFilterFields = "GMANo.";
                            RequestFilterFields = "GMAWithh. Certificate No.";
                            column(Descripcion894; Descripcion894) { }
                            column(ValueType2; ValueType) { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_894; "Movimiento Retenciones"."GMACalculation Base") { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_894; "Movimiento Retenciones"."GMAWithholding Amount") { }
                            column(alicuota894; alicuota894) { }
                            column(minimo894; minimo894) { }
                            column(Movimiento_Retenciones_No_894; "GMANo.") { }
                            column(Movimiento_Retenciones_Voucher_Number894; "GMAVoucher Number") { }

                            column(GMAPictureSign894; "GMATreasury Setup 894".GMASignPicture) { }
                            dataitem(Copia; "Integer")
                            {
                                DataItemTableView = SORTING(Number);
                                column(DetRetencion_Titulo894; DetRetencion894.GMATitle) { }
                                column(InfoEmpresa_Name894; InfoEmpresa894.BssiLegalNameFull) { }
                                column(InfoEmpresa_Picture_hdr894; InfoEmpresa894.BssiPicture) { }
                                column(InfoEmpresa_LocARAddress894; InfoEmpresa894.BssiBillingAddr1 + ', ' + InfoEmpresa894.BssiBillingZipCode + ', ' + InfoEmpresa894.BssiBillingCity + ', ' + gProvincia894 + ', ' + InfoEmpresa894.BssiBillingCountry) { }
                                column(InfoEmpresa__Phone_No__894; InfoEmpresa894.BssiBillingPhoneNumber) { }
                                column(InfoEmpresa__E_Mail_894; InfoEmpresa894.BssiEmail) { }
                                column(InfoEmpresa__Home_Page_894; '') { }
                                column(InfoEmpresa_Address_______InfoEmpresa_City____C_P____InfoEmpresa__Post_Code_894; direccionEmpresa894) { }
                                column(InfoEmpresa__Address_2_894; InfoEmpresa894.BssiBillingAddress2) { }
                                column(InfoEmpresa__VAT_Registration_No__894; InfoEmpresa894.BssiRegistrationNo) { }
                                column(Proveedor__No_ingresos_brutos_894; Proveedor894."GMAGross Income Tax No") { }
                                column(Proveedor__VAT_Registration_No__894; Proveedor894."VAT Registration No.") { }
                                column(Proveedor_Address_______Proveedor_City____C_P____Proveedor__Post_Code________Proveedor__Address_2_894; direccionProveedor894) { }
                                column(Proveedor_Name894; Proveedor894.Name) { }
                                column(Movimiento_Retenciones___Nro_Certificado_Retencion_894; "Movimiento Retenciones"."GMAWithh. Certificate No.") { }
                                column(Movimiento_Retenciones___Fecha_comprobante_894; "Movimiento Retenciones"."GMAVoucher Date") { }
                                column(Tipo_fiscal__Description894; "Tipo fiscal894".GMADescription) { }

                                column(Movimiento_Retenciones___Numero_comprobante_894; "Movimiento Retenciones"."GMAVoucher Number") { }
                                column(tipoCond894; tipoCond894) { }
                                column(DetRetencion__Agente_de_Retencion_894; DetRetencion894."GMAWithholding Agent") { }
                                column("CERTIFICADO_DE_RETENCIÓN_N_Caption894"; CERTIFICADO_DE_RETENCIÓN_N_CaptionLbl894) { }
                                column(DATOS_DEL_AGENTE_DE_RETENCIONCaption894; DATOS_DEL_AGENTE_DE_RETENCIONCaptionLbl894) { }
                                column(Domicilio_Caption894; Domicilio_CaptionLbl894) { }
                                column(Nro__de_CUIT_Caption894; Nro__de_CUIT_CaptionLbl894) { }
                                column(Ag__de_Ret__N__Caption894; Ag__de_Ret__N__CaptionLbl894) { }
                                column(Nro__de_IIBBCaption894; Nro__de_IIBBCaptionLbl894) { }
                                column(Nro__de_CUIT_Caption_Control1000000052894; Nro__de_CUIT_Caption_Control1000000052Lbl894) { }
                                column("Dirección_Caption894"; Dirección_CaptionLbl894) { }
                                column(DATOS_DEL_SUJETO_RETENIDOCaption894; DATOS_DEL_SUJETO_RETENIDOCaptionLbl894) { }
                                column(FECHA_Caption894; FECHA_CaptionLbl894) { }
                                column(EmptyStringCaption894; EmptyStringCaptionLbl894) { }
                                column(EmptyStringCaption_Control1000000088894; EmptyStringCaption_Control1000000088Lbl894) { }
                                column(EmptyStringCaption_Control1000000089894; EmptyStringCaption_Control1000000089Lbl894) { }
                                column("Razón_Social_Caption894"; Razón_Social_CaptionLbl894) { }
                                column(Tipo_de_ContribuyenteCaption894; Tipo_de_ContribuyenteCaptionLbl894) { }
                                column("Razón_Social_Caption_Control1000000092894"; Razón_Social_Caption_Control1000000092Lbl894) { }
                                column(CurrReport_PAGENOCaption894; CurrReport_PAGENOCaptionLbl894) { }
                                column(ORDEN_DE_PAGO_N__Caption894; ORDEN_DE_PAGO_N__CaptionLbl894) { }
                                column(Sit__ante_IVA_Caption894; Sit__ante_IVA_CaptionLbl894) { }
                                column(Copia_Number894; Number) { }
                                dataitem(Pagina; "Integer")
                                {
                                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                                    column(Movimiento_Retenciones___Importe_retencion_894; "Movimiento Retenciones"."GMAWithholding Amount") { }
                                    column(decRetenAnt894; decRetenAnt894) { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100894; decRetenAnt894 + "Movimiento Retenciones"."GMAWithholding Amount") { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100_2894; "Movimiento Retenciones"."GMAWithholding Amount") { }
                                    column(FORMAT_alicuota______894; FORMAT(ROUND(alicuota894)) + ' %') { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp894; "Movimiento Retenciones".GMABase + decPagosAnt894 - decMinimoNoImp894) { }
                                    column(decMinimoNoImp894; decMinimoNoImp894) { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt894; "Movimiento Retenciones".GMABase + decPagosAnt894) { }
                                    column(decPagosAnt894; decPagosAnt894) { }
                                    column(MontoFijo894; MontoFijo894) { }
                                    column(Movimiento_Retenciones__Base894; "Movimiento Retenciones".GMABase) { }
                                    column("Régimen__________DetRetencion_Regimen__________DetRetencion_Descripcion894"; 'Régimen' + '  ' + DetRetencion894."GMATax System" + ' - ' + DetRetencion894.GMADescription) { }
                                    column(InfoEmpresa_Picture2894; InfoEmpresa894.BssiPicture) { }
                                    column(EmptyStringCaption_Control1000000081894; EmptyStringCaption_Control1000000081Lbl894) { }
                                    column(EmptyStringCaption_Control1000000080894; EmptyStringCaption_Control1000000080Lbl894) { }
                                    column(Retenciones_anterioresCaption894; Retenciones_anterioresCaptionLbl894) { }
                                    column(EmptyStringCaption_Control1000000079894; EmptyStringCaption_Control1000000079Lbl894) { }
                                    column(EmptyStringCaption_Control1000000078894; EmptyStringCaption_Control1000000078Lbl894) { }
                                    column("Monto_Sujeto_a_RetenciónCaption894"; Monto_Sujeto_a_RetenciónCaptionLbl894) { }
                                    column(EmptyStringCaption_Control1000000077894; EmptyStringCaption_Control1000000077Lbl894) { }
                                    column("Mínimo_No_imponibleCaption894"; Mínimo_No_imponibleCaptionLbl894) { }
                                    column(EmptyStringCaption_Control1000000076894; EmptyStringCaption_Control1000000076Lbl894) { }
                                    column("MONTO_DE_LA_RETENCIÓNCaption894"; MONTO_DE_LA_RETENCIÓNCaptionLbl894) { }
                                    column("AlícuotaCaption894"; AlícuotaCaptionLbl894) { }
                                    column(Pagos_anterioresCaption894; Pagos_anterioresCaptionLbl894) { }
                                    column(EmptyStringCaption_Control1000000075894; EmptyStringCaption_Control1000000075Lbl894) { }
                                    column(Pago_de_la_fechaCaption894; Pago_de_la_fechaCaptionLbl894) { }
                                    column(EmptyStringCaption_Control1000000074894; EmptyStringCaption_Control1000000074Lbl894) { }
                                    column(TotalCaption894; TotalCaptionLbl894) { }
                                    column("DATOS_DE_LA_RETENCIÓN_PRACTICADACaption894"; DATOS_DE_LA_RETENCIÓN_PRACTICADACaptionLbl894) { }
                                    column(EmptyStringCaption_Control1102201001894; EmptyStringCaption_Control1102201001Lbl894) { }
                                    column(EmptyStringCaption_Control1102201005894; EmptyStringCaption_Control1102201005Lbl894) { }
                                    column(EmptyStringCaption_Control1102201006894; EmptyStringCaption_Control1102201006Lbl894) { }
                                    column(EmptyStringCaption_Control1102201007894; EmptyStringCaption_Control1102201007Lbl894) { }
                                    column(Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaption894; Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl894) { }
                                    column(que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_Caption894; que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl894) { }
                                    column("FIRMA_DEL_AGENTE_DE_RETENCIÓNCaption894"; FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl894) { }
                                    column(EmptyStringCaption_Control1000000006894; EmptyStringCaption_Control1000000006Lbl894) { }
                                    column(EmptyStringCaption_Control1000000007894; EmptyStringCaption_Control1000000007Lbl894) { }
                                    column(EmptyStringCaption_Control1000000008894; EmptyStringCaption_Control1000000008Lbl894) { }
                                    column(Pago_en_concepto_de___Caption894; Pago_en_concepto_de___CaptionLbl894) { }
                                    column(EmptyStringCaption_Control1000000018894; EmptyStringCaption_Control1000000018Lbl894) { }
                                    column("ACLARACIÓN_CARGOCaption894"; ACLARACIÓN_CARGOCaptionLbl894) { }
                                    column(Pagina_Number894; Number) { }

                                    dataitem("Posted Payment Order Vouchers894"; "GMAPosted Payment Ord Vouch")
                                    {
                                        DataItemLink = "GMAPayment Order No." = FIELD("GMAVoucher Number");
                                        DataItemLinkReference = "Movimiento Retenciones";
                                        DataItemTableView = SORTING("GMAPayment Order No.", "GMAVoucher No.") ORDER(Ascending);
                                        column(tipocomp894; tipocomp894) { }
                                        column(TOTAL894; TOTAL894) { }
                                        column(movfac__External_Document_No__894; movfac894."External Document No.") { }
                                        column(AcumTotal894; AcumTotal894) { }
                                        column(Tipo_CompCaption894; Tipo_CompCaptionLbl894) { }
                                        column(Base_ImponibleCaption894; Base_ImponibleCaptionLbl894) { }
                                        column(Movimiento_Retenciones__Valor894; "Movimiento Retenciones".GMAValue) { }
                                        column(EmptyStringCaption_Control1000000009894; EmptyStringCaption_Control1000000009Lbl894) { }
                                        column(Nro__ComprobanteCaption894; Nro__ComprobanteCaptionLbl894) { }
                                        column(EmptyStringCaption_Control1000000022894; EmptyStringCaption_Control1000000022Lbl894) { }
                                        column(EmptyStringCaption_Control1000000023894; EmptyStringCaption_Control1000000023Lbl894) { }
                                        column(EmptyStringCaption_Control1000000049894; EmptyStringCaption_Control1000000049Lbl894) { }
                                        column(TOTAL_IMPONIBLECaption894; TOTAL_IMPONIBLECaptionLbl894) { }
                                        column(Posted_Payment_Order_Vouchers_Payment_Order_No_894; "GMAPayment Order No.") { }
                                        column(Posted_Payment_Order_Vouchers_Voucher_No_894; "GMAVoucher No.") { }
                                        column(Posted_Payment_Order_Vouchers_Entry_No_894; "GMAEntry No.") { }

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

                                            ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion

                                            Acumulado894 := 0;
                                            if ("Posted Payment Order Vouchers894"."GMADocument Type" = "Posted Payment Order Vouchers894"."GMADocument Type"::Invoice) or
                                              ("Posted Payment Order Vouchers894"."GMADocument Type" = "Posted Payment Order Vouchers894"."GMADocument Type"::"GMANota Debito") then begin
                                                Facturas.RESET;
                                                Facturas.SETRANGE(Facturas."No.", "Posted Payment Order Vouchers894"."GMAVoucher No.");
                                                if Facturas.FindSet() then begin
                                                    Facturas.CALCFIELDS("Amount Including VAT");
                                                    //Calculo porcentaje del pago sobre el total de la factura
                                                    if Facturas."Currency Factor" <> 0 then
                                                        PorcMonto := (("GMAAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                                                    else
                                                        PorcMonto := (("GMAAmount (LCY)" * 100) / Facturas."Amount Including VAT");
                                                    if ("Posted Payment Order Vouchers894".GMACrMemoAppliedExists) then
                                                        PorcMonto := 100;

                                                    LineasFactura.RESET;
                                                    LineasFactura.SETRANGE("Document No.", "Posted Payment Order Vouchers894"."GMAVoucher No.");
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
                                                                        CondImpuesto.SETRANGE(CondImpuesto."GMAVendor Code", "Posted Payment Order Vouchers894".GMAVendor);
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
                                                                                            Acumulado894 := ((PorcMonto * (LineasFactura."VAT Base Amount" / Facturas."Currency Factor")) / 100) +
                                                                                                                     Acumulado894
                                                                                        else
                                                                                            Acumulado894 := ((PorcMonto * LineasFactura."VAT Base Amount") / 100) +
                                                                                                                Acumulado894;

                                                                                    DetRetencion."GMAWithholding Base Type"::"Importe Impuestos":
                                                                                        if Facturas."Currency Factor" <> 0 then
                                                                                            Acumulado894 := ((PorcMonto * ((LineasFactura."Amount Including VAT" / Facturas."Currency Factor")
                                                                                                                - (LineasFactura."VAT Base Amount" / Facturas."Currency Factor"))) / 100) +
                                                                                                                   Acumulado894
                                                                                        else
                                                                                            Acumulado894 := ((PorcMonto * (LineasFactura."Amount Including VAT"
                                                                                                                 - LineasFactura."VAT Base Amount")) / 100) + Acumulado894;

                                                                                    DetRetencion."GMAWithholding Base Type"::"Importe Total":
                                                                                        if Facturas."Currency Factor" <> 0 then
                                                                                            Acumulado894 := ((PorcMonto * (LineasFactura."Amount Including VAT" / Facturas."Currency Factor")) / 100) +
                                                                                                                     Acumulado894
                                                                                        else
                                                                                            Acumulado894 := ((PorcMonto * LineasFactura."Amount Including VAT") / 100) +
                                                                                                                 Acumulado894;
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
                                            if ("Posted Payment Order Vouchers894"."GMADocument Type" = "Posted Payment Order Vouchers894"."GMADocument Type"::"Credit Memo") then begin
                                                Facturas2.RESET;
                                                Facturas2.SETRANGE("No.", "Posted Payment Order Vouchers894"."GMAVoucher No.");
                                                if Facturas2.FindSet() then begin
                                                    Facturas2.CALCFIELDS("Amount Including VAT");
                                                    //Calculo porcentaje del pago sobre el total de la factura
                                                    if Facturas2."Currency Factor" <> 0 then
                                                        PorcMonto := (("GMAAmount (LCY)" * 100) / (Facturas2."Amount Including VAT" / Facturas2."Currency Factor"))
                                                    else
                                                        PorcMonto := (("GMAAmount (LCY)" * 100) / Facturas2."Amount Including VAT");

                                                    LineasFactura2.RESET;
                                                    LineasFactura2.SETRANGE("Document No.", "Posted Payment Order Vouchers894"."GMAVoucher No.");
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
                                                                        CondImpuesto.SETRANGE(CondImpuesto."GMAVendor Code", "Posted Payment Order Vouchers894".GMAVendor);
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
                                                                                            Acumulado894 -= ((PorcMonto * (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor")) / 100)

                                                                                        else
                                                                                            Acumulado894 -= ((PorcMonto * LineasFactura2."VAT Base Amount") / 100);

                                                                                    DetRetencion."GMAWithholding Base Type"::"Importe Impuestos":
                                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                                            Acumulado894 -= ((PorcMonto * ((LineasFactura2."Amount Including VAT" / Facturas2."Currency Factor")
                                                                                                                - (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor"))) / 100)
                                                                                        else
                                                                                            Acumulado894 -= ((PorcMonto * (LineasFactura2."Amount Including VAT"
                                                                                                                 - LineasFactura2."VAT Base Amount")) / 100);

                                                                                    DetRetencion."GMAWithholding Base Type"::"Importe Total":
                                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                                            Acumulado894 -= ((PorcMonto * (LineasFactura2."Amount Including VAT" / Facturas2."Currency Factor")) / 100)
                                                                                        else
                                                                                            Acumulado894 -= ((PorcMonto * LineasFactura2."Amount Including VAT") / 100);
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

                                            movfac894.RESET;
                                            movfac894.SETRANGE(movfac894."Document No.", "Posted Payment Order Vouchers894"."GMAVoucher No.");
                                            ok894 := movfac894.FindSet();

                                            //NAVAR1.06002-
                                            CLEAR(ImporteNC894);
                                            tipocomp894 := '';
                                            if (movfac894."Document Type" = movfac894."Document Type"::Invoice) then begin
                                                tipocomp894 := 'FC';
                                                ImporteNC894 := FindApplicCreditMemo("Posted Payment Order Vouchers894"."GMAVoucher No.", "Posted Payment Order Vouchers894");
                                            end;

                                            if (movfac894."Document Type" = movfac894."Document Type"::"Credit Memo") then
                                                tipocomp894 := 'NC';

                                            if (movfac894."Document Type" = movfac894."GMADocument Type Loc."::"GMANota Debito") then
                                                tipocomp894 := 'ND';

                                            if (movfac894."Document Type" = movfac894."Document Type"::"Credit Memo") then
                                                Acumulado894 := -Acumulado894;

                                            Acumulado894 := ROUND(Acumulado894, 0.01);

                                            CLEAR(TOTAL894);

                                            if (HOPago894."GMANew Payment") then
                                                Acumulado894 := "Posted Payment Order Vouchers894"."GMATo be Cancelled (LCY)";

                                            AcumTotal894 := AcumTotal894 + Acumulado894;

                                            if ("Posted Payment Order Vouchers894".GMACrMemoAppliedExists) then
                                                TOTAL894 := Acumulado894
                                            else
                                                TOTAL894 := Acumulado894 + ImporteNC894;

                                            //NAVAR1.06002+

                                            if Acumulado894 = 0 then
                                                CurrReport.SKIP;

                                        end;
                                    }
                                }

                                trigger OnPreDataItem();
                                begin
                                    case optCopias894 of
                                        optCopias894::"Sólo original":
                                            SETRANGE(Number, 1, 1);
                                        optCopias894::Duplicado:
                                            SETRANGE(Number, 1, 2);
                                        optCopias894::Triplicado:
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
                                IF (ValueType <> 2) THEN
                                    CurrReport.sKIP;
                                IF (printWitholding("Movimiento Retenciones")) then
                                    CurrReport.sKIP;

                                DetRetencion894.RESET;
                                DetRetencion894.SETRANGE(DetRetencion894."GMAWithholding No.", "Movimiento Retenciones"."GMAWithholding No.");
                                if DetRetencion894.FindSet() then
                                    Descripcion894 := DetRetencion894.GMADescription;

                                //GMDataScale MC +
                                //Se deben sacar estos datos del historico de retenciones, no de la escala, esta puede cambiar.
                                //Dejo para retenciones ya generadas

                                if ("Movimiento Retenciones".GMAFrom = 0) and ("Movimiento Retenciones"."GMAFixed Amount" = 0) and ("Movimiento Retenciones"."GMABase Amount" = 0) then begin
                                    Escala894.RESET;
                                    Escala894.SETRANGE(Escala894."GMAScale Code", "Movimiento Retenciones"."GMAScale Code");
                                    Escala894.SETRANGE(Escala894."GMAWithholding Condition", "Movimiento Retenciones"."GMACondition Code");
                                    Escala894.SETRANGE(Escala894."GMATax Code", "Movimiento Retenciones"."GMATax Code");
                                    if Escala894.FindSet() then
                                        repeat
                                            if (Escala894.GMAFrom <= "Movimiento Retenciones"."GMACalculation Base") then begin
                                                alicuota894 := Escala894."GMAExcedent %";
                                                minimo894 := Escala894.GMAFrom;
                                                MontoFijo894 := Escala894."GMAFixed Amount";
                                                decMinimoNoImp894 := Escala894."GMABase Amount";
                                            end;
                                        until Escala894.NEXT = 0;
                                end
                                else begin
                                    alicuota894 := "Movimiento Retenciones"."GMAWithholding%";
                                    minimo894 := "Movimiento Retenciones".GMAFrom;
                                    MontoFijo894 := "Movimiento Retenciones"."GMAFixed Amount";
                                    decMinimoNoImp894 := "Movimiento Retenciones"."GMABase Amount";
                                end;
                                //GMDataScale MC -


                                //11807+
                                "Withholding Kind Line894".RESET;
                                "Withholding Kind Line894".SETRANGE("Withholding Kind Line894"."GMAWithholding Code", "GMAWithholding Code");
                                "Withholding Kind Line894".SETRANGE("Withholding Kind Line894"."GMATax Code", "GMATax Code");
                                "Withholding Kind Line894".SETRANGE("Withholding Kind Line894"."GMAIs vendor withholding", true);
                                if ("Withholding Kind Line894".FINDFIRST) then begin
                                    if ("Vendor withholding" <> '') then begin
                                        Proveedor894.RESET;
                                        Proveedor894.SETCURRENTKEY("No.");
                                        Proveedor894.SETRANGE("No.", "Vendor withholding");
                                        if Proveedor894.FINDFIRST then;
                                    end
                                    else begin
                                        Proveedor894.RESET;
                                        Proveedor894.SETCURRENTKEY("No.");
                                        Proveedor894.SETRANGE("No.", "GMAVendor Code");
                                        if Proveedor894.FINDFIRST then;
                                    end;
                                end
                                else begin
                                    Proveedor894.RESET;
                                    Proveedor894.SETCURRENTKEY("No.");
                                    Proveedor894.SETRANGE("No.", "GMAVendor Code");
                                    if Proveedor894.FINDFIRST then;
                                end;
                                //11807-
                                if (Proveedor894.Address <> '') then direccionProveedor894 := Proveedor894.Address;
                                if (Proveedor894.City <> '') then direccionProveedor894 := direccionProveedor894 + ',  ' + Proveedor894.City;
                                if (Proveedor894."Post Code" <> '') then direccionProveedor894 := direccionProveedor894 + ', C.P. ' + Proveedor894."Post Code";
                                if (Proveedor894."Country/Region Code" <> '') then begin
                                    maestroPais894.Reset();
                                    maestroPais894.SetFilter(Code, Proveedor894."Country/Region Code");
                                    if maestroPais894.FindFirst() then direccionProveedor894 := direccionProveedor894 + ', ' + maestroPais894.GetNameInCurrentLanguage();
                                end;

                                if "Tipo fiscal894".Get(Proveedor894."GMAFiscal Type") then;

                                //Proveedor.GET("Movimiento Retenciones"."GMAVendor Code"); //11807

                                HOPago894.GET("Movimiento Retenciones"."GMAVoucher Number");
                                HOPago894.CALCFIELDS("GMAPaid Amount (LCY)");
                                HLinCompPago.SETRANGE("GMAPayment Order No.", HOPago894."GMAPayment O. No.");
                                HLinCompPago.FindFirst();
                                for i := 1 to 60 do
                                    txtNroComprobantes894[i] := ' ';
                                i := 1;
                                repeat
                                    Contador894 += 1;
                                    if MovProveedor.GET(HLinCompPago."GMAEntry No.") then begin
                                        if (MovProveedor."Document Type" = MovProveedor."Document Type"::Invoice) then
                                            txtNroComprobantes894[i] += 'FC  ' + MovProveedor."External Document No.";
                                        if (MovProveedor."Document Type" = MovProveedor."Document Type"::"Credit Memo") then
                                            txtNroComprobantes894[i] += 'NC  ' + MovProveedor."External Document No.";
                                        if (MovProveedor."Document Type" <> MovProveedor."Document Type"::Invoice) and
                                         (MovProveedor."Document Type" <> MovProveedor."Document Type"::Invoice) then
                                            txtNroComprobantes894[i] += MovProveedor."External Document No.";


                                        i += 1;
                                    end;
                                until (HLinCompPago.NEXT = 0) or (Contador894 = 150);

                                Dia := FORMAT(DATE2DMY("Movimiento Retenciones"."GMAWithholding Date", 1));
                                Anio := FORMAT(DATE2DMY("Movimiento Retenciones"."GMAWithholding Date", 3));
                                Mes := FORMAT("Movimiento Retenciones"."GMAWithholding Date", 0, '<Month Text>');
                                txtLugarYFecha894 := 'Buenos Aires, ' + Dia + ' de ' + Mes + ' de ' + Anio + '.';
                                txtDeclaracion894 := 'La presente retención se informará en la DDJJ correspondiente al mes de ' + Mes + ' del año ' + Anio + '.';

                                if (HOPago894."GMANew Payment") then begin
                                    "Hist Lin Valor OPago894".SETRANGE("GMAPayment Order No.", HOPago894."GMAPayment O. No."); // "Posted Payment Order Vouchers"."Payment Order No."
                                    "Hist Lin Valor OPago894".SETRANGE("Hist Lin Valor OPago894".GMAValue, "Movimiento Retenciones".GMAValue);
                                    "Hist Lin Valor OPago894".SETRANGE("Hist Lin Valor OPago894"."GMAWithholding No.", "Movimiento Retenciones"."GMAWithholding No.");
                                    if ("Hist Lin Valor OPago894".FINDFIRST()) then begin
                                        //IF("Hist Lin Valor OPago"."Pagos Anteriores" <> 0)THEN
                                        decPagosAnt894 := "Hist Lin Valor OPago894"."GMAPrevious Payments";
                                        // IF("Hist Lin Valor OPago"."Retenciones Anteriores" <> 0)THEN
                                        decRetenAnt894 := "Hist Lin Valor OPago894"."GMAPrevious Withholdings";
                                    end;
                                end;
                                if (alicuota894 = 0) then
                                    if ("Movimiento Retenciones"."GMAWithholding%" <> 0) then
                                        alicuota894 := "Movimiento Retenciones"."GMAWithholding%"
                                    else begin
                                        if ("Movimiento Retenciones"."GMACalculation Base" <> 0) and ("Movimiento Retenciones"."GMAWithholding Amount" <> 0) then
                                            alicuota894 := ("Movimiento Retenciones"."GMAWithholding Amount" /
                                            ("Movimiento Retenciones"."GMACalculation Base" + decPagosAnt894 - decMinimoNoImp894)) * 100;
                                    end;


                                InfoEmpresa894.Reset();
                                InfoEmpresa894.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                                InfoEmpresa894.SetFilter(Code, "Movimiento Retenciones"."GMAShortcut Dimension 1");
                                IF (InfoEmpresa894.FindFirst()) THEN;
                                InfoEmpresa894.CALCFIELDS(InfoEmpresa894.BssiPicture);
                                InfoEmpresa894.CALCFIELDS(BssiPicture);
                                if (InfoEmpresa894.BssiBillingAddr1 <> '') then direccionEmpresa894 := InfoEmpresa894.BssiBillingAddr1;
                                if (InfoEmpresa894.BssiBillingCity <> '') then direccionEmpresa894 := direccionEmpresa894 + ',  ' + InfoEmpresa894.BssiBillingCity;
                                if (InfoEmpresa894."BssiBillingZipCode" <> '') then direccionEmpresa894 := direccionEmpresa894 + ', C.P. ' + InfoEmpresa894.BssiBillingZipCode;
                                if (InfoEmpresa894.BssiBillingCountry <> '') then begin
                                    maestroPais894.Reset();
                                    maestroPais894.SetFilter(Code, InfoEmpresa894.BssiBillingCountry);
                                    if maestroPais894.FindFirst() then direccionEmpresa894 := direccionEmpresa894 + ', ' + maestroPais894.Name;
                                end;
                                RecProvincia894.RESET;
                                RecProvincia894.SETCURRENTKEY(RecProvincia894."GMAProvince Code");
                                RecProvincia894.SETRANGE("GMAProvince Code", InfoEmpresa894.BssiProvinceCode);
                                if RecProvincia894.FINDFIRST then
                                    gProvincia894 := RecProvincia894.GMADescription;

                            end;

                            trigger OnPreDataItem();
                            var
                                Valores3: record GMAValues;
                            begin

                                "GMATreasury Setup 894".GET();
                                "GMATreasury Setup 894".CALCFIELDS(GMASignPicture);
                                ValueType := 0;
                                Valores3.Reset();
                                Valores3.GET("GMAPosted Payment Order Valu".GMAValue);
                                if Valores3."GMAReport ID" = 34006894 then
                                    ValueType := 2
                                else
                                    CurrReport.Skip();
                                "Movimiento Retenciones".SETRANGE("Movimiento Retenciones".GMAValue, Valores3.GMACode);
                                if "Movimiento Retenciones".FINDFIRST then;

                            end;

                        }


                        //REporte de IVA
                        dataitem(WithholdingLedgerEntry896; "GMAWithholding Ledger Entry")
                        {
                            DataItemLink = "GMAVoucher Number" = field("GMAPayment Order No."), "GMAWithholding No." = field("GMAWithholding No.");
                            DataItemLinkReference = "GMAPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMANo.");
                            //RequestFilterFields = "GMANo.";
                            RequestFilterFields = "GMAWithh. Certificate No.";

                            column(InfoEmpresa_Name896; InfoEmpresa896.BssiLegalNameFull) { }
                            column(ValueType3; ValueType) { }
                            column(InfoEmpresa_Picture896; InfoEmpresa896.BssiPicture) { }
                            column(InfoEmpresa_LocARAddress896; InfoEmpresa896.BssiBillingAddr1 + ', ' + InfoEmpresa896.BssiBillingZipCode + ', ' + InfoEmpresa896.BssiBillingCity + ', ' + gProvincia896 + ', ' + InfoEmpresa896.BssiBillingCountry) { }
                            column(InfoEmpresa__Phone_No__896; InfoEmpresa896.BssiBillingPhoneNumber) { }
                            column(InfoEmpresa__E_Mail_896; InfoEmpresa896.BssiEmail) { }
                            column(InfoEmpresa__Home_Page_896; InfoEmpresa896.BssiHomePage) { }
                            column(InfoEmpresa_Address896; direccionEmpresa896) { }
                            column(InfoEmpresa_City_______InfoEmpresa_Provincia_______InfoEmpresa__Cod__Pais_Argentina_896; InfoEmpresa896.BssiBillingCity + ' - ' + InfoEmpresa896.BssiProvinceCode + ' - ' + InfoEmpresa896.BssiBillingCountry) { }
                            column(InfoEmpresa__VAT_Registration_No__896; InfoEmpresa896.BssiRegistrationNo) { }
                            column(InfoEmpresa__Withholding_Agent_No__896; InfoEmpresa896."BssiGrossIncomeNo") { }
                            column(InfoEmpresa_Provincia896; InfoEmpresa896.BssiProvinceCode) { }
                            column(Proveedor__No_ingresos_brutos_896; Proveedor896."GMAGross Income Tax No") { }
                            column(Proveedor__VAT_Registration_No__896; Proveedor896."VAT Registration No.") { }
                            column("Proveedor_Address_______Proveedor_City_______Proveedor__Cód__Provincia_896"; direccionProveedor896) { }
                            column(Proveedor_Name896; Proveedor896.Name) { }
                            column(Movimiento_Retenciones__Withholding_Certification_No__896; "GMAWithh. Certificate No.") { }
                            column(Movimiento_Retenciones__Fecha_comprobante_896; FORMAT("GMAVoucher Date", 10, '<Day,2>/<Month,2>/<Year4>')) { }
                            column("Provincia_Descripción896"; Provincia896.GMADescription) { }
                            column(Descripcion896; Descripcion896) { }
                            column(FORMAT_vbase_896; '$ ' + FORMAT(vbase896)) { }
                            column(FORMAT__Movimiento_Retenciones___Importe_retencion__896; '$ ' + FORMAT(WithholdingLedgerEntry896."GMAWithholding Amount")) { }
                            column(FORMAT_alicuota______896; FORMAT(alicuota896) + ' %') { }
                            column(minimo896; minimo896) { }
                            column(Movimiento_Retenciones_Regimen896; "GMATax System") { }
                            column(CERTIFICADO_DE_RETENCION_IVACaption896; CERTIFICADO_DE_RETENCION_IVACaptionLbl896) { }
                            column(AGENTE_DE_RETENCIONCaption896; AGENTE_DE_RETENCIONCaptionLbl896) { }
                            column("DirecciónCaption896"; DirecciónCaptionLbl896) { }
                            column(Nro__de_CUITCaption896; Nro__de_CUITCaptionLbl896) { }
                            column("Agente_RetenciónCaption896"; Agente_RetenciónCaptionLbl896) { }
                            column("JurisdicciónCaption896"; JurisdicciónCaptionLbl896) { }
                            column(Nro__de_IIBBCaption896; Nro__de_IIBBCaptionLbl896) { }
                            column(Nro__de_CUITCaption_Control1000000018896; Nro__de_CUITCaption_Control1000000018Lbl896) { }
                            column("DirecciónCaption_Control1000000021896"; DirecciónCaption_Control1000000021Lbl896) { }
                            column(SUJETO_DE_RETENCIONCaption896; SUJETO_DE_RETENCIONCaptionLbl896) { }
                            column(Certificado_N_Caption896; Certificado_N_CaptionLbl896) { }
                            column(FechaCaption896; FechaCaptionLbl896) { }
                            column("JurisdicciónCaption_Control1000000016896"; JurisdicciónCaption_Control1000000016Lbl896) { }
                            column(RETENCIONCaption896; RETENCIONCaptionLbl896) { }
                            column(B__IMPONIBLECaption896; B__IMPONIBLECaptionLbl896) { }
                            column(ALICUOTACaption896; ALICUOTACaptionLbl896) { }
                            column(MINIMOCaption896; MINIMOCaptionLbl896) { }
                            column(RETENIDOCaption896; RETENIDOCaptionLbl896) { }
                            column(EmptyStringCaption896; EmptyStringCaptionLbl896) { }
                            column(EmptyStringCaption_Control1000000041896; EmptyStringCaption_Control1000000041Lbl896) { }
                            column(EmptyStringCaption_Control1000000042896; EmptyStringCaption_Control1000000042Lbl896) { }
                            column(EmptyStringCaption_Control1000000046896; EmptyStringCaption_Control1000000046Lbl896) { }
                            column(REGIMEN_N_Caption896; REGIMEN_N_CaptionLbl896) { }
                            column("Firma_del_Agente_de_RetenciónCaption896"; Firma_del_Agente_de_RetenciónCaptionLbl896) { }
                            column("Aclaración_Caption896"; Aclaración_CaptionLbl896) { }
                            column(Cargo_Caption896; Cargo_CaptionLbl896) { }
                            column(Withholding_Ledger_Entry_No_896; "GMANo.") { }
                            column(Withholding_Ledger_Entry_Voucher_Number896; "GMAVoucher Number") { }
                            // AW - Begin
                            column(Withholding_Ledger_Entry_GMACalculation_Base896; WithholdingLedgerEntry896."GMACalculation Base") { }
                            // AW - End
                            column(GMAPictureSign896; "GMATreasury Setup896".GMASignPicture) { }
                            dataitem("GMAPosted Payment Order Vouchers"; "GMAPosted Payment Ord Vouch")
                            {
                                DataItemLink = "GMAPayment Order No." = FIELD("GMAVoucher Number");
                                DataItemTableView = SORTING("GMAPayment Order No.", "GMAVoucher No.") ORDER(Ascending);
                                column(Movimiento_Retenciones__Valor896; WithholdingLedgerEntry896.GMAValue) { }
                                column(FORMAT_Acumulado_896; '$ ' + FORMAT(Acumulado896)) { }
                                column(Hist_Lin_Comp_OPago__Nro_Comprobante_896; "GMAPosted Payment Order Vouchers"."GMAVoucher No.") { }
                                column(movfac__External_Document_No__896; movfac896."External Document No.") { }
                                column(ReferenciaCaption896; ReferenciaCaptionLbl896) { }
                                column("Cod__RetenciónCaption896"; Cod__RetenciónCaptionLbl896) { }
                                column(ImponibleCaption896; ImponibleCaptionLbl896) { }
                                column(EmptyStringCaption_Control1000000047896; EmptyStringCaption_Control1000000047Lbl896) { }
                                column(Nro__FacturaCaption896; Nro__FacturaCaptionLbl896) { }
                                column("Declaración_en_la_que_se_informará_la_retencion__Caption896"; Declaración_en_la_que_se_informará_la_retencion__CaptionLbl896) { }
                                column(EmptyStringCaption_Control1000000049896; EmptyStringCaption_Control1000000049Lbl896) { }
                                column(Posted_Payment_Order_Vouchers_Payment_Order_No_896; "GMAPayment Order No.") { }
                                column(Posted_Payment_Order_Vouchers_Entry_No_896; "GMAEntry No.") { }

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
                                    Acumulado896 := 0;
                                    ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                                    movfac896.RESET;
                                    movfac896.SETRANGE(movfac896."Document No.", "GMAPosted Payment Order Vouchers"."GMAVoucher No.");
                                    if movfac896.FindSet() then begin
                                        movfac896.CALCFIELDS("Original Amt. (LCY)");
                                        Acumulado896 := -movfac896."Original Amt. (LCY)";

                                        DetRetencion.RESET;
                                        DetRetencion.SETRANGE(DetRetencion."GMAWithholding No.", WithholdingLedgerEntry896."GMAWithholding No.");
                                        if DetRetencion.FindSet() then;

                                    end;

                                    Acumulado896 := 0;
                                    LineasFactura.RESET;
                                    LineasFactura.SETCURRENTKEY("Document No.", "Line No.");
                                    LineasFactura.SETRANGE("Document No.", "GMAPosted Payment Order Vouchers"."GMAVoucher No.");
                                    if LineasFactura.FINDFIRST then begin
                                        repeat
                                            Acumulado896 := Acumulado896 + LineasFactura."VAT Base Amount";
                                        until LineasFactura.NEXT = 0;
                                        Acumulado896 := ROUND(Acumulado896, 0.01);
                                    end;
                                end;
                            }

                            trigger OnAfterGetRecord();
                            var
                                BssiMEMSystemSetup: record BssiMEMSystemSetup;
                            begin
                                IF (ValueType <> 3) THEN
                                    CurrReport.sKIP;
                                IF (printWitholding(WithholdingLedgerEntry896)) then
                                    CurrReport.sKIP;
                                DetRetencion896.RESET;
                                DetRetencion896.SETRANGE(DetRetencion896."GMAWithholding No.", WithholdingLedgerEntry896."GMAWithholding No.");
                                if DetRetencion896.FindSet() then
                                    Descripcion896 := DetRetencion896.GMADescription;

                                Escala896.RESET;
                                Escala896.SETRANGE(Escala896."GMAScale Code", WithholdingLedgerEntry896."GMAScale Code");
                                Escala896.SETRANGE(Escala896."GMAWithholding Condition", WithholdingLedgerEntry896."GMACondition Code");
                                Escala896.SETRANGE(Escala896."GMATax Code", WithholdingLedgerEntry896."GMATax Code");
                                if Escala896.FindSet() then
                                    repeat
                                        if (Escala896.GMAFrom <= WithholdingLedgerEntry896."GMACalculation Base") then begin
                                            alicuota896 := Escala896."GMAExcedent %";
                                            minimo896 := Escala896.GMAFrom;
                                        end;
                                    until Escala896.NEXT = 0;
                                //11807+
                                "Withholding Kind Line896".RESET;
                                "Withholding Kind Line896".SETRANGE("Withholding Kind Line896"."GMAWithholding Code", WithholdingLedgerEntry896."GMAWithholding Code");
                                "Withholding Kind Line896".SETRANGE("Withholding Kind Line896"."GMATax Code", WithholdingLedgerEntry896."GMATax Code");
                                "Withholding Kind Line896".SETRANGE("Withholding Kind Line896"."GMAIs vendor withholding", true);
                                if ("Withholding Kind Line896".FINDFIRST) then begin
                                    if (WithholdingLedgerEntry896."Vendor withholding" <> '') then begin
                                        Proveedor896.RESET;
                                        Proveedor896.SETCURRENTKEY("No.");
                                        Proveedor896.SETRANGE("No.", WithholdingLedgerEntry896."Vendor withholding");
                                        if Proveedor896.FINDFIRST then;
                                    end
                                    else begin
                                        Proveedor896.RESET;
                                        Proveedor896.SETCURRENTKEY("No.");
                                        Proveedor896.SETRANGE("No.", "GMAVendor Code");
                                        if Proveedor896.FINDFIRST then;
                                    end;
                                end
                                else begin
                                    Proveedor896.RESET;
                                    Proveedor896.SETCURRENTKEY("No.");
                                    Proveedor896.SETRANGE("No.", "GMAVendor Code");
                                    if Proveedor896.FINDFIRST then;
                                end;
                                //11807-
                                if (Proveedor896.Address <> '') then direccionProveedor896 := Proveedor896.Address;
                                if (Proveedor896.City <> '') then direccionProveedor896 := direccionProveedor896 + ',  ' + Proveedor896.City;
                                if (Proveedor896."Post Code" <> '') then direccionProveedor896 := direccionProveedor896 + ', C.P. ' + Proveedor896."Post Code";
                                if (Proveedor896."Country/Region Code" <> '') then begin
                                    maestroPais896.Reset();
                                    maestroPais896.Get(Proveedor896."Country/Region Code");
                                    if maestroPais896.FindFirst() then direccionProveedor896 := direccionProveedor896 + ', ' + maestroPais896.GetNameInCurrentLanguage();
                                end;
                                InfoEmpresa896.Reset();
                                InfoEmpresa896.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                                InfoEmpresa896.SetFilter(Code, WithholdingLedgerEntry896."GMAShortcut Dimension 1");
                                IF (InfoEmpresa896.FindFirst()) THEN;
                                InfoEmpresa896.CALCFIELDS(InfoEmpresa896.BssiPicture);
                                Provincia896.RESET;
                                Provincia896.SETCURRENTKEY(Provincia896."GMAProvince Code");
                                Provincia896.SETRANGE("GMAProvince Code", InfoEmpresa896.BssiProvinceCode);
                                if Provincia896.FINDFIRST then
                                    gProvincia896 := Provincia896.GMADescription;
                                if (InfoEmpresa896.BssiBillingAddr1 <> '') then direccionEmpresa896 := InfoEmpresa896.BssiBillingAddr1;
                                if (InfoEmpresa896.BssiBillingCity <> '') then direccionEmpresa896 := direccionEmpresa896 + ',  ' + InfoEmpresa896.BssiBillingCity;
                                if (InfoEmpresa896.BssiBillingZipCode <> '') then direccionEmpresa896 := direccionEmpresa896 + ', C.P. ' + InfoEmpresa896.BssiBillingZipCode;
                                if (InfoEmpresa896.BssiBillingCountry <> '') then begin
                                    maestroPais896.Reset();
                                    maestroPais896.Get(InfoEmpresa896.BssiBillingCountry);
                                    if maestroPais896.FindFirst() then direccionEmpresa896 := direccionEmpresa896 + ', ' + maestroPais896.Name;
                                end;
                            end;

                            trigger OnPreDataItem();
                            var
                                Valores2: record GMAValues;
                            begin
                                ok896 := InfoEmpresa896.FindSet();
                                "GMATreasury Setup896".GET();
                                "GMATreasury Setup896".CALCFIELDS(GMASignPicture);
                                ValueType := 0;
                                Valores2.Reset();
                                Valores2.GET("GMAPosted Payment Order Valu".GMAValue);
                                if Valores2."GMAReport ID" = 34006896 then
                                    ValueType := 3
                                else
                                    CurrReport.Skip();
                                WithholdingLedgerEntry896.SETRANGE(WithholdingLedgerEntry896.GMAValue, Valores2.GMACode);
                                if WithholdingLedgerEntry896.FINDFIRST then;

                            end;
                        }



                        //Reporte SUSS
                        dataitem(GMAWithholdingLedgerEntry897; "GMAWithholding Ledger Entry")
                        {
                            DataItemLink = "GMAVoucher Number" = field("GMAPayment Order No."), "GMAWithholding No." = field("GMAWithholding No.");
                            DataItemLinkReference = "GMAPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMANo.")
                                                        WHERE("GMATax Code" = const('SUSS'));
                            //RequestFilterFields = "GMANo.";
                            RequestFilterFields = "GMAWithh. Certificate No.";
                            column(InfoEmpresa_Name897; InfoEmpresa897.BssiLegalNameFull) { }
                            column(ValueType4; ValueType) { }
                            column(InfoEmpresa_Picture897; InfoEmpresa897.BssiPicture) { }
                            column(InfoEmpresa_LocARAddress897; InfoEmpresa897.BssiBillingAddr1 + ', ' + InfoEmpresa897.BssiBillingZipCode + ', ' + InfoEmpresa897.BssiBillingCity + ', ' + gProvincia897 + ', ' + InfoEmpresa897.BssiBillingCountry) { }
                            column(InfoEmpresa__Phone_No__897; InfoEmpresa897.BssiBillingPhoneNumber) { }
                            column(InfoEmpresa__E_Mail_897; InfoEmpresa897.BssiEmail) { }
                            column(InfoEmpresa__Home_Page_897; InfoEmpresa897.BssiHomePage) { }
                            column(InfoEmpresa_Address897; direccionEmpresa897) { }
                            column(InfoEmpresa__Address_2_897; InfoEmpresa897.BssiBillingAddress2) { }
                            column(InfoEmpresa__VAT_Registration_No__897; InfoEmpresa897.BssiRegistrationNo) { }
                            column(InfoEmpresa__N__agente_retenci_n_897; InfoEmpresa897."BssiGrossIncomeNo") { }
                            column(InfoEmpresa_Provincia897; InfoEmpresa897.BssiProvinceCode) { }
                            column(Proveedor__No__ingresos_brutos_897; Proveedor897."GMAGross Income Tax No") { }
                            column(Proveedor__VAT_Registration_No__897; Proveedor897."VAT Registration No.") { }
                            column(Proveedor_Address897; direccionProveedor897) { }
                            column(Proveedor_Name897; Proveedor897.Name) { }
                            column(Movimiento_Retenciones__N__Certificado_Retencion_897; "GMAWithh. Certificate No.") { }
                            column(Movimiento_Retenciones__Fecha_comprobante_897; "GMAVoucher Date") { }
                            column(Provincia__Descripci_n_897; InfoEmpresa897.BssiProvinceCode) { }
                            column(Descripcion897; Descripcion897) { }
                            column(Retencion_TaxSystem897; Retencion_TaxSystem897) { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_897; GMAWithholdingLedgerEntry897."GMACalculation Base") { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_897; GMAWithholdingLedgerEntry897."GMAWithholding Amount") { }
                            column(alicuota897; alicuota897) { }
                            column(minimo897; minimo897) { }
                            column(CERTIFICADO_DE_RETENCION_SUSSCaption897; CERTIFICADO_DE_RETENCION_SUSSCaptionLbl897) { }
                            column(AGENTE_DE_RETENCIONCaption897; AGENTE_DE_RETENCIONCaptionLbl897) { }
                            column(Direcci_nCaption897; Direcci_nCaptionLbl897) { }
                            column(Nro__de_CUITCaption897; Nro__de_CUITCaptionLbl897) { }
                            column(Agente_Retenci_nCaption897; Agente_Retenci_nCaptionLbl897) { }
                            column(Juridisdicci_nCaption897; Juridisdicci_nCaptionLbl897) { }
                            column(Nro__de_IIBBCaption897; Nro__de_IIBBCaptionLbl897) { }
                            column(Nro__de_CUITCaption_Control1000000018897; Nro__de_CUITCaption_Control1000000018Lbl897) { }
                            column(Direcci_nCaption_Control1000000021897; Direcci_nCaption_Control1000000021Lbl897) { }
                            column(SUJETO_DE_RETENCIONCaption897; SUJETO_DE_RETENCIONCaptionLbl897) { }
                            column(Certificado_N_Caption897; Certificado_N_CaptionLbl897) { }
                            column(FechaCaption897; FechaCaptionLbl897) { }
                            column(Jurisdicci_nCaption897; Jurisdicci_nCaptionLbl897) { }
                            column(RETENCIONCaption897; RETENCIONCaptionLbl897) { }
                            column(B__IMPONIBLECaption897; B__IMPONIBLECaptionLbl897) { }
                            column(ALICUOTACaption897; ALICUOTACaptionLbl897) { }
                            column(MINIMOCaption897; MINIMOCaptionLbl897) { }
                            column(RETENIDOCaption897; RETENIDOCaptionLbl897) { }
                            column(EmptyStringCaption897; EmptyStringCaptionLbl897) { }
                            column(EmptyStringCaption_Control1000000041897; EmptyStringCaption_Control1000000041Lbl897) { }
                            column(EmptyStringCaption_Control1000000042897; EmptyStringCaption_Control1000000042Lbl897) { }
                            column(EmptyStringCaption_Control1000000046897; EmptyStringCaption_Control1000000046Lbl897) { }
                            column(Withholding_Ledger_Entry_No_897; "GMANo.") { }
                            column(Withholding_Ledger_Entry_Voucher_Number897; "GMAVoucher Number") { }
                            column("FIRMA_DEL_AGENTE_DE_RETENCIÓNCaption897"; FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl897) { }
                            column(Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaption897; Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl897) { }
                            column(que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_Caption897; que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl897) { }
                            column(InfoEmpresa_Picture2897; InfoEmpresa897.BssiPicture) { }
                            column("ACLARACIÓN_CARGOCaption897"; ACLARACIÓN_CARGOCaptionLbl897) { }
                            column(GMAPictureSign897; "GMATreasury Setup897".GMASignPicture) { }
                            dataitem("GMAPosted Payment Ord Vouch897"; "GMAPosted Payment Ord Vouch")
                            {
                                DataItemLink = "GMAPayment Order No." = FIELD("GMAVoucher Number");
                                DataItemTableView = SORTING("GMAPayment Order No.", "GMAVoucher No.") ORDER(Ascending);
                                column(Movimiento_Retenciones__Valor897; GMAWithholdingLedgerEntry897.GMAValue) { }
                                column(Acumulado897; Acumulado897) { }
                                column(tipocomp897; tipocomp897) { }
                                column(Hist_Lin_Comp_OPago__Nro_Comprobante_897; "GMAVoucher No.") { }
                                column(movfac__External_Document_No__897; movfac897."External Document No.") { }
                                column(ReferenciaCaption897; ReferenciaCaptionLbl897) { }
                                column(Cod__Retenci_nCaption897; Cod__Retenci_nCaptionLbl897) { }
                                column(Base_ImponibleCaption897; Base_ImponibleCaptionLbl897) { }
                                column(EmptyStringCaption_Control1000000047897; EmptyStringCaption_Control1000000047Lbl897) { }
                                column(Nro__FacturaCaption897; Nro__FacturaCaptionLbl897) { }
                                column(Declaraci_n_en_la_que_se_informar__la_retencion__Caption897; Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl897) { }
                                column(EmptyStringCaption_Control1000000049897; EmptyStringCaption_Control1000000049Lbl897) { }
                                column(Posted_Payment_Order_Vouchers_Payment_Order_No_897; "GMAPayment Order No.") { }
                                column(Posted_Payment_Order_Vouchers_Entry_No_897; "GMAEntry No.") { }

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
                                    Acumulado897 := 0;
                                    ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                                    Facturas.RESET;
                                    Facturas.SETCURRENTKEY("No.");
                                    Facturas.SETRANGE(Facturas."No.", "GMAPosted Payment Ord Vouch897"."GMAVoucher No.");
                                    if Facturas.FINDFIRST then begin
                                        Facturas.CALCFIELDS("Amount Including VAT");
                                        //Calculo porcentaje del pago sobre el total de la factura
                                        if Facturas."Currency Factor" <> 0 then
                                            PorcMonto := (("GMAAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                                        else
                                            PorcMonto := (("GMAAmount (LCY)" * 100) / Facturas."Amount Including VAT");

                                        LineasFactura.RESET;
                                        LineasFactura.SETCURRENTKEY("Document No.", "Line No.");
                                        LineasFactura.SETRANGE("Document No.", "GMAPosted Payment Ord Vouch897"."GMAVoucher No.");
                                        if LineasFactura.FINDFIRST then begin
                                            repeat
                                                Comportamiento.RESET;
                                                Comportamiento.SETCURRENTKEY("GMAWithholding No.", "GMAWithholding Code");
                                                Comportamiento.SETRANGE(Comportamiento."GMAWithholding Code", LineasFactura."GMAWithholding Code");
                                                Comportamiento.SETRANGE(Comportamiento."GMATax System", GMAWithholdingLedgerEntry897."GMATax System");
                                                Comportamiento.SETRANGE(Comportamiento."GMAWithholding No.", GMAWithholdingLedgerEntry897."GMAWithholding No.");//NAVAR1.06
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
                                                            CondImpuesto.SETRANGE(CondImpuesto."GMAVendor Code", "GMAPosted Payment Ord Vouch897".GMAVendor);
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
                                                                                Acumulado897 := ((PorcMonto * (LineasFactura."VAT Base Amount" / Facturas."Currency Factor")) / 100) +
                                                                                                         Acumulado897
                                                                            else
                                                                                Acumulado897 := ((PorcMonto * LineasFactura."VAT Base Amount") / 100) +
                                                                                                    Acumulado897;

                                                                        DetRetencion."GMAWithholding Base Type"::"Importe Impuestos":
                                                                            if Facturas."Currency Factor" <> 0 then
                                                                                Acumulado897 := ((PorcMonto * ((LineasFactura."Amount Including VAT" / Facturas."Currency Factor")
                                                                                                    - (LineasFactura."VAT Base Amount" / Facturas."Currency Factor"))) / 100) +
                                                                                                       Acumulado897
                                                                            else
                                                                                Acumulado897 := ((PorcMonto * (LineasFactura."Amount Including VAT"
                                                                                                     - LineasFactura."VAT Base Amount")) / 100) + Acumulado897;

                                                                        DetRetencion."GMAWithholding Base Type"::"Importe Total":
                                                                            if Facturas."Currency Factor" <> 0 then
                                                                                Acumulado897 := ((PorcMonto * (LineasFactura."Amount Including VAT" / Facturas."Currency Factor")) / 100) +
                                                                                                         Acumulado897
                                                                            else
                                                                                Acumulado897 := ((PorcMonto * LineasFactura."Amount Including VAT") / 100) +
                                                                                                     Acumulado897;
                                                                    end;

                                                                end;
                                                            end;
                                                        end;
                                                    end;

                                                end;
                                                //NAVAR1.06002-
                                                Acumulado897 := ROUND(Acumulado897, 0.01);
                                            //NAVAR1.06002+
                                            until LineasFactura.NEXT = 0;
                                        end;

                                    end;

                                    movfac897.RESET;
                                    movfac897.SETCURRENTKEY("Entry No.");
                                    movfac897.SETRANGE(movfac897."Document No.", "GMAPosted Payment Ord Vouch897"."GMAVoucher No.");
                                    ok897 := movfac897.FINDFIRST;

                                    tipocomp897 := '';
                                    if (movfac."Document Type" = movfac."Document Type"::Invoice) then begin
                                        tipocomp897 := 'FC';
                                        //ImporteNC := FindApplicCreditMemo("Hist Lin Comp OPago"."Nro Comprobante");
                                    end;
                                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                        tipocomp897 := 'NC';

                                    if (movfac."Document Type" = movfac."GMADocument Type Loc."::"GMANota Debito") then
                                        tipocomp897 := 'ND';

                                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                        Acumulado897 := -Acumulado;

                                    CLEAR(TOTAL);


                                    if (HOPago.GET("GMAPosted Payment Ord Vouch897"."GMAPayment Order No.")) then
                                        if (HOPago."GMANew Payment") then
                                            IF ("GMAPosted Payment Ord Vouch897"."GMACurrency Code" <> '') THEN begin
                                                Acumulado897 := "GMAPosted Payment Ord Vouch897"."GMATo be Cancelled (LCY)"
                                            end;



                                    GMAWithholdingLedgerEntry897."GMACalculation Base" := ROUND(GMAWithholdingLedgerEntry897."GMACalculation Base");
                                    if Acumulado897 = 0 then
                                        CurrReport.SKIP;
                                end;
                            }

                            trigger OnAfterGetRecord();
                            var
                                BssiMEMSystemSetup: record BssiMEMSystemSetup;
                            begin

                                IF (ValueType <> 4) THEN
                                    CurrReport.sKIP;
                                IF (printWitholding(GMAWithholdingLedgerEntry897)) then
                                    CurrReport.sKIP;
                                DetRetencion897.RESET;
                                DetRetencion897.SETCURRENTKEY("GMAWithholding No.", "GMATax Code", "GMATax System");
                                DetRetencion897.SETRANGE(DetRetencion897."GMAWithholding No.", GMAWithholdingLedgerEntry897."GMAWithholding No.");
                                if DetRetencion897.FINDFIRST then
                                    Descripcion897 := DetRetencion897.GMADescription;
                                Retencion_TaxSystem897 := DetRetencion897."GMATax System";
                                Escala897.RESET;
                                Escala897.SETCURRENTKEY("GMAScale Code", "GMAWithholding Condition", "GMATax Code", GMAFrom);
                                Escala897.SETRANGE(Escala897."GMAScale Code", GMAWithholdingLedgerEntry897."GMAScale Code");
                                Escala897.SETRANGE(Escala897."GMAWithholding Condition", GMAWithholdingLedgerEntry897."GMACondition Code");
                                Escala897.SETRANGE(Escala897."GMATax Code", GMAWithholdingLedgerEntry897."GMATax Code");
                                if Escala897.FINDFIRST then
                                    repeat
                                        if (Escala897.GMAFrom <= GMAWithholdingLedgerEntry897."GMACalculation Base") then begin
                                            alicuota897 := Escala897."GMAExcedent %";
                                            minimo897 := Escala897.GMAFrom;
                                        end;
                                    until Escala897.NEXT = 0;


                                //NAVAR1.06001-
                                Provincia897.RESET;
                                Provincia897.SETCURRENTKEY("GMAProvince Code");
                                Provincia897.SETRANGE("GMAProvince Code", "GMAProvince Code");
                                if Provincia897.FINDFIRST then
                                    gProvincia897 := Provincia897.GMADescription
                                else
                                    gProvincia897 := '';
                                //11807+
                                "Withholding Kind Line897".RESET;
                                "Withholding Kind Line897".SETRANGE("Withholding Kind Line897"."GMAWithholding Code", GMAWithholdingLedgerEntry897."GMAWithholding Code");
                                "Withholding Kind Line897".SETRANGE("Withholding Kind Line897"."GMATax Code", GMAWithholdingLedgerEntry897."GMATax Code");
                                "Withholding Kind Line897".SETRANGE("Withholding Kind Line897"."GMAIs vendor withholding", true);
                                if ("Withholding Kind Line897".FINDFIRST) then begin
                                    if (GMAWithholdingLedgerEntry897."Vendor withholding" <> '') then begin
                                        Proveedor897.RESET;
                                        Proveedor897.SETCURRENTKEY("No.");
                                        Proveedor897.SETRANGE("No.", GMAWithholdingLedgerEntry897."Vendor withholding");
                                        if Proveedor897.FINDFIRST then;
                                    end
                                    else begin
                                        Proveedor897.RESET;
                                        Proveedor897.SETCURRENTKEY("No.");
                                        Proveedor897.SETRANGE("No.", "GMAVendor Code");
                                        if Proveedor897.FINDFIRST then;
                                    end;
                                end
                                else begin
                                    Proveedor897.RESET;
                                    Proveedor897.SETCURRENTKEY("No.");
                                    Proveedor897.SETRANGE("No.", "GMAVendor Code");
                                    if Proveedor897.FINDFIRST then;
                                end;
                                //11807-
                                if (Proveedor897.Address <> '') then direccionProveedor897 := Proveedor897.Address;
                                if (Proveedor897.City <> '') then direccionProveedor897 := direccionProveedor897 + ',  ' + Proveedor897.City;
                                if (Proveedor897."Post Code" <> '') then direccionProveedor897 := direccionProveedor897 + ', C.P. ' + Proveedor897."Post Code";
                                if (Proveedor897."Country/Region Code" <> '') then begin
                                    maestroPais897.Reset();
                                    maestroPais897.SetFilter(Code, Proveedor897."Country/Region Code");
                                    if maestroPais897.FindFirst() then direccionProveedor897 := direccionProveedor897 + ', ' + maestroPais897.GetNameInCurrentLanguage();
                                end;
                                InfoEmpresa897.Reset();
                                InfoEmpresa897.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                                InfoEmpresa897.SetFilter(Code, GMAWithholdingLedgerEntry897."GMAShortcut Dimension 1");
                                IF (InfoEmpresa897.FindFirst()) THEN;
                                InfoEmpresa897.CALCFIELDS(InfoEmpresa897.BssiPicture);
                                Provincia897.RESET;
                                Provincia897.SETCURRENTKEY(Provincia897."GMAProvince Code");
                                Provincia897.SETRANGE("GMAProvince Code", InfoEmpresa897.BssiProvinceCode);
                                if Provincia897.FINDFIRST then
                                    gProvincia897 := Provincia897.GMADescription;

                                if (InfoEmpresa897.BssiBillingAddr1 <> '') then direccionEmpresa897 := InfoEmpresa897.BssiBillingAddr1;
                                if (InfoEmpresa897.BssiBillingCity <> '') then direccionEmpresa897 := direccionEmpresa897 + ',  ' + InfoEmpresa897.BssiBillingCity;
                                if (InfoEmpresa897.BssiBillingZipCode <> '') then direccionEmpresa897 := direccionEmpresa897 + ', C.P. ' + InfoEmpresa897.BssiBillingZipCode;
                                if (InfoEmpresa897.BssiBillingCountry <> '') then begin
                                    maestroPais897.Reset();
                                    maestroPais897.SetFilter(Code, InfoEmpresa897.BssiBillingCountry);
                                    if maestroPais897.FindFirst() then direccionEmpresa897 := direccionEmpresa897 + ', ' + maestroPais897.Name;
                                end;

                            end;

                            trigger OnPreDataItem();
                            var
                                Valores2: record GMAValues;

                            begin
                                ok897 := InfoEmpresa897.FINDFIRST;
                                "GMATreasury Setup897".GET();
                                "GMATreasury Setup897".CALCFIELDS(GMASignPicture);

                                ValueType := 0;
                                Valores2.Reset();
                                Valores2.GET("GMAPosted Payment Order Valu".GMAValue);
                                if Valores2."GMAReport ID" = 34006897 then
                                    ValueType := 4
                                else
                                    CurrReport.Skip();
                                GMAWithholdingLedgerEntry897.SETRANGE(GMAWithholdingLedgerEntry897.GMAValue, Valores2.GMACode);
                                if GMAWithholdingLedgerEntry897.FINDFIRST then;
                            end;
                        }


                        trigger OnAfterGetRecord();
                        begin
                            Valores.GET("GMAPosted Payment Order Valu".GMAValue);
                            if "GMAPosted Payment Order Valu"."GMACurrency Code" = '' then
                                Valordivisa := 'PESO ARG'
                            else
                                Valordivisa := "GMAPosted Payment Order Valu"."GMACurrency Code";

                            if "GMACurrency Factor" <> 0 then
                                Importepesos := GMAAmount / "GMACurrency Factor"
                            else
                                Importepesos := GMAAmount;

                            Totalpesos := Totalpesos + Importepesos;
                            Banco.Get("GMAPosted Payment Order Valu"."GMACash/Bank");
                            BankMaster.Reset();
                            BankMaster.Get(Banco."GMANav Bank Account Number");

                            if "GMAPosted Payment Order Valu"."GMACurrency Code" = '' then
                                SimboloMonedaValue := '$'
                            else begin
                                ValueMoneda.GET("GMAPosted Payment Order Valu"."GMACurrency Code");
                                SimboloMonedaValue := ValueMoneda.Symbol;
                            End;

                            if (SimboloMonedaValueValueAnterior <> '') and (SimboloMonedaValueValueAnterior <> SimboloMonedaValue) then begin
                                SimboloMonedaValueValueAnterior := SimboloMonedaValue;
                                FlagValue := 0;
                            end
                            else begin
                                FlagValue := 1;
                                SimboloMonedaValueValueAnterior := SimboloMonedaValue;
                            end;

                            ImportepesosSum += Importepesos;
                            Hist_Lin_Valor_OPago_ImporteSum += GMAAmount;
                        end;

                        trigger OnPreDataItem();
                        begin
                            Clear(ImportepesosSum);
                            Clear(Hist_Lin_Valor_OPago_ImporteSum);
                            Totalpesos := 0;
                        end;
                    }
                    dataitem(ParaDivisas; Currency)
                    {
                        DataItemTableView = SORTING(Code) ORDER(Ascending);
                        column(Divisa; Divisa) { }
                        column(FactorDiv; FactorDiv)
                        {
                            DecimalPlaces = 2 : 4;
                        }
                        column(ConfEmpresa__LCY_Code_; ConfEmpresa."LCY Code") { }
                        column(TIPO_DE_CAMBIOCaption; TIPO_DE_CAMBIOCaptionLbl) { }
                        column(V1_00Caption; V1_00CaptionLbl) { }
                        column(EmptyStringCaption_Control1000000074; EmptyStringCaption_Control1000000074Lbl) { }
                        column(ParaDivisas_Code; Code) { }

                        trigger OnAfterGetRecord();
                        var
                            LinCom: Record "GMAPosted Payment Ord Vouch";
                            LinVal: Record "GMAPosted Payment Order Valu";
                            HayDivisa: Boolean;
                        begin
                            LinCom.RESET;
                            LinCom.SETRANGE(LinCom."GMAPayment Order No.", "Hist Cab OPago"."GMAPayment O. No.");
                            if LinCom.FindSet() then
                                repeat
                                    if LinCom."GMACurrency Code" <> '' then begin
                                        if LinCom."GMAExchange Rate" <> 0 then
                                            FactorDiv := 1 / LinCom."GMAExchange Rate"
                                        else
                                            FactorDiv := 0;
                                        Divisa := LinCom."GMACurrency Code";
                                        HayDivisa := true;
                                    end;
                                until LinCom.NEXT = 0;
                            LinVal.RESET;
                            LinVal.SETRANGE(LinVal."GMAPayment Order No.", "Hist Cab OPago"."GMAPayment O. No.");
                            if LinVal.FindSet() then
                                repeat
                                    if LinVal."GMACurrency Code" <> '' then begin
                                        if LinVal."GMACurrency Factor" <> 0 then
                                            FactorDiv := 1 / LinVal."GMACurrency Factor"
                                        else
                                            FactorDiv := 0;
                                        Divisa := LinVal."GMACurrency Code";
                                        HayDivisa := true;
                                    end;
                                until LinVal.NEXT = 0;

                            if not HayDivisa then
                                CurrReport.SKIP;
                        end;

                        trigger OnPreDataItem();
                        begin
                            ConfEmpresa.GET;
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin

                    OutputNo += 1;

                end;

                trigger OnPreDataItem();
                begin
                    //NAVAR1.06003-
                    SETRANGE(Number, 1, 1);

                    OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            var
                //DDS15082025 se agrego el aprobador 
                ApprovalEntry: Record "Approval Entry";
                purchaseinvline: Record "Purch. Inv. Line";
                purchcrmemoline: Record "Purch. Cr. Memo Line";
            //DDS15082025 se agrego el aprobador 

            begin
                FechaReporte := "Hist Cab OPago"."GMAPayment O. Date";
                if fechaposting = true then
                    FechaReporte := "Hist Cab OPago"."GMAPosting Date";
                Proveedor.GET("Hist Cab OPago"."GMAVendor No.");
                InfoEmpresa.Reset();
                //DDSDESCOMENTAR InfoEmpresa.SetFilter(Code, BssiMEMEntityID);
                IF (InfoEmpresa.FindFirst()) THEN;
                RecProvincia.RESET;
                RecProvincia.SETCURRENTKEY(RecProvincia."GMAProvince Code");
                RecProvincia.SETRANGE("GMAProvince Code", InfoEmpresa.BssiProvinceCode);
                RecPais.RESET;
                RecPais.GET(InfoEmpresa.BssiBillingCountry);
                ValoresRecibidos.RESET;
                ValoresRecibidos.SETRANGE("GMAPayment Order No.", "Hist Cab OPago"."GMAPayment O. No.");
                Clear(ImpTotalValor);
                Clear(ImpTotalValorDolar);
                CLEAR(ImpTotalValorBanco);
                Clear(MonedaVoucher);
                EsDolar := false;

                if ValoresRecibidos.FindFirst then
                    repeat
                        IF (banco.get(ValoresRecibidos."GMACash/Bank")) THEN
                            IF (banco.GMAType = banco.GMAType::Banco) THEN
                                ImpTotalValorBanco += ValoresRecibidos."GMAAmount (LCY)";
                        ImpTotalValor := ImpTotalValor + ValoresRecibidos."GMAAmount (LCY)";
                        if ValoresRecibidos."GMACurrency Code" <> '' then begin
                            ImpTotalValorFuncional := ImpTotalValorFuncional + ValoresRecibidos."GMAAmount (LCY)";
                            ImpTotalValorDolar := ImpTotalValorDolar + ValoresRecibidos.GMAAmount;
                        end;
                    until ValoresRecibidos.Next = 0;

                VoucherAplicado.RESET;
                VoucherAplicado.SETRANGE("GMAPayment Order No.", "Hist Cab OPago"."GMAPayment O. No.");
                if VoucherAplicado.FindFirst then
                    repeat
                        if VoucherAplicado."GMACurrency Code" <> '' then begin
                            //CambioMoneda.Get(VoucherAplicado."GMACurrency Code", VoucherAplicado.GMADate);
                            ImpTotalValorFuncionalVoucher := ImpTotalValorFuncionalVoucher + VoucherAplicado."GMAAmount (LCY)";//  VoucherAplicado.GMAAmount * CambioMoneda."Relational Exch. Rate Amount";
                            ImpTotalValorDolarVoucher := ImpTotalValorDolarVoucher + VoucherAplicado.GMAAmount;
                            EsDolar := true;
                            MonedaVoucher := VoucherAplicado."GMACurrency Code"
                        end;
                        //DDS15082025 se agrego el aprobador 
                        IF (UserAprovalName = '') THEN begin
                            Postedaproval.Reset();
                            Postedaproval.SetRange("Document No.", VoucherAplicado."GMAVoucher No.");

                            if Postedaproval.Count > 0 then begin
                                if Postedaproval.Count > 1 then begin
                                    // Hay más de un registro → tomar el penúltimo
                                    if Postedaproval.FindLast() then;
                                    //if Postedaproval.Next(-1) <> 0 then; // mover al penúltimo
                                end else begin
                                    // Solo un registro → usar ese
                                    Postedaproval.FindFirst();
                                end;

                                // Recién acá usamos el registro encontrado
                                UserAproval.Reset();
                                UserAproval.SetRange("User Name", Postedaproval."Approver ID");
                                if UserAproval.FindFirst() then
                                    UserAprovalName := UserAproval."Full Name";
                            end
                            else
                                UserAprovalName := '';
                            //Si esta en blanco quiere decir que el documento registrado no tiene aprobaciones y hay que buscar en pedidos aprobados
                            IF (UserAprovalName = '') THEN begin
                                IF (VoucherAplicado."GMADocument Type" = VoucherAplicado."GMADocument Type"::"Credit Memo") THEN begin
                                    purchcrmemoline.Reset();
                                    purchcrmemoline.SetRange("Document No.", VoucherAplicado."GMAVoucher No.");
                                    IF (purchcrmemoline.FindFirst()) THEN
                                        repeat
                                            IF (purchcrmemoline."Order No." <> '') THEN begin
                                                ApprovalEntry.Reset();
                                                ApprovalEntry.SetCurrentKey("Entry No.");
                                                ApprovalEntry.SetRange("Document No.", purchcrmemoline."Order No.");

                                                if ApprovalEntry.Count > 0 then begin
                                                    if ApprovalEntry.Count > 1 then begin
                                                        // Hay más de un registro → quedarnos con el penúltimo
                                                        if ApprovalEntry.FindLast() then;
                                                        //if ApprovalEntry.Next(-1) <> 0 then; // mover al penúltimo
                                                    end else begin
                                                        // Solo un registro → usar ese
                                                        ApprovalEntry.FindFirst();
                                                    end;

                                                    // Recién acá usamos el ApprovalEntry actual (penúltimo o único)
                                                    UserAproval.Reset();
                                                    UserAproval.SetRange("User Name", ApprovalEntry."Approver ID");
                                                    if UserAproval.FindFirst() then
                                                        UserAprovalName := UserAproval."Full Name";
                                                end;
                                            end;
                                        until purchcrmemoline.Next = 0;

                                end
                                else begin
                                    purchaseinvline.Reset();
                                    purchaseinvline.SetRange("Document No.", VoucherAplicado."GMAVoucher No.");
                                    IF (purchaseinvline.FindFirst()) THEN
                                        repeat
                                            IF (purchaseinvline."Order No." <> '') THEN begin
                                                ApprovalEntry.Reset();
                                                ApprovalEntry.SetCurrentKey("Entry No.");
                                                ApprovalEntry.SetRange("Document No.", purchaseinvline."Order No.");

                                                if ApprovalEntry.Count > 0 then begin
                                                    if ApprovalEntry.Count > 1 then begin
                                                        // Hay más de un registro → quedarnos con el penúltimo
                                                        if ApprovalEntry.FindLast() then;
                                                        //if ApprovalEntry.Next(-1) <> 0 then; // mover al penúltimo
                                                    end else begin
                                                        // Solo un registro → usar ese
                                                        ApprovalEntry.FindFirst();
                                                    end;

                                                    // Recién acá usamos el ApprovalEntry actual (penúltimo o único)
                                                    UserAproval.Reset();
                                                    UserAproval.SetRange("User Name", ApprovalEntry."Approver ID");
                                                    if UserAproval.FindFirst() then
                                                        UserAprovalName := UserAproval."Full Name";
                                                end;
                                            end;
                                        until purchaseinvline.Next = 0;
                                end;

                            end;
                        end;

                    //DDS15082025 se agrego el aprobador 
                    until VoucherAplicado.Next = 0;


                /* CambioMoneda.RESET;
                  CambioMoneda.SETRANGE("Currency Code", MonedaVoucher);
                  CambioMoneda.SETRANGE("Starting Date", "Hist Cab OPago"."GMAPayment O. Date");*/
                //CambioMoneda.FindLast;

                if ImpTotalValorDolar = ImpTotalValorDolarVoucher then begin
                    DiferenciaDeCambio := ImpTotalValorFuncionalVoucher - ImpTotalValorFuncional;
                end
                else begin
                    //  DiferenciaDeCambio := (ImpTotalValorDolar * CambioMoneda."Relational Exch. Rate Amount") - ImpTotalValorFuncional;
                    DiferenciaDeCambio := ImpTotalValorFuncionalVoucher - ImpTotalValorFuncional;
                end;

                DiferenciaDeCambio := ROUND(DiferenciaDeCambio, 0.01);

                if ValoresRecibidos."GMACurrency Code" <> '' then
                    ok := Moneda.GET(ValoresRecibidos."GMACurrency Code");
                //Tesoreria.Get();
                if DiferenciaDeCambio < 0 then
                    CuentaDifDeCambio := Moneda."Unrealized Losses Acc."
                else
                    CuentaDifDeCambio := Moneda."Unrealized Gains Acc.";

                Language_Code := 'ESP';
                if Language_Code = 'ENU' then begin
                    Convierto.FormatNoText(NumberText, ROUND(ImpTotalValor, 0.01),
                    "GMAPosted Payment Ord Vouch"."GMACurrency Code");
                end
                else begin

                    Convierto.FormatNoText(NumberTextBanco, ROUND(ImpTotalValorBanco, 0.01), '');
                    Convierto.FormatNoText(NumberText, ROUND(ImpTotalValor, 0.01), '');
                end;

                CLEAR(importeLetrasBanco);
                if "GMAPosted Payment Order Valu"."GMACurrency Code" <> '' then begin
                    ok := Moneda.GET("GMAPosted Payment Order Valu"."GMACurrency Code");
                    if (Moneda."Currency Factor" <> 0) then
                        leyenda2 := 'Al solo  efecto impositivo el tipo de cambio aplicado es de $ ' + FORMAT(ROUND(1 / Moneda."Currency Factor", 0.0001, '=')) +
                                    'por cada ' + Moneda.Description;

                    ImporteLetras := 'Son ' + Moneda.Description + ': ' + NumberText[1] + NumberText[2];/*+ '  a TC: ' + FORMAT(ROUND(1/factor,0.0001,'='));*/
                    importeLetrasBanco := 'Monto a extraer del banco son ' + Moneda.Description + ':' + FORMAT(ImpTotalValorBanco) + ' ' + NumberTextBanco[1] + NumberTextBanco[2];
                end
                else begin
                    ImporteLetras := 'Son Pesos: ' + NumberText[1] + NumberText[2];
                    importeLetrasBanco := 'Monto a extraer del banco son Pesos: ' + FORMAT(ImpTotalValorBanco) + ' ' + NumberTextBanco[1] + NumberTextBanco[2];
                end;
                if RecProvincia.FINDFIRST then
                    gProvincia := RecProvincia.GMADescription;

                CuentaC := "Hist Cab OPago".GMAVendorSL;
                "Calc&ShowLin" := false;
                InfoEmpresa.CALCFIELDS(InfoEmpresa.BssiPicture);

                MonedaFuncional.GET();
                SimboloMonedaFuncional := MonedaFuncional."Local Currency Symbol";
            end;

            trigger OnPreDataItem();
            begin

                "GMATreasury Setup".GET();
                "GMATreasury Setup".CALCFIELDS(GMASignPicture);
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
                    field(fechaposting; fechaposting)
                    {
                        Caption = 'Use Posting Date';
                        ApplicationArea = ALL;
                    }
                }
            }
        }

        actions { }
    }

    labels { }
    trigger OnInitReport();
    begin
        optCopias894 := optCopias894::"Sólo original";
    end;

    trigger OnPreReport();
    begin
        textoCopia894[1] := 'ORIGINAL';
        textoCopia894[2] := 'DUPLICADO';
        textoCopia894[3] := 'TRIPLICADO';
    end;

    var
        //DDS15082025 se agrego el aprobador 
        Postedaproval: Record "Posted Approval Entry";
        UserAprovalName: Text[100];
        UserAproval: Record User;
        //DDS15082025 se agrego el aprobador 
        fechaposting: Boolean;
        ImportepesosSum: Decimal;

        Hist_Lin_Valor_OPago_ImporteSum: decimal;
        "GMATreasury Setup": Record "GMATreasury Setup";
        Proveedor: Record Vendor;
        Valordivisa: Code[10];
        Valores: Record GMAValues;
        Banco: Record "GMACash/Bank Account";
        BankMaster: Record "Bank Account";
        RecPais: Record "Country/Region";
        ValoresRecibidos: Record "GMAPosted Payment Order Valu";
        VoucherAplicado: Record "GMAPosted Payment Ord Vouch";
        ImpTotalValor: Decimal;
        ImpTotalValorBanco: Decimal;
        ImpTotalValorDolar: Decimal;
        ImpTotalValorFuncional: Decimal;
        ImpTotalValorDolarVoucher: Decimal;
        ImpTotalValorFuncionalVoucher: Decimal;
        DiferenciaDeCambio: Decimal;
        MonedaVoucher: Code[20];
        CambioMoneda: Record "Currency Exchange Rate";
        EsDolar: Boolean;
        Tesoreria: Record "GMATreasury Setup";
        CuentaDifDeCambio: Code[20];
        VoucherMoneda: Record Currency;
        SimboloMonedaVoucher: Text[10];
        SimboloMonedaVoucherVoucherAnterior: Text[10];
        SimboloMonedaValueValueAnterior: Text[10];
        FlagVoucher: Integer;
        FlagValue: Integer;
        ValueMoneda: Record Currency;
        SimboloMonedaValue: Text[10];
        MonedaFuncional: Record "General Ledger Setup";
        SimboloMonedaFuncional: Text[10];
        Importepesos: Decimal;
        Totalpesos: Decimal;
        Facturas: Record "Purch. Inv. Header";
        TipoDocumento: Text[10];
        NumberText: array[2] of Text[256];
        NumberTextBanco: array[2] of Text[256];
        Moneda: Record Currency;
        leyenda2: Text[100];
        ImporteLetras: Text[1024];
        ImporteLetrasBanco: Text[1024];
        ok: Boolean;
        Convierto: Codeunit GMAConvierteNoAText;
        Language_Code: Text[3];
        NumFacProveedor: Code[20];
        InfoEmpresa: Record "Dimension Value";
        InfoEmpresaPO: Record "Dimension Value";
        DivisaTesoreria: Record "GMATreasury Currencies";
        ConfEmpresa: Record "General Ledger Setup";
        FactorDiv: Decimal;
        Divisa: Code[20];
        gProvincia: Text[50];
        RecProvincia: Record GMAProvince;
        RecPurchHeader: Record "Purchase Header";
        CodProyecto: Text[30];
        RecPurchHeaderInv: Record "Purch. Inv. Header";
        RecPurchCRMemoInv: Record "Purch. Cr. Memo Hdr.";
        Encontro: Boolean;
        txtSaldoCuentaC: Text[250];
        txtSaldoSi: Text[250];
        Text001: Label 'Saldo cuenta corriente al';
        Text002: Label 'Saldo si se confirma la orden de pago';
        CuentaC: Decimal;
        TotalConfirmadoCuenta: Decimal;
        OutputNo: Integer;
        AuxRecHistLinCOP: Record "GMAPosted Payment Ord Vouch";
        AuxImportePesos: Decimal;
        AuxTotalPesos: Decimal;
        "Calc&ShowLin": Boolean;
        RecPurchCRMemoInv2: Record "Purch. Cr. Memo Hdr.";
        Obra: Record Job;
        NombreObra: Text[30];
        FIRMA_SOLICITANTECaptionLbl: Label 'CONFECCIÓN';
        FIRMA_GERENTE_FINANCIEROCaptionLbl: Label 'AUTORIZACIÓN';
        FIRMA_GERENTE_GENERALCaptionLbl: Label 'RECEPCIÓN';
        Fecha_CaptionLbl: Label 'Fecha:';
        SE_ORES_CaptionLbl: Label 'SEÑORES:';
        C_U_I_T___CaptionLbl: Label '"C.U.I.T.: "';
        Proveedor_N___CaptionLbl: Label '"Proveedor Nº: "';
        INGRESOS_BRUTOS_N__CaptionLbl: Label 'INGRESOS BRUTOS Nº:';
        Tel_CaptionLbl: Label 'Tel.';
        E_mailCaptionLbl: Label 'E-mail';
        O_R_D_E_N___D_E___P_A_G_OCaptionLbl: Label 'O R D E N   D E   P A G O';
        C_P_CaptionLbl: Label 'C.P.';
        N__CaptionLbl: Label 'Nº:';
        DATOS_DE_FACTURAS_O_N__DEBITOSCaptionLbl: Label 'DATOS DE FACTURAS O N. DEBITOS';
        ComprobanteCaptionLbl: Label 'Comprobante';
        DivisaCaptionLbl: Label 'Divisa';
        Su_PagoCaptionLbl: Label 'Su Pago';
        En_PesosCaptionLbl: Label 'En Pesos';
        EN_CONCEPTO_DECaptionLbl: Label 'EN CONCEPTO DE';
        Job_NoCaptionLbl: Label 'Job No';
        T_O_T_A_L_E_S_CaptionLbl: Label '"T O T A L E S "';
        EmptyStringCaptionLbl: Label '__________________________________________________________________________________________________________________';
        N_meroCaptionLbl: Label 'Número';
        S_E_G_U_N___D_E_T_A_L_L_E_CaptionLbl: Label 'S E G U N   D E T A L L E:';
        ValorCaptionLbl: Label 'Valor';
        DivisaCaption_Control1000000045Lbl: Label 'Divisa';
        En_PesosCaption_Control1000000047Lbl: Label 'En Pesos';
        CajaCaptionLbl: Label 'Caja';
        EmptyStringCaption_Control1000000034Lbl: Label '__________________________________________________________________________________________________________________';
        T_O_T_A_L_E_S_Caption_Control1000000035Lbl: Label '"T O T A L E S "';
        TIPO_DE_CAMBIOCaptionLbl: Label 'TIPO DE CAMBIO';
        V1_00CaptionLbl: Label '1,00';
        EmptyStringCaption_Control1000000074Lbl: Label '=';


        DimensionValue: Record "Dimension Value";
        //  Proveedor: Record Vendor;
        //  ok: Boolean;
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
        //   "GMATreasury Setup": Record "GMATreasury Setup";
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
        "Withholding Kind Line": Record "GMAWithholding Kind Line";
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
        //  EmptyStringCaptionLbl: Label '*';
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
        //   gProvincia: Text[50];
        //   RecProvincia: Record GMAProvince;
        direccionProveedor: Text[250];
        direccionEmpresa: Text[250];
        maestroPais: Record "Country/Region";
        ValueType: Integer;



        "GMATreasury Setup 894": Record "GMATreasury Setup";
        InfoEmpresa894: Record "Dimension Value";
        Proveedor894: Record Vendor;
        ok894: Boolean;
        Descripcion894: Text[100];
        DetRetencion894: Record "GMAWithholding Datail";
        Escala894: Record "GMAWithholding Scale";
        alicuota894: Decimal;
        minimo894: Decimal;
        Provincia894: Record GMAProvince;
        Retenciones894: Codeunit GMARetenciones;
        retencion894: Record "GMAWithholding Calculation";
        Acumulado894: Decimal;
        movfac894: Record "Vendor Ledger Entry";
        HOPago894: Record "GMAPosted Payment Order";
        InicioMes894: Date;
        blnEncontroRetencionesAnt894: Boolean;
        txtLugarYFecha894: Text[250];
        txtNroComprobantes894: array[150] of Text[250];
        txtDeclaracion894: Text[250];
        decPagosAnt894: Decimal;
        decRetenAnt894: Decimal;
        decMinimoNoImp894: Decimal;
        optCopias894: Option "Sólo original",Duplicado,Triplicado;
        textoCopia894: array[3] of Text[50];
        Temp_PagosProcesados894: Record "GMAPosted Payment Order" temporary;
        txtNroC894: array[30] of Text[250];
        Contador894: Integer;
        "Hist Lin Valor OPago894": Record "GMAPosted Payment Order Valu";
        tipocomp894: Text[30];
        tipocomp897: Text[30];
        DescRet894: Text[250];
        "Tipo fiscal894": Record "GMAFiscal Type";
        globImpuestos894: Record GMATaxes;
        tipoCond894: Text[30];
        AcumTotal894: Decimal;
        VendorLedgerEntry894: Record "Vendor Ledger Entry";
        numero894: Integer;
        ImporteNC894: Decimal;
        TOTAL894: Decimal;
        TOTALNC894: Decimal;
        "Withholding Kind Line894": Record "GMAWithholding Kind Line";
        "CERTIFICADO_DE_RETENCIÓN_N_CaptionLbl894": Label 'CERTIFICADO DE RETENCIÓN Nº';
        DATOS_DEL_AGENTE_DE_RETENCIONCaptionLbl894: Label 'DATOS DEL AGENTE DE RETENCION';
        Domicilio_CaptionLbl894: Label 'Domicilio:';
        Nro__de_CUIT_CaptionLbl894: Label 'Nro. de CUIT:';
        Ag__de_Ret__N__CaptionLbl894: Label 'Ag. de Ret. N°:';
        Nro__de_IIBBCaptionLbl894: Label 'Nro. de IIBB';
        Nro__de_CUIT_Caption_Control1000000052Lbl894: Label 'Nro. de CUIT:';
        "Dirección_CaptionLbl894": Label 'Dirección:';
        DATOS_DEL_SUJETO_RETENIDOCaptionLbl894: Label 'DATOS DEL SUJETO RETENIDO';
        FECHA_CaptionLbl894: Label 'FECHA:';
        EmptyStringCaptionLbl894: Label '-';
        EmptyStringCaption_Control1000000088Lbl894: Label '-';
        EmptyStringCaption_Control1000000089Lbl894: Label '-';
        "Razón_Social_CaptionLbl894": Label 'Razón Social:';
        Tipo_de_ContribuyenteCaptionLbl894: Label 'Tipo de Contribuyente';
        "Razón_Social_Caption_Control1000000092Lbl894": Label 'Razón Social:';
        CurrReport_PAGENOCaptionLbl894: Label 'Page';
        ORDEN_DE_PAGO_N__CaptionLbl894: Label 'ORDEN DE PAGO Nº:';
        Sit__ante_IVA_CaptionLbl894: Label 'Sit. ante IVA:';
        EmptyStringCaption_Control1000000081Lbl894: Label '$';
        EmptyStringCaption_Control1000000080Lbl894: Label '$';
        Retenciones_anterioresCaptionLbl894: Label 'Retenciones anteriores';
        EmptyStringCaption_Control1000000079Lbl894: Label '$';
        EmptyStringCaption_Control1000000078Lbl894: Label '$';
        "Monto_Sujeto_a_RetenciónCaptionLbl894": Label 'Base retencion por alicuota';
        EmptyStringCaption_Control1000000077Lbl894: Label '$';
        "Mínimo_No_imponibleCaptionLbl894": Label 'Mínimo Escala';
        EmptyStringCaption_Control1000000076Lbl894: Label '$';
        "MONTO_DE_LA_RETENCIÓNCaptionLbl894": Label 'MONTO DE LA RETENCIÓN';
        "AlícuotaCaptionLbl894": Label 'Alícuota';
        Pagos_anterioresCaptionLbl894: Label 'Pagos anteriores';
        EmptyStringCaption_Control1000000075Lbl894: Label '$';
        Pago_de_la_fechaCaptionLbl894: Label 'Pago de la fecha';
        EmptyStringCaption_Control1000000074Lbl894: Label '$';
        TotalCaptionLbl894: Label 'Total';
        "DATOS_DE_LA_RETENCIÓN_PRACTICADACaptionLbl894": Label 'DATOS DE LA RETENCIÓN PRACTICADA';
        EmptyStringCaption_Control1102201001Lbl894: Label '-';
        EmptyStringCaption_Control1102201005Lbl894: Label '(';
        EmptyStringCaption_Control1102201006Lbl894: Label ')';
        EmptyStringCaption_Control1102201007Lbl894: Label '-';
        Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl894: Label 'Declaro que los datos consignados en este certificado son correctos y completos, y';
        que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl894: Label 'que he confeccionado la presente sin omitir ni falsear dato alguno que deba ';
        "FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl894": Label 'FIRMA DEL AGENTE DE RETENCIÓN';
        EmptyStringCaption_Control1000000006Lbl894: Label '____________________________________';
        EmptyStringCaption_Control1000000007Lbl894: Label '(';
        EmptyStringCaption_Control1000000008Lbl894: Label ')';
        Pago_en_concepto_de___CaptionLbl894: Label 'Pago en concepto de:  ';
        EmptyStringCaption_Control1000000018Lbl894: Label '-';
        "ACLARACIÓN_CARGOCaptionLbl894": Label 'ACLARACIÓN/CARGO';
        EmptyStringCaption_Control1000000072Lbl894: Label '$';
        EmptyStringCaption_Control1000000073Lbl894: Label '$';
        EmptyStringCaption_Control1100240000Lbl894: Label '-';
        Tipo_CompCaptionLbl894: Label 'Tipo Comp';
        Base_ImponibleCaptionLbl894: Label 'Base Imponible';
        EmptyStringCaption_Control1000000009Lbl894: Label '-';
        Nro__ComprobanteCaptionLbl894: Label 'Nro. Comprobante';
        EmptyStringCaption_Control1000000022Lbl894: Label '$';
        EmptyStringCaption_Control1000000023Lbl894: Label '$';
        EmptyStringCaption_Control1000000049Lbl894: Label '-';
        TOTAL_IMPONIBLECaptionLbl894: Label 'TOTAL IMPONIBLE';
        MontoFijo894: Decimal;
        gProvincia894: Text[50];
        RecProvincia894: Record GMAProvince;
        direccionProveedor894: Text[250];
        direccionEmpresa894: Text[250];
        maestroPais894: Record "Country/Region";
        DocumentDate: Date;




        InfoEmpresa896: Record "Dimension Value";
        Proveedor896: Record Vendor;
        ok896: Boolean;
        Descripcion896: Text[100];
        DetRetencion896: Record "GMAWithholding Datail";
        Escala896: Record "GMAWithholding Scale";
        alicuota896: Decimal;
        minimo896: Decimal;
        Provincia896: Record GMAProvince;
        Retenciones896: Codeunit GMARetenciones;
        retencion896: Record "GMAWithholding Calculation";
        Acumulado896: Decimal;
        movfac896: Record "Vendor Ledger Entry";
        vbase896: Decimal;
        "Withholding Kind Line896": Record "GMAWithholding Kind Line";
        CERTIFICADO_DE_RETENCION_IVACaptionLbl896: Label 'CERTIFICADO DE RETENCION IVA';
        AGENTE_DE_RETENCIONCaptionLbl896: Label 'AGENTE DE RETENCION';
        "DirecciónCaptionLbl896": Label 'Dirección';
        Nro__de_CUITCaptionLbl896: Label 'Nro. de CUIT';
        "Agente_RetenciónCaptionLbl896": Label 'Agente Retención';
        "JurisdicciónCaptionLbl896": Label 'Jurisdicción';
        Nro__de_IIBBCaptionLbl896: Label 'Nro. de IIBB';
        Nro__de_CUITCaption_Control1000000018Lbl896: Label 'Nro. de CUIT';
        "DirecciónCaption_Control1000000021Lbl896": Label 'Dirección';
        SUJETO_DE_RETENCIONCaptionLbl896: Label 'SUJETO DE RETENCION';
        Certificado_N_CaptionLbl896: Label 'Certificado Nº';
        FechaCaptionLbl896: Label 'Fecha';
        "JurisdicciónCaption_Control1000000016Lbl896": Label 'Jurisdicción';
        RETENCIONCaptionLbl896: Label 'RETENCION';
        B__IMPONIBLECaptionLbl896: Label 'B. IMPONIBLE';
        ALICUOTACaptionLbl896: Label 'ALICUOTA';
        MINIMOCaptionLbl896: Label 'MINIMO';
        RETENIDOCaptionLbl896: Label 'RETENIDO';
        EmptyStringCaptionLbl896: Label '*';
        EmptyStringCaption_Control1000000041Lbl896: Label '*';
        EmptyStringCaption_Control1000000042Lbl896: Label '-';
        EmptyStringCaption_Control1000000046Lbl896: Label '-';
        REGIMEN_N_CaptionLbl896: Label 'REGIMEN Nº';
        "Firma_del_Agente_de_RetenciónCaptionLbl896": Label 'Firma del Agente de Retención';
        "Aclaración_CaptionLbl896": Label 'Aclaración:';
        Cargo_CaptionLbl896: Label 'Cargo:';
        ReferenciaCaptionLbl896: Label 'Referencia';
        "Cod__RetenciónCaptionLbl896": Label 'Cod. Retención';
        ImponibleCaptionLbl896: Label 'Imponible';
        EmptyStringCaption_Control1000000047Lbl896: Label '-';
        Nro__FacturaCaptionLbl896: Label 'Nro. Factura';
        "Declaración_en_la_que_se_informará_la_retencion__CaptionLbl896": Label 'Declaración en la que se informará la retencion :';
        EmptyStringCaption_Control1000000049Lbl896: Label '*';
        gProvincia896: Text[50];
        direccionProveedor896: Text[250];
        direccionEmpresa896: Text[250];
        maestroPais896: Record "Country/Region";
        "GMATreasury Setup896": Record "GMATreasury Setup";


        InfoEmpresa897: Record "Dimension Value";
        "GMATreasury Setup897": Record "GMATreasury Setup";
        Proveedor897: Record Vendor;
        ok897: Boolean;
        Descripcion897: Text[100];
        DetRetencion897: Record "GMAWithholding Datail";
        Escala897: Record "GMAWithholding Scale";
        alicuota897: Decimal;
        minimo897: Decimal;
        Provincia897: Record GMAProvince;
        Retenciones897: Codeunit GMARetenciones;
        retencion897: Record "GMAWithholding Calculation";
        Acumulado897: Decimal;
        movfac897: Record "Vendor Ledger Entry";
        "Withholding Kind Line897": Record "GMAWithholding Kind Line";
        CERTIFICADO_DE_RETENCION_SUSSCaptionLbl897: Label 'CERTIFICADO DE RETENCION SUSS';
        AGENTE_DE_RETENCIONCaptionLbl897: Label 'AGENTE DE RETENCION';
        Direcci_nCaptionLbl897: Label 'Dirección';
        Nro__de_CUITCaptionLbl897: Label 'Nro. de CUIT';
        Agente_Retenci_nCaptionLbl897: Label 'Agente Retención';
        Juridisdicci_nCaptionLbl897: Label 'jurisdicción';
        Nro__de_IIBBCaptionLbl897: Label 'Nro. de IIBB';
        Nro__de_CUITCaption_Control1000000018Lbl897: Label 'Nro. de CUIT';
        Direcci_nCaption_Control1000000021Lbl897: Label 'Dirección';
        SUJETO_DE_RETENCIONCaptionLbl897: Label 'SUJETO DE RETENCION';
        Certificado_N_CaptionLbl897: Label 'Certificado Nº';
        FechaCaptionLbl897: Label 'Fecha';
        Jurisdicci_nCaptionLbl897: Label 'Jurisdicción';
        RETENCIONCaptionLbl897: Label 'RETENCION';
        B__IMPONIBLECaptionLbl897: Label 'B. IMPONIBLE';
        ALICUOTACaptionLbl897: Label 'ALICUOTA';
        MINIMOCaptionLbl897: Label 'MINIMO';
        RETENIDOCaptionLbl897: Label 'RETENIDO';
        EmptyStringCaptionLbl897: Label '*';
        EmptyStringCaption_Control1000000041Lbl897: Label '*';
        EmptyStringCaption_Control1000000042Lbl897: Label '-';
        EmptyStringCaption_Control1000000046Lbl897: Label '-';
        ReferenciaCaptionLbl897: Label 'Referencia';
        Cod__Retenci_nCaptionLbl897: Label 'Cod. Retención';
        Base_ImponibleCaptionLbl897: Label 'Base Imponible';
        EmptyStringCaption_Control1000000047Lbl897: Label '-';
        Nro__FacturaCaptionLbl897: Label 'Nro. Factura';
        Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl897: Label 'Declaración en la que se informará la retencion :';
        EmptyStringCaption_Control1000000049Lbl897: Label '*';
        gProvincia897: Text[50];
        direccionProveedor897: Text[250];
        direccionEmpresa897: Text[250];
        maestroPais897: Record "Country/Region";
        Retencion_TaxSystem897: Code[10];
        "FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl897": Label 'FIRMA DEL AGENTE DE RETENCIÓN';
        Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl897: Label 'Declaro que los datos consignados en este certificado son correctos y completos, y';
        que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl897: Label 'que he confeccionado la presente sin omitir ni falsear dato alguno que deba ';
        "ACLARACIÓN_CARGOCaptionLbl897": Label 'ACLARACIÓN/CARGO';
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        TempRetencionesProcesadas: Record "GMAWithholding Ledger Entry" temporary;
        FechaReporte: date;

    procedure "#InicializaVariables"();
    begin
        SimboloMonedaVoucherVoucherAnterior := '';
        SimboloMonedaValueValueAnterior := '';
        FlagVoucher := 0;
        FlagValue := 0;
    end;

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
        LinComprobanteOP.SETFILTER("GMADocument Type", '<>%1', LinComprobanteOP."GMADocument Type"::"Credit Memo");
        if LinComprobanteOP.FindSet() then
            repeat

                Dec_BaseDocu := 0;
                Dec_ImporteMov := 0;
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

    procedure FindApplicCreditMemo(DocNum: Code[20]; PPOV: Record "GMAPosted Payment Ord Vouch") ImporteNC: Decimal;
    var
        LclMovProv: Record "Vendor Ledger Entry";
    begin
        LclMovProv.SETRANGE(LclMovProv."Document No.", DocNum);     // PARA ORDEN DE PAGA YA QUE EL DOCUMENTO NO ESTA PENDIENTE
        LclMovProv.SETRANGE(LclMovProv.Open, false);
        if (LclMovProv.FINDFIRST) then
            ImporteNC := FindAppliNC(LclMovProv."Entry No.", LclMovProv."Vendor No.", PPOV);
    end;

    procedure FindAppliNC(EntryNum: Integer; Prov: Code[20]; PPOV: Record "GMAPosted Payment Ord Vouch") ImporteNC: Decimal;
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
                    recPCMH.SETRANGE("Pay-to Vendor No.", PPOV.GMAVendor);
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

    procedure printWitholding(WLE: Record "GMAWithholding Ledger Entry") ReturnValue: Boolean;
    var
    begin
        if TempRetencionesProcesadas.GET(WLE."GMANo.") then BEGIN
            ReturnValue := true;
        end
        else begin
            TempRetencionesProcesadas.INIT;
            TempRetencionesProcesadas."GMANo." := WLE."GMANo.";
            TempRetencionesProcesadas.INSERT;
        end;
    end;
}

