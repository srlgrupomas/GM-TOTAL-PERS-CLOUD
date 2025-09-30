pageextension 80907 "PersPayment Order Vouchers" extends "GMLocPayment Order Vouchers"
{
    layout
    {
        modify("GMLocDocument Posting Group")
        {
            Editable = false;
        }
    }
}