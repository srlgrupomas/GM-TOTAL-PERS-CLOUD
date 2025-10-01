pageextension 34006890 persMenu9006 extends "Order Processor Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }
            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006891 persMenu9022 extends "Business Manager Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }
            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006892 persMenu9027 extends "Accountant Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006893 persMenu9018 extends "Administrator Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006894 persMenu9005 extends "Sales Manager Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}
pageextension 34006895 persMenu8901 extends "Finance Manager Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006896 persMenu8908 extends "Service Manager Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006897 persMenu9007 extends "Purchasing Agent Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006898 persMenu8909 extends "Warehouse Manager Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006899 persMenu8905 extends "Purchasing Manager Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}

pageextension 34006900 persMenu8910 extends "Service Dispatcher Role Center"
{
    actions
    {
        modify(GMARep23)
        {
            Visible = false;
        }
        addafter(GMARep23)
        {
            action("PERSRep23")
            {
                ApplicationArea = ALL;
                Caption = 'SUSS';
                Image = "Report";
                RunObject = Report "PERS SUSS";

            }
        }
        modify(GMARep31)
        {
            Visible = false;
        }
        addafter(GMARep31)
        {
            action("PERSRep31")
            {
                ApplicationArea = ALL;
                Caption = 'SIRE IVA';
                Image = "Report";
                RunObject = Report "PERS SIRE IVA";

            }
        }
        addlast(Sections)
        {
            group("TotalPersData")
            {
                Caption = 'Total Data Editor';
                action("TotalPerBanckDimensionValuePage")
                {
                    RunObject = page "EntitySetUpExtend";
                    ApplicationArea = ALL;
                    Image = PaymentJournal;
                    Caption = 'Dimension Value Bank';
                }
            }
        }

        addafter(GMAMovAxiPresupDetallado)
        {
            action(PERReporteTotal)
            {
                ApplicationArea = ALL;
                Caption = 'Reporte Total';
                Image = TransmitElectronicDoc;
                RunObject = page "Report Total";
            }
        }
        addafter("GMATax Groups")
        {
            action(TaxAreaPerCompany)
            {
                ApplicationArea = all;
                Caption = 'Tax Area by Entity';
                RunObject = Page PerceptionabyEntity;
            }


        }
        modify("GMAGEneracionAXI")
        {
            visible = false;
        }
        modify("GMAGEneracionAXIV2")
        {
            visible = false;
        }
        addafter("GMAGEneracionAXI")
        {
            action("GeneracionAXI")
            {
                RunObject = page "AXI Parámetros";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'AXI Generation';
            }
            action("EntitySetUpExtendPage")
            {
                RunObject = page "EntitySetUpExtend";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Entity SetUp Extend';
            }
        }
        addafter("GMATaxation")
        {
            action("Withholding Taxes by Entity")
            {
                RunObject = page "BssiMEMWithholdingTaxByEntity";
                ApplicationArea = ALL;
                Image = TransmitElectronicDoc;
                Caption = 'Withholding Taxes by Entity';
            }
        }
        modify("GMARep7")
        {
            visible = false;
        }
        addafter("GMARep7")
        {
            action("persVAT Sales Book F(V)NC(C)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Book F(V)NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(C)";

            }
        }
        modify("GMARep88")
        {
            visible = false;
        }
        addafter("GMARep88")
        {
            action("persRep88")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Ledger Purchases Invoices(C) and NC(C)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(C)";
            }
        }
        modify("GMARep55")
        {
            visible = false;
        }
        addafter("GMARep55")
        {
            action("perscRep55")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Sales Ledger Invoices(V) and NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Sales Book F(V)NC(V)";

            }
        }
        modify("GMARep8")
        {
            visible = false;
        }
        addafter("GMARep8")
        {
            action("persVAT Purch Book F(C)NC(V)")
            {
                ApplicationArea = ALL;
                Caption = 'VAT Purch Book F(C)NC(V)';
                Image = "Report";
                RunObject = Report "PersVAT Purch Book F(C)NC(V)";

            }
        }

        modify("GMARep11")
        {
            visible = false;
        }
        addafter("GMARep11")
        {
            action("PERRep11")
            {
                ApplicationArea = ALL;
                Caption = 'Libro Diario';
                Image = "Report";
                RunObject = Report "PersLibro Diario";

            }
        }
        modify(GMARep12)
        {
            visible = false;
        }
        addafter(GMARep12)
        {
            action("PERRep12")
            {
                ApplicationArea = ALL;
                Caption = 'Withholdings Book';
                Image = "Report";
                RunObject = Report "PersWithholdings Book";

            }

        }
        modify(GMARep13)
        {
            visible = false;
        }
        addafter(GMARep13)
        {
            action("persRep13")
            {
                ApplicationArea = ALL;
                Caption = 'Perceptions Book';
                Image = "Report";
                RunObject = Report "PersPerceptions Book";

            }

            action("PERMEMTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalance";

            }
            action("PERMEMTrialBalanceLocal")
            {
                ApplicationArea = ALL;
                Caption = 'Trial Balance Local';
                Image = "Report";
                RunObject = Report "PERMEMTrialBalanceLocal";

            }
            action("PERDetailTrialBalance")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalance";

            }
            action("PERDetailTrialBalByEntity")
            {
                ApplicationArea = ALL;
                Caption = 'Detail Trial Bal By Entity';
                Image = "Report";
                RunObject = Report "PERDetailTrialBalByEntity";

            }
            action("PerTrialBalanceCliPro")
            {
                ApplicationArea = all;
                caption = 'Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Cli/Pro";
            }
            action("PerTrialBalanceDetailCliPro")
            {
                ApplicationArea = all;
                caption = 'Detail Trial Balance Vendor / Customer';
                Image = "Report";
                RunObject = report "PersTrial Balance Det Cli/Pro";
            }
            action("PerTrialBalanceBankAcc")
            {
                ApplicationArea = all;
                Caption = 'Trial Balance Bank Account';
                Image = "Report";
                RunObject = report "PersTrial Balance Bank Acc";
            }
        }

        modify("GMARep16")
        {
            Visible = false;
        }
        addafter("GMARep16")
        {
            action("PERRep16")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA Perception';
                Image = "Report";
                RunObject = Report "PERARBA Perception";

            }
        }
        modify("GMARep17")
        {
            Visible = false;
        }
        addafter("GMARep17")
        {
            action("PERRep17")
            {
                ApplicationArea = ALL;
                Caption = 'ARBA RET IIBB BSAS';
                Image = "Report";
                RunObject = Report "PERARBA IIBB BSAS";

            }
        }
        modify(GMARep20)
        {
            Visible = false;
        }

        addafter(GMARep20)
        {
            action("PERRep20")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Per. IIBB Sufferings';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT Perc. Suff.";

            }

        }
        modify(GMARep19)
        {
            Visible = false;
        }
        addafter(GMARep19)
        {
            action("PERRep19")
            {
                ApplicationArea = ALL;
                Caption = 'SIFERE - Ret. IIBB Suffered';
                Image = "Report";
                RunObject = Report "PERSIFERE - GIT With. Suff.";

            }
        }
        modify("GMARep22")
        {
            Visible = false;
        }
        addafter("GMARep22")
        {
            action("PERRep22")
            {
                ApplicationArea = ALL;
                Caption = 'SICORE';
                Image = "Report";
                RunObject = Report "PER SICORE";

            }
        }
        modify(GMARep25)
        {
            Visible = false;
        }
        addafter("GMARep25")
        {
            action("PERRep25")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Purchases';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Compras";

            }
        }
        modify(GMARep26)
        {
            Visible = false;
        }
        addafter("GMARep26")
        {
            action("PERRep26")
            {
                ApplicationArea = ALL;
                Caption = 'CITI Sales';
                Image = "Report";
                RunObject = Report "PER R.G. 3685 CITI Ventas";

            }
        }
        modify(GMARep27)
        {
            Visible = false;
        }
        addafter("GMARep27")
        {
            action("PERRep27")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA RET PERC';
                Image = "Report";
                RunObject = Report "PER EARCIBA RET PERC";

            }
        }
        modify(GMARep28)
        {
            Visible = false;
        }
        addafter("GMARep28")
        {
            action("PERRep28")
            {
                ApplicationArea = ALL;
                Caption = 'E-ARCIBA NC';
                Image = "Report";
                RunObject = Report "PER EARCIBA NC";

            }
            action("PERSircar")
            {
                ApplicationArea = ALL;
                Caption = 'SIRCAR Perceptions and Withholdings Reg 1 y 2';
                Image = "Report";
                RunObject = Report "PERSIRCAR_REG_1y2";

            }
        }
        modify("GMASircar")
        {
            Visible = false;
        }
        addafter(GMAAXI)
        {
            group(GMAAXDC)
            {
                Caption = 'Differences Exchange Rates';

                action("Differences Exchange Rates")
                {
                    RunObject = page "Differences Exchange Rates";
                    ApplicationArea = ALL;
                    Caption = 'Differences Exchange Rates';
                }
            }
            action(extrate)
            {
                ApplicationArea = ALL;
                RunObject = report "PERExch. Rate Adjustment";
                Caption = 'Exch. Rate Adjustment';
            }
        }

    }
}
