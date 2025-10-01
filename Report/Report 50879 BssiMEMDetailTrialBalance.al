
report 34006870 PERDetailTrialBalance
{
    // *********************************************************************************
    // Description: Duplicate D365BC Detail Trial Balance (Object ID: 4)
    // Written By : Rajbir
    // ---------------------------------------------------------------------------------
    // Revision History
    // ---------------------------------------------------------------------------------
    // Rev No.  Date                By       Revision Description 
    // ???      July-16-2019     Rajbir     Initial Release 
    // ???      April-01-2020    Divjot     Initial Release (Ver 15.4)
    // 003      20210318         Kuljit     We will not default the entity to the entity filter from system setup as 
    //                                      it is causing the filtering issue when entity filter is empty. Jira: NAVMEM-3092
    // *********************************************************************************
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/BSSIMEMDetailTrialBalance.rdl';
    AdditionalSearchTerms = 'payment due,order status';
    ApplicationArea = Basic, Suite;
    Caption = 'MEM Detail Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Income/Balance", "Debit/Credit", "Date Filter";
            column(PeriodGLDtFilter; StrSubstNo(Text000, GLDateFilter))
            {
            }
            column(CompanyName; Empresa.BssiLegalNameFull)
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(PrintReversedEntries; PrintReversedEntries)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(PrintClosingEntries; PrintClosingEntries)
            {
            }
            column(PrintOnlyCorrections; PrintOnlyCorrections)
            {
            }
            column(GLAccTableCaption; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(No_GLAcc; "No.")
            {
            }
            column(DetailTrialBalCaption; DetailTrialBalCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(OnlyCorrectionsCaption; OnlyCorrectionsCaptionLbl)
            {
            }
            column(NetChangeCaption; NetChangeCaptionLbl)
            {
            }
            column(AddNetChangeCaption; AddNetChangeCaptionLbl)
            {
            }
            column(GLEntryDebitAmtCaption; GLEntryDebitAmtCaptionLbl)
            {
            }
            column(GLEntryCreditAmtCaption; GLEntryCreditAmtCaptionLbl)
            {
            }
            column(GLBalCaption; GLBalCaptionLbl)
            {
            }
            column(BssiDefaultEntity; BssiDimensionForRestriction)
            {
            }
            column(BssiDefaultEntitylbl; BssiMEMSystemSetup.Bssi_tGetEntityLabel(BssiMEMSystemSetup.Bssi_cGetEntityCode()))
            {
            }
            dataitem(PageCounter; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(Name_GLAcc; AccountName)
                {
                }
                column(StartBalance; StartBalance)
                {
                    AutoFormatType = 1;
                }
                column(AddStartBalance; AddStartBalance)
                {
                    AutoFormatType = 1;
                }
                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink = "G/L Account No." = FIELD("No."),
                                   "Posting Date" = FIELD("Date Filter"),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                   "Business Unit Code" = FIELD("Business Unit Filter");
                    DataItemLinkReference = "G/L Account";
                    DataItemTableView = SORTING("G/L Account No.", "Posting Date");
                    column(VATAmount_GLEntry; "VAT Amount")
                    {
                        IncludeCaption = true;
                    }
                    column(DebitAmount_GLEntry; "Debit Amount")
                    {
                    }
                    column(CreditAmount_GLEntry; "Credit Amount")
                    {
                    }
                    column(AddDebitAmount_GLEntry; "G/L Entry"."Add.-Currency Debit Amount")
                    {
                    }
                    column(AddCreditAmount_GLEntry; "G/L Entry"."Add.-Currency Credit Amount")
                    {
                    }
                    column(PostingDate_GLEntry; Format("Posting Date"))
                    {
                    }
                    column(DocumentNo_GLEntry; "Document No.")
                    {
                    }
                    column(ExtDocNo_GLEntry; "External Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_GLEntry; Description)
                    {
                    }
                    column(GLBalance; GLBalance)
                    {
                        AutoFormatType = 1;
                    }
                    column(AddGLBalance; AddGLBalance)
                    {
                        AutoFormatType = 1;
                    }
                    column(EntryNo_GLEntry; "Entry No.")
                    {
                    }
                    column(ClosingEntry; ClosingEntry)
                    {
                    }
                    column(Reversed_GLEntry; Reversed)
                    {
                    }
                    column(BssiEntityID; Bssi_EntityID)
                    {
                    }
                    column(DatoDescriptivo; DatoDescriptivo)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        /* Bssi Code for Dimension Code */
                        if BssiMEMSystemSetup.Bssi_iGetGlobalDimensionNoToUse() = 1 then
                            Bssi_EntityID := "Global Dimension 1 Code"
                        else
                            Bssi_EntityID := "Global Dimension 2 Code";
                        /* End */

                        IF PrintOnlyCorrections THEN
                            IF NOT (("Debit Amount" < 0) OR ("Credit Amount" < 0)) THEN
                                CurrReport.SKIP;
                        IF NOT PrintReversedEntries AND Reversed THEN
                            CurrReport.SKIP;

                        GLBalance := GLBalance + Amount;
                        AddGLBalance := AddGLBalance + "Additional-Currency Amount";

                        if ("Posting Date" = ClosingDate("Posting Date")) and
                           not PrintClosingEntries
                        then begin
                            "Debit Amount" := 0;
                            "Credit Amount" := 0;
                            "Add.-Currency Credit Amount" := 0;
                            "Add.-Currency Debit Amount" := 0;
                        end;

                        if "Posting Date" = ClosingDate("Posting Date") then
                            ClosingEntry := true
                        else
                            ClosingEntry := false;

                        if UsarNombreCorporativo then
                            AccountName := "G/L Account"."GMACorporate Account Name"
                        else
                            AccountName := "G/L Account".Name;



                        if ("GMADocument Type Loc." = "GMADocument Type Loc."::GMATransferencia) then
                            DatoDescriptivo := ' Transferencia a cuenta: ' + "G/L Entry"."PERNombre Cuenta Corporacion";
                        if "GMADocument Type Loc." = "GMADocument Type Loc."::GMARecibo then
                            DatoDescriptivo := ' Recibo al cliente: ' + "G/L Entry"."PERNombre Cliente";
                        if "GMADocument Type Loc." = "GMADocument Type Loc."::"Payment" then
                            DatoDescriptivo := ' Pago al proveedor: ' + "G/L Entry"."PERNombre Proveedor";
                    end;

                    trigger OnPreDataItem()
                    begin
                        GLBalance := StartBalance;
                        AddGLBalance := AddStartBalance;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    // CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnly or (StartBalance = 0);
                    if UsarNombreCorporativo then
                        AccountName := "G/L Account"."GMACorporate Account Name"
                    else
                        AccountName := "G/L Account".Name;
                end;
            }

            trigger OnAfterGetRecord()
            var
                GLEntry: Record "G/L Entry";
                Date: Record Date;
            begin
                StartBalance := 0;
                AddStartBalance := 0;
                //Added By Bssi Developer        
                if BSsiMEMSystemSetup.Get() then
                    if BSsiMEMSystemSetup.BssiEntityDimension = BSsiMEMSystemSetup.BssiEntityDimension::"Global Dimension 1 Code" then
                        SetFilter("Global Dimension 1 Filter", BssiDimensionForRestriction)
                    else
                        SetFilter("Global Dimension 2 Filter", BssiDimensionForRestriction);
                //End of Added By Bssi Developer
                IF GLDateFilter <> '' THEN BEGIN
                    Date.SETRANGE("Period Type", Date."Period Type"::Date);
                    Date.SETFILTER("Period Start", GLDateFilter);
                    IF Date.FINDFIRST THEN BEGIN
                        SETRANGE("Date Filter", 0D, CLOSINGDATE(Date."Period Start" - 1));
                        CALCFIELDS("Net Change", "Additional-Currency Net Change");
                        StartBalance := "Net Change";
                        AddStartBalance := "Additional-Currency Net Change";
                        SetFilter("Date Filter", GLDateFilter);
                    end;
                end;

                if UsarNombreCorporativo then
                    AccountName := "G/L Account"."GMACorporate Account Name"
                else
                    AccountName := "G/L Account".Name;

                IF PrintOnlyOnePerPage THEN BEGIN
                    GLEntry.RESET;
                    GLEntry.SETRANGE("G/L Account No.", "No.");
                    // IF CurrReport.PrintOnlyIfDetail AND GLEntry.FINDFIRST THEN
                    //     PageGroupNo := PageGroupNo + 1;
                    if GLEntry.FindFirst() then
                        PageGroupNo := PageGroupNo + 1;
                end;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        //[x]: Get Context Link
        //ContextSensitiveHelpPage = 'MEM/enduser/RptTBDetail.htm';
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPageperGLAcc; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per G/L Acc.';
                        ToolTip = 'Specifies if each G/L account information is printed on a new page if you have chosen two or more G/L accounts to be included in the report.';
                    }
                    field(ExcludeGLAccsHaveBalanceOnly; ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude G/L Accs. That Have a Balance Only';
                        MultiLine = true;
                        ToolTip = 'Specifies if you do not want the report to include entries for G/L accounts that have a balance but do not have a net change during the selected time period.';
                    }
                    field(InclClosingEntriesWithinPeriod; PrintClosingEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Closing Entries Within the Period';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want the report to include closing entries. This is useful if the report covers an entire fiscal year. Closing entries are listed on a fictitious date between the last day of one fiscal year and the first day of the next one. They have a C before the date, such as C123194. If you do not select this field, no closing entries are shown.';
                    }
                    field(IncludeReversedEntries; PrintReversedEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Reversed Entries';
                        ToolTip = 'Specifies if you want to include reversed entries in the report.';
                    }
                    field(PrintCorrectionsOnly; PrintOnlyCorrections)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Corrections Only';
                        ToolTip = 'Specifies if you want the report to show only the entries that have been reversed and their matching correcting entries.';
                    }
                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        ToolTip = 'Select the Entity to restrict the report.';
                        Importance = Promoted;

                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
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
            //V17 Fix  //003
            // if BssiDimension = '' then
            //     BssiDimension := BssiMEMDefaultEntity.Bssi_gUserDefaultEntity();
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
        PostingDateCaption = 'Posting Date';
        DocNoCaption = 'Document No.';
        DescCaption = 'Description';
        VATAmtCaption = 'VAT Amount';
        EntryNoCaption = 'Entry No.';
    }

    trigger OnPreReport()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry"; // AB#4938
    begin
        // AB#4938
        //FeatureTelemetry.LogUptake(format(BssiMEMTelemetryEvents::Reporting), CurrReport.ObjectId(true), "Feature Uptake Status"::Used);
        GLFilter := "G/L Account".GetFilters;
        GLDateFilter := "G/L Account".GetFilter("Date Filter");
    end;
    // AB#4938
    trigger OnPostReport()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry";
    begin
        //FeatureTelemetry.LogUsage(format(BssiMEMTelemetryEvents::Reporting), CurrReport.ObjectId(true), 'Reporting');
    end;

    var
        Empresa: Record "Dimension Value";
        Text000: Label 'Period: %1';
        GLDateFilter: Text;
        GLFilter: Text;
        GLBalance: Decimal;
        AddGLBalance: Decimal;
        StartBalance: Decimal;
        AddStartBalance: Decimal;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        PrintClosingEntries: Boolean;
        PrintOnlyCorrections: Boolean;
        PrintReversedEntries: Boolean;
        PageGroupNo: Integer;
        ClosingEntry: Boolean;
        DetailTrialBalCaptionLbl: Label 'MEM Detail Trial Balance';
        PageCaptionLbl: Label 'Page';
        BalanceCaptionLbl: Label 'This also includes general ledger accounts that only have a balance.';
        PeriodCaptionLbl: Label 'This report also includes closing entries within the period.';
        OnlyCorrectionsCaptionLbl: Label 'Only corrections are included.';
        NetChangeCaptionLbl: Label 'Net Change';
        AddNetChangeCaptionLbl: Label 'Net Change-Additional Currency ';
        GLEntryDebitAmtCaptionLbl: Label 'Debit';
        GLEntryCreditAmtCaptionLbl: Label 'Credit';
        GLBalCaptionLbl: Label 'Balance';
        BssiMEMSystemSetup: Record BssiMEMSystemSetup;
        BssiMEMDimensionsOneTwoVisible: Boolean;
        BssiMEMDefaultEntity: record BssiMEMDefaultEntity;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;

        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        Bssi_EntityID: Code[20];
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        AccountName: Text;
        UsarNombreCorporativo: Boolean;
        DatoDescriptivo: Text;


    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean; NewPrintClosingEntries: Boolean; NewPrintReversedEntries: Boolean; NewPrintOnlyCorrections: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        ExcludeBalanceOnly := NewExcludeBalanceOnly;
        PrintClosingEntries := NewPrintClosingEntries;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintOnlyCorrections := NewPrintOnlyCorrections;
    end;

    [IntegrationEvent(false, false)]
    local procedure Bssi_RegKeyValidationMEMReports(var Handled: Boolean)
    begin
    end;
}
