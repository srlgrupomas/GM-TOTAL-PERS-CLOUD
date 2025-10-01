table 34006999 "PreviewMasivoBool"
{
    DataClassification = ToBeClassified;
    Caption = 'PreviewMasivoBool';
    fields
    {
        field(1; UserName; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "PreviewMasivo"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; UserName)
        {
            Clustered = true;
        }
    }
}