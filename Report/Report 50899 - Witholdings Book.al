/// <summary>
///  File Description : MEM Copy of Localization Argentina report: Withholdings Book (report 34006466 "GMLocWithholdings Book") 
/// </summary>
/// <remarks>
/// | Rev No. | Date | By | Description |
/// |:-------:|:----:|:--:|:------------|
/// | 000 | 20241224 | Arvind | Initial Release |
/// </remarks>
report 80899 "PersWithholdings Book"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG

    DefaultRenderingLayout = "BssiMEMWithholdingBook.rdlc";
    Caption = 'MEM Withholding Book';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(BssiDimensionValue; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code);
            PrintOnlyIfDetail = true;
            column(BssiMEMCode; Code)
            {
            }
            column(BssiMEMName; Name)
            {
            }
            column(BssiEntityLegalName; BssiLegalNameFull)
            {
            }
            column(BssiEntityTaxRegistrationNumber; BssiTaxRegistrationNumber)
            {
            }
            column(BssiEntityPicture; BssiPicture)
            {
            }
            column(BssiEntityEmail; BssiEmail)
            {
            }
            column(BssiEntityHomePage; BssiHomePage)
            {
            }
            column(BssiEntityBankAccount; BssiBankAccount)
            {
            }
            column(BssiEntityIntercompanyCustomerNo; BssiIntercompanyCustomerNo)
            {
            }
            column(BssiEntityIntercompanyVendorNo; BssiIntercompanyVendorNo)
            {
            }
            column(BssiEntityIntercompanyLocationNo; BssiIntercompanyLocationNo)
            {
            }
            column(BssiEntityApprovarUser; BssiApprovarUser)
            {
            }
            column(BssiEntityBillingAddr1; BssiBillingAddr1)
            {
            }
            column(BssiEntityBillingAddress2; BssiBillingAddress2)
            {
            }
            column(BssiEntityBillingCity; BssiBillingCity)
            {
            }
            column(BssiEntityBillingState; BssiBillingState)
            {
            }
            column(BssiEntityBillingZipCode; BssiBillingZipCode)
            {
            }
            column(BssiEntityBillingCountry; BssiBillingCountry)
            {
            }
            column(BssiEntityBillingContactName; BssiBillingContactName)
            {
            }
            column(BssiEntityBillingPhoneNumber; BssiBillingPhoneNumber)
            {
            }
            column(BssiEntityShippingAddr1; BssiShippingAddr1)
            {
            }
            column(BssiEntityShippingAddress2; BssiShippingAddress2)
            {
            }
            column(BssiEntityShippingCity; BssiShippingCity)
            {
            }
            column(BssiEntityShippingState; BssiShippingState)
            {
            }
            column(BssiEntityShippingZipCode; BssiShippingZipCode)
            {
            }
            column(BssiEntityShippingCountry; BssiShippingCountry)
            {
            }
            column(BssiEntityShippingContactName; BssiShippingContactName)
            {
            }
            column(BssiEntityShippingPhoneNumber; BssiShippingPhoneNumber)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                column(Hasta; Hasta)
                {
                }
                column(Folio; Folio)
                {
                }
                column(Desde; Desde)
                {
                }
                column(Empresa_City; Empresa.BssiBillingCity)
                {
                }
                column(Empresa__VAT_Registration_No__; Empresa.BssiRegistrationNo)
                {
                }
                // column(Empresa_Name; CompanyProperty.DisplayName())
                // {
                // }
                column(Empresa_Name; '')
                {
                }
                // column(Empresa_Address; Empresa.BssiBillingAddr1 + ', ' + Empresa.BssiBillingZipCode + ', ' + Empresa.BssiBillingCity + ', ' + Empresa.BssiBillingCountry)
                // {
                // }
                column(Empresa_Address; '')
                {
                }
                // column(Empresa_County; Empresa.BssiBillingCountry)
                // {
                // }
                column(Empresa_County; '')
                {
                }
                // column(Empresa__Post_Code_; Empresa.BssiBillingZipCode)
                // {
                // }
                column(Empresa__Post_Code_; '')
                {
                }
                column(Per_odo_Caption; Per_odo_CaptionLbl)
                {
                }
                column(Folio_Caption; Folio_CaptionLbl)
                {
                }
                column(ToCaption; ToCaptionLbl)
                {
                }
                column(FromCaption; FromCaptionLbl)
                {
                }
                column(CUIT_Caption; CUIT_CaptionLbl)
                {
                }
                column(LIBRO_DE_RETENCIONESCaption; LIBRO_DE_RETENCIONESCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }
                column(GMLocPictureSign; "GMLocTreasury Setup".GMLocSignPicture)
                {
                }
                dataitem(EnVentas; "GMLocValues Entry")
                {
                    DataItemTableView = SORTING("GMLocDocument No.") ORDER(Ascending) WHERE("GMLocDocument Type" = FILTER(Recibo | "Ing/Egreso"), GMLocAmount = FILTER(<> 0), GMLocValue = FILTER(<> ''));
                    RequestFilterFields = GMLocValue;
                    RequestFilterHeading = 'Sufridas - Recibos Ing/Egreso';
                    // Solicitan cambio a document date
                    // column(EnVentas__Fecha_registro_; "GMLocPosting Date")
                    // {
                    // }
                    column(EnVentas__Fecha_registro_; "GMLocDocument Date")
                    {
                    }
                    column(EnVentas__Fecha_Documento_; "GMLocDocument Date")
                    {
                    }
                    column(EnVentas__Nro_Doc_; "GMLocDocument No.")
                    {
                    }
                    column(EnVentas_Valor; GMLocValue)
                    {
                    }
                    column(EnVentas__C_d__Serie_; "GMLocSeries Code")
                    {
                    }
                    column(EnVentas_Importe; -1 * GMLocAmount)
                    {
                    }
                    column(EnVentas_EnVentas__Nro_Valor_; EnVentas."GMLocValue No.")
                    {
                    }
                    column(RecCustomer__No__; RecCustomer."No.")
                    {
                    }
                    column(RecCustomer__VAT_Registration_No__; RecCustomer."VAT Registration No.")
                    {
                    }
                    column(RecCustomer_Name; RecCustomer.Name)
                    {
                    }
                    column(EnVentas__Nro_Doc_Caption; FIELDCAPTION("GMLocDocument No."))
                    {
                    }
                    column(EnVentas_ValorCaption; FIELDCAPTION(GMLocValue))
                    {
                    }
                    column(N_meroCaption; N_meroCaptionLbl)
                    {
                    }
                    column(EnVentas_ImporteCaption; FIELDCAPTION(GMLocAmount))
                    {
                    }
                    column(FechaCaption; FechaCaptionLbl)
                    {
                    }
                    column(RETENCIONES_SUFRIDASCaption; RETENCIONES_SUFRIDASCaptionLbl)
                    {
                    }
                    column(N_Cert_Caption; N_Cert_CaptionLbl)
                    {
                    }
                    column(ClienteCaption; ClienteCaptionLbl)
                    {
                    }
                    column(CuitCaption; CuitCaptionLbl)
                    {
                    }
                    column(Nombre_clienteCaption; Nombre_clienteCaptionLbl)
                    {
                    }
                    column(EnVentas_Entry_No_; "GMLocEntry No.")
                    {
                    }
                    column(EnVentas_Transaction_No_; GLRecord."Transaction No.")
                    {
                    }
                    column(EnVentas_GMLocTax_Code_; RecWithholdingLedgerEntry."GMLocTax Code")
                    {
                    }
                    // AW - BEGIN
                    column(TipoRegimen_EnVentas; RecWithholdingLedgerEntry."GMLocTax System")
                    { }
                    column(FechaRetencion_EnVentas; RecWithholdingLedgerEntry.GMLocDocumentDate)
                    { }
                    // column(FechaRetencion_EnVentas; RecWithholdingLedgerEntry."GMLocWithholding Date")
                    // { }
                    column(BaseImponible_EnVentas; FORMAT(-1 * RecWithholdingLedgerEntry.GMLocBase, 0, '<Precision,2:2><Integer Thousand><Decimals>'))
                    { }
                    column(Alicuota_EnVentas; FORMAT(RecWithholdingLedgerEntry."GMLocWithholding%", 0, '<Precision,2:2><Integer Thousand><Decimals>'))
                    { }
                    // AW - END
                    trigger OnPreDataItem();
                    var
                        txtValores: Text;
                    begin

                        IF (EnVentas.GetFilter(GMLocValue) = '') then begin
                            Valores.RESET;
                            Valores.SETCURRENTKEY(GMLocCode);
                            Valores.SetRange("GMLocIs Withholding", true);
                            if Provincia <> '' then
                                Valores.SetRange(GMLocProvince, Provincia);

                            if Valores.FindFirst() then
                                repeat
                                    txtValores += Valores.GMLocCode + '|';
                                until Valores.Next() = 0;
                            if StrLen(txtValores) > 0 then
                                txtValores := CopyStr(txtValores, 1, StrLen(txtValores) - 1);
                            EnVentas.SETRANGE(EnVentas."GMLocDocument Date", Desde, Hasta);
                            EnVentas.SetFilter(EnVentas."GMLocValue", txtValores);
                        end
                        else begin
                            EnVentas.SETRANGE(EnVentas."GMLocDocument Date", Desde, Hasta);
                            GlobaltxtValoresVentas := EnVentas.GetFilter(GMLocValue);
                        end;

                        //Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            EnVentas.SetRange("GMLocGlobal Dimension 1", BssiDimensionValue.Code)
                        else
                            EnVentas.SetRange("GMLocGlobal Dimension 2", BssiDimensionValue.Code);
                        //Bssi End

                        /*if (GlobaltxtVAloresVentas = '') then begin
                                Totales.RESET;
                                Totales.SETCURRENTKEY(Totales.GMLocValue);
                                Totales.SETRANGE(Totales."GMLocPosting Date", Desde, Hasta);

                                Valores.RESET;
                                Valores.SETCURRENTKEY(GMLocCode);
                                Valores.SetRange("GMLocIs Withholding", true);
                                if Provincia <> '' then
                                    Valores.SetRange(GMLocProvince, Provincia);

                                if Valores.FindFirst() then
                                    repeat
                                        txtValores += Valores.GMLocCode + '|';
                                    until Valores.Next() = 0;
                                if StrLen(txtValores) > 0 then
                                    txtValores := CopyStr(txtValores, 1, StrLen(txtValores) - 1);
                                Totales.SetFilter(Totales."GMLocValue", txtValores);
                            end
                            else begin
                                Totales.RESET;
                                Totales.SETCURRENTKEY(Totales.GMLocValue);
                                Totales.SETRANGE(Totales."GMLocPosting Date", Desde, Hasta);
                                Totales.SetFilter(Totales."GMLocValue", '%1', GlobaltxtValoresVentas);
                            end;*/
                    end;

                    trigger OnAfterGetRecord();
                    begin

                        // AW - BEGIN
                        if (GenerarSufridas = false) then CurrReport.Skip();
                        // Para obtener Fecha Retención, Base Imponible, Alícuota ("GMLocWithholding Date", "GMLocBase", "GMLocWithholding%")
                        RecWithholdingLedgerEntry.Reset();
                        RecWithholdingLedgerEntry.SetRange(RecWithholdingLedgerEntry."GMLocVoucher Number", EnVentas."GMLocDocument No.");
                        RecWithholdingLedgerEntry.SetRange(RecWithholdingLedgerEntry."GMLocWithh. Certificate No.", EnVentas."GMLocValue No.");
                        RecWithholdingLedgerEntry.SetRange(RecWithholdingLedgerEntry.GMLocValue, EnVentas.GMLocValue);
                        if (RecWithholdingLedgerEntry.FindFirst()) then;

                        // Para obtener Tipo Régimen ("GMLocTax System")
                        /* RecWithholdingDatail.Reset();
                         RecWithholdingDatail.SetRange(RecWithholdingDatail.GMLocValue, EnVentas.GMLocValue);
                         RecWithholdingDatail.SetRange(RecWithholdingDatail."GMLocWithholding No.", RecWithholdingLedgerEntry."GMLocWithholding No.");
                         if (RecWithholdingDatail.FindFirst()) then;
     */
                        //AW -END

                        // Para obtener No. Asiento Contable
                        GLRecord.Reset();
                        GLRecord.SetRange(GLRecord."GMLocCheck No.", EnVentas."GMLocValue No.");
                        GLRecord.SetRange(GLRecord."GMLocCashBank", EnVentas."GMLocCash/Bank Account");
                        GLRecord.SetRange(GLRecord."GMLocValue", EnVentas."GMLocValue");
                        GLRecord.SetRange(GLRecord."Document No.", EnVentas."GMLocDocument No.");
                        if GLRecord.FINDFIRST then;

                        RecCustomer.RESET;
                        RecCustomer.SETCURRENTKEY("No.");
                        RecCustomer.SETRANGE("No.", "GMLocEntry Source Code");
                        if RecCustomer.FINDFIRST then;
                    end;


                }
                dataitem(EnCompras; "GMLocValues Entry")
                {
                    DataItemTableView = SORTING("GMLocDocument No.") ORDER(Ascending) WHERE("GMLocDocument Type" = CONST("Orden de Pago"));
                    RequestFilterFields = GMLocValue;
                    RequestFilterHeading = 'Realizadas Ordenes de Pago';
                    column(EnCompras_Importe; -1 * GMLocAmount)
                    {
                    }
                    column(EnCompras__C_d__Serie_; "GMLocSeries Code")
                    {
                    }
                    column(EnCompras_Valor; GMLocValue)
                    {
                    }
                    column(EnCompras__Nro_Doc_; "GMLocDocument No.")
                    {
                    }
                    // Solicitan cambio a document date
                    // column(EnCompras__Fecha_registro_; "GMLocPosting Date")
                    // {
                    // }
                    column(EnCompras__Fecha_registro_; "GMLocDocument Date")
                    {
                    }
                    column(EnCompras__Fecha_documento_; "GMLocDocument Date")
                    {
                    }
                    column(EnCompras_EnCompras__Nro_Valor_; EnCompras."GMLocValue No.")
                    {
                    }
                    column(RecVendor__No__; RecVendor."No.")
                    {
                    }
                    column(RecVendor__VAT_Registration_No__; RecVendor."VAT Registration No.")
                    {
                    }
                    column(RecVendor_Name; RecVendor.Name)
                    {
                    }
                    column(FechaCaption_Control1000000031; FechaCaption_Control1000000031Lbl)
                    {
                    }
                    column(Nro_DocCaption; Nro_DocCaptionLbl)
                    {
                    }
                    column(ValorCaption; ValorCaptionLbl)
                    {
                    }
                    column(ImporteCaption; ImporteCaptionLbl)
                    {
                    }
                    column(N_meroCaption_Control1000000043; N_meroCaption_Control1000000043Lbl)
                    {
                    }
                    column(RETENCIONES_REALIZADASCaption; RETENCIONES_REALIZADASCaptionLbl)
                    {
                    }
                    column(N_Cert_Caption_Control1100227004; N_Cert_Caption_Control1100227004Lbl)
                    {
                    }
                    column(ProveedorCaption; ProveedorCaptionLbl)
                    {
                    }
                    column(CuitCaption_Control1100227008; CuitCaption_Control1100227008Lbl)
                    {
                    }
                    column(Nombre_ProveedorCaption; Nombre_ProveedorCaptionLbl)
                    {
                    }
                    column(EnCompras_Entry_No_; "GMLocEntry No.")
                    {
                    }
                    column(EnCompras_Transaction_No_; GLRecord."Transaction No.")
                    {
                    }
                    column(EnCompras_GMLocTax_Code_; RecWithholdingLedgerEntry."GMLocTax Code")
                    {
                    }
                    // AW - BEGIN
                    column(TipoRegimen_EnCompras; RecWithholdingLedgerEntry."GMLocTax System")
                    { }
                    column(FechaRetencion_EnCompras; format(RecWithholdingLedgerEntry.GMLocDocumentDate, 10, '<Day,2>/<Month,2>/<year4>'))
                    { }
                    //                    column(FechaRetencion_EnCompras; format(RecWithholdingLedgerEntry."GMLocWithholding Date", 10, '<Day,2>/<Month,2>/<year4>'))
                    // { }
                    column(BaseImponible_EnCompras; FORMAT(-1 * RecWithholdingLedgerEntry.GMLocBase, 0, '<Precision,2:2><Integer Thousand><Decimals>'))
                    { }
                    column(Alicuota_EnCompras; FORMAT(RecWithholdingLedgerEntry."GMLocWithholding%", 0, '<Precision,2:2><Integer Thousand><Decimals>'))
                    { }
                    // AW - END
                    // FORMAT(RecTaxReportBase.LocARTaxAmount, 0, '<Precision,2:2><Integer Thousand><Decimals>')

                    trigger OnPreDataItem();
                    var
                        txtValores: Text;
                        Valores: Record GMLocValues;
                    begin

                        IF (EnCompras.GetFilter(GMLocValue) = '') then begin
                            Valores.RESET;
                            Valores.SETCURRENTKEY(GMLocCode);
                            Valores.SetRange("GMLocIs Withholding", true);
                            if Provincia <> '' then
                                Valores.SetRange(GMLocProvince, Provincia);

                            if Valores.FindFirst() then
                                repeat
                                    txtValores += Valores.GMLocCode + '|';
                                until Valores.Next() = 0;
                            if StrLen(txtValores) > 0 then
                                txtValores := CopyStr(txtValores, 1, StrLen(txtValores) - 1);

                            EnCompras.SETRANGE(EnCompras."GMLocDocument Date", Desde, Hasta);
                            EnCompras.SetFilter(EnCompras."GMLocValue", txtValores);
                        end
                        else begin
                            EnCompras.SETRANGE(EnCompras."GMLocDocument Date", Desde, Hasta);
                            GlobaltxtValoresCompras := EnCompras.GetFilter(GMLocValue);
                        end;

                        //Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            EnCompras.SetRange("GMLocGlobal Dimension 1", BssiDimensionValue.Code)
                        else
                            EnCompras.SetRange("GMLocGlobal Dimension 2", BssiDimensionValue.Code);
                        //Bssi End

                        /*
                        if (GlobaltxtValoresCompras = '') then begin
                            Compras_Totales.RESET;
                            Compras_Totales.SETCURRENTKEY(Compras_Totales.GMLocValue);
                            Compras_Totales.SETRANGE(Compras_Totales."GMLocPosting Date", Desde, Hasta);

                            Valores.RESET;
                            Valores.SETCURRENTKEY(GMLocCode);
                            Valores.SetRange("GMLocIs Withholding", true);
                            if Provincia <> '' then
                                Valores.SetRange(GMLocProvince, Provincia);

                            if Valores.FindFirst() then
                                repeat
                                    txtValores += Valores.GMLocCode + '|';
                                until Valores.Next() = 0;
                            if StrLen(txtValores) > 0 then
                                txtValores := CopyStr(txtValores, 1, StrLen(txtValores) - 1);
                            Compras_Totales.SetFilter(Compras_Totales."GMLocValue", txtValores);
                        end
                        else begin
                            Compras_Totales.RESET;
                            Compras_Totales.SETCURRENTKEY(Compras_Totales.GMLocValue);
                            Compras_Totales.SETRANGE(Compras_Totales."GMLocPosting Date", Desde, Hasta);
                            Compras_Totales.SetFilter(Compras_Totales."GMLocValue", '%1', GlobaltxtValoresCompras);
                        end;
                    */
                    end;

                    trigger OnAfterGetRecord();
                    begin

                        if (GenerarRealizadas = false) then CurrReport.Skip();
                        // AW - BEGIN

                        // Para obtener Fecha Retención, Base Imponible, Alícuota ("GMLocWithholding Date", "GMLocBase", "GMLocWithholding%")
                        RecWithholdingLedgerEntry.Reset();
                        RecWithholdingLedgerEntry.SetRange(RecWithholdingLedgerEntry."GMLocVoucher Number", EnCompras."GMLocDocument No.");
                        RecWithholdingLedgerEntry.SetRange(RecWithholdingLedgerEntry."GMLocWithh. Certificate No.", Encompras."GMLocValue No.");
                        RecWithholdingLedgerEntry.SetRange(RecWithholdingLedgerEntry.GMLocValue, EnCompras.GMLocValue);

                        // Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            RecWithholdingLedgerEntry.SetRange("GMLocShortcut Dimension 1", BssiDimensionValue.Code)
                        else
                            RecWithholdingLedgerEntry.SetRange("GMLocShortcut Dimension 2", BssiDimensionValue.Code);
                        // Bssi End

                        if (RecWithholdingLedgerEntry.FindFirst()) then;
                        // Para obtener Tipo Régimen ("GMLocTax System")
                        /* RecWithholdingDatail.Reset();
                         RecWithholdingDatail.SetRange(RecWithholdingDatail.GMLocValue, EnCompras.GMLocValue);
                         RecWithholdingDatail.SetRange(RecWithholdingDatail."GMLocWithholding No.", RecWithholdingLedgerEntry."GMLocWithholding No.");
                         if (RecWithholdingDatail.FindFirst()) then;
     */
                        //AW -END

                        // Para obtener No. Asiento Contable
                        GLRecord.Reset();
                        GLRecord.SetRange(GLRecord."GMLocCheck No.", EnCompras."GMLocValue No.");
                        GLRecord.SetRange(GLRecord."GMLocCashBank", EnCompras."GMLocCash/Bank Account");
                        GLRecord.SetRange(GLRecord."GMLocValue", EnCompras."GMLocValue");
                        GLRecord.SetRange(GLRecord."Document No.", EnCompras."GMLocDocument No.");

                        // Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            GLRecord.SetRange("Global Dimension 1 Code", BssiDimensionValue.Code)
                        else
                            GLRecord.SetRange("Global Dimension 2 Code", BssiDimensionValue.Code);
                        // Bssi End

                        if GLRecord.FINDFIRST then;

                        RecVendor.RESET;
                        RecVendor.SETCURRENTKEY("No.");
                        RecVendor.SETRANGE("No.", "GMLocEntry Source Code");
                        if RecVendor.FINDFIRST then;
                    end;


                }

                //Totales Ventas
                dataitem(Totales; "GMLocValues Entry")
                {
                    DataItemTableView = SORTING(GMLocValue) ORDER(Ascending);
                    column(Totales_Valor; GMLocValue)
                    {
                    }
                    column(Totales_Importe; -1 * GMLocAmount)
                    {
                    }
                    column(Texto; Texto)
                    {
                    }
                    column(Totales_ValorCaption; FIELDCAPTION(GMLocValue))
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }
                    column(Descripci_nCaption; Descripci_nCaptionLbl)
                    {
                    }
                    column(TOTALESCaption; TOTALESCaptionLbl)
                    {
                    }
                    column(Totales_Entry_No_; "GMLocEntry No.")
                    {
                    }
                    column(CodImpuesto; CodImpuesto)
                    {

                    }
                    trigger OnPreDataItem();
                    var
                        txtValores: Text;

                    begin
                        Totales.RESET;
                        Totales.CopyFilters(EnVentas);
                    end;

                    trigger OnAfterGetRecord();
                    var
                        BssiMEMTaxesByEntity: Record BssiMEMWithholdingTaxByEntity;
                    begin
                        if (GenerarSufridas = false) then
                            CurrReport.Skip();
                        Valores.RESET;
                        Valores.SETCURRENTKEY(GMLocCode);
                        Valores.SETRANGE(GMLocCode, GMLocValue);
                        if Valores.FINDFIRST then begin
                            BssiMEMTaxesByEntity.Reset();
                            BssiMEMTaxesByEntity.SetRange(BssiTaxCode, valores."GMLocTax Code");
                            BssiMEMTaxesByEntity.SetRange(BssiMEMEntityID, BssiDimensionValue.Code);
                            if BssiMEMTaxesByEntity.FindFirst() then begin
                                Compras_texto := Valores."GMLocTax Code";
                                Compras_CodImpuesto := valores."GMLocTax Code";
                            end
                            else begin
                                texto := 'No agrupado por código impuesto.';
                                CodImpuesto := 'No agrupado';
                            end;
                        end;

                        /*
                            ORIGINAL
                            if ((GlobaltxtValoresCompras = '') and (GlobaltxtVAloresVentas = '')) then begin
                                Totales.RESET;
                                Totales.SETCURRENTKEY(Totales.GMLocValue);
                                Totales.SETRANGE(Totales."GMLocPosting Date", Desde, Hasta);

                                Valores.RESET;
                                Valores.SETCURRENTKEY(GMLocCode);
                                Valores.SetRange("GMLocIs Withholding", true);
                                if Provincia <> '' then
                                    Valores.SetRange(GMLocProvince, Provincia);

                                if Valores.FindFirst() then
                                    repeat
                                        txtValores += Valores.GMLocCode + '|';
                                    until Valores.Next() = 0;
                                if StrLen(txtValores) > 0 then
                                    txtValores := CopyStr(txtValores, 1, StrLen(txtValores) - 1);
                                Totales.SetFilter(Totales."GMLocValue", txtValores);
                            end
                            else begin
                                Totales.RESET;
                                Totales.SETCURRENTKEY(Totales.GMLocValue);
                                Totales.SETRANGE(Totales."GMLocPosting Date", Desde, Hasta);
                                if ((GlobaltxtValoresCompras <> '') and (GlobaltxtVAloresVentas <> '')) then
                                    Totales.SetFilter(Totales."GMLocValue", '%1|%2', GlobaltxtValoresVentas, GlobaltxtValoresCompras);
                                if ((GlobaltxtValoresCompras <> '') and (GlobaltxtVAloresVentas = '')) then
                                    Totales.SetFilter(Totales."GMLocValue", '%1', GlobaltxtValoresCompras);
                                if ((GlobaltxtValoresCompras = '') and (GlobaltxtVAloresVentas <> '')) then
                                    Totales.SetFilter(Totales."GMLocValue", '%1', GlobaltxtValoresVentas);
                            end;
                        end;

                        trigger OnAfterGetRecord();
                        var
                            recTaxes: Record GMLocTaxes;
                        begin


                            Valores.RESET;
                            Valores.SETCURRENTKEY(GMLocCode);
                            Valores.SETRANGE(GMLocCode, GMLocValue);
                            if Valores.FINDFIRST then begin
                                rectaxes.reset;
                                recTaxes.SetRange(recTaxes."GMLocTax Code", valores."GMLocTax Code");
                                if recTaxes.FindFirst() then begin
                                    Texto := Valores."GMLocTax Code";
                                    codimpuesto := valores."GMLocTax Code";

                                end
                                else begin
                                    texto := 'No agrupado por código impuesto.';
                                    CodImpuesto := 'No agrupado';
                                end;
                            end;

                        end;
                        */
                    end;



                }

                dataitem(Compras_Totales; "GMLocValues Entry")
                {
                    DataItemTableView = SORTING(GMLocValue) ORDER(Ascending);
                    column(Compras_Totales_Valor; GMLocValue)
                    {
                    }
                    column(Compras_Totales_Importe; -1 * GMLocAmount)
                    {
                    }
                    column(Compras_Texto; Compras_texto)
                    {
                    }
                    column(Compras_Totales_ValorCaption; FIELDCAPTION(GMLocValue))
                    {
                    }
                    column(Compras_TotalCaption; TotalCaptionLbl)
                    {
                    }
                    column(Compras_Descripci_nCaption; Descripci_nCaptionLbl)
                    {
                    }
                    column(Compras_TOTALESCaption; TOTALESCaptionLbl)
                    {
                    }
                    column(Compras_Totales_Entry_No_; "GMLocEntry No.")
                    {
                    }
                    column(Compras_CodImpuesto; Compras_CodImpuesto)
                    {

                    }
                    trigger OnPreDataItem();
                    var
                        txtValores: Text;

                    begin
                        Compras_Totales.RESET;
                        Compras_Totales.CopyFilters(EnCompras);
                    end;

                    trigger OnAfterGetRecord();
                    var
                        // recTaxes: Record GMLocTaxes;
                        BssiMEMTaxesByEntity: Record BssiMEMWithholdingTaxByEntity;
                    begin
                        if (GenerarRealizadas = false) then CurrReport.Skip();
                        Valores.RESET;
                        Valores.SETCURRENTKEY(GMLocCode);
                        Valores.SETRANGE(GMLocCode, GMLocValue);
                        if Valores.FINDFIRST then begin
                            // rectaxes.reset;
                            // recTaxes.SetRange(recTaxes."GMLocTax Code", valores."GMLocTax Code");
                            BssiMEMTaxesByEntity.Reset();
                            BssiMEMTaxesByEntity.SetRange(BssiTaxCode, valores."GMLocTax Code");
                            BssiMEMTaxesByEntity.SetRange(BssiMEMEntityID, BssiDimensionValue.Code);
                            if BssiMEMTaxesByEntity.FindFirst() then begin
                                Compras_texto := Valores."GMLocTax Code";
                                Compras_CodImpuesto := valores."GMLocTax Code";

                            end
                            else begin
                                Compras_texto := 'No agrupado por código impuesto.';
                                Compras_CodImpuesto := 'No agrupado';
                            end;
                        end;

                    end;


                }
                trigger OnPreDataItem();
                begin
                    // Empresa.RESET;
                    // Empresa.GET('');

                    Empresa.Reset();
                    Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    Empresa.SetFilter(Code, BssiDimensionValue.Code);
                    IF (Empresa.FindFirst()) THEN;

                    "GMLocTreasury Setup".GET();
                    "GMLocTreasury Setup".CALCFIELDS(GMLocSignPicture);
                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                SetFilter(Code, BssiDimensionForRestriction);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(GMLocOptions)
                {
                    Caption = 'Opciones';
                    field(Desde; Desde)
                    {
                        Caption = 'Desde',
                                    ;
                        ApplicationArea = ALL;
                    }
                    field(Hasta; Hasta)
                    {
                        Caption = 'Hasta',
                                    ;
                        ApplicationArea = ALL;
                    }
                    field(Provincia; Provincia)
                    {
                        Caption = 'Province Code';
                        ApplicationArea = ALL;
                        TableRelation = GMLocProvince;
                    }
                    field(GenerarSufridas; GenerarSufridas)
                    {
                        Caption = 'Traer Retenciones Sufridas';
                        ApplicationArea = ALL;
                    }
                    field(GenerarRealizadas; GenerarRealizadas)
                    {
                        Caption = 'Traer Retenciones Realizadas';
                        ApplicationArea = ALL;
                    }
                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = Basic, Suite;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        Importance = Additional;
                        ToolTip = 'Specifies the entity range for which to restrict the suggested vendor payment information.';
                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;

                        trigger OnValidate()
                        var
                            BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        var
            Bssi_Handled: Boolean;
        begin
            BssiMEMReportEvents.Bssi_RegKeyValidationCoreCUEvents(Bssi_Handled);
            if Bssi_Handled then
                Error('');

            if BssiDimension <> '' then
                BssiDimensionForRestriction := BssiDimension
            else
                BssiDimensionForRestriction := BssiMEMSecurityHelper.Bssi_tGetUserSecurityFilterText();
        end;
    }

    rendering
    {
        layout("BssiMEMWithholdingBook.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layout/MEM/BssiMEMWithholdingBook.rdl';
            Caption = 'MEM Withholding Book';
        }
        layout("BssiMEMVATPurchaseBookEntity.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layout/MEM/BssiMEMWithholdingBookEntity.rdl';
            Caption = 'MEM Withholding Book - Entity Information';
        }
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        BssiDimensionValue.SetAutoCalcFields(BssiPicture);
    end;

    var
        Empresa: Record "Dimension Value";
        Folio: Integer;
        Desde: Date;
        Hasta: Date;
        Valores: Record GMLocValues;
        Texto: Text[300];
        RecCustomer: Record Customer;
        RecVendor: Record Vendor;
        GLRecord: Record 17;
        Per_odo_CaptionLbl: Label 'Período:';
        Folio_CaptionLbl: Label 'Folio:';
        ToCaptionLbl: Label 'To';
        FromCaptionLbl: Label 'From';
        CUIT_CaptionLbl: Label 'CUIT:';
        LIBRO_DE_RETENCIONESCaptionLbl: Label 'LIBRO DE RETENCIONES';
        N_meroCaptionLbl: Label 'Número';
        FechaCaptionLbl: Label 'Fecha';
        RETENCIONES_SUFRIDASCaptionLbl: Label 'RETENCIONES SUFRIDAS';
        N_Cert_CaptionLbl: Label 'N Cert.';
        ClienteCaptionLbl: Label 'Cliente';
        CuitCaptionLbl: Label 'Cuit';
        Nombre_clienteCaptionLbl: Label 'Nombre cliente';
        FechaCaption_Control1000000031Lbl: Label 'Fecha';
        Nro_DocCaptionLbl: Label 'Nro Doc';
        ValorCaptionLbl: Label 'Valor';
        ImporteCaptionLbl: Label 'Importe';
        N_meroCaption_Control1000000043Lbl: Label 'Número';
        RETENCIONES_REALIZADASCaptionLbl: Label 'RETENCIONES REALIZADAS';
        N_Cert_Caption_Control1100227004Lbl: Label 'N Cert.';
        ProveedorCaptionLbl: Label 'Proveedor';
        CuitCaption_Control1100227008Lbl: Label 'Cuit';
        Nombre_ProveedorCaptionLbl: Label 'Nombre Proveedor';
        TotalCaptionLbl: Label 'Total';
        Descripci_nCaptionLbl: Label 'Descripción';
        TOTALESCaptionLbl: Label 'TOTALES';
        // AW - BEGIN
        RecWithholdingLedgerEntry: record "GMLocWithholding Ledger Entry";
        //RecWithholdingDatail: record "GMLocWithholding Datail";
        "GMLocTreasury Setup": Record "GMLocTreasury Setup";
        Provincia: Text;
        CodImpuesto: Text;
        GlobaltxtValoresCompras: code[20];
        GlobaltxtValoresVentas: code[20];
        GenerarSufridas: boolean;
        GenerarRealizadas: boolean;
        Compras_CodImpuesto: text;
        Compras_texto: text;
        // AW - END

        //Bssi Variables
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
        Bssi_Handled: Boolean;
        BssiDimension, BssiDimensionForRestriction : Text;
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        BssiMEMReportEvents: Codeunit BssiReportEvents;

}
