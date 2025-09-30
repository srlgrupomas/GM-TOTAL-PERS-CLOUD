tableextension 80903 "PERSales & Receivables Set" extends "Sales & Receivables Setup"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    fields
    {

        field(50903; PerCreateTaxArea; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Create Customer Tax Area by Entity';
        }

    }
}