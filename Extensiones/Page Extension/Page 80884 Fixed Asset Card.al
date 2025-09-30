pageextension 80884 "PersFixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        addafter("GMLocActivo")
        {
            field("PersCurrency Code"; rec."PersCurrency Code") { ApplicationArea = all; }
            field("PersCurrency Factor"; rec."PersCurrency Factor") { ApplicationArea = all; }
            field("PersExchange Rate FA"; rec."PersExchange Rate FA") { ApplicationArea = all; }
        }
    }
}