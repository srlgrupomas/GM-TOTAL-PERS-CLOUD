namespace GMTOTALPERS.GMTOTALPERS;

tableextension 34006871 GMAWitholdngLedgerEntry extends "GMAWithholding Ledger Entry"
{
    fields
    {
        field(34006870; "GMADocumentDate"; Date)
        {
            Caption = 'Document Date';

            FieldClass = FlowField;
            CalcFormula = lookup("GMAPosted Payment Order"."GMAPayment O. Date" where("GMAPayment O. No." = field("GMAVoucher Number")));
        }
    }
}
