pageextension 34006990 VendorBankAccountCard extends "Vendor Bank Account Card"
{
    layout
    {
        modify(IBAN)
        {
            ShowMandatory = true;
        }
    }
}
