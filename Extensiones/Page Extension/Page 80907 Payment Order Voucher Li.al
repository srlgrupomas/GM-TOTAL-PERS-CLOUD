pageextension 34006907 "PersPayment Order Vouchers" extends "GMAPayment Order Vouchers"
{
    layout
    {
        modify("GMADocument Posting Group")
        {
            Editable = false;
        }
    }
}