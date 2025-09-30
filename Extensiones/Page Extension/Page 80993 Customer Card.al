pageextension 80993 "PersExtend_Customer" extends "Customer Card"
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
        modify("GMLocFiscal Type")
        {
            ShowMandatory = true;
        }
        modify("GMLocAFIP Document Type")
        {
            ShowMandatory = true;
        }
        modify("GMLocProvince Code")
        {
            ShowMandatory = true;
        }

    }
}