page 34006902 "AXI Parámetros"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AXI Ajuste Inflacion";
    SourceTableView = order(Ascending) where(CuentaMovimiento = filter(<> ''));

    layout
    {
        area(Content)
        {
            group("AXI Parameters")
            {
                field("Date of the last fiscal year"; FechaInicio)
                {
                    ApplicationArea = All;
                }
                field("Adjustment date"; FechaFin)
                {
                    ApplicationArea = All;
                }
                field("Company Entity"; CompanyEntity)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code;

                    trigger OnValidate()
                    var
                        dimensiontable: Record "Dimension Value";
                    begin
                        if CompanyEntity <> '' then begin
                            dimensiontable.Reset();
                            dimensiontable.SetRange(code, CompanyEntity);
                            if not dimensiontable.FindFirst() then
                                Error('The Dimension Code %1 does not exist in the Dimension Value table.', CompanyEntity);
                        end;
                    end;
                }
                field("General Journal"; DiarioGeneral)
                {
                    ApplicationArea = All;
                    TableRelation = "Gen. Journal Template".Name;
                    trigger OnValidate()
                    begin
                        if DiarioGeneral = '' then begin
                            JournalBatch := '';
                            JournalBatchRevert := '';
                        end;
                    end;
                }
                field("Journal Batch"; JournalBatch)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        GenJournalBatch.Reset();
                        GenJournalBatch.SetRange("Journal Template Name", DiarioGeneral);
                        if GenJournalBatch.FindSet() then begin
                            if Page.RunModal(Page::"Gen. Journal Batch List", GenJournalBatch) = Action::LookupOK then begin
                                JournalBatch := GenJournalBatch.Name;
                                ValidateJournalBatch(JournalBatch, DiarioGeneral);
                            end;
                        end else begin
                            Message('There are no Journal Batches available for the selected General Ledger.');
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ValidateJournalBatch(JournalBatch, DiarioGeneral);
                    end;
                }

                field("Journal Batch Revertion"; JournalBatchRevert)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        GenJournalBatch.Reset();
                        GenJournalBatch.SetRange("Journal Template Name", DiarioGeneral);
                        if GenJournalBatch.FindSet() then begin
                            if Page.RunModal(Page::"Gen. Journal Batch List", GenJournalBatch) = Action::LookupOK then begin
                                JournalBatchRevert := GenJournalBatch.Name;
                                ValidateJournalBatch(JournalBatchRevert, DiarioGeneral);
                            end;
                        end else begin
                            Message('There are no Journal Batches available for the selected General Journal.');
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ValidateJournalBatch(JournalBatchRevert, DiarioGeneral);
                    end;
                }
                field("Document Number"; DocumentNumber)
                {
                    ApplicationArea = All;
                }
                field("Document Number Revertion"; DocumentNumberRevert)
                {
                    ApplicationArea = All;
                }
            }

            group("Inflation Coefficients")
            {
                repeater(Control1)
                {
                    field("Cuenta"; rec.CuentaMovimiento) { ApplicationArea = All; }
                    field("Cuenta No"; rec.CuentaMovimientoNo) { ApplicationArea = All; }
                    field("Fecha del movimiento"; rec.FechaMovimiento) { ApplicationArea = All; }
                    field("Valor del movimiento"; rec.ValorMovimiento) { ApplicationArea = All; }
                    field("Coeficiente"; rec."Coeficiente") { ApplicationArea = All; BlankZero = true; }
                    field("Valor ajustado"; rec."ValorAjustado") { ApplicationArea = All; }
                    field("Diferencia"; rec."Diferencia") { ApplicationArea = All; }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Coefficients")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CalcularCoeficientesInflacionarios();
                end;
            }

            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                begin
                    ImprimirRegistrosAPDF();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        AnioActual: Integer;
    begin
        AnioActual := Date2DMY(Today, 3);
        // FechaInicio := DMY2Date(31, 12, AnioActual - 1);
        Clear(FechaFin);
        Clear(CompanyEntity);
        Clear(AjusteInflacion);
        AjusteInflacion.Reset();
        AjusteInflacion.DeleteAll();
    end;

    local procedure GetLastDayOfMonth(Anio: Integer; Mes: Integer): Date
    begin
        exit(CalcDate('+1M-1D', DMY2Date(1, Mes, Anio)));
    end;

    local procedure ValidateJournalBatch(JournalBatchCode: Code[20]; TemplateName: Code[10])
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if JournalBatchCode <> '' then begin
            GenJournalBatch.Get(TemplateName, JournalBatchCode);
            if GenJournalBatch."Journal Template Name" <> TemplateName then
                Error('The selected Journal Batch does not belong to the specified General Ledger.');
        end;
    end;

    local procedure CalcularCoeficientesInflacionarios()
    var
        FechaActual: Date;
        IndiceFin: Decimal;
        IndiceFinInicial: Decimal;
        Indice2Inicio: Decimal;
        Indice2InicioInicial: Decimal;
        MesActual: Integer;
        PrimerDiaMesActual: date;
        UltimoDiaMesActual: date;
        AnioActual: Integer;
        MesFin: Integer;
        AnioFin: Integer;
        CuentaActual: Code[20];
        SumaInicial: Decimal;
        SumaPorCuenta: Dictionary of [Code[20], Decimal];
        SumaAjustadoTotal: Dictionary of [Code[20], Decimal];
        DiferenciaPorCuenta: Dictionary of [Code[20], Decimal];
        CuentaKey: Code[20];
        SumaTotal: Decimal;
        AjustadoTotal: Decimal;
        DiferenciaTotal: Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        CuentaAXI: Code[50];
        ValorDiferencia: Decimal;
        SumaTotalInvertido: Decimal;
        FechaFinRevert: Date;
        sumatotalporbatch: Decimal;
        sumatotalporbatchrevert: Decimal;
        MovimientosProcesados: Dictionary of [Integer, Boolean];
        generalLedgerSetUp: record 98;
        EntitySetUpExtend: Record 34006903;
        dimensionvalue: record "Dimension Value";
    begin
        MovimientoID := 1;

        AjusteInflacion.Reset();
        AjusteInflacion.DeleteAll();

        MesFin := Date2DMY(FechaFin, 2);
        AnioFin := Date2DMY(FechaFin, 3);

        IndicesIniciales.Reset();
        IndicesIniciales.SetFilter(GMAFecha, '%1..%2', DMY2Date(1, MesFin, AnioFin), GetLastDayOfMonth(AnioFin, MesFin));
        if IndicesIniciales.FindFirst() then
            IndiceFinInicial := IndicesIniciales.GMAIndice
        else
            Error('No index found for the date: %1', FechaFin);

        MesActual := Date2DMY(FechaInicio, 2);
        AnioActual := Date2DMY(FechaInicio, 3);

        IndicesIniciales.Reset();
        IndicesIniciales.SetFilter(GMAFecha, '%1..%2', DMY2Date(1, MesActual, AnioActual), GetLastDayOfMonth(AnioActual, MesActual));
        if IndicesIniciales.FindFirst() then
            Indice2InicioInicial := IndicesIniciales.GMAIndice
        else
            Error('No index found for the date %1.', FechaActual);

        // Procesamiento de Movimientos Anteriores a la Fecha de Inicio
        Movimientos.Reset();
        Movimientos.SetRange("Global Dimension 1 Code", CompanyEntity);
        Movimientos.SetFilter("Posting Date", '%1..%2', 0D, FechaInicio);
        Movimientos.SetCurrentKey("G/L Account No.", "Posting Date");

        // if Movimientos.FindSet() then begin
        //     repeat
        //         PlanAccount.Reset();
        //         PlanAccount.SetRange("No.", Movimientos."G/L Account No.");
        //         PlanAccount.SetFilter("GMATipo de cuenta AXI Local", 'Monetaria');

        //         if PlanAccount.FindFirst() then begin
        //             if CuentaActual <> Movimientos."G/L Account No." then begin
        //                 if CuentaActual <> '' then begin
        //                     AjusteInflacion.Init();
        //                     AjusteInflacion.ID := MovimientoID;
        //                     AjusteInflacion.CuentaMovimiento := GLAccountName;
        //                     AjusteInflacion.FechaMovimiento := FechaInicio;
        //                     AjusteInflacion.ValorMovimiento := SumaInicial;
        //                     AjusteInflacion.Coeficiente := IndiceFinInicial / Indice2InicioInicial;
        //                     AjusteInflacion.ValorAjustado := SumaInicial * AjusteInflacion.Coeficiente;
        //                     AjusteInflacion.Diferencia := AjusteInflacion.ValorAjustado - AjusteInflacion.ValorMovimiento;
        //                     AjusteInflacion.Insert();

        //                     MovimientoID := MovimientoID + 1;
        //                 end;

        //                 CuentaActual := Movimientos."G/L Account No.";
        //                 SumaInicial := 0;
        //                 GLAccountName := PlanAccount.Name;
        //             end;

        //             SumaInicial := SumaInicial + Movimientos.Amount;

        //             if SumaPorCuenta.ContainsKey(CuentaActual) then
        //                 SumaPorCuenta.Set(CuentaActual, SumaPorCuenta.Get(CuentaActual) + Movimientos.Amount)
        //             else
        //                 SumaPorCuenta.Add(CuentaActual, Movimientos.Amount);

        //             if SumaAjustadoTotal.containsKey(CuentaActual) then
        //                 SumaAjustadoTotal.set(CuentaActual, SumaAjustadoTotal.get(CuentaActual) + AjusteInflacion.ValorAjustado)
        //             else
        //                 SumaAjustadoTotal.add(CuentaActual, AjusteInflacion.ValorAjustado);

        //             if DiferenciaPorCuenta.ContainsKey(CuentaActual) then
        //                 DiferenciaPorCuenta.Set(CuentaActual, DiferenciaPorCuenta.Get(CuentaActual) + AjusteInflacion.Diferencia)
        //             else
        //                 DiferenciaPorCuenta.Add(CuentaActual, AjusteInflacion.Diferencia);
        //         end;

        //     until Movimientos.Next() = 0;

        //     if CuentaActual <> '' then begin
        //         AjusteInflacion.Init();
        //         AjusteInflacion.ID := MovimientoID;
        //         AjusteInflacion.CuentaMovimiento := GLAccountName;
        //         AjusteInflacion.FechaMovimiento := FechaInicio;
        //         AjusteInflacion.ValorMovimiento := SumaInicial;
        //         AjusteInflacion."Coeficiente" := IndiceFinInicial / Indice2InicioInicial;
        //         AjusteInflacion.ValorAjustado := SumaInicial * AjusteInflacion."Coeficiente";
        //         AjusteInflacion.Diferencia := AjusteInflacion.ValorAjustado - AjusteInflacion.ValorMovimiento;
        //         AjusteInflacion.Insert();

        //         MovimientoID := MovimientoID + 1;
        //     end;
        // end;

        // Procesamiento de Movimientos entre la Fecha de Inicio y Fin
        FechaActual := FechaInicio + 1;
        while FechaActual <= FechaFin do begin
            MesFin := Date2DMY(FechaFin, 2);
            AnioFin := Date2DMY(FechaFin, 3);

            Indices.Reset();
            Indices.SetFilter(GMAFecha, '%1..%2', DMY2Date(1, MesFin, AnioFin), GetLastDayOfMonth(AnioFin, MesFin));
            if Indices.FindFirst() then
                IndiceFin := Indices.GMAIndice;

            MesActual := Date2DMY(FechaActual, 2);
            AnioActual := Date2DMY(FechaActual, 3);

            Indices.Reset();
            Indices.SetFilter(GMAFecha, '%1..%2', DMY2Date(1, MesActual, AnioActual), GetLastDayOfMonth(AnioActual, MesActual));
            if Indices.FindFirst() then
                Indice2Inicio := Indices.GMAIndice;

            // Calcular el primer y último día del mes actual
            PrimerDiaMesActual := DMY2Date(1, MesActual, AnioActual);
            UltimoDiaMesActual := GetLastDayOfMonth(AnioActual, MesActual);

            Movimientos.Reset();
            Movimientos.SetRange("Global Dimension 1 Code", CompanyEntity);
            Movimientos.SetFilter("Posting Date", '%1..%2', PrimerDiaMesActual, UltimoDiaMesActual);
            Movimientos.SetCurrentKey("G/L Account No.", "Posting Date");

            if Movimientos.FindSet() then begin
                repeat
                    // Verificar si el movimiento ya ha sido procesado
                    if not MovimientosProcesados.ContainsKey(Movimientos."Entry No.") then begin
                        PlanAccount.Reset();
                        PlanAccount.SetRange("No.", Movimientos."G/L Account No.");
                        PlanAccount.SetFilter("GMATipo de cuenta AXI Local", 'Monetaria');

                        if PlanAccount.FindFirst() then begin
                            if CuentaActual <> Movimientos."G/L Account No." then begin
                                CuentaActual := Movimientos."G/L Account No.";
                                GLAccountName := PlanAccount.Name;
                            end;

                            if GLAccountName <> '' then begin
                                // Verificar si el Amount es diferente de 0
                                if Movimientos.Amount <> 0 then begin
                                    AjusteInflacion.Init();
                                    AjusteInflacion.ID := MovimientoID;
                                    AjusteInflacion.CuentaMovimiento := GLAccountName;
                                    AjusteInflacion.FechaMovimiento := Movimientos."Posting Date";
                                    AjusteInflacion.ValorMovimiento := Movimientos.Amount;
                                    AjusteInflacion.Coeficiente := IndiceFin / Indice2Inicio;
                                    AjusteInflacion.ValorAjustado := Movimientos.Amount * AjusteInflacion.Coeficiente;
                                    AjusteInflacion.Diferencia := AjusteInflacion.ValorAjustado - AjusteInflacion.ValorMovimiento;
                                    AjusteInflacion.CuentaMovimientoNo := Movimientos."G/L Account No.";
                                    AjusteInflacion.Insert();

                                    MovimientoID := MovimientoID + 1;

                                    // Actualizar sumas por cuenta
                                    if SumaPorCuenta.ContainsKey(CuentaActual) then
                                        SumaPorCuenta.Set(CuentaActual, SumaPorCuenta.Get(CuentaActual) + Movimientos.Amount)
                                    else
                                        SumaPorCuenta.Add(CuentaActual, Movimientos.Amount);

                                    if SumaAjustadoTotal.ContainsKey(CuentaActual) then
                                        SumaAjustadoTotal.Set(CuentaActual, SumaAjustadoTotal.Get(CuentaActual) + AjusteInflacion.ValorAjustado)
                                    else
                                        SumaAjustadoTotal.Add(CuentaActual, AjusteInflacion.ValorAjustado);

                                    if DiferenciaPorCuenta.ContainsKey(CuentaActual) then
                                        DiferenciaPorCuenta.Set(CuentaActual, DiferenciaPorCuenta.Get(CuentaActual) + AjusteInflacion.Diferencia)
                                    else
                                        DiferenciaPorCuenta.Add(CuentaActual, AjusteInflacion.Diferencia);

                                    // Marcar el movimiento como procesado
                                    MovimientosProcesados.Add(Movimientos."Entry No.", true);
                                end;
                            end;
                        end;
                    end;

                until Movimientos.Next() = 0;
            end;

            FechaActual := CalcDate('+1M', FechaActual);
        end;

        sumatotalporbatch := 0;
        sumatotalporbatchrevert := 0;

        foreach CuentaKey in SumaPorCuenta.Keys do begin
            SumaTotal := 0;
            AjustadoTotal := 0;
            DiferenciaTotal := 0;

            SumaTotal := Round(SumaPorCuenta.Get(CuentaKey), 0.01);
            AjustadoTotal := Round(SumaAjustadoTotal.Get(CuentaKey), 0.01);
            DiferenciaTotal := Round(DiferenciaPorCuenta.Get(CuentaKey), 0.01);

            PlanAccount.Reset();
            PlanAccount.SetFilter("No.", CuentaKey);
            PlanAccount.SetFilter("GMATipo de cuenta AXI Local", 'Monetaria');
            if PlanAccount.FindFirst() then begin
                GLAccountName := PlanAccount.Name;
                CuentaAXI := PlanAccount."No.";
                if PlanAccount."GMACuenta AXI Local" <> '' then
                    if JournalBatchRevert <> '' then begin
                        CuentaAXI := PlanAccount."GMACuenta AXI Local";
                    end;


                AjusteInflacion.Init();
                AjusteInflacion.ID := MovimientoID;
                AjusteInflacion.CuentaMovimiento := GLAccountName;
                AjusteInflacion.FechaMovimiento := FechaFin;
                AjusteInflacion.ValorMovimiento := SumaTotal;
                AjusteInflacion.ValorAjustado := AjustadoTotal;
                AjusteInflacion.Diferencia := DiferenciaTotal;
                AjusteInflacion.CuentaMovimientoNo := 'SubTotal';
                AjusteInflacion.Insert();
            end;

            // Generación de Líneas de Diario
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", DiarioGeneral);
            GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
            if GenJournalLine.FindLast() then
                LineNo := GenJournalLine."Line No." + 10000
            else
                LineNo := 10000;

            GenJournalLine.Init();
            GenJournalLine."Journal Template Name" := DiarioGeneral;
            GenJournalLine."Journal Batch Name" := JournalBatch;
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Posting Date" := FechaFin;
            GenJournalLine."Document Date" := FechaFin;
            GenJournalLine."VAT Reporting Date" := FechaFin;
            GenJournalLine."Last Modified DateTime" := CreateDateTime(FechaFin, 000000T);
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
            GenJournalLine."Document No." := DocumentNumber;
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            GenJournalLine."Account No." := CuentaAXI;
            GenJournalLine.Description := 'AXI - ' + GLAccountName;
            GenJournalLine.Amount := Round(DiferenciaTotal, 0.01);
            GenJournalLine."Debit Amount" := Round(DiferenciaTotal, 0.01);
            GenJournalLine."Amount (LCY)" := Round(DiferenciaTotal, 0.01);
            GenJournalLine."Balance (LCY)" := Round(DiferenciaTotal, 0.01);
            GenJournalLine."VAT Base Amount" := Round(DiferenciaTotal, 0.01);
            GenJournalLine."Bal. VAT Base Amount" := Round(-DiferenciaTotal, 0.01);
            GenJournalLine."VAT Amount (LCY)" := Round(DiferenciaTotal, 0.01);
            GenJournalLine."Bal. VAT Amount (LCY)" := Round(-DiferenciaTotal, 0.01);
            GenJournalLine."Source Code" := 'AXI';
            GenJournalLine.BssiOriginalEntityID := CompanyEntity;
            GenJournalLine.Validate("Shortcut Dimension 1 Code", CompanyEntity);
            if JournalBatchRevert = '' then begin
                EntitySetUpExtend.Reset();
                EntitySetUpExtend.SetFilter("Dimension Code", CompanyEntity);
                EntitySetUpExtend.FindFirst();
                dimensionvalue.Reset();
                dimensionvalue.SetRange("Code", EntitySetUpExtend.AssetValue);
                if dimensionvalue.FindFirst() then begin
                    GenJournalLine.Validate("Shortcut Dimension 2 Code", dimensionvalue.Code);
                end;
                GenJournalLine.ValidateShortcutDimCode(3, EntitySetUpExtend.DepartmentValue);
                GenJournalLine.ValidateShortcutDimCode(4, EntitySetUpExtend.IntercompanyValue);
            end;
            GenJournalLine.BssiEntityID := CompanyEntity;
            GenJournalLine."Additional-Currency Posting" := 1;
            if GenJournalLine.Amount <> 0 then begin
                GenJournalLine.Insert();
            end;

            sumatotalporbatch := sumatotalporbatch + GenJournalLine.Amount;

            if JournalBatchRevert <> '' then begin
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", DiarioGeneral);
                GenJournalLine.SetRange("Journal Batch Name", JournalBatchRevert);
                if GenJournalLine.FindLast() then
                    LineNo := GenJournalLine."Line No." + 10000
                else
                    LineNo := 10000;

                SumaTotalInvertido := Round(-DiferenciaTotal, 0.01);
                FechaFinRevert := FechaFin + 1;

                GenJournalLine.Init();
                GenJournalLine."Journal Template Name" := DiarioGeneral;
                GenJournalLine."Journal Batch Name" := JournalBatchRevert;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Posting Date" := FechaFinRevert;
                GenJournalLine."Document Date" := FechaFinRevert;
                GenJournalLine."VAT Reporting Date" := FechaFinRevert;
                GenJournalLine."Last Modified DateTime" := CreateDateTime(FechaFinRevert, 000000T);
                GenJournalLine."Document No." := DocumentNumberRevert;
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine."Account No." := CuentaAXI;
                GenJournalLine.Description := 'AXI - Reversión - ' + GLAccountName;
                GenJournalLine.Amount := SumaTotalInvertido;
                GenJournalLine."Debit Amount" := SumaTotalInvertido;
                GenJournalLine."Amount (LCY)" := SumaTotalInvertido;
                GenJournalLine."Balance (LCY)" := SumaTotalInvertido;
                GenJournalLine."VAT Base Amount" := SumaTotalInvertido;
                GenJournalLine."Bal. VAT Base Amount" := Round(-SumaTotalInvertido, 0.01);
                GenJournalLine."VAT Amount (LCY)" := SumaTotalInvertido;
                GenJournalLine."Bal. VAT Amount (LCY)" := Round(-SumaTotalInvertido, 0.01);
                GenJournalLine."Source Code" := 'AXI';
                GenJournalLine.BssiOriginalEntityID := CompanyEntity;
                GenJournalLine."Shortcut Dimension 1 Code" := CompanyEntity;
                GenJournalLine.BssiEntityID := CompanyEntity;
                GenJournalLine."Additional-Currency Posting" := 1;
                // Solo insertar si Amount no es 0
                if GenJournalLine.Amount <> 0 then begin
                    GenJournalLine.Insert();
                    sumatotalporbatchrevert := sumatotalporbatchrevert + GenJournalLine.Amount;
                end;
            end;

            MovimientoID := MovimientoID + 1;
        end;

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", DiarioGeneral);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJournalLine.FindLast() then
            LineNo := GenJournalLine."Line No." + 10000
        else
            LineNo := 10000;

        generalLedgerSetUp.Reset();
        if generalLedgerSetUp.FindFirst() then begin
            if JournalBatchRevert <> '' then begin
                CuentaAXI := generalLedgerSetUp."GMACta AXI Local Gan";
            end;
            if JournalBatchRevert = '' then begin
                CuentaAXI := PlanAccount."No.";
            end;
            PlanAccount.Reset();
            PlanAccount.SetFilter("No.", CuentaAXI);
            if PlanAccount.FindFirst() then begin
                GLAccountName := PlanAccount.Name;
            end;
        end;

        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := DiarioGeneral;
        GenJournalLine."Journal Batch Name" := JournalBatch;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Posting Date" := FechaFin;
        GenJournalLine."Document Date" := FechaFin;
        GenJournalLine."VAT Reporting Date" := FechaFin;
        GenJournalLine."Last Modified DateTime" := CreateDateTime(FechaFin, 000000T);
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
        GenJournalLine."Document No." := DocumentNumber;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine."Account No." := CuentaAXI;
        GenJournalLine.Description := 'AXI - ' + GLAccountName;
        GenJournalLine.Amount := Round(-sumatotalporbatch, 0.01);
        GenJournalLine."Debit Amount" := Round(sumatotalporbatch, 0.01);
        GenJournalLine."Amount (LCY)" := Round(-sumatotalporbatch, 0.01);
        GenJournalLine."Balance (LCY)" := Round(-sumatotalporbatch, 0.01);
        GenJournalLine."VAT Base Amount" := Round(-sumatotalporbatch, 0.01);
        GenJournalLine."Bal. VAT Base Amount" := Round(-sumatotalporbatch, 0.01);
        GenJournalLine."VAT Amount (LCY)" := Round(-sumatotalporbatch, 0.01);
        GenJournalLine."Bal. VAT Amount (LCY)" := Round(-sumatotalporbatch, 0.01);
        GenJournalLine."Additional-Currency Posting" := 1;
        GenJournalLine."Source Code" := 'AXI';
        GenJournalLine.BssiOriginalEntityID := CompanyEntity;
        GenJournalLine.Validate("Shortcut Dimension 1 Code", CompanyEntity);
        GenJournalLine.BssiEntityID := CompanyEntity;
        if JournalBatchRevert = '' then begin
            EntitySetUpExtend.Reset();
            EntitySetUpExtend.SetFilter("Dimension Code", CompanyEntity);
            EntitySetUpExtend.FindFirst();
            dimensionvalue.Reset();
            dimensionvalue.SetRange("Dimension Code", EntitySetUpExtend.Asset);
            if dimensionvalue.FindFirst() then begin
                GenJournalLine.Validate("Shortcut Dimension 2 Code", dimensionvalue.Code);
            end;
            GenJournalLine.ValidateShortcutDimCode(3, EntitySetUpExtend.DepartmentValue);
            GenJournalLine.ValidateShortcutDimCode(4, EntitySetUpExtend.IntercompanyValue);
        end;
        if GenJournalLine.Amount <> 0 then
            GenJournalLine.Insert();

        if JournalBatchRevert <> '' then begin
            GenJournalLine.Reset();
            GenJournalLine.SetRange("Journal Template Name", DiarioGeneral);
            GenJournalLine.SetRange("Journal Batch Name", JournalBatchRevert);
            if GenJournalLine.FindLast() then
                LineNo := GenJournalLine."Line No." + 10000
            else
                LineNo := 10000;

            FechaFinRevert := FechaFin + 1;

            GenJournalLine.Init();
            GenJournalLine."Journal Template Name" := DiarioGeneral;
            GenJournalLine."Journal Batch Name" := JournalBatchRevert;
            GenJournalLine."Line No." := LineNo;
            GenJournalLine."Posting Date" := FechaFinRevert;
            GenJournalLine."Document Date" := FechaFinRevert;
            GenJournalLine."VAT Reporting Date" := FechaFinRevert;
            GenJournalLine."Last Modified DateTime" := CreateDateTime(FechaFinRevert, 000000T);
            GenJournalLine."Document No." := DocumentNumberRevert;
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            GenJournalLine."Account No." := CuentaAXI;
            GenJournalLine.Description := 'AXI - Reversión - ' + GLAccountName;
            GenJournalLine.Amount := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."Debit Amount" := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."Amount (LCY)" := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."Balance (LCY)" := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."VAT Base Amount" := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."Bal. VAT Base Amount" := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."VAT Amount (LCY)" := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."Bal. VAT Amount (LCY)" := Round(-sumatotalporbatchrevert, 0.01);
            GenJournalLine."Additional-Currency Posting" := 1;
            GenJournalLine."Source Code" := 'AXI';
            GenJournalLine.BssiOriginalEntityID := CompanyEntity;
            GenJournalLine."Shortcut Dimension 1 Code" := CompanyEntity;
            GenJournalLine.BssiEntityID := CompanyEntity;
            if GenJournalLine.Amount <> 0 then
                GenJournalLine.Insert();
        end;

        CurrPage.Update();
    end;

    local procedure ImprimirRegistrosAPDF()
    var
        AjusteInflacionReport: Report "AXI Ajuste Inflacion Report";
    begin
        AjusteInflacion.Reset();
        AjusteInflacion.SetCurrentKey(CuentaMovimiento, FechaMovimiento);
        AjusteInflacionReport.SetTableView(AjusteInflacion);
        AjusteInflacionReport.SetFechas(FechaFin, Date2DMY(FechaFin, 3), FechaInicio);
        AjusteInflacionReport.Run();
    end;

    var
        FechaInicio: Date;
        FechaFin: Date;
        Indices: Record "GMAInd Ajuste por Inflacion";
        IndicesIniciales: Record "GMAInd Ajuste por Inflacion";
        IndiceFin: Decimal;
        Indice2Inicio: Decimal;
        AjusteInflacion: Record "AXI Ajuste Inflacion";
        GLAccount: Code[20];
        PlanAccount: Record 15;
        Movimientos: Record 17;
        CompanyEntity: Code[20];
        GLAccountName: Text[100];
        MovimientoID: Integer;
        DiarioGeneral: Code[10];
        JournalBatch: Code[20];
        JournalBatchRevert: Code[20];
        DocumentNumber: Text[100];
        DocumentNumberRevert: Text[100];
        JournalBatchRecord: Record 232;
        JournalBatchRevertRecord: Record 232;
}