pageextension 80989 "PersExtend_Vendor" extends "Vendor Card"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG   

    layout
    {
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        modify("Payment Method Code")
        {
            ShowMandatory = true;
        }
        modify("Tax Area Code")
        {
            ShowMandatory = true;
        }
        modify("Partner Type")
        {
            ShowMandatory = true;
        }
        modify("GMLocFiscal Type")
        {
            ShowMandatory = true;
        }
        modify("GMLocProvince Code")
        {
            ShowMandatory = true;
        }
        modify("GMLocWithholding Code")
        {
            ShowMandatory = true;
        }
        modify("GMLocAFIP Document Type")
        {
            ShowMandatory = true;
        }
    }
}