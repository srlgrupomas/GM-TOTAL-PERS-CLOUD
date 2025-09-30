namespace GMTOTALPERS.GMTOTALPERS;

using Microsoft.Finance.GeneralLedger.Ledger;

pageextension 80992 GeneralLedgerEntry extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {

            field("PERNombre Cliente"; rec."PERNombre Cliente")
            {
                ApplicationArea = all;
            }
            field("PERNombre Proveedor"; rec."PERNombre Proveedor")
            {
                ApplicationArea = all;
            }
            field("PERCodigo Cuenta Corporacion"; rec."PERCodigo Cuenta Corporacion")
            {
                ApplicationArea = all;
            }
            field("PERNombre Cuenta Corporacion"; rec."PERNombre Cuenta Corporacion")
            {
                ApplicationArea = all;
            }
        }
    }
}
