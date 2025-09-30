pageextension 80990 VendorBankAccountCard extends "Vendor Bank Account Card"
{
    layout
    {
        modify(IBAN)
        {
            ShowMandatory = true;
        }
    }
}
