tableextension 34006901 "PERTaxAreaLine" extends "Tax Area Line"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    fields
    {
        field(50902; EntityID; Code[20])
        {
            DataClassification = ToBeClassified;

            Caption = 'EntityID';
            trigger OnLookup()
            var
                BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
                BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
                BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
                BssiDimensionForRestriction: Text;
                TaxArea: Record "Tax Area";
            begin

                BssiDimensionForRestriction := '';
                BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                EntityID := BssiDimension;

                TaxArea.Reset();
                TaxArea.SetRange(Code, rec."Tax Area");
                IF (TaxArea.FindFirst()) THEN begin
                    TestField(EntityID, TaxArea.EntityID);
                end;
            end;

            trigger OnValidate()
            var
                BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
            begin
                BssiDimensionForRestriction := '';
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
            end;
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
