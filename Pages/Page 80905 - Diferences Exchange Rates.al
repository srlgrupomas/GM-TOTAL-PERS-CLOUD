page 34006905 "Differences Exchange Rates"
{
    PageType = Worksheet;
    ApplicationArea = All;
    SourceTable = "Gen. Journal Line";
    Permissions = tabledata "G/L Entry" = rimd;

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                field("Es Prueba"; EsPrueba)
                {
                    ApplicationArea = All;
                }
                field("Foreign Exchange Losses"; ForeignExchangeLosses)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Exchange Gains"; CurrencyExchangeGains)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("General Journal Template"; GeneralJournalTemplate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("General Journal Batch"; GeneralJournalBatch)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reclas. Serial No. Cur. Adjus."; "Reclas. Serial No. Cur. Adjus.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date of the transaction in the general ledger, and thereby the fiscal year and period.';
                }
                field("Additional-Currency Posting"; Rec."Additional-Currency Posting")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of posting for the additional currency.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number for the journal line.';
                    Editable = false;
                    ShowMandatory = true;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Editable = false;
                }
                field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the external document number that will be exported in the payment file.';
                    Visible = false;
                    Editable = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';

                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the account number that the entry on the journal line will be posted to.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the entry.';
                }
                field("Payer Information"; Rec."Payer Information")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies payer information that is imported with the bank statement file.';
                    Visible = false;
                }
                field("Transaction Information"; Rec."Transaction Information")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies transaction information that is imported with the bank statement file.';
                    Visible = false;
                }
                field("Business Unit Code"; Rec."Business Unit Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the business unit that the entry derives from in a consolidated company.';
                    Visible = false;
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    AssistEdit = true;
                    ToolTip = 'Specifies the code of the currency for the amounts on the journal line.';
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total amount in local currency (including VAT) that the journal line consists of.';
                    Editable = false;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for the balancing account type that should be used in this journal line.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Editable = false;
                }
                field("GMAEntityCode"; Rec."GMAEntityCode")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(GMAEntity; rec.GMAEntity)
                {
                    ApplicationArea = basic, suite;
                    editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Process")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    GetTransaction();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        GLAccount: Record "G/L Account";
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        GenJournalSetup.Get;

        GLAccount.reset();
        GLAccount.Get(GenJournalSetup."Foreign Exchange Losses");
        ForeignExchangeLosses := GLAccount.Name;

        GLAccount.reset();
        GLAccount.Get(GenJournalSetup."Currency Exchange Gains");
        CurrencyExchangeGains := GLAccount.Name;

        GeneralJournalTemplate := GenJournalSetup."General Journal Template";
        GeneralJournalBatch := GenJournalSetup."General Journal Batch";
        "Reclas. Serial No. Cur. Adjus." := GenJournalSetup."Reclas. Serial No. Cur. Adjus.";
        EsPrueba := True;

        Rec.SetRange("Journal Template Name", GeneralJournalTemplate);
        Rec.SetRange("Journal Batch Name", GeneralJournalBatch);

        if ClientTypeManagement.GetCurrentClientType() in [CLIENTTYPE::SOAP, CLIENTTYPE::OData, CLIENTTYPE::ODataV4] then
            IsSimplePage := false
        else
            IsSimplePage := GenJnlManagement.GetJournalSimplePageModePreference(PAGE::"General Journal");

        CurrPage.Update();
    end;

    procedure GetTransaction();
    var
        GlEntries: Record "G/L Entry";
        NumeroSecuencial: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        DimensionValue: record "Dimension Value";
    begin
        NumeroSecuencial := 0;

        GlEntries.Reset();
        GlEntries.SetRange("G/L Account No.", GenJournalSetup."Foreign Exchange Losses");
        GlEntries.SetRange("Additional-currency Adjusted", false);
        if (GlEntries.FindSet()) then begin
            repeat
                NumeroSecuencial := NumeroSecuencial + 1;

                // Primer registro
                GenJournalLine.Reset();
                GenJournalLine.Init();
                GenJournalLine."Journal Template Name" := GeneralJournalTemplate;
                GenJournalLine."Journal Batch Name" := GeneralJournalBatch;
                GenJournalLine."Line No." := NumeroSecuencial;
                GenJournalLine."Posting Date" := GlEntries."Posting Date";
                GenJournalLine."Document No." := GlEntries."Document No.";
                GenJournalLine."External Document No." := GlEntries."Document No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Account No." := GenJournalSetup."Foreign Exchange Losses";
                GenJournalLine."Document Date" := GlEntries."Document Date";
                GenJournalLine."Description" := 'Reclasif. AXDCambio ' + GlEntries."Document No.";
                GenJournalLine."Currency Code" := 'USD';
                GenJournalLine."Currency Factor" := 1;
                GenJournalLine.Amount := -GlEntries."Additional-Currency Amount";
                GenJournalLine."Amount (LCY)" := -GlEntries."Additional-Currency Amount";
                GenJournalLine."Additional-Currency Posting" := 2;
                GenJournalLine."Shortcut Dimension 1 Code" := GlEntries."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := GlEntries."Global Dimension 2 Code";
                GenJournalLine.GMAEntityCode := GlEntries."Global Dimension 1 Code";
                GenJournalLine."Dimension Set ID" := GlEntries."Dimension Set ID";
                if GenJournalLine.GMAEntityCode <> '' then begin
                    DimensionValue.SetFilter(code, GenJournalLine.GMAEntityCode);
                    DimensionValue.FindFirst();
                    GenJournalLine.GMAEntity := DimensionValue.Name;
                end;
                if GlEntries.BssiEntityID <> '' then
                    GenJournalLine.BssiEntityID := GlEntries.BssiEntityID
                else
                    GenJournalLine.BssiEntityID := GlEntries.GMAEntityCode;

                if EsPrueba = false then begin
                    GenJournalLine."Additional-currency Adjusted" := true;
                    GlEntries."Additional-currency Adjusted" := true;
                    GlEntries.Modify();
                    COMMIT;
                end else begin
                    GenJournalLine."Additional-currency Adjusted" := false;
                    GlEntries."Additional-currency Adjusted" := false;
                    GlEntries.Modify();
                    COMMIT;
                end;

                if (GenJournalLine.Amount <> 0) then
                    GenJournalLine.Insert();

                // Segundo registro
                GenJournalLine.Reset();
                GenJournalLine.Init();
                GenJournalLine."Journal Template Name" := GeneralJournalTemplate;
                GenJournalLine."Journal Batch Name" := GeneralJournalBatch;
                GenJournalLine."Line No." := NumeroSecuencial + 1000;
                GenJournalLine."Posting Date" := GlEntries."Posting Date";
                GenJournalLine."Document No." := GlEntries."Document No.";
                GenJournalLine."External Document No." := GlEntries."Document No.";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Account No." := GenJournalSetup."Currency Exchange Gains";
                GenJournalLine."Document Date" := GlEntries."Document Date";
                GenJournalLine."Description" := 'Reclasif. AXDCambio ' + GlEntries."Document No.";
                GenJournalLine."Currency Code" := 'USD';
                GenJournalLine."Currency Factor" := 1;
                GenJournalLine.Amount := GlEntries."Additional-Currency Amount";
                GenJournalLine."Amount (LCY)" := GlEntries."Additional-Currency Amount";
                GenJournalLine."Additional-Currency Posting" := 2;
                GenJournalLine."Shortcut Dimension 1 Code" := GlEntries."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := GlEntries."Global Dimension 2 Code";
                GenJournalLine.GMAEntityCode := GlEntries."Global Dimension 1 Code";
                GenJournalLine."Dimension Set ID" := GlEntries."Dimension Set ID";
                if GenJournalLine.GMAEntityCode <> '' then begin
                    DimensionValue.SetFilter(code, GenJournalLine.GMAEntityCode);
                    DimensionValue.FindFirst();
                    GenJournalLine.GMAEntity := DimensionValue.Name;
                end;
                if GlEntries.BssiEntityID <> '' then
                    GenJournalLine.BssiEntityID := GlEntries.BssiEntityID
                else
                    GenJournalLine.BssiEntityID := GlEntries.GMAEntityCode;

                if EsPrueba = false then begin
                    GenJournalLine."Additional-currency Adjusted" := true;
                end else begin
                    GenJournalLine."Additional-currency Adjusted" := false;
                end;

                if (GenJournalLine.Amount <> 0) then
                    GenJournalLine.Insert();

            until GlEntries.Next() = 0;
        end;

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Batch Name", GeneralJournalBatch);
        GenJournalLine.SetRange("Journal Template Name", GeneralJournalTemplate);
        if (GenJournalLine.FindSet()) then begin
            repeat
                if EsPrueba = false then begin
                    GenJournalLine.SendToPosting(Codeunit::"Gen. Jnl.-Post");
                    GeneralJournalBatch := GenJournalLine.GetRangeMax("Journal Batch Name");
                    if IsSimplePage then
                        if GenJournalSetup."Post with Job Queue" then
                            NewDocumentNo()
                        else
                            SetDataForSimpleModeOnPost();
                    SetJobQueueVisibility();
                    CurrPage.Update(false);
                end;

            until GenJournalLine.Next() = 0;
        end;

        currpage.Update();
    end;

    procedure NewDocumentNo()
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        GenJournalLine: Record "Gen. Journal Line";
        [SecurityFiltering(SecurityFilter::Filtered)]
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        LastDocNo: Code[20];
    begin
        if Rec.Count = 0 then
            exit;
        GenJnlBatch.Get(Rec."Journal Template Name", GeneralJournalBatch);
        GenJournalLine.Reset();
        GenJournalLine.SetCurrentKey("Document No.");
        GenJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJournalLine.FindLast() then begin
            LastDocNo := GenJournalLine."Document No.";
            LastDocNo := NoSeriesBatch.SimulateGetNextNo(GenJnlBatch."No. Series", Rec."Posting Date", LastDocNo);
        end else
            LastDocNo := NoSeriesBatch.PeekNextNo(GenJnlBatch."No. Series", Rec."Posting Date");

        CurrentDocNo := LastDocNo;
        SetDocumentNumberFilter(CurrentDocNo);
    end;

    local procedure SetDataForSimpleModeOnPost()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        PostedFromSimplePage := true;
        Rec.SetCurrentKey("Document No.", "Line No.");
        if Rec.FindFirst() then
            SetDataForSimpleMode(Rec)
    end;

    local procedure SetJobQueueVisibility()
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        JobQueuesUsed := GenJournalSetup.JobQueueActive();
    end;

    local procedure SetDataForSimpleMode(GenJournalLine1: Record "Gen. Journal Line")
    begin
        CurrentDocNo := GenJournalLine1."Document No.";
        CurrentPostingDate := GenJournalLine1."Posting Date";
        CurrentCurrencyCode := GenJournalLine1."Currency Code";
        SetDocumentNumberFilter(CurrentDocNo);
    end;

    local procedure SetDocumentNumberFilter(DocNoToSet: Code[20])
    var
        OriginalFilterGroup: Integer;
    begin
        OriginalFilterGroup := Rec.FilterGroup;
        Rec.FilterGroup := 25;
        Rec.SetFilter("Document No.", DocNoToSet);
        Rec.FilterGroup := OriginalFilterGroup;
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        GenJournalSetup: Record "General Ledger Setup";
        ForeignExchangeLosses: Code[50];
        CurrencyExchangeGains: Code[50];
        GeneralJournalTemplate: Code[20];
        GeneralJournalBatch: Code[20];
        CurrentDocNo: Code[20];
        "Reclas. Serial No. Cur. Adjus.": Code[20];
        CurrentCurrencyCode: Code[10];
        CurrentPostingDate: Date;
        EsPrueba: Boolean;
        IsSimplePage: Boolean;
        JobQueuesUsed: Boolean;
        JobQueueVisible: Boolean;
        PostedFromSimplePage: Boolean;
}