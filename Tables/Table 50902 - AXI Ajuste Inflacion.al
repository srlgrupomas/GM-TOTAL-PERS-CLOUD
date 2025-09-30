table 80902 "AXI Ajuste Inflacion"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "ID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "FechaMovimiento"; Date) { }
        field(3; "CuentaMovimiento"; Text[100]) { }
        field(4; "ValorMovimiento"; Decimal) { }
        field(5; "Coeficiente"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 5 : 5;
        }
        field(6; "ValorAjustado"; Decimal) { }
        field(7; "Diferencia"; Decimal) { }
        field(8; "CuentaMovimientoNo"; Code[20]) { }
    }

    keys
    {
        key(PK; "ID")
        {
            Clustered = true;
        }
        key(CuentaOrdenada; "CuentaMovimiento")
        {
            MaintainSIFTIndex = true;
        }
        key(Key1; CuentaMovimiento, FechaMovimiento) { }

    }
}