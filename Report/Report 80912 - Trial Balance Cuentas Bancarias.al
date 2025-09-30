report 80912 "PersTrial Balance Bank Acc"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/BssiMEMTrialBalanceBankAcc.rdl';
    AdditionalSearchTerms = 'year closing,close accounting period,close fiscal year';
    ApplicationArea = Basic, Suite;
    Caption = 'Trial Balance Bank Account';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("GMLocCash/Bank Account item"; "GMLocCash/Bank Account")
        {
            DataItemTableView = SORTING("GMLocNo.");
            RequestFilterFields = "GMLocNo.", "GMLocAccount Type", "GMLocGlobal Dimension 1", "GMLocGlobal Dimension 2";

            column(Cash_Bank_Account_No; "GMLocCash/Bank Account item"."GMLocNo.") { }
            column(Cash_Bank_Account_Description; "GMLocCash/Bank Account item".GMLocDescription) { }
            column(GMLocRemaining_Amount_Bank_Acc; "GMLocCash/Bank Account item"."GMLocSaldo Pendiente") { }
            column(BssiDimension; "GMLocCash/Bank Account item".BssiGetMEMEntityDimValue()) { }

            dataitem("GMLocValues Entry"; "GMLocValues Entry")
            {
                DataItemTableView = SORTING("GMLocEntry No.");
                DataItemLinkReference = "GMLocCash/Bank Account item";
                DataItemLink = "GMLocCash/Bank Account" = field("GMLocNo.");

                column(GMLocPosting_Date; "GMLocValues Entry"."GMLocPosting Date") { }
                column(GMLocDocument_No_; ReportDocumentNo) { }
                column(GMLocExternal_Document_No_; ReportExternalDocumentNo) { }
                column(GMLocDescription; ReportDescription) { }
                column(GMLocRemaining_Amount_Neg; -"GMLocValues Entry".GMLocAmount) { }
                column(GMLocRemaining_Amount_Pos; "GMLocValues Entry".GMLocAmount) { }
                column(RunningBalance; RunningBalance) { }

                trigger OnAfterGetRecord()
                var
                    Vendor: Record Vendor;
                    Customer: Record Customer;
                    BankAccount: Record "Bank Account";
                    GLAccount: Record "G/L Account";
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    // Inicializar variables temporales
                    ReportDescription := "GMLocValues Entry".GMLocDescription;
                    ReportExternalDocumentNo := "GMLocValues Entry"."GMLocExternal Document No.";
                    ReportDocumentNo := PADSTR("GMLocValues Entry"."GMLocDocument No.", 13, '0');

                    // Lógica para "Payment" o "Pago"
                    // if ("GMLocValues Entry"."GMLocDocument Type" ="GMLocValues Entry"."GMLocDocument Type"::Pago ) then begin
                    //     if Vendor.Get("GMLocValues Entry"."GMLocSource No.") then
                    //         ReportDescription := Vendor.Name;
                    //     VendorLedgerEntry.SetRange("GMLocDocument No.", "GMLocValues Entry"."GMLocDocument No.");
                    //     if VendorLedgerEntry.FindFirst() then
                    //         ReportExternalDocumentNo := VendorLedgerEntry."External Document No.";
                    // end;

                    // Lógica para "Receipt" o "Recibo"
                    if ("GMLocValues Entry"."GMLocDocument Type" = "GMLocValues Entry"."GMLocDocument Type"::Recibo) then begin
                        CustLedgerEntry.Reset();
                        CustLedgerEntry.SetRange("Document No.", "GMLocValues Entry"."GMLocDocument No.");
                        if CustLedgerEntry.FindFirst() then begin
                            ReportExternalDocumentNo := CustLedgerEntry."External Document No.";
                            ReportDescription := CustLedgerEntry."Customer Name";
                        end;
                    end;

                    // Lógica para "Transfer" o "Transferencia"
                    // if ("GMLocValues Entry"."GMLocDocument Type" = "GMLocValues Entry"."GMLocDocument Type"::Transferencia) then begin
                    //     if "GMLocValues Entry".GMLocAmount > 0 then begin
                    //         if BankAccount.Get("GMLocValues Entry"."GMLocSource No.") then
                    //             ReportDescription := BankAccount.Name;
                    //     end else begin
                    //         if BankAccount.Get("GMLocValues Entry"."GMLocDestination") then
                    //             ReportDescription := BankAccount.Name;
                    //     end;
                    // end;

                    // Lógica para "Ingreso/Egreso"
                    if "GMLocValues Entry"."GMLocDocument Type" = "GMLocValues Entry"."GMLocDocument Type"::"Ing/Egreso" then begin
                        GLAccount.Reset();
                        GLAccount.SetRange("Trial Balance Bank Account", true);
                        GLAccount.setrange("No.", "GMLocValues Entry"."GMLocGL Account");
                        if GLAccount.FindFirst() then
                            ReportDescription := GLAccount.Name;
                    end;

                    // Actualizar RunningBalance (ya existente)
                    if "GMLocValues Entry".GMLocAmount > 0 then
                        RunningBalance := RunningBalance + -"GMLocValues Entry".GMLocAmount
                    else if -"GMLocValues Entry".GMLocAmount > 0 then
                        RunningBalance := RunningBalance + "GMLocValues Entry".GMLocAmount;
                end;

                trigger OnPreDataItem()
                begin
                    RunningBalance := "GMLocCash/Bank Account item"."GMLocSaldo Pendiente";
                end;
            }

            trigger OnPreDataItem()
            begin
                if BssiMEMSystemSetup.Get() then
                    if BSsiMEMSystemSetup.BssiEntityDimension = BSsiMEMSystemSetup.BssiEntityDimension::"Global Dimension 1 Code" then
                        "GMLocCash/Bank Account item".SetFilter("GMLocGlobal Dimension 1", BssiDimension)
                    else
                        "GMLocCash/Bank Account item".SetFilter("GMLocGlobal Dimension 2", BssiDimension);
                RunningBalance := "GMLocCash/Bank Account item"."GMLocSaldo Pendiente";
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
                        ApplicationArea = all;
                        TableRelation = "GRP Ledger Code";
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
            FeatureTelemetry: Codeunit "Feature Telemetry";
        begin
            Bssi_RegKeyValidationMEMReports(Bssi_Handled);
            if Bssi_Handled then
                Error('');
            BssiMEMSingleInstanceCU.Bssi_SetCurrentHeaderEntity('');
            BssiMEMSingleInstanceCU.Bssi_SetCurrentEntity('');
            BssiMEMSystemSetup.Get();
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

    trigger OnPreReport()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry"; // AB#4938
    begin
        // AB#4938
        //FeatureTelemetry.LogUptake(format(BssiMEMTelemetryEvents::Reporting), CurrReport.ObjectId(true), "Feature Uptake Status"::Used);

        //Added By Bssi Developer        
        if BssiMEMSystemSetup.Get() then
            if BSsiMEMSystemSetup.BssiEntityDimension = BSsiMEMSystemSetup.BssiEntityDimension::"Global Dimension 1 Code" then
                "GMLocCash/Bank Account item".SetFilter("GMLocGlobal Dimension 1", BssiDimension)
            else
                "GMLocCash/Bank Account item".SetFilter("GMLocGlobal Dimension 2", BssiDimension);
        Empresa.Reset();
        Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        Empresa.SetFilter(Code, BssiDimension);
        IF (Empresa.FindFirst()) THEN;
    end;

    var
        StartingBalance: Decimal;
        TotalNetChange: Decimal;
        RunningBalance: Decimal;
        Empresa: Record "Dimension Value";
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        BssiDimension: Text;
        BssiDimensionForRestriction: Text;
        BssiMEMSystemSetup: Record BssiMEMSystemSetup;
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        BssiMEMDimensionsOneTwoVisible: Boolean;
        BssiMEMDefaultEntity: Record BssiMEMDefaultEntity;
        BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        AccountName: Text;
        UsarNombreCorporativo: Boolean;
        LedgerCode: Code[20];
        GlobalNetAmount: Decimal;
        glentry: Record "G/L Entry";
        prueba: Code[20];
        LastSourceNo: Code[20];
        LastSourceType: Option;
        ReportDescription: Text;
        ReportExternalDocumentNo: Code[20];
        ReportDocumentNo: Code[20];

    [IntegrationEvent(false, false)]
    local procedure Bssi_RegKeyValidationMEMReports(var Handled: Boolean)
    begin
    end;
}