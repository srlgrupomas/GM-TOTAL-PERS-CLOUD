pageextension 80987 "PersGeneral Ledger Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter(GMLoc)
        {
            group("GMLocDifExch")
            {
                Caption = 'Diferences in Exchange Rates';
                field("Foreign Exchange Losses"; rec."Foreign Exchange Losses")
                {
                    ApplicationArea = All;
                    ToolTip = 'G/L Account for foreign exchange losses.';
                }
                field("Currency Exchange Gains"; rec."Currency Exchange Gains")
                {
                    ApplicationArea = All;
                    ToolTip = 'G/L Account for currency exchange gains.';
                }
                field("General Journal Template"; rec."General Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'G/L Account for general journal template.';
                }
                field("General Journal Batch"; rec."General Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'G/L Account for general journal batch.';
                }
                field("Reclas. Serial No. Cur. Adjus."; rec."Reclas. Serial No. Cur. Adjus.")
                {
                    ApplicationArea = All;
                    ToolTip = 'G/L Account for reclas. serial no. cur. adjus.';
                }
            }
        }
    }
}