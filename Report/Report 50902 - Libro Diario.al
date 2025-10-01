/// <summary>
///  File Description : MEM Copy of Localization Argentina report: G/L Journal Book (report 34006539 "GMALibro Diario") 
/// </summary>
/// <remarks>
/// | Rev No. | Date | By | Ticket | Description |
/// |:-------:|:----:|:--:|:------:|:------------|
/// | 000 | 20241224 | Arvind | NAVMEM-#### | Initial Release |
/// </remarks>
report 34006902 "PersLibro Diario"
{
    // No. yyyy.mm.dd        Developer     Company     DocNo.         Version    Description
    // -----------------------------------------------------------------------------------------------------
    // 01  2018.01.01        DDS           GRUPOMAS                   NAVAR1.06  Localization ARG



    DefaultRenderingLayout = "BssiMEMGLJournalBook.rdlc";
    Caption = 'MEM G/L Journal Book';
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(BssiDimensionValue; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code);
            PrintOnlyIfDetail = true;
            // column(BssiMEMCode; Code)
            // {
            // }
            column(BssiMEMName; Name)
            {
            }
            column(BssiMEMCode; 'Cuit')
            {
            }
            // column(BssiEntityLegalName; BssiLegalNameFull)
            // {
            // }
            column(BssiEntityLegalName; InfoEmpresa.BssiRegistrationNo)
            {
            }
            column(BssiEntityTaxRegistrationNumber; BssiTaxRegistrationNumber)
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
            dataitem("IntegerCompName"; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                column(InfoEmpresa_Address; InfoEmpresa.BssiBillingAddr1)
                { }
                column(InfoEmpresa_Picture; InfoEmpresa.BssiPicture)
                { }
                // column(InfoEmpresa_Name; InfoEmpresa.Name)
                // {
                // }
                column(InfoEmpresa_Name; InfoEmpresa.BssiLegalNameFull)
                {
                }
                column(InfoEmpresa_Picture1; InfoEmpresa1.BssiPicture)
                {

                }
                column(GlobalAper; GlobalAper)
                {
                }
                column(GlobalMov; GlobalMov)
                {
                }
                column(GlobalCier; GlobalCier)
                {
                }

                column(Asiento_Apertura; 'NRO.:' + FORMAT(NroAsiento) + '          Asiento Apertura')
                {
                }
                column(Asiento_Cierre; 'NRO.:' + FORMAT(NroAsiento) + '          Asiento Cierre')
                {
                }
                trigger OnPreDataItem();
                begin
                    InfoEmpresa.Reset();
                    InfoEmpresa.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    InfoEmpresa.SetFilter(Code, BssiDimensionValue.Code);
                    IF (InfoEmpresa.FindFirst()) THEN;
                    InfoEmpresa.CalcFields(BssiPicture);
                    InfoEmpresa1.Reset();
                    InfoEmpresa1.SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                    InfoEmpresa1.SetFilter(Code, BssiDimensionValue.Code);
                    IF (InfoEmpresa1.FindFirst()) THEN;
                    BssiDimensionValue.CalcFields(BssiPicture);
                    InfoEmpresa1.BssiPicture := BssiDimensionValue.BssiPicture;

                    if (ACierre) then
                        globalcier := 'Si'
                    else
                        globalcier := '';
                    if (ADiario) then
                        Globalmov := 'Si'
                    else
                        Globalmov := '';
                    if (AApertura) then
                        globalAper := 'Si'
                    else
                        globalAper := '';
                end;

                trigger OnAfterGetRecord()
                begin

                    if (ACierre) then
                        globalcier := 'Si'
                    else
                        globalcier := '';
                    if (ADiario) then
                        Globalmov := 'Si'
                    else
                        Globalmov := '';
                    if (AApertura) then
                        globalAper := 'Si'
                    else
                        globalAper := '';
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
                // PrintOnlyIfDetail = true;
                column(Per_odo____FORMAT_DESDE________FORMAT_HASTA_; 'Período: ' + FORMAT(DESDE) + ' - ' + FORMAT(HASTA))
                {
                }

                column(Razon_Social_Lbl; Razon_Social_Lbl)
                { }
                column(Sede_Legal_Lbl; Sede_Legal_Lbl)
                { }
                column(PageAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }

                column(DimNom_1_; DimNom[1])
                {
                }
                column(DimNom_2_; DimNom[2])
                {
                }
                column(DimNom_4_; DimNom[4])
                {
                }
                column(DimNom_3_; DimNom[3])
                {
                }
                column(DimNom_6_; DimNom[6])
                {
                }
                column(DimNom_5_; DimNom[5])
                {
                }
                column(DimNom_8_; DimNom[8])
                {
                }
                column(DimNom_7_; DimNom[7])
                {
                }
                column(DimNom_9_; DimNom[9])
                {
                }
                column(CREDITCaption; CREDITCaptionLbl)
                {
                }
                column(BEBITCaption; BEBITCaptionLbl)
                {
                }
                column(DENOMINACION_CUENTACaption; DENOMINACION_CUENTACaptionLbl)
                {
                }
                column(LIBRO_DIARIOCaption; LIBRO_DIARIOCaptionLbl)
                {
                }
                column(CUENTACaption; CUENTACaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }
                dataitem(Apertura; "G/L Account")
                {
                    DataItemTableView = SORTING("No.") ORDER(Ascending);
                    column(NRO____FORMAT_NroAsiento_____________Asiento_Apertura_; 'NRO.:' + FORMAT(NroAsiento) + '          Asiento Apertura')
                    {
                    }
                    column(Apertura_Apertura__No__; Apertura."No.")
                    {
                    }
                    column(mNombreCLiente; mNombreCLiente)
                    {
                    }
                    column(Apertura_Name; Name)
                    {
                    }
                    column(Debe; Debe)
                    {
                    }
                    column(Haber; Haber)
                    {
                    }
                    column(Apertura_Apertura__No___Control1100227004; Apertura."No.")
                    {
                    }
                    column(THaber; THaber)
                    {
                    }
                    column(TDebe; TDebe)
                    {
                    }
                    column(TOTAL_DEL_ASIENTO_APERTURACaption; TOTAL_DEL_ASIENTO_APERTURACaptionLbl)
                    {
                    }
                    trigger OnAfterGetRecord();
                    begin

                        if not (AApertura) then CurrReport.BREAK;

                        CLEAR(Debe);
                        CLEAR(Haber);

                        Apertura.SETFILTER(Apertura."Date Filter", '..%1', Dia);

                        //Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            Apertura.SetRange("Global Dimension 1 Filter", BssiDimensionValue.Code)
                        else
                            Apertura.SetRange("Global Dimension 2 Filter", BssiDimensionValue.Code);
                        //Bssi End

                        if UsarNombreCorporativo then
                            AccountName := Cuentas."GMACorporate Account Name"
                        else
                            AccountName := Cuentas.Name;

                        Apertura.CALCFIELDS(Apertura."Net Change");

                        if (Apertura."Net Change" <> 0) then begin
                            if Apertura."Net Change" > 0 then begin
                                Debe := ABS(Apertura."Net Change");
                                TDebe += Debe;
                            end else begin
                                Haber := ABS(Apertura."Net Change");
                                THaber += Haber;
                            end;
                        end;
                    end;

                    trigger OnPostDataItem();
                    begin
                        if AApertura then NroAsiento += 1;
                        //   NroAsiento := "G/L Register"."No.";
                        Dia := 0D;
                        CLEAR(Debe);
                        CLEAR(Haber);
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not (AApertura) then CurrReport.BREAK;

                        Apertura.RESET;
                        Dia := CALCDATE('-01D', DESDE);

                        Dia := CLOSINGDATE(Dia);
                        SetRange("Account Type", "G/L Account Type"::Posting);
                    end;
                }
                dataitem(Date; Date)
                {
                    DataItemTableView = SORTING("Period Type", "Period Start") ORDER(Ascending);

                    dataitem(Asientos; "G/L Entry")
                    {
                        DataItemTableView = SORTING("Transaction No.") ORDER(Ascending);
                        PrintOnlyIfDetail = true;
                        column(Asientos_Entry_No_; "Entry No.")
                        {
                        }
                        dataitem("G/L Entry"; "G/L Entry")
                        {
                            DataItemTableView = SORTING("Transaction No.") ORDER(Ascending);
                            column(TipoProcedencia; TipoProcedencia)
                            {
                            }
                            column(NRO____FORMAT_NroAsiento_____________Comprobante_Nro_____TipoDoc_____Documento; 'NRO.:' + FORMAT(NroAsiento) + '          Comprobante Nro.: ' + TipoDoc + ' ' + Documento)
                            {
                            }
                            column(Fecha___FORMAT__Posting_Date__0___Day_2___Month_2___Year___; 'Fecha ' + FORMAT("Posting Date", 0, '<Day,2>/<Month,2>/<Year>'))
                            {
                            }
                            column(G_L_Entry__G_L_Entry___Transaction_No__; "G/L Entry"."Transaction No.")
                            {
                            }
                            column(DESDE; DESDE)
                            {
                            }
                            column(HASTA; HASTA)
                            {
                            }
                            column(NroAsiento; NroAsiento)
                            {
                            }
                            column(Apertura__Net_Change_; Apertura."Net Change")
                            {
                            }
                            column(Apertura__Account_Type_; Apertura."Account Type")
                            {
                            }
                            column(Documento; Documento)
                            {
                            }
                            column(Mi_PostingDate; "Posting Date")
                            {
                            }
                            column(FiltroTransaccion; FiltroTransaccion)
                            {
                            }
                            column(mCodigoCliente_________mNombreCLiente; mCodigoCliente + ' ' + mNombreCLiente)
                            {
                            }
                            column(G_L_Entry__Credit_Amount_; "Credit Amount")
                            {
                            }
                            column(G_L_Entry__Debit_Amount_; "Debit Amount")
                            {
                            }
                            column(Cuentas_Name; AccountName)
                            {
                            }
                            column(DimVal_1_; DimVal[1])
                            {
                            }
                            column(DimVal_2_; DimVal[2])
                            {
                            }
                            column(DimVal_4_; DimVal[4])
                            {
                            }
                            column(DimVal_3_; DimVal[3])
                            {
                            }
                            column(DimVal_6_; DimVal[6])
                            {
                            }
                            column(DimVal_5_; DimVal[5])
                            {
                            }
                            column(DimVal_8_; DimVal[8])
                            {
                            }
                            column(DimVal_7_; DimVal[7])
                            {
                            }
                            column(DimVal_9_; DimVal[9])
                            {
                            }
                            column(G_L_Entry__G_L_Account_No__; "G/L Account No.")
                            {
                            }
                            column(G_L_Entry__Credit_Amount__Control1000000022; "Credit Amount")
                            {
                            }
                            column(G_L_Entry__Debit_Amount__Control1000000020; "Debit Amount")
                            {
                            }
                            column(Cuentas_Name_Control1000000018; Cuentas.Name)
                            {
                            }
                            column(G_L_Entry__G_L_Account_No___Control1000000016; "G/L Account No.")
                            {
                            }
                            column(MRecTempGLentry__Debit_Amount_; MRecTempGLentry."Debit Amount")
                            {
                            }
                            column(G_L_Entry__G_L_Entry__Description_Control1100227011; "G/L Entry".Description)
                            {
                            }
                            column(THaber_Control1000000000; THaber)
                            {
                            }
                            column(TDebe_Control1000000006; TDebe)
                            {
                            }
                            column(G_L_Entry__G_L_Entry__Description; "G/L Entry".Description)
                            {
                            }
                            column(REF__Caption; REF__CaptionLbl)
                            {
                            }
                            column(TOTAL_DEL_ASIENTOCaption; TOTAL_DEL_ASIENTOCaptionLbl)
                            {
                            }
                            column(G_L_Entry__G_L_Entry__DescriptionCaption; FIELDCAPTION(Description))
                            {
                            }
                            column(G_L_Entry_Entry_No_; "Entry No.")
                            {
                            }

                            trigger OnAfterGetRecord();
                            var
                                I: Integer;
                                fin: Boolean;
                            begin

                                if not (ADiario) then CurrReport.SKIP;
                                Cuentas.RESET;
                                Cuentas.SETRANGE(Cuentas."No.", "G/L Entry"."G/L Account No.");
                                OK := Cuentas.FINDFIRST;

                                if UsarNombreCorporativo then
                                    AccountName := Cuentas."GMACorporate Account Name"
                                else
                                    AccountName := Cuentas.Name;

                                if Detallada then begin
                                    TDebe += "Debit Amount";
                                    THaber += "Credit Amount";
                                    I := 0;
                                end;
                                if (not (Detallada)) then begin
                                    TDebe += "Debit Amount";
                                    THaber += "Credit Amount";    //Jon
                                end;
                            end;

                            trigger OnPostDataItem();
                            begin

                                if Flag then;
                                //NroAsiento += 1;
                                //    NroAsiento := "G/L Register"."No.";
                            end;

                            trigger OnPreDataItem();
                            begin
                                // CurrReport.CREATETOTALS("G/L Entry"."Debit Amount","G/L Entry"."Credit Amount");

                                if not (Flag) then
                                    CurrReport.BREAK;

                                "G/L Entry".RESET;

                                if not (Detallada) then
                                    "G/L Entry".SETCURRENTKEY("G/L Account No.", "Posting Date")
                                else
                                    "G/L Entry".SETCURRENTKEY("Transaction No.");

                                "G/L Entry".SETFILTER("Transaction No.", FiltroTransaccion);
                                if (ARefundicion) then
                                    "G/L Entry".SETRANGE("Posting Date", DESDE, CLOSINGDATE(HASTA))
                                else
                                    "G/L Entry".SETRANGE("Posting Date", DESDE, HASTA);

                                //Bssi Start
                                if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                    "G/L Entry".SetRange("Global Dimension 1 Code", BssiDimensionValue.Code)
                                else
                                    "G/L Entry".SetRange("Global Dimension 2 Code", BssiDimensionValue.Code);
                                //Bssi End

                                NroAsiento += 1;
                                TDebe := 0;
                                THaber := 0;
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            if not (ADiario) then CurrReport.Skip;
                            ContLine += 1;
                            GLEntryTemp.reset;
                            GLEntryTemp.SetCurrentKey("Transaction No.");
                            GLEntryTemp.SetRange("Transaction No.", Asientos."Transaction No.");
                            if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                GLEntryTemp.SetRange("Global Dimension 1 Code", BssiDimensionValue.Code)
                            else
                                GLEntryTemp.SetRange("Global Dimension 2 Code", BssiDimensionValue.Code);
                            IF (GLEntryTemp.FindFirst()) THEN
                                CurrReport.Skip()
                            else begin
                                GLEntryTemp.Init();
                                GLEntryTemp.TransferFields(Asientos);
                                GLEntryTemp.Insert();
                            end;

                            mCodigoCliente := '';
                            mNombreCLiente := '';
                            Agregame := false;
                            //IF ("Document Type"="Document Type"::Invoice) OR ("Document Type"="Document Type"::"GMANota Debito") THEN BEGIN
                            if Agregame = false then begin
                                rSINVH.RESET;
                                rSINVH.SETCURRENTKEY("No.");
                                rSINVH.SETRANGE("No.", "Document No.");
                                if rSINVH.FINDFIRST then begin
                                    mCodigoCliente := 'Cliente';
                                    mNombreCLiente := rSINVH."Sell-to Customer Name";
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;
                            //IF "Document Type"="Document Type"::"Credit Memo" THEN BEGIN
                            if Agregame = false then begin
                                rSCREDH.RESET;
                                rSCREDH.SETCURRENTKEY("No.");
                                rSCREDH.SETRANGE("No.", "Document No.");
                                if rSCREDH.FINDFIRST then begin
                                    mCodigoCliente := 'Cliente';
                                    mNombreCLiente := rSCREDH."Sell-to Customer Name";
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;

                            //IF ("Document Type"="Document Type"::Invoice) OR ("Document Type"="Document Type"::"GMANota Debito") THEN BEGIN
                            if Agregame = false then begin
                                rSIH.RESET;
                                rSIH.SETCURRENTKEY("No.");
                                rSIH.SETRANGE("No.", "Document No.");
                                if rSIH.FINDFIRST then begin
                                    mCodigoCliente := 'Proveedor';
                                    mNombreCLiente := rSIH."Buy-from Vendor Name";
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;
                            //IF "Document Type"="Document Type"::"Credit Memo" THEN BEGIN
                            if Agregame = false then begin
                                rCRM.RESET;
                                rCRM.SETCURRENTKEY("No.");
                                rCRM.SETRANGE("No.", "Document No.");
                                if rCRM.FINDFIRST then begin
                                    mCodigoCliente := 'Proveedor';
                                    mNombreCLiente := rCRM."Buy-from Vendor Name";
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;
                            //IF "Document Type"="Document Type"::"Orden Pago" THEN BEGIN
                            if Agregame = false then begin
                                rOPH.RESET;
                                rOPH.SETCURRENTKEY("GMAPayment O. No.");
                                rOPH.SETRANGE("GMAPayment O. No.", "Document No.");
                                if rOPH.FINDFIRST then begin
                                    mCodigoCliente := 'Proveedor';
                                    mNombreCLiente := rOPH.GMAName;
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;
                            //IF "Document Type"="Document Type"::Recibo THEN BEGIN
                            if Agregame = false then begin
                                rRH.RESET;
                                rRH.SETCURRENTKEY("GMANro Recibo");
                                rRH.SETRANGE("GMANro Recibo", "Document No.");
                                if rRH.FINDFIRST then begin
                                    mCodigoCliente := 'Cliente';
                                    mNombreCLiente := rRH.GMAName;
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;
                            //IF "Document Type"="Document Type"::Transferencia THEN BEGIN
                            if Agregame = false then begin
                                rCTH.RESET;
                                rCTH.SETCURRENTKEY("GMANo.");
                                rCTH.SETRANGE("GMANo.", "Document No.");
                                if rCTH.FINDFIRST then begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;
                            //IF "Document Type"="Document Type"::"Ingreso/Egreso" THEN BEGIN
                            if Agregame = false then begin
                                rCIE.RESET;
                                rCIE.SETCURRENTKEY("GMANo.");
                                rCIE.SETRANGE("GMANo.", "Document No.");
                                if rCIE.FINDFIRST then begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                    Agregame := true;
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;
                            //IF "Document Type"="Document Type"::Payment THEN BEGINmCodigoCliente50
                            if Agregame = false then begin
                                rVLG.RESET;
                                rVLG.SETCURRENTKEY("Entry No.");
                                rVLG.SETRANGE("Document No.", "Document No.");
                                if rVLG.FINDFIRST then begin
                                    mCodigoCliente := rVLG."Vendor No.";
                                    rVEN.RESET;
                                    rVEN.SETRANGE("No.", rVLG."Vendor No.");
                                    Agregame := true;
                                    if rVEN.FINDFIRST then begin
                                        mNombreCLiente := rVEN.Name;
                                        Agregame := true;
                                    end else begin
                                        mNombreCLiente := '';
                                        mCodigoCliente := '';
                                    end
                                end else begin
                                    mCodigoCliente := '';
                                    mNombreCLiente := '';
                                end;
                            end;


                            Flag := false;


                            NDocumento := Asientos."Document No.";
                            FechaAsiento := Asientos."Posting Date";


                            TransaccionActual := Asientos."Transaction No.";
                            FiltroTransaccion := FORMAT(TransaccionActual);


                            repeat
                                repeat
                                    Paso := Asientos.NEXT;
                                    if (TransaccionActual <> Asientos."Transaction No.") and (NDocumento = Asientos."Document No.") then begin
                                        TransaccionActual := Asientos."Transaction No.";
                                        if not (ActualizarFiltroTransaccion(FiltroTransaccion, FORMAT(Asientos."Transaction No."))) then
                                            ERROR(Text53803);
                                    end;
                                until (Paso = 0) or (NDocumento <> Asientos."Document No.") or (FechaAsiento <> Asientos."Posting Date");

                                if (Paso = 0) then begin
                                    Flag := true;
                                    MovCont.RESET;
                                    MovCont.SETCURRENTKEY("Transaction No.");
                                    MovCont.SETFILTER("Transaction No.", FiltroTransaccion);
                                    if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                        MovCont.SetFilter("Global Dimension 1 Code", BssiDimensionValue.Code)
                                    else
                                        MovCont.SetFilter("Global Dimension 2 Code", BssiDimensionValue.Code);
                                    if MovCont.FINDFIRST then begin
                                        MovCont.CALCSUMS("Debit Amount", "Credit Amount");
                                        if ABS(MovCont."Debit Amount" - MovCont."Credit Amount") >= diferAdmitida then begin
                                        end;
                                    end;
                                end else begin
                                    // Filtro y sumarizo para ver si cuadra (y ver si es realemente un Asiento)
                                    MovCont.RESET;
                                    MovCont.SETCURRENTKEY("Transaction No.");
                                    MovCont.SETFILTER("Transaction No.", FiltroTransaccion);
                                    if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                        MovCont.SetFilter("Global Dimension 1 Code", BssiDimensionValue.Code)
                                    else
                                        MovCont.SetFilter("Global Dimension 2 Code", BssiDimensionValue.Code);
                                    if MovCont.FINDFIRST then begin
                                        MovCont.CALCSUMS("Debit Amount", "Credit Amount");
                                        if ABS(MovCont."Debit Amount" - MovCont."Credit Amount") < diferAdmitida then begin
                                            Flag := true;
                                            Asientos.NEXT(-1);
                                        end else begin /// Si no cuadra singo agrupando
                                            NDocumento := Asientos."Document No.";
                                            TransaccionActual := Asientos."Transaction No.";
                                            if not (ActualizarFiltroTransaccion(FiltroTransaccion, FORMAT(Asientos."Transaction No."))) then
                                                ERROR(Text53803);
                                        end;
                                    end; //de MovCont.FindSet()
                                end;

                            until Flag;


                            CLEAR(TipoDoc);
                            CLEAR(Documento);
                            CLEAR(CodProcedencia);
                            CLEAR(TipoProcedencia);


                            if Flag then begin

                                if MovCont.FINDFIRST then begin
                                    //--Si es Proveedor o Activo Fijo, Traigo el numero de Documento Externo
                                    if (MovCont."Source Type" = MovCont."Source Type"::Vendor) or
                                       (MovCont."Source Type" = MovCont."Source Type"::"Fixed Asset") then begin
                                        Documento := MovCont."External Document No.";
                                        TipoDoc := FORMAT(MovCont."Document Type");
                                    end
                                    else
                                        Documento := MovCont."Document No.";

                                    //Si es un Pago o vacio
                                    if (MovCont."Document Type" = MovCont."Document Type"::Payment) or (MovCont."Document Type" = MovCont."Document Type"::" ") then
                                        Documento := MovCont."Document No.";

                                    case MovCont."Source Type" of
                                        MovCont."Source Type"::" ":
                                            TipoProcedencia := '';
                                        MovCont."Source Type"::Customer:
                                            if RecClientes.GET(MovCont."Source No.") then
                                                TipoProcedencia := 'Cliente: ' + RecClientes.Name;
                                        MovCont."Source Type"::Vendor:
                                            if RecProveedores.GET(MovCont."Source No.") then
                                                TipoProcedencia := 'Proveedor: ' + RecProveedores.Name;
                                        MovCont."Source Type"::"Bank Account":
                                            TipoProcedencia := 'Banco';
                                        MovCont."Source Type"::"Fixed Asset":
                                            TipoProcedencia := 'Activo';
                                    end;

                                    DocumentNumber := MovCont."Document No.";

                                    if MovCont.FINDFIRST then
                                        repeat
                                            if DocumentNumber <> MovCont."Document No." then begin
                                                Documento := 'Referencia:' + FORMAT(MovCont."Transaction No.");
                                                TipoDoc := '';
                                            end;
                                        until MovCont.NEXT = 0;

                                end;
                            end;

                        end;

                        trigger OnPreDataItem();
                        begin
                            MovDesde := 1;
                            MovHasta := 1;
                            TransaccionActual := 1;
                            FiltroTransaccion := '';

                            // original  Asientos.SETRANGE("Posting Date", CLOSINGDATE(Date."Period Start"));

                            IF ARefundicion THEN
                                Asientos.SETFILTER("Posting Date", '%1|%2', Date."Period Start", CLOSINGDATE(Date."Period Start"))
                            ELSE
                                Asientos.SETRANGE("Posting Date", Date."Period Start");

                            //Bssi Start
                            if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                                Asientos.SetRange("Global Dimension 1 Code", BssiDimensionValue.Code)
                            else
                                Asientos.SetRange("Global Dimension 2 Code", BssiDimensionValue.Code);
                            //Bssi End

                            if Asientos.IsEmpty() then
                                CurrReport.Break();
                        end;
                    }
                    trigger OnPreDataItem();
                    begin
                        if not (ADiario) then CurrReport.Break();
                        NroAsiento := NroAsiento - 1;
                        if Dia = 0D then begin
                            Dia := DESDE;
                        end
                        else
                            if Dia < HASTA then begin
                                Dia := CALCDATE('01D', Dia);
                            end
                            else
                                CurrReport.BREAK;


                        Date.SETRANGE("Period Type", "Period Type"::Date);
                        Date.SETRANGE("Period Start", DESDE, HASTA);
                    end;
                }

                dataitem(Cierre; "G/L Account")
                {
                    DataItemTableView = SORTING("No.") ORDER(Ascending);
                    column(NRO____FORMAT_NroAsiento_______________Asiento_cierre_; 'NRO.:' + FORMAT(AsientoCierre) + '            Asiento cierre')
                    {
                    }
                    column(ACierreText; ACierreText)
                    {
                    }
                    column(ACierre; ACierre)
                    {
                    }
                    column(Haber_Control1000000005; Haber)
                    {
                    }
                    column(Debe_Control1000000007; Debe)
                    {
                    }
                    column(Cierre_Name; Name)
                    {
                    }
                    column(Cierre_Cierre__No__; Cierre."No.")
                    {
                    }
                    column(THaber_Control1000000038; THaber)
                    {
                    }
                    column(TDebe_Control1000000039; TDebe)
                    {
                    }
                    column(TOTAL_DEL_ASIENTO_CIERRECaption; TOTAL_DEL_ASIENTO_CIERRECaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        if not (ACierre) then CurrReport.BREAK;
                        if (ACierre) then
                            ACierreText := 'ACierre21'
                        else
                            ACierreText := '';
                        CLEAR(Debe);
                        CLEAR(Haber);

                        HASTA := CLOSINGDATE(HASTA);

                        Cierre.SETFILTER(Cierre."Date Filter", '..%1', CLOSINGDATE(HASTA));

                        //Bssi Start
                        if BssiMEMSystemSetup.BssiUseGlobalDimOne() then
                            Cierre.SetRange("Global Dimension 1 Filter", BssiDimensionValue.Code)
                        else
                            Cierre.SetRange("Global Dimension 2 Filter", BssiDimensionValue.Code);
                        //Bssi End

                        if UsarNombreCorporativo then
                            AccountName := Cuentas."GMACorporate Account Name"
                        else
                            AccountName := Cuentas.Name;

                        Cierre.CALCFIELDS(Cierre."Net Change");

                        if ((Cierre."Net Change" <> 0) and (Cierre."Account Type" = Cierre."Account Type"::Posting)) then begin
                            if Cierre."Net Change" < 0 then begin
                                Debe := ABS(Cierre."Net Change");
                                TDebe += Debe;
                            end else begin
                                Haber := ABS(Cierre."Net Change");
                                THaber += Haber;
                            end;
                        end;
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not (ACierre) then CurrReport.BREAK;
                        AsientoCierre := NroAsiento + 1;
                        Cierre.RESET;
                        //CurrReport.CREATETOTALS(Debe, Haber);
                        if (ACierre) then
                            ACierreText := 'ACierre1'
                        else
                            ACierreText := '';
                        InfoEmpresa.GET();
                        TDebe := 0;
                        THaber := 0;
                    end;
                }

                trigger OnAfterGetRecord();
                begin

                    if not (ADiario) and not (AApertura) and not (ACierre) then
                        CurrReport.SKIP;
                    if (ACierre) then
                        globalcier := 'Si'
                    else
                        globalcier := '';
                    if (ADiario) then
                        Globalmov := 'Si'
                    else
                        Globalmov := '';
                    if (AApertura) then
                        globalAper := 'Si'
                    else
                        globalAper := '';
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(THaber);
                Clear(TDebe);
            end;

            trigger OnPreDataItem()
            begin
                if not (ADiario) and not (AApertura) and not (ACierre) then
                    CurrReport.SKIP;
                SetFilter("Dimension Code", BssiMEMSystemSetup.Bssi_cGetEntityCode());
                SetFilter("Code", BssiDimensionForRestriction);
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(GMAPeriod)
                {
                    Caption = 'Period',
                                ;
                    field(DESDE; DESDE)
                    {
                        Caption = 'From',
                                    ;
                        ApplicationArea = ALL;
                    }
                    field(HASTA; HASTA)
                    {
                        Caption = 'To',
                                    ;
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
                group(GMAOptions)
                {
                    Caption = 'Opciones';
                    field(NroAsiento; NroAsiento)
                    {
                        Caption = 'Ingrese número asiento de inicio';
                        ApplicationArea = ALL;
                    }
                    field(AApertura; AApertura)
                    {
                        Caption = 'Asiento de apertura';
                        ApplicationArea = ALL;
                    }
                    field(ADiario; ADiario)
                    {
                        Caption = 'Asientos diario';
                        ApplicationArea = ALL;
                    }
                    field(ACierre; ACierre)
                    {
                        Caption = 'Asiento de cierre';
                        ApplicationArea = ALL;
                    }
                    field(ARefundicion; ARefundicion)
                    {
                        Caption = 'Asiento de Refundicion';
                        ApplicationArea = ALL;
                    }
                    field(Detallada; Detallada)
                    {
                        Caption = 'Detallada';
                        ApplicationArea = ALL;
                    }
                    field(UsarNombreCorporativo; UsarNombreCorporativo)
                    {
                        Caption = 'Use Corporate Account Name';
                        ApplicationArea = ALL;
                        ToolTip = 'Seleccione esta opción para utilizar el nombre corporativo en lugar del nombre estándar.';
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
        layout("BssiMEMGLJournalBook.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layout/MEM/BssiMEMGLJournalBook.rdl';
            Caption = 'MEM G/L Journal Book';
        }
        layout("BssiMEMGLJournalBook_Entity.rdlc")
        {
            Type = RDLC;
            LayoutFile = './Layout/MEM/BssiMEMGLJournalBookEntity.rdl';
            Caption = 'MEM G/L Journal Book - Entity Information';
        }
    }
    labels
    {
    }

    trigger OnInitReport();
    begin

        NroAsiento := 1;
        // NroAsiento := "G/L Register"."No.";
        ADiario := true;
        DESDE := TODAY;
        HASTA := TODAY;
        BssiDimensionValue.SetAutoCalcFields(BssiPicture);
    end;

    trigger OnPreReport();
    var
        carac: Text[1];
        pos: Integer;
        Dims: Record Dimension;
        I: Integer;
    begin



        configCont.GET;
        RedondeoCont := FORMAT(configCont."Amount Rounding Precision");

        RedondeoVisual := configCont."Amount Decimal Places";
        pos := STRLEN(configCont."Amount Decimal Places");

        if pos <> 0 then begin
            repeat
                pos -= 1;
                carac := COPYSTR(RedondeoVisual, pos + 1, 1);
            until (pos = 0) or (carac = ':');

            if pos <> 0 then
                RedondeoVisual := COPYSTR(RedondeoVisual, pos + 2);

            EVALUATE(pos, RedondeoVisual);
            RedondeoVisual := FORMAT(POWER(10, -pos));
        end;

        EVALUATE(diferAdmitida, RedondeoVisual);


        Dims.RESET;
        Dims.SETCURRENTKEY(Code);
        I := 0;
        if Dims.FINDFIRST then
            repeat
                I += 1;
                DimNom[I] := Dims.Code;
            until (Dims.NEXT = 0) or (I = 15);
        CLEAR(Dims);
    end;

    var
        configCont: Record "General Ledger Setup";
        DESDE: Date;
        Text53801: Label 'Exportando a Excel\@1@@@@@@@@@@@@';
        Text53802: Label 'Los valores del Filtro nos son de tipo numérico';
        Text53803: Label 'Se produjo un error al generar el Filtro de Transaccion';
        Text53804: Label 'Finalizó el día %1 y la/s transaccion/es %2 no cuadran %3';
        CREDITCaptionLbl: Label 'HABER';
        BEBITCaptionLbl: Label 'DEBE';
        DENOMINACION_CUENTACaptionLbl: Label 'DENOMINACION CUENTA';
        LIBRO_DIARIOCaptionLbl: Label 'LIBRO DIARIO';
        CUENTACaptionLbl: Label 'CUENTA';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        TOTAL_DEL_ASIENTO_APERTURACaptionLbl: Label 'TOTAL DEL ASIENTO APERTURA';
        REF__CaptionLbl: Label 'REF.:';
        TOTAL_DEL_ASIENTOCaptionLbl: Label 'TOTAL DEL ASIENTO';
        TOTAL_DEL_ASIENTO_CIERRECaptionLbl: Label 'TOTAL DEL ASIENTO CIERRE';

        // AW
        Razon_Social_Lbl: Label 'Razón Social: ';
        Sede_Legal_Lbl: Label 'Sede Legal: ';
        //AW END
        HASTA: Date;
        Debe: Decimal;
        Haber: Decimal;
        Saldo: Decimal;
        MovCont: Record "G/L Entry";
        Cuentas: Record "G/L Account";
        NroAsiento: Integer;
        Dia: Date;
        I: Integer;
        OK: Boolean;
        InfoEmpresa: Record "Dimension Value";
        InfoEmpresa1: Record "Dimension Value";
        Documento: Code[100];
        TipoProcedencia: Text[250];
        CodProcedencia: Code[20];
        AApertura: Boolean;
        ACierre: Boolean;
        ARefundicion: Boolean;
        ADiario: Boolean;
        TDebe: Decimal;
        THaber: Decimal;
        "G/L Register": Record "G/L Register";
        Flag: Boolean;
        Detallada: Boolean;
        Debito: Decimal;
        Credito: Decimal;
        TipoDoc: Text[50];
        RecClientes: Record Customer;
        RecProveedores: Record Vendor;
        DocumentNumber: Code[20];
        FRegistroGL: Date;
        MovDesde: Integer;
        MovHasta: Integer;
        TransaccionActual: Integer;
        FiltroTransaccion: Text;
        Paso: Integer;
        RedondeoCont: Text[30];
        RedondeoVisual: Text[30];
        diferAdmitida: Decimal;
        "--- EXCEL ----": Text[30];
        d: Dialog;
        Linea: Integer;
        FactorLinea: Integer;
        SimboloDL: Text[10];
        NDocumento: Code[100];
        FechaAsiento: Date;
        DimVal: array[15] of Text[30];
        DimNom: array[15] of Text[30];
        TotDebe: Decimal;
        TotHaber: Decimal;
        MRecTempGLentry: Record "G/L Entry" temporary;
        MiTdebe: Decimal;
        MiThaber: Decimal;
        MRecTempGLentry2: Record "G/L Entry" temporary;
        rSIH: Record "Purch. Inv. Header";
        rCRM: Record "Purch. Cr. Memo Hdr.";
        rOPH: Record "GMAPosted Payment Order";
        rCTH: Record "GMAPosted Transfer";
        rRH: Record "GMAPosted Receipt";
        rCIE: Record "GMAPosted Deposit/Withdrawal";
        rVEN: Record Vendor;
        rVLG: Record "Vendor Ledger Entry";
        rSINVH: Record "Sales Invoice Header";
        rSCREDH: Record "Sales Cr.Memo Header";
        mNombreCLiente: Text[100];
        mCodigoCliente: Text[30];
        Agregame: Boolean;
        AsientoCierre: Integer;
        ACierreText: Text;
        globalAper: Text;
        Globalmov: Text;
        globalcier: Text;
        excelBuffer: Record "Excel Buffer";
        ContLine: Integer;
        GLEntryTemp: Record "G/L Entry" temporary;

        //Bssi Variables
        BssiMEMSystemSetup: record BssiMEMSystemSetup;
        BssiMEMCoreGlobalCU: Codeunit BssiMEMCoreGlobalCU;
        BssiMEMReportEvents: Codeunit BssiReportEvents;
        BssiDimension, BssiDimensionForRestriction : Text;
        BssiMEMSecurityHelper: Codeunit BssiMEMSecurityHelper;
        AccountName: Text;
        UsarNombreCorporativo: Boolean;
    // AW - END

    /// <summary>
    /// ActualizarFiltroTransaccion.
    /// </summary>
    /// <param name="Filtro">VAR Text.</param>
    /// <param name="NuevoValor">Text[30].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ActualizarFiltroTransaccion(var Filtro: Text; NuevoValor: Text[30]): Boolean;
    var
        pos: Integer;
        carac: Text[1];
        copiaFiltro: Text;
        ultimoValor: Integer;
        ultimoValorTXT: Text[30];
        siguienteValor: Text[30];
        okFILTRO: Boolean;
    begin
        MRecTempGLentry.DELETEALL;
        copiaFiltro := Filtro;
        pos := STRLEN(copiaFiltro);
        carac := '';
        ultimoValorTXT := '';
        okFILTRO := false;

        if pos = 0 then begin
            Filtro := NuevoValor;
            exit(true);
        end;


        repeat
            carac := COPYSTR(copiaFiltro, pos, 1);
            ultimoValorTXT := carac + ultimoValorTXT;
            pos -= 1;
        until (pos = 0) or (carac in ['.', '|']);


        if (carac in ['.', '|']) then
            ultimoValorTXT := COPYSTR(ultimoValorTXT, 2);

        if EVALUATE(ultimoValor, ultimoValorTXT) then begin
            siguienteValor := FORMAT(ultimoValor + 1);
            if FORMAT(siguienteValor) = NuevoValor then begin
                if carac = '.' then begin
                    copiaFiltro := COPYSTR(copiaFiltro, 1, pos + 1) + NuevoValor;
                    okFILTRO := true;
                end else begin
                    // es el primer valor de todo el filtro o de un nuevo rango
                    copiaFiltro := copiaFiltro + '..' + NuevoValor;
                    okFILTRO := true;
                end;

            end else begin
                copiaFiltro := copiaFiltro + '|' + NuevoValor;
                okFILTRO := true;
            end;

        end else begin
            ERROR(Text53802);
        end;


        if okFILTRO then begin
            Filtro := copiaFiltro;

        end;

        exit(okFILTRO);
    end;
}