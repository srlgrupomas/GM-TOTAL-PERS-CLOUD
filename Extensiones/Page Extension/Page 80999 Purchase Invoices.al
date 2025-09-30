pageextension 80999 "GMLocPurchase Invoices Preview" extends "Purchase Invoices"
{
    layout
    {
    }

    actions
    {
        addafter(PostAndPrint)
        {
            action(GMLOcPostSelected)
            {
                ApplicationArea = All;
                Caption = 'Preview';
                Image = PostOrder;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchPost: Codeunit "LocPurch.-Post";
                    pagePreview: Page "locExtendedPosting Preview";
                    saveTempMov: Codeunit SaveTempMov;

                begin

                    saveTempMov.modifyPreviewMasivoBool();

                    saveTempMov.ClearBuffers();
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    if PurchaseHeader.FindSet() then begin
                        repeat
                            CLEAR(PurchPost);
                            PurchPost.SetSuppressCommit(true);
                            PurchPost.RunWithCheck(PurchaseHeader);
                        until PurchaseHeader.Next() = 0;
                    end;

                    pagePreview.SetFromPurchase(true);
                    pagePreview.Run();

                    // El error hace que no se registre el post
                    error('');
                end;
            }
        }
    }


}