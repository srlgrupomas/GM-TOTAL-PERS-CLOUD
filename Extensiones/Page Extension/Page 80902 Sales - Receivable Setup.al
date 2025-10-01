pageextension 34006902 "PERSales & Receivables Setup" extends "Sales & Receivables Setup"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    layout
    {
        addafter(GMANotCreateTaxArea)
        {
            field(PerCreateTaxArea; Rec.PerCreateTaxArea)
            {
                ApplicationArea = ALL;
                Visible = VisibleArgentina;

            }
        }

    }

    actions
    {

    }

    var

        CodArgentina: codeunit GMAArgentina2;
        VisibleArgentina: Boolean;
        VisibleChile: Boolean;
        VisibleColombia: Boolean;
        VisibleMexico: Boolean;
        VisiblePeru: Boolean;

    trigger OnOpenPage()
    begin

        CodArgentina.VisibleFieldLocalization(VisibleArgentina, VisibleChile, VisibleColombia, VisibleMexico, VisiblePeru);
    end;
}