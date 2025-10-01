pageextension 34006888 PERTaxAreaLine extends "Tax Area Line"
{
    layout
    {
        addafter("Calculation Order")
        {
            field(EntityID; rec.EntityID)
            {
                ApplicationArea = all;
                //Editable = false;
            }
        }
    }
}
