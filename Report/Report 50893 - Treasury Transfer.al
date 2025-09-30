report 80893 "PersTreasury Transfer"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/Report 7107477 - Treasury Transfer.rdl';


    dataset
    {
        dataitem("Hist. Cab. Transferencias"; "GMLocPosted Transfer")
        {
            RequestFilterFields = "GMLocNo.";
            column(InfoEmpresa_Picture; InfoEmpresa.BssiPicture)
            {
            }
            column(Hist__Cab__Transferencias__Hist__Cab__Transferencias___N__; "Hist. Cab. Transferencias"."GMLocNo.")
            {
            }
            column(Hist__Cab__Transferencias__Hist__Cab__Transferencias___Fecha_de_Registro_; "Hist. Cab. Transferencias"."GMLocPosting Date")
            {
            }
            column(Hist__Cab__Transferencias__Desde_cja_bco_; "GMLocFrom Cash/Bank")
            {
            }
            column(Hist__Cab__Transferencias__Hasta_cja_bco_; "GMLocTo Cash/Bank")
            {
            }
            column(Hist__Cab__Transferencias_Comentario; GMLocComment)
            {
            }
            column(InfoEmpresa__Phone_No__; InfoEmpresa."BssiBillingPhoneNumber")
            {
            }
            column(InfoEmpresa_Address; InfoEmpresa.BssiBillingAddr1 + ', ' + InfoEmpresa."BssiBillingZipCode" + ', ' + InfoEmpresa.BssiBillingCity + ', ' + InfoEmpresa.BssiBillingCountry)
            {
            }
            column(InfoEmpresa_Name; InfoEmpresa.BssiLegalNameFull)
            {
            }
            column(Hist__Cab__Transferencias_Comentario_Control1100227000; GMLocComment)
            {
            }
            column(nombrebancodesde; nombrebancodesde)
            {
            }
            column(nombrebancohasta; nombrebancohasta)
            {
            }
            column(Hist__Cab__Transferencias_Importe; GMLocAmount)
            {
            }
            column(Hist__Cab__Transferencias__Importe__DL__; "GMLocAmount (LCY)")
            {
            }
            column(Fecha_Caption; Fecha_CaptionLbl)
            {
            }
            column(T_R_A_N_S_F_E_R_E_N_C_I_ACaption; T_R_A_N_S_F_E_R_E_N_C_I_ACaptionLbl)
            {
            }
            column(N__Caption; N__CaptionLbl)
            {
            }
            column(Datos_de_la_TransferenciaCaption; Datos_de_la_TransferenciaCaptionLbl)
            {
            }
            column(Hist__Cab__Transferencias__Desde_cja_bco_Caption; FIELDCAPTION("GMLocFrom Cash/Bank"))
            {
            }
            column(Hist__Cab__Transferencias__Hasta_cja_bco_Caption; FIELDCAPTION("GMLocTo Cash/Bank"))
            {
            }
            column(Tel_Caption; Tel_CaptionLbl)
            {
            }
            column(Hist__Cab__Transferencias_Comentario_Control1100227000Caption; FIELDCAPTION(GMLocComment))
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(T_O_T_A_L_E_S_Caption; T_O_T_A_L_E_S_CaptionLbl)
            {
            }
            column(FIRMA_GERENTE_GENERALCaption; FIRMA_GERENTE_GENERALCaptionLbl)
            {
            }
            column(FIRMA_GERENTE_GENERALCaption_Control1000000034; FIRMA_GERENTE_GENERALCaption_Control1000000034Lbl)
            {
            }
            column(FIRMA_GERENTE_FINANCIEROCaption; FIRMA_GERENTE_FINANCIEROCaptionLbl)
            {
            }
            column(FIRMA_SOLICITANTECaption; FIRMA_SOLICITANTECaptionLbl)
            {
            }
            dataitem("GMLocPosted Transfer Line"; "GMLocPosted Transfer Line")
            {
                DataItemLink = "GMLocTransfer No." = FIELD("GMLocNo.");
                DataItemTableView = SORTING("GMLocTransfer No.", "GMLocLine No.") ORDER(Ascending);
                MaxIteration = 0;
                column(Valordivisa; Valordivisa)
                {
                }
                column(Hist__Lin__Transferencias_Valor; Value)
                {
                }
                column(Hist__Lin__Transferencias_Descripcion; Description)
                {
                }
                column(Hist__Lin__Transferencias_Importe; GMLocAmount)
                {
                }
                column(Hist__Lin__Transferencias__Importe__DL__; "GMLocAmount (LCY)")
                {
                }
                column(Hist__Lin__Transferencias__N__Valor_; "GMLocValue No.")
                {
                }
                column(Hist__Lin__Transferencias_Entidad; GMLocEntity)
                {
                }
                column(DivisaCaption; DivisaCaptionLbl)
                {
                }
                column(En_PesosCaption; En_PesosCaptionLbl)
                {
                }
                column(Hist__Lin__Transferencias_ValorCaption; FIELDCAPTION(Value))
                {
                }
                column(Hist__Lin__Transferencias_DescripcionCaption; FIELDCAPTION(Description))
                {
                }
                column(Hist__Lin__Transferencias_ImporteCaption; FIELDCAPTION(GMLocAmount))
                {
                }
                column(Hist__Lin__Transferencias__N__Valor_Caption; FIELDCAPTION("GMLocValue No."))
                {
                }
                column(Hist__Lin__Transferencias_EntidadCaption; FIELDCAPTION(GMLocEntity))
                {
                }
                column(Posted_Transfer_Line_Transfer_No_; "GMLocTransfer No.")
                {
                }
                column(Posted_Transfer_Line_Line_No_; "GMLocLine No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    if "GMLocPosted Transfer Line"."GMLocCurrency Code" = '' then
                        Valordivisa := 'PESO ARG'
                    else
                        Valordivisa := "GMLocPosted Transfer Line"."GMLocCurrency Code";
                end;
            }

            trigger OnPreDataItem();
            var
                BssiMEMSystemSetup: record BssiMEMSystemSetup;
            begin
                InfoEmpresa.Reset();
                InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                InfoEmpresa.SetFilter(Code, "Hist. Cab. Transferencias".BssiMEMEntityID);
                IF (InfoEmpresa.FindFirst()) THEN;
                InfoEmpresa.CALCFIELDS(BssiPicture);

                if "Hist. Cab. Transferencias".FINDFIRST then begin
                    cajas.RESET;
                    cajas.SETRANGE(cajas."GMLocNo.", "Hist. Cab. Transferencias"."GMLocFrom Cash/Bank");
                    if cajas.FINDFIRST then begin
                        nombrebancodesde := cajas.GMLocDescription;
                    end;

                    cajas.RESET;
                    cajas.SETRANGE(cajas."GMLocNo.", "Hist. Cab. Transferencias"."GMLocTo Cash/Bank");
                    if cajas.FINDFIRST then begin
                        nombrebancohasta := cajas.GMLocDescription;
                    end;

                end;
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
        Valores: Record GMLocValues;
        InfoEmpresa: Record "Dimension Value";
        nombrebancodesde: Text[30];
        nombrebancohasta: Text[30];
        cajas: Record "GMLocCash/Bank Account";
        Fecha_CaptionLbl: Label 'Fecha:';
        T_R_A_N_S_F_E_R_E_N_C_I_ACaptionLbl: Label 'T R A N S F E R E N C I A';
        N__CaptionLbl: Label 'Nº:';
        Datos_de_la_TransferenciaCaptionLbl: Label 'Datos de la Transferencia';
        Tel_CaptionLbl: Label 'Tel.';
        EmptyStringCaptionLbl: Label '________________________________________________________________________________________________________________________';
        T_O_T_A_L_E_S_CaptionLbl: Label '"T O T A L E S "';
        FIRMA_GERENTE_GENERALCaptionLbl: Label 'FIRMA DIRECTOR';
        FIRMA_GERENTE_GENERALCaption_Control1000000034Lbl: Label 'FIRMA GERENTE GENERAL';
        FIRMA_GERENTE_FINANCIEROCaptionLbl: Label 'FIRMA GERENTE FINANCIERO';
        FIRMA_SOLICITANTECaptionLbl: Label 'FIRMA SOLICITANTE';
        DivisaCaptionLbl: Label 'Divisa';
        En_PesosCaptionLbl: Label 'En Pesos';
}

