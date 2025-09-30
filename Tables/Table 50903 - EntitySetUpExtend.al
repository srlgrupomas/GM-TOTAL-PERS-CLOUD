table 80903 "EntitySetUpExtend"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "CompanyCBU"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "CompanyAlias"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Asset"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "AssetValue"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Department"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "DepartmentValue"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Intercompany"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "IntercompanyValue"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Dimension Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        UpdateAssetField();
    end;

    trigger OnModify()
    begin
        UpdateAssetField();
    end;

    local procedure UpdateAssetField()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if GeneralLedgerSetup.Get() then begin
            "Asset" := GeneralLedgerSetup."Shortcut Dimension 2 Code";
            "Department" := GeneralLedgerSetup."Shortcut Dimension 3 Code";
            "Intercompany" := GeneralLedgerSetup."Shortcut Dimension 4 Code";
        end;
    end;
}