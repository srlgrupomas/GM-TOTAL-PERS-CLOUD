pageextension 80887 "PersExtend_Purchase Order" extends "Purchase Order"
{
    layout
    {
        modify("GRP Job No.")
        {
            ShowMandatory = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            ShowMandatory = true;
        }
        modify("GRP Shortcut Dimension 3 Code")
        {
            ShowMandatory = true;
        }
        modify("Vendor Invoice No.")
        {
            ShowMandatory = false;
        }
        modify("Purchaser Code")
        {
            ShowMandatory = false;
        }
    }
}