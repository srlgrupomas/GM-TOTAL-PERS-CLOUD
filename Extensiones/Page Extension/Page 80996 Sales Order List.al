pageextension 34006996 "GMLocSales Order List" extends "Sales Order List"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    layout
    {

    }

    actions
    {

        addafter(PostAndSend)
        {


            action(GMLOcPostSelected)
            {
                ApplicationArea = all;
                Caption = 'Preview';
                Image = PostOrder;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesBatchPostMgt: Codeunit "Sales Batch Post Mgt.";
                    SelectedSalesHeader: Record "Sales Header";
                    SalesPostYesNo: Codeunit "LocSales-Post (Yes/No)";
                    recSalesHeader: Record "Sales Header";
                    Copyrec: Record "Sales Header";
                    SetFilterSalesHeader: Record "Sales Header";
                    SalesPost: Codeunit "LocSales-Post";

                    //para mostrar la page
                    TempDocumentEntry: Record "Document Entry" temporary;
                    pagePreview: Page "locExtendedPosting Preview";
                    saveTempMov: Codeunit SaveTempMov;
                begin
                    saveTempMov.modifyPreviewMasivoBool();

                    saveTempMov.ClearBuffers();
                    CurrPage.SetSelectionFilter(SalesHeader);
                    SalesHeader.FindSet();
                    repeat

                        recSalesHeader.Reset();
                        recSalesHeader.SetRange("Document Type", SalesHeader."Document Type");
                        recSalesHeader.SetRange("No.", SalesHeader."No.");
                        IF (recSalesHeader.FindFirst()) THEN begin

                            CLEAR(SalesPost);
                            SalesPost.SetSuppressCommit(true);
                            SalesPost.RunWithCheck(recSalesHeader);

                        end;
                    until SalesHeader.Next() = 0;

                    pagePreview.SetFromPurchase(false);
                    pagePreview.Run();
                    error('');
                end;
            }

        }
    }
}