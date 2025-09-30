tableextension 80904 "PerGeneral Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Foreign Exchange Losses"; Code[20])
        {
            Caption = 'Foreign Exchange Losses';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
        field(50001; "Currency Exchange Gains"; Code[20])
        {
            Caption = 'Currency Exchange Gains';
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
        field(50002; "General Journal Template"; Code[20])
        {
            Caption = 'General Journal Template';
            TableRelation = "Gen. Journal Template";
            DataClassification = ToBeClassified;
        }
        field(50003; "General Journal Batch"; Code[20])
        {
            Caption = 'General Journal Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("General Journal Template"));
            DataClassification = ToBeClassified;
        }
        field(50004; "Reclas. Serial No. Cur. Adjus."; Code[20])
        {
            Caption = 'Reclas. Serial No. Cur. Adjus.';
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
    }
}
