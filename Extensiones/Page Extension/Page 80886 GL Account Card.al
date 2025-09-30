pageextension 80886 "PersG/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter("GMLocHideOnMatrixHistory")
        {
            field("Trial Balance Vendor/Customer"; rec."Trial Balance Vendor/Customer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the G/L Account is used in the Trial Balance for Vendors and Customers.';
            }
        }
    }
}