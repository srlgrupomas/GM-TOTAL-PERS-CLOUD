pageextension 80889 PERTaxArea extends "Tax Area"
{
    layout
    {
        addafter("GMLocTax Area Ex. Gross income")
        {
            field(EntityID; rec.EntityID)
            {
                ApplicationArea = all;
                trigger OnAssistEdit()
                var
                    TaxAreaLine: Record "Tax Area Line";
                begin
                    TaxAreaLine.Reset();
                    TaxAreaLine.SetRange("Tax Area", Rec.Code);
                    IF (TaxAreaLine.FindFirst()) THEN
                        repeat
                            TaxAreaLine.EntityID := rec.EntityID;
                            TaxAreaLine.Modify();
                        until TaxAreaLine.Next() = 0;
                end;

                trigger OnValidate()
                var
                    TaxAreaLine: Record "Tax Area Line";
                begin
                    TaxAreaLine.Reset();
                    TaxAreaLine.SetRange("Tax Area", Rec.Code);
                    IF (TaxAreaLine.FindFirst()) THEN
                        repeat
                            TaxAreaLine.EntityID := rec.EntityID;
                            TaxAreaLine.Modify();
                        until TaxAreaLine.Next() = 0;
                end;

            }
            field(PERCustomerNo; rec.PERCustomerNo)
            {
                ApplicationArea = all;
            }
        }
    }
}
