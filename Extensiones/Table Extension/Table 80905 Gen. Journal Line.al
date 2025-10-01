tableextension 34006905 "PerGen Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        // Nuevo campo
        field(34006900; "Additional-currency Adjusted"; Boolean)
        {
            Caption = 'Additional-currency Adjusted';
            DataClassification = ToBeClassified;
        }
        field(34006908; "PerCurrency Factor FA"; Decimal)
        {
            Caption = 'Currency Factor FA';
            DecimalPlaces = 0 : 18;
        }
        field(34006902; PersRecalculado; Boolean)
        {
        }
    }
}