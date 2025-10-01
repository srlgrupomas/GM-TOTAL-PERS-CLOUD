tableextension 34006902 "PERTaxArea" extends "Tax Area"
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
            begin

                BssiDimensionForRestriction := '';
                BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                validate(EntityID, BssiDimension);
            end;

            trigger OnValidate()
            var
                BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                TAxAreaLine: Record "Tax Area Line";
            begin
                TAxAreaLine.Reset();
                TAxAreaLine.SetRange("Tax Area", rec.Code);
                IF (TAxAreaLine.FindFirst()) THEN
                    repeat
                        TAxAreaLine.EntityID := rec.EntityID;
                        TAxAreaLine.Modify();
                    until TAxAreaLine.Next() = 0;
                BssiDimensionForRestriction := '';
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
            end;
        }
        field(50903; PERCustomerNo; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
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
