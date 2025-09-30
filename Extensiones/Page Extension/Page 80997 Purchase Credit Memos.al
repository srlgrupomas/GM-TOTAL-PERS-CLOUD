pageextension 80997 "GMLocPurchase Credit Memos P" extends "Purchase Credit Memos"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    layout
    {

    }

    actions
    {

        addafter(PostAndPrint)
        {


            action(GMLOcPostSelected)
            {
                ApplicationArea = all;
                Caption = 'Preview';
                Image = PostOrder;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseBatchPostMgt: Codeunit "Purchase Batch Post Mgt.";
                    SelectedPurchaseHeader: Record "Purchase Header";
                    PurchPostYesNo: Codeunit "LocPurch.-Post (Yes/No)";
                    recPurchaseHeader: Record "Purchase Header";
                    Copyrec: Record "Purchase Header";
                    SetFilterPurchaseHeader: Record "Purchase Header";
                    PurchPost: Codeunit "LocPurch.-Post";

                    //para mostrar la page
                    TempDocumentEntry: Record "Document Entry" temporary;
                    pagePreview: Page "locExtendedPosting Preview";
                    saveTempMov: Codeunit SaveTempMov;
                begin
                    saveTempMov.modifyPreviewMasivoBool();

                    saveTempMov.ClearBuffers();
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    PurchaseHeader.FindSet();
                    repeat

                        recPurchaseHeader.Reset();
                        recPurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type");
                        recPurchaseHeader.SetRange("No.", PurchaseHeader."No.");
                        IF (recPurchaseHeader.FindFirst()) THEN begin

                            CLEAR(PurchPost);
                            PurchPost.SetSuppressCommit(true);
                            PurchPost.RunWithCheck(recPurchaseHeader);

                        end;
                    until PurchaseHeader.Next() = 0;

                    pagePreview.SetFromPurchase(true);
                    pagePreview.Run();
                    error('');
                end;
            }

        }
    }
}