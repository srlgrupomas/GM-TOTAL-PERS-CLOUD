table 34006901 PerceptionabyEntity
{
    DataClassification = ToBeClassified;
    LookupPageId = PerceptionabyEntity;
    Caption = 'Perception by Entity';
    fields
    {
        field(1; ProvinceCode; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = GMAProvince."GMAProvince Code";
            Caption = 'Province Code';
        }
        field(2; EntityID; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Dimension Value"."Dimension Code";
            Caption = 'EntityID';
            trigger OnLookup()
            var
                BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
                BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
                BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
                BssiDimensionForRestriction: Text;
            begin
                BssiDimensionForRestriction := '';
                BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                EntityID := BssiDimension;
            end;

            trigger OnValidate()
            var
                BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
            begin
                BssiDimensionForRestriction := '';
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
            end;
        }

        field(3; Retains; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retains';
        }

    }

    keys
    {
        key(PK; ProvinceCode, EntityID)
        {
            Clustered = true;

        }
    }
    var
        BssiDimension: Text;
        BssiDimensionForRestriction: Text;

        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;

    procedure validardimrest()
    var
    begin
        BssiMEMSingleInstanceCU.Bssi_SetCurrentHeaderEntity('');
        BssiMEMSingleInstanceCU.Bssi_SetCurrentEntity('');
        BssiMEMSystemSetup.Get();

        if BssiDimension <> '' then
            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension)
        else
            BssiDimensionForRestriction := BssiMEMSecurityHelper.Bssi_tGetUserSecurityFilterText();
    end;
}