pageextension 80988 "PersChartofAccounts" extends "Chart of Accounts"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG   

    layout
    {
        addafter(Name)
        {
            field("GMLocCorporate Account Code"; Rec."GMLocCorporate Account Code")
            {
                ApplicationArea = ALL;
                Description = 'Corporate Account Code';
            }
            field("GMLocCorporate Account Name"; Rec."GMLocCorporate Account Name")
            {
                ApplicationArea = ALL;
                Description = 'Corporate Account Name';
            }

        }
    }
}