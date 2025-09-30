Codeunit 80900 PERExchRateAdjmtProcess
{
    TableNo = "Exch. Rate Adjmt. Parameters";
    Permissions = TableData "Exch. Rate Adjmt. Reg." = rimd,
                  TableData "Exch. Rate Adjmt. Ledg. Entry" = rimd,
                  TableData "VAT Entry" = rimd;

    var
        VATEntryTotalBase: Record "VAT Entry";
        GLSetup: Record "General Ledger Setup";
        ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters";
        CurrExchRate2: Record "Currency Exchange Rate";
        BssiMEMSystemSetup: Record BssiMEMSystemSetup;
        ExchRateAdjmtReg: Record "Exch. Rate Adjmt. Reg.";
        AddRepCurrency: Record Currency;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        AddCurrCurrencyFactor: Decimal;
        ExchangeRateAdjmtMustBeErr: Label '%1 on %2 %3 must be %4. When this %2 is used in %5, the exchange rate adjustment is defined in the %6 field in the %7. %2 %3 is used in the %8 field in the %5. ', Comment = '%1, %2, &%3, %4, %5, %6, %7, %8 - field names';
        GLSetupRead: Boolean;
        Window: Dialog;
        GLAmtTotal: Decimal;
        GLAddCurrNetChangeTotal: Decimal;
        GLNetChangeBase: Decimal;
        GLAddCurrAmtTotal: Decimal;
        GLNetChangeTotal: Decimal;
        GLAddCurrNetChangeBase: Decimal;
        ProcessEntity: Code[20];
        AdjustingVATEntriesTxt: Label 'Adjusting VAT Entries...\\';
        VATEntryProgressBarTxt: Label 'VAT Entry    @1@@@@@@@@@@@@@';
        AdjustingGeneralLedgerTxt: Label 'Adjusting general ledger...\\';
        GLAccountProgressBarTxt: Label 'G/L Account    @1@@@@@@@@@@@@@';

    trigger OnRun()
    var
        DimensionValue: Record "Dimension Value";
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        RatesAdjustedMsg: Label 'One or more currency exchange rates have been adjusted.';
        LastRegNo: Integer;
    begin
        ExchRateAdjmtParameters.Copy(Rec);
        if not ExchRateAdjmtParameters."Adjust G/L Accounts" then exit;
        BssiGetGLSetup();
        if ExchRateAdjmtReg.FindLast() then
            LastRegNo := ExchRateAdjmtReg."No.";

        BssiSetAdditionalReportingCurrency();
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
        DimensionValue.SetRange("Global Dimension No.", BssiMEMSystemSetup.Bssi_iGetGlobalDimensionNoToUse());
        DimensionValue.SetFilter(Code, BssiMEMSingleInstanceCU.BssiGetExchangeRateAdjEntity());

        if DimensionValue.FindSet() then
            repeat
                ProcessEntity := DimensionValue.Code;
                if GLSetup."VAT Exchange Rate Adjustment" <> GLSetup."VAT Exchange Rate Adjustment"::"No Adjustment"
                        then
                    BssiMEMAdjustVAT();

                BssiMEMAdjustGLAccounts();
            until DimensionValue.Next() = 0;

        if ExchRateAdjmtParameters."Preview Posting" then exit;

        if GenJnlPostLine.IsGLEntryInconsistent() then
            GenJnlPostLine.ShowInconsistentEntries()
        else
            if not ExchRateAdjmtParameters."Hide UI" then
                if ExchRateAdjmtReg."No." > LastRegNo then begin
                    BssiMEMSingleInstanceCU.BssiSetExchangeRateAdjHideUI(true);
                    Message(RatesAdjustedMsg);
                end;
    end;

    internal procedure BssiMEMAdjustVAT()
    var
        VATEntry: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        VATEntryNoTotal: Decimal;
        VATEntryNo: Decimal;
    begin
        Window.Open(AdjustingVATEntriesTxt + VATEntryProgressBarTxt);
        VATEntryNoTotal := VATEntry.Count();
        BssiSetVATEntryFilters(VATEntry, ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        if VATPostingSetup.FindSet() then
            repeat
                VATEntryNo := VATEntryNo + 1;
                Window.Update(1, Round(VATEntryNo / VATEntryNoTotal * 10000, 1));
                BssiProcessVATAdjustment(VATPostingSetup);
            until VATPostingSetup.Next() = 0;
    end;

    internal procedure BssiMEMAdjustGLAccounts()
    var
        GLAccount: Record "G/L Account";
        GLAccNo: Decimal;
        GLAccNoTotal: Decimal;
    begin
        Window.Open(AdjustingGeneralLedgerTxt + GLAccountProgressBarTxt);
        GLAccNo := 0;
        GLAccNoTotal := GLAccount.Count();
        GLAccount.SetRange("Date Filter", ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            GLAccount.SetRange("Global Dimension 1 Filter", ProcessEntity)
        else
            GLAccount.SetRange("Global Dimension 2 Filter", ProcessEntity);
        if GLAccount.FindSet() then
            repeat
                GLAccNo := GLAccNo + 1;
                Window.Update(1, Round(GLAccNo / GLAccNoTotal * 10000, 1));
                if GLAccount."Exchange Rate Adjustment" <> GLAccount."Exchange Rate Adjustment"::"No Adjustment" then
                    BssiProcessGLAccountAdjustment(GLAccount);
            until GLAccount.Next() = 0;
        BssiPostGLAccAdjmtTotalotal();
    end;

    local procedure BssiProcessGLAccountAdjustment(var GLAccount: Record "G/L Account")
    begin
        if GLAccount."Exchange Rate Adjustment" = GLAccount."Exchange Rate Adjustment"::"No Adjustment" then
            exit;

        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        GLAccount.CalcFields("Net Change", "Additional-Currency Net Change");
        BssiMEMOnProcessGLAccountAdjustmentOnBeforePostGLAccAdjmt(GLAccount);
        case GLAccount."Exchange Rate Adjustment" of
            GLAccount."Exchange Rate Adjustment"::"Adjust Amount":
                BssiPostGLAccAdjmt(
                    GLAccount."No.", GLAccount."Exchange Rate Adjustment"::"Adjust Amount",
                    Round(
                    CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                        ExchRateAdjmtParameters."Posting Date", BssiGetAdditionalReportingCurrency(),
                        GLAccount."Additional-Currency Net Change", AddCurrCurrencyFactor) -
                    GLAccount."Net Change"),
                    GLAccount."Net Change",
                    GLAccount."Additional-Currency Net Change");
            GLAccount."Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                BssiPostGLAccAdjmt(
                    GLAccount."No.", GLAccount."Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                    Round(
                    CurrExchRate2.ExchangeAmtLCYToFCY(
                        ExchRateAdjmtParameters."Posting Date", BssiGetAdditionalReportingCurrency(),
                        GLAccount."Net Change", AddCurrCurrencyFactor) -
                    GLAccount."Additional-Currency Net Change",
                    AddRepCurrency."Amount Rounding Precision"),
                    GLAccount."Net Change",
                    GLAccount."Additional-Currency Net Change");
        end;
    end;

    local procedure BssiPostGLAccAdjmtTotalotal()
    var
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        GenJnlLine.Init();
        GenJnlLine."Document No." := ExchRateAdjmtParameters."Document No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Posting Date" := ExchRateAdjmtParameters."Posting Date";
        GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        GenJnlLine."System-Created Entry" := true;

        if GLAmtTotal <> 0 then begin
            if GLAmtTotal < 0 then
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLLossesAccount()
            else
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLGainsAccount();
            GenJnlLine.Description :=
                StrSubstNo(ExchRateAdjmtParameters."Posting Description", BssiGetAdditionalReportingCurrency(), GLAddCurrNetChangeTotal);
            GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
            GenJnlLine."Currency Code" := '';
            GenJnlLine.Amount := -GLAmtTotal;
            GenJnlLine."Amount (LCY)" := -GLAmtTotal;
            GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
            GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
            BssiGetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
            BssiAssignMEMEntity(GenJnlLine, TempDimSetEntry);
            BssiPostGenJnlLine(GenJnlLine, TempDimSetEntry);
        end;
        if GLAddCurrAmtTotal <> 0 then begin
            if GLAddCurrAmtTotal < 0 then
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLLossesAccount()
            else
                GenJnlLine."Account No." := AddRepCurrency.GetRealizedGLGainsAccount();
            GenJnlLine.Description := StrSubstNo(ExchRateAdjmtParameters."Posting Description", '', GLNetChangeTotal);
            GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
            GenJnlLine."Currency Code" := BssiGetAdditionalReportingCurrency();
            GenJnlLine.Amount := -GLAddCurrAmtTotal;
            GenJnlLine."Amount (LCY)" := 0;
            GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
            GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
            BssiGetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
            BssiAssignMEMEntity(GenJnlLine, TempDimSetEntry);
            BssiPostGenJnlLine(GenJnlLine, TempDimSetEntry);
        end;

        if (GLAmtTotal <> 0) or (GLAddCurrAmtTotal <> 0) then begin
            ExchRateAdjmtReg."No." := ExchRateAdjmtReg."No." + 1;
            ExchRateAdjmtReg."Creation Date" := ExchRateAdjmtParameters."Posting Date";
            ExchRateAdjmtReg."Account Type" := ExchRateAdjmtReg."Account Type"::"G/L Account";
            ExchRateAdjmtReg."Posting Group" := '';
            ExchRateAdjmtReg."Currency Code" := BssiGetAdditionalReportingCurrency();
            ExchRateAdjmtReg."Currency Factor" := CurrExchRate2."Adjustment Exch. Rate Amount";
            ExchRateAdjmtReg."Adjusted Base" := 0;
            ExchRateAdjmtReg."Adjusted Base (LCY)" := GLNetChangeBase;
            ExchRateAdjmtReg."Adjusted Amt. (LCY)" := GLAmtTotal;
            ExchRateAdjmtReg."Adjusted Base (Add.-Curr.)" := GLAddCurrNetChangeBase;
            ExchRateAdjmtReg."Adjusted Amt. (Add.-Curr.)" := GLAddCurrAmtTotal;
            ExchRateAdjmtReg.Insert();
        end;
        GLAmtTotal := 0;
        GLAddCurrNetChangeTotal := 0;
        GLAddCurrAmtTotal := 0;
        GLNetChangeTotal := 0;
    end;

    local procedure BssiAssignMEMEntity(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        GenJnlLine.BssiEntityID := ProcessEntity;
        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then begin
            GenJnlLine."Shortcut Dimension 1 Code" := ProcessEntity;
            DimMgt.ValidateShortcutDimValues(1, GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Dimension Set ID");
        end
        else begin
            GenJnlLine."Shortcut Dimension 2 Code" := ProcessEntity;
            DimMgt.ValidateShortcutDimValues(2, GenJnlLine."Shortcut Dimension 2 Code", GenJnlLine."Dimension Set ID");
        end;
        DimMgt.GetDimensionSet(DimSetEntry, GenJnlLine."Dimension Set ID");
    end;

    local procedure BssiSetVATEntryFilters(var VATEntry: Record "VAT Entry"; StartDate: Date; EndDate: Date)
    begin
        if not
            VATEntry.SetCurrentKey(
                Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date")
        then
            VATEntry.SetCurrentKey(
                Type, Closed, "Tax Jurisdiction Code", "Use Tax", "Posting Date");
        VATEntry.SetRange(Closed, false);
        VATEntry.SetRange("Posting Date", StartDate, EndDate);
        BssiMEMOnAfterSetVATEntryFilters(VATEntry);
    end;

    local procedure BssiProcessVATAdjustment(var VATPostingSetup: Record "VAT Posting Setup")
    var
        TotalVATEntry: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATEntry: Record "VAT Entry";
    begin
        VATEntry.SetRange("VAT Bus. Posting Group", VATPostingSetup."VAT Bus. Posting Group");
        VATEntry.SetRange("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");

        if VATPostingSetup."VAT Calculation Type" <> "Tax Calculation Type"::"Sales Tax" then begin
            BssiAdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Purchase, false);
            if (TotalVATEntry.Amount <> 0) or (TotalVATEntry."Additional-Currency Amount" <> 0) then begin
                BssiAdjustVATAccount(
                    VATPostingSetup.GetPurchAccount(false),
                    TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
                    VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
                if VATPostingSetup."VAT Calculation Type" = "Tax Calculation Type"::"Reverse Charge VAT" then
                    BssiAdjustVATAccount(
                        VATPostingSetup.GetRevChargeAccount(false),
                        -TotalVATEntry.Amount, -TotalVATEntry."Additional-Currency Amount",
                        -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
            end;
            if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
                (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
            then begin
                VATPostingSetup.TestField("Unrealized VAT Type");
                BssiAdjustVATAccount(
                    VATPostingSetup.GetPurchAccount(true),
                    TotalVATEntry."Remaining Unrealized Amount",
                    TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                    VATEntryTotalBase."Remaining Unrealized Amount",
                    VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                if VATPostingSetup."VAT Calculation Type" = "Tax Calculation Type"::"Reverse Charge VAT" then
                    BssiAdjustVATAccount(
                        VATPostingSetup.GetRevChargeAccount(true),
                        -TotalVATEntry."Remaining Unrealized Amount",
                        -TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                        -VATEntryTotalBase."Remaining Unrealized Amount",
                        -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            end;

            BssiAdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Sale, false);
            if (TotalVATEntry.Amount <> 0) or (TotalVATEntry."Additional-Currency Amount" <> 0) then
                BssiAdjustVATAccount(
                    VATPostingSetup.GetSalesAccount(false),
                    TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
                    VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
            if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
                (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
            then begin
                VATPostingSetup.TestField("Unrealized VAT Type");
                BssiAdjustVATAccount(
                    VATPostingSetup.GetSalesAccount(true),
                    TotalVATEntry."Remaining Unrealized Amount",
                    TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                    VATEntryTotalBase."Remaining Unrealized Amount",
                    VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            end;
        end else begin
            if TaxJurisdiction.Find('-') then
                repeat
                    VATEntry.SetRange("Tax Jurisdiction Code", TaxJurisdiction.Code);
                    BssiAdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Purchase, false);
                    BssiAdjustPurchTax(TaxJurisdiction, TotalVATEntry, false);
                    BssiAdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Purchase, true);
                    BssiAdjustPurchTax(TaxJurisdiction, TotalVATEntry, true);
                    BssiAdjustVATEntries(VATEntry, TotalVATEntry, VATEntry.Type::Sale, false);
                    BssiAdjustSalesTax(TaxJurisdiction, TotalVATEntry);
                until TaxJurisdiction.Next() = 0;
            VATEntry.SetRange("Tax Jurisdiction Code");
        end;
        Clear(VATEntryTotalBase);
    end;

    local procedure BssiAdjustVATEntries(var VATEntry: Record "VAT Entry"; var TotalVATEntry: Record "VAT Entry"; VATType: Enum "General Posting Type"; UseTax: Boolean)
    begin
        Clear(TotalVATEntry);
        VATEntry.SetRange(Type, VATType);
        VATEntry.SetRange("Use Tax", UseTax);
        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
            VATEntry.SetRange("Bssi Shortcut Dimension 1 Code", ProcessEntity)
        else
            VATEntry.SetRange("Bssi Shortcut Dimension 2 Code", ProcessEntity);
        if VATEntry.Find('-') then
            repeat
                BssiAccumulate(TotalVATEntry.Base, VATEntry.Base);
                BssiAccumulate(TotalVATEntry.Amount, VATEntry.Amount);
                BssiAccumulate(TotalVATEntry."Unrealized Amount", VATEntry."Unrealized Amount");
                BssiAccumulate(TotalVATEntry."Unrealized Base", VATEntry."Unrealized Base");
                BssiAccumulate(TotalVATEntry."Remaining Unrealized Amount", VATEntry."Remaining Unrealized Amount");
                BssiAccumulate(TotalVATEntry."Remaining Unrealized Base", VATEntry."Remaining Unrealized Base");
                BssiAccumulate(TotalVATEntry."Additional-Currency Amount", VATEntry."Additional-Currency Amount");
                BssiAccumulate(TotalVATEntry."Additional-Currency Base", VATEntry."Additional-Currency Base");
                BssiAccumulate(TotalVATEntry."Add.-Currency Unrealized Amt.", VATEntry."Add.-Currency Unrealized Amt.");
                BssiAccumulate(TotalVATEntry."Add.-Currency Unrealized Base", VATEntry."Add.-Currency Unrealized Base");
                BssiAccumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                BssiAccumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Base", VATEntry."Add.-Curr. Rem. Unreal. Base");

                BssiAccumulate(VATEntryTotalBase.Base, VATEntry.Base);
                BssiAccumulate(VATEntryTotalBase.Amount, VATEntry.Amount);
                BssiAccumulate(VATEntryTotalBase."Unrealized Amount", VATEntry."Unrealized Amount");
                BssiAccumulate(VATEntryTotalBase."Unrealized Base", VATEntry."Unrealized Base");
                BssiAccumulate(VATEntryTotalBase."Remaining Unrealized Amount", VATEntry."Remaining Unrealized Amount");
                BssiAccumulate(VATEntryTotalBase."Remaining Unrealized Base", VATEntry."Remaining Unrealized Base");
                BssiAccumulate(VATEntryTotalBase."Additional-Currency Amount", VATEntry."Additional-Currency Amount");
                BssiAccumulate(VATEntryTotalBase."Additional-Currency Base", VATEntry."Additional-Currency Base");
                BssiAccumulate(VATEntryTotalBase."Add.-Currency Unrealized Amt.", VATEntry."Add.-Currency Unrealized Amt.");
                BssiAccumulate(VATEntryTotalBase."Add.-Currency Unrealized Base", VATEntry."Add.-Currency Unrealized Base");
                BssiAccumulate(VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                BssiAccumulate(VATEntryTotalBase."Add.-Curr. Rem. Unreal. Base", VATEntry."Add.-Curr. Rem. Unreal. Base");

                BssiAdjustVATAmount(VATEntry.Base, VATEntry."Additional-Currency Base");
                BssiAdjustVATAmount(VATEntry.Amount, VATEntry."Additional-Currency Amount");
                BssiAdjustVATAmount(VATEntry."Unrealized Amount", VATEntry."Add.-Currency Unrealized Amt.");
                BssiAdjustVATAmount(VATEntry."Unrealized Base", VATEntry."Add.-Currency Unrealized Base");
                BssiAdjustVATAmount(VATEntry."Remaining Unrealized Amount", VATEntry."Add.-Curr. Rem. Unreal. Amount");
                BssiAdjustVATAmount(VATEntry."Remaining Unrealized Base", VATEntry."Add.-Curr. Rem. Unreal. Base");
                VATEntry.Modify();

                BssiAccumulate(TotalVATEntry.Base, -VATEntry.Base);
                BssiAccumulate(TotalVATEntry.Amount, -VATEntry.Amount);
                BssiAccumulate(TotalVATEntry."Unrealized Amount", -VATEntry."Unrealized Amount");
                BssiAccumulate(TotalVATEntry."Unrealized Base", -VATEntry."Unrealized Base");
                BssiAccumulate(TotalVATEntry."Remaining Unrealized Amount", -VATEntry."Remaining Unrealized Amount");
                BssiAccumulate(TotalVATEntry."Remaining Unrealized Base", -VATEntry."Remaining Unrealized Base");
                BssiAccumulate(TotalVATEntry."Additional-Currency Amount", -VATEntry."Additional-Currency Amount");
                BssiAccumulate(TotalVATEntry."Additional-Currency Base", -VATEntry."Additional-Currency Base");
                BssiAccumulate(TotalVATEntry."Add.-Currency Unrealized Amt.", -VATEntry."Add.-Currency Unrealized Amt.");
                BssiAccumulate(TotalVATEntry."Add.-Currency Unrealized Base", -VATEntry."Add.-Currency Unrealized Base");
                BssiAccumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Amount", -VATEntry."Add.-Curr. Rem. Unreal. Amount");
                BssiAccumulate(TotalVATEntry."Add.-Curr. Rem. Unreal. Base", -VATEntry."Add.-Curr. Rem. Unreal. Base");
            until VATEntry.Next() = 0;
    end;

    local procedure BssiAdjustVATAmount(var AmountLCY: Decimal; var AmountAddCurr: Decimal)
    begin
        BssiGetGLSetup();
        case GLSetup."VAT Exchange Rate Adjustment" of
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                AmountLCY :=
                  Round(
                    CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                      ExchRateAdjmtParameters."Posting Date", BssiGetAdditionalReportingCurrency(),
                      AmountAddCurr, AddCurrCurrencyFactor));
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                AmountAddCurr :=
                  Round(
                    CurrExchRate2.ExchangeAmtLCYToFCY(
                      ExchRateAdjmtParameters."Posting Date", BssiGetAdditionalReportingCurrency(),
                      AmountLCY, AddCurrCurrencyFactor));
        end;
    end;

    local procedure BssiGetAdditionalReportingCurrency(): Code[10]
    begin
        BssiGetGLSetup();
        exit(GLSetup."Additional Reporting Currency");
    end;

    local procedure BssiGetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get();

        GLSetupRead := true;
    end;

    local procedure BssiAdjustVATAccount(AccNo: Code[20]; AmountLCY: Decimal; AmountAddCurr: Decimal; BaseLCY: Decimal; BaseAddCurr: Decimal)
    var
        GLAccount: Record "G/L Account";
    begin
        BssiGetGLSetup();
        GLAccount.Get(AccNo);
        GLAccount.SetRange("Date Filter", ExchRateAdjmtParameters."Start Date", ExchRateAdjmtParameters."End Date");
        case GLSetup."VAT Exchange Rate Adjustment" of
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                BssiPostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount",
                  -AmountLCY, BaseLCY, BaseAddCurr);
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                BssiPostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                  -AmountAddCurr, BaseLCY, BaseAddCurr);
        end;
    end;

    local procedure BssiAdjustPurchTax(TaxJurisdiction: Record "Tax Jurisdiction"; var TotalVATEntry: Record "VAT Entry"; UseTax: Boolean)
    begin
        if (TotalVATEntry.Amount <> 0) or (TotalVATEntry."Additional-Currency Amount" <> 0) then begin
            TaxJurisdiction.TestField("Tax Account (Purchases)");
            BssiAdjustVATAccount(
              TaxJurisdiction."Tax Account (Purchases)",
              TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
              VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
            if UseTax then begin
                TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                BssiAdjustVATAccount(
                  TaxJurisdiction."Reverse Charge (Purchases)",
                  -TotalVATEntry.Amount, -TotalVATEntry."Additional-Currency Amount",
                  -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
            end;
        end;
        if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
           (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
        then begin
            TaxJurisdiction.TestField("Unrealized VAT Type");
            TaxJurisdiction.TestField("Unreal. Tax Acc. (Purchases)");
            BssiAdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Purchases)",
              TotalVATEntry."Remaining Unrealized Amount", TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount", TotalVATEntry."Add.-Curr. Rem. Unreal. Amount");

            if UseTax then begin
                TaxJurisdiction.TestField("Unreal. Rev. Charge (Purch.)");
                BssiAdjustVATAccount(
                  TaxJurisdiction."Unreal. Rev. Charge (Purch.)",
                  -TotalVATEntry."Remaining Unrealized Amount",
                  -TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
                  -VATEntryTotalBase."Remaining Unrealized Amount",
                  -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            end;
        end;
    end;

    local procedure BssiAdjustSalesTax(TaxJurisdiction: Record "Tax Jurisdiction"; var TotalVATEntry: Record "VAT Entry")
    begin
        TaxJurisdiction.TestField("Tax Account (Sales)");
        BssiAdjustVATAccount(
          TaxJurisdiction."Tax Account (Sales)",
          TotalVATEntry.Amount, TotalVATEntry."Additional-Currency Amount",
          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
        if (TotalVATEntry."Remaining Unrealized Amount" <> 0) or
           (TotalVATEntry."Add.-Curr. Rem. Unreal. Amount" <> 0)
        then begin
            TaxJurisdiction.TestField("Unrealized VAT Type");
            TaxJurisdiction.TestField("Unreal. Tax Acc. (Sales)");
            BssiAdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Sales)",
              TotalVATEntry."Remaining Unrealized Amount",
              TotalVATEntry."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount",
              VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
        end;
    end;

    local procedure BssiSetAdditionalReportingCurrency()
    var
        GLAccount: Record "G/L Account";
        VATPostingSetup2: Record "VAT Posting Setup";
        TaxJurisdiction2: Record "Tax Jurisdiction";
    begin
        BssiGetGLSetup();
        GLSetup.TestField("Additional Reporting Currency");

        AddRepCurrency.Get(BssiGetAdditionalReportingCurrency());
        GLAccount.Get(AddRepCurrency.GetRealizedGLGainsAccount());
        GLAccount.TestField("Exchange Rate Adjustment", GLAccount."Exchange Rate Adjustment"::"No Adjustment");

        GLAccount.Get(AddRepCurrency.GetRealizedGLLossesAccount());
        GLAccount.TestField("Exchange Rate Adjustment", GLAccount."Exchange Rate Adjustment"::"No Adjustment");

        if VATPostingSetup2.Find('-') then
            repeat
                if VATPostingSetup2."VAT Calculation Type" <> "Tax Calculation Type"::"Sales Tax" then begin
                    BssiCheckExchRateAdjustment(
                        VATPostingSetup2."Purchase VAT Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Purchase VAT Account"));
                    BssiCheckExchRateAdjustment(
                        VATPostingSetup2."Reverse Chrg. VAT Acc.", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Reverse Chrg. VAT Acc."));
                    BssiCheckExchRateAdjustment(
                        VATPostingSetup2."Purch. VAT Unreal. Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Purch. VAT Unreal. Account"));
                    BssiCheckExchRateAdjustment(
                        VATPostingSetup2."Reverse Chrg. VAT Unreal. Acc.", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Reverse Chrg. VAT Unreal. Acc."));
                    BssiCheckExchRateAdjustment(
                        VATPostingSetup2."Sales VAT Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Sales VAT Account"));
                    BssiCheckExchRateAdjustment(
                        VATPostingSetup2."Sales VAT Unreal. Account", VATPostingSetup2.TableCaption(), VATPostingSetup2.FieldCaption("Sales VAT Unreal. Account"));
                end;
            until VATPostingSetup2.Next() = 0;

        if TaxJurisdiction2.Find('-') then
            repeat
                BssiCheckExchRateAdjustment(
                    TaxJurisdiction2."Tax Account (Purchases)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Tax Account (Purchases)"));
                BssiCheckExchRateAdjustment(
                    TaxJurisdiction2."Reverse Charge (Purchases)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Reverse Charge (Purchases)"));
                BssiCheckExchRateAdjustment(
                    TaxJurisdiction2."Unreal. Tax Acc. (Purchases)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Unreal. Tax Acc. (Purchases)"));
                BssiCheckExchRateAdjustment(
                    TaxJurisdiction2."Unreal. Rev. Charge (Purch.)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Unreal. Rev. Charge (Purch.)"));
                BssiCheckExchRateAdjustment(
                    TaxJurisdiction2."Tax Account (Sales)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Tax Account (Sales)"));
                BssiCheckExchRateAdjustment(
                    TaxJurisdiction2."Unreal. Tax Acc. (Sales)", TaxJurisdiction2.TableCaption(), TaxJurisdiction2.FieldCaption("Unreal. Tax Acc. (Sales)"));
            until TaxJurisdiction2.Next() = 0;

        AddCurrCurrencyFactor :=
            CurrExchRate2.ExchangeRateAdjmt(ExchRateAdjmtParameters."Posting Date", BssiGetAdditionalReportingCurrency());
    end;

    local procedure BssiCheckExchRateAdjustment(AccNo: Code[20]; SetupTableName: Text; SetupFieldName: Text)
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo = '' then
            exit;

        GLAcc.Get(AccNo);
        /*
        if GLAcc."Exchange Rate Adjustment" <> GLAcc."Exchange Rate Adjustment"::"No Adjustment" then begin
            GLAcc."Exchange Rate Adjustment" := GLAcc."Exchange Rate Adjustment"::"No Adjustment";
            Error(
              ExchangeRateAdjmtMustBeErr,
              GLAcc.FieldCaption("Exchange Rate Adjustment"), GLAcc.TableCaption(),
              GLAcc."No.", GLAcc."Exchange Rate Adjustment",
              SetupTableName, GLSetup.FieldCaption("VAT Exchange Rate Adjustment"),
              GLSetup.TableCaption(), SetupFieldName);
        end;
        */
    end;

    local procedure BssiPostGLAccAdjmt(GLAccNo: Code[20]; ExchRateAdjmt: Enum "Exch. Rate Adjustment Type"; Amount: Decimal;
                                                                         NetChange: Decimal;
                                                                         AddCurrNetChange: Decimal)
    var
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get();
        GenJnlLine.Init();
        case ExchRateAdjmt of
            "Exch. Rate Adjustment Type"::"Adjust Amount":
                begin
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
                    GenJnlLine."Currency Code" := '';
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                    GLAmtTotal := GLAmtTotal + GenJnlLine.Amount;
                    GLAddCurrNetChangeTotal := GLAddCurrNetChangeTotal + AddCurrNetChange;
                    GLNetChangeBase := GLNetChangeBase + NetChange;
                end;
            "Exch. Rate Adjustment Type"::"Adjust Additional-Currency Amount":
                begin
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                    GenJnlLine."Currency Code" := BssiGetAdditionalReportingCurrency();
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := 0;
                    GLAddCurrAmtTotal := GLAddCurrAmtTotal + GenJnlLine.Amount;
                    GLNetChangeTotal := GLNetChangeTotal + NetChange;
                    GLAddCurrNetChangeBase := GLAddCurrNetChangeBase + AddCurrNetChange;
                end;
        end;
        if GenJnlLine.Amount <> 0 then begin
            GenJnlLine."Document No." := ExchRateAdjmtParameters."Document No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GLAccNo;
            GenJnlLine."Posting Date" := ExchRateAdjmtParameters."Posting Date";
            case GenJnlLine."Additional-Currency Posting" of
                GenJnlLine."Additional-Currency Posting"::"Amount Only":
                    GenJnlLine.Description :=
                        StrSubstNo(
                            ExchRateAdjmtParameters."Posting Description", BssiGetAdditionalReportingCurrency(), AddCurrNetChange);
                GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only":
                    GenJnlLine.Description := StrSubstNo(ExchRateAdjmtParameters."Posting Description", '', NetChange);
            end;
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            GenJnlLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
            GenJnlLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
            BssiGetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
            BssiAssignMEMEntity(GenJnlLine, TempDimSetEntry);
            BssiPostGenJnlLine(GenJnlLine, TempDimSetEntry);
        end;
    end;

    local procedure BssiGetJnlLineDefDim(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    var
        DimMgt: Codeunit DimensionManagement;
        DimSetID: Integer;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        case GenJnlLine."Account Type" of
            GenJnlLine."Account Type"::"G/L Account":
                DimMgt.AddDimSource(DefaultDimSource, Database::"G/L Account", GenJnlLine."Account No.");
            GenJnlLine."Account Type"::"Bank Account":
                DimMgt.AddDimSource(DefaultDimSource, Database::"Bank Account", GenJnlLine."Account No.");
        end;
        DimSetID :=
            DimMgt.GetDefaultDimID(
                DefaultDimSource, GenJnlLine."Source Code",
                GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code",
                GenJnlLine."Dimension Set ID", 0);
        DimMgt.GetDimensionSet(DimSetEntry, DimSetID);
    end;

    local procedure BssiPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var DimensionSetEntry: Record "Dimension Set Entry"): Integer
    begin
        GenJournalLine."Journal Template Name" := ExchRateAdjmtParameters."Journal Template Name";
        GenJournalLine."Journal Batch Name" := ExchRateAdjmtParameters."Journal Batch Name";
        BssiSetPostingDimensions(ExchRateAdjmtParameters."Dimension Posting", GenJournalLine, DimensionSetEntry);
        BssiMEMOnPostGenJnlLineOnBeforeGenJnlPostLineRun(GenJournalLine, ExchRateAdjmtParameters);
        GenJnlPostLine.Run(GenJournalLine);
        BssiMEMOnPostGenJnlLineOnAfterGenJnlPostLineRun(GenJournalLine, GenJnlPostLine);
        exit(GenJnlPostLine.GetNextTransactionNo());
    end;

    procedure BssiSetPostingDimensions(DimensionPosting: Enum "Exch. Rate Adjmt. Dimensions"; var GenJournalLine: Record "Gen. Journal Line"; var DimensionSetEntry: Record "Dimension Set Entry")
    var
        DimMgt: Codeunit DimensionManagement;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        GLSetup.Get();
        case DimensionPosting of
            "Exch. Rate Adjmt. Dimensions"::"No Dimensions", "Exch. Rate Adjmt. Dimensions"::"Bssi No Dimensions":
                if BssiMEMSystemSetup.BssiUseGlobalDimOne() then begin
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", BssiGetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimensionSetEntry));
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", '');
                end
                else begin
                    GenJournalLine.Validate("Shortcut Dimension 1 Code", '');
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", BssiGetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimensionSetEntry));
                end;

            "Exch. Rate Adjmt. Dimensions"::"Source Entry Dimensions", "Exch. Rate Adjmt. Dimensions"::"Bssi Source Entry Dimensions":
                begin
                    GenJournalLine."Shortcut Dimension 1 Code" := BssiGetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimensionSetEntry);
                    GenJournalLine."Shortcut Dimension 2 Code" := BssiGetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimensionSetEntry);
                    GenJournalLine."Dimension Set ID" := DimMgt.GetDimensionSetID(DimensionSetEntry);
                end;
            "Exch. Rate Adjmt. Dimensions"::"G/L Account Dimensions", "Exch. Rate Adjmt. Dimensions"::"Bssi G/L Account Dimensions":
                if GenJournalLine."Account Type" = "Gen. Journal Account Type"::"G/L Account" then begin
                    DimMgt.AddDimSource(
                        DefaultDimSource, DimMgt.TypeToTableID1(GenJournalLine."Account Type".AsInteger()), GenJournalLine."Account No.", true);
                    if BssiMEMSystemSetup.BssiUseGlobalDimOne() then begin
                        GenJournalLine.Validate("Shortcut Dimension 1 Code", BssiGetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimensionSetEntry));
                        GenJournalLine.Validate("Shortcut Dimension 2 Code");
                    end
                    else begin
                        GenJournalLine.Validate("Shortcut Dimension 1 Code");
                        GenJournalLine.Validate("Shortcut Dimension 2 Code", BssiGetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimensionSetEntry));
                    end;
                end;
        end;
    end;

    local procedure BssiGetGlobalDimVal(GlobalDimCode: Code[20]; var DimSetEntry: Record "Dimension Set Entry"): Code[20]
    var
        DimVal: Code[20];
    begin
        if GlobalDimCode = '' then
            DimVal := ''
        else begin
            DimSetEntry.SetRange("Dimension Code", GlobalDimCode);
            if DimSetEntry.Find('-') then
                DimVal := DimSetEntry."Dimension Value Code"
            else
                DimVal := '';
            DimSetEntry.SetRange("Dimension Code");
        end;
        exit(DimVal);
    end;

    local procedure BssiAccumulate(var TotalAmount: Decimal; AmountToAdd: Decimal)
    begin
        TotalAmount := TotalAmount + AmountToAdd;
    end;

    [IntegrationEvent(false, false)]
    local procedure BssiMEMOnAfterSetVATEntryFilters(var VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure BssiMEMOnProcessGLAccountAdjustmentOnBeforePostGLAccAdjmt(var GLAccount: Record "G/L Account");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure BssiMEMOnPostGenJnlLineOnBeforeGenJnlPostLineRun(var GenJnlLine: Record "Gen. Journal Line"; var ExchRateAdjmtParameters: Record "Exch. Rate Adjmt. Parameters")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure BssiMEMOnPostGenJnlLineOnAfterGenJnlPostLineRun(var GenJnlLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
    end;
}