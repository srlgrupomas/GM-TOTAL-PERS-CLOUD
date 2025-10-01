pageextension 34006989 "PersExtend_Vendor" extends "Vendor Card"
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
        modify("GMAFiscal Type")
        {
            ShowMandatory = true;
        }
        modify("GMAProvince Code")
        {
            ShowMandatory = true;
        }
        modify("GMAWithholding Code")
        {
            ShowMandatory = true;
        }
        modify("GMAAFIP Document Type")
        {
            ShowMandatory = true;
        }
    }
}