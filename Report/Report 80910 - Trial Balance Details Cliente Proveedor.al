report 80910 "PersTrial Balance Det Cli/Pro"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/BSSIMEMDetailTrialBalanceCliPro.rdl';
    AdditionalSearchTerms = 'payment due,order status';
    ApplicationArea = Basic, Suite;
    Caption = 'MEM Detail Trial Balance Vendor / Customer';
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
            column(BalanceAccount; "G/L Account"."Balance at Date")
            {
            }
            column(BalanceAccountAddCurr; "G/L Account"."Add.-Currency Balance at Date")
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
                    DataItemTableView = SORTING("G/L Account No.", "Posting Date", "Source No.");
                    column(VATAmount_GLEntry; "VAT Amount")
                    {
                        IncludeCaption = true;
                    }
                    column(DebitAmount_GLEntry; DebitNetChangeEntry)
                    {
                    }
                    column(NombreClienteOProveedor; NombreClienteOProveedor)
                    { }
                    column(NoNombreClienteOProveedor; "Source No.")
                    { }
                    column(Total_Anterior; TotalAnteriorClienteOProveedor)
                    { }
                    column(CreditAmount_GLEntry; CreditNetChangeEntry)
                    {
                    }
                    column(Saldo_Anterior_Credit; SaldoAnteriorCredit)
                    { }
                    column(Saldo_Anterior_Debit; SaldoAnteriorDebit)
                    { }
                    column(AddDebitAmount_GLEntry; DebitNetChangeAddCurrEntry)
                    {
                    }
                    column(AddCreditAmount_GLEntry; CreditNetChangeAddCurrEntry)
                    {
                    }
                    column(Total_Anterior_Add_Curr; TotalAnteriorClienteOProveedorAddCurr)
                    { }
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
                    trigger OnAfterGetRecord()
                    var
                        Customer: Record Customer;
                        Vendor: Record Vendor;
                        glentry: Record "G/L Entry";
                        StartDate: Date;
                    begin
                        NombreClienteOProveedor := '';
                        NoNombreClienteOProveedor := '';
                        if ("Source Type" in ["Source Type"::Customer, "Source Type"::Vendor]) then begin
                            case "Source Type" of
                                "Source Type"::Customer:
                                    if Customer.Get("Source No.") then begin
                                        NombreClienteOProveedor := Customer.Name;
                                        NoNombreClienteOProveedor := Customer."No.";
                                    end;
                                "Source Type"::Vendor:
                                    if Vendor.Get("Source No.") then begin
                                        NombreClienteOProveedor := Vendor.Name;
                                        NoNombreClienteOProveedor := Vendor."No.";
                                    end;
                            end;
                            glentry.Reset();
                            glentry.SetRange("G/L Account No.", "G/L Account No.");
                            glentry.SetRange("Source Type", "Source Type");
                            glentry.SetRange("Source No.", "Source No.");
                            if "G/L Account".GetFilter("Date Filter") <> '' then begin
                                Evaluate(StartDate, "G/L Account".GetFilter("Date Filter"));
                                glentry.SetRange("Posting Date", 0D, StartDate - 1);
                            end else begin
                                glentry.SetRange("Posting Date", 0D, Today - 1);
                            end;
                            TotalAnteriorClienteOProveedor := 0;
                            TotalAnteriorClienteOProveedorAddCurr := 0;
                            if glentry.FindSet() then begin
                                repeat
                                    TotalAnteriorClienteOProveedor += glentry.Amount;
                                    TotalAnteriorClienteOProveedorAddCurr += glentry."Additional-Currency Amount";
                                until glentry.Next() = 0;
                            end;
                        end else begin
                            NombreClienteOProveedor := 'Sin identificar';
                            NoNombreClienteOProveedor := 'UNIDENTIFIED';
                            TotalAnteriorClienteOProveedor := 0;
                            TotalAnteriorClienteOProveedorAddCurr := 0;
                        end;

                        if "G/L Entry".Amount > 0 then begin
                            DebitNetChangeEntry := "G/L Entry"."Amount";
                            CreditNetChangeEntry := 0;
                            DebitNetChangeAddCurrEntry := "G/L Entry"."Additional-Currency Amount";
                            CreditNetChangeAddCurrEntry := 0;
                        end else begin
                            DebitNetChangeEntry := 0;
                            CreditNetChangeEntry := -"G/L Entry"."Amount";
                            DebitNetChangeAddCurrEntry := 0;
                            CreditNetChangeAddCurrEntry := -"G/L Entry"."Additional-Currency Amount";
                        end;

                        /* Bssi Code for Dimension Code */
                        if BssiMEMSystemSetup.Bssi_iGetGlobalDimensionNoToUse() = 1 then
                            Bssi_EntityID := "Global Dimension 1 Code"
                        else
                            Bssi_EntityID := "Global Dimension 2 Code";
                        /* End */

                        if PrintOnlyCorrections then
                            if not (("Debit Amount" < 0) or ("Credit Amount" < 0)) then
                                CurrReport.Skip;
                        if not PrintReversedEntries and Reversed then
                            CurrReport.Skip;

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
                            AccountName := "G/L Account"."GMLocCorporate Account Name"
                        else
                            AccountName := "G/L Account".Name;
                    end;

                    trigger OnPreDataItem()
                    begin
                        NombreClienteOProveedor := '';
                        if BssiMEMSystemSetup.Get() then
                            if BSsiMEMSystemSetup.BssiEntityDimension = BSsiMEMSystemSetup.BssiEntityDimension::"Global Dimension 1 Code" then
                                "G/L Entry".SetFilter("Global Dimension 1 Code", BssiDimensionForRestriction)
                            else
                                "G/L Entry".SetFilter("Global Dimension 2 Code", BssiDimensionForRestriction);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if UsarNombreCorporativo then
                        AccountName := "G/L Account"."GMLocCorporate Account Name"
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
                if BSsiMEMSystemSetup.Get() then
                    if BSsiMEMSystemSetup.BssiEntityDimension = BSsiMEMSystemSetup.BssiEntityDimension::"Global Dimension 1 Code" then
                        SetFilter("Global Dimension 1 Filter", BssiDimensionForRestriction)
                    else
                        SetFilter("Global Dimension 2 Filter", BssiDimensionForRestriction);
                if GLDateFilter <> '' then begin
                    Date.SetRange("Period Type", Date."Period Type"::Date);
                    Date.SetFilter("Period Start", GLDateFilter);
                    if Date.FindFirst then begin
                        SetRange("Date Filter", 0D, ClosingDate(Date."Period Start" - 1));
                        CalcFields("Net Change", "Additional-Currency Net Change");
                        // StartBalance := "Net Change";
                        // AddStartBalance := "Additional-Currency Net Change";
                        SetFilter("Date Filter", GLDateFilter);
                    end;
                end;

                if UsarNombreCorporativo then
                    AccountName := "G/L Account"."GMLocCorporate Account Name"
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
                "G/L Account".SetRange("Trial Balance Vendor/Customer", true);
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
        NoNombreClienteOProveedor: Code[20];
        NombreClienteOProveedor: text[100];
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
        DetailTrialBalCaptionLbl: Label 'MEM Detail Trial Balance Vendor / Customer';
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
        SaldoAnteriorCredit: Decimal;
        SaldoAnteriorDebit: Decimal;
        TotalAnteriorClienteOProveedor: Decimal;
        TotalAnteriorClienteOProveedorAddCurr: Decimal;
        BssiDimension: Text;

        BssiDimensionForRestriction: Text;

        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        Bssi_EntityID: Code[20];
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        AccountName: Text;
        UsarNombreCorporativo: Boolean;
        DebitNetChangeEntry: Decimal;
        CreditNetChangeEntry: Decimal;
        DebitNetChangeAddCurrEntry: Decimal;
        CreditNetChangeAddCurrEntry: Decimal;


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