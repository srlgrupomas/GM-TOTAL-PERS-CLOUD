pageextension 34006988 "PersChartofAccounts" extends "Chart of Accounts"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG   

    layout
    {
        addafter(Name)
        {
            field("GMACorporate Account Code"; Rec."GMACorporate Account Code")
            {
                ApplicationArea = ALL;
                Description = 'Corporate Account Code';
            }
            field("GMACorporate Account Name"; Rec."GMACorporate Account Name")
            {
                ApplicationArea = ALL;
                Description = 'Corporate Account Name';
            }

        }
    }
}