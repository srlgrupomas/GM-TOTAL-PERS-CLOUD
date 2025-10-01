/// <summary>
///  File Description : MEM Copy of Localization Argentina report: Perception Book (report 34006465 "GMAPerceptions Book") 
/// </summary>
/// <remarks>
/// | Rev No. | Date | By | Ticket | Description |
/// |:-------:|:----:|:--:|:------:|:------------|
/// | 000 | 20241224 | Arvind | NAVMEM-#### | Initial Release |
/// </remarks>
report 34006892 "PersPerceptions Book"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG
    DefaultRenderingLayout = "BssiMEMPerceptionBook.rdlc";
    Caption = 'MEM Perception Book';
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
                column(LIBRO_DE_PERCEPCIONESCaption; LIBRO_DE_PERCEPCIONESCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }
                column(filtros; filtros)
                {

                }
                dataitem(EnVentas; "VAT Entry")  // REALIZADAS
                {
                    DataItemTableView = SORTING(Type, "Bill-to/Pay-to No.", "Transaction No.") ORDER(Ascending) WHERE(Type = CONST(Sale), Amount = FILTER(<> 0));
                    RequestFilterFields = "Tax Jurisdiction Code";
                    //  RequestFilterHeadingML = 'for sales';
                    RequestFilterHeading = 'Realizadas';

                    column(EnVentas_EnVentas__Posting_Date_; EnVentas."Posting Date")
                    {
                    }
                    column(EnVentas_EnVentas__Document_Date_; EnVentas."Document Date")
                    {
                    }
                    column(EnVentas_EnVentas__Document_No__; EnVentas."Document No.")
                    {
                    }
                    column(Jurid_Description; Jurid.Description)
                    {
                    }
                    column(TotalesVentasAmount; abs(enventas.Amount))
                    {
                    }
                    column(taxoftypeventa; taxoftypeventa)
                    {
                    }
                    column(EnVentas__Document_Type_; "Document Type")
                    {
                    }
                    column(Cliente__VAT_Registration_No__; varCUITCliente)
                    {
                    }
                    column(EnVentas_TransactionNo; EnVentas."Transaction No.")
                    {
                    }
                    column(ValorNeto; abs(enventas.Base))
                    {
                    }
                    column(MostrarLinea; MostrarLinea)
                    {
                    }
                    column(EnVentas_EnVentas__Bill_to_Pay_to_No__; EnVentas."Bill-to/Pay-to No.")
                    {
                    }
                    column(mRecCustomer_Name; varNombreCliente)
                    {
                    }
                    column(Subtotal; Subtotal)
                    {
                    }
                    column(Total_Documento_; 'Total Documento')
                    {
                    }
                    column(Mostrar; Mostrar)
                    {
                    }
                    column(EnVentas_EnVentas__Document_No__Caption; EnVentas_EnVentas__Document_No__CaptionLbl)
                    {
                    }
                    column(Percepci_nCaption; Percepci_nCaptionLbl)
                    {
                    }
                    column(ImporteCaption; ImporteCaptionLbl)
                    {
                    }
                    column(FechaCaption; FechaCaptionLbl)
                    {
                    }
                    column(PERCEPCIONES_REALIZADASCaption; PERCEPCIONES_REALIZADASCaptionLbl)
                    {
                    }
                    column(TipoCaption; TipoCaptionLbl)
                    {
                    }
                    column(CUT_ClienteCaption; CUT_ClienteCaptionLbl)
                    {
                    }
                    column(Neto_GrabadoCaption; Neto_GrabadoCaptionLbl)
                    {
                    }
                    column(ClienteCaption; ClienteCaptionLbl)
                    {
                    }
                    column(Nombre_ClienteCaption; Nombre_ClienteCaptionLbl)
                    {
                    }
                    column(EnVentas_Entry_No_; "Entry No.")
                    {
                    }
                    column(EnVentas_Tax_Jurisdiction_Code; "Tax Jurisdiction Code")
                    {
                    }
                    // AW - BEGIN
                    column(AlicuotaEnVentas; AlicuotaEnVentas)
                    { }
                    column(varVATBookCodeVentas; varVATBookCode)
                    { }
                    // AW - END
                    trigger OnPreDataItem();

                    var
                        recTaxJurisdictions: Record "Tax Jurisdiction";
                        varFiltro: Text;
                    begin
                        Empresa.Reset();
                        Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                        Empresa.SetFilter(Code, BssiDimensionValue.Code);
                        IF (Empresa.FindFirst()) THEN;

                        "VAT Entry Temp".DELETEALL;
                        /*
                            IF (EnVentas.GetFilter(GMAValue) = '') then begin
                            Valores.RESET;
                            Valores.SETCURRENTKEY(GMACode);
                            Valores.SetRange("GMAIs Withholding", true);
                            if Provincia <> '' then
                                Valores.SetRange(GMAProvince, Provincia);

                            if Valores.FindFirst() then
                                repeat
                                    txtValores += Valores.GMACode + '|';
                                until Valores.Next() = 0;
                            if StrLen(txtValores) > 0 then
                                txtValores := CopyStr(txtValores, 1, StrLen(txtValores) - 1);
                            EnVentas.SETRANGE(EnVentas."GMAPosting Date", Desde, Hasta);
                            EnVentas.SetFilter(EnVentas."GMAValue", txtValores);
                        end
                        else begin
                            EnVentas.SETRANGE(EnVentas."GMAPosting Date", Desde, Hasta);
                            GlobaltxtValoresVentas := EnVentas.GetFilter(GMAValue);
                        end;
                        */


                        //sdt filtro ventas

                        //NOTA: Si no se especifica ningún valor en el filtro, el reporte traerá los movimientos que sean en GMATax Type Loc del tipo IIBB e IVA Percep.
                        //Si decidimos colocar un filtro en particular que no pertenezca a esos tipos (ej IVA 21%), lo traerá.
                        IF (EnVentas.GetFilter("Tax Jurisdiction Code") = '') then begin
                            EnVentas.Reset();
                            EnVentas.SETRANGE(EnVentas."Posting Date", Desde, Hasta);
                            EnVentas.SetFilter("GMATax Type Loc", '%1|%2', "GMATax Type Loc"::"Ingresos Brutos", "GMATax Type Loc"::"IVA Percepcion");
                            EnVentas.SETRANGE(EnVentas.Type, EnVentas.Type::Sale);

                            if paramProvincia <> '' then begin
                                varFiltro := '';
                                recTaxJurisdictions.Reset();
                                recTaxJurisdictions.SetRange("GMAProvince Code", paramProvincia);
                                if recTaxJurisdictions.FindFirst() then
                                    repeat
                                        varFiltro += recTaxJurisdictions.Code + '|';
                                    until recTaxJurisdictions.Next() = 0;
                                if varFiltro <> '' then
                                    varFiltro := CopyStr(varFiltro, 1, StrLen(varFiltro) - 1);
                            end;
                            EnVentas.SetFilter(EnVentas."Tax Jurisdiction Code", varFiltro);
                        end
                        else begin
                            EnVentas.SETRANGE(EnVentas."Posting Date", Desde, Hasta);
                            GlobaltxtValoresVentas := EnVentas.GetFilter("Tax Jurisdiction Code");
                        end;

                        //Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            SetRange("Bssi Shortcut Dimension 1 Code", BssiDimensionValue.Code)
                        else
                            SetRange("Bssi Shortcut Dimension 2 Code", BssiDimensionValue.Code)
                        //Bssi End
                    end;

                    trigger OnAfterGetRecord();
                    VAR
                        RecTaxDetail: record "Tax Detail";
                        recVBCodeVPostingSetup: Record "VAT Posting Setup";
                        recvBTaxJurisdictions: Record "Tax Jurisdiction";
                    begin
                        //SaveVentas(EnVentas);
                        //SDT20200506-
                        if (GenerarRealizadas = false) then CurrReport.Skip();
                        if EnVentas."Document Type" = EnVentas."Document Type"::Invoice then
                            if ExcludeBooksVentas(true, EnVentas."Document No.") then
                                CurrReport.Skip();
                        if EnVentas."Document Type" = EnVentas."Document Type"::"Credit Memo" then
                            if ExcludeBooksVentas(false, EnVentas."Document No.") then
                                CurrReport.Skip();
                        //SDT20200506+
                        CLEAR(Importe);
                        CLEAR(taxoftypeventa);
                        CLEAR(Cliente);
                        CLEAR(mRecCustomer);

                        // AW - BEGIN CALCULO ALICUOTA 
                        // Alicuota
                        // Clave tabla "Tax Detail" (Tax Jurisdiction Code,Tax Group Code, Tax Type, Effective Date)
                        // con solo estos 3 debería alcanzar
                        RecTaxDetail.SetRange(RecTaxDetail."Tax Jurisdiction Code", EnVentas."Tax Jurisdiction Code");
                        RecTaxDetail.SetRange(RecTaxDetail."Tax Group Code", EnVentas."Tax Group Code");
                        //RecTaxDetail.SetRange(RecTaxDetail."Tax Type", EnVentas."Tax Type");

                        if RecTaxDetail.Find('-') then
                            AlicuotaEnVentas := RecTaxDetail."Tax Below Maximum"
                        else
                            AlicuotaEnVentas := '0';

                        // AW - END


                        if (Cliente.GET(EnVentas."Bill-to/Pay-to No.")) then;

                        Entradas += 1;

                        if Mostrar = true then
                            Subtotal := 0;

                        Mostrar := false;
                        MostrarLinea := false;



                        Jurid.RESET;
                        Jurid.SETRANGE(Code);
                        Jurid.SETRANGE(Jurid.Code, EnVentas."Tax Jurisdiction Code");
                        if (Jurid.FINDFIRST) then
                            taxoftypeventa := FORMAT(Jurid.Code);

                        if (EnVentas."Tax Jurisdiction Code" = '') then begin
                            if ("VAT Product Posting Group".GET(EnVentas."VAT Prod. Posting Group")) then begin
                                Jurid."GMAType of Tax" := "VAT Product Posting Group"."GMATax Type";
                                taxoftype := "VAT Product Posting Group".Code;
                            end;
                        end;

                        if Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA then begin
                            //if not (Mostrar) then CurrReport.SKIP;
                            //CurrReport.Skip();
                        end
                        else begin
                            //--NAVAR1.0601
                            if EnVentas."Document No." <> NDocumento then begin
                                Importe := 0;
                                CLEAR(Importe2);
                                CLEAR(Tax2);
                                if NDocumento <> '' then Mostrar := true;
                                NDocumento := EnVentas."Document No.";
                            end
                            else begin
                                Reportado := false;
                                for i := 1 to 10 do
                                    if Tax2[i] = (taxoftypeventa) then begin
                                        Reportado := true;
                                        i := 10;
                                    end;
                                if not (Reportado) then begin
                                    DocuInterno := NDocumento;
                                    MovIVA.RESET;
                                    MovIVA.SETCURRENTKEY("Entry No.");
                                    MovIVA.SETRANGE("Document No.", NDocumento);
                                    MovIVA.SETRANGE(MovIVA."Posting Date", Desde, Hasta);
                                    if (EnVentas."Tax Jurisdiction Code" <> '') then
                                        MovIVA.SETRANGE(MovIVA."Tax Jurisdiction Code", EnVentas."Tax Jurisdiction Code")
                                    else
                                        if (EnVentas."VAT Prod. Posting Group" <> '') then
                                            MovIVA.SETRANGE("VAT Prod. Posting Group", EnVentas."VAT Prod. Posting Group");

                                    //Bssi Start
                                    if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                        MovIVA.SetRange("Bssi Shortcut Dimension 1 Code", BssiDimensionValue.Code)
                                    else
                                        MovIVA.SetRange("Bssi Shortcut Dimension 2 Code", BssiDimensionValue.Code);
                                    //Bssi End
                                    if MovIVA.FINDFIRST then
                                        repeat
                                            Importe += MovIVA.Amount;
                                        until MovIVA.NEXT = 0;
                                    MostrarLinea := true;
                                    Subtotal += Importe;
                                    for i := 1 to 10 do
                                        if Tax2[i] = '' then begin
                                            Tax2[i] := (taxoftypeventa);
                                            i := 10;
                                        end;
                                end;
                            end;

                            DocuInterno := NDocumento;
                            case EnVentas."GMADocument Type Loc." of
                                EnVentas."GMADocument Type Loc."::Invoice:
                                    begin
                                        if VTSHistFAc.GET(EnVentas."Document No.") then
                                            VTSHistFAc.CALCFIELDS(Amount);
                                        // ValorNeto := CPRHistFac.Amount;  // Comentado AW
                                        ValorNeto := VTSHistFAc.Amount;   // Agregado
                                                                          //SDT20200723-
                                        varCUITCliente := EnVentas."VAT Registration No."; // VTSHistFAc."VAT Registration No.";
                                        varNombreCliente := VTSHistFAc."Bill-to Name";
                                        //SDT20200723+

                                        //7280  -  CAS-14859-M6Z2D4  -  20200826
                                        varCUITCliente := CheckVATRegistrationNo(varCUITCliente, VTSHistFAc."Sell-to Customer No.");
                                        //7280  -  CAS-14859-M6Z2D4  -  20200826 END
                                    end;
                                EnVentas."GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        if VTSHistFAc.GET(EnVentas."Document No.") then
                                            VTSHistFAc.CALCFIELDS(Amount);
                                        //  ValorNeto := CPRHistFac.Amount; // Comentado AW
                                        ValorNeto := VTSHistFAc.Amount;   // Agregado
                                                                          //SDT20200723-
                                        varCUITCliente := EnVentas."VAT Registration No.";
                                        // VTSHistFAc."VAT Registration No.";
                                        varNombreCliente := VTSHistFAc."Bill-to Name";
                                        //SDT20200723+

                                        //7280  -  CAS-14859-M6Z2D4  -  20200826
                                        varCUITCliente := CheckVATRegistrationNo(varCUITCliente, VTSHistFAc."Sell-to Customer No.");
                                        //7280  -  CAS-14859-M6Z2D4  -  20200826 END
                                    end;
                                EnVentas."GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        if VTSHistAbono.GET(EnVentas."Document No.") then
                                            VTSHistAbono.CALCFIELDS(Amount);
                                        //  ValorNeto := CPRHistAbono.Amount * (-1); // Comentado AW
                                        ValorNeto := VTSHistAbono.Amount * (-1);  // Agregado
                                                                                  //SDT20200723-
                                        varCUITCliente := EnVentas."VAT Registration No.";// VTSHistAbono."VAT Registration No.";
                                        varNombreCliente := VTSHistAbono."Bill-to Name";
                                        //SDT20200723+

                                        //7280  -  CAS-14859-M6Z2D4  -  20200826
                                        varCUITCliente := CheckVATRegistrationNo(varCUITCliente, VTSHistAbono."Sell-to Customer No.");
                                        //7280  -  CAS-14859-M6Z2D4  -  20200826 END
                                    end;
                            end;



                        end;



                        //++NAVAR1.0601
                        mRecCustomer.RESET;
                        mRecCustomer.SETCURRENTKEY("No.");
                        mRecCustomer.SETRANGE("No.", EnVentas."Bill-to/Pay-to No.");
                        if mRecCustomer.FINDFIRST then;

                        //VATBookCode-
                        if EnVentas."VAT Calculation Type" = EnVentas."VAT Calculation Type"::"Normal VAT" then begin
                            recVBCodeVPostingSetup.Reset();
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Bus. Posting Group", EnVentas."VAT Bus. Posting Group");
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Prod. Posting Group", EnVentas."VAT Prod. Posting Group");
                            if recVBCodeVPostingSetup.FindFirst() then
                                varVATBookCode := recVBCodeVPostingSetup."GMAVAT Book Code";
                        end;
                        if EnVentas."VAT Calculation Type" = EnVentas."VAT Calculation Type"::"Sales Tax" then begin
                            recvBTaxJurisdictions.Reset();
                            recvBTaxJurisdictions.SetRange(recvBTaxJurisdictions.Code, EnVentas."Tax Jurisdiction Code");
                            if recvBTaxJurisdictions.FindFirst() then
                                varVATBookCode := recvBTaxJurisdictions."GMA VAT Book Code";
                        end;
                        //VATBookCode+
                    end;
                }
                dataitem(EnCompras; "VAT Entry")
                {
                    DataItemTableView = SORTING(Type, "Bill-to/Pay-to No.", "Transaction No.") ORDER(Ascending) WHERE(Type = CONST(Purchase), Amount = FILTER(<> 0));
                    RequestFilterFields = "Tax Jurisdiction Code";
                    RequestFilterHeading = 'Sufridas';
                    column(Importe_Control1000000037; encompras.Amount)
                    {
                    }
                    column(Jurid_Description_Control1000000040; taxoftype)
                    {
                    }
                    column(EnCompras__Document_Type_; "Document Type")
                    {
                    }
                    column(EnCompras_EnCompras__External_Document_No__; EnCompras."External Document No.")
                    {
                    }
                    column(EnCompras_EnCompras__Posting_Date_; EnCompras."Posting Date")
                    {
                    }
                    column(EnCompras_EnCompras__Document_Date_; EnCompras."Document Date")
                    {
                    }
                    column(Proveedor__VAT_Registration_No__; varCUITProveedor) //SDT20200721
                    {
                    }
                    column(ValorNeto_Control1000000058; encompras.Base)
                    {
                    }
                    column(MostrarLinea_Control1100227002; MostrarLinea)
                    {
                    }
                    column(EnCompras_EnCompras__Bill_to_Pay_to_No__; EnCompras."Bill-to/Pay-to No.")
                    {
                    }
                    column(mRecVendor_Name; varNombreProveedor) //SDT20200721
                    {
                    }
                    column(Importe2; Importe2)
                    {
                    }
                    column(Subtotal_Control1000000052; Subtotal)
                    {
                    }
                    column(Total_Documento__Control1000000036; 'Total Documento')
                    {
                    }
                    column(Documento_Interno_____DocuInterno; 'Documento Interno : ' + DocuInterno)
                    {
                    }
                    column(Mostrar_Control1100227003; Mostrar)
                    {
                    }
                    column(FechaCaption_Control1000000031; FechaCaption_Control1000000031Lbl)
                    {
                    }
                    column(Nro_DocCaption; Nro_DocCaptionLbl)
                    {
                    }
                    column(PERCEPCIONES_SUFRIDASCaption; PERCEPCIONES_SUFRIDASCaptionLbl)
                    {
                    }
                    column(ImporteCaption_Control1000000049; ImporteCaption_Control1000000049Lbl)
                    {
                    }
                    column(Percepci_nCaption_Control1000000050; Percepci_nCaption_Control1000000050Lbl)
                    {
                    }
                    column(TipoCaption_Control1000000051; TipoCaption_Control1000000051Lbl)
                    {
                    }
                    column(CUIT_ProveedorCaption; CUIT_ProveedorCaptionLbl)
                    {
                    }
                    column(Neto_GrabadoCaption_Control1000000061; Neto_GrabadoCaption_Control1000000061Lbl)
                    {
                    }
                    column(ProveedorCaption; ProveedorCaptionLbl)
                    {
                    }
                    column(Nombre_Prov_Caption; Nombre_Prov_CaptionLbl)
                    {
                    }
                    column(EnCompras_Entry_No_; "Entry No.")
                    {
                    }
                    column(EnCompras_TransactionNo; EnCompras."Transaction No.")
                    {
                    }
                    // AW - BEGIN
                    column(AlicuotaEnCompras; AlicuotaEnCompras)
                    { }
                    column(varVATBookCodeCompras; varVATBookCode)
                    { }
                    // AW - END
                    trigger OnPreDataItem();
                    var
                        recTaxJurisdictions: Record "Tax Jurisdiction";
                        varFiltro: Text;

                    begin
                        //sdt filtro compras
                        /*
                        EnCompras.RESET;
                        EnCompras.SETCURRENTKEY("Tax Jurisdiction Code", "Tax Group Used", "Tax Type", "Use Tax", "Posting Date");
                        EnCompras.SetFilter("GMATax Type Loc", '%1|%2', "GMATax Type Loc"::"Ingresos Brutos", "GMATax Type Loc"::"IVA Percepcion");
                        EnCompras.SETRANGE(EnCompras."Posting Date", Desde, Hasta);
                        EnCompras.SETRANGE(EnCompras.Type, EnCompras.Type::Purchase);

                        Entradas := 0;
    */
                        //NOTA: Si no se especifica ningún valor en el filtro, el reporte traerá los movimientos que sean en GMATax Type Loc del tipo IIBB e IVA Percep.
                        //Si decidimos colocar un filtro en particular que no pertenezca a esos tipos (ej IVA 21%), lo traerá.
                        IF (EnCompras.GetFilter("Tax Jurisdiction Code") = '') then begin
                            EnCompras.Reset();
                            EnCompras.SETRANGE(EnCompras."Posting Date", Desde, Hasta);
                            EnCompras.SetFilter("GMATax Type Loc", '%1|%2', "GMATax Type Loc"::"Ingresos Brutos", "GMATax Type Loc"::"IVA Percepcion");
                            EnCompras.SETRANGE(EnCompras.Type, EnCompras.Type::Purchase);

                            if paramProvincia <> '' then begin
                                varFiltro := '';
                                recTaxJurisdictions.Reset();
                                recTaxJurisdictions.SetRange("GMAProvince Code", paramProvincia);
                                if recTaxJurisdictions.FindFirst() then
                                    repeat
                                        varFiltro += recTaxJurisdictions.Code + '|';
                                    until recTaxJurisdictions.Next() = 0;
                                if varFiltro <> '' then
                                    varFiltro := CopyStr(varFiltro, 1, StrLen(varFiltro) - 1);
                            end;
                            EnCompras.SetFilter(EnCompras."Tax Jurisdiction Code", varFiltro);
                        end
                        else begin
                            EnCompras.SETRANGE(EnCompras."Posting Date", Desde, Hasta);
                            GlobaltxtValoresCompras := EnCompras.GetFilter("Tax Jurisdiction Code");
                        end;
                        //Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            SetRange("Bssi Shortcut Dimension 1 Code", BssiDimensionValue.Code)
                        else
                            SetRange("Bssi Shortcut Dimension 2 Code", BssiDimensionValue.Code)
                        //Bssi End
                    end;

                    trigger OnAfterGetRecord();
                    var
                        "VAT Product Posting Group": Record "VAT Product Posting Group";
                        RecTaxDetail: record "Tax Detail";
                        recVBCodeVPostingSetup: Record "VAT Posting Setup";
                        recVBTaxJurisdictions: Record "Tax Jurisdiction";
                        varFiltro: Text;
                        recTaxJurisdictions: Record "Tax Jurisdiction";
                        recPIL: Record "Purch. Inv. Line";
                        recPCML: Record "Purch. Cr. Memo Line";
                        contemplar: Boolean;
                    begin
                        if (GenerarSufridas = false) then CurrReport.Skip();
                        //Savecompras(Encompras);
                        //SDT20200506-
                        if EnCompras."Document Type" = EnCompras."Document Type"::Invoice then
                            if ExcludeBooksCompras(true, EnCompras."Document No.") then
                                CurrReport.Skip();
                        if EnCompras."Document Type" = EnCompras."Document Type"::"Credit Memo" then
                            if ExcludeBooksCompras(false, EnCompras."Document No.") then
                                CurrReport.Skip();
                        //SDT20200506+

                        //filtrar por provincia
                        if paramProvincia <> '' then begin
                            varFiltro := '';
                            recTaxJurisdictions.Reset();
                            recTaxJurisdictions.SetRange(recTaxJurisdictions.Code, EnCompras."Tax Jurisdiction Code");
                            if recTaxJurisdictions.FindFirst() then begin
                                if (recTaxJurisdictions."GMAProvince Code" <> paramProvincia) and (EnCompras."VAT Calculation Type" <> EnCompras."VAT Calculation Type"::"Full VAT") then
                                    CurrReport.Skip();
                            end;
                            if EnCompras."VAT Calculation Type" = EnCompras."VAT Calculation Type"::"Full VAT" then begin
                                if EnCompras."Document Type" = EnCompras."Document Type"::Invoice then begin
                                    recPIL.Reset();
                                    recPIL.SetRange(recPIL."Document No.", EnCompras."Document No.");
                                    if recPIL.FindFirst() then
                                        repeat
                                            if recPIL."VAT Calculation Type" = recPIL."VAT Calculation Type"::"Full VAT" then begin
                                                if (EnCompras."VAT Bus. Posting Group" = recPIL."VAT Bus. Posting Group") and (EnCompras."VAT Prod. Posting Group" = recpil."VAT Prod. Posting Group") and (recpil.GMAProvince = paramProvincia) then
                                                    contemplar := true;
                                            end;
                                        until recPIL.Next = 0;
                                    if not contemplar then
                                        CurrReport.Skip();
                                end;
                            end;
                            if EnCompras."VAT Calculation Type" = EnCompras."VAT Calculation Type"::"Full VAT" then begin
                                if EnCompras."Document Type" = EnCompras."Document Type"::"Credit Memo" then begin
                                    recPCML.Reset();
                                    recPCML.SetRange(recPCML."Document No.", EnCompras."Document No.");
                                    if recPCML.FindFirst() then
                                        repeat
                                            if recPCML."VAT Calculation Type" = recPIL."VAT Calculation Type"::"Full VAT" then begin
                                                if (EnCompras."VAT Bus. Posting Group" = recPCML."VAT Bus. Posting Group") and (EnCompras."VAT Prod. Posting Group" = recPCML."VAT Prod. Posting Group") and (recPCML.GMAProvince = paramProvincia) then
                                                    contemplar := true;
                                            end;
                                        until recPCML.Next = 0;
                                    if not contemplar then
                                        CurrReport.Skip();
                                end;

                            end;
                        end;


                        CLEAR(Importe);
                        CLEAR(taxoftype);
                        CLEAR(Proveedor);
                        CLEAR(mRecVendor);


                        RecTaxDetail.SetRange(RecTaxDetail."Tax Jurisdiction Code", EnCompras."Tax Jurisdiction Code");
                        RecTaxDetail.SetRange(RecTaxDetail."Tax Group Code", EnCompras."Tax Group Code");

                        if EnCompras."VAT Calculation Type" <> EnCompras."VAT Calculation Type"::"Full VAT" then
                            if RecTaxDetail.Find('-') then
                                AlicuotaEnCompras := RecTaxDetail."Tax Below Maximum"
                            else
                                AlicuotaEnCompras := '0';

                        if (Proveedor.GET(EnCompras."Bill-to/Pay-to No.")) then;



                        Jurid.RESET;
                        Jurid.SETRANGE(Code);
                        Jurid.SETRANGE(Jurid.Code, EnCompras."Tax Jurisdiction Code");
                        if (Jurid.FINDFIRST) then
                            taxoftype := FORMAT(Jurid.Code);

                        if (EnCompras."Tax Jurisdiction Code" = '') then begin
                            if ("VAT Product Posting Group".GET(EnCompras."VAT Prod. Posting Group")) then begin
                                Jurid."GMAType of Tax" := "VAT Product Posting Group"."GMATax Type";
                                taxoftype := "VAT Product Posting Group".Code;
                            end;
                        end;


                        case EnCompras."GMADocument Type Loc." of
                            EnCompras."GMADocument Type Loc."::Invoice:
                                begin
                                    if CPRHistFac.GET(EnCompras."Document No.") then
                                        CPRHistFac.CALCFIELDS(Amount);
                                    ValorNeto := CPRHistFac.Amount;
                                    //SDT20200721-
                                    varCUITProveedor := EnCompras."VAT Registration No.";//   CPRHistFac."VAT Registration No.";
                                    varNombreProveedor := CPRHistFac."Buy-from Vendor Name";
                                    //SDT20200721+

                                    //7280  -  CAS-14859-M6Z2D4  -  20200826
                                    varCUITProveedor := CheckVendorVATRegistrationNo(varCUITProveedor, EnCompras."Bill-to/Pay-to No.")
                                    //7280  -  CAS-14859-M6Z2D4  -  20200826 END

                                end;
                            EnCompras."GMADocument Type Loc."::"GMANota Debito":
                                begin
                                    if CPRHistFac.GET(EnCompras."Document No.") then
                                        CPRHistFac.CALCFIELDS(Amount);
                                    ValorNeto := CPRHistFac.Amount;
                                    //SDT20200721-
                                    varCUITProveedor := EnCompras."VAT Registration No."; //CPRHistFac."VAT Registration No.";
                                    varNombreProveedor := CPRHistFac."Buy-from Vendor Name";
                                    //SDT20200721+

                                    //7280  -  CAS-14859-M6Z2D4  -  20200826
                                    varCUITProveedor := CheckVendorVATRegistrationNo(varCUITProveedor, EnCompras."Bill-to/Pay-to No.")
                                    //7280  -  CAS-14859-M6Z2D4  -  20200826 END
                                end;
                            EnCompras."GMADocument Type Loc."::"Credit Memo":
                                begin
                                    if CPRHistAbono.GET(EnCompras."Document No.") then
                                        CPRHistAbono.CALCFIELDS(Amount);
                                    ValorNeto := CPRHistAbono.Amount * (-1);
                                    //SDT20200721-
                                    varCUITProveedor := EnCompras."VAT Registration No."; // CPRHistAbono."VAT Registration No.";
                                    varNombreProveedor := CPRHistAbono."Buy-from Vendor Name";
                                    //SDT20200721+

                                    //7280  -  CAS-14859-M6Z2D4  -  20200826
                                    varCUITProveedor := CheckVendorVATRegistrationNo(varCUITProveedor, EnCompras."Bill-to/Pay-to No.")
                                    //7280  -  CAS-14859-M6Z2D4  -  20200826 END
                                end;
                        end;

                        //++NAVAR1.0601
                        mRecVendor.RESET;
                        mRecVendor.SETCURRENTKEY("No.");
                        mRecVendor.SETRANGE("No.", EnCompras."Bill-to/Pay-to No.");
                        if mRecVendor.FINDFIRST then;


                        //VATBookCode-
                        if EnCompras."VAT Calculation Type" = EnCompras."VAT Calculation Type"::"Full VAT" then begin
                            recVBCodeVPostingSetup.Reset();
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Bus. Posting Group", EnCompras."VAT Bus. Posting Group");
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Prod. Posting Group", EnCompras."VAT Prod. Posting Group");
                            if recVBCodeVPostingSetup.FindFirst() then
                                varVATBookCode := recVBCodeVPostingSetup."GMAVAT Book Code";
                        end;
                        if EnCompras."VAT Calculation Type" = EnCompras."VAT Calculation Type"::"Normal VAT" then begin
                            recVBCodeVPostingSetup.Reset();
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Bus. Posting Group", EnCompras."VAT Bus. Posting Group");
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Prod. Posting Group", EnCompras."VAT Prod. Posting Group");
                            if recVBCodeVPostingSetup.FindFirst() then
                                varVATBookCode := recVBCodeVPostingSetup."GMAVAT Book Code";
                        end;
                        if EnCompras."VAT Calculation Type" = EnCompras."VAT Calculation Type"::"Sales Tax" then begin
                            recVBTaxJurisdictions.Reset();
                            recVBTaxJurisdictions.SetRange(recVBTaxJurisdictions."Code", EnCompras."Tax Jurisdiction Code");
                            if recVBTaxJurisdictions.FindFirst() then
                                varVATBookCode := recVBTaxJurisdictions."GMA VAT Book Code";
                        end;
                        //VATBookCode+

                    end;



                }
                dataitem(TotalesVentas; "VAT Entry")
                {
                    DataItemTableView = SORTING(Type, "Bill-to/Pay-to No.", "Transaction No.") ORDER(Ascending) WHERE(Type = CONST(Sale), Amount = FILTER(<> 0));
                    column(TotalesVentas_TotalesVentas__Tax_Jurisdiction_Code_; TaxJurisdictionCodeventa)
                    {
                    }
                    column(TotalesVentas_TotalesVentas_Amount; abs(TotalesVentas.Amount))
                    {
                    }
                    column(Texto; Texto)
                    {
                    }
                    column(Percepci_nCaption_Control1000000013; Percepci_nCaption_Control1000000013Lbl)
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }
                    column(Descripci_nCaption; Descripci_nCaptionLbl)
                    {
                    }
                    column(TOTALES_PERCEPCIONES_REALIZADASCaption; TOTALES_PERCEPCIONES_REALIZADASCaptionLbl)
                    {
                    }
                    column(TotalesVentas_Entry_No_; "Entry No.")
                    {
                    }
                    column(varVATBookCodeTVentas; varVATBookCode)
                    { }

                    trigger OnPreDataItem();
                    var
                        recTaxJurisdictions: Record "Tax Jurisdiction";
                        varFiltro: Text;
                    begin
                        Empresa.Reset();
                        Empresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                        Empresa.SetFilter(Code, BssiDimensionValue.Code);
                        IF (Empresa.FindFirst()) THEN;
                        "VAT Entry Temp".DELETEALL;

                        TotalesVentas.RESET;
                        TotalesVentas.CopyFilters(EnVentas);
                        /*
                        if ((GlobaltxtValoresCompras = '') and (GlobaltxtVAloresVentas = '')) then begin
                            Totales.RESET;
                            Totales.SETCURRENTKEY(Totales.GMAValue);
                            Totales.SETRANGE(Totales."GMAPosting Date", Desde, Hasta);

                            Valores.RESET;
                            Valores.SETCURRENTKEY(GMACode);
                            Valores.SetRange("GMAIs Withholding", true);
                            if Provincia <> '' then
                                Valores.SetRange(GMAProvince, Provincia);

                            if Valores.FindFirst() then
                                repeat
                                    txtValores += Valores.GMACode + '|';
                                until Valores.Next() = 0;
                            if StrLen(txtValores) > 0 then
                                txtValores := CopyStr(txtValores, 1, StrLen(txtValores) - 1);
                            Totales.SetFilter(Totales."GMAValue", txtValores);
                        end
                        else begin
                            Totales.RESET;
                            Totales.SETCURRENTKEY(Totales.GMAValue);
                            Totales.SETRANGE(Totales."GMAPosting Date", Desde, Hasta);
                            if ((GlobaltxtValoresCompras <> '') and (GlobaltxtVAloresVentas <> '')) then
                                Totales.SetFilter(Totales."GMAValue", '%1|%2', GlobaltxtValoresVentas, GlobaltxtValoresCompras);
                            if ((GlobaltxtValoresCompras <> '') and (GlobaltxtVAloresVentas = '')) then
                                Totales.SetFilter(Totales."GMAValue", '%1', GlobaltxtValoresCompras);
                            if ((GlobaltxtValoresCompras = '') and (GlobaltxtVAloresVentas <> '')) then
                                Totales.SetFilter(Totales."GMAValue", '%1', GlobaltxtValoresVentas);
                        end;
                    end;
                        */

                        //sdt filtro ventas
                        /*
                                            if ((GlobaltxtVAloresVentas = '')) then begin
                                                TotalesVentas.RESET;
                                                TotalesVentas.SETCURRENTKEY("Tax Jurisdiction Code", "Tax Group Used", "Tax Type", "Use Tax", "Posting Date");
                                                TotalesVentas.SetFilter("GMATax Type Loc", '%1|%2', "GMATax Type Loc"::"Ingresos Brutos", "GMATax Type Loc"::"IVA Percepcion");
                                                TotalesVentas.SETRANGE(TotalesVentas."Posting Date", Desde, Hasta);
                                                totalesventas.SETRANGE(totalesventas.Type, totalesventas.Type::Sale);

                                                if paramProvincia <> '' then begin
                                                    varFiltro := '';
                                                    recTaxJurisdictions.Reset();
                                                    recTaxJurisdictions.SetRange("GMAProvince Code", paramProvincia);
                                                    if recTaxJurisdictions.FindFirst() then begin
                                                        repeat
                                                            varFiltro += recTaxJurisdictions.Code + '|';
                                                        until recTaxJurisdictions.Next() = 0;
                                                        if varFiltro <> '' then
                                                            varFiltro := CopyStr(varFiltro, 1, StrLen(varFiltro) - 1);
                                                    end;
                                                    TotalesVentas.SetFilter(TotalesVentas."Tax Jurisdiction Code", varFiltro);
                                                end
                                            end
                                            else begin
                                                TotalesVentas.RESET;
                                                TotalesVentas.SETCURRENTKEY(TotalesVentas."Tax Jurisdiction Code");
                                                totalesventas.SETRANGE(totalesventas.Type, totalesventas.Type::Sale);
                                                TotalesVentas.SETRANGE(TotalesVentas."Posting Date", Desde, Hasta);
                                                TotalesVentas.SetFilter(TotalesVentas."Tax Jurisdiction Code", '%1', GlobaltxtValoresVentas);
                                            end;*/

                        // TotalesVentas.Reset();
                        // totalesventas.SETRANGE(totalesventas."Posting Date", Desde, Hasta);
                        // TotalesVentas.SetFilter("GMATax Type Loc", '%1|%2', "GMATax Type Loc"::"Ingresos Brutos", "GMATax Type Loc"::"IVA Percepcion");
                        // totalesventas.SETRANGE(totalesventas.Type, 2);
                    end;

                    trigger OnAfterGetRecord();
                    var
                        recVBCodeVPostingSetup: Record "VAT Posting Setup";
                        recVBTaxJurisdictions: Record "Tax Jurisdiction";

                    begin
                        if (GenerarRealizadas = false) then
                            CurrReport.Skip();
                        //SDT20200506-
                        if TotalesVentas."Document Type" = TotalesVentas."Document Type"::Invoice then
                            if ExcludeBooksVentas(true, TotalesVentas."Document No.") then
                                CurrReport.Skip();
                        if TotalesVentas."Document Type" = TotalesVentas."Document Type"::"Credit Memo" then
                            if ExcludeBooksVentas(false, TotalesVentas."Document No.") then
                                CurrReport.Skip();
                        //SDT20200506+
                        if (TotalesVentas."Tax Jurisdiction Code" <> '') then begin
                            Jurid.RESET;
                            Jurid.SETCURRENTKEY(Code);
                            Jurid.SETRANGE(Jurid.Code, TotalesVentas."Tax Jurisdiction Code");
                            if (Jurid.FINDFIRST) then begin
                                //if (Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA) then
                                //    CurrReport.SKIP;

                                Texto := Jurid.Description;
                                TaxJurisdictionCodeventa := Jurid.Code;
                            end;
                        end
                        else begin
                            if ("VAT Product Posting Group".GET(TotalesVentas."VAT Prod. Posting Group")) then
                                Jurid."GMAType of Tax" := "VAT Product Posting Group"."GMATax Type";
                            //if (Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA) then
                            //    CurrReport.SKIP
                            begin
                                TaxJurisdictionCodeventa := FORMAT("VAT Product Posting Group".Code);
                                Jurid.Code := TaxJurisdictionCode;
                                Texto := "VAT Product Posting Group".Description;
                            end;
                        end;

                        //VATBookCode-
                        if TotalesVentas."VAT Calculation Type" = TotalesVentas."VAT Calculation Type"::"Normal VAT" then begin
                            recVBCodeVPostingSetup.Reset();
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Bus. Posting Group", TotalesVentas."VAT Bus. Posting Group");
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Prod. Posting Group", TotalesVentas."VAT Prod. Posting Group");
                            if recVBCodeVPostingSetup.FindFirst() then
                                varVATBookCode := recVBCodeVPostingSetup."GMAVAT Book Code";
                        end;
                        if TotalesVentas."VAT Calculation Type" = TotalesVentas."VAT Calculation Type"::"Sales Tax" then begin
                            recVBTaxJurisdictions.Reset();
                            recVBTaxJurisdictions.SetRange(recVBTaxJurisdictions."Code", TotalesVentas."Tax Jurisdiction Code");
                            if recVBTaxJurisdictions.FindFirst() then
                                varVATBookCode := recVBTaxJurisdictions."GMA VAT Book Code";
                        end;
                        //VATBookCode+
                    end;


                }
                dataitem(TotalesCompras; "VAT Entry")
                {
                    DataItemTableView = SORTING(Type, "Bill-to/Pay-to No.", "Transaction No.") ORDER(Ascending) WHERE(Type = CONST(Purchase), Amount = FILTER(<> 0));
                    column(TotalesCompras_TotalesCompras_Amount; TotalesCompras.Amount)
                    {
                    }
                    column(TotalesCompras_TotalesCompras__Tax_Jurisdiction_Code_; TaxJurisdictionCode)
                    {
                    }
                    column(Texto_Control1000000039; Texto)
                    {
                    }
                    column(TotalCaption_Control1000000006; TotalCaption_Control1000000006Lbl)
                    {
                    }
                    column(Descripci_nCaption_Control1000000007; Descripci_nCaption_Control1000000007Lbl)
                    {
                    }
                    column(Percepci_nCaption_Control1000000030; Percepci_nCaption_Control1000000030Lbl)
                    {
                    }
                    column(TOTALES_PERCEPCIONES_SUFRIDASCaption; TOTALES_PERCEPCIONES_SUFRIDASCaptionLbl)
                    {
                    }
                    column(TotalesCompras_Entry_No_; "Entry No.")
                    {
                    }
                    column(varVATBookCodeTCompras; varVATBookCode)
                    { }

                    trigger OnPreDataItem()
                    var
                        recTaxJurisdictions: Record "Tax Jurisdiction";
                        varFiltro: Text;

                    begin
                        //sdt filtro compra

                        // TotalesCompras.Reset();
                        // TotalesCompras.SETCURRENTKEY("Tax Jurisdiction Code", "Tax Group Used", "Tax Type", "Use Tax", "Posting Date");
                        // TotalesCompras.SetFilter("GMATax Type Loc", '%1|%2', "GMATax Type Loc"::"Ingresos Brutos", "GMATax Type Loc"::"IVA Percepcion");
                        // TotalesCompras.SETRANGE(TotalesCompras."Posting Date", Desde, Hasta);
                        // TotalesCompras.SETRANGE(TotalesCompras.Type, TotalesCompras.Type::Purchase);
                        TotalesCompras.RESET;
                        TotalesCompras.CopyFilters(EnCompras);
                        /*if ((GlobaltxtVAloresVentas = '')) then begin
                            TotalesCompras.RESET;
                            TotalesCompras.SETCURRENTKEY("Tax Jurisdiction Code", "Tax Group Used", "Tax Type", "Use Tax", "Posting Date");
                            TotalesCompras.SetFilter("GMATax Type Loc", '%1|%2', "GMATax Type Loc"::"Ingresos Brutos", "GMATax Type Loc"::"IVA Percepcion");
                            TotalesCompras.SETRANGE(TotalesCompras."Posting Date", Desde, Hasta);
                            TotalesCompras.SETRANGE(TotalesCompras.Type, TotalesCompras.Type::Purchase);

                            if paramProvincia <> '' then begin
                                varFiltro := '';
                                recTaxJurisdictions.Reset();
                                recTaxJurisdictions.SetRange("GMAProvince Code", paramProvincia);
                                if recTaxJurisdictions.FindFirst() then begin
                                    repeat
                                        varFiltro += recTaxJurisdictions.Code + '|';
                                    until recTaxJurisdictions.Next() = 0;
                                    if varFiltro <> '' then
                                        varFiltro := CopyStr(varFiltro, 1, StrLen(varFiltro) - 1);
                                end;
                                TotalesCompras.SetFilter(TotalesCompras."Tax Jurisdiction Code", varFiltro);
                            end
                        end
                        else begin
                            TotalesCompras.RESET;
                            TotalesCompras.SetFilter(TotalesCompras."Tax Jurisdiction Code", '%1', GlobaltxtValoresCompras);
                            TotalesCompras.SETCURRENTKEY(TotalesCompras."Tax Jurisdiction Code");
                            TotalesCompras.SETRANGE(TotalesCompras.Type, TotalesCompras.Type::Purchase);
                            TotalesCompras.SETRANGE(TotalesCompras."Posting Date", Desde, Hasta);
                        end;*/
                    end;

                    trigger OnAfterGetRecord();
                    var
                        "VAT Product Posting Group": Record "VAT Product Posting Group";
                        recVBCodeVPostingSetup: Record "VAT Posting Setup";
                        recVBCodeTaxJurisdictions: Record "Tax Jurisdiction";
                        varFiltro: Text;
                        recTaxJurisdictions: Record "Tax Jurisdiction";
                        recPIL: Record "Purch. Inv. Line";
                        recPCML: Record "Purch. Cr. Memo Line";
                        contemplar: Boolean;
                    begin
                        //SDT20200506-
                        if (GenerarSufridas = false) then CurrReport.Skip();
                        if TotalesCompras."Document Type" = TotalesCompras."Document Type"::Invoice then
                            if ExcludeBooksCompras(true, TotalesCompras."Document No.") then
                                CurrReport.Skip();
                        if TotalesCompras."Document Type" = TotalesCompras."Document Type"::"Credit Memo" then
                            if ExcludeBooksCompras(false, TotalesCompras."Document No.") then
                                CurrReport.Skip();
                        //SDT20200506+
                        //filtrar por provincia
                        if paramProvincia <> '' then begin
                            varFiltro := '';
                            recTaxJurisdictions.Reset();
                            recTaxJurisdictions.SetRange(recTaxJurisdictions.Code, TotalesCompras."Tax Jurisdiction Code");
                            if recTaxJurisdictions.FindFirst() then begin
                                if (recTaxJurisdictions."GMAProvince Code" <> paramProvincia) and (TotalesCompras."VAT Calculation Type" <> TotalesCompras."VAT Calculation Type"::"Full VAT") then
                                    CurrReport.Skip();
                            end;
                            if TotalesCompras."VAT Calculation Type" = TotalesCompras."VAT Calculation Type"::"Full VAT" then begin
                                if TotalesCompras."Document Type" = TotalesCompras."Document Type"::Invoice then begin
                                    recPIL.Reset();
                                    recPIL.SetRange(recPIL."Document No.", TotalesCompras."Document No.");
                                    if recPIL.FindFirst() then
                                        repeat
                                            if recPIL."VAT Calculation Type" = recPIL."VAT Calculation Type"::"Full VAT" then begin
                                                if (TotalesCompras."VAT Bus. Posting Group" = recPIL."VAT Bus. Posting Group") and (TotalesCompras."VAT Prod. Posting Group" = recpil."VAT Prod. Posting Group") and (recpil.GMAProvince = paramProvincia) then
                                                    contemplar := true;
                                            end;
                                        until recPIL.Next = 0;
                                    if not contemplar then
                                        CurrReport.Skip();
                                end;
                            end;
                            if TotalesCompras."VAT Calculation Type" = TotalesCompras."VAT Calculation Type"::"Full VAT" then begin
                                if TotalesCompras."Document Type" = TotalesCompras."Document Type"::"Credit Memo" then begin
                                    recPCML.Reset();
                                    recPCML.SetRange(recPCML."Document No.", TotalesCompras."Document No.");
                                    if recPCML.FindFirst() then
                                        repeat
                                            if recPCML."VAT Calculation Type" = recPIL."VAT Calculation Type"::"Full VAT" then begin
                                                if (TotalesCompras."VAT Bus. Posting Group" = recPCML."VAT Bus. Posting Group") and (TotalesCompras."VAT Prod. Posting Group" = recPCML."VAT Prod. Posting Group") and (recPCML.GMAProvince = paramProvincia) then
                                                    contemplar := true;
                                            end;
                                        until recPCML.Next = 0;
                                    if not contemplar then
                                        CurrReport.Skip();
                                end;

                            end;
                        end;



                        if (TotalesCompras."Tax Jurisdiction Code" <> '') then begin
                            Jurid.RESET;
                            Jurid.SETCURRENTKEY(Code);
                            Jurid.SETRANGE(Jurid.Code, TotalesCompras."Tax Jurisdiction Code");
                            if (Jurid.FINDFIRST) then begin
                                //if (Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA) then
                                //CurrReport.SKIP;

                                Texto := Jurid.Description;
                                TaxJurisdictionCode := Jurid.Code;
                            end;
                        end
                        else begin
                            if ("VAT Product Posting Group".GET(TotalesCompras."VAT Prod. Posting Group")) then begin
                                Jurid."GMAType of Tax" := "VAT Product Posting Group"."GMATax Type";

                                //if (Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA) then
                                //CurrReport.SKIP
                            end
                            else begin
                                TaxJurisdictionCode := FORMAT("VAT Product Posting Group".Code);
                                Jurid.Code := TaxJurisdictionCode;
                                Texto := "VAT Product Posting Group".Description;
                            end;
                        end;


                        //VATBookCode-
                        if TotalesCompras."VAT Calculation Type" = TotalesCompras."VAT Calculation Type"::"Full VAT" then begin
                            recVBCodeVPostingSetup.Reset();
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Bus. Posting Group", TotalesCompras."VAT Bus. Posting Group");
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Prod. Posting Group", TotalesCompras."VAT Prod. Posting Group");
                            if recVBCodeVPostingSetup.FindFirst() then
                                varVATBookCode := recVBCodeVPostingSetup."GMAVAT Book Code";
                        end;
                        if TotalesCompras."VAT Calculation Type" = TotalesCompras."VAT Calculation Type"::"Normal VAT" then begin
                            recVBCodeVPostingSetup.Reset();
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Bus. Posting Group", TotalesCompras."VAT Bus. Posting Group");
                            recVBCodeVPostingSetup.SetRange(recVBCodeVPostingSetup."VAT Prod. Posting Group", TotalesCompras."VAT Prod. Posting Group");
                            if recVBCodeVPostingSetup.FindFirst() then
                                varVATBookCode := recVBCodeVPostingSetup."GMAVAT Book Code";
                        end;
                        if TotalesCompras."VAT Calculation Type" = TotalesCompras."VAT Calculation Type"::"Sales Tax" then begin
                            recVBCodeTaxJurisdictions.Reset();
                            recVBCodeTaxJurisdictions.SetRange(recVBCodeTaxJurisdictions."Code", TotalesCompras."Tax Jurisdiction Code");
                            if recVBCodeTaxJurisdictions.FindFirst() then
                                varVATBookCode := recVBCodeTaxJurisdictions."GMA VAT Book Code";
                        end;
                        //VATBookCode+

                    end;

                }
                trigger OnPreDataItem()
                begin
                    if paramProvincia <> '' then
                        filtros := 'Filtro provincia: ' + paramprovincia + ' desde: ' + format(Desde) + ' hasta: ' + format(Hasta)
                    else
                        filtros := 'Filtro desde: ' + format(Desde) + ' hasta: ' + format(Hasta)
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
                group(GMAOptions)
                {
                    Caption = 'Options';
                    field(Desde; Desde)
                    {
                        Caption = 'From',
                                    ;
                        ApplicationArea = ALL;
                    }
                    field(Hasta; Hasta)
                    {
                        Caption = 'To',
                                    ;
                        ApplicationArea = ALL;
                    }
                    field(paramProvincia; paramProvincia)
                    {
                        Caption = 'Province Code';
                        ApplicationArea = all;
                        TableRelation = GMAProvince;
                    }
                    field(GenerarSufridas; GenerarSufridas)
                    {
                        Caption = 'Traer Percepciones Sufridas';
                        ApplicationArea = ALL;
                    }
                    field(GenerarRealizadas; GenerarRealizadas)
                    {
                        Caption = 'Traer Percepciones Realizadas';
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
        layout("BssiMEMPerceptionBook.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layout/MEM/BssiMEMPerceptionBook.rdl';
            Caption = 'MEM Perception Book';
        }
        layout("BssiMEMPerceptionBookEntity.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layout/MEM/BssiMEMPerceptionBookEntity.rdl';
            Caption = 'MEM Perception Book - Entity Information';
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
        paramProvincia: Code[200];
        Empresa: Record "Dimension Value";
        Folio: Integer;
        Desde: Date;
        Hasta: Date;
        //Valores : Record "Hist. Tax Area";
        Texto: Text[100];
        Jurid: Record "Tax Jurisdiction";
        Ventas: Record "Sales Invoice Header";
        VentasCredito: Record "Sales Cr.Memo Header";
        Compras: Record "Purch. Inv. Header";
        ComprasCredito: Record "Purch. Cr. Memo Hdr.";
        NDocumento: Code[20];
        Importe: Decimal;
        Mostrar: Boolean;
        MostrarLinea: Boolean;
        Subtotal: Decimal;
        Tax: array[10] of Integer;
        Tax2: array[10] of Text;
        impo: Decimal;
        ok: Boolean;
        MovIVA: Record "VAT Entry";
        Reportado: Boolean;
        i: Integer;
        Proveedor: Record Vendor;
        Cliente: Record Customer;
        Entradas: Integer;
        CPRHistFac: Record "Purch. Inv. Header";
        CPRHistAbono: Record "Purch. Cr. Memo Hdr.";
        VTSHistFAc: Record "Sales Invoice Header";
        VTSHistAbono: Record "Sales Cr.Memo Header";
        ValorNeto: Decimal;
        mRecVendor: Record Vendor;
        mRecCustomer: Record Customer;
        Importe2: Decimal;
        "VAT Entry Temp": Record "GMAVAT Entry Temp";
        "VAT Entry Temp2": Record "GMAVAT Entry Temp";
        "VAT Product Posting Group": Record "VAT Product Posting Group";
        Per_odo_CaptionLbl: Label 'Período:';
        Folio_CaptionLbl: Label 'Folio:';
        ToCaptionLbl: label 'To';
        FromCaptionLbl: label 'From';
        CUIT_CaptionLbl: Label 'CUIT:';
        LIBRO_DE_PERCEPCIONESCaptionLbl: label 'LIBRO DE PERCEPCIONES';
        EnVentas_EnVentas__Document_No__CaptionLbl: Label 'Nro Doc';
        Percepci_nCaptionLbl: Label 'Percepción';
        ImporteCaptionLbl: Label 'Importe';
        FechaCaptionLbl: Label 'Fecha';
        PERCEPCIONES_REALIZADASCaptionLbl: Label 'PERCEPCIONES REALIZADAS';
        TipoCaptionLbl: Label 'Tipo';
        CUT_ClienteCaptionLbl: Label 'CUT Cliente';
        Neto_GrabadoCaptionLbl: Label 'Neto Gravado';
        ClienteCaptionLbl: Label 'Cliente';
        Nombre_ClienteCaptionLbl: Label 'Nombre Cliente';
        FechaCaption_Control1000000031Lbl: Label 'Fecha';
        Nro_DocCaptionLbl: Label 'Nro Doc';
        PERCEPCIONES_SUFRIDASCaptionLbl: Label 'PERCEPCIONES SUFRIDAS';
        ImporteCaption_Control1000000049Lbl: Label 'Importe';
        Percepci_nCaption_Control1000000050Lbl: Label 'Percepción';
        TipoCaption_Control1000000051Lbl: Label 'Tipo';
        CUIT_ProveedorCaptionLbl: Label 'CUIT Proveedor';
        Neto_GrabadoCaption_Control1000000061Lbl: Label 'Neto Gravado';
        ProveedorCaptionLbl: Label 'Proveedor';
        Nombre_Prov_CaptionLbl: Label 'Nombre Prov.';
        Percepci_nCaption_Control1000000013Lbl: Label 'Percepción';
        TotalCaptionLbl: Label 'Total';
        Descripci_nCaptionLbl: Label 'Descripción';
        TOTALES_PERCEPCIONES_REALIZADASCaptionLbl: Label 'TOTALES PERCEPCIONES REALIZADAS';
        TotalCaption_Control1000000006Lbl: Label 'Total';
        Descripci_nCaption_Control1000000007Lbl: Label 'Descripción';
        Percepci_nCaption_Control1000000030Lbl: Label 'Percepción';
        TOTALES_PERCEPCIONES_SUFRIDASCaptionLbl: Label 'TOTALES PERCEPCIONES SUFRIDAS';
        DocuInterno: Code[20];
        TaxJurisdictionCode: Text;
        taxoftype: Text;
        taxoftypeventa: Text;
        TaxJurisdictionCodeventa: Text;
        // AW BEGIN
        AlicuotaEnVentas: decimal;
        AlicuotaEnCompras: decimal;

        // AW END
        varVATBookCode: Text;

        filtros: Text;
        varNombreProveedor: Text; //SDT20200721
        varCUITProveedor: Text; //SDT20200721

        varCUITCliente: Text; //SDT20200723

        varNombreCliente: Text;//30072020
        GlobaltxtValoresCompras: code[20];
        GlobaltxtValoresVentas: code[20];
        GenerarSufridas: boolean;
        GenerarRealizadas: boolean;

        //Bssi Variables
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
        BssiDimension, BssiDimensionForRestriction : Text;
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        BssiMEMReportEvents: Codeunit BssiReportEvents;
        fechaposting: Boolean;

    procedure SaveVentas(ParVat: Record "VAT Entry");
    begin
        Cliente.GET(EnVentas."Bill-to/Pay-to No.");

        "VAT Entry Temp".RESET;
        "VAT Entry Temp".SETRANGE("VAT Entry Temp"."GMADocument No.", ParVat."Document No.");
        "VAT Entry Temp".SETRANGE("VAT Entry Temp"."GMATax Jurisdiction Code", ParVat."Tax Jurisdiction Code");
        if ("VAT Entry Temp".FINDFIRST) then begin
            "VAT Entry Temp".GMAAmount := "VAT Entry Temp".GMAAmount + ParVat.Amount;
            "VAT Entry Temp".MODIFY;
        end
        else begin
            Jurid.RESET;
            Jurid.SETCURRENTKEY(Code);
            Jurid.SETRANGE(Jurid.Code, EnVentas."Tax Jurisdiction Code");
            if (Jurid.FINDFIRST) then begin
                //if Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA then
                //    CurrReport.SKIP;
            end;

            "VAT Entry Temp".TRANSFERFIELDS(ParVat);
            "VAT Entry Temp".INSERT;

            case EnVentas."GMADocument Type Loc." of
                EnVentas."GMADocument Type Loc."::Invoice:
                    begin
                        if VTSHistFAc.GET("VAT Entry Temp"."GMADocument No.") then
                            VTSHistFAc.CALCFIELDS(Amount);
                        ValorNeto := CPRHistFac.Amount;
                    end;
                EnVentas."GMADocument Type Loc."::"GMANota Debito":
                    begin
                        if VTSHistFAc.GET("VAT Entry Temp"."GMADocument No.") then
                            VTSHistFAc.CALCFIELDS(Amount);
                        ValorNeto := CPRHistFac.Amount;
                    end;
                EnVentas."GMADocument Type Loc."::"Credit Memo":
                    begin
                        if VTSHistAbono.GET("VAT Entry Temp"."GMADocument No.") then
                            VTSHistAbono.CALCFIELDS(Amount);
                        ValorNeto := CPRHistAbono.Amount * (-1);
                    end;
            end;

            "VAT Entry Temp".GMABase := ValorNeto;
            "VAT Entry Temp".MODIFY;
        end;

        mRecCustomer.RESET;
        mRecCustomer.SETCURRENTKEY("No.");
        mRecCustomer.SETRANGE("No.", ParVat."Bill-to/Pay-to No.");
        if mRecCustomer.FINDFIRST then;
    end;

    procedure SaveCompras(EnCompras: Record "VAT Entry");
    begin
    end;

    procedure tempventas();
    begin
        ok := Cliente.GET(EnVentas."Bill-to/Pay-to No.");



        //--NAVAR1.0601
        if Mostrar = true then Subtotal := 0;
        Mostrar := false;
        MostrarLinea := false;


        //++NAVAR1.0601

        Jurid.RESET;
        Jurid.SETCURRENTKEY(Code);
        Jurid.SETRANGE(Jurid.Code, EnVentas."Tax Jurisdiction Code");
        ok := Jurid.FINDFIRST;
        if Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA then begin
            //Si la persepcion es IVa no la informo
            //if not (Mostrar) then CurrReport.SKIP;
            //CurrReport.Skip();
        end
        else begin
            //--NAVAR1.0601
            if EnVentas."Document No." <> NDocumento then begin
                Importe := 0;
                CLEAR(Tax);
                if NDocumento <> '' then Mostrar := true;
                NDocumento := EnVentas."Document No.";
            end
            else begin
                Reportado := false;
                for i := 1 to 10 do
                    if Tax[i] = Jurid."GMAType of Tax" then Reportado := true;
                if not (Reportado) then begin
                    DocuInterno := NDocumento;
                    MovIVA.RESET;
                    MovIVA.SETCURRENTKEY("Entry No.");
                    MovIVA.SETRANGE("Document No.", NDocumento);
                    MovIVA.SETRANGE(MovIVA."Tax Jurisdiction Code", EnVentas."Tax Jurisdiction Code");
                    if MovIVA.FINDFIRST then
                        repeat
                            Importe += MovIVA.Amount;
                        until MovIVA.NEXT = 0;
                    MostrarLinea := true;
                    Subtotal += Importe;
                    for i := 1 to 10 do
                        if Tax[i] = 0 then Tax[i] := Jurid."GMAType of Tax";
                end;

            end;


            case EnVentas."GMADocument Type Loc." of
                EnVentas."GMADocument Type Loc."::Invoice:
                    begin
                        if VTSHistFAc.GET(DocuInterno) then
                            VTSHistFAc.CALCFIELDS(Amount);
                        ValorNeto := CPRHistFac.Amount;
                    end;
                EnVentas."GMADocument Type Loc."::"GMANota Debito":
                    begin
                        if VTSHistFAc.GET(DocuInterno) then
                            VTSHistFAc.CALCFIELDS(Amount);
                        ValorNeto := CPRHistFac.Amount;
                    end;
                EnVentas."GMADocument Type Loc."::"Credit Memo":
                    begin
                        if VTSHistAbono.GET(DocuInterno) then
                            VTSHistAbono.CALCFIELDS(Amount);
                        ValorNeto := CPRHistAbono.Amount * (-1);
                    end;
            end;

        end;


    end;

    procedure tempcompras();
    begin
        CLEAR(Importe);
        //CLEAR(ValorNeto);
        ok := Proveedor.GET(EnCompras."Bill-to/Pay-to No.");


        Entradas += 1;

        Jurid.RESET;
        Jurid.SETRANGE(Code);
        Jurid.SETRANGE(Jurid.Code, EnCompras."Tax Jurisdiction Code");
        ok := Jurid.FINDFIRST;
        if (EnCompras."Tax Jurisdiction Code" = '') then begin
            if ("VAT Product Posting Group".GET(EnCompras."VAT Prod. Posting Group")) then
                Jurid."GMAType of Tax" := "VAT Product Posting Group"."GMATax Type";
            ok := true;
        end;
        //if Jurid."GMAType of Tax" = Jurid."GMAType of Tax"::IVA then begin
        //    CurrReport.Skip();
        //end
        begin
            //--NAVAR1.0601
            if EnCompras."Document No." <> NDocumento then begin
                Importe := 0;
                CLEAR(Importe2);
                CLEAR(Tax);
                if NDocumento <> '' then Mostrar := true;
                NDocumento := EnCompras."Document No.";
            end
            else begin
                Reportado := false;
                for i := 1 to 10 do
                    if Tax[i] = (Jurid."GMAType of Tax") then Reportado := true;
                if not (Reportado) then begin
                    DocuInterno := NDocumento;
                    MovIVA.RESET;
                    MovIVA.SETCURRENTKEY("Entry No.");
                    MovIVA.SETRANGE("Document No.", NDocumento);
                    if (EnCompras."Tax Jurisdiction Code" <> '') then
                        MovIVA.SETRANGE(MovIVA."Tax Jurisdiction Code", EnCompras."Tax Jurisdiction Code")
                    else
                        if (EnCompras."VAT Prod. Posting Group" <> '') then
                            MovIVA.SETRANGE("VAT Prod. Posting Group", EnCompras."VAT Prod. Posting Group");
                    if MovIVA.FINDFIRST then
                        repeat
                            Importe += MovIVA.Amount;
                        until MovIVA.NEXT = 0;
                    MostrarLinea := true;
                    Subtotal += Importe;
                    for i := 1 to 10 do
                        if Tax[i] = 0 then
                            Tax[i] := (Jurid."GMAType of Tax")
           ;
                end;
            end;


            case EnCompras."GMADocument Type Loc." of
                EnCompras."GMADocument Type Loc."::Invoice:
                    begin
                        if CPRHistFac.GET(DocuInterno) then
                            CPRHistFac.CALCFIELDS(Amount);
                        ValorNeto := CPRHistFac.Amount;
                    end;
                EnCompras."GMADocument Type Loc."::"GMANota Debito":
                    begin
                        if CPRHistFac.GET(DocuInterno) then
                            CPRHistFac.CALCFIELDS(Amount);
                        ValorNeto := CPRHistFac.Amount;
                    end;
                EnCompras."GMADocument Type Loc."::"Credit Memo":
                    begin
                        if CPRHistAbono.GET(DocuInterno) then
                            CPRHistAbono.CALCFIELDS(Amount);
                        ValorNeto := CPRHistAbono.Amount * (-1);
                    end;
            end;

        end;
        //++NAVAR1.0601
        mRecVendor.RESET;
        mRecVendor.SETCURRENTKEY("No.");
        mRecVendor.SETRANGE("No.", EnCompras."Bill-to/Pay-to No.");
        if mRecVendor.FINDFIRST then;

        Importe2 += Importe;
    end;

    trigger OnPreReport()
    begin
    end;

    local procedure ExcludeBooksVentas(EsFactura: Boolean; DocumentNo: code[200]) retorno: Boolean
    var
        recSIH: Record "Sales Invoice Header";
        recSCM: Record "Sales Cr.Memo Header";
        recInvoiceType: Record "GMAAFIP - Voucher Type";
    begin
        //7280  -  CAS-14859-M6Z2D4  -  20200827
        retorno := false;
        //7280  -  CAS-14859-M6Z2D4  -  20200827 END
        if EsFactura then begin
            recSIH.Reset();
            recSIH.SetRange(recSIH."No.", DocumentNo);
            if recSIH.FindFirst() then begin
                recInvoiceType.Reset();
                recInvoiceType.SetRange(recInvoiceType.GMAID, recSIH."GMAAFIP Voucher Type");
                if recInvoiceType.FindFirst() then begin
                    if recInvoiceType."GMAExclude Books" then
                        retorno := true;
                end;
            end;
        end
        else begin
            recSCM.Reset();
            recSCM.SetRange(recSCM."No.", DocumentNo);
            if recSCM.FindFirst() then begin
                recInvoiceType.Reset();
                recInvoiceType.SetRange(recInvoiceType.GMAID, recSCM."GMAAFIP Voucher Type");
                if recInvoiceType.FindFirst() then begin
                    if recInvoiceType."GMAExclude Books" then
                        retorno := true;
                end;
            end;
        end;
        //7280  -  CAS-14859-M6Z2D4  -  20200827
        exit(retorno);
        //7280  -  CAS-14859-M6Z2D4  -  20200827 EDN
    end;

    local procedure ExcludeBooksCompras(EsFactura: Boolean; DocumentNo: code[200]) retorno: Boolean
    var
        recPIH: Record "Purch. Inv. Header";
        recPCM: Record "Purch. Cr. Memo Hdr.";
        recInvoiceType: Record "GMAAFIP - Voucher Type";
    begin
        //7280  -  CAS-14859-M6Z2D4  -  20200827
        retorno := false;
        //7280  -  CAS-14859-M6Z2D4  -  20200827 END       
        if EsFactura then begin
            recPIH.Reset();
            recPIH.SetRange(recPIH."No.", DocumentNo);
            if recPIH.FindFirst() then begin
                recInvoiceType.Reset();
                recInvoiceType.SetRange(recInvoiceType.GMAID, recPIH."GMAAFIP Invoice Voucher Type");
                if recInvoiceType.FindFirst() then begin
                    if recInvoiceType."GMAExclude Books" then begin
                        retorno := true;
                    end;
                end;
            end;
        end
        else begin
            recPCM.Reset();
            recPCM.SetRange(recPCM."No.", DocumentNo);
            if recPCM.FindFirst() then begin
                recInvoiceType.Reset();
                recInvoiceType.SetRange(recInvoiceType.GMAID, recPCM."GMAAFIP Invoice Voucher Type");
                if recInvoiceType.FindFirst() then begin
                    if recInvoiceType."GMAExclude Books" then begin
                        retorno := true;
                    end;
                end;
            end;
        end;
        //7280  -  CAS-14859-M6Z2D4  -  20200827
        exit(false);
        //7280  -  CAS-14859-M6Z2D4  -  20200827 END

    end;

    //7280  -  CAS-14859-M6Z2D4  -  20200826
    local procedure CheckVATRegistrationNo(_VATRegistrationNo: Text; _SelltoCustomerNo: Code[20]) VATRegistrationNo: text[20];
    var
        Customer: Record Customer;
    begin
        VATRegistrationNo := _VATRegistrationNo;
        if _VATRegistrationNo = '00-00000000-0' then begin
            Customer.Reset();
            Customer.SetRange("No.", _SelltoCustomerNo);
            if Customer.FindFirst() then
                if Customer."VAT Registration No." <> '00-00000000-0' then
                    VATRegistrationNo := Customer."VAT Registration No."
        end;
    end;

    local procedure CheckVendorVATRegistrationNo(_VATRegistrationNo: Text; _BillToVendorNo: Code[20]) VATRegistrationNo: text[20];
    var
        Vendor: Record Vendor;
    begin
        VATRegistrationNo := _VATRegistrationNo;
        if _VATRegistrationNo = '00-00000000-0' then begin
            Vendor.Reset();
            Vendor.SetRange("No.", _BillToVendorNo);
            if Vendor.FindFirst() then
                if Vendor."VAT Registration No." <> '00-00000000-0' then
                    VATRegistrationNo := Vendor."VAT Registration No."
        end;
    end;
    //7280  -  CAS-14859-M6Z2D4  -  20200826 END

}
