pageextension 34006901 "PersExtendPurchaseOrderSubForm" extends "Purchase Order SubForm"
{
    layout
    {
        modify("Tax Group Code")
        {
            ShowMandatory = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            ShowMandatory = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
        modify("Tax Area Code")
        {
            ShowMandatory = true;
        }
        modify("GMAProvince")
        {
            ShowMandatory = true;
        }
        modify("GMAWithholding Code")
        {
            ShowMandatory = true;
        }
    }
}