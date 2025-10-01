codeunit 34006999 "SaveTempMov"
{
    SingleInstance = true;
    Permissions = tabledata PreviewMasivoBool = rimd;

    var
        GLobalParGLEntry: Record "G/L Entry" temporary;

        GLobalParVatEntry: Record "VAT Entry" temporary;
        entryNo: Integer;

    procedure GetLastGenJnlLine(var ParGLEntry: Record "G/L Entry" temporary)
    var
        aux: integer;
    begin
        GLobalParGLEntry.Reset();
        IF (GLobalParGLEntry.findfirst) THEN
            repeat
                ParGLEntry.init;
                ParGLEntry.Copy(GLobalParGLEntry);
                ParGLEntry.Insert();
            until GLobalParGLEntry.next() = 0;

        ParGLEntry.Reset();
        IF (ParGLEntry.findfirst) THEN;

    end;

    procedure GetLastVatEntry(var ParVatEntry: Record "VAT Entry" temporary)
    var
        aux: integer;
    begin
        GLobalParVatEntry.Reset();
        IF (GLobalParVatEntry.findfirst) THEN
            repeat
                ParVatEntry.init;
                ParVatEntry.Copy(GLobalParVatEntry);
                ParVatEntry.Insert();
            until GLobalParVatEntry.next() = 0;

        ParVatEntry.Reset();
        IF (ParVatEntry.findfirst) THEN;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforePrePostApprovalCheckPurch', '', false, false)]
    local procedure OnBeforePrePostApprovalCheckPurch(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    var
        PreviewMasivoBool: Record "PreviewMasivoBool";
    begin
        PreviewMasivoBool.Reset();
        PreviewMasivoBool.SetRange(UserName, UserId);
        if PreviewMasivoBool.FindFirst() then begin
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"GMAExtention Codeunit", 'OnBeforeIsPurchaseApprovalsGMA', '', false, false)]
    local procedure OnBeforeIsPurchaseApprovalsGMA(var IsHandled: Boolean)
    var
        PreviewMasivoBool: Record "PreviewMasivoBool";
    begin
        PreviewMasivoBool.Reset();
        PreviewMasivoBool.SetRange(UserName, UserId);
        if PreviewMasivoBool.FindFirst() then begin
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, OnAfterInsertVATEntry, '', true, true)]
    local procedure OnAfterInsertVATEntry(GenJnlLine: Record "Gen. Journal Line"; VATEntry: Record "VAT Entry"; GLEntryNo: Integer; var NextEntryNo: Integer; var TempGLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link" temporary)
    var
        aux: integer;
        PurchaseHeader: Record "Purchase Header";
        salesHeader: Record "Sales Header";
        PreviewMasivoBool: Record "PreviewMasivoBool";
    begin
        PreviewMasivoBool.Reset();
        PreviewMasivoBool.SetRange(UserName, UserId);
        if PreviewMasivoBool.FindFirst() then begin
            entryNo += 1;
            GLobalParVatEntry.Init();
            GLobalParVatEntry.copy(VATEntry);
            GLobalParVatEntry."Entry No." := entryNo;

            //Compras
            IF (GenJnlLine.GMASalesPurchase = GenJnlLine.GMASalesPurchase::Compra) THEN begin
                PurchaseHeader.Reset();
                PurchaseHeader.SetRange("Document Type", GenJnlLine.GMADocTypepurchase);
                PurchaseHeader.setrange("No.", GenJnlLine.GMADocNo);
                if PurchaseHeader.FindFirst() then begin
                    GLobalParVatEntry."GMAAFIP Voucher Type" := PurchaseHeader."GMAAFIP Invoice Voucher Type";
                end;
            end;

            //Ventas
            IF (GenJnlLine.GMASalesPurchase = GenJnlLine.GMASalesPurchase::Venta) THEN begin
                salesHeader.Reset();
                salesHeader.SetRange("Document Type", GenJnlLine.GMADocTypeSales);
                salesHeader.setrange("No.", GenJnlLine.GMADocNo);
                if salesHeader.FindFirst() then begin
                    GLobalParVatEntry."GMAAFIP Voucher Type" := salesHeader."GMAAFIP Invoice Voucher Type";
                end;
            end;

            GLobalParVatEntry.Insert();

            GLobalParVatEntry.Reset();
            IF (GLobalParVatEntry.findfirst) THEN
                repeat
                    aux += 1;
                until GLobalParVatEntry.next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLEntry', '', true, true)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    var
        aux: integer;
        PurchaseHeader: Record "Purchase Header";
        salesHeader: Record "Sales Header";
        PreviewMasivoBool: Record "PreviewMasivoBool";
    begin
        PreviewMasivoBool.Reset();
        PreviewMasivoBool.SetRange(UserName, UserId);
        if PreviewMasivoBool.FindFirst() then begin

            entryNo += 1;
            GLobalParGLEntry.Init();
            GLobalParGLEntry.copy(GLEntry);
            GLobalParGLEntry."Entry No." := entryNo;
            GLobalParGLEntry."GMLocPreview Due Date" := GenJournalLine."Due Date";
            GLobalParGLEntry."GMLocPreview CUIT" := GenJournalLine."VAT Registration No.";

            //Compras
            IF (GenJournalLine.GMASalesPurchase = GenJournalLine.GMASalesPurchase::Compra) THEN begin
                PurchaseHeader.Reset();
                PurchaseHeader.SetRange("Document Type", GenJournalLine.GMADocTypepurchase);
                PurchaseHeader.setrange("No.", GenJournalLine.GMADocNo);
                if PurchaseHeader.FindFirst() then begin
                    GLobalParGLEntry."GMLocPreviewAFIP Inv. Vo. Type" := PurchaseHeader."GMAAFIP Invoice Voucher Type";
                    GLobalParGLEntry."PerNombre Proveedor" := PurchaseHeader."Buy-from Vendor Name";
                end;
            end;

            //Ventas
            IF (GenJournalLine.GMASalesPurchase = GenJournalLine.GMASalesPurchase::Venta) THEN begin
                salesHeader.Reset();
                salesHeader.SetRange("Document Type", GenJournalLine.GMADocTypepurchase);
                salesHeader.setrange("No.", GenJournalLine.GMADocNo);
                if salesHeader.FindFirst() then begin
                    GLobalParGLEntry."GMLocPreviewAFIP Inv. Vo. Type" := salesHeader."GMAAFIP Invoice Voucher Type";
                    GLobalParGLEntry."PerNombre Cliente" := salesHeader."Sell-to Customer Name";
                end;
            end;
            GLobalParGLEntry.Insert();

            GLobalParGLEntry.Reset();
            IF (GLobalParGLEntry.findfirst) THEN
                repeat
                    aux += 1;
                until GLobalParGLEntry.next() = 0;
        end;
    end;

    procedure ClearBuffers();
    begin

        entryNo := 0;


        GLobalParGLEntry.Reset();
        while GLobalParGLEntry.FindFirst() do
            GLobalParGLEntry.Delete();


        GLobalParVatEntry.Reset();
        while GLobalParVatEntry.FindFirst() do
            GLobalParVatEntry.Delete();
    end;


#if CLEAN21 // ver luego como resolver eso para BC23
 
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostInvPostBuffer', '', false, false)]
    local procedure OnBeforePostInvPostBuffer80Loc(VAR GenJnlLine: Record "Gen. Journal Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer"; SalesHeader: Record "Sales Header");
     
    begin
       GenJnlLine."External Document No." := SalesHeader."No.";
                   
    end;
 
#else

    [EventSubscriber(ObjectType::Codeunit, 825, 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure OnBeforePostInvPostBuffer80Loc(VAR GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary);

    begin
        GenJnlLine."External Document No." := SalesHeader."No.";


    end;
#endif

#if CLEAN21 // ver luego como resolver eso para BC23
 
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostInvPostBuffer', '', false, false)]
    local procedure OnBeforePostInvPostBuffer90Loc(var GenJnlLine: Record "Gen. Journal Line";var PurchHeader: Record "Purchase Header");
     
    begin
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") THEN begin
            IF (PurchHeader."Vendor Cr. Memo No." <> '') then;
                GenJnlLine."External Document No." := PurchHeader."Vendor Cr. Memo No."
            else
                GenJnlLine."External Document No." := PurchHeader."No.";

        end
        else begin
            IF (PurchHeader."Vendor Invoice No." <> '') then
                GenJnlLine."External Document No." := PurchHeader."Vendor Invoice No."
            else
                GenJnlLine."External Document No." := PurchHeader."No.";

        end;
                   
    end;
 
#else

    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure OnBeforePostInvPostBuffer826Loc(VAR GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header");

    begin
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") THEN begin
            IF (PurchHeader."Vendor Cr. Memo No." <> '') then
                GenJnlLine."External Document No." := PurchHeader."Vendor Cr. Memo No."
            else
                GenJnlLine."External Document No." := PurchHeader."No.";

        end
        else begin
            IF (PurchHeader."Vendor Invoice No." <> '') then
                GenJnlLine."External Document No." := PurchHeader."Vendor Invoice No."
            else
                GenJnlLine."External Document No." := PurchHeader."No.";

        end;


    end;
#endif

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInsertVAT', '', false, false)]
    local procedure OnAfterInsertVAT12(var VATEntry: Record "VAT Entry"; var GenJournalLine: Record "Gen. Journal Line");

    begin
        VATEntry."External Document No." := GenJournalLine."External Document No.";


    end;

#if not CLEAN24


    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostInvPostBuffer', '', false, false)]

    local procedure OnBeforePostInvPostBuffer90LOC(VAR GenJnlLine: Record "Gen. Journal Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer"; VAR PurchHeader: Record "Purchase Header");
    var

    begin
        // identificar si es preview
        GenJnlLine.GMADocNo := PurchHeader."No.";
        GenJnlLine.GMADocTypepurchase := PurchHeader."Document Type";
        GenJnlLine.GMASalesPurchase := GenJnlLine.GMASalesPurchase::Compra;
    end;
#else
    [EventSubscriber(ObjectType::Codeunit, 826, 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure OnBeforePostInvPostBuffer90LOC(VAR GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header");

    begin
        // identificar si es preview
        GenJnlLine.GMADocNo := PurchHeader."No.";
        GenJnlLine.GMADocTypepurchase := PurchHeader."Document Type";
        GenJnlLine.GMASalesPurchase := GenJnlLine.GMASalesPurchase::Compra;
    end;
#endif



#if  not CLEAN24
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostInvPostBuffer', '', false, false)]
    local procedure OnBeforePostInvPostBuffer80LOC1(VAR GenJnlLine: Record "Gen. Journal Line"; VAR InvoicePostBuffer: Record "Invoice Post. Buffer"; var SalesHeader: Record "Sales Header");
    var
    begin
        // identificar si es preview
        GenJnlLine.GMADocNo := SalesHeader."No.";
        GenJnlLine.GMADocTypepurchase := SalesHeader."Document Type";
        GenJnlLine.GMASalesPurchase := GenJnlLine.GMASalesPurchase::Venta;
    end;
#else
    [EventSubscriber(ObjectType::Codeunit, 825, 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure OnBeforePostInvPostBuffer80LOC2(VAR GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header");

    begin
        // identificar si es preview
        GenJnlLine.GMADocNo := SalesHeader."No.";
        genJnlLine.GMADocTypeSales := salesheader."Document Type";
        GenJnlLine.GMASalesPurchase := GenJnlLine.GMASalesPurchase::Venta;
    end;
#endif

    procedure modifyPreviewMasivoBool();
    var
        PreviewMasivoBool: Record "PreviewMasivoBool";
    begin
        PreviewMasivoBool.Reset();
        PreviewMasivoBool.SetRange(UserName, UserId);
        if not PreviewMasivoBool.FindFirst() then begin
            PreviewMasivoBool.init();
            PreviewMasivoBool.UserName := UserId;
            PreviewMasivoBool.Insert();
        end;
    end;
}
