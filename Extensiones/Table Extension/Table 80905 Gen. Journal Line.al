tableextension 80905 "PerGen Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        // Nuevo campo
        field(80900; "Additional-currency Adjusted"; Boolean)
        {
            Caption = 'Additional-currency Adjusted';
            DataClassification = ToBeClassified;
        }
        field(80908; "PerCurrency Factor FA"; Decimal)
        {
            Caption = 'Currency Factor FA';
            DecimalPlaces = 0 : 18;
        }
        field(80902; PersRecalculado; Boolean)
        {
        }
    }
}