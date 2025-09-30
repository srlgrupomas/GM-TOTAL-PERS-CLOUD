tableextension 80907 "PerG/L Account" extends "G/L Account"
{
    fields
    {
        field(80900; "Trial Balance Vendor/Customer"; Boolean)
        {
            Caption = 'Trial Balance Vendor/Customer';
            DataClassification = ToBeClassified;
        }
        field(80901; "Trial Balance Bank Account"; Boolean)
        {
            Caption = 'Trial Balance Bank Account';
            DataClassification = ToBeClassified;
        }
    }
}