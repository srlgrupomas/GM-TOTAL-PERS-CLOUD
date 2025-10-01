report 34006898 "PersIncome/Expend."
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    GMADescription
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107475 - Income - Expend.rdl';


    dataset
    {
        dataitem("Posted Deposit/Withdrawal"; "GMAPosted Deposit/Withdrawal")
        {
            RequestFilterFields = "GMANo.";
            column(Hist__Cab_Ingresos_Egresos__Hist__Cab_Ingresos_Egresos___N__; "Posted Deposit/Withdrawal"."GMANo.")
            {
            }
            column(Hist__Cab_Ingresos_Egresos__Hist__Cab_Ingresos_Egresos___Fecha_de_Registro_; "Posted Deposit/Withdrawal"."GMAPosting Date")
            {
            }
            column(Hist__Cab_Ingresos_Egresos_Tipo; GMAType)
            {
            }
            column(Hist__Cab_Ingresos_Egresos__Caja_Cuenta_Bancaria_; nombrecajaCab)
            {
            }
            column(Hist__Cab_Ingresos_Egresos_Tipo_Control1000000009; GMAType)
            {
            }
            column(InfoEmpresa_Name; InfoEmpresa.BssiLegalNameFull)
            {
            }
            column(InfoEmpresa_Address; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa.BssiBillingZipCode + ', ' + InfoEmpresa.BssiBillingCity + ', ' + InfoEmpresa.BssiBillingCountry)
            {
            }
            column(InfoEmpresa__Phone_No__; InfoEmpresa.BssiBillingPhoneNumber)
            {
            }
            column(InfoEmpresa_City; InfoEmpresa.BssiBillingCity)
            {
            }
            column(Hist__Cab_Ingresos_Egresos_Comentario; GMAComment)
            {
            }
            column(nombrecaja; nombrecaja)
            {
            }
            column(TipoReport; TipoReport)
            {
            }
            column(UserId_PostedDepositWithdrawal; "GMAUser Id")
            {
            }
            column(Fecha_Caption; Fecha_CaptionLbl)
            {
            }
            column(I_N_G_R_E_S_O___E_G_R_E_S_OCaption; I_N_G_R_E_S_O___E_G_R_E_S_OCaptionLbl)
            {
            }
            column(TIPO_Caption; TIPO_CaptionLbl)
            {
            }
            column(N__Caption; N__CaptionLbl)
            {
            }
            column(Hist__Cab_Ingresos_Egresos__Caja_Cuenta_Bancaria_Caption; Hist__Cab_Ingresos_Egresos__Caja_Cuenta_Bancaria_CaptionLbl)
            {
            }
            column(Datos_delCaption; Datos_delCaptionLbl)
            {
            }
            column(Tel_Caption; Tel_CaptionLbl)
            {
            }
            column(Hist__Cab_Ingresos_Egresos_ComentarioCaption; FIELDCAPTION(GMAComment))
            {
            }
            column(FIRMA_GERENTE_GENERALCaption; FIRMA_GERENTE_GENERALCaptionLbl)
            {
            }
            column(FIRMA_GERENTE_GENERALCaption_Control1000000033; FIRMA_GERENTE_GENERALCaption_Control1000000033Lbl)
            {
            }
            column(FIRMA_GERENTE_FINANCIEROCaption; FIRMA_GERENTE_FINANCIEROCaptionLbl)
            {
            }
            column(FIRMA_SOLICITANTECaption; FIRMA_SOLICITANTECaptionLbl)
            {
            }
            dataitem("GMAPosted Depos/Withdrawal L"; "GMAPosted Depos/Withdrawal L")
            {
                DataItemLink = "GMADeposit/Withdrawal No." = FIELD("GMANo.");
                DataItemTableView = SORTING("GMADeposit/Withdrawal No.", "GMALine No.") ORDER(Ascending);
                MaxIteration = 0;
                column(Hist__Lin_Ingresos_Egresos_Valor; GMAValue)
                {
                }
                column(Hist__Lin_Ingresos_Egresos_Cuenta; "GMAGL Account")
                {
                }
                column(Hist__Lin_Ingresos_Egresos_Descripcion; GMADescription)
                {
                }
                column(Valordivisa; Valordivisa)
                {
                }
                column(Hist__Lin_Ingresos_Egresos_Importe; GMAAmount)
                {
                }
                column(Hist__Lin_Ingresos_Egresos__Importe__DL__; "GMAAmount (LCY)")
                {
                }
                column(Hist__Lin_Ingresos_Egresos__N__Valor_; "GMAValue No.")
                {
                }
                column(Hist__Lin_Ingresos_Egresos_Entidad; GMAEntity)
                {
                }
                column(Hist__Lin_Ingresos_Egresos__Hist__Lin_Ingresos_Egresos___Job_No__; "GMAPosted Depos/Withdrawal L"."GMAJob No.")
                {
                }
                column(Hist__Lin_Ingresos_Egresos__Nombre_cuenta_; "GMAAccount Name")
                {
                }
                column(Hist__Lin_Ingresos_Egresos_Importe_Control1000000027; GMAAmount)
                {
                }
                column(Hist__Lin_Ingresos_Egresos__Importe__DL___Control1000000030; "GMAAmount (LCY)")
                {
                }
                column(Hist__Lin_Ingresos_Egresos_ValorCaption; FIELDCAPTION(GMAValue))
                {
                }
                column(Hist__Lin_Ingresos_Egresos_CuentaCaption; FIELDCAPTION("GMAGL Account"))
                {
                }
                column(Hist__Lin_Ingresos_Egresos_DescripcionCaption; FIELDCAPTION(GMADescription))
                {
                }
                column(DivisaCaption; DivisaCaptionLbl)
                {
                }
                column(Hist__Lin_Ingresos_Egresos_ImporteCaption; FIELDCAPTION(GMAAmount))
                {
                }
                column(En_PesosCaption; En_PesosCaptionLbl)
                {
                }
                column(Hist__Lin_Ingresos_Egresos__N__Valor_Caption; FIELDCAPTION("GMAValue No."))
                {
                }
                column(Hist__Lin_Ingresos_Egresos_EntidadCaption; FIELDCAPTION(GMAEntity))
                {
                }
                column(Job_No_Caption; Job_No_CaptionLbl)
                {
                }
                column(Hist__Lin_Ingresos_Egresos__Nombre_cuenta_Caption; FIELDCAPTION("GMAAccount Name"))
                {
                }
                column(T_O_T_A_L_E_S_Caption; T_O_T_A_L_E_S_CaptionLbl)
                {
                }
                column(Posted_Deposit_Withdrawal_Line_Deposit_Withdrawal_No_; "GMADeposit/Withdrawal No.")
                {
                }
                column(Posted_Deposit_Withdrawal_Line_Line_No_; "GMALine No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if "GMAPosted Depos/Withdrawal L"."GMACurrency Code" = '' then
                        Valordivisa := 'PESO ARG'
                    else
                        Valordivisa := "GMAPosted Depos/Withdrawal L"."GMACurrency Code";

                    //NAVAR1.06003-
                    recGLAcc.RESET;
                    recGLAcc.SETCURRENTKEY("No.");
                    recGLAcc.SETRANGE("No.", "GMAGL Account");
                    if recGLAcc.FINDFIRST then
                        nombrecaja := recGLAcc.Name
                    else
                        nombrecaja := '';
                    //NAVAR1.06003+
                end;
            }

            trigger OnAfterGetRecord();
            var
                _recCajaCBank: Record "GMACash/Bank Account";
            begin
                case GMAType of
                    GMAType::"Ingreso Caja/Cuenta B.":
                        TipoReport := 'INGRESO';
                    GMAType::"Egreso Caja/Cuenta B.":
                        TipoReport := 'EGRESO';
                    else
                        TipoReport := '';
                end;

                //NAVAR1.06003-
                _recCajaCBank.RESET;
                _recCajaCBank.SETCURRENTKEY("GMANo.");
                _recCajaCBank.SETRANGE("GMANo.", "GMACash/Bank Account");
                if _recCajaCBank.FINDFIRST then
                    nombrecajaCab := _recCajaCBank.GMADescription
                else
                    nombrecajaCab := '';
                //NAVAR1.06003+
            end;

            trigger OnPreDataItem();
            var
                BssiMEMSystemSetup: record BssiMEMSystemSetup;
            begin
                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Posted Deposit/Withdrawal"."GMAShortcut Dimension 1 Co");
                IF (InfoEmpresa.FindFirst()) THEN;
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
        Valordivisa: Code[10];
        Valores: Record GMAValues;
        InfoEmpresa: Record "Dimension Value";
        cajas: Record "GMACash/Bank Account";
        nombrecaja: Text[100];
        TipoReport: Code[20];
        recGLAcc: Record "G/L Account";
        nombrecajaCab: Text[100];
        Fecha_CaptionLbl: Label 'Fecha:';
        I_N_G_R_E_S_O___E_G_R_E_S_OCaptionLbl: Label 'I N G R E S O / E G R E S O';
        TIPO_CaptionLbl: Label 'TIPO:';
        N__CaptionLbl: Label 'Nº:';
        Hist__Cab_Ingresos_Egresos__Caja_Cuenta_Bancaria_CaptionLbl: Label 'Caja/Cuenta Bancaria:';
        Datos_delCaptionLbl: Label 'Datos del';
        Tel_CaptionLbl: Label 'Tel.';
        FIRMA_GERENTE_GENERALCaptionLbl: Label 'FIRMA GERENTE GENERAL';
        FIRMA_GERENTE_GENERALCaption_Control1000000033Lbl: Label 'FIRMA GERENTE GENERAL';
        FIRMA_GERENTE_FINANCIEROCaptionLbl: Label 'FIRMA GERENTE FINANCIERO';
        FIRMA_SOLICITANTECaptionLbl: Label 'FIRMA SOLICITANTE';
        DivisaCaptionLbl: Label 'Divisa';
        En_PesosCaptionLbl: Label 'En Pesos';
        Job_No_CaptionLbl: Label 'Job No.';
        T_O_T_A_L_E_S_CaptionLbl: Label '"T O T A L E S "';
}

