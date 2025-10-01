
report 34006904 PERMEMTrialBalanceLocal
{
    // *********************************************************************************
    // Description: Duplicate D365BC - Trial Balance (Object ID: 6)
    // Written By : Rajbir
    // ---------------------------------------------------------------------------------
    // Revision History
    // ---------------------------------------------------------------------------------
    // Date                By                  Revision Description 
    // July-22-2019       Rajbir               Initial Release 
    // March-31-2020      Divjot               Initial Release (Ver 15.3)
    // *********************************************************************************

    DefaultLayout = RDLC;
    RDLCLayout = './Layout/BssiMEMTrialBalanceLocal.rdl';
    AdditionalSearchTerms = 'year closing,close accounting period,close fiscal year';
    ApplicationArea = Basic, Suite;
    Caption = 'MEM Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("GMACorporate Account Code") ORDER(Ascending);
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText))
            {
            }
            column(COMPANYNAME; Empresa.BssiLegalNameFull)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(G_L_Account_No_; "GMACorporate Account Code")
            {
            }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
            }

            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(AdditionalNet_ChangeCaption; AdditionalNet_ChangeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(AdditionalBalanceCaption; AdditionalBalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FieldCaption("GMACorporate Account Code"))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(BssiDefaultEntity; BssiDimensionForRestriction)
            {
            }
            column(BssiDefaultEntitylbl; BssiMEMSystemSetup.Bssi_tGetEntityLabel(BssiMEMSystemSetup.Bssi_cGetEntityCode()))
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(G_L_Account___No__; "G/L Account"."GMACorporate Account Code")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PadStr('', "G/L Account".Indentation * 2) + AccountName)
                {
                }
                column(G_L_Account___Net_Change_; "G/L Account"."Debit Amount")
                {
                }
                column(G_L_Account___AdditionalNet_Change_; "G/L Account"."Add.-Currency Debit Amount")
                {
                }
                column(G_L_Account___Net_Change__Control22; "G/L Account"."Credit Amount")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___AdditionalNet_Change__Control22; "G/L Account"."Add.-Currency Credit Amount")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; "G/L Account"."Debit Amount" - "G/L Account"."Credit Amount")
                {
                }
                column(G_L_Account___AdditionalBalance_at_Date_; "G/L Account"."Add.-Currency Debit Amount" - "G/L Account"."Add.-Currency Credit Amount")
                {
                }
                column(G_L_Account___Balance_at_Date__Control24; -"G/L Account"."Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___AdditionalBalance_at_Date__Control24; -"G/L Account"."Add.-Currency Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2))
                {
                }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines")
                {
                }
                dataitem(BlankLineRepeater; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(BlankLineNo; BlankLineNo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if BlankLineNo = 0 then
                            CurrReport.Break;

                        BlankLineNo -= 1;

                        if UsarNombreCorporativo then
                            AccountName := "G/L Account"."GMACorporate Account Name"
                        else
                            AccountName := "G/L Account".Name;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlankLineNo := "G/L Account"."No. of Blank Lines" + 1;
                    if ("G/L Account"."Net Change" <= 0) and (-"G/L Account"."Net Change" <= 0) and ("G/L Account"."Balance at Date" <= 0) and (-"G/L Account"."Balance at Date" <= 0) and ("G/L Account"."Additional-Currency Net Change" <= 0) and (-"G/L Account"."Additional-Currency Net Change" <= 0) and ("G/L Account"."Add.-Currency Balance at Date" <= 0) and (-"G/L Account"."Add.-Currency Balance at Date" <= 0) then
                        CurrReport.Skip();

                    if UsarNombreCorporativo then
                        AccountName := "G/L Account"."GMACorporate Account Name"
                    else
                        AccountName := "G/L Account".Name;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change", "Credit Amount", "Debit Amount", "Balance at Date", "Additional-Currency Net Change", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount", "Add.-Currency Balance at Date");

                if ("Debit Amount" = 0) and
                       ("Credit Amount" = 0) and
                       (("Debit Amount" - "Credit Amount") = 0) and
                       ("Add.-Currency Debit Amount" = 0) and
                       ("Add.-Currency Credit Amount" = 0) and
                       (("Add.-Currency Debit Amount" - "Add.-Currency Credit Amount") = 0) then
                    CurrReport.Skip;

                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;

                ChangeGroupNo := "New Page";

                if UsarNombreCorporativo then
                    AccountName := "G/L Account"."GMACorporate Account Name"
                else
                    AccountName := "G/L Account".Name;
            end;

            trigger OnPreDataItem()
            var
                GLEntry: Record "G/L Entry";
                AccountList: Text;
            begin
                //Added By Bssi Developer        
                if BssiMEMSystemSetup.Get() then
                    if BSsiMEMSystemSetup.BssiEntityDimension = BSsiMEMSystemSetup.BssiEntityDimension::"Global Dimension 1 Code" then
                        "G/L Account".SetFilter("Global Dimension 1 Filter", BssiDimensionForRestriction)
                    else
                        "G/L Account".SetFilter("Global Dimension 2 Filter", BssiDimensionForRestriction);

                Empresa.Reset();
                Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                Empresa.SetFilter(Code, BssiDimension);
                IF (Empresa.FindFirst()) THEN;
                //End of Added By Bssi Developer

                if LedgerCode <> '' then begin
                    GLEntry.Reset();
                    GLEntry.SetFilter("GRP Ledger Code", LedgerCode);
                    GLEntry.SetFilter("Posting Date", "G/L Account".GetFilter("Date Filter"));
                    if GLEntry.FindSet() then begin
                        AccountList := '';
                        repeat
                            if AccountList = '' then
                                AccountList := GLEntry."G/L Account No."
                            else
                                AccountList += '|' + GLEntry."G/L Account No.";
                        until GLEntry.Next() = 0;
                        "G/L Account".SetFilter("No.", AccountList);
                    end else begin
                        "G/L Account".SetRange("No.", '');
                    end;
                end;
                PageGroupNo := 0;
                ChangeGroupNo := false;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(BssiOptions)
                {
                    Caption = 'Options';
                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        Importance = Promoted;

                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            SecurityHelper: Codeunit BssiMEMSecurityHelper;
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            SecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;

                        trigger OnValidate()
                        var
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;
                    }
                    field(UsarNombreCorporativo; UsarNombreCorporativo)
                    {
                        Caption = 'Use Corporate Account Name';
                        ApplicationArea = ALL;
                        ToolTip = 'Seleccione esta opción para utilizar el nombre corporativo en lugar del nombre estándar.';
                    }

                    field(LedgerCode; LedgerCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Ledger Code';
                        ToolTip = 'Select one or more ledger codes to filter the report.';

                        trigger OnAssistEdit()
                        var
                            GRPLedgerCodeSelection: Page "Ledger Code Selection";
                        begin
                            LedgerCode := '';
                            GRPLedgerCodeSelection.SetLedgerCode(LedgerCode);
                            if GRPLedgerCodeSelection.RunModal() = ACTION::OK then
                                LedgerCode := GRPLedgerCodeSelection.GetSelectedLedgerCodes();
                        end;
                    }
                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        var
            Bssi_Handled: Boolean;
            FeatureTelemetry: Codeunit "Feature Telemetry"; // AB#4938
        begin
            Bssi_RegKeyValidationMEMReports(Bssi_Handled);
            if Bssi_Handled then
                Error('');
            // AB#4938
            /* FeatureTelemetry.LogUptake(format(BssiMEMTelemetryEvents::Reporting), CurrReport.ObjectId(true), "Feature Uptake Status"::Discovered); */
            BssiMEMSingleInstanceCU.Bssi_SetCurrentHeaderEntity('');
            BssiMEMSingleInstanceCU.Bssi_SetCurrentEntity('');
            BssiMEMSystemSetup.Get();
            //V17 fix
            if BssiDimension = '' then
                BssiDimension := BssiMEMDefaultEntity.Bssi_gUserDefaultEntity();
            if BssiDimension <> '' then
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension)
            else
                BssiDimensionForRestriction := BssiMEMSecurityHelper.Bssi_tGetUserSecurityFilterText();
            if BssiMEMSystemSetup.Bssi_iGetGlobalDimensionNoToUse() = 1 then
                BssiMEMDimensionsOneTwoVisible := true
            else
                BssiMEMDimensionsOneTwoVisible := false;
            Empresa.Reset();
            Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
            Empresa.SetFilter(Code, BssiDimension);
            IF (Empresa.FindFirst()) THEN;
        end;

    }

    labels
    {
    }

    trigger OnPostReport()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry";
    begin
        //FeatureTelemetry.LogUsage(format(BssiMEMTelemetryEvents::Reporting), CurrReport.ObjectId(true), 'Reporting');
    end;

    trigger OnPreReport()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry"; // AB#4938
    begin
        // AB#4938
        //FeatureTelemetry.LogUptake(format(BssiMEMTelemetryEvents::Reporting), CurrReport.ObjectId(true), "Feature Uptake Status"::Used);

        //Added By Bssi Developer        
        if BssiMEMSystemSetup.Get() then
            if BSsiMEMSystemSetup.BssiEntityDimension = BSsiMEMSystemSetup.BssiEntityDimension::"Global Dimension 1 Code" then
                "G/L Account".SetFilter("Global Dimension 1 Filter", BssiDimensionForRestriction)
            else
                "G/L Account".SetFilter("Global Dimension 2 Filter", BssiDimensionForRestriction);

        Empresa.Reset();
        Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        Empresa.SetFilter(Code, BssiDimension);
        IF (Empresa.FindFirst()) THEN;
        //End of Added By Bssi Developer
        GLFilter := "G/L Account".GETFILTERS;
        PeriodText := "G/L Account".GETFILTER("Date Filter");
    end;

    var
        Empresa: Record "Dimension Value";
        Text000: Label 'Period: %1';
        GLFilter: Text;
        PeriodText: Text[30];
        Trial_BalanceCaptionLbl: Label 'MEM Trial Balance';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Net_ChangeCaptionLbl: Label 'Net Change';
        BalanceCaptionLbl: Label 'Balance';
        AdditionalNet_ChangeCaptionLbl: Label 'Net Change Additional Currency';
        AdditionalBalanceCaptionLbl: Label 'Balance Additional Currency';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: Label 'Name';
        G_L_Account___Net_Change_CaptionLbl: Label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: Label 'Credit';
        G_L_Account___Balance_at_Date_CaptionLbl: Label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: Label 'Credit';
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMDimensionsOneTwoVisible: Boolean;
        BssiMEMDefaultEntity: record BssiMEMDefaultEntity;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        AccountName: Text;
        UsarNombreCorporativo: Boolean;
        LedgerCode: Text;

    [IntegrationEvent(false, false)]
    local procedure Bssi_RegKeyValidationMEMReports(var Handled: Boolean)
    begin
    end;

}

