tableextension 34006908 "PersFixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(34006901; "PersCurrency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            Editable = false;
            DecimalPlaces = 0 : 18;
        }
        field(34006902; "PersCurrency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            var
                BankAcc: Record "Bank Account";
                CurrExchRate: Record "Currency Exchange Rate";
                AccCurrencyCode: Code[10];
            begin
                if rec."PersCurrency Code" <> '' then begin
                    "PersCurrency Factor" := CurrExchRate.ExchangeRate(rec."Last Date Modified", rec."PersCurrency Code");
                end else
                    "PersCurrency Factor" := 0;
                Validate("PersCurrency Factor");
            end;
        }
        field(34006903; "PersExchange Rate FA"; Decimal)
        {
            Caption = 'Exchange Rate FA';
            DecimalPlaces = 1 : 6;
        }
    }
}