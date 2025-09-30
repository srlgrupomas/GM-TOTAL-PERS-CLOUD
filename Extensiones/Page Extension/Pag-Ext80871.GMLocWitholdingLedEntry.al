namespace GMTOTALPERS.GMTOTALPERS;

pageextension 80871 GMLocWitholdingLedEntry extends "GMLoc Withh Ledg Entries"
{
    layout
    {
        addafter("GMLocVoucher Date")
        {
            field("GMLocDocumentDate"; Rec."GMLocDocumentDate")
            {
                ApplicationArea = All;
                Caption = 'Document Date';
                ToolTip = 'Specifies the date of the document.';
            }
        }
    }

    actions
    {
        // Add any actions if needed
    }

    trigger OnOpenPage()
    begin
        // Initialization code if needed
    end;
}
