namespace GMTOTALPERS.GMTOTALPERS;

tableextension 80871 GMlocWitholdngLedgerEntry extends "GMLocWithholding Ledger Entry"
{
    fields
    {
        field(80870; "GMLocDocumentDate"; Date)
        {
            Caption = 'Document Date';

            FieldClass = FlowField;
            CalcFormula = lookup("GMLocPosted Payment Order"."GMLocPayment O. Date" where("GMLocPayment O. No." = field("GMLocVoucher Number")));
        }
    }
}
