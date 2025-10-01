tableextension 34006906 "PerG/L Entries" extends "G/L Entry"
{
    fields
    {
        field(34006900; "Additional-currency Adjusted"; Boolean)
        {
            Caption = 'Additional-currency Adjusted';
            DataClassification = ToBeClassified;

        }
        field(34006901; "GMLocPreview Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(34006902; "GMLocPreview CUIT"; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = ToBeClassified;
        }
        field(34006903; "GMLocPreviewAFIP Inv. Vo. Type"; Text[20])
        {
            Caption = 'AFIP Voucher Type';
            DataClassification = ToBeClassified;
        }

        field(34006904; "PERNombre Proveedor"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Source No.")));
            Caption = 'Vendor Name';

        }
        field(34006905; "PERNombre Cliente"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Source No.")));
            Caption = 'Customer Name';
        }
        field(34006906; "PERCodigo Cuenta Corporacion"; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."GMACorporate Account Code" where("No." = field("G/L Account No.")));
            Caption = 'Corporate Account Code';
        }
        field(34006907; "PERNombre Cuenta Corporacion"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account"."GMACorporate Account Name" where("No." = field("G/L Account No.")));
            Caption = 'Corporate Account Name';
        }
        field(34006908; "PerCurrency Factor FA"; Decimal)
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
