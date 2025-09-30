report 80908 "PERS SIRE IVA"
{
    caption = 'SIRE - IVA';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
            dataitem("GMLocWithholding Ledger Entry"; "GMLocWithholding Ledger Entry")
            {
                DataItemTableView = SORTING("GMLocNo.") ORDER(Ascending) WHERE("GMLocWithholding Type" = FILTER(Realizada));
                trigger OnPreDataItem()
                begin
                    IF (fechaposting) Then
                        "GMLocWithholding Ledger Entry".SetRange("GMLocWithholding Ledger Entry"."GMLocWithholding Date", FechaDesde, FechaHasta)
                    else
                        "GMLocWithholding Ledger Entry".SetRange("GMLocWithholding Ledger Entry".GMLocDocumentDate, FechaDesde, FechaHasta);
                    "GMLocWithholding Ledger Entry".SetFilter("GMLocWithholding Ledger Entry"."GMLocShortcut Dimension 1", BssiDimension);
                    "GMLocWithholding Ledger Entry".SetFilter("GMLocWithholding Ledger Entry"."GMLocTax System", '%1|%2', '212', '214');
                    "GMLocWithholding Ledger Entry".SetFilter("GMLocWithholding Ledger Entry"."GMLocWithholding Type", '%1', "GMLocWithholding Ledger Entry"."GMLocWithholding Type"::Realizada);

                    // JCG Segun la fecha elegida cambia el campo
                    "GMLocWithholding Ledger Entry".CalcFields(GMLocDocumentDate);
                end;

                trigger OnAfterGetRecord()
                var
                    CompPago: Record "GMLocPosted Payment Ord Vouch";
                    PIH: Record "Purch. Inv. Header";
                    PICM: Record "Purch. Cr. Memo Hdr.";
                    vatentry: record "VAT Entry";
                begin
                    Campo1 := '';
                    Campo2 := '';
                    Campo3 := '';
                    Campo4 := '';
                    Campo5 := '';
                    Campo6 := '';
                    Campo7 := '';
                    Campo8 := '';
                    Campo9 := '';
                    Campo10 := '';
                    Campo11 := '';
                    Campo12 := '';
                    Campo13 := '';
                    Campo14 := '';
                    Campo15 := '';
                    Campo16 := '';
                    Campo17 := '';
                    Campo18 := '';
                    Campo19 := '';
                    Campo20 := '';
                    Campo21 := '';
                    Campo22 := '';
                    Campo23 := '';
                    Campo24 := '';
                    Campo25 := '';
                    Campo26 := '';

                    EscribirFichero := TRUE;
                    NumeroLineas += 1;

                    //Version (fijo)
                    Campo1 := '0100';

                    //Codigo de trazabilidad
                    Campo2 := '                                    ';

                    //Impuesto
                    Campo3 := '216';

                    InfoEmpresa.Reset();
                    InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    InfoEmpresa.SetFilter(Code, BssiDimension);
                    IF (InfoEmpresa.FindFirst()) THEN;

                    //Regimen
                    Campo4 := '831';

                    "GMLocWithholding Ledger Entry".CalcFields(GMLocDocumentDate);

                    //Fecha de retencion
                    // JCG Se solicita mostrar solo la Document date
                    // if fechaposting = true then
                    //     Campo5 := FORMAT("GMLocWithholding Ledger Entry"."GMLocWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>')
                    // else
                    Campo5 := FORMAT("GMLocWithholding Ledger Entry".GMLocDocumentDate, 10, '<Day,2>/<Month,2>/<Year4>');

                    //Condicion
                    Campo6 := '01';

                    //Imposibilidad de retencion 
                    Campo7 := '0';

                    //No retencion motivo
                    Campo8 := '                              ';

                    //Importe de retencion
                    Campo9 := CompletarCerosAIzquierda(format("GMLocWithholding Ledger Entry"."GMLocWithholding Amount"), 14);

                    //Importe base
                    Campo10 := CompletarCerosAIzquierda(FORMAT("GMLocWithholding Ledger Entry"."GMLocCalculation Base"), 14);

                    //Regimen de exclusion
                    if "GMLocWithholding Ledger Entry"."GMLocExemption %" > 0 then
                        campo11 := '1'
                    else
                        campo11 := '0';

                    //Porcentaje de exclusion
                    campo12 := CompletarCerosAIzquierda(DelChr(format("GMLocWithholding Ledger Entry"."GMLocExemption %"), '=', '-'), 6);

                    //Fecha de publicacion
                    // JCG Se solicita mostrar solo la Document date
                    campo13 := FORMAT("GMLocWithholding Ledger Entry"."GMLocDocumentDate", 0, '<Day,2>/<Month,2>/<Year4>');
                    if (campo13 = '') or (campo13 = '00/00/0000') then
                        campo13 := '          ';

                    //Tipo de comprobante
                    CompPago.reset();
                    CompPago.SetRange(CompPago."GMLocPayment Order No.", "GMLocWithholding Ledger Entry"."GMLocVoucher Number");
                    if CompPago.findfirst() then
                        case CompPago."GMLocDocument Type" of
                            CompPago."GMLocDocument Type"::Invoice:
                                campo14 := '01';
                            CompPago."GMLocDocument Type"::"Credit Memo":
                                campo14 := '03';
                            CompPago."GMLocDocument Type"::"Nota Débito":
                                campo14 := '04';
                        end;

                    //Fecha de comprobante
                    Campo15 := format("GMLocWithholding Ledger Entry"."GMLocDocumentDate", 0, '<Day,2>/<Month,2>/<Year4>');

                    //Numero de comprobante
                    PIH.Reset();
                    PIH.SetRange(PIH."No.", CompPago."GMLocVoucher No.");
                    if PIH.FINDFIRST() then begin
                        Campo16 := CompletarEspaciosADerecha(FormatVoucherNumber(PIH."Vendor Invoice No."), 16);
                    end else
                        Campo16 := '                ';

                    //COE
                    Campo17 := '            ';

                    //COE Original
                    Campo18 := '            ';

                    //CAE
                    Campo19 := '              ';

                    //Importe del comprobante
                    Campo20 := CompletarCerosAIzquierda(format("GMLocWithholding Ledger Entry"."GMLocVoucher Amount"), 14);

                    //Motivo emision
                    Campo21 := '                              ';

                    //Retenido clave
                    Proveedor.RESET;
                    Proveedor.SETRANGE(Proveedor."No.", "GMLocWithholding Ledger Entry"."GMLocVendor Code");
                    IF Proveedor.FINDFIRST THEN
                        Campo22 := DelChr(Proveedor."VAT Registration No.", '=', '-+');

                    //Certificado original numero
                    Campo23 := '                         ';

                    //certificado original fecha
                    Campo24 := '          ';

                    //certificado original importe
                    Campo25 := '              ';

                    //motivo de anulacion
                    Campo26 := ' ';

                    CLEAR(Texto);
                    Texto := (
                    FORMAT(Campo1) +
                    FORMAT(Campo2) +
                    FORMAT(Campo3) +
                    FORMAT(Campo4) +
                    FORMAT(Campo5) +
                    FORMAT(Campo6) +
                    FORMAT(Campo7) +
                    FORMAT(Campo8) +
                    FORMAT(Campo9) +
                    FORMAT(Campo10) +
                    FORMAT(Campo11) +
                    FORMAT(Campo12) +
                    FORMAT(Campo13) +
                    FORMAT(Campo14) +
                    FORMAT(Campo15) +
                    FORMAT(Campo16) +
                    FORMAT(Campo17) +
                    FORMAT(Campo18) +
                    FORMAT(Campo19) +
                    FORMAT(Campo20) +
                    FORMAT(Campo21) +
                    FORMAT(Campo22) +
                    FORMAT(Campo23) +
                    FORMAT(Campo24) +
                    FORMAT(Campo25) +
                    FORMAT(Campo26));
                    "#RellenaExcelBuff"(Texto)
                end;

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GMLocOptions)
                {
                    Caption = 'Options';

                    field(FechaDesde; FechaDesde)
                    {
                        Caption = 'From date',;
                        ApplicationArea = All;
                    }

                    field(FechaHasta; FechaHasta)
                    {
                        caption = 'To date',;
                        ApplicationArea = all;
                    }

                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        Importance = Promoted;

                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            SecurityHelper: Codeunit BssiMEMSecurityHelper;
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            SecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;

                        trigger OnValidate()
                        var
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;
                    }
                    field(fechaposting; fechaposting)
                    {
                        Caption = 'Use Posting Date';
                        ApplicationArea = ALL;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CR := 13;
        FL := 10;
    end;

    trigger OnPostReport();
    begin
        if NumeroLineas = 0 then
            MESSAGE(Text004)
        else begin
            //La ultima linea debe ser vacia.
            CLEAR(Texto);
            Texto := '';
            NumeroLineas := NumeroLineas + 1;
            "#RellenaExcelBuff"(Texto);

            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuff);
            Xmlport.Run(80396, false, false, TempExcelBuff);
        end;

    end;

    var
        XMLImporExport: XmlPort "GMLocXML ImportExport";
        Campo1: Text[4];
        Campo2: Text[36];
        Campo3: Text[3];
        Campo4: Text[3];
        Campo5: Text[10];
        Campo6: Text[2];
        Campo7: Text[1];
        Campo8: Text[30];
        Campo9: Text[14];
        Campo10: Text[14];
        Campo10Bis: Text[1];
        CAmpo11aux: Text[16];
        Campo11: Text[1];
        Campo12: Text[6];
        Campo13: Text[10];
        Campo14: Text[2];
        Campo15: Text[10];
        Campo16: Text[16];
        Campo17: Text[32];
        Campo18: Text[12];
        Campo19: Text[14];
        Campo20: Text[14];
        Campo21: Text[30];
        Campo22: Text[11];
        Campo23: Text[25];
        Campo24: Text[10];
        Campo25: Text[14];
        Campo26: Text[1];
        FechaDesde: Date;
        FechaHasta: Date;
        Proveedor: Record 23;
        InfoEmpresa: Record "Dimension Value";
        Texto: Text[1024];
        NumeroLineas: Integer;
        EscribirFichero: Boolean;
        TempExcelBuff: Record 370 TEMPORARY;
        CR: Char;
        FL: Char;
        Text004: label 'There are no records to generate the report.',;

        BssiDimension: Text;

        BssiDimensionForRestriction: Text;
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMDimensionsOneTwoVisible: Boolean;
        BssiMEMDefaultEntity: record BssiMEMDefaultEntity;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        fechaposting: Boolean;

    PROCEDURE "#RellenaExcelBuff"(pTexto: Text[1024]);
    BEGIN
        TempExcelBuff.INIT;
        TempExcelBuff."Row No." := NumeroLineas;
        TempExcelBuff."Cell Value as Text" := COPYSTR(pTexto, 1, 250);
        TempExcelBuff.Comment := COPYSTR(pTexto, 251, 250);
        TempExcelBuff.Formula := COPYSTR(pTexto, 501, 250);
        TempExcelBuff.INSERT;
    END;

    procedure CompletarCerosAIzquierda(texto: Text; Length: Integer) retorno: Text;
    var
        aux: Integer;
        parteEntera: Integer;
        parteDecimal: Decimal;
        cantDecimales: Integer;
        numeroOriginal: Decimal;
        strParteDecimal: Text;
    begin
        //la cantidad de decimales es la que falta especificar.
        cantDecimales := 2;
        Evaluate(numeroOriginal, texto);
        parteEntera := round(numeroOriginal, 1, '<');
        parteDecimal := numeroOriginal - parteEntera;
        if strlen(Format(parteDecimal)) > 1 then
            strParteDecimal := CopyStr(Format(parteDecimal), 3, 100)
        else
            strpartedecimal := '0';


        if strlen(strParteDecimal) < 2 then
            strParteDecimal := strParteDecimal + '0';

        texto := format(parteEntera) + ',' + CopyStr(strParteDecimal, 1, cantDecimales);


        aux := StrLen(copystr(texto, 1, StrLen(texto)));
        retorno := texto;
        while aux < Length do begin
            retorno := '0' + retorno;
            aux += 1;
        end;
    end;

    procedure CompletarEspaciosADerecha(texto: Text; Length: Integer) retorno: Text;
    var
        aux: Integer;
    begin
        texto := CopyStr(texto, 1, Length);
        aux := StrLen(copystr(texto, 1, StrLen(texto)));
        retorno := texto;
        while aux < Length do begin
            retorno += ' ';
            aux += 1;
        end;
    end;

    procedure GetLastNCharacters(texto: Text; N: Integer) retorno: Text;
    begin
        if StrLen(texto) <= N then
            retorno := texto
        else
            retorno := CopyStr(texto, StrLen(texto) - N + 1, N);
    end;

    procedure FormatVoucherNumber(VoucherNo: Text) Result: Text;
    var
        NumericText: Text;
        FirstPart: Text;
        SecondPart: Text;
    begin
        NumericText := DelChr(VoucherNo, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ-+=');

        if StrLen(NumericText) < 13 then
            NumericText := PadStr('', 13 - StrLen(NumericText), '0') + NumericText;

        NumericText := GetLastNCharacters(NumericText, 13);

        FirstPart := CopyStr(NumericText, 1, 5);
        SecondPart := CopyStr(NumericText, 6, 8);

        Result := FirstPart + '-' + SecondPart;
    end;

}
