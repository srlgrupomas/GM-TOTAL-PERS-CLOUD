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
report 80890 "PersPayment Order"
{
    Caption = 'PersPayment Order';
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107485 - Payment Order.rdl';
    dataset
    {
        dataitem("Hist Cab OPago"; "GMLocPosted Payment Order")
        {
            RequestFilterFields = "GMLocPayment O. No.", "GMLocExternal Document No.";
            column(FIRMA_SOLICITANTECaption; FIRMA_SOLICITANTECaptionLbl) { }
            column(FIRMA_GERENTE_FINANCIEROCaption; FIRMA_GERENTE_FINANCIEROCaptionLbl) { }
            column(GMLocPictureSign; "GMLocTreasury Setup".GMLocSignPicture) { }
            column(FIRMA_GERENTE_GENERALCaption; FIRMA_GERENTE_GENERALCaptionLbl) { }
            column(Hist_Cab_OPago_Payment_O__No_; "GMLocPayment O. No.") { }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                    column(Hist_Cab_OPago_Nombre; "Hist Cab OPago".GMLocName) { }
                    column(Hist_Cab_OPago_Domicilio; "Hist Cab OPago".GMLocAddress) { }
                    column(Proveedor__Post_Code_; Proveedor."Post Code") { }
                    column(Proveedor_City; Proveedor.City) { }
                    column(Proveedor_County; Proveedor.County) { }
                    column(Proveedor_Phone; Proveedor."Phone No.") { }
                    column(Proveedor_Fax; Proveedor."Fax No.") { }
                    column(Hist_Cab_OPago__Hist_Cab_OPago___Fecha_de_O__Pago_; FechaReporte) { }
                    column(Hist_Cab_OPago_LocARCUIT; "Hist Cab OPago".GMLocCUIT) { }
                    column(Hist_Cab_OPago__Hist_Cab_OPago___Nro_Proveedor_; "Hist Cab OPago"."GMLocVendor No.") { }
                    column(Proveedor__No__ingresos_brutos_; Proveedor."GMLocGross Income Tax No") { }
                    column(InfoEmpresa__Phone_No__; InfoEmpresa.BssiBillingPhoneNumber) { }
                    column(InfoEmpresa__E_Mail_; InfoEmpresa.BssiEmail) { }
                    column(InfoEmpresa__Post_Code_; InfoEmpresa.BssiBillingZipCode) { }
                    column(gProvincia______InfoEmpresa__Country_Region_Code_; gProvincia + ', ' + InfoEmpresa.BssiBillingCountry) { }
                    column(InfoEmpresa_LocARAddress; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa.BssiBillingZipCode + ', ' + InfoEmpresa.BssiBillingCity + ', ' + InfoEmpresa.BssiBillingCountry + ', ' + RecPais.Name)//InfoEmpresa."Country/Region Code")
                    {
                    }
                    column(InfoEmpresa_Fax; '') { }
                    column(Hist_Cab_OPago__Hist_Cab_OPago___Nro_O_Pago_; "Hist Cab OPago"."GMLocPayment O. No.") { }
                    column(InfoEmpresa_LocARName; InfoEmpresa.BssiLegalNameFull) { }
                    column(OutputNo; OutputNo) { }
                    column(Hist_Cab_OPago_Usuario; "Hist Cab OPago"."GMLocUser Id") { }
                    column(InfoEmpresa_Picture; InfoEmpresa.BssiPicture) { }
                    column(Hist_Cab_OPago___Create_OP_User_; "Hist Cab OPago"."GMLocCreate OP User") { }
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
                    dataitem("GMLocPosted Payment Ord Vouch"; "GMLocPosted Payment Ord Vouch")
                    {
                        DataItemLink = "GMLocPayment Order No." = FIELD("GMLocPayment O. No.");
                        DataItemLinkReference = "Hist Cab OPago";
                        DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.");
                        MaxIteration = 0;
                        column(Hist_Cab_OPago___En_concepto_de_; "Hist Cab OPago"."GMLocBy way of") { }
                        column(NumFacProveedor; NumFacProveedor) { }
                        column(Hist_Lin_Comp_OPago_Fecha; DocumentDate) { }
                        column(Hist_Lin_Comp_OPago_Importe; GMLocAmount) { }
                        column(Valordivisa; Valordivisa) { }
                        column(Hist_Lin_Comp_OPago_Cancelado; GMLocCancelled) { }
                        column(Importepesos; Importepesos) { }
                        column(CodProyecto; CodProyecto) { }
                        column(txtSaldoCuentaC; txtSaldoCuentaC) { }
                        column(txtSaldoSi; txtSaldoSi) { }
                        column(NombreObra; NombreObra) { }
                        column(Hist_Lin_Comp_OPago_Importe_Control1000000027; GMLocAmount) { }
                        column(Hist_Lin_Comp_OPago_Cancelado_Control1000000028; GMLocCancelled) { }
                        column(Totalpesos; Totalpesos) { }
                        column(DATOS_DE_FACTURAS_O_N__DEBITOSCaption; DATOS_DE_FACTURAS_O_N__DEBITOSCaptionLbl) { }
                        column(ComprobanteCaption; ComprobanteCaptionLbl) { }
                        column(Hist_Lin_Comp_OPago_FechaCaption; FIELDCAPTION(GMLocDate)) { }
                        column(Hist_Lin_Comp_OPago_ImporteCaption; FIELDCAPTION(GMLocAmount)) { }
                        column(DivisaCaption; DivisaCaptionLbl) { }
                        column(Su_PagoCaption; Su_PagoCaptionLbl) { }
                        column(En_PesosCaption; En_PesosCaptionLbl) { }
                        column(EN_CONCEPTO_DECaption; EN_CONCEPTO_DECaptionLbl) { }
                        column(Job_NoCaption; Job_NoCaptionLbl) { }
                        column(T_O_T_A_L_E_S_Caption; T_O_T_A_L_E_S_CaptionLbl) { }
                        column(EmptyStringCaption; EmptyStringCaptionLbl) { }
                        column(Posted_Payment_Order_Vouchers_Payment_Order_No_; "GMLocPayment Order No.") { }
                        column(Posted_Payment_Order_Vouchers_Voucher_No_; "GMLocVoucher No.") { }
                        column(Posted_Payment_Order_Vouchers_Entry_No_; "GMLocEntry No.") { }
                        column(Facturas_Total; Facturas."Amount Including VAT") { }
                        column(TipoDocumento; TipoDocumento) { }
                        column(SimboloMonedaVoucher; SimboloMonedaVoucher) { }
                        column(FlagVoucher; FlagVoucher) { }
                        trigger OnAfterGetRecord();
                        begin
                            //   if "GMLocCurrency Code" <> '' then
                            //   CambioMoneda.GET("GMLocCurrency Code", GMLocDate);

                            if "GMLocPosted Payment Ord Vouch"."GMLocCurrency Code" = '' then
                                Valordivisa := 'PESO ARG'
                            else
                                Valordivisa := "GMLocPosted Payment Ord Vouch"."GMLocCurrency Code";

                            if "GMLocCurrency Code" <> '' then //"GMLocExchange Rate" <> 0 then
                                Importepesos := "GMLocTo be Cancelled (LCY)" //* CambioMoneda."Relational Exch. Rate Amount" // "GMLocExchange Rate"
                            else
                                Importepesos := GMLocCancelled;

                            Totalpesos := Totalpesos + Importepesos;

                            if Facturas.GET("GMLocPosted Payment Ord Vouch"."GMLocVoucher No.") then
                                IF (Facturas."Vendor Invoice No." = '') THEN
                                    NumFacProveedor := "GMLocPosted Payment Ord Vouch"."GMLocVoucher No."
                                else
                                    NumFacProveedor := Facturas."Vendor Invoice No."
                            else begin
                                RecPurchCRMemoInv2.RESET;
                                if RecPurchCRMemoInv2.GET("GMLocPosted Payment Ord Vouch"."GMLocVoucher No.") then
                                    IF (Facturas."Vendor Invoice No." = '') THEN
                                        NumFacProveedor := "GMLocPosted Payment Ord Vouch"."GMLocVoucher No."
                                    else
                                        NumFacProveedor := RecPurchCRMemoInv2."Vendor Cr. Memo No."
                                else
                                    //CMD(21/05/14)Pongo en nro externo en la linea de la op
                                    if "GMLocPosted Payment Ord Vouch"."GMLocDocument No" <> '' then
                                        NumFacProveedor := "GMLocPosted Payment Ord Vouch"."GMLocDocument No"
                                    else
                                        if ("GMLocPosted Payment Ord Vouch"."GMLocAmount (LCY)" <> 0) then
                                            NumFacProveedor := 'PAGO A CUENTA';
                            end;
                            DocumentDate := Facturas."Document Date";
                            if ("GMLocPosted Payment Ord Vouch"."GMLocDocument Type" = "GMLocPosted Payment Ord Vouch"."GMLocDocument Type"::Payment) then
                                NumFacProveedor := "GMLocPosted Payment Ord Vouch"."GMLocVoucher No.";
                            //Busco Proyecto en Los Distintos documentos--
                            CLEAR(CodProyecto);
                            Encontro := false;
                            case "GMLocDocument Type" of
                                "GMLocDocument Type"::Invoice:
                                    begin
                                        RecPurchHeaderInv.RESET;
                                        RecPurchHeaderInv.SETCURRENTKEY("No.");
                                        RecPurchHeaderInv.SETRANGE("No.", "GMLocVoucher No.");
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
                                "GMLocDocument Type"::"Credit Memo":
                                    begin
                                        RecPurchCRMemoInv.RESET;
                                        RecPurchCRMemoInv.SETCURRENTKEY("No.");
                                        RecPurchCRMemoInv.SETRANGE("No.", "GMLocVoucher No.");
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
                                RecPurchHeader.SETRANGE("No.", "GMLocVoucher No.");
                                if RecPurchHeader.FINDFIRST then
                                    CodProyecto := ''
                                else
                                    CodProyecto := '';
                            end;
                            //Busco Proyecto en Los Distintos documentos++
                            //NAVAR1.06002-
                            if not "Calc&ShowLin" then begin
                                AuxRecHistLinCOP.RESET;
                                AuxRecHistLinCOP.SETCURRENTKEY("GMLocPayment Order No.", "GMLocVoucher No.", "GMLocEntry No.");
                                AuxRecHistLinCOP.SETRANGE("GMLocPayment Order No.", "Hist Cab OPago"."GMLocPayment O. No.");
                                if AuxRecHistLinCOP.FINDSET then
                                    repeat
                                        if AuxRecHistLinCOP."GMLocExchange Rate" <> 0 then
                                            AuxImportePesos := AuxRecHistLinCOP."GMLocTo be Cancelled (LCY)"
                                        else
                                            AuxImportePesos := AuxRecHistLinCOP.GMLocCancelled;

                                        AuxTotalPesos += AuxImportePesos;
                                    until AuxRecHistLinCOP.NEXT = 0;
                                CLEAR(TotalConfirmadoCuenta);
                                txtSaldoCuentaC := Text001 + ' ' + FORMAT(TODAY) + ' $' + FORMAT(CuentaC, 0, '<Sign><Integer Thousand><Decimals,3>');
                                TotalConfirmadoCuenta := CuentaC - AuxTotalPesos;
                                txtSaldoSi := Text002 + ' $' + FORMAT(TotalConfirmadoCuenta, 0, '<Sign><Integer Thousand><Decimals,3>');
                                "Calc&ShowLin" := true;
                            end;

                            if "GMLocPosted Payment Ord Vouch"."GMLocDocument Type" = "GMLocPosted Payment Ord Vouch"."GMLocDocument Type"::" " then
                                TipoDocumento := '';
                            if "GMLocPosted Payment Ord Vouch"."GMLocDocument Type" = "GMLocPosted Payment Ord Vouch"."GMLocDocument Type"::Payment then
                                TipoDocumento := 'OP';
                            if "GMLocPosted Payment Ord Vouch"."GMLocDocument Type" = "GMLocPosted Payment Ord Vouch"."GMLocDocument Type"::Invoice then
                                TipoDocumento := 'FC';
                            if "GMLocPosted Payment Ord Vouch"."GMLocDocument Type" = "GMLocPosted Payment Ord Vouch"."GMLocDocument Type"::"Credit Memo" then
                                TipoDocumento := 'NC';
                            if "GMLocPosted Payment Ord Vouch"."GMLocDocument Type" = "GMLocPosted Payment Ord Vouch"."GMLocDocument Type"::"Nota Débito" then
                                TipoDocumento := 'ND';
                            if "GMLocPosted Payment Ord Vouch"."GMLocDocument Type" = "GMLocPosted Payment Ord Vouch"."GMLocDocument Type"::Recibo then
                                TipoDocumento := 'RC';

                            if "GMLocPosted Payment Ord Vouch"."GMLocCurrency Code" = '' then
                                SimboloMonedaVoucher := '$'
                            else begin
                                VoucherMoneda.GET("GMLocPosted Payment Ord Vouch"."GMLocCurrency Code");
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
                                Convierto.FormatNoText(NumberText, ROUND("GMLocPosted Payment Ord Vouch".GMLocAmount, 0.01),
                                "GMLocPosted Payment Ord Vouch"."GMLocCurrency Code");
                                end
                             else begin
                                Convierto.FormatNoText(NumberText, ROUND("GMLocPosted Payment Ord Vouch".GMLocAmount, 0.01),
                                '');
                            end;


                            if "GMLocPosted Payment Order Valu"."GMLocCurrency Code" <> '' then begin
                                ok := Moneda.GET("GMLocPosted Payment Order Valu"."GMLocCurrency Code");
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
                    dataitem("GMLocPosted Payment Order Valu"; "GMLocPosted Payment Order Valu")
                    {
                        DataItemLink = "GMLocPayment Order No." = FIELD("GMLocPayment O. No.");
                        DataItemLinkReference = "Hist Cab OPago";
                        DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocLine No.");
                        column(Hist_Lin_Valor_OPago__N__Valor_; "GMLocValue No.") { }
                        column(Valores_Descripcion; Valores.GMLocDescription) { }
                        column(Hist_Lin_Valor_OPago_Entidad; GMLocEntity) { }
                        column(Hist_Lin_Valor_OPago__A_Fecha_; "GMLocTo Date") { }
                        column(Hist_Lin_Valor_OPago_Importe; GMLocAmount) { }
                        column(Valordivisa_Control1000000044; Valordivisa) { }
                        column(Importepesos_Control1000000046; Importepesos) { }
                        column(ImportepesosSum; ImportepesosSum) { }
                        column(Hist_Lin_Valor_OPago_ImporteSum; Hist_Lin_Valor_OPago_ImporteSum) { }
                        column(Hist_Lin_Valor_OPago_Caja; "GMLocCash/Bank") { }
                        column(Hist_Lin_Valor_OPago_Importe_Control1000000048; GMLocAmount) { }
                        column(Totalpesos_Control1000000053; Totalpesos) { }
                        column(N_meroCaption; N_meroCaptionLbl) { }
                        column(S_E_G_U_N___D_E_T_A_L_L_E_Caption; S_E_G_U_N___D_E_T_A_L_L_E_CaptionLbl) { }
                        column(ValorCaption; ValorCaptionLbl) { }
                        column(Hist_Lin_Valor_OPago_EntidadCaption; FIELDCAPTION(GMLocEntity)) { }
                        column(Hist_Lin_Valor_OPago__A_Fecha_Caption; FIELDCAPTION("GMLocTo Date")) { }
                        column(Hist_Lin_Valor_OPago_ImporteCaption; FIELDCAPTION(GMLocAmount)) { }
                        column(DivisaCaption_Control1000000045; DivisaCaption_Control1000000045Lbl) { }
                        column(En_PesosCaption_Control1000000047; En_PesosCaption_Control1000000047Lbl) { }
                        column(CajaCaption; CajaCaptionLbl) { }
                        column(EmptyStringCaption_Control1000000034; EmptyStringCaption_Control1000000034Lbl) { }
                        column(T_O_T_A_L_E_S_Caption_Control1000000035; T_O_T_A_L_E_S_Caption_Control1000000035Lbl) { }
                        column(Posted_Payment_Order_Values_Payment_Order_No_; "GMLocPayment Order No.") { }
                        column(Posted_Payment_Order_Values_Line_No_; "GMLocLine No.") { }
                        column(Banco_Nombre; Banco.GMLocDescription) { }
                        column(Banco_Sucursal; BankMaster."Bank Branch No.") { }
                        column(SimboloMonedaValue; SimboloMonedaValue) { }
                        column(FlagValue; FlagValue) { }

                        //Reporte de IIBB
                        dataitem(GMLocWithholdingLedgerEntry; "GMLocWithholding Ledger Entry")
                        {
                            DataItemLink = "GMLocVoucher Number" = field("GMLocPayment Order No."), "GMLocWithholding No." = field("GMLocWithholding No.");
                            DataItemLinkReference = "GMLocPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMLocNo.");

                            //RequestFilterFields = "GMLocNo.";
                            RequestFilterFields = "GMLocWithh. Certificate No.";
                            column(InfoEmpresa_Name; DimensionValue.BssiLegalNameFull) { }
                            column(ValueType; ValueType) { }
                            column(GMLocWithholdingNo; "GMLocWithholding No.") { }
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
                            column(Proveedor__No__ingresos_brutos_2; Proveedor."GMLocGross Income Tax No") { }
                            column(Proveedor__VAT_Registration_No__; Proveedor."VAT Registration No.") { }
                            column(Proveedor_Address; direccionProveedor) { }
                            column(Proveedor_Name; Proveedor.Name) { }
                            column(Movimiento_Retenciones__N__Certificado_Retencion_; "GMLocWithh. Certificate No.") { }
                            column(Movimiento_Retenciones__Fecha_comprobante_; "GMLocVoucher Date") { }
                            column(Provincia__Descripci_n_; DimensionValue.BssiProvinceCode) { }
                            column(DetRetencion_Titulo; DetRetencion.GMLocTitle) { }
                            column(Text1; Text1) { }
                            column(Text2; Text2) { }
                            column(Tipo_fiscal__Description; "Tipo fiscal".GMLocDescription) { }
                            column(Descripcion; Descripcion) { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_; "GMLocCalculation Base") { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_; "GMLocWithholding Amount") { }
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
                            column(Withholding_Ledger_Entry_No_; "GMLocNo.") { }
                            column(Withholding_Ledger_Entry_Voucher_Number; "GMLocVoucher Number") { }
                            column(GMLocPictureSign2; "GMLocTreasury Setup".GMLocSignPicture) { }
                            dataitem("Posted Payment Order Vouchers"; "GMLocPosted Payment Ord Vouch")
                            {
                                DataItemLink = "GMLocPayment Order No." = FIELD("GMLocVoucher Number");
                                DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.") ORDER(Ascending);
                                column(Movimiento_Retenciones__Valor; GMLocWithholdingLedgerEntry.GMLocValue) { }
                                column(Acumulado; Acumulado) { }
                                column(Hist_Lin_Comp_OPago__Nro_Comprobante_; "GMLocVoucher No.") { }
                                column(movfac__External_Document_No__; movfac."External Document No.") { }
                                column(tipocomp; tipocomp) { }
                                column(Hist_Lin_Comp_OPago__Nro_O_Pago_; "GMLocPayment Order No.") { }
                                column("Movimiento_Retenciones__NombreRetención"; GMLocWithholdingLedgerEntry.GMLocWithholdingName) { }
                                column(Movimiento_Retenciones__Valor_Control1000000056; GMLocWithholdingLedgerEntry.GMLocValue) { }
                                column(Movimiento_Retenciones___Base_de_calculo_; GMLocWithholdingLedgerEntry."GMLocCalculation Base") { }
                                column(alicuota_Control1000000066; alicuota) { }
                                column(Movimiento_Retenciones___Importe_retencion_; GMLocWithholdingLedgerEntry."GMLocWithholding Amount") { }
                                column(Movimiento_Retenciones___Base_de_calculo__Control1000000068; GMLocWithholdingLedgerEntry."GMLocCalculation Base") { }
                                column(InfoEmpresa_Picture2; DimensionValue.BssiPicture) { }
                                column(ReferenciaCaption; ReferenciaCaptionLbl) { }
                                column(Cod__Retenci_nCaption; Cod__Retenci_nCaptionLbl) { }
                                column(Base_ImponibleCaption; Base_ImponibleCaptionLbl) { }
                                column(EmptyStringCaption_Control1000000047; EmptyStringCaption_Control1000000047Lbl) { }
                                column(Nro__FacturaCaption; Nro__FacturaCaptionLbl) { }
                                column(Tipo_CompCaption; Tipo_CompCaptionLbl) { }
                                column(Hist_Lin_Comp_OPago__Nro_O_Pago_Caption; FIELDCAPTION("GMLocPayment Order No.")) { }
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
                                column(Posted_Payment_Order_Vouchers_Entry_No_2; "GMLocEntry No.") { }

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
                                                Comportamiento.SETRANGE(Comportamiento."GMLocTax System", GMLocWithholdingLedgerEntry."GMLocTax System");
                                                Comportamiento.SETRANGE(Comportamiento."GMLocWithholding No.", GMLocWithholdingLedgerEntry."GMLocWithholding No.");//NAVAR1.06
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
                                        if (HOPago."GMLocNew Payment") then begin
                                            alicuota := GMLocWithholdingLedgerEntry."GMLocWithholding%";
                                            Acumulado := "Posted Payment Order Vouchers"."GMLocTo be Cancelled (LCY)";
                                        end;

                                    //AcumTotal := AcumTotal + Acumulado;

                                    GMLocWithholdingLedgerEntry."GMLocCalculation Base" := ROUND(GMLocWithholdingLedgerEntry."GMLocCalculation Base");
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
                                IF (printWitholding(GMLocWithholdingLedgerEntry)) then
                                    CurrReport.sKIP;


                                if (COPYSTR(GMLocWithholdingLedgerEntry."GMLocTax Code", 1, 2) = 'IB') then begin
                                    Text1 := 'JURISDICCION:';
                                    if (prov.GET(GMLocWithholdingLedgerEntry."GMLocProvince Code")) then
                                        Text2 := prov.GMLocDescription;


                                end;


                                gblProvincia := '';
                                DetRetencion.RESET;
                                DetRetencion.SETCURRENTKEY("GMLocWithholding No.", "GMLocTax Code", "GMLocTax System");
                                DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", GMLocWithholdingLedgerEntry."GMLocWithholding No.");
                                if DetRetencion.FINDFIRST then
                                    Descripcion := DetRetencion.GMLocDescription;

                                Escala.RESET;
                                Escala.SETCURRENTKEY("GMLocScale Code", "GMLocWithholding Condition", "GMLocTax Code", GMLocFrom);
                                Escala.SETRANGE(Escala."GMLocScale Code", GMLocWithholdingLedgerEntry."GMLocScale Code");
                                Escala.SETRANGE(Escala."GMLocWithholding Condition", GMLocWithholdingLedgerEntry."GMLocCondition Code");
                                Escala.SETRANGE(Escala."GMLocTax Code", GMLocWithholdingLedgerEntry."GMLocTax Code");
                                if Escala.FINDFIRST then
                                    repeat
                                        if (Escala.GMLocFrom <= GMLocWithholdingLedgerEntry."GMLocCalculation Base") then begin
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
                                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocWithholding Code", GMLocWithholdingLedgerEntry."GMLocWithholding Code");
                                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocTax Code", GMLocWithholdingLedgerEntry."GMLocTax Code");
                                "Withholding Kind Line".SETRANGE("Withholding Kind Line"."GMLocIs vendor withholding", true);
                                if ("Withholding Kind Line".FINDFIRST) then begin
                                    if (GMLocWithholdingLedgerEntry."Vendor withholding" <> '') then begin
                                        Proveedor.RESET;
                                        Proveedor.SETCURRENTKEY("No.");
                                        Proveedor.SETRANGE("No.", GMLocWithholdingLedgerEntry."Vendor withholding");
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

                                DimensionValue.Reset();
                                DimensionValue.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                                DimensionValue.SetFilter(Code, GMLocWithholdingLedgerEntry."GMLocShortcut Dimension 1");
                                IF (DimensionValue.FindFirst()) THEN;
                                DimensionValue.CALCFIELDS(DimensionValue.BssiPicture);
                                DimensionValue.CALCFIELDS(BssiPicture);

                                RecProvincia.RESET;
                                RecProvincia.SETCURRENTKEY(RecProvincia."GMLocProvince Code");
                                RecProvincia.SETRANGE("GMLocProvince Code", DimensionValue.BssiProvinceCode);
                                if RecProvincia.FINDFIRST then
                                    gProvincia := RecProvincia.GMLocDescription;

                                if (DimensionValue.BssiBillingAddr1 <> '') then direccionEmpresa := DimensionValue.BssiBillingAddr1;
                                if (DimensionValue.BssiBillingCity <> '') then direccionEmpresa := direccionEmpresa + ',  ' + DimensionValue.BssiBillingCity;
                                if (DimensionValue."BssiBillingZipCode" <> '') then direccionEmpresa := direccionEmpresa + ', C.P. ' + DimensionValue.BssiBillingZipCode;
                                if (DimensionValue.BssiBillingCountry <> '') then begin
                                    maestroPais.Reset();
                                    maestroPais.SetFilter(Code, DimensionValue.BssiBillingCountry);
                                    if maestroPais.FindFirst() then direccionEmpresa := direccionEmpresa + ', ' + maestroPais.Name;
                                end;

                                //NAVAR1.06001+
                                if ("Tipo fiscal".GET(Proveedor."GMLocFiscal Type")) then;
                            end;


                            trigger OnPreDataItem()
                            var
                                MovRet: record "GMLocWithholding Ledger Entry";
                                Valores2: record GMLocValues;

                            begin
                                ValueType := 0;
                                "GMLocTreasury Setup".GET();
                                "GMLocTreasury Setup".CALCFIELDS(GMLocSignPicture);
                                Valores2.Reset();
                                Valores2.GET("GMLocPosted Payment Order Valu".GMLocValue);
                                if Valores2."GMLocReport ID" = 80895 then
                                    ValueType := 1
                                else
                                    CurrReport.Skip();
                                GMLocWithholdingLedgerEntry.SETRANGE(GMLocWithholdingLedgerEntry.GMLocValue, Valores2.GMLocCode);
                                if GMLocWithholdingLedgerEntry.FINDFIRST then;
                            end;

                        }



                        //Reporte de Ganancias
                        dataitem("Movimiento Retenciones"; "GMLocWithholding Ledger Entry")
                        {
                            DataItemLink = "GMLocVoucher Number" = field("GMLocPayment Order No."), "GMLocWithholding No." = field("GMLocWithholding No.");
                            DataItemLinkReference = "GMLocPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMLocNo.");
                            //RequestFilterFields = "GMLocNo.";
                            RequestFilterFields = "GMLocWithh. Certificate No.";
                            column(Descripcion894; Descripcion894) { }
                            column(ValueType2; ValueType) { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_894; "Movimiento Retenciones"."GMLocCalculation Base") { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_894; "Movimiento Retenciones"."GMLocWithholding Amount") { }
                            column(alicuota894; alicuota894) { }
                            column(minimo894; minimo894) { }
                            column(Movimiento_Retenciones_No_894; "GMLocNo.") { }
                            column(Movimiento_Retenciones_Voucher_Number894; "GMLocVoucher Number") { }

                            column(GMLocPictureSign894; "GMLocTreasury Setup 894".GMLocSignPicture) { }
                            dataitem(Copia; "Integer")
                            {
                                DataItemTableView = SORTING(Number);
                                column(DetRetencion_Titulo894; DetRetencion894.GMLocTitle) { }
                                column(InfoEmpresa_Name894; InfoEmpresa894.BssiLegalNameFull) { }
                                column(InfoEmpresa_Picture_hdr894; InfoEmpresa894.BssiPicture) { }
                                column(InfoEmpresa_LocARAddress894; InfoEmpresa894.BssiBillingAddr1 + ', ' + InfoEmpresa894.BssiBillingZipCode + ', ' + InfoEmpresa894.BssiBillingCity + ', ' + gProvincia894 + ', ' + InfoEmpresa894.BssiBillingCountry) { }
                                column(InfoEmpresa__Phone_No__894; InfoEmpresa894.BssiBillingPhoneNumber) { }
                                column(InfoEmpresa__E_Mail_894; InfoEmpresa894.BssiEmail) { }
                                column(InfoEmpresa__Home_Page_894; '') { }
                                column(InfoEmpresa_Address_______InfoEmpresa_City____C_P____InfoEmpresa__Post_Code_894; direccionEmpresa894) { }
                                column(InfoEmpresa__Address_2_894; InfoEmpresa894.BssiBillingAddress2) { }
                                column(InfoEmpresa__VAT_Registration_No__894; InfoEmpresa894.BssiRegistrationNo) { }
                                column(Proveedor__No_ingresos_brutos_894; Proveedor894."GMLocGross Income Tax No") { }
                                column(Proveedor__VAT_Registration_No__894; Proveedor894."VAT Registration No.") { }
                                column(Proveedor_Address_______Proveedor_City____C_P____Proveedor__Post_Code________Proveedor__Address_2_894; direccionProveedor894) { }
                                column(Proveedor_Name894; Proveedor894.Name) { }
                                column(Movimiento_Retenciones___Nro_Certificado_Retencion_894; "Movimiento Retenciones"."GMLocWithh. Certificate No.") { }
                                column(Movimiento_Retenciones___Fecha_comprobante_894; "Movimiento Retenciones"."GMLocVoucher Date") { }
                                column(Tipo_fiscal__Description894; "Tipo fiscal894".GMLocDescription) { }

                                column(Movimiento_Retenciones___Numero_comprobante_894; "Movimiento Retenciones"."GMLocVoucher Number") { }
                                column(tipoCond894; tipoCond894) { }
                                column(DetRetencion__Agente_de_Retencion_894; DetRetencion894."GMLocWithholding Agent") { }
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
                                    column(Movimiento_Retenciones___Importe_retencion_894; "Movimiento Retenciones"."GMLocWithholding Amount") { }
                                    column(decRetenAnt894; decRetenAnt894) { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100894; decRetenAnt894 + "Movimiento Retenciones"."GMLocWithholding Amount") { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp__alicuota_100_2894; "Movimiento Retenciones"."GMLocWithholding Amount") { }
                                    column(FORMAT_alicuota______894; FORMAT(ROUND(alicuota894)) + ' %') { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt_decMinimoNoImp894; "Movimiento Retenciones".GMLocBase + decPagosAnt894 - decMinimoNoImp894) { }
                                    column(decMinimoNoImp894; decMinimoNoImp894) { }
                                    column(Movimiento_Retenciones__Base_decPagosAnt894; "Movimiento Retenciones".GMLocBase + decPagosAnt894) { }
                                    column(decPagosAnt894; decPagosAnt894) { }
                                    column(MontoFijo894; MontoFijo894) { }
                                    column(Movimiento_Retenciones__Base894; "Movimiento Retenciones".GMLocBase) { }
                                    column("Régimen__________DetRetencion_Regimen__________DetRetencion_Descripcion894"; 'Régimen' + '  ' + DetRetencion894."GMLocTax System" + ' - ' + DetRetencion894.GMLocDescription) { }
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

                                    dataitem("Posted Payment Order Vouchers894"; "GMLocPosted Payment Ord Vouch")
                                    {
                                        DataItemLink = "GMLocPayment Order No." = FIELD("GMLocVoucher Number");
                                        DataItemLinkReference = "Movimiento Retenciones";
                                        DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.") ORDER(Ascending);
                                        column(tipocomp894; tipocomp894) { }
                                        column(TOTAL894; TOTAL894) { }
                                        column(movfac__External_Document_No__894; movfac894."External Document No.") { }
                                        column(AcumTotal894; AcumTotal894) { }
                                        column(Tipo_CompCaption894; Tipo_CompCaptionLbl894) { }
                                        column(Base_ImponibleCaption894; Base_ImponibleCaptionLbl894) { }
                                        column(Movimiento_Retenciones__Valor894; "Movimiento Retenciones".GMLocValue) { }
                                        column(EmptyStringCaption_Control1000000009894; EmptyStringCaption_Control1000000009Lbl894) { }
                                        column(Nro__ComprobanteCaption894; Nro__ComprobanteCaptionLbl894) { }
                                        column(EmptyStringCaption_Control1000000022894; EmptyStringCaption_Control1000000022Lbl894) { }
                                        column(EmptyStringCaption_Control1000000023894; EmptyStringCaption_Control1000000023Lbl894) { }
                                        column(EmptyStringCaption_Control1000000049894; EmptyStringCaption_Control1000000049Lbl894) { }
                                        column(TOTAL_IMPONIBLECaption894; TOTAL_IMPONIBLECaptionLbl894) { }
                                        column(Posted_Payment_Order_Vouchers_Payment_Order_No_894; "GMLocPayment Order No.") { }
                                        column(Posted_Payment_Order_Vouchers_Voucher_No_894; "GMLocVoucher No.") { }
                                        column(Posted_Payment_Order_Vouchers_Entry_No_894; "GMLocEntry No.") { }

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

                                            ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion

                                            Acumulado894 := 0;
                                            if ("Posted Payment Order Vouchers894"."GMLocDocument Type" = "Posted Payment Order Vouchers894"."GMLocDocument Type"::Invoice) or
                                              ("Posted Payment Order Vouchers894"."GMLocDocument Type" = "Posted Payment Order Vouchers894"."GMLocDocument Type"::"Nota Débito") then begin
                                                Facturas.RESET;
                                                Facturas.SETRANGE(Facturas."No.", "Posted Payment Order Vouchers894"."GMLocVoucher No.");
                                                if Facturas.FindSet() then begin
                                                    Facturas.CALCFIELDS("Amount Including VAT");
                                                    //Calculo porcentaje del pago sobre el total de la factura
                                                    if Facturas."Currency Factor" <> 0 then
                                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                                                    else
                                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / Facturas."Amount Including VAT");
                                                    if ("Posted Payment Order Vouchers894".GMLocCrMemoAppliedExists) then
                                                        PorcMonto := 100;

                                                    LineasFactura.RESET;
                                                    LineasFactura.SETRANGE("Document No.", "Posted Payment Order Vouchers894"."GMLocVoucher No.");
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
                                                                        CondImpuesto.SETRANGE(CondImpuesto."GMLocVendor Code", "Posted Payment Order Vouchers894".GMLocVendor);
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
                                                                                            Acumulado894 := ((PorcMonto * (LineasFactura."VAT Base Amount" / Facturas."Currency Factor")) / 100) +
                                                                                                                     Acumulado894
                                                                                        else
                                                                                            Acumulado894 := ((PorcMonto * LineasFactura."VAT Base Amount") / 100) +
                                                                                                                Acumulado894;

                                                                                    DetRetencion."GMLocWithholding Base Type"::"Importe Impuestos":
                                                                                        if Facturas."Currency Factor" <> 0 then
                                                                                            Acumulado894 := ((PorcMonto * ((LineasFactura."Amount Including VAT" / Facturas."Currency Factor")
                                                                                                                - (LineasFactura."VAT Base Amount" / Facturas."Currency Factor"))) / 100) +
                                                                                                                   Acumulado894
                                                                                        else
                                                                                            Acumulado894 := ((PorcMonto * (LineasFactura."Amount Including VAT"
                                                                                                                 - LineasFactura."VAT Base Amount")) / 100) + Acumulado894;

                                                                                    DetRetencion."GMLocWithholding Base Type"::"Importe Total":
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
                                            if ("Posted Payment Order Vouchers894"."GMLocDocument Type" = "Posted Payment Order Vouchers894"."GMLocDocument Type"::"Credit Memo") then begin
                                                Facturas2.RESET;
                                                Facturas2.SETRANGE("No.", "Posted Payment Order Vouchers894"."GMLocVoucher No.");
                                                if Facturas2.FindSet() then begin
                                                    Facturas2.CALCFIELDS("Amount Including VAT");
                                                    //Calculo porcentaje del pago sobre el total de la factura
                                                    if Facturas2."Currency Factor" <> 0 then
                                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / (Facturas2."Amount Including VAT" / Facturas2."Currency Factor"))
                                                    else
                                                        PorcMonto := (("GMLocAmount (LCY)" * 100) / Facturas2."Amount Including VAT");

                                                    LineasFactura2.RESET;
                                                    LineasFactura2.SETRANGE("Document No.", "Posted Payment Order Vouchers894"."GMLocVoucher No.");
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
                                                                        CondImpuesto.SETRANGE(CondImpuesto."GMLocVendor Code", "Posted Payment Order Vouchers894".GMLocVendor);
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
                                                                                            Acumulado894 -= ((PorcMonto * (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor")) / 100)

                                                                                        else
                                                                                            Acumulado894 -= ((PorcMonto * LineasFactura2."VAT Base Amount") / 100);

                                                                                    DetRetencion."GMLocWithholding Base Type"::"Importe Impuestos":
                                                                                        if Facturas2."Currency Factor" <> 0 then
                                                                                            Acumulado894 -= ((PorcMonto * ((LineasFactura2."Amount Including VAT" / Facturas2."Currency Factor")
                                                                                                                - (LineasFactura2."VAT Base Amount" / Facturas2."Currency Factor"))) / 100)
                                                                                        else
                                                                                            Acumulado894 -= ((PorcMonto * (LineasFactura2."Amount Including VAT"
                                                                                                                 - LineasFactura2."VAT Base Amount")) / 100);

                                                                                    DetRetencion."GMLocWithholding Base Type"::"Importe Total":
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
                                            movfac894.SETRANGE(movfac894."Document No.", "Posted Payment Order Vouchers894"."GMLocVoucher No.");
                                            ok894 := movfac894.FindSet();

                                            //NAVAR1.06002-
                                            CLEAR(ImporteNC894);
                                            tipocomp894 := '';
                                            if (movfac894."Document Type" = movfac894."Document Type"::Invoice) then begin
                                                tipocomp894 := 'FC';
                                                ImporteNC894 := FindApplicCreditMemo("Posted Payment Order Vouchers894"."GMLocVoucher No.", "Posted Payment Order Vouchers894");
                                            end;

                                            if (movfac894."Document Type" = movfac894."Document Type"::"Credit Memo") then
                                                tipocomp894 := 'NC';

                                            if (movfac894."Document Type" = movfac894."GMLocDocument Type Loc."::"Nota Débito") then
                                                tipocomp894 := 'ND';

                                            if (movfac894."Document Type" = movfac894."Document Type"::"Credit Memo") then
                                                Acumulado894 := -Acumulado894;

                                            Acumulado894 := ROUND(Acumulado894, 0.01);

                                            CLEAR(TOTAL894);

                                            if (HOPago894."GMLocNew Payment") then
                                                Acumulado894 := "Posted Payment Order Vouchers894"."GMLocTo be Cancelled (LCY)";

                                            AcumTotal894 := AcumTotal894 + Acumulado894;

                                            if ("Posted Payment Order Vouchers894".GMLocCrMemoAppliedExists) then
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
                                HLinCompPago: Record "GMLocPosted Payment Ord Vouch";
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
                                DetRetencion894.SETRANGE(DetRetencion894."GMLocWithholding No.", "Movimiento Retenciones"."GMLocWithholding No.");
                                if DetRetencion894.FindSet() then
                                    Descripcion894 := DetRetencion894.GMLocDescription;

                                //GMDataScale MC +
                                //Se deben sacar estos datos del historico de retenciones, no de la escala, esta puede cambiar.
                                //Dejo para retenciones ya generadas

                                if ("Movimiento Retenciones".GMLocFrom = 0) and ("Movimiento Retenciones"."GMLocFixed Amount" = 0) and ("Movimiento Retenciones"."GMLocBase Amount" = 0) then begin
                                    Escala894.RESET;
                                    Escala894.SETRANGE(Escala894."GMLocScale Code", "Movimiento Retenciones"."GMLocScale Code");
                                    Escala894.SETRANGE(Escala894."GMLocWithholding Condition", "Movimiento Retenciones"."GMLocCondition Code");
                                    Escala894.SETRANGE(Escala894."GMLocTax Code", "Movimiento Retenciones"."GMLocTax Code");
                                    if Escala894.FindSet() then
                                        repeat
                                            if (Escala894.GMLocFrom <= "Movimiento Retenciones"."GMLocCalculation Base") then begin
                                                alicuota894 := Escala894."GMLocExcedent %";
                                                minimo894 := Escala894.GMLocFrom;
                                                MontoFijo894 := Escala894."GMLocFixed Amount";
                                                decMinimoNoImp894 := Escala894."GMLocBase Amount";
                                            end;
                                        until Escala894.NEXT = 0;
                                end
                                else begin
                                    alicuota894 := "Movimiento Retenciones"."GMLocWithholding%";
                                    minimo894 := "Movimiento Retenciones".GMLocFrom;
                                    MontoFijo894 := "Movimiento Retenciones"."GMLocFixed Amount";
                                    decMinimoNoImp894 := "Movimiento Retenciones"."GMLocBase Amount";
                                end;
                                //GMDataScale MC -


                                //11807+
                                "Withholding Kind Line894".RESET;
                                "Withholding Kind Line894".SETRANGE("Withholding Kind Line894"."GMLocWithholding Code", "GMLocWithholding Code");
                                "Withholding Kind Line894".SETRANGE("Withholding Kind Line894"."GMLocTax Code", "GMLocTax Code");
                                "Withholding Kind Line894".SETRANGE("Withholding Kind Line894"."GMLocIs vendor withholding", true);
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
                                        Proveedor894.SETRANGE("No.", "GMLocVendor Code");
                                        if Proveedor894.FINDFIRST then;
                                    end;
                                end
                                else begin
                                    Proveedor894.RESET;
                                    Proveedor894.SETCURRENTKEY("No.");
                                    Proveedor894.SETRANGE("No.", "GMLocVendor Code");
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

                                if "Tipo fiscal894".Get(Proveedor894."GMLocFiscal Type") then;

                                //Proveedor.GET("Movimiento Retenciones"."GMLocVendor Code"); //11807

                                HOPago894.GET("Movimiento Retenciones"."GMLocVoucher Number");
                                HOPago894.CALCFIELDS("GMLocPaid Amount (LCY)");
                                HLinCompPago.SETRANGE("GMLocPayment Order No.", HOPago894."GMLocPayment O. No.");
                                HLinCompPago.FindFirst();
                                for i := 1 to 60 do
                                    txtNroComprobantes894[i] := ' ';
                                i := 1;
                                repeat
                                    Contador894 += 1;
                                    if MovProveedor.GET(HLinCompPago."GMLocEntry No.") then begin
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

                                Dia := FORMAT(DATE2DMY("Movimiento Retenciones"."GMLocWithholding Date", 1));
                                Anio := FORMAT(DATE2DMY("Movimiento Retenciones"."GMLocWithholding Date", 3));
                                Mes := FORMAT("Movimiento Retenciones"."GMLocWithholding Date", 0, '<Month Text>');
                                txtLugarYFecha894 := 'Buenos Aires, ' + Dia + ' de ' + Mes + ' de ' + Anio + '.';
                                txtDeclaracion894 := 'La presente retención se informará en la DDJJ correspondiente al mes de ' + Mes + ' del año ' + Anio + '.';

                                if (HOPago894."GMLocNew Payment") then begin
                                    "Hist Lin Valor OPago894".SETRANGE("GMLocPayment Order No.", HOPago894."GMLocPayment O. No."); // "Posted Payment Order Vouchers"."Payment Order No."
                                    "Hist Lin Valor OPago894".SETRANGE("Hist Lin Valor OPago894".GMLocValue, "Movimiento Retenciones".GMLocValue);
                                    "Hist Lin Valor OPago894".SETRANGE("Hist Lin Valor OPago894"."GMLocWithholding No.", "Movimiento Retenciones"."GMLocWithholding No.");
                                    if ("Hist Lin Valor OPago894".FINDFIRST()) then begin
                                        //IF("Hist Lin Valor OPago"."Pagos Anteriores" <> 0)THEN
                                        decPagosAnt894 := "Hist Lin Valor OPago894"."GMLocPrevious Payments";
                                        // IF("Hist Lin Valor OPago"."Retenciones Anteriores" <> 0)THEN
                                        decRetenAnt894 := "Hist Lin Valor OPago894"."GMLocPrevious Withholdings";
                                    end;
                                end;
                                if (alicuota894 = 0) then
                                    if ("Movimiento Retenciones"."GMLocWithholding%" <> 0) then
                                        alicuota894 := "Movimiento Retenciones"."GMLocWithholding%"
                                    else begin
                                        if ("Movimiento Retenciones"."GMLocCalculation Base" <> 0) and ("Movimiento Retenciones"."GMLocWithholding Amount" <> 0) then
                                            alicuota894 := ("Movimiento Retenciones"."GMLocWithholding Amount" /
                                            ("Movimiento Retenciones"."GMLocCalculation Base" + decPagosAnt894 - decMinimoNoImp894)) * 100;
                                    end;


                                InfoEmpresa894.Reset();
                                InfoEmpresa894.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                                InfoEmpresa894.SetFilter(Code, "Movimiento Retenciones"."GMLocShortcut Dimension 1");
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
                                RecProvincia894.SETCURRENTKEY(RecProvincia894."GMLocProvince Code");
                                RecProvincia894.SETRANGE("GMLocProvince Code", InfoEmpresa894.BssiProvinceCode);
                                if RecProvincia894.FINDFIRST then
                                    gProvincia894 := RecProvincia894.GMLocDescription;

                            end;

                            trigger OnPreDataItem();
                            var
                                Valores3: record GMLocValues;
                            begin

                                "GMLocTreasury Setup 894".GET();
                                "GMLocTreasury Setup 894".CALCFIELDS(GMLocSignPicture);
                                ValueType := 0;
                                Valores3.Reset();
                                Valores3.GET("GMLocPosted Payment Order Valu".GMLocValue);
                                if Valores3."GMLocReport ID" = 80894 then
                                    ValueType := 2
                                else
                                    CurrReport.Skip();
                                "Movimiento Retenciones".SETRANGE("Movimiento Retenciones".GMLocValue, Valores3.GMLocCode);
                                if "Movimiento Retenciones".FINDFIRST then;

                            end;

                        }


                        //REporte de IVA
                        dataitem(WithholdingLedgerEntry896; "GMLocWithholding Ledger Entry")
                        {
                            DataItemLink = "GMLocVoucher Number" = field("GMLocPayment Order No."), "GMLocWithholding No." = field("GMLocWithholding No.");
                            DataItemLinkReference = "GMLocPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMLocNo.");
                            //RequestFilterFields = "GMLocNo.";
                            RequestFilterFields = "GMLocWithh. Certificate No.";

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
                            column(Proveedor__No_ingresos_brutos_896; Proveedor896."GMLocGross Income Tax No") { }
                            column(Proveedor__VAT_Registration_No__896; Proveedor896."VAT Registration No.") { }
                            column("Proveedor_Address_______Proveedor_City_______Proveedor__Cód__Provincia_896"; direccionProveedor896) { }
                            column(Proveedor_Name896; Proveedor896.Name) { }
                            column(Movimiento_Retenciones__Withholding_Certification_No__896; "GMLocWithh. Certificate No.") { }
                            column(Movimiento_Retenciones__Fecha_comprobante_896; FORMAT("GMLocVoucher Date", 10, '<Day,2>/<Month,2>/<Year4>')) { }
                            column("Provincia_Descripción896"; Provincia896.GMLocDescription) { }
                            column(Descripcion896; Descripcion896) { }
                            column(FORMAT_vbase_896; '$ ' + FORMAT(vbase896)) { }
                            column(FORMAT__Movimiento_Retenciones___Importe_retencion__896; '$ ' + FORMAT(WithholdingLedgerEntry896."GMLocWithholding Amount")) { }
                            column(FORMAT_alicuota______896; FORMAT(alicuota896) + ' %') { }
                            column(minimo896; minimo896) { }
                            column(Movimiento_Retenciones_Regimen896; "GMLocTax System") { }
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
                            column(Withholding_Ledger_Entry_No_896; "GMLocNo.") { }
                            column(Withholding_Ledger_Entry_Voucher_Number896; "GMLocVoucher Number") { }
                            // AW - Begin
                            column(Withholding_Ledger_Entry_GMLocCalculation_Base896; WithholdingLedgerEntry896."GMLocCalculation Base") { }
                            // AW - End
                            column(GMLocPictureSign896; "GMLocTreasury Setup896".GMLocSignPicture) { }
                            dataitem("GMLocPosted Payment Order Vouchers"; "GMLocPosted Payment Ord Vouch")
                            {
                                DataItemLink = "GMLocPayment Order No." = FIELD("GMLocVoucher Number");
                                DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.") ORDER(Ascending);
                                column(Movimiento_Retenciones__Valor896; WithholdingLedgerEntry896.GMLocValue) { }
                                column(FORMAT_Acumulado_896; '$ ' + FORMAT(Acumulado896)) { }
                                column(Hist_Lin_Comp_OPago__Nro_Comprobante_896; "GMLocPosted Payment Order Vouchers"."GMLocVoucher No.") { }
                                column(movfac__External_Document_No__896; movfac896."External Document No.") { }
                                column(ReferenciaCaption896; ReferenciaCaptionLbl896) { }
                                column("Cod__RetenciónCaption896"; Cod__RetenciónCaptionLbl896) { }
                                column(ImponibleCaption896; ImponibleCaptionLbl896) { }
                                column(EmptyStringCaption_Control1000000047896; EmptyStringCaption_Control1000000047Lbl896) { }
                                column(Nro__FacturaCaption896; Nro__FacturaCaptionLbl896) { }
                                column("Declaración_en_la_que_se_informará_la_retencion__Caption896"; Declaración_en_la_que_se_informará_la_retencion__CaptionLbl896) { }
                                column(EmptyStringCaption_Control1000000049896; EmptyStringCaption_Control1000000049Lbl896) { }
                                column(Posted_Payment_Order_Vouchers_Payment_Order_No_896; "GMLocPayment Order No.") { }
                                column(Posted_Payment_Order_Vouchers_Entry_No_896; "GMLocEntry No.") { }

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
                                    Acumulado896 := 0;
                                    ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                                    movfac896.RESET;
                                    movfac896.SETRANGE(movfac896."Document No.", "GMLocPosted Payment Order Vouchers"."GMLocVoucher No.");
                                    if movfac896.FindSet() then begin
                                        movfac896.CALCFIELDS("Original Amt. (LCY)");
                                        Acumulado896 := -movfac896."Original Amt. (LCY)";

                                        DetRetencion.RESET;
                                        DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", WithholdingLedgerEntry896."GMLocWithholding No.");
                                        if DetRetencion.FindSet() then;

                                    end;

                                    Acumulado896 := 0;
                                    LineasFactura.RESET;
                                    LineasFactura.SETCURRENTKEY("Document No.", "Line No.");
                                    LineasFactura.SETRANGE("Document No.", "GMLocPosted Payment Order Vouchers"."GMLocVoucher No.");
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
                                DetRetencion896.SETRANGE(DetRetencion896."GMLocWithholding No.", WithholdingLedgerEntry896."GMLocWithholding No.");
                                if DetRetencion896.FindSet() then
                                    Descripcion896 := DetRetencion896.GMLocDescription;

                                Escala896.RESET;
                                Escala896.SETRANGE(Escala896."GMLocScale Code", WithholdingLedgerEntry896."GMLocScale Code");
                                Escala896.SETRANGE(Escala896."GMLocWithholding Condition", WithholdingLedgerEntry896."GMLocCondition Code");
                                Escala896.SETRANGE(Escala896."GMLocTax Code", WithholdingLedgerEntry896."GMLocTax Code");
                                if Escala896.FindSet() then
                                    repeat
                                        if (Escala896.GMLocFrom <= WithholdingLedgerEntry896."GMLocCalculation Base") then begin
                                            alicuota896 := Escala896."GMLocExcedent %";
                                            minimo896 := Escala896.GMLocFrom;
                                        end;
                                    until Escala896.NEXT = 0;
                                //11807+
                                "Withholding Kind Line896".RESET;
                                "Withholding Kind Line896".SETRANGE("Withholding Kind Line896"."GMLocWithholding Code", WithholdingLedgerEntry896."GMLocWithholding Code");
                                "Withholding Kind Line896".SETRANGE("Withholding Kind Line896"."GMLocTax Code", WithholdingLedgerEntry896."GMLocTax Code");
                                "Withholding Kind Line896".SETRANGE("Withholding Kind Line896"."GMLocIs vendor withholding", true);
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
                                        Proveedor896.SETRANGE("No.", "GMLocVendor Code");
                                        if Proveedor896.FINDFIRST then;
                                    end;
                                end
                                else begin
                                    Proveedor896.RESET;
                                    Proveedor896.SETCURRENTKEY("No.");
                                    Proveedor896.SETRANGE("No.", "GMLocVendor Code");
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
                                InfoEmpresa896.SetFilter(Code, WithholdingLedgerEntry896."GMLocShortcut Dimension 1");
                                IF (InfoEmpresa896.FindFirst()) THEN;
                                InfoEmpresa896.CALCFIELDS(InfoEmpresa896.BssiPicture);
                                Provincia896.RESET;
                                Provincia896.SETCURRENTKEY(Provincia896."GMLocProvince Code");
                                Provincia896.SETRANGE("GMLocProvince Code", InfoEmpresa896.BssiProvinceCode);
                                if Provincia896.FINDFIRST then
                                    gProvincia896 := Provincia896.GMLocDescription;
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
                                Valores2: record GMLocValues;
                            begin
                                ok896 := InfoEmpresa896.FindSet();
                                "GMLocTreasury Setup896".GET();
                                "GMLocTreasury Setup896".CALCFIELDS(GMLocSignPicture);
                                ValueType := 0;
                                Valores2.Reset();
                                Valores2.GET("GMLocPosted Payment Order Valu".GMLocValue);
                                if Valores2."GMLocReport ID" = 80896 then
                                    ValueType := 3
                                else
                                    CurrReport.Skip();
                                WithholdingLedgerEntry896.SETRANGE(WithholdingLedgerEntry896.GMLocValue, Valores2.GMLocCode);
                                if WithholdingLedgerEntry896.FINDFIRST then;

                            end;
                        }



                        //Reporte SUSS
                        dataitem(GMLocWithholdingLedgerEntry897; "GMLocWithholding Ledger Entry")
                        {
                            DataItemLink = "GMLocVoucher Number" = field("GMLocPayment Order No."), "GMLocWithholding No." = field("GMLocWithholding No.");
                            DataItemLinkReference = "GMLocPosted Payment Order Valu";
                            DataItemTableView = SORTING("GMLocNo.")
                                                        WHERE("GMLocTax Code" = const('SUSS'));
                            //RequestFilterFields = "GMLocNo.";
                            RequestFilterFields = "GMLocWithh. Certificate No.";
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
                            column(Proveedor__No__ingresos_brutos_897; Proveedor897."GMLocGross Income Tax No") { }
                            column(Proveedor__VAT_Registration_No__897; Proveedor897."VAT Registration No.") { }
                            column(Proveedor_Address897; direccionProveedor897) { }
                            column(Proveedor_Name897; Proveedor897.Name) { }
                            column(Movimiento_Retenciones__N__Certificado_Retencion_897; "GMLocWithh. Certificate No.") { }
                            column(Movimiento_Retenciones__Fecha_comprobante_897; "GMLocVoucher Date") { }
                            column(Provincia__Descripci_n_897; InfoEmpresa897.BssiProvinceCode) { }
                            column(Descripcion897; Descripcion897) { }
                            column(Retencion_TaxSystem897; Retencion_TaxSystem897) { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Base_de_calculo_897; GMLocWithholdingLedgerEntry897."GMLocCalculation Base") { }
                            column(Movimiento_Retenciones__Movimiento_Retenciones___Importe_retencion_897; GMLocWithholdingLedgerEntry897."GMLocWithholding Amount") { }
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
                            column(Withholding_Ledger_Entry_No_897; "GMLocNo.") { }
                            column(Withholding_Ledger_Entry_Voucher_Number897; "GMLocVoucher Number") { }
                            column("FIRMA_DEL_AGENTE_DE_RETENCIÓNCaption897"; FIRMA_DEL_AGENTE_DE_RETENCIÓNCaptionLbl897) { }
                            column(Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaption897; Declaro_que_los_datos_consignados_en_este_certificado_son_correctos_y_completos__yCaptionLbl897) { }
                            column(que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_Caption897; que_he_confeccionado_la_presente_sin_omitir_ni_falsear_dato_alguno_que_deba_CaptionLbl897) { }
                            column(InfoEmpresa_Picture2897; InfoEmpresa897.BssiPicture) { }
                            column("ACLARACIÓN_CARGOCaption897"; ACLARACIÓN_CARGOCaptionLbl897) { }
                            column(GMLocPictureSign897; "GMLocTreasury Setup897".GMLocSignPicture) { }
                            dataitem("GMLocPosted Payment Ord Vouch897"; "GMLocPosted Payment Ord Vouch")
                            {
                                DataItemLink = "GMLocPayment Order No." = FIELD("GMLocVoucher Number");
                                DataItemTableView = SORTING("GMLocPayment Order No.", "GMLocVoucher No.") ORDER(Ascending);
                                column(Movimiento_Retenciones__Valor897; GMLocWithholdingLedgerEntry897.GMLocValue) { }
                                column(Acumulado897; Acumulado897) { }
                                column(tipocomp897; tipocomp897) { }
                                column(Hist_Lin_Comp_OPago__Nro_Comprobante_897; "GMLocVoucher No.") { }
                                column(movfac__External_Document_No__897; movfac897."External Document No.") { }
                                column(ReferenciaCaption897; ReferenciaCaptionLbl897) { }
                                column(Cod__Retenci_nCaption897; Cod__Retenci_nCaptionLbl897) { }
                                column(Base_ImponibleCaption897; Base_ImponibleCaptionLbl897) { }
                                column(EmptyStringCaption_Control1000000047897; EmptyStringCaption_Control1000000047Lbl897) { }
                                column(Nro__FacturaCaption897; Nro__FacturaCaptionLbl897) { }
                                column(Declaraci_n_en_la_que_se_informar__la_retencion__Caption897; Declaraci_n_en_la_que_se_informar__la_retencion__CaptionLbl897) { }
                                column(EmptyStringCaption_Control1000000049897; EmptyStringCaption_Control1000000049Lbl897) { }
                                column(Posted_Payment_Order_Vouchers_Payment_Order_No_897; "GMLocPayment Order No.") { }
                                column(Posted_Payment_Order_Vouchers_Entry_No_897; "GMLocEntry No.") { }

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
                                    Acumulado897 := 0;
                                    ///Doy de alta los tipos de retenciones con el monto de pago correspondiente en la tabla Calculo de Retencion
                                    Facturas.RESET;
                                    Facturas.SETCURRENTKEY("No.");
                                    Facturas.SETRANGE(Facturas."No.", "GMLocPosted Payment Ord Vouch897"."GMLocVoucher No.");
                                    if Facturas.FINDFIRST then begin
                                        Facturas.CALCFIELDS("Amount Including VAT");
                                        //Calculo porcentaje del pago sobre el total de la factura
                                        if Facturas."Currency Factor" <> 0 then
                                            PorcMonto := (("GMLocAmount (LCY)" * 100) / (Facturas."Amount Including VAT" / Facturas."Currency Factor"))
                                        else
                                            PorcMonto := (("GMLocAmount (LCY)" * 100) / Facturas."Amount Including VAT");

                                        LineasFactura.RESET;
                                        LineasFactura.SETCURRENTKEY("Document No.", "Line No.");
                                        LineasFactura.SETRANGE("Document No.", "GMLocPosted Payment Ord Vouch897"."GMLocVoucher No.");
                                        if LineasFactura.FINDFIRST then begin
                                            repeat
                                                Comportamiento.RESET;
                                                Comportamiento.SETCURRENTKEY("GMLocWithholding No.", "GMLocWithholding Code");
                                                Comportamiento.SETRANGE(Comportamiento."GMLocWithholding Code", LineasFactura."GMLocWithholding Code");
                                                Comportamiento.SETRANGE(Comportamiento."GMLocTax System", GMLocWithholdingLedgerEntry897."GMLocTax System");
                                                Comportamiento.SETRANGE(Comportamiento."GMLocWithholding No.", GMLocWithholdingLedgerEntry897."GMLocWithholding No.");//NAVAR1.06
                                                if Comportamiento.FINDFIRST then begin
                                                    DetRetencion.RESET;
                                                    DetRetencion.SETCURRENTKEY("GMLocWithholding No.", "GMLocTax Code", "GMLocTax System");
                                                    DetRetencion.SETRANGE(DetRetencion."GMLocWithholding No.", Comportamiento."GMLocWithholding No.");
                                                    if DetRetencion.FINDFIRST then begin
                                                        ///Control de Valor en Detalle de Retención
                                                        if DetRetencion.GMLocValue = '' then
                                                            ControlValor := false
                                                        else
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
                                                            CondImpuesto.SETRANGE(CondImpuesto."GMLocVendor Code", "GMLocPosted Payment Ord Vouch897".GMLocVendor);
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
                                                                                Acumulado897 := ((PorcMonto * (LineasFactura."VAT Base Amount" / Facturas."Currency Factor")) / 100) +
                                                                                                         Acumulado897
                                                                            else
                                                                                Acumulado897 := ((PorcMonto * LineasFactura."VAT Base Amount") / 100) +
                                                                                                    Acumulado897;

                                                                        DetRetencion."GMLocWithholding Base Type"::"Importe Impuestos":
                                                                            if Facturas."Currency Factor" <> 0 then
                                                                                Acumulado897 := ((PorcMonto * ((LineasFactura."Amount Including VAT" / Facturas."Currency Factor")
                                                                                                    - (LineasFactura."VAT Base Amount" / Facturas."Currency Factor"))) / 100) +
                                                                                                       Acumulado897
                                                                            else
                                                                                Acumulado897 := ((PorcMonto * (LineasFactura."Amount Including VAT"
                                                                                                     - LineasFactura."VAT Base Amount")) / 100) + Acumulado897;

                                                                        DetRetencion."GMLocWithholding Base Type"::"Importe Total":
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
                                    movfac897.SETRANGE(movfac897."Document No.", "GMLocPosted Payment Ord Vouch897"."GMLocVoucher No.");
                                    ok897 := movfac897.FINDFIRST;

                                    tipocomp897 := '';
                                    if (movfac."Document Type" = movfac."Document Type"::Invoice) then begin
                                        tipocomp897 := 'FC';
                                        //ImporteNC := FindApplicCreditMemo("Hist Lin Comp OPago"."Nro Comprobante");
                                    end;
                                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                        tipocomp897 := 'NC';

                                    if (movfac."Document Type" = movfac."GMLocDocument Type Loc."::"Nota Débito") then
                                        tipocomp897 := 'ND';

                                    if (movfac."Document Type" = movfac."Document Type"::"Credit Memo") then
                                        Acumulado897 := -Acumulado;

                                    CLEAR(TOTAL);


                                    if (HOPago.GET("GMLocPosted Payment Ord Vouch897"."GMLocPayment Order No.")) then
                                        if (HOPago."GMLocNew Payment") then
                                            IF ("GMLocPosted Payment Ord Vouch897"."GMLocCurrency Code" <> '') THEN begin
                                                Acumulado897 := "GMLocPosted Payment Ord Vouch897"."GMLocTo be Cancelled (LCY)"
                                            end;



                                    GMLocWithholdingLedgerEntry897."GMLocCalculation Base" := ROUND(GMLocWithholdingLedgerEntry897."GMLocCalculation Base");
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
                                IF (printWitholding(GMLocWithholdingLedgerEntry897)) then
                                    CurrReport.sKIP;
                                DetRetencion897.RESET;
                                DetRetencion897.SETCURRENTKEY("GMLocWithholding No.", "GMLocTax Code", "GMLocTax System");
                                DetRetencion897.SETRANGE(DetRetencion897."GMLocWithholding No.", GMLocWithholdingLedgerEntry897."GMLocWithholding No.");
                                if DetRetencion897.FINDFIRST then
                                    Descripcion897 := DetRetencion897.GMLocDescription;
                                Retencion_TaxSystem897 := DetRetencion897."GMLocTax System";
                                Escala897.RESET;
                                Escala897.SETCURRENTKEY("GMLocScale Code", "GMLocWithholding Condition", "GMLocTax Code", GMLocFrom);
                                Escala897.SETRANGE(Escala897."GMLocScale Code", GMLocWithholdingLedgerEntry897."GMLocScale Code");
                                Escala897.SETRANGE(Escala897."GMLocWithholding Condition", GMLocWithholdingLedgerEntry897."GMLocCondition Code");
                                Escala897.SETRANGE(Escala897."GMLocTax Code", GMLocWithholdingLedgerEntry897."GMLocTax Code");
                                if Escala897.FINDFIRST then
                                    repeat
                                        if (Escala897.GMLocFrom <= GMLocWithholdingLedgerEntry897."GMLocCalculation Base") then begin
                                            alicuota897 := Escala897."GMLocExcedent %";
                                            minimo897 := Escala897.GMLocFrom;
                                        end;
                                    until Escala897.NEXT = 0;


                                //NAVAR1.06001-
                                Provincia897.RESET;
                                Provincia897.SETCURRENTKEY("GMLocProvince Code");
                                Provincia897.SETRANGE("GMLocProvince Code", "GMLocProvince Code");
                                if Provincia897.FINDFIRST then
                                    gProvincia897 := Provincia897.GMLocDescription
                                else
                                    gProvincia897 := '';
                                //11807+
                                "Withholding Kind Line897".RESET;
                                "Withholding Kind Line897".SETRANGE("Withholding Kind Line897"."GMLocWithholding Code", GMLocWithholdingLedgerEntry897."GMLocWithholding Code");
                                "Withholding Kind Line897".SETRANGE("Withholding Kind Line897"."GMLocTax Code", GMLocWithholdingLedgerEntry897."GMLocTax Code");
                                "Withholding Kind Line897".SETRANGE("Withholding Kind Line897"."GMLocIs vendor withholding", true);
                                if ("Withholding Kind Line897".FINDFIRST) then begin
                                    if (GMLocWithholdingLedgerEntry897."Vendor withholding" <> '') then begin
                                        Proveedor897.RESET;
                                        Proveedor897.SETCURRENTKEY("No.");
                                        Proveedor897.SETRANGE("No.", GMLocWithholdingLedgerEntry897."Vendor withholding");
                                        if Proveedor897.FINDFIRST then;
                                    end
                                    else begin
                                        Proveedor897.RESET;
                                        Proveedor897.SETCURRENTKEY("No.");
                                        Proveedor897.SETRANGE("No.", "GMLocVendor Code");
                                        if Proveedor897.FINDFIRST then;
                                    end;
                                end
                                else begin
                                    Proveedor897.RESET;
                                    Proveedor897.SETCURRENTKEY("No.");
                                    Proveedor897.SETRANGE("No.", "GMLocVendor Code");
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
                                InfoEmpresa897.SetFilter(Code, GMLocWithholdingLedgerEntry897."GMLocShortcut Dimension 1");
                                IF (InfoEmpresa897.FindFirst()) THEN;
                                InfoEmpresa897.CALCFIELDS(InfoEmpresa897.BssiPicture);
                                Provincia897.RESET;
                                Provincia897.SETCURRENTKEY(Provincia897."GMLocProvince Code");
                                Provincia897.SETRANGE("GMLocProvince Code", InfoEmpresa897.BssiProvinceCode);
                                if Provincia897.FINDFIRST then
                                    gProvincia897 := Provincia897.GMLocDescription;

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
                                Valores2: record GMLocValues;

                            begin
                                ok897 := InfoEmpresa897.FINDFIRST;
                                "GMLocTreasury Setup897".GET();
                                "GMLocTreasury Setup897".CALCFIELDS(GMLocSignPicture);

                                ValueType := 0;
                                Valores2.Reset();
                                Valores2.GET("GMLocPosted Payment Order Valu".GMLocValue);
                                if Valores2."GMLocReport ID" = 80897 then
                                    ValueType := 4
                                else
                                    CurrReport.Skip();
                                GMLocWithholdingLedgerEntry897.SETRANGE(GMLocWithholdingLedgerEntry897.GMLocValue, Valores2.GMLocCode);
                                if GMLocWithholdingLedgerEntry897.FINDFIRST then;
                            end;
                        }


                        trigger OnAfterGetRecord();
                        begin
                            Valores.GET("GMLocPosted Payment Order Valu".GMLocValue);
                            if "GMLocPosted Payment Order Valu"."GMLocCurrency Code" = '' then
                                Valordivisa := 'PESO ARG'
                            else
                                Valordivisa := "GMLocPosted Payment Order Valu"."GMLocCurrency Code";

                            if "GMLocCurrency Factor" <> 0 then
                                Importepesos := GMLocAmount / "GMLocCurrency Factor"
                            else
                                Importepesos := GMLocAmount;

                            Totalpesos := Totalpesos + Importepesos;
                            Banco.Get("GMLocPosted Payment Order Valu"."GMLocCash/Bank");
                            BankMaster.Reset();
                            BankMaster.Get(Banco."GMLocNav Bank Account Number");

                            if "GMLocPosted Payment Order Valu"."GMLocCurrency Code" = '' then
                                SimboloMonedaValue := '$'
                            else begin
                                ValueMoneda.GET("GMLocPosted Payment Order Valu"."GMLocCurrency Code");
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
                            Hist_Lin_Valor_OPago_ImporteSum += GMLocAmount;
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
                            LinCom: Record "GMLocPosted Payment Ord Vouch";
                            LinVal: Record "GMLocPosted Payment Order Valu";
                            HayDivisa: Boolean;
                        begin
                            LinCom.RESET;
                            LinCom.SETRANGE(LinCom."GMLocPayment Order No.", "Hist Cab OPago"."GMLocPayment O. No.");
                            if LinCom.FindSet() then
                                repeat
                                    if LinCom."GMLocCurrency Code" <> '' then begin
                                        if LinCom."GMLocExchange Rate" <> 0 then
                                            FactorDiv := 1 / LinCom."GMLocExchange Rate"
                                        else
                                            FactorDiv := 0;
                                        Divisa := LinCom."GMLocCurrency Code";
                                        HayDivisa := true;
                                    end;
                                until LinCom.NEXT = 0;
                            LinVal.RESET;
                            LinVal.SETRANGE(LinVal."GMLocPayment Order No.", "Hist Cab OPago"."GMLocPayment O. No.");
                            if LinVal.FindSet() then
                                repeat
                                    if LinVal."GMLocCurrency Code" <> '' then begin
                                        if LinVal."GMLocCurrency Factor" <> 0 then
                                            FactorDiv := 1 / LinVal."GMLocCurrency Factor"
                                        else
                                            FactorDiv := 0;
                                        Divisa := LinVal."GMLocCurrency Code";
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
                FechaReporte := "Hist Cab OPago"."GMLocPayment O. Date";
                if fechaposting = true then
                    FechaReporte := "Hist Cab OPago"."GMLocPosting Date";
                Proveedor.GET("Hist Cab OPago"."GMLocVendor No.");
                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter(Code, BssiMEMEntityID);
                IF (InfoEmpresa.FindFirst()) THEN;
                RecProvincia.RESET;
                RecProvincia.SETCURRENTKEY(RecProvincia."GMLocProvince Code");
                RecProvincia.SETRANGE("GMLocProvince Code", InfoEmpresa.BssiProvinceCode);
                RecPais.RESET;
                RecPais.GET(InfoEmpresa.BssiBillingCountry);
                ValoresRecibidos.RESET;
                ValoresRecibidos.SETRANGE("GMLocPayment Order No.", "Hist Cab OPago"."GMLocPayment O. No.");
                Clear(ImpTotalValor);
                Clear(ImpTotalValorDolar);
                CLEAR(ImpTotalValorBanco);
                Clear(MonedaVoucher);
                EsDolar := false;

                if ValoresRecibidos.FindFirst then
                    repeat
                        IF (banco.get(ValoresRecibidos."GMLocCash/Bank")) THEN
                            IF (banco.GMLocType = banco.GMLocType::Banco) THEN
                                ImpTotalValorBanco += ValoresRecibidos."GMLocAmount (LCY)";
                        ImpTotalValor := ImpTotalValor + ValoresRecibidos."GMLocAmount (LCY)";
                        if ValoresRecibidos."GMLocCurrency Code" <> '' then begin
                            ImpTotalValorFuncional := ImpTotalValorFuncional + ValoresRecibidos."GMLocAmount (LCY)";
                            ImpTotalValorDolar := ImpTotalValorDolar + ValoresRecibidos.GMLocAmount;
                        end;
                    until ValoresRecibidos.Next = 0;

                VoucherAplicado.RESET;
                VoucherAplicado.SETRANGE("GMLocPayment Order No.", "Hist Cab OPago"."GMLocPayment O. No.");
                if VoucherAplicado.FindFirst then
                    repeat
                        if VoucherAplicado."GMLocCurrency Code" <> '' then begin
                            //CambioMoneda.Get(VoucherAplicado."GMLocCurrency Code", VoucherAplicado.GMLocDate);
                            ImpTotalValorFuncionalVoucher := ImpTotalValorFuncionalVoucher + VoucherAplicado."GMLocAmount (LCY)";//  VoucherAplicado.GMLocAmount * CambioMoneda."Relational Exch. Rate Amount";
                            ImpTotalValorDolarVoucher := ImpTotalValorDolarVoucher + VoucherAplicado.GMLocAmount;
                            EsDolar := true;
                            MonedaVoucher := VoucherAplicado."GMLocCurrency Code"
                        end;
                        //DDS15082025 se agrego el aprobador 
                        IF (UserAprovalName = '') THEN begin
                            Postedaproval.Reset();
                            Postedaproval.SetRange("Document No.", VoucherAplicado."GMLocVoucher No.");

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
                                IF (VoucherAplicado."GMLocDocument Type" = VoucherAplicado."GMLocDocument Type"::"Credit Memo") THEN begin
                                    purchcrmemoline.Reset();
                                    purchcrmemoline.SetRange("Document No.", VoucherAplicado."GMLocVoucher No.");
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
                                    purchaseinvline.SetRange("Document No.", VoucherAplicado."GMLocVoucher No.");
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
                  CambioMoneda.SETRANGE("Starting Date", "Hist Cab OPago"."GMLocPayment O. Date");*/
                //CambioMoneda.FindLast;

                if ImpTotalValorDolar = ImpTotalValorDolarVoucher then begin
                    DiferenciaDeCambio := ImpTotalValorFuncionalVoucher - ImpTotalValorFuncional;
                end
                else begin
                    //  DiferenciaDeCambio := (ImpTotalValorDolar * CambioMoneda."Relational Exch. Rate Amount") - ImpTotalValorFuncional;
                    DiferenciaDeCambio := ImpTotalValorFuncionalVoucher - ImpTotalValorFuncional;
                end;

                DiferenciaDeCambio := ROUND(DiferenciaDeCambio, 0.01);

                if ValoresRecibidos."GMLocCurrency Code" <> '' then
                    ok := Moneda.GET(ValoresRecibidos."GMLocCurrency Code");
                //Tesoreria.Get();
                if DiferenciaDeCambio < 0 then
                    CuentaDifDeCambio := Moneda."Unrealized Losses Acc."
                else
                    CuentaDifDeCambio := Moneda."Unrealized Gains Acc.";

                Language_Code := 'ESP';
                if Language_Code = 'ENU' then begin
                    Convierto.FormatNoText(NumberText, ROUND(ImpTotalValor, 0.01),
                    "GMLocPosted Payment Ord Vouch"."GMLocCurrency Code");
                end
                else begin

                    Convierto.FormatNoText(NumberTextBanco, ROUND(ImpTotalValorBanco, 0.01), '');
                    Convierto.FormatNoText(NumberText, ROUND(ImpTotalValor, 0.01), '');
                end;

                CLEAR(importeLetrasBanco);
                if "GMLocPosted Payment Order Valu"."GMLocCurrency Code" <> '' then begin
                    ok := Moneda.GET("GMLocPosted Payment Order Valu"."GMLocCurrency Code");
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
                    gProvincia := RecProvincia.GMLocDescription;

                CuentaC := "Hist Cab OPago".GMLocVendorSL;
                "Calc&ShowLin" := false;
                InfoEmpresa.CALCFIELDS(InfoEmpresa.BssiPicture);

                MonedaFuncional.GET();
                SimboloMonedaFuncional := MonedaFuncional."Local Currency Symbol";
            end;

            trigger OnPreDataItem();
            begin

                "GMLocTreasury Setup".GET();
                "GMLocTreasury Setup".CALCFIELDS(GMLocSignPicture);
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
        "GMLocTreasury Setup": Record "GMLocTreasury Setup";
        Proveedor: Record Vendor;
        Valordivisa: Code[10];
        Valores: Record GMLocValues;
        Banco: Record "GMLocCash/Bank Account";
        BankMaster: Record "Bank Account";
        RecPais: Record "Country/Region";
        ValoresRecibidos: Record "GMLocPosted Payment Order Valu";
        VoucherAplicado: Record "GMLocPosted Payment Ord Vouch";
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
        Tesoreria: Record "GMLocTreasury Setup";
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
        Convierto: Codeunit GMLocConvierteNoAText;
        Language_Code: Text[3];
        NumFacProveedor: Code[20];
        InfoEmpresa: Record "Dimension Value";
        InfoEmpresaPO: Record "Dimension Value";
        DivisaTesoreria: Record "GMLocTreasury Currencies";
        ConfEmpresa: Record "General Ledger Setup";
        FactorDiv: Decimal;
        Divisa: Code[20];
        gProvincia: Text[50];
        RecProvincia: Record GMLocProvince;
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
        AuxRecHistLinCOP: Record "GMLocPosted Payment Ord Vouch";
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
        DetRetencion: Record "GMLocWithholding Datail";
        Escala: Record "GMLocWithholding Scale";
        alicuota: Decimal;
        minimo: Decimal;
        Provincia: Record GMLocProvince;
        Retenciones: Codeunit GMLocRetenciones;
        retencion: Record "GMLocWithholding Calculation";
        Acumulado: Decimal;
        movfac: Record "Vendor Ledger Entry";
        //   "GMLocTreasury Setup": Record "GMLocTreasury Setup";
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
        //   RecProvincia: Record GMLocProvince;
        direccionProveedor: Text[250];
        direccionEmpresa: Text[250];
        maestroPais: Record "Country/Region";
        ValueType: Integer;



        "GMLocTreasury Setup 894": Record "GMLocTreasury Setup";
        InfoEmpresa894: Record "Dimension Value";
        Proveedor894: Record Vendor;
        ok894: Boolean;
        Descripcion894: Text[100];
        DetRetencion894: Record "GMLocWithholding Datail";
        Escala894: Record "GMLocWithholding Scale";
        alicuota894: Decimal;
        minimo894: Decimal;
        Provincia894: Record GMLocProvince;
        Retenciones894: Codeunit GMLocRetenciones;
        retencion894: Record "GMLocWithholding Calculation";
        Acumulado894: Decimal;
        movfac894: Record "Vendor Ledger Entry";
        HOPago894: Record "GMLocPosted Payment Order";
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
        Temp_PagosProcesados894: Record "GMLocPosted Payment Order" temporary;
        txtNroC894: array[30] of Text[250];
        Contador894: Integer;
        "Hist Lin Valor OPago894": Record "GMLocPosted Payment Order Valu";
        tipocomp894: Text[30];
        tipocomp897: Text[30];
        DescRet894: Text[250];
        "Tipo fiscal894": Record "GMLocFiscal Type";
        globImpuestos894: Record GMLocTaxes;
        tipoCond894: Text[30];
        AcumTotal894: Decimal;
        VendorLedgerEntry894: Record "Vendor Ledger Entry";
        numero894: Integer;
        ImporteNC894: Decimal;
        TOTAL894: Decimal;
        TOTALNC894: Decimal;
        "Withholding Kind Line894": Record "GMLocWithholding Kind Line";
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
        RecProvincia894: Record GMLocProvince;
        direccionProveedor894: Text[250];
        direccionEmpresa894: Text[250];
        maestroPais894: Record "Country/Region";
        DocumentDate: Date;




        InfoEmpresa896: Record "Dimension Value";
        Proveedor896: Record Vendor;
        ok896: Boolean;
        Descripcion896: Text[100];
        DetRetencion896: Record "GMLocWithholding Datail";
        Escala896: Record "GMLocWithholding Scale";
        alicuota896: Decimal;
        minimo896: Decimal;
        Provincia896: Record GMLocProvince;
        Retenciones896: Codeunit GMLocRetenciones;
        retencion896: Record "GMLocWithholding Calculation";
        Acumulado896: Decimal;
        movfac896: Record "Vendor Ledger Entry";
        vbase896: Decimal;
        "Withholding Kind Line896": Record "GMLocWithholding Kind Line";
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
        "GMLocTreasury Setup896": Record "GMLocTreasury Setup";


        InfoEmpresa897: Record "Dimension Value";
        "GMLocTreasury Setup897": Record "GMLocTreasury Setup";
        Proveedor897: Record Vendor;
        ok897: Boolean;
        Descripcion897: Text[100];
        DetRetencion897: Record "GMLocWithholding Datail";
        Escala897: Record "GMLocWithholding Scale";
        alicuota897: Decimal;
        minimo897: Decimal;
        Provincia897: Record GMLocProvince;
        Retenciones897: Codeunit GMLocRetenciones;
        retencion897: Record "GMLocWithholding Calculation";
        Acumulado897: Decimal;
        movfac897: Record "Vendor Ledger Entry";
        "Withholding Kind Line897": Record "GMLocWithholding Kind Line";
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
        TempRetencionesProcesadas: Record "GMLocWithholding Ledger Entry" temporary;
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
        LinComprobanteOP.SETFILTER("GMLocDocument Type", '<>%1', LinComprobanteOP."GMLocDocument Type"::"Credit Memo");
        if LinComprobanteOP.FindSet() then
            repeat

                Dec_BaseDocu := 0;
                Dec_ImporteMov := 0;
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

    procedure FindApplicCreditMemo(DocNum: Code[20]; PPOV: Record "GMLocPosted Payment Ord Vouch") ImporteNC: Decimal;
    var
        LclMovProv: Record "Vendor Ledger Entry";
    begin
        LclMovProv.SETRANGE(LclMovProv."Document No.", DocNum);     // PARA ORDEN DE PAGA YA QUE EL DOCUMENTO NO ESTA PENDIENTE
        LclMovProv.SETRANGE(LclMovProv.Open, false);
        if (LclMovProv.FINDFIRST) then
            ImporteNC := FindAppliNC(LclMovProv."Entry No.", LclMovProv."Vendor No.", PPOV);
    end;

    procedure FindAppliNC(EntryNum: Integer; Prov: Code[20]; PPOV: Record "GMLocPosted Payment Ord Vouch") ImporteNC: Decimal;
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
                    recPCMH.SETRANGE("Pay-to Vendor No.", PPOV.GMLocVendor);
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

    procedure printWitholding(WLE: Record "GMLocWithholding Ledger Entry") ReturnValue: Boolean;
    var
    begin
        if TempRetencionesProcesadas.GET(WLE."GMLocNo.") then BEGIN
            ReturnValue := true;
        end
        else begin
            TempRetencionesProcesadas.INIT;
            TempRetencionesProcesadas."GMLocNo." := WLE."GMLocNo.";
            TempRetencionesProcesadas.INSERT;
        end;
    end;
}

