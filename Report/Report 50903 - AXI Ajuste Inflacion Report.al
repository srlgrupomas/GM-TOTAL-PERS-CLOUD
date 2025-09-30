report 80903 "AXI Ajuste Inflacion Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Layout\report 80903 - AXIAjusteInflacionReport.rdl';

    dataset
    {
        dataitem("AXI Ajuste Inflacion"; "AXI Ajuste Inflacion")
        {
            column(CuentaMovimiento; CuentaMovimiento) { }
            column(CuentaMovimientoNo; CuentaMovimientoNo) { }
            column(FechaMovimiento; FechaMovimiento) { }
            column(ValorMovimiento; ValorMovimiento) { }
            column(Coeficiente; Coeficiente) { }
            column(ValorAjustado; ValorAjustado) { }
            column(Diferencia; Diferencia) { }
            column(AnioEjercicio; AnioEjercicio) { }
            column(FechaFin; FechaFin) { }
            column(FechaUltimoEjercicio; FechaUltimoEjercicio) { }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
    }

    procedure SetFechas(FechaFinP: date; AnioFinP: Integer; FechaInicioP: date)
    begin
        FechaFin := FechaFinP;
        AnioEjercicio := AnioFinP;
        FechaUltimoEjercicio := FechaInicioP;
    end;

    var
        FechaFin: date;
        AnioEjercicio: Integer;
        FechaUltimoEjercicio: date;
}