tableextension 80906 "PerG/L Entries" extends "G/L Entry"
{
    fields
    {
        field(80900; "Additional-currency Adjusted"; Boolean)
        {
            Caption = 'Additional-currency Adjusted';
            DataClassification = ToBeClassified;

        }
        field(80901; "GMLocPreview Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(80902; "GMLocPreview CUIT"; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = ToBeClassified;
        }
        field(80903; "GMLocPreviewAFIP Inv. Vo. Type"; Text[20])
        {
            Caption = 'AFIP Voucher Type';
            DataClassification = ToBeClassified;
        }

        field(80904; "PERNombre Proveedor"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Source No.")));
            Caption = 'Vendor Name';

        }
        field(80905; "PERNombre Cliente"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Source No.")));
            Caption = 'Customer Name';
        }
        field(80906; "PERCodigo Cuenta Corporacion"; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."GMLocCorporate Account Code" where("No." = field("G/L Account No.")));
            Caption = 'Corporate Account Code';
        }
        field(80907; "PERNombre Cuenta Corporacion"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."GMLocCorporate Account Name" where("No." = field("G/L Account No.")));
            Caption = 'Corporate Account Name';
        }
        field(80908; "PerCurrency Factor FA"; Decimal)
        {
            Caption = 'Currency Factor FA';
            DecimalPlaces = 0 : 18;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(SourceNo; "Source No.") { }
    }
}
