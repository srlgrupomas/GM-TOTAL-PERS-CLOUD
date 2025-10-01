pageextension 34006993 "PersExtend_Customer" extends "Customer Card"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    layout
    {
        modify("Tax Area Code")
        {
            ShowMandatory = true;
        }
        modify("GMAFiscal Type")
        {
            ShowMandatory = true;
        }
        modify("GMAAFIP Document Type")
        {
            ShowMandatory = true;
        }
        modify("GMAProvince Code")
        {
            ShowMandatory = true;
        }

    }
}