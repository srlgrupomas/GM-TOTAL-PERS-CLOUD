report 34006891 PersReceipts
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107474 - Receipts.rdl';


    dataset
    {
        dataitem("GMAPosted Receipt"; "GMAPosted Receipt")
        {
            RequestFilterFields = "GMANro Recibo";
            column(numero; numero)
            {
            }
            column(Hist__Cab_Recibos__Hist__Cab_Recibos___Fecha_de_Recibo_; "GMAPosted Receipt"."GMADocument Date")
            {
            }
            column(Hist__Cab_Recibos_Nombre; GMAName)
            {
            }
            column(Hist__Cab_Recibos_Domicilio; GMAAddress)
            {
            }
            column(Cliente__Post_Code_; Cliente."Post Code")
            {
            }
            column(Cliente_City; Cliente.City)
            {
            }
            column(Cliente_County; Cliente.County)
            {
            }
            column(Hist__Cab_Recibos_LocARCUIT; GMACUIT)
            {
            }
            column(Hist__Cab_Recibos__Hist__Cab_Recibos___Nro_Cliente_; "GMAPosted Receipt"."GMACustomer No.")
            {
            }
            column(Cliente__No__ingresos_brutos_; Cliente."GMAIIBB Code")
            {
            }
            column(SerieFactura_Letra; SerieFactura.GMALetter)
            {
            }
            column(InfoEmpresa__Phone_No__; InfoEmpresa.BssiBillingPhoneNumber)
            {
            }
            column(InfoEmpresaVATRegistrationNo; InfoEmpresa.BssiRegistrationNo)
            {
            }
            column(InfoEmpresa_LocARAddress; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa."BssiBillingZipCode" + ', ' + InfoEmpresa.BssiBillingCity + ', ' + InfoEmpresa.BssiBillingCountry)
            {
            }
            column(InfoEmpresa_LocARName; InfoEmpresa.BssiLegalNameFull)
            {
            }
            column(Hist__Cab_Recibos__No__; "GMANo.")
            {
            }
            column(InfoEmpresa_Picture; InfoEmpresa.BssiPicture)
            {
                AutoCalcField = true;
            }
            // AW - BEGIN
            column(InfoEmpresa_Gross_Incomes_No; InfoEmpresa.BssiIncomeExpenseNoSeries)
            { }
            column(InfoEmpresa_Email; InfoEmpresa.BssiEmail)
            { }
            column(InfoEmpresa_Activity_Starting_Date; InfoEmpresa.BssiActivityStratDate)
            { }
            // AW - END
            column(Hist__Cab_Recibos__Id__usuario_; "GMAUser Id")
            {
            }
            column(R_E_C_I_B_O___O_F_I_C_I_A_LCaption; R_E_C_I_B_O___O_F_I_C_I_A_LCaptionLbl)
            {
            }
            column(SE_ORES_Caption; SE_ORES_CaptionLbl)
            {
            }
            column(C_U_I_T___Caption; C_U_I_T___CaptionLbl)
            {
            }
            column(Cliente_N___Caption; Cliente_N___CaptionLbl)
            {
            }
            column(INGRESOS_BRUTOS_N__Caption; INGRESOS_BRUTOS_N__CaptionLbl)
            {
            }
            column(Tel_Caption; Tel_CaptionLbl)
            {
            }
            column(N__RECIBO_Caption; N__RECIBO_CaptionLbl)
            {
            }
            column(Hist__Cab_Recibos__Id__usuario_Caption; FIELDCAPTION("GMAUser Id"))
            {
            }
            column(Cuyo_importe_una_vez_hecho_efectivo_le_s__acreditaremos_seg_n_liquidaci_nCaption; Cuyo_importe_una_vez_hecho_efectivo_le_s__acreditaremos_seg_n_liquidaci_nCaptionLbl)
            {
            }
            column(indicada_mas_arriba__Agradecemos_su_remesa_y_saludamos_a_Uds__atte_Caption; indicada_mas_arriba__Agradecemos_su_remesa_y_saludamos_a_Uds__atte_CaptionLbl)
            {
            }
            column(Posted_Receipt_Nro_Recibo; "GMANro Recibo")
            {
            }


            dataitem("GMAPosted Receipt Vouchers"; "GMAPosted Receipt Vouchers")
            {
                DataItemLink = "GMAReceipt No." = FIELD("GMANro Recibo");
                DataItemTableView = SORTING("GMAReceipt No.", "GMAVoucher No.");
                MaxIteration = 0;
                column(Hist__Lin_Comp__Recibo__Nro_Comprobante_; Ndoc)
                {
                }
                column(Hist__Lin_Comp__Recibo_Fecha; GMADate)
                {
                }
                column(Hist__Lin_Comp__Recibo_Importe; GMAAmount)
                {
                }
                column(Hist__Lin_Comp__Recibo_ImpPendiente; "GMAPending Amount")
                {
                }
                column(Valordivisa; Valordivisa)
                {
                }
                column(Hist__Lin_Comp__Recibo_Cancelado; GMACancelled)
                {
                }
                column(ImporteDolares; ImporteDolares)
                {
                }
                column(Importepesos; Importepesos)
                {
                }
                column(ImportePesoTP; ImportePesoTP)
                {
                }
                column(Hist__Lin_Comp__Recibo_Importe_Control1000000027; GMAAmount)
                {
                }
                column(Hist__Lin_Comp__Recibo_Cancelado_Control1000000028; GMACancelled)
                {
                }
                column(Totalpesos; Totalpesos)
                {
                }
                column(DATOS_DE_FACTURAS_O_N__DEBITOSCaption; DATOS_DE_FACTURAS_O_N__DEBITOSCaptionLbl)
                {
                }
                column(Hist__Lin_Comp__Recibo__Nro_Comprobante_Caption; Hist__Lin_Comp__Recibo__Nro_Comprobante_CaptionLbl)
                {
                }
                column(Hist__Lin_Comp__Recibo_FechaCaption; FIELDCAPTION(GMADate))
                {
                }
                column(Hist__Lin_Comp__Recibo_ImporteCaption; FIELDCAPTION(GMAAmount))
                {
                }
                column(DivisaCaption; DivisaCaptionLbl)
                {
                }
                column(Su_PagoCaption; Su_PagoCaptionLbl)
                {
                }
                column(En_PesosCaption; En_PesosCaptionLbl)
                {
                }
                column(T_O_T_A_L_E_S_Caption; T_O_T_A_L_E_S_CaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(Posted_Receipt_Vouchers_Receipt_No_; "GMAReceipt No.")
                {
                }
                column(Posted_Receipt_Vouchers_Voucher_No_; "GMAVoucher No.")
                {
                }
                column(Posted_Receipt_Vouchers_Entry_No_; "GMAEntry No.")
                {
                }
                column(TipoCambio; TipoCambio)
                {
                }
                column(importePendienteTotalFactura; importePendienteTotalFactura)
                {

                }

                trigger OnAfterGetRecord();
                var
                    recCLE: Record "Cust. Ledger Entry";
                begin
                    if "GMAPosted Receipt Vouchers"."GMACurrency Code" = '' then begin
                        Valordivisa := 'PESOS';
                        importedolares := 0;
                        ImportePesoTP := GMACancelled;
                    end else begin
                        Valordivisa := "GMAPosted Receipt Vouchers"."GMACurrency Code";
                        ImporteDolares := GMACancelled;
                    end;
                    if "GMAExchange Rate" <> 0 then
                        Importepesos := GMACancelled / "GMAExchange Rate"
                    else
                        Importepesos := GMACancelled;
                    Totalpesos := Totalpesos + Importepesos;

                    //NAVAR1.06001-
                    CLEAR(Ndoc);
                    RecSalesHeader.RESET;
                    RecSalesHeader.SETCURRENTKEY("No.");
                    RecSalesHeader.SETRANGE("No.", "GMAVoucher No.");
                    if RecSalesHeader.FINDFIRST then
                        Ndoc := RecSalesHeader."External Document No."
                    else
                        Ndoc := '';

                    if Ndoc = '' then begin
                        RecSalesCrMemo.RESET;
                        RecSalesCrMemo.SETCURRENTKEY("No.");
                        RecSalesCrMemo.SETRANGE("No.", "GMAVoucher No.");
                        if RecSalesCrMemo.FINDFIRST then
                            Ndoc := RecSalesCrMemo."External Document No."
                        else
                            Ndoc := '';
                    end;

                    if (Ndoc = '') and ("GMAVoucher No." <> '') then begin
                        Ndoc := "GMAVoucher No.";
                    end;

                    //NAVAR1.06001+

                    //SDT-
                    //actualizar los valores de total importe factura y totalimportefacturadl
                    importePendienteTotalFactura := 0;

                    recCLE.Reset();
                    recCLE.SetRange(recCLE."Customer No.", "GMAPosted Receipt Vouchers".GMACustomer);
                    recCLE.SetRange(recCLE."Document No.", "GMAPosted Receipt Vouchers"."GMAVoucher No.");
                    recCLE.SetRange(recCLE."Entry No.", "GMAPosted Receipt Vouchers"."GMAEntry No.");
                    if recCLE.FindFirst() then
                        repeat
                            recCLE.CalcFields("Remaining Amount", "Remaining Amount");
                            importePendienteTotalFactura += recCLE."Remaining Amount";
                        until recCLE.Next() = 0;
                    importePendienteTotalFactura += "GMAPosted Receipt Vouchers".GMACancelled;
                    //SDT+
                end;

                trigger OnPreDataItem();
                begin
                    Totalpesos := 0;
                end;
            }
            dataitem("Posted Receipt Values"; "GMAPosted Receipt Values")
            {
                DataItemLink = "GMAReceipt No." = FIELD("GMANro Recibo");
                DataItemTableView = SORTING("GMAReceipt No.", "GMALine No.");
                column(Hist__Lin_Valores_Recibos__N__Valor_; "GMAValue No.")
                {
                }
                column(Valores_Descripcion; Valores.GMADescription)
                {
                }
                column(Hist__Lin_Valores_Recibos_Entidad; GMAEntity)
                {
                }
                column(Hist__Lin_Valores_Recibos__A_Fecha_; "GMATo Date")
                {
                }
                column(Hist__Lin_Valores_Recibos_Importe; GMAAmount)
                {
                }
                column(Valordivisa_Control1000000044; Valordivisa)
                {
                }
                column(Importepesos_Control1000000046; Importepesos)
                {
                }
                column(Hist__Lin_Valores_Recibos_Importe_Control1000000048; GMAAmount)
                {
                }
                column(Totalpesos_Control1000000053; Totalpesos)
                {
                }
                column(N_meroCaption; N_meroCaptionLbl)
                {
                }
                column(S_E_G_U_N___D_E_T_A_L_L_E_Caption; S_E_G_U_N___D_E_T_A_L_L_E_CaptionLbl)
                {
                }
                column(ValorCaption; ValorCaptionLbl)
                {
                }
                column(Hist__Lin_Valores_Recibos_EntidadCaption; FIELDCAPTION(GMAEntity))
                {
                }
                column(Hist__Lin_Valores_Recibos__A_Fecha_Caption; FIELDCAPTION("GMATo Date"))
                {
                }
                column(Hist__Lin_Valores_Recibos_ImporteCaption; FIELDCAPTION(GMAAmount))
                {
                }
                column(DivisaCaption_Control1000000045; DivisaCaption_Control1000000045Lbl)
                {
                }
                column(En_PesosCaption_Control1000000047; En_PesosCaption_Control1000000047Lbl)
                {
                }
                column(EmptyStringCaption_Control1000000034; EmptyStringCaption_Control1000000034Lbl)
                {
                }
                column(T_O_T_A_L_E_S_Caption_Control1000000035; T_O_T_A_L_E_S_Caption_Control1000000035Lbl)
                {
                }
                column(Posted_Receipt_Values_Receipt_No_; "GMAReceipt No.")
                {
                }
                column(Posted_Receipt_Values_Line_No_; "GMALine No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    Valores.GET("Posted Receipt Values".GMAValue);
                    if "Posted Receipt Values"."GMACurrency Code" = '' then
                        Valordivisa := 'PESOS'
                    else
                        Valordivisa := "Posted Receipt Values"."GMACurrency Code";
                    if "GMAExchange Rate" <> 0 then
                        Importepesos := GMAAmount / "GMAExchange Rate"
                    else
                        Importepesos := GMAAmount;
                    Totalpesos := Totalpesos + Importepesos;
                end;

                trigger OnPreDataItem();
                begin
                    Totalpesos := 0;
                end;
            }

            trigger OnAfterGetRecord();
            var
                recVouchers: record "GMAPosted Receipt Vouchers";
                varImportePesos: decimal;
                varImporteDolares: decimal;
                recValues: record "GMAPosted Receipt Values";
                varTotalPagoPeso: decimal;
                varEnPesos: decimal;
                BssiMEMSystemSetup: record BssiMEMSystemSetup;
            begin
                Cliente.GET("GMAPosted Receipt"."GMACustomer No.");
                numero := "GMANro Recibo";

                recVouchers.Reset();
                recVouchers.SetRange("GMAReceipt No.", "GMAPosted Receipt"."GMANro Recibo");
                if recVouchers.findfirst then
                    repeat
                        if recVouchers."GMACurrency Code" = '' then
                            varImportePesos := varImportePesos + recVouchers.GMACancelled
                        else begin
                            varImporteDolares := varImporteDolares + recVouchers.GMACancelled;
                        end;

                    until recvouchers.Next = 0;

                recValues.reset();
                recValues.SetRange("GMAReceipt No.", "GMAPosted Receipt"."GMANro Recibo");
                if recvalues.FindFirst() then
                    repeat
                        if recValues.GMACurrency = '' then
                            varTotalPagoPeso := varTotalPagoPeso + recValues.GMAAmount
                        else
                            varTotalPagoPeso := varTotalPagoPeso + (recValues.GMAAmount * (1 / recValues."GMAExchange Rate"));
                    until recValues.next = 0;
                if varImporteDolares <> 0 then
                    TipoCambio := (varTotalPagoPeso) / varImporteDolares
                else
                    TipoCambio := 1;

                SerieFactura.RESET;
                SerieFactura.SETCURRENTKEY("GMAInvoice Type", "GMAFiscal Type", "GMACompany Activity");
                SerieFactura.SETRANGE(SerieFactura."GMAInvoice Type", SerieFactura."GMAInvoice Type"::Recibo);
                SerieFactura.SETRANGE(SerieFactura."GMACompany Activity", COPYSTR("GMAPosted Receipt"."GMANro Recibo", 3, 4));
                if SerieFactura.FINDFIRST then;

                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                //DDSDESCOMENTAR  InfoEmpresa.SetFilter(Code, "GMAPosted Receipt".BssiMEMEntityID);
                IF (InfoEmpresa.FindFirst()) THEN;
                InfoEmpresa.CALCFIELDS(InfoEmpresa.BssiPicture);
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
        importePendienteTotalFactura: Decimal;
        ImportePesoTP: decimal;
        TipoCambio: decimal;
        Cliente: Record Customer;
        Valordivisa: Code[10];
        Valores: Record GMAValues;
        ImporteDolares: Decimal;
        Importepesos: Decimal;
        Totalpesos: Decimal;
        numero: Text[20];
        SerieFactura: Record "GMAInvoice Series Setup2";
        InfoEmpresa: Record "Dimension Value";
        RecSalesHeader: Record "Sales Invoice Header";
        RecSalesCrMemo: Record "Sales Cr.Memo Header";
        Ndoc: Code[20];
        R_E_C_I_B_O___O_F_I_C_I_A_LCaptionLbl: Label 'R E C I B O   O F I C I A L';
        SE_ORES_CaptionLbl: Label 'SEÑORES:';
        C_U_I_T___CaptionLbl: Label '"C.U.I.T.: "';
        Cliente_N___CaptionLbl: Label '"Cliente Nº: "';
        INGRESOS_BRUTOS_N__CaptionLbl: Label 'INGRESOS BRUTOS Nº:';
        Tel_CaptionLbl: Label 'Tel.';
        N__RECIBO_CaptionLbl: Label 'Nº Recibo';
        Cuyo_importe_una_vez_hecho_efectivo_le_s__acreditaremos_seg_n_liquidaci_nCaptionLbl: Label 'Cuyo importe una vez hecho efectivo le(s) acreditaremos según liquidación';
        indicada_mas_arriba__Agradecemos_su_remesa_y_saludamos_a_Uds__atte_CaptionLbl: Label 'indicada mas arriba. Agradecemos su remesa y saludamos a Uds. atte.';
        DATOS_DE_FACTURAS_O_N__DEBITOSCaptionLbl: Label 'DATOS DE FACTURAS O N. DEBITOS';
        Hist__Lin_Comp__Recibo__Nro_Comprobante_CaptionLbl: Label 'Nro Comprobante';
        DivisaCaptionLbl: Label 'Divisa';
        Su_PagoCaptionLbl: Label 'PAGO USD';
        En_PesosCaptionLbl: Label 'En Pesos';
        T_O_T_A_L_E_S_CaptionLbl: Label '"T O T A L E S "';
        EmptyStringCaptionLbl: Label '__________________________________________________________________________________________________________________';
        N_meroCaptionLbl: Label 'Número';
        S_E_G_U_N___D_E_T_A_L_L_E_CaptionLbl: Label 'S E G U N   D E T A L L E:';
        ValorCaptionLbl: Label 'Valor';
        DivisaCaption_Control1000000045Lbl: Label 'Divisa';
        En_PesosCaption_Control1000000047Lbl: Label 'En Pesos';
        EmptyStringCaption_Control1000000034Lbl: Label '__________________________________________________________________________________________________________________';
        T_O_T_A_L_E_S_Caption_Control1000000035Lbl: Label '"T O T A L E S "';

}

