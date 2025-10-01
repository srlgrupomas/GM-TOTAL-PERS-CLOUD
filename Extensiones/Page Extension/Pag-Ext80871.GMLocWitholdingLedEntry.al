namespace GMTOTALPERS.GMTOTALPERS;

pageextension 34006871 GMLocWitholdingLedEntry extends "GMA Withh Ledg Entries"
{
    layout
    {
        addafter("GMAVoucher Date")
        {
            field("GMADocumentDate"; Rec."GMADocumentDate")
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
