// page 80892 "Procesar Revaluaciones Modal"
// {
//     PageType = Card;
//     ApplicationArea = All;
//     Editable = true;
//     Caption = 'Procesar Revaluaciones';

//     actions
//     {
//         area(processing)
//         {
//             action(Procesar)
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Procesar';
//                 Image = Process;

//                 trigger OnAction()
//                 begin
//                     ProcesarRevaluacionesAXI();
//                 end;
//             }
//         }
//     }

//     procedure ProcesarRevaluacionesAXI()
//     var
//         Movimientos: Record "Ledger Entry Matching Buffer";
//         Coeficientes: Record "GMLocInd Ajuste por Inflacion";
//         MEMSetup: Record BssiMEMSystemSetup;
//         GenJnlLine: Record "Gen. Journal Line";
//         FechaInicio: Date;
//         FechaFin: Date;
//         FechaActual: Date;
//         TotalOrigen: Decimal;
//         TotalActual: Decimal;
//         TotalDiferencia: Decimal;
//         CoeficienteDesde: Decimal;
//         CoeficienteHasta: Decimal;
//         Coeficiente: Decimal;
//         ValorActual: Decimal;
//         Diferencia: Decimal;
//     begin
//         FechaInicio := CALCDATE('<-1Y>', TODAY);
//         FechaFin := DMY2DATE(31, 12, DATE2DMY(TODAY, 3));

//         TotalOrigen := 0;
//         TotalActual := 0;
//         TotalDiferencia := 0;

//         FechaActual := FechaInicio;

//         while FechaActual <= FechaFin do begin
//             if not Coeficientes.GET(Coeficientes.GMLocFecha = FechaInicio) then
//                 ERROR('No se encontró un coeficiente para la fecha de inicio %1.', FechaInicio);
//             CoeficienteDesde := Coeficientes.GMLocIndice;

//             if not Coeficientes.GET(Coeficientes.GMLocFecha = FechaActual) then
//                 ERROR('No se encontró un coeficiente para la fecha %1.', FechaActual);
//             CoeficienteHasta := Coeficientes.GMLocIndice;

//             Coeficiente := CoeficienteHasta / CoeficienteDesde;

//             Movimientos.SetRange("Posting Date", FechaActual, CALCDATE('<1M>', FechaActual));
//             if Movimientos.FindSet then begin
//                 repeat
//                     ValorActual := Movimientos."Remaining Amount" * Coeficiente;
//                     Diferencia := ValorActual - Movimientos."Remaining Amount";

//                     TotalOrigen += Movimientos."Remaining Amount";
//                     TotalActual += ValorActual;
//                     TotalDiferencia += Diferencia;

//                     GenJnlLine.Init();
//                     GenJnlLine."Posting Date" := FechaActual;
//                     GenJnlLine.Amount := Diferencia;
//                     GenJnlLine.Description := 'Revaluación patrimonial';
//                     GenJnlLine."Account No." := 'Cuenta_Patrimonial';
//                     GenJnlLine.INSERT(true);
//                 until Movimientos.Next = 0;
//             end;

//             FechaActual := CALCDATE('<1M>', FechaActual);
//         end;

//         GenJnlLine.Init();
//         GenJnlLine."Posting Date" := FechaFin;
//         GenJnlLine.Amount := TotalDiferencia * -1;
//         GenJnlLine.Description := 'Revaluación final del año';
//         GenJnlLine."Account No." := 'R.E.C.P.A.M.';
//         GenJnlLine.INSERT(true);

//         MESSAGE('Proceso completado. Totales: Origen: %1, Actual: %2, Diferencia: %3',
//             TotalOrigen, TotalActual, TotalDiferencia);
//     end;

// }