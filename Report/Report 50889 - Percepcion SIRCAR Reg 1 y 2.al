/// <summary>
/// Report GMASIRCAR_REG_1y2 (ID 34006419).
/// </summary>
report 34006889 "PERSIRCAR_REG_1y2"
{
    Caption = 'SIRCAR registro 1 y 2';
    ProcessingOnly = true;

    dataset
    {
        dataitem(IVA; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") where("GMADocument Type Loc." = filter(Invoice | "Credit Memo" | "GMANota Debito"), Amount = filter(<> 0));
            column(ReportForNavId_1537; 1537)
            {
            }

            trigger OnAfterGetRecord()
            begin
                EscribirFichero := true;
                //I0031
                "#VatEntryIVA";
            end;

            trigger OnPostDataItem()
            var
                num1: Decimal;
                num2: Decimal;
                result: Decimal;
                dec: Text[1];
                cont: Integer;
                copycont: Integer;
                cont2: Integer;
                Encontro: Boolean;
            begin
            end;

            trigger OnPreDataItem()
            begin

                if FileName <> '' then begin
                    SetRange("Posting Date", FechaDesde, FechaHasta);
                    SetRange(Type, IVA.Type::Purchase);
                    SetRange("GMATax Type Loc", IVA."GMATax Type Loc"::"IVA Percepcion");
                    SetFilter("Tax Jurisdiction Code", '=%1', 'PIVA-ANA');
                end else
                    SetRange("Document No.", 'NoAplicaEXC');

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        IVA.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        IVA.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);

            end;
        }
        dataitem(Cordoba; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") where("GMADocument Type Loc." = filter(Invoice | "Credit Memo" | "GMANota Debito"), Amount = filter(<> 0));
            column(ReportForNavId_4198; 4198)
            {
            }

            trigger OnAfterGetRecord()
            begin

                EscribirFicheroCordoba := true;
                IsSales := false;
                Clear(Provincia);
                case Type of
                    Type::Sale:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recSalesInvHeader.Reset;
                                        recSalesInvHeader.SetRange("No.", "Document No.");
                                        if recSalesInvHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recSalesInvHeader."GMAAFIP Voucher Type";
                                        IsSales := true;
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recSalesCrMemoHeader.Reset;
                                        recSalesCrMemoHeader.SetRange("No.", "Document No.");
                                        if recSalesCrMemoHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recSalesCrMemoHeader."GMAAFIP Voucher Type";
                                        IsSales := true;
                                    end;
                            end;
                        end;

                    Type::Purchase:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recPurchInvHeader.Reset;
                                        recPurchInvHeader.SetRange("No.", "Document No.");
                                        if recPurchInvHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recPurchInvHeader."GMAInvoice Document Type";
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recPurchCrMemoHeader.Reset;
                                        recPurchCrMemoHeader.SetRange("No.", "Document No.");
                                        if recPurchCrMemoHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recPurchCrMemoHeader."GMAInvoice Document Type";
                                    end;
                            end;
                        end;
                end;


                if (DisSircar(FiltrorecProvince) = '2') then //para que identifique el registro 2
                    "#InsertVATEntryCordobaTemp";

            end;

            trigger OnPreDataItem()
            begin
                if (FileNameCordoba <> '') or (FileNameCordobaARP <> '') then begin
                    SetRange("Posting Date", FechaDesde, FechaHasta);
                    SetRange(Type, Cordoba.Type::Sale);

                    SetRange("GMATax Type Loc", "GMAtax type loc"::"Ingresos Brutos");

                end else
                    SetRange("Document No.", 'NoAplicaEXC');//Filtro para evitar que corra el dataitem

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        Cordoba.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        Cordoba.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);

            end;
        }
        dataitem(CordobaRetenciones; "GMAWithholding Ledger Entry")
        {
            DataItemTableView = sorting("GMANo.") order(ascending);
            column(ReportForNavId_8720; 8720)
            {
            }

            trigger OnAfterGetRecord()
            var
                _recTaxes: Record GMATaxes;
                _recValues: Record GMAValues;
            begin
                if "GMATax Code" <> '' then begin

                    _recValues.Reset;
                    _recValues.SetRange(GMACode, CordobaRetenciones.GMAValue);
                    if _recValues.FindFirst then begin
                        if (_recValues.GMAProvince = FiltrorecProvince) then begin
                            recCordobaTempIIBB.Reset;
                            recCordobaTempIIBB.SetRange("GMAVendor Code", "GMAVendor Code");
                            recCordobaTempIIBB.SetRange("GMAVoucher Number", "GMAVoucher Number");
                            if not recCordobaTempIIBB.FindFirst then begin
                                recCordobaTempIIBB.Init;
                                recCordobaTempIIBB.TransferFields(CordobaRetenciones);
                                recCordobaTempIIBB.Insert(false);
                            end else begin
                                recCordobaTempIIBB."GMACalculation Base" += "GMACalculation Base";
                                recCordobaTempIIBB."GMAWithholding Amount" += "GMAWithholding Amount";
                                recCordobaTempIIBB.GMABase += GMABase;
                                recCordobaTempIIBB.Modify(false);
                            end;

                        end;

                    end;
                end;

            end;

            trigger OnPreDataItem()
            begin

                if FileNameCordobaIIBB <> '' then begin
                    SetRange("GMAWithholding Date", FechaDesde, FechaHasta);
                    SetRange("GMAWithholding Type", "GMAwithholding type"::Realizada);
                    SetFilter("GMATax Code", 'IB*');
                    SetFilter("GMAWithholding Amount", '>%1', 0);
                end else
                    SetRange("GMAVendor Code", 'NoAplicaEXC');//Filtro para evitar que corra el dataitem

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        CordobaRetenciones.SetFilter("GMAShortcut Dimension 1", BssiDimension)
                    else
                        CordobaRetenciones.SetFilter("GMAShortcut Dimension 2", BssiDimension);

            end;
        }
        dataitem(SantaFe; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") where("GMADocument Type Loc." = filter(Invoice | "Credit Memo" | "GMANota Debito"), "Document No." = filter(<> ''), Amount = filter(<> 0));
            column(ReportForNavId_3959; 3959)
            {
            }

            trigger OnAfterGetRecord()
            begin

                EscribirFicheroSantaFe := true;
                EscribirFicheroEntreRios := true;
                Clear(Provincia);
                case Type of
                    Type::Sale:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recSalesInvHeader.Reset;
                                        recSalesInvHeader.SetRange("No.", "Document No.");
                                        if recSalesInvHeader.FindFirst then begin
                                            recSalesInvHeader.CalcFields(Amount, "Amount Including VAT");
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                            TipoComprobante := recSalesInvHeader."GMAAFIP Voucher Type";
                                            MontoCompTotal := recSalesInvHeader."Amount Including VAT";
                                            MontoComp := recSalesInvHeader.Amount;
                                        end;
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recSalesCrMemoHeader.Reset;
                                        recSalesCrMemoHeader.SetRange("No.", "Document No.");
                                        if recSalesCrMemoHeader.FindFirst then begin
                                            recSalesCrMemoHeader.CalcFields(Amount, "Amount Including VAT");
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                            TipoComprobante := recSalesCrMemoHeader."GMAAFIP Voucher Type";
                                            MontoCompTotal := recSalesCrMemoHeader."Amount Including VAT";
                                            MontoComp := recSalesCrMemoHeader.Amount;
                                        end;
                                    end;
                            end;
                        end;

                    Type::Purchase:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recPurchInvHeader.Reset;
                                        recPurchInvHeader.SetRange("No.", "Document No.");
                                        if recPurchInvHeader.FindFirst then begin
                                            recPurchInvHeader.CalcFields(Amount, "Amount Including VAT");

                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                            TipoComprobante := recPurchInvHeader."GMAInvoice Document Type";
                                            MontoCompTotal := recPurchInvHeader."Amount Including VAT";
                                            MontoComp := recPurchInvHeader.Amount;
                                        end;
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recPurchCrMemoHeader.Reset;
                                        recPurchCrMemoHeader.SetRange("No.", "Document No.");
                                        if recPurchCrMemoHeader.FindFirst then begin
                                            recPurchCrMemoHeader.CalcFields(Amount, "Amount Including VAT");

                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                            TipoComprobante := recPurchCrMemoHeader."GMAInvoice Document Type";
                                            MontoCompTotal := recPurchCrMemoHeader."Amount Including VAT";
                                            MontoComp := recPurchCrMemoHeader.Amount;
                                        end;
                                    end;
                            end;
                        end;
                end;

                if Provincia = FiltrorecProvince then begin
                    if (FiltrorecProvince = '908') then
                        "#InsertVATEntrySantaFeTemp"
                    else
                        "#InsertVATEntrySantaFeTemp";
                end;
            end;

            trigger OnPreDataItem()
            begin

                if (FileNameSantaFe <> '') or (FileNameEntreRios <> '') then begin
                    SetRange("Posting Date", FechaDesde, FechaHasta);
                    SetRange(Type, SantaFe.Type::Sale);
                    SetRange("GMATax Type Loc", "GMATax type loc"::"Ingresos Brutos");
                end else
                    SetRange("Document No.", 'NoAplicaEXC');//Filtro para evitar que corra el dataitem

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        SantaFe.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        SantaFe.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);

            end;
        }
        dataitem(Tucuman; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") where("GMADocument Type Loc." = filter(Invoice | "Credit Memo" | "GMANota Debito"), Amount = filter(<> 0));
            column(ReportForNavId_6769; 6769)
            {
            }

            trigger OnAfterGetRecord()
            var
                LocTaxArea: Record "Tax Area";
            begin
                EscribirFicheroTucuman := true;
                EscribirFicheroTucuman2 := true;
                EscribirFicheroTucuman3 := true;
                Clear(Provincia);
                Clear(TipoComprobante);
                Clear(Nombre_RazSoc);
                Clear(Domicilio);
                case Type of
                    Type::Sale:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recSalesInvHeader.Reset;
                                        recSalesInvHeader.SetRange("No.", "Document No.");
                                        if recSalesInvHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        if (CopyStr(recSalesInvHeader."No.", 1, 1) = 'A') then
                                            TipoComprobante := '01';

                                        if (CopyStr(recSalesInvHeader."No.", 1, 1) = 'B') then
                                            TipoComprobante := '06';

                                        if (CopyStr(recSalesInvHeader."No.", 1, 3) = 'NDB') then
                                            TipoComprobante := '07';

                                        if (CopyStr(recSalesInvHeader."No.", 1, 3) = 'NDA') then
                                            TipoComprobante := '02';

                                        if (TipoComprobante = '') then
                                            TipoComprobante := '99';

                                        Nombre_RazSoc := recSalesInvHeader."Bill-to Name";
                                        Domicilio := recSalesInvHeader."Bill-to Address";
                                        CodPostal := recSalesInvHeader."Bill-to Post Code";
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recSalesCrMemoHeader.Reset;
                                        recSalesCrMemoHeader.SetRange("No.", "Document No.");
                                        if recSalesCrMemoHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");

                                        if (CopyStr(recSalesCrMemoHeader."No.", 1, 3) = 'NCA') then
                                            TipoComprobante := '03';

                                        if (CopyStr(recSalesCrMemoHeader."No.", 1, 3) = 'NCB') then
                                            TipoComprobante := '08';

                                        if (TipoComprobante = '') then
                                            TipoComprobante := '99';


                                        Nombre_RazSoc := recSalesCrMemoHeader."Bill-to Name";
                                        Domicilio := recSalesCrMemoHeader."Bill-to Address";
                                        CodPostal := recSalesCrMemoHeader."Bill-to Post Code";
                                    end;
                            end;
                        end;

                    Type::Purchase:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recPurchInvHeader.Reset;
                                        recPurchInvHeader.SetRange("No.", "Document No.");
                                        if recPurchInvHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        if (LocTaxArea.Get(recPurchInvHeader."Tax Area Code")) then begin
                                            if (LocTaxArea."GMAInvoice Letter" = 'A') then begin
                                                if (recPurchInvHeader."GMAInvoice Type" = recPurchInvHeader."GMAinvoice type"::Factura) then
                                                    TipoComprobante := '01';

                                                if (recPurchInvHeader."GMAInvoice Type" = recPurchInvHeader."GMAinvoice type"::"Nota Debito") then
                                                    TipoComprobante := '02';

                                            end;
                                            if (LocTaxArea."GMAInvoice Letter" = 'B') then begin
                                                if (recPurchInvHeader."GMAInvoice Type" = recPurchInvHeader."GMAinvoice type"::Factura) then
                                                    TipoComprobante := '06';

                                                if (recPurchInvHeader."GMAInvoice Type" = recPurchInvHeader."GMAinvoice type"::"Nota Debito") then
                                                    TipoComprobante := '07';
                                            end;
                                        end;

                                        Nombre_RazSoc := recPurchInvHeader."Pay-to Vendor No.";
                                        Domicilio := recPurchInvHeader."Pay-to Address";
                                        CodPostal := recPurchInvHeader."Pay-to Post Code";
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recPurchCrMemoHeader.Reset;
                                        recPurchCrMemoHeader.SetRange("No.", "Document No.");
                                        if recPurchCrMemoHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        if (LocTaxArea.Get(recPurchCrMemoHeader."Tax Area Code")) then begin
                                            if (LocTaxArea."GMAInvoice Letter" = 'A') then
                                                TipoComprobante := '03';
                                            if (LocTaxArea."GMAInvoice Letter" = 'B') then
                                                TipoComprobante := '08';
                                        end;

                                        if (TipoComprobante = '') then
                                            TipoComprobante := '99';


                                        Nombre_RazSoc := recPurchCrMemoHeader."Pay-to Vendor No.";
                                        Domicilio := recPurchCrMemoHeader."Pay-to Address";
                                        CodPostal := recPurchCrMemoHeader."Pay-to Post Code";
                                    end;
                            end;
                        end;
                end;

                if Provincia = '924' then
                    "#InsertVATEntryTucumanTemp";

            end;

            trigger OnPreDataItem()
            begin

                if FileNameTucuman <> '' then begin
                    SetRange("Posting Date", FechaDesde, FechaHasta);
                    SetRange(Type, Tucuman.Type::Sale);
                    SetRange("GMATax Type Loc", "GMAtax type loc"::"Ingresos Brutos");
                end else
                    SetRange("Document No.", 'NoAplicaEXC');//Filtro para evitar que corra el dataitem

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        Tucuman.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        Tucuman.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
            end;
        }
        dataitem(Misiones; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") where("GMADocument Type Loc." = filter(Invoice | "Credit Memo" | "GMANota Debito"), Amount = filter(<> 0));
            column(ReportForNavId_2274; 2274)
            {
            }

            trigger OnAfterGetRecord()
            begin
                EscribirFicheroMisiones := true;
                Clear(Provincia);
                Clear(TipoComprobante);
                Clear(Nombre_RazSoc);
                Clear(Domicilio);
                case Type of
                    Type::Sale:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recSalesInvHeader.Reset;
                                        recSalesInvHeader.SetRange("No.", "Document No.");
                                        if recSalesInvHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recSalesInvHeader."GMAAFIP Voucher Type";
                                        Nombre_RazSoc := recSalesInvHeader."Bill-to Name";
                                        Domicilio := recSalesInvHeader."Bill-to Address";
                                        CodPostal := recSalesInvHeader."Bill-to Post Code";
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recSalesCrMemoHeader.Reset;
                                        recSalesCrMemoHeader.SetRange("No.", "Document No.");
                                        if recSalesCrMemoHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recSalesCrMemoHeader."GMAAFIP Voucher Type";
                                        Nombre_RazSoc := recSalesCrMemoHeader."Bill-to Name";
                                        Domicilio := recSalesCrMemoHeader."Bill-to Address";
                                        CodPostal := recSalesCrMemoHeader."Bill-to Post Code";
                                    end;
                            end;
                        end;

                    Type::Purchase:
                        begin
                            case "GMADocument Type Loc." of
                                "GMADocument Type Loc."::Invoice, "GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recPurchInvHeader.Reset;
                                        recPurchInvHeader.SetRange("No.", "Document No.");
                                        if recPurchInvHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recPurchInvHeader."GMAInvoice Document Type";
                                        Nombre_RazSoc := recPurchInvHeader."Pay-to Vendor No.";
                                        Domicilio := recPurchInvHeader."Pay-to Address";
                                        CodPostal := recPurchInvHeader."Pay-to Post Code";
                                    end;

                                "GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recPurchCrMemoHeader.Reset;
                                        recPurchCrMemoHeader.SetRange("No.", "Document No.");
                                        if recPurchCrMemoHeader.FindFirst then
                                            Provincia := "#Provincia"("Tax Jurisdiction Code", "VAT Prod. Posting Group");
                                        TipoComprobante := recPurchCrMemoHeader."GMAInvoice Document Type";
                                        Nombre_RazSoc := recPurchCrMemoHeader."Pay-to Vendor No.";
                                        Domicilio := recPurchCrMemoHeader."Pay-to Address";
                                        CodPostal := recPurchCrMemoHeader."Pay-to Post Code";
                                    end;
                            end;
                        end;
                end;

                if Provincia = '914' then
                    "#InsertVATEntryMisionesTemp";

            end;

            trigger OnPreDataItem()
            begin

                if FileNameMisiones <> '' then begin
                    SetRange("Posting Date", FechaDesde, FechaHasta);

                    SetRange(Type, Misiones.Type::Sale);

                    SetRange("GMATax Type Loc", "GMAtax type loc"::"Ingresos Brutos");
                end else
                    SetRange("Document No.", 'NoAplicaEXC');//Filtro para evitar que corra el dataitem

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        Misiones.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        Misiones.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
            end;
        }
        dataitem(IIBB; "VAT Entry")
        {
            DataItemTableView = sorting("Entry No.") where("GMADocument Type Loc." = filter(Invoice | "Credit Memo" | "GMANota Debito"), Amount = filter(<> 0));
            column(ReportForNavId_6570; 6570)
            {
            }

            trigger OnAfterGetRecord()
            begin

                EscribirFicheroIIBB := true;
                "#VatEntryIIBB";

            end;

            trigger OnPreDataItem()
            begin

                if FileNameIIBB <> '' then begin
                    SetRange("Posting Date", FechaDesde, FechaHasta);
                    SetRange(Type, IVA.Type::Purchase);
                    SetRange("GMATax Type Loc", IIBB."GMAtax type loc"::"Ingresos Brutos");

                    SetFilter("Tax Area Code", '*ADUANA*');

                end else
                    SetRange("Document No.", 'NoAplicaEXC');//Filtro para evitar que corra el dataitem

                if (BssiDimension <> '') then
                    if "BssiMEMSystemSetup".Bssi_iGetGlobalDimensionNoToUse() = 1 then
                        IIBB.SetFilter("Bssi Shortcut Dimension 1 Code", BssiDimension)
                    else
                        IIBB.SetFilter("Bssi Shortcut Dimension 2 Code", BssiDimension);
            end;
        }
        dataitem(IntCordoba; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_1438; 1438)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    recCordobaTemp.FindFirst
                else
                    recCordobaTemp.Next;

                if FileNameCordoba <> '' then
                    "#VatEntryCordoba";

                if FileNameCordobaARP <> '' then
                    "#VatEntryCordobaARP";

            end;

            trigger OnPreDataItem()
            begin

                NumeroRenglonSircar := 0;
                recCordobaTemp.Reset;
                SetRange(Number, 1, recCordobaTemp.Count);
            end;
        }
        dataitem(IntCordobaIIBB; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_4100; 4100)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    recCordobaTempIIBB.FindFirst
                else
                    recCordobaTempIIBB.Next;

                if (FiltrorecProvince = '913') then
                    "#VatEntryCordobaIIBB"(FiltrorecProvince)

                else
                    "#VatEntryCordobaIIBB"(FiltrorecProvince);

            end;

            trigger OnPreDataItem()
            begin

                NumeroRenglonSircar := 0;
                recCordobaTempIIBB.Reset;
                SetRange(Number, 1, recCordobaTempIIBB.Count);

            end;
        }
        dataitem(IntSantaFe; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_1199; 1199)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    recSantaFeTemp.FindFirst
                else
                    recSantaFeTemp.Next;

                "#VatEntrySantaFe"(FiltrorecProvince);

            end;

            trigger OnPreDataItem()
            begin

                recSantaFeTemp.Reset;
                SetRange(Number, 1, recSantaFeTemp.Count);
            end;
        }
        dataitem(IntEntreRios; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    recEntreRiosTemp.FindFirst
                else
                    recEntreRiosTemp.Next;

                "#VatEntryEntreRios"(FiltrorecProvince);

            end;

            trigger OnPreDataItem()
            begin

                recEntreRiosTemp.Reset;
                SetRange(Number, 1, recEntreRiosTemp.Count);

            end;
        }
        dataitem(IntTucuman; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_5157; 5157)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    recTucumanTemp.FindFirst
                else
                    recTucumanTemp.Next;

                "#VatEntryTucuman";

            end;

            trigger OnPreDataItem()
            begin

                recTucumanTemp.Reset;
                SetRange(Number, 1, recTucumanTemp.Count);
            end;
        }
        dataitem(IntMisiones; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_6531; 6531)
            {
            }

            trigger OnAfterGetRecord()
            var
                _recTaxArea: Record "Tax Area";
            begin
                if Number = 1 then
                    recMisionesTemp.FindFirst
                else
                    recMisionesTemp.Next;


                Clear(Provincia);
                Clear(TipoComprobante);
                Clear(Nombre_RazSoc);
                Clear(Domicilio);
                case recMisionesTemp.Type of
                    recMisionesTemp.Type::Sale:
                        begin
                            case recMisionesTemp."GMADocument Type Loc." of
                                recMisionesTemp."GMADocument Type Loc."::Invoice, recMisionesTemp."GMADocument Type Loc."::"GMANota Debito":
                                    begin
                                        recSalesInvHeader.Reset;
                                        recSalesInvHeader.SetRange("No.", recMisionesTemp."Document No.");
                                        if recSalesInvHeader.FindFirst then begin
                                            _recTaxArea.Reset;
                                            _recTaxArea.SetRange(Code, recSalesInvHeader."Tax Area Code");
                                            if _recTaxArea.FindFirst then;
                                            case recSalesInvHeader."GMAAFIP Voucher Type" of
                                                '001':
                                                    TipoComprobante := 'FA_A';
                                                '006':
                                                    TipoComprobante := 'FA_B';
                                                '011':
                                                    TipoComprobante := 'FA_C';
                                                '003':
                                                    TipoComprobante := 'NC_A';
                                                '008':
                                                    TipoComprobante := 'NC_B';
                                                '013':
                                                    TipoComprobante := 'NC_C';
                                                '002':
                                                    TipoComprobante := 'ND_A';
                                                '007':
                                                    TipoComprobante := 'ND_B';
                                                '012':
                                                    TipoComprobante := 'ND_C';
                                                '201':
                                                    TipoComprobante := 'FCE_A';
                                                '206':
                                                    TipoComprobante := 'FCE_B';
                                                '211':
                                                    TipoComprobante := 'FCE_C';
                                                '203':
                                                    TipoComprobante := 'NCE_A';
                                                '208':
                                                    TipoComprobante := 'NCE_B';
                                                '213':
                                                    TipoComprobante := 'NCE_C';
                                                '202':
                                                    TipoComprobante := 'NDE_A';
                                                '207':
                                                    TipoComprobante := 'NDE_B';
                                                '212':
                                                    TipoComprobante := 'NDE_C';
                                            end;
                                            //TipoComprobante := _recTaxArea."GMAInvoice Letter";

                                            Provincia := recSalesInvHeader.GMAProvince;
                                            Nombre_RazSoc := recSalesInvHeader."Bill-to Name";
                                            Domicilio := recSalesInvHeader."Sell-to Address";
                                            CodPostal := recSalesInvHeader."Sell-to Post Code";
                                        end;
                                    end;

                                recMisionesTemp."GMADocument Type Loc."::"Credit Memo":
                                    begin
                                        recSalesCrMemoHeader.Reset;
                                        recSalesCrMemoHeader.SetRange("No.", recMisionesTemp."Document No.");
                                        if recSalesCrMemoHeader.FindFirst then begin
                                            _recTaxArea.Reset;
                                            _recTaxArea.SetRange(Code, recSalesCrMemoHeader."Tax Area Code");
                                            if _recTaxArea.FindFirst then;
                                            case recSalesCrMemoHeader."GMAAFIP Voucher Type" of
                                                '001':
                                                    TipoComprobante := 'FA_A';
                                                '006':
                                                    TipoComprobante := 'FA_B';
                                                '011':
                                                    TipoComprobante := 'FA_C';
                                                '003':
                                                    TipoComprobante := 'NC_A';
                                                '008':
                                                    TipoComprobante := 'NC_B';
                                                '013':
                                                    TipoComprobante := 'NC_C';
                                                '002':
                                                    TipoComprobante := 'ND_A';
                                                '007':
                                                    TipoComprobante := 'ND_B';
                                                '012':
                                                    TipoComprobante := 'ND_C';
                                                '201':
                                                    TipoComprobante := 'FCE_A';
                                                '206':
                                                    TipoComprobante := 'FCE_B';
                                                '211':
                                                    TipoComprobante := 'FCE_C';
                                                '203':
                                                    TipoComprobante := 'NCE_A';
                                                '208':
                                                    TipoComprobante := 'NCE_B';
                                                '213':
                                                    TipoComprobante := 'NCE_C';
                                                '202':
                                                    TipoComprobante := 'NDE_A';
                                                '207':
                                                    TipoComprobante := 'NDE_B';
                                                '212':
                                                    TipoComprobante := 'NDE_C';
                                            end;
                                            //TipoComprobante := _recTaxArea."GMAInvoice Letter";

                                            Provincia := recSalesCrMemoHeader.GMAProvince;
                                            Nombre_RazSoc := recSalesCrMemoHeader."Bill-to Name";
                                            Domicilio := recSalesCrMemoHeader."Sell-to Address";
                                            CodPostal := recSalesCrMemoHeader."Sell-to Post Code";
                                        end;
                                    end;
                            end;
                        end;
                end;

                "#VatEntryMisiones";

            end;

            trigger OnPreDataItem()
            begin

                recMisionesTemp.Reset;
                SetRange(Number, 1, recMisionesTemp.Count);
            end;
        }
        dataitem(IntSalesCrTemp; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_7577; 7577)
            {
            }

            trigger OnAfterGetRecord()
            var
                _SalesInvoiceHeader: Record "Sales Invoice Header";
                _Campo1: Text[4];
                _Campo2: Text[20];
                _Campo3: Text[4];
                _Campo4: Text[20];
                _Campo5: Text[2];
                _CampoTemp: Text[30];
            begin
                if Number = 1 then
                    recSalesCrMemoHeaderTemp.FindFirst
                else
                    recSalesCrMemoHeaderTemp.Next;

                NumeroLineasTucuman3 += 1;
                _SalesInvoiceHeader.Reset;
                _SalesInvoiceHeader.SetRange("No.", recSalesCrMemoHeaderTemp."Applies-to Doc. No.");
                if _SalesInvoiceHeader.FindFirst then;


                Clear(_CampoTemp);
                _CampoTemp := DelChr(recSalesCrMemoHeaderTemp."No.", '=', ' QWERTYUIOP├â┬â├é┬»+}{├â┬é├é┬ÑLKJHGFDSA<ZXCVBNM,.-');

                _Campo1 := CopyStr(_CampoTemp, 1, 4);

                while StrLen(_Campo1) < 4 do
                    _Campo1 := '0' + _Campo1;


                _Campo2 := DelChr(recSalesCrMemoHeaderTemp."No.", '=', ' QWERTYUIOP├â┬â├é┬»+}{├â┬é├é┬ÑLKJHGFDSA<ZXCVBNM,.-');
                if (StrLen(_Campo2) > 8) then begin
                    _Campo2 := CopyStr(_Campo2, (StrLen(_Campo2) - 7), 8);
                end
                else begin
                    while StrLen(_Campo2) < 8 do
                        _Campo2 := '0' + _Campo2;
                end;

                Clear(_CampoTemp);
                _CampoTemp := DelChr(_SalesInvoiceHeader."No.", '=', ' QWERTYUIOP├â┬â├é┬»+}{├â┬é├é┬ÑLKJHGFDSA<ZXCVBNM,.-');

                _Campo3 := CopyStr(_CampoTemp, 1, 4);
                while StrLen(_Campo3) < 4 do
                    _Campo3 := '0' + _Campo3;

                _Campo4 := DelChr(_SalesInvoiceHeader."No.", '=', ' QWERTYUIOP├â┬â├é┬»+}{├â┬é├é┬ÑLKJHGFDSA<ZXCVBNM,.-');
                if (StrLen(_Campo4) > 8) then begin
                    _Campo4 := CopyStr(_Campo4, (StrLen(_Campo4) - 7), 8);
                end
                else begin
                    while StrLen(_Campo4) < 8 do
                        _Campo4 := '0' + _Campo4;
                end;

                if (CopyStr(_SalesInvoiceHeader."No.", 1, 1) = 'A') then
                    _Campo5 := '01';

                if (CopyStr(_SalesInvoiceHeader."No.", 1, 1) = 'B') then
                    _Campo5 := '06';

                if (CopyStr(_SalesInvoiceHeader."No.", 1, 3) = 'NDB') then
                    _Campo5 := '07';

                if (CopyStr(_SalesInvoiceHeader."No.", 1, 3) = 'NDA') then
                    _Campo5 := '02';

                if (_Campo5 = '') then
                    _Campo5 := '99';


                Clear(TextoTucuman3);
                TextoTucuman3 := (
                  Format(_Campo1, 4, '<Text>') +
                  Format(_Campo2, 8, '<Text>') +
                  Format(_Campo3, 4, '<Text>') +
                  Format(_Campo4, 8, '<Text>') +
                  Format(_Campo5, 2, '<Text>')
                );


                "#RellenaExcelBuffTucuman3"(TextoTucuman3);

            end;

            trigger OnPreDataItem()
            begin

                recSalesCrMemoHeaderTemp.Reset;
                SetRange(Number, 1, recSalesCrMemoHeaderTemp.Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Exportaciones)
                {
                    Caption = 'Exportaciones';
                    field(FechaDesde; FechaDesde)
                    {
                        ApplicationArea = Basic;
                        Caption = 'From Date';
                    }
                    field(FechaHasta; FechaHasta)
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Date';
                    }
                    field(TipoRetencion; TipoRetencion)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tipo retencion';
                        TableRelation = GMAValues;
                        Visible = false;
                    }
                    field(FileName; FileName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Perceptions Aduana de IVA';

                        trigger OnDrillDown()
                        var
                            d: Text[30];
                            t: Text[30];
                        begin
                            d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                            t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                            FileName := 'Percep.Aduana' + d + '_' + t;
                        end;
                    }
                    field(FileNameIIBB; FileNameIIBB)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Perceptions Aduana de IIBB';

                        trigger OnDrillDown()
                        var
                            d: Text[30];
                            t: Text[30];
                        begin
                            d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                            t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                            FileNameIIBB := 'Percep.IIBB' + d + '_' + t;
                        end;
                    }
                    field(BssiDimension; BssiDimension)
                    {
                        ApplicationArea = ALL;
                        CaptionClass = BssiMEMCoreGlobalCU.BssiGetDimFilterCaption();
                        ToolTip = 'Select the Entity to restrict the report.';
                        Importance = Promoted;

                        trigger OnLookup(var Text1: Text): Boolean
                        var
                            BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
                        begin
                            BssiDimensionForRestriction := '';
                            BssiMEMSecurityHelper.Bssi_LookupEntityCodeForReports(BssiDimension);
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
                }
                group("Percepciones Registro 1 y 2")
                {
                    Caption = 'Percepciones Registro 1 y 2';
                    field(FiltrorecProvince; FiltrorecProvince)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Filtro Province';
                        TableRelation = GMAProvince;
                    }
                    field(FileNameSantaFe; FileNameSantaFe)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archivo de Percepciones';

                        trigger OnAssistEdit()
                        var
                            d: Text[30];
                            t: Text[30];
                        begin
                            d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                            t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                            FileNameSantaFe := 'Percep.Provincia' + FiltrorecProvince + '_' + d + '_' + t;

                        end;

                    }
                    group("Entre Rios")
                    {
                        Caption = 'Entre Rios';
                        Visible = false;
                        field("Filtro Province"; FiltrorecProvince)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Filtro Province';
                            TableRelation = GMAProvince;
                        }
                        field(FileNameEntreRios; FileNameEntreRios)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Perceptions Entre Rios';

                            trigger OnAssistEdit()
                            var
                                d: Text[30];
                                t: Text[30];
                            begin

                                d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                                t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                                FileNameEntreRios := 'Percep.Entre_Rios' + d + '_' + t;

                            end;
                        }
                    }
                    group("Retenciones y Percepciones Registro 2")
                    {
                        Caption = 'Retenciones y Percepciones Registro 2';
                        field("<Control40>"; FiltrorecProvince)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Filtro Province';
                            Editable = false;
                            TableRelation = GMAProvince;
                        }
                        field(FileNameCordoba; FileNameCordoba)
                        {
                            ApplicationArea = Basic;
                            Caption = 'SIRCAR Perceptions Cordoba';

                            trigger OnAssistEdit()
                            var
                                d: Text[30];
                                t: Text[30];
                            begin
                                d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                                t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                                FileNameCordoba := 'Percep.Cordoba' + d + '_' + t;
                            end;
                        }
                        field(FileNameCordobaIIBB; FileNameCordobaIIBB)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Agentes de retencion Ingresos Brutos Registro 1 y 2';

                            trigger OnAssistEdit()
                            var
                                d: Text[30];
                                t: Text[30];
                            begin

                                d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                                t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                                FileNameCordobaIIBB := 'Retencion.Provincia' + FiltrorecProvince + '_' + d + '_' + t;

                            end;
                        }
                        field(FileNameCordobaARP; FileNameCordobaARP)
                        {
                            ApplicationArea = Basic;
                            Caption = 'ARP Retenciones Cordoba';

                            trigger OnAssistEdit()
                            var
                                d: Text[30];
                                t: Text[30];
                            begin

                                d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                                t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                                FileNameCordobaARP := 'ARP.Reten.Cordoba' + d + '_' + t;

                            end;
                        }
                    }
                    group(Tucuman)
                    {
                        Caption = 'Tucuman';
                        group("Perceptions Tucuman")
                        {
                            Caption = 'Perceptions Tucuman';
                            field(FileNameTucuman; FileNameTucuman)
                            {
                                ApplicationArea = Basic;
                                Caption = 'DATOS';

                                trigger OnAssistEdit()
                                var
                                    d: Text[30];
                                    t: Text[30];
                                begin

                                    d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                                    t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                                    FileNameTucuman := 'DATOS';
                                    FileNameTucuman2 := CopyStr(FileNameTucuman, 1, (StrLen(FileNameTucuman) - 9)) + 'RETPER.txt';
                                    FileNameTucuman3 := CopyStr(FileNameTucuman, 1, (StrLen(FileNameTucuman) - 9)) + 'NCFACT.txt';

                                end;
                            }
                            field(FileNameTucuman2; FileNameTucuman2)
                            {
                                ApplicationArea = Basic;
                                Caption = 'RETPER';
                                Editable = false;
                            }
                            field(FileNameTucuman3; FileNameTucuman3)
                            {
                                ApplicationArea = Basic;
                                Caption = 'NCFACT';
                                Editable = false;
                            }
                        }
                        field(FileNameMisiones; FileNameMisiones)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Perceptions Misiones';

                            trigger OnAssistEdit()
                            var
                                d: Text[30];
                                t: Text[30];
                            begin
                                d := Format(DelChr(Format(FechaDesde), '=', ':;/.,'));
                                t := Format(DelChr(Format(FechaHasta), '=', ':;/.,'));
                                FileNameMisiones := 'Percep.Misiones' + d + '_' + t;

                            end;
                        }
                    }
                }
            }

        }

        trigger OnOpenPage()
        var
        begin
            BssiMEMSingleInstanceCU.Bssi_SetCurrentHeaderEntity('');
            BssiMEMSingleInstanceCU.Bssi_SetCurrentEntity('');
            BssiMEMSystemSetup.Get();

            if BssiDimension <> '' then
                BssiDimensionForRestriction := BssiMEMCoreGlobalCU.Bssi_getEntityFilterString(BssiDimension)
            else
                BssiDimensionForRestriction := BssiMEMSecurityHelper.Bssi_tGetUserSecurityFilterText();
        end;

    }

    labels
    {
    }

    trigger OnPostReport()
    begin



        FileNameNull := 'SinoNoAnda.txt';// solamente esta para que funcione no guarda nada aca.

        if NumeroLineas > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuff);
            Xmlport.Run(34006396, false, false);
        end;


        if NumeroLineasCordoba > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffCordoba);
            Xmlport.Run(34006396, false, false);
        end;

        if NumeroLineasCordobaIIBB > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffCordobaIIBB);
            Xmlport.Run(34006396, false, false);
        end;


        if NumeroLineasCordobaARP > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffCordobaARP);
            Xmlport.Run(34006396, false, false);
        end;



        if NumeroLineasSantaFe > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffSantaFe);
            Xmlport.Run(34006396, false, false);
        end;



        if NumeroLineasEntreRios > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffEntreRios);
            Xmlport.Run(34006396, false, false);
        end;

        if NumeroLineasTucuman > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffTucuman);
            Xmlport.Run(34006396, false, false);
        end;


        if NumeroLineasMisiones > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffMisiones);
            Xmlport.Run(34006396, false, false);
        end;
        // ExportaTxt."#ExportaTxtWithName"(FileNameNull, TempExcelBuffMisiones, FileNameMisiones);



        if NumeroLineasIIBB > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffIIBB);
            Xmlport.Run(34006396, false, false);
        end;


        /* if NumeroLineasTucuman2 > 0 then begin
             ExportaTxt."#ExportaTxtWithName"(FileNameNull, TempExcelBuffTucuman2, FileNameTucuman2);
         end;*/
        if NumeroLineasTucuman2 > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffTucuman2);
            Xmlport.Run(34006396, false, false);
        end;


        if NumeroLineasTucuman3 > 0 then begin
            XMLImporExport."#CargaExcelBuffTemp"(TempExcelBuffTucuman3);
            Xmlport.Run(34006396, false, false);
        end;

        if ((NumeroLineas = 0) and (NumeroLineasCordoba = 0) and
            (NumeroLineasSantaFe = 0) and
            (NumeroLineasEntreRios = 0) and (NumeroLineasTucuman = 0) and
            (NumeroLineasTucuman2 = 0) and (NumeroLineasTucuman3 = 0) and
            (NumeroLineasIIBB = 0) and (NumeroLineasMisiones = 0) and
            (NumeroLineasCordobaIIBB = 0) and (NumeroLineasCordobaARP = 0)) then
            Message(Text004);

    end;

    trigger OnPreReport()
    begin
        CR := 13;
        FL := 10;

        recCordobaTempIIBB.DeleteAll;

    end;

    var
        XMLImporExport: XmlPort "GMAXML ImportExport";
        FechaDesde: Date;
        FechaHasta: Date;
        Proveedor: Record Vendor;

        Texto: Text[1024];
        FileName: Text[250];

        NumeroLineas: Integer;
        EscribirFichero: Boolean;

        TempExcelBuff: Record "Excel Buffer" temporary;

        CR: Char;
        FL: Char;

        TipoRetencion: Code[50];


        Campo1: Text[100];
        Campo2: Text[100];
        Campo3: Text[100];
        Campo4: Text[100];
        Campo5: Text[100];
        Campo6: Text[100];
        Campo7: Text[100];
        Campo8: Text[100];
        Campo9: Text[100];
        Campo10: Text[100];
        Campo11: Text[100];
        Campo12: Text[100];
        Campo13: Text[100];
        Campo14: Text[100];
        Campo15: Text[100];
        Campo16: Text[100];
        Campo17: Text[100];
        Campo18: Text[100];
        Campo19: Text[100];
        Campo20: Text[100];
        Campo21: Text[100];
        Text004: label 'There are no records to generate the file.';
        Campo22: Text[100];
        Campo23: Text[100];
        Campo24: Text[100];
        Campo25: Text[100];
        Campo26: Text[100];
        Campo27: Text[100];
        Campo28: Text[100];
        nroig: Code[20];
        baseretencion: Decimal;
        TextTemp: Text[20];
        tempvatentry: Record "VAT Entry" temporary;
        aux: Integer;
        auxvatentry: Record "VAT Entry";
        importesumado: Decimal;
        RecCustomer: Record Customer;
        Doc: Text[100];
        "----------Cordoba----------": Integer;
        OutFileCordoba: File;
        TextoCordoba: Text[1024];
        FileNameCordoba: Text[250];
        NumeroLineasCordoba: Integer;
        EscribirFicheroCordoba: Boolean;
        TextoBisCordoba: BigText;
        TempExcelBuffCordoba: Record "Excel Buffer" temporary;
        "-----------SantaFe-----------": Integer;
        OutFileSantaFe: File;
        TextoSantaFe: Text[1024];
        FileNameSantaFe: Text[250];
        NumeroLineasSantaFe: Integer;
        EscribirFicheroSantaFe: Boolean;
        TextoBisSantaFe: BigText;
        TempExcelBuffSantaFe: Record "Excel Buffer" temporary;
        "-----------Tucuman-----------": Integer;
        OutFileTucuman: File;
        TextoTucuman: Text[1024];
        FileNameTucuman: Text[250];
        NumeroLineasTucuman: Integer;
        EscribirFicheroTucuman: Boolean;
        TextoBisTucuman: BigText;
        TempExcelBuffTucuman: Record "Excel Buffer" temporary;
        FileNameNull: Text[250];
        "-----------IIBB-----------": Integer;
        OutFileIIBB: File;
        TextoIIBB: Text[1024];
        FileNameIIBB: Text[250];
        NumeroLineasIIBB: Integer;
        EscribirFicheroIIBB: Boolean;
        TextoBisIIBB: BigText;
        TempExcelBuffIIBB: Record "Excel Buffer" temporary;
        "----------------------------": Integer;
        recPurchInvHeader: Record "Purch. Inv. Header";
        recSalesInvHeader: Record "Sales Invoice Header";
        recPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Provincia: Code[20];
        TipoComprobante: Code[20];
        PrimeraParteNComp: Text[50];
        SegundaParteNComp: Text[50];
        Nombre_RazSoc: Text[100];
        Domicilio: Text[100];
        CodPostal: Text[50];
        recProvince: Record GMAProvince;
        recPostCode: Record "Post Code";
        Localidad: Text[100];
        IsSales: Boolean;
        recVendor: Record Vendor;
        MontoCompTotal: Decimal;
        MontoComp: Decimal;
        "-----------Misiones-----------": Integer;
        OutFileMisiones: File;
        TextoMisiones: Text[1024];
        FileNameMisiones: Text[250];
        NumeroLineasMisiones: Integer;
        EscribirFicheroMisiones: Boolean;
        TextoBisMisiones: BigText;
        TempExcelBuffMisiones: Record "Excel Buffer" temporary;
        "------------------------------": Integer;
        recCordobaTemp: Record "VAT Entry" temporary;
        recSantaFeTemp: Record "VAT Entry" temporary;
        recTucumanTemp: Record "VAT Entry" temporary;
        recMisionesTemp: Record "VAT Entry" temporary;
        "-----------Tucuman2-----------": Integer;
        OutFileTucuman2: File;
        TextoTucuman2: Text[1024];
        FileNameTucuman2: Text[250];
        NumeroLineasTucuman2: Integer;
        EscribirFicheroTucuman2: Boolean;
        TextoBisTucuman2: BigText;
        TempExcelBuffTucuman2: Record "Excel Buffer" temporary;
        FileNameNull2: Text[250];
        "-----------Tucuman3-----------": Integer;
        OutFileTucuman3: File;
        TextoTucuman3: Text[1024];
        FileNameTucuman3: Text[250];
        NumeroLineasTucuman3: Integer;
        EscribirFicheroTucuman3: Boolean;
        TextoBisTucuman3: BigText;
        TempExcelBuffTucuman3: Record "Excel Buffer" temporary;
        FileNameNull3: Text[250];
        recSalesCrMemoHeaderTemp: Record "Sales Cr.Memo Header" temporary;
        recVendor2: Record Vendor;
        Text005: label 'Debe Configurar la provincia en Jurisdiccion Impuesto %1';
        NumeroRenglonSircar: Integer;
        "--------Cordoba IIBB--------": Integer;
        OutFileCordobaIIBB: File;
        TextoCordobaIIBB: Text[1024];
        FileNameCordobaIIBB: Text[250];
        NumeroLineasCordobaIIBB: Integer;
        EscribirFicheroCordobaIIBB: Boolean;
        TextoBisCordobaIIBB: BigText;
        TempExcelBuffCordobaIIBB: Record "Excel Buffer" temporary;
        recCordobaTempIIBB: Record "GMAWithholding Ledger Entry" temporary;
        "-------Cordoba APR------": Integer;
        OutFileCordobaARP: File;
        TextoCordobaARP: Text[1024];
        FileNameCordobaARP: Text[250];
        NumeroLineasCordobaARP: Integer;
        EscribirFicheroCordobaARP: Boolean;
        TextoBisCordobaARP: BigText;
        TempExcelBuffCordobaARP: Record "Excel Buffer" temporary;
        "-----------Entre Ri-----------": Integer;
        OutFileEntreRios: File;
        TextoEntreRios: Text[1024];
        FileNameEntreRios: Text[250];
        NumeroLineasEntreRios: Integer;
        EscribirFicheroEntreRios: Boolean;
        TextoBisEntreRios: BigText;
        TempExcelBuffEntreRios: Record "Excel Buffer";
        DELDOCNUM: label ' QWERTYUIOP├û+}{┬ÑLKJHGFDSA<ZXCVBNM-!"#$%&/()=?┬¡├Éqwertyuiopasdfghjkl┬ñ<zxcvbnm,.;:_[]*';
        recEntreRiosTemp: Record "VAT Entry" temporary;
        FiltrorecProvince: Code[10];
        BssiMEMSystemSetup: Record "BssiMEMSystemSetup";
        BssiMEMSecurityHelper: codeunit BssiMEMSecurityHelper;
        BssiMEMCoreGlobalCU: codeunit BssiMEMCoreGlobalCU;
        BssiMEMSingleInstanceCU: Codeunit BssiMEMSingleInstanceCU;
        BssiDimension: Text;
        BssiDimensionForRestriction: Text;

    procedure "#VatEntryIVA"()
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _recTaxJur: Record "Tax Jurisdiction";
    begin
        //++@r ARIBM.CPA-160613 @v 12198 @m 1
        EscribirFichero := true;
        NumeroLineas += 1;

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

        Campo1 := '267';

        //CUIT
        Proveedor.Reset;
        Proveedor.SetCurrentkey("No.");
        Proveedor.SetRange("No.", IVA."Bill-to/Pay-to No.");
        if Proveedor.FindFirst then
            Campo2 := Proveedor."VAT Registration No.";


        Campo2 := DelChr(Campo2, '=', '-');
        Campo2 := CopyStr(Campo2, 1, 2) + '-' + CopyStr(Campo2, 3, 8) + '-' + CopyStr(Campo2, 11, 1);


        //Fecha de percepcion
        Campo3 := Format(IVA."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //Numero Fac Parte 1 y 2

        Clear(Doc);
        //--@r ARIBMMFA-160630 @v 15128 @m 1
        Doc := IVA."External Document No.";

        //++@r ARIBM.GPA-160810 @v 15742 @m 3
        Doc := DelChr(Doc, '=', '-.');
        Doc := DelChr(Doc, '=', ',.-├â┬â├é┬»+{}├â┬â├é┬╣*[] ');
        if StrLen(Doc) >= 16 then
            Doc := CopyStr(Doc, 1, 16)
        else
            while StrLen(Doc) < 16 do
                Doc += '0' + Doc;
        //+Orig
        //Doc := DELCHR(Doc,'=','-.');
        //Doc := DELCHR(Doc,'=',',.-├â┬â├é┬»+{}├â┬â├é┬╣*[]');
        //IF STRLEN(Doc) >= 20 THEN
        //  Doc := COPYSTR(Doc, 1, 20)
        //ELSE BEGIN
        //  WHILE STRLEN(Doc) < 20 DO
        //    Doc += '0' + Doc;
        //END;
        //-Orig
        //--@r ARIBM.GPA-160810 @v 15742 @m 3
        Campo4 := Doc;
        //--@r ARIBM.CPA-160613 @v 14749 @m 1

        //Monto de percepcion
        while StrLen(Campo6) + StrLen(ConvertStr(DelChr(Format(ROUND(IVA.Amount, 0.01), 0,
        //++@r ARIBM.CPA-160613 @v 14749 @m 1
        //++@r ARIBM.GPA-160810 @v 15742 @m 3
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 16 do Campo6 += '0';
        //+Orig
        //  '<Precision,2:2><integer><decimals>'),'.','') ,',',',')) < 10 DO Campo6+= '0';
        //-Orig
        //--@r ARIBM.GPA-160810 @v 15742 @m 3
        begin
            Campo6 += ConvertStr(DelChr(Format(ROUND(IVA.Amount, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        end;
        //--@r ARIBM.CPA-160613 @v 12198 @m 1

        Clear(Texto);
        Texto := (
        Format(Campo1, 3, '<Text>') +
        Format(Campo2, 13, '<Text>') +
        Format(Campo3, 10, '<Text>') +
        //++@r ARIBM.GPA-160810 @v 15742 @m 3
        Format(Campo4, 16, '<Text>') +
        Format(Campo6, 16, '<Text>'));

        "#RellenaExcelBuff"(Texto);

    end;


    procedure "#VatEntryCordoba"()
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
        _recCustomer: Record Customer;
        _recTaxArea: Record "Tax Area";
        "Tax Detail": Record "Tax Detail";
    begin

        //++@r ARIBM.CPA-160613 @v 14397 @m 1
        EscribirFicheroCordoba := true;
        NumeroLineasCordoba += 1;

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

        //Identificador
        NumeroRenglonSircar += 1;
        Campo1 := Format(NumeroRenglonSircar);
        while StrLen(Campo1) < 5 do
            Campo1 := '0' + Campo1;

        //Tipo de comprobante
        case recCordobaTemp."Document Type" of
            recCordobaTemp."GMADocument Type Loc."::Invoice:
                Campo2 := '001';
            recCordobaTemp."GMADocument Type Loc."::"Credit Memo":
                Campo2 := '102';
            recCordobaTemp."GMADocument Type Loc."::"GMANota Debito":
                Campo2 := '002';
        end;

        //Letra comprobante
        _recTaxArea.Reset;
        _recTaxArea.SetRange(Code, recCordobaTemp."Tax Area Code");
        if _recTaxArea.FindFirst then
            //++@r ARIBM.SPR-200610 @v 29594 @m1
            //Campo3 := _recTaxArea."GMAInvoice Letter" old code
            Campo3 := UpperCase(_recTaxArea."GMAInvoice Letter")
        //++@r ARIBM.SPR-200610 @v 29594 @m1
        else
            Campo3 := 'Z';

        //Numero comprobante
        Campo4 := recCordobaTemp."Document No.";
        //++@r ARIBM.SPR-200610 @v 29594 @m1
        //++old code
        //Campo4 := DELCHR(recCordobaTemp."Document No.", '=', 'QWERTYUIOP├É*ASDFGHJKL┬Ñ[]ZXCVBNM;:_!"#$%&/()=?┬¡');
        //Campo4 := DELCHR(recCordobaTemp."Document No.", '=', 'qwertyuiop├û+asdfghjkl┬ñ{}zxcvbnm,.-\~');
        //--old code
        Campo4 := DelChr(Campo4, '=', DELDOCNUM);
        //--@r ARIBM.SPR-200610 @v 29594 @m1
        if StrLen(Campo4) > 12 then
            Campo4 := CopyStr(Campo4, 1, 12);

        while StrLen(Campo4) < 12 do
            Campo4 := '0' + Campo4;

        //CUIT contribuyente
        _recCustomer.Reset;
        _recCustomer.SetRange("No.", recCordobaTemp."Bill-to/Pay-to No.");
        if _recCustomer.FindFirst then;
        Campo5 := DelChr(_recCustomer."VAT Registration No.", '=', '-./');
        while StrLen(Campo5) < 11 do
            Campo5 := '0' + Campo5;

        //Fecha percep
        Campo6 := Format(recCordobaTemp."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //++@r ARIBM.SPR-200610 @v 29594 @m1
        "Tax Detail".Reset;
        "Tax Detail".SetRange("Tax Jurisdiction Code", recCordobaTemp."Tax Jurisdiction Code");
        "Tax Detail".SetRange("Tax Group Code", recCordobaTemp."Tax Group Code");
        if ("Tax Detail".FindFirst) then begin
            //Alicuota
            _Alicuota := "Tax Detail"."Tax Above Maximum";
            while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
              '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo8 += '0';
            begin
                Campo8 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
                '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.');
            end;
            if (Campo2 = '102') then begin
                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo9 := '-' + Campo9;
                //--@r ARIBM.SPR-200610 @v 29594 @m1
                //Monto sujeto a percepcion
                //++@r ARIBM.SPR-200610 @v 29594 @m1
                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(
                ROUND(ROUND(recCordobaTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(
                    ROUND(ROUND(recCordobaTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                    , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo7 := '-' + Campo7;
            end
            else begin
                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;

                //Monto sujeto a percepcion
                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(
                ROUND(ROUND(recCordobaTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(
                    ROUND(ROUND(recCordobaTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                    , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
            end;
        end
        else begin
            if (Campo2 = '102') then begin
                //Monto sujeto a percepcion
                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Base, 0.01), 0,
                      '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Base, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo7 := '-' + Campo7;
                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo9 := '-' + Campo9;
            end
            else begin
                //Monto sujeto a percepcion

                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Base, 0.01), 0,
              '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Base, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                    //--@r ARIBM.SPR-200610 @v 29594 @m1
                end;

                //++@r ARIBM.SPR-200610 @v 29594 @m1
                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
            end;
            //--@r ARIBM.SPR-200610 @v 29594 @m1
            //Alicuota
            //++@r ARIBM.SPR-200610 @v 29594 @m1
            if recCordobaTemp.Base <> 0 then
                _Alicuota := ROUND(((recCordobaTemp.Amount * 100) / recCordobaTemp.Base), 0.0001);
            while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
              '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo8 += '0';
            begin
                Campo8 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
                '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.');
            end;
            //--@r ARIBM.SPR-200610 @v 29594 @m1

        end;

        //Tipo regimen Percepcion
        Campo10 := '009';//OLD  '001'; //++@r ARIBM.SPR-200610 @v 29594 @m1

        //Jurisdiccion (Siempre cordoba)
        Campo11 := '904';
        //++@r ARIBM.SPR-200610 @v 29594 @m1
        if (Campo2 = '102') then begin
            //Tipo de operacion (siempre efectuada)
            Campo12 := '2';

            //Numero de constacia original (solo para 2-anulaciones)
            Campo13 := '00' + Campo4;

        end
        else begin
            //--@r ARIBM.SPR-200610 @v 29594 @m1
            //Tipo de operacion (siempre efectuada)
            Campo12 := '1';

            //Numero de constacia original (solo para 2-anulaciones)
            Campo13 := '00000000000000';


        end;//++@r ARIBM.SPR-200610 @v 29594 @m1
        Clear(TextoCordoba);
        TextoCordoba := (
        //++@r ARIBM.SPR-200610 @v 29594 @m1
        /*//old code
    FORMAT(Campo1,   5, '<Text>') +
    FORMAT(Campo2,   3, '<Text>') +
    FORMAT(Campo3,   1, '<Text>') +
    FORMAT(Campo4,  12, '<Text>') +
    FORMAT(Campo5,  11, '<Text>') +
    FORMAT(Campo6,  10, '<Text>') +
    FORMAT(Campo7,  12, '<Text>') +
    FORMAT(Campo8,   6, '<Text>') +
    FORMAT(Campo9,  12, '<Text>') +
    FORMAT(Campo10,  3, '<Text>') +
    FORMAT(Campo11, 13, '<Text>') +
    FORMAT(Campo12,  1, '<Text>') +
    FORMAT(Campo13, 14, '<Text>'));
        *///old code
        Format(Campo1, 5, '<Text>') + ',' +
        Format(Campo2, 3, '<Text>') + ',' +
        Format(Campo3, 1, '<Text>') + ',' +
        Format(Campo4, 12, '<Text>') + ',' +
        Format(Campo5, 11, '<Text>') + ',' +
        Format(Campo6, 10, '<Text>') + ',' +
        Format(Campo7, 12, '<Text>') + ',' +
        Format(Campo8, 6, '<Text>') + ',' +
        Format(Campo9, 12, '<Text>') + ',' +
        Format(Campo10, 3, '<Text>') + ',' +
        Format(Campo11, 3, '<Text>') + ',' +
        Format(Campo12, 1, '<Text>') + ',' +
        Format(Campo13, 14, '<Text>'));

        "#RellenaExcelBuffCordoba"(TextoCordoba);


    end;


    procedure "#VatEntryCordobaIIBB"(ParJurisdiccion: Code[3])
    var
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
        _recVendor: Record Vendor;
        _recTaxArea: Record "Tax Area";
    begin

        //++@r ARIBM.CPA-160613 @v 14397 @m 1
        EscribirFicheroCordobaIIBB := true;
        NumeroLineasCordobaIIBB += 1;

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

        //Identificador
        NumeroRenglonSircar += 1;
        Campo1 := Format(NumeroRenglonSircar);
        while StrLen(Campo1) < 5 do
            Campo1 := '0' + Campo1;

        //Origen del comprobante (1 software propio, 2 software de sistema sircar)
        Campo2 := '1';

        //Tipo de comprobante (1 comprobante retencion, 2 comprobante anulacion)
        Campo3 := '1';

        //Numero Comprobante
        Campo4 := recCordobaTempIIBB."GMAVoucher Number";
        //++@r ARIBM.SPR-200610 @v 29594 @m1
        //old code
        //Campo4 := DELCHR(Campo4, '=', 'QWERTYUIOP├É*ASDFGHJKL┬Ñ[]>ZXCVBNM;:_');
        //Campo4 := DELCHR(Campo4, '=', 'qwertyuiop├û+asdfghjkl┬ñ{}<zxcvbnm,.-');
        //old code
        Campo4 := DelChr(Campo4, '=', DELDOCNUM);
        //--@r ARIBM.SPR-200610 @v 29594 @m1
        while StrLen(Campo4) < 12 do
            Campo4 := '0' + Campo4;

        //CUIT
        _recVendor.Reset;
        _recVendor.SetRange("No.", recCordobaTempIIBB."GMAVendor Code");
        if _recVendor.FindFirst then;
        Campo5 := DelChr(_recVendor."VAT Registration No.", '=', '-./');
        while StrLen(Campo5) < 11 do
            Campo5 := '0' + Campo5;

        //Fecha de retencion
        Campo6 := Format(recCordobaTempIIBB."GMAWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //Monto sujeto retencion
        while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB.GMABase, 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo7 += '0';
        begin
            Campo7 += ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB.GMABase, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
        end;

        //Alicuota
        if recCordobaTempIIBB.GMABase <> 0 then
            _Alicuota := ROUND(((recCordobaTempIIBB."GMAWithholding Amount" * 100) / recCordobaTempIIBB.GMABase), 0.0001);
        while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
          '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo8 += '0';
        begin
            Campo8 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
            '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.');
        end;
        //--@r ARIBM.SPR-200610 @v 29594 @m1
        //Monto retenido
        while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB."GMAWithholding Amount", 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo9 += '0';
        begin
            Campo9 += ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB."GMAWithholding Amount", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
        end;

        //Tipo de regimen

        if (recCordobaTempIIBB."GMATax System" <> '') then
            Campo10 := recCordobaTempIIBB."GMATax System"
        else
            Campo10 := '001';

        //Jurisdiccion
        //++@r ARIBM.MAR-211110 @v 38867 @m 1
        //ORIG++
        //Campo11 := '904'; //Siempre Cordoba
        //ORIG--
        Campo11 := ParJurisdiccion; //Siempre Cordoba
                                    //if (ParJurisdiccion = '904') then begin
        if (DisSircar(ParJurisdiccion) = '2') then begin
            //--@r ARIBM.MAR-211110 @v 38867 @m 1
            //Tipo de operacion
            Campo12 := '1';

            //Fecha Emision de constancia
            Campo13 := Format(recCordobaTempIIBB."GMAWithholding Date", 10, '<Day,2>/<Month,2>/<Year4>');

            //Numero de Constancia
            Campo14 := recCordobaTempIIBB."GMAWithh. Certificate No.";

            Campo14 := DelChr(Campo14, '=', DELDOCNUM);
            //--@r ARIBM.SPR-200610 @v 29594 @m1
            while StrLen(Campo14) < 14 do
                Campo14 := '0' + Campo14;

            //Numero de Constancia Original (solo para anulaciones)
            Campo15 := '00000000000000';
            //++@r ARIBM.MAR-211110 @v 38867 @m 1
        end;

        if (DisSircar(ParJurisdiccion) = '2') then begin
            //--@r ARIBM.MAR-211214 @v 38867 @m 2
            Clear(TextoCordobaIIBB);
            TextoCordobaIIBB := (

            Format(Campo1, 5, '<Text>') + ',' +
            Format(Campo2, 1, '<Text>') + ',' +
            Format(Campo3, 1, '<Text>') + ',' +
            Format(Campo4, 12, '<Text>') + ',' +
            Format(Campo5, 11, '<Text>') + ',' +
            Format(Campo6, 10, '<Text>') + ',' +
            Format(Campo7, 12, '<Text>') + ',' +
            Format(Campo8, 6, '<Text>') + ',' +
            Format(Campo9, 12, '<Text>') + ',' +
            Format(Campo10, 3, '<Text>') + ',' +
            Format(Campo11, 3, '<Text>') + ',' +
            Format(Campo12, 1, '<Text>') + ',' +
            Format(Campo13, 10, '<Text>') + ',' +
            Format(Campo14, 14, '<Text>') + ',' +
            Format(Campo15, 14, '<Text>'));

        end
        else begin
            Clear(TextoCordobaIIBB);
            TextoCordobaIIBB := (
            Format(Campo1, 5, '<Text>') + ',' +
            Format(Campo2, 1, '<Text>') + ',' +
            Format(Campo3, 1, '<Text>') + ',' +
            Format(Campo4, 12, '<Text>') + ',' +
            Format(Campo5, 11, '<Text>') + ',' +
            Format(Campo6, 10, '<Text>') + ',' +
            Format(Campo7, 12, '<Text>') + ',' +
            Format(Campo8, 6, '<Text>') + ',' +
            Format(Campo9, 12, '<Text>') + ',' +
            Format(Campo10, 3, '<Text>') + ',' +
            Format(Campo11, 3, '<Text>'));
        end;

        "#RellenaExcelBuffCordobaIIBB"(TextoCordobaIIBB);


    end;


    procedure "#VatEntryMendozaIIBB"(ParJurisdiccion: Code[3])
    var
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
        _recVendor: Record Vendor;
        _recTaxArea: Record "Tax Area";
    begin
        //++@r ARIBM.MAR-211214 @v 38867 @m 2
        EscribirFicheroCordobaIIBB := true;
        NumeroLineasCordobaIIBB += 1;

        Clear(Campo5);
        Clear(Campo24);
        Clear(Campo4);
        Clear(Campo13);
        Clear(Campo6);
        Clear(Campo7);
        Clear(Campo8);
        Clear(Campo9);

        //CUIT
        _recVendor.Reset;
        _recVendor.SetRange("No.", recCordobaTempIIBB."GMAVendor Code");
        if _recVendor.FindFirst then
            Campo5 := DelChr(_recVendor."VAT Registration No.", '=', '-./ ');

        if (StrLen(Campo5) = 11) then
            Campo5 := CopyStr(Campo5, 1, 2) + '-' + CopyStr(Campo5, 3, 8) + '-' + CopyStr(Campo5, 11, 1)
        else begin
            while StrLen(Campo5) < 11 do
                Campo5 := '0' + Campo5;
            if (StrLen(Campo5) = 11) then
                Campo5 := CopyStr(Campo5, 1, 2) + '-' + CopyStr(Campo5, 3, 8) + '-' + CopyStr(Campo5, 11, 1);
        end;

        //Denominacion
        Campo24 := Format(_recVendor.Name);
        while StrLen(Campo24) < 80 do
            Campo24 := Campo24 + ' ';

        //Fecha Emision de constancia
        Campo13 := Format(recCordobaTempIIBB."GMAWithholding Date", 8, '<Day,2><Month,2><Year4>');

        //Numero Comprobante
        Campo4 := recCordobaTempIIBB."GMAVoucher Number";
        Campo4 := DelChr(Campo4, '=', DELDOCNUM);
        while StrLen(Campo4) < 12 do
            Campo4 := '0' + Campo4;

        //Fecha de retencion
        Campo6 := Format(recCordobaTempIIBB."GMAWithholding Date", 8, '<Day,2><Month,2><Year4>');

        //Monto sujeto retencion
        while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB.GMABase, 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo7 += '0';
        begin
            Campo7 += ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB.GMABase, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
        end;

        //Alicuota
        if recCordobaTempIIBB.GMABase <> 0 then
            _Alicuota := ROUND(((recCordobaTempIIBB."GMAWithholding Amount" * 100) / recCordobaTempIIBB.GMABase), 0.01);
        while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.01), 0,
          '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 4 do Campo8 += '0';
        begin
            Campo8 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.01), 0,
            '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.');
        end;
        //Monto retenido
        while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB."GMAWithholding Amount", 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo9 += '0';
        begin
            Campo9 += ConvertStr(DelChr(Format(ROUND(recCordobaTempIIBB."GMAWithholding Amount", 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
        end;

        Clear(TextoCordobaIIBB);
        TextoCordobaIIBB := (
        Format(Campo5, 13, '<Text>') +
        Format(Campo24, 80, '<Text>') +
        Format(Campo13, 8, '<Text>') +
        Format(Campo4, 12, '<Text>') +
        Format(Campo6, 8, '<Text>') +
        Format(Campo7, 15, '<Text>') +
        Format(Campo8, 5, '<Text>') +
        Format(Campo9, 15, '<Text>'));


        "#RellenaExcelBuffCordobaIIBB"(TextoCordobaIIBB);

    end;

    procedure "#VatEntrySantaFe"(ParJurisdiccion: Code[3])
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
        _recCustomer: Record Customer;
        _recTaxArea: Record "Tax Area";
        "Tax Detail": Record "Tax Detail";
    begin

        //++@r ARIBM.SPR-200610 @v 29594 @m1
        EscribirFicheroSantaFe := true;
        NumeroLineasSantaFe += 1;

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

        //Identificador
        NumeroRenglonSircar += 1;
        Campo1 := Format(NumeroRenglonSircar);
        while StrLen(Campo1) < 5 do
            Campo1 := '0' + Campo1;

        //Tipo de comprobante
        case recSantaFeTemp."Document Type" of
            recSantaFeTemp."GMADocument Type Loc."::Invoice:
                Campo2 := '001';
            recSantaFeTemp."GMADocument Type Loc."::"Credit Memo":
                Campo2 := '102';
            recSantaFeTemp."GMADocument Type Loc."::"GMANota Debito":
                Campo2 := '002';
        end;

        //Letra comprobante
        _recTaxArea.Reset;
        _recTaxArea.SetRange(Code, recSantaFeTemp."Tax Area Code");
        if _recTaxArea.FindFirst then
            Campo3 := UpperCase(_recTaxArea."GMAInvoice Letter")
        else
            Campo3 := 'Z';

        //Numero comprobante
        Campo4 := recSantaFeTemp."Document No.";
        Campo4 := DelChr(Campo4, '=', DELDOCNUM);
        if StrLen(Campo4) > 12 then
            Campo4 := CopyStr(Campo4, 1, 12);

        while StrLen(Campo4) < 12 do
            Campo4 := '0' + Campo4;

        //CUIT contribuyente
        _recCustomer.Reset;
        _recCustomer.SetRange("No.", recSantaFeTemp."Bill-to/Pay-to No.");
        if _recCustomer.FindFirst then;
        Campo5 := DelChr(_recCustomer."VAT Registration No.", '=', '-./');
        while StrLen(Campo5) < 11 do
            Campo5 := '0' + Campo5;

        //Fecha percep
        Campo6 := Format(recSantaFeTemp."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');


        "Tax Detail".Reset;
        "Tax Detail".SetRange("Tax Jurisdiction Code", recSantaFeTemp."Tax Jurisdiction Code");
        "Tax Detail".SetRange("Tax Group Code", recSantaFeTemp."Tax Group Code");
        if ("Tax Detail".FindFirst) then begin
            //Alicuota
            _Alicuota := "Tax Detail"."Tax Above Maximum";
            if (_Alicuota = 0) then
                _Alicuota := 1;

            while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
              '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo8 += '0';
            begin
                Campo8 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
                '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.');
            end;
            if (Campo2 = '102') then begin
                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo9 := '-' + Campo9;

                //Monto sujeto a percepcion
                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(
                ROUND(ROUND(recSantaFeTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(
                    ROUND(ROUND(recSantaFeTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                    , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo7 := '-' + Campo7;
            end
            else begin
                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;

                //Monto sujeto a percepcion
                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(
                ROUND(ROUND(recSantaFeTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(
                    ROUND(ROUND(recSantaFeTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                    , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;

            end;
        end
        else begin
            if (Campo2 = '102') then begin
                //Monto sujeto a percepcion
                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Base, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Base, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo7 := '-' + Campo7;
                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;
                Campo9 := '-' + Campo9;
            end
            else begin
                //Monto sujeto a percepcion
                while StrLen(Campo7) + StrLen(ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Base, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo7 += '0';
                begin
                    Campo7 += ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Base, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;

                //Monto percibido
                while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                  '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 12 do Campo9 += '0';
                begin
                    Campo9 += ConvertStr(DelChr(Format(ROUND(recSantaFeTemp.Amount, 0.01), 0,
                    '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
                end;

            end;
            //Alicuota
            if recSantaFeTemp.Base <> 0 then
                _Alicuota := ROUND(((recSantaFeTemp.Amount * 100) / recSantaFeTemp.Base), 0.0001);
            while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
              '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo8 += '0';
            begin
                Campo8 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
                '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.');
            end;


        end;


        //Tipo regimen Percepcion
        Campo10 := RegimenSircar(ParJurisdiccion);

        //Jurisdiccion
        Campo11 := ParJurisdiccion;

        if (Campo2 = '102') then begin
            //Tipo de operacion (siempre efectuada)
            Campo12 := '2';

            //Numero de constacia original (solo para 2-anulaciones)
            Campo13 := '00' + Campo4;

        end
        else begin
            //Tipo de operacion (siempre efectuada)

            Campo12 := '1';

            //Numero de constacia original (solo para 2-anulaciones)
            Campo13 := '00000000000000';

        end;
        if (DisSircar(ParJurisdiccion) = '1') then begin
            Clear(TextoSantaFe);
            TextoSantaFe := (
            Format(Campo1, 5, '<Text>') + ',' +
            Format(Campo2, 3, '<Text>') + ',' +
            Format(Campo3, 1, '<Text>') + ',' +
            Format(Campo4, 12, '<Text>') + ',' +
            Format(Campo5, 11, '<Text>') + ',' +
            Format(Campo6, 10, '<Text>') + ',' +
            Format(Campo7, 12, '<Text>') + ',' +
            Format(Campo8, 6, '<Text>') + ',' +
            Format(Campo9, 12, '<Text>') + ',' +
            Format(Campo10, 3, '<Text>') + ',' +
            Format(Campo11, 3, '<Text>'));
        end
        else begin
            Clear(TextoSantaFe);
            TextoSantaFe := (
            Format(Campo1, 5, '<Text>') + ',' +
            Format(Campo2, 3, '<Text>') + ',' +
            Format(Campo3, 1, '<Text>') + ',' +
            Format(Campo4, 12, '<Text>') + ',' +
            Format(Campo5, 11, '<Text>') + ',' +
            Format(Campo6, 10, '<Text>') + ',' +
            Format(Campo7, 12, '<Text>') + ',' +
            Format(Campo8, 6, '<Text>') + ',' +
            Format(Campo9, 12, '<Text>') + ',' +
            Format(Campo10, 3, '<Text>') + ',' +
            Format(Campo11, 3, '<Text>') + ',' +
            Format(Campo12, 1, '<Text>') + ',' +
            Format(Campo13, 14, '<Text>'));
        end;

        "#RellenaExcelBuffSantaFe"(TextoSantaFe);


    end;

    local procedure "#VatEntryEntreRios"(ParJurisdiccion: Code[3])
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
        _recCustomer: Record Customer;
        _recTaxArea: Record "Tax Area";
        "Tax Detail": Record "Tax Detail";
    begin


        EscribirFicheroEntreRios := true;
        NumeroLineasEntreRios += 1;

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

        //Tipo de agente
        Campo1 := '1';

        //Motivo de comprobante
        Campo2 := '061';


        //CUIT contribuyente
        _recCustomer.Reset;
        _recCustomer.SetRange("No.", recEntreRiosTemp."Bill-to/Pay-to No.");
        if _recCustomer.FindFirst then;
        Campo3 := DelChr(_recCustomer."VAT Registration No.", '=', '-./');
        while StrLen(Campo3) < 11 do
            Campo3 := '0' + Campo3;

        //Fecha percep
        Campo4 := Format(recEntreRiosTemp."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');




        //Tipo de comprobante
        case recEntreRiosTemp."Document Type" of
            recEntreRiosTemp."GMADocument Type Loc."::Invoice:
                Campo5 := 'F     ';
            recEntreRiosTemp."GMADocument Type Loc."::"Credit Memo":
                Campo5 := 'C     ';
            recEntreRiosTemp."GMADocument Type Loc."::"GMANota Debito":
                Campo5 := 'D     ';
        end;

        //Letra comprobante
        _recTaxArea.Reset;
        _recTaxArea.SetRange(Code, recEntreRiosTemp."Tax Area Code");
        if _recTaxArea.FindFirst then
            Campo6 := UpperCase(_recTaxArea."GMAInvoice Letter")
        else
            Campo6 := 'Z';

        //Numero comprobante
        Campo7 := recEntreRiosTemp."Document No.";
        Campo7 := DelChr(Campo7, '=', DELDOCNUM);
        if StrLen(Campo7) > 12 then
            Campo7 := CopyStr(Campo7, StrLen(Campo7) - 11, 12);

        while StrLen(Campo7) < 12 do
            Campo7 := '0' + Campo7;

        "Tax Detail".Reset;
        "Tax Detail".SetRange("Tax Jurisdiction Code", recEntreRiosTemp."Tax Jurisdiction Code");
        "Tax Detail".SetRange("Tax Group Code", recEntreRiosTemp."Tax Group Code");
        if ("Tax Detail".FindFirst) then begin
            //Alicuota
            _Alicuota := "Tax Detail"."Tax Above Maximum";
            if (_Alicuota = 0) then
                _Alicuota := 1;


            while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.01), 0,
              '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo9 += '0';
            begin
                Campo9 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
            end;

            //Monto percibido
            while StrLen(Campo10) + StrLen(ConvertStr(DelChr(Format(ROUND(recEntreRiosTemp.Amount, 0.01), 0,
              '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo10 += '0';
            begin
                Campo10 += ConvertStr(DelChr(Format(ROUND(recEntreRiosTemp.Amount, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
            end;

            //Monto sujeto a percepcion
            while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(
            ROUND(ROUND(recEntreRiosTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
            , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo8 += '0';
            begin
                Campo8 += ConvertStr(DelChr(Format(
                ROUND(ROUND(recEntreRiosTemp.Amount * 100, 0.01) / _Alicuota, 0.01)
                , 0, '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
            end;
        end
        else begin
            //Monto sujeto a percepcion
            while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(recEntreRiosTemp.Base, 0.01), 0,
              '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo8 += '0';
            begin
                Campo8 += ConvertStr(DelChr(Format(ROUND(recEntreRiosTemp.Base, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
            end;

            //Alicuota
            if recEntreRiosTemp.Base <> 0 then
                _Alicuota := ROUND(((recEntreRiosTemp.Amount * 100) / recEntreRiosTemp.Base), 0.01);
            while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.01), 0,
              '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo9 += '0';
            begin
                Campo9 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
            end;

            //Monto percibido
            while StrLen(Campo10) + StrLen(ConvertStr(DelChr(Format(ROUND(recEntreRiosTemp.Amount, 0.01), 0,
              '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo10 += '0';
            begin
                Campo10 += ConvertStr(DelChr(Format(ROUND(recEntreRiosTemp.Amount, 0.01), 0,
                '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
            end;

        end;


        //Tipo regimen Percepcion
        case recEntreRiosTemp."Document Type" of
            recEntreRiosTemp."GMADocument Type Loc."::Invoice:
                Campo11 := '0';
            recEntreRiosTemp."GMADocument Type Loc."::"Credit Memo":
                Campo11 := '1';
            recEntreRiosTemp."GMADocument Type Loc."::"GMANota Debito":
                Campo11 := '0';
        end;

        //Tipo de operacion (siempre efectuada)
        Campo12 := '0';

        Clear(TextoEntreRios);
        TextoEntreRios := (
        Format(Campo1, 1, '<Text>') +
        Format(Campo2, 3, '<Text>') +
        Format(Campo3, 11, '<Text>') +
        Format(Campo4, 10, '<Text>') +
        Format(Campo5, 6, '<Text>') +
        Format(Campo6, 1, '<Text>') +
        Format(Campo7, 12, '<Text>') +
        Format(Campo8, 15, '<Text>') +
        Format(Campo9, 6, '<Text>') +
        Format(Campo10, 15, '<Text>') +
        Format(Campo11, 1, '<Text>') +
        Format(Campo12, 1, '<Text>'));


        "#RellenaExcelBuffEntreRios"(TextoEntreRios);

    end;


    procedure "#VatEntryTucuman"()
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
        _recCustomer: Record Customer;
        _TipoDoc: Text[2];
        _Documento: Text[11];
        _Nombre: Text[40];
        _Domicilio: Text[40];
        _No: Text[5];
        _Localidad: Text[15];
        _Provincia: Text[15];
        _Ningbru: Text[11];
        _CPostal: Text[8];
        _recProvince: Record GMAProvince;
        _recVendor: Record Vendor;
        _recSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        _Campo3Aux: Text[30];
        _recDetCustLedEntry: Record "Detailed Cust. Ledg. Entry";
        _recDetCustLedEntry2: Record "Detailed Cust. Ledg. Entry";
        _recDetCustLedEntry3: Record "Detailed Cust. Ledg. Entry";
    begin


        EscribirFichero := true;
        NumeroLineasTucuman += 1;
        NumeroLineasTucuman2 += 1;

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

        //Fecha
        Campo1 := Format(recTucumanTemp."Posting Date", 8, '<Year4><Month,2><Day,2>');

        //Documento
        //++@r ARIBM.CPA-160613 @v 14397 @m 1
        if recTucumanTemp.Type = recTucumanTemp.Type::Purchase then begin
            _recVendor.Reset;
            _recVendor.SetRange("No.", recTucumanTemp."Bill-to/Pay-to No.");
            if _recVendor.FindFirst then begin
                //Tipo Doc
                if (_recVendor."GMAAFIP Document Type" <> '') then
                    Campo2 := _recVendor."GMAAFIP Document Type"
                else
                    Campo2 := '80';
                //Documento
                Campo3 := DelChr(_recVendor."VAT Registration No.", '=', '-_ ');
                while StrLen(Campo3) < 11 do
                    Campo3 := '0' + Campo3;
            end;
        end;
        if recTucumanTemp.Type = recTucumanTemp.Type::Sale then begin
            _recCustomer.Reset;
            _recCustomer.SetRange("No.", recTucumanTemp."Bill-to/Pay-to No.");
            if _recCustomer.FindFirst then begin
                //Tipo Doc
                if (_recCustomer."GMAAFIP Document Type" <> '') then
                    Campo2 := _recCustomer."GMAAFIP Document Type"
                else
                    Campo2 := '80';
                //Documento
                Campo3 := DelChr(_recCustomer."VAT Registration No.", '=', '-_ ');
                while StrLen(Campo3) < 11 do
                    Campo3 := '0' + Campo3;
            end;
        end;


        //Tipo Comp

        if (recTucumanTemp."GMAPoint of Sales" <> '') then
            Campo4 := CopyStr(recTucumanTemp."GMAPoint of Sales", 1, 2);

        //Letra
        case recTucumanTemp."GMAPoint of Sales" of
            '01', '02', '03':
                Campo5 := 'A';
            '06', '07', '08':
                Campo5 := 'B';
        end;

        //Numero

        if recTucumanTemp.Type = recTucumanTemp.Type::Sale then begin

            Campo7 := DelChr(recTucumanTemp."Document No.", '=', DELDOCNUM);

            if (StrLen(Campo7) > 8) then begin
                //Terminal
                Campo6 := CopyStr(Campo7, 1, 4);

                while StrLen(Campo6) < 4 do
                    Campo6 := '0' + Campo6;

                Campo7 := CopyStr(Campo7, (StrLen(Campo7) - 7), 8);
            end
            else begin
                //Terminal
                Campo6 := CopyStr(Campo7, 1, 4);
                while StrLen(Campo6) < 4 do
                    Campo6 := '0' + Campo6;

                while StrLen(Campo7) < 8 do
                    Campo7 := '0' + Campo7;

            end;
        end
        else begin
            //++@r ARIBM.SPR-200610 @v 29594 @m1
            //old code
            //Campo7 := DELCHR(recTucumanTemp."External Document No.", '=', ' QWERTYUIOP├û+}{┬ÑLKJHGFDSA<ZXCVBNM,.-');
            //old code
            Campo7 := DelChr(recTucumanTemp."External Document No.", '=', DELDOCNUM);
            //--@r ARIBM.SPR-200610 @v 29594 @m1
            if (StrLen(Campo7) > 8) then begin
                //Terminal
                Campo6 := CopyStr(Campo7, 1, 4);
                while StrLen(Campo6) < 4 do
                    Campo6 := '0' + Campo6;

                Campo7 := CopyStr(Campo7, (StrLen(Campo7) - 7), 8);
            end
            else begin
                //Terminal
                Campo6 := CopyStr(Campo7, 1, 4);
                while StrLen(Campo6) < 4 do
                    Campo6 := '0' + Campo6;

                while StrLen(Campo7) < 8 do
                    Campo7 := '0' + Campo7;
            end;
        end;
        //--@r ARIBM.CPA-160613 @v 14397 @m 1

        //Monto Imp
        while StrLen(Campo8) + StrLen(ConvertStr(DelChr(Format(ROUND(recTucumanTemp.Base, 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo8 += '0';  //dds14397 se cambio la coma por punto
        begin
            Campo8 += ConvertStr(DelChr(Format(ROUND(recTucumanTemp.Base, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');//dds14397 se cambio la coma por punto
        end;

        //Alicuota
        if recTucumanTemp.Base <> 0 then
            _Alicuota := ROUND(((recTucumanTemp.Amount * 100) / recTucumanTemp.Base), 0.0001);
        while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
          '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 6 do Campo9 += '0'; //dds14397 se cambio la coma por punto
        begin
            Campo9 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
            '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.'); //dds14397 se cambio la coma por punto
        end;

        //importe percep
        while StrLen(Campo10) + StrLen(ConvertStr(DelChr(Format(ROUND(recTucumanTemp.Amount, 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 15 do Campo10 += '0';//dds14397 se cambio la coma por punto
        begin
            Campo10 += ConvertStr(DelChr(Format(ROUND(recTucumanTemp.Amount, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');//dds14397 se cambio la coma por punto
        end;
        //NINGBRU
        Campo11 := '00000000000';

        //RELAFACT_N_C
        Campo12 := '000000000000';

        Clear(TextoTucuman);
        TextoTucuman := (
        Format(Campo1, 8, '<Text>') +
        Format(Campo2, 2, '<Text>') +
        Format(Campo3, 11, '<Text>') +
        Format(Campo4, 2, '<Text>') +
        Format(Campo5, 1, '<Text>') +
        Format(Campo6, 4, '<Text>') +
        Format(Campo7, 8, '<Text>') +
        Format(Campo8, 15, '<Text>') +
        Format(Campo9, 6, '<Text>') +
        Format(Campo10, 15, '<Text>'));

        "#RellenaExcelBuffTucuman"(TextoTucuman);

        Clear(_TipoDoc);
        Clear(_Documento);
        Clear(_Nombre);
        Clear(_Domicilio);
        Clear(_No);
        Clear(_Localidad);
        Clear(_Provincia);
        Clear(_Ningbru);
        Clear(_CPostal);

        //++@r ARIBM.CPA-160613 @v 14397 @m 1
        if recTucumanTemp.Type = recTucumanTemp.Type::Sale then begin
            _recCustomer.Reset;
            _recCustomer.SetRange("No.", recTucumanTemp."Bill-to/Pay-to No.");
            if _recCustomer.FindFirst then begin
                //++@r ARIBM.CPA-160613 @v 14397 @m 1
                if (_recCustomer."GMAAFIP Document Type" <> '') then
                    _TipoDoc := _recCustomer."GMAAFIP Document Type"
                else
                    _TipoDoc := '80';
                //--@r ARIBM.CPA-160613 @v 14397 @m 1
                _Documento := DelChr(_recCustomer."VAT Registration No.", '=', '-_ ');
                while StrLen(_Documento) < 11 do
                    _Documento := '0' + _Documento;

                _Nombre := CopyStr(_recCustomer.Name, 1, 40);
                while StrLen(_Nombre) < 40 do
                    _Nombre := _Nombre + ' ';

                _Domicilio := CopyStr(_recCustomer.Address, 1, 40);
                while StrLen(_Domicilio) < 40 do
                    _Domicilio := _Domicilio + ' ';

                _No := '00000';
                //++@r ARIBM.MJI-160808 @v 15738 @m 1
                //++@r W1EXCE.BJ.160804 @v 15738 @m 1
                //ORG+
                //_Localidad := _recCustomer.City;
                //ORG-
                _Localidad := CopyStr(_recCustomer.City, 1, 15);
                //--@r W1EXCE.BJ.160804 @v 15738 @m 1
                //--@r ARIBM.MJI-160808 @v 15738 @m 1
                while StrLen(_Localidad) < 15 do
                    _Localidad := _Localidad + ' ';

                _recProvince.Reset;
                _recProvince.SetRange("GMAProvince Code", _recCustomer."GMAProvince Code");
                if _recProvince.FindFirst then;
                _Provincia := CopyStr(_recProvince.GMADescription, 1, 15);
                while StrLen(_Provincia) < 15 do
                    _Provincia := _Provincia + ' ';

                _Ningbru := '           ';

                _CPostal := _recCustomer."Post Code";
                while StrLen(_CPostal) < 8 do
                    _CPostal := ' ' + _CPostal;
            end;
        end else begin
            _recVendor.Reset;
            _recVendor.SetRange("No.", recTucumanTemp."Bill-to/Pay-to No.");
            if _recVendor.FindFirst then begin
                //++@r ARIBM.CPA-160613 @v 14397 @m 1
                if (_recCustomer."GMAAFIP Document Type" <> '') then
                    _TipoDoc := _recCustomer."GMAAFIP Document Type"
                else
                    _TipoDoc := '80';
                //--@r ARIBM.CPA-160613 @v 14397 @m 1

                _Documento := DelChr(_recVendor."VAT Registration No.", '=', '-_ ');
                while StrLen(_Documento) < 11 do
                    _Documento := '0' + _Documento;

                _Nombre := CopyStr(_recVendor.Name, 1, 40);
                while StrLen(_Nombre) < 40 do
                    _Nombre := _Nombre + ' ';

                _Domicilio := CopyStr(_recVendor.Address, 1, 40);
                while StrLen(_Domicilio) < 40 do
                    _Domicilio := _Domicilio + ' ';

                _No := '00000';

                //++@r ARIBM.MJI-160340069 @v 15738 @m 2
                //ORG+
                //_Localidad := _recVendor.City;
                _Localidad := CopyStr(_recVendor.City, 1, 15);
                //ORG-
                //--@r ARIBM.MJI-160809 @v 15738 @m 2
                while StrLen(_Localidad) < 15 do
                    _Localidad := _Localidad + ' ';

                _recProvince.Reset;
                _recProvince.SetRange("GMAProvince Code", _recVendor."GMAProvince Code");
                if _recProvince.FindFirst then;
                _Provincia := CopyStr(_recProvince.GMADescription, 1, 15);
                while StrLen(_Provincia) < 15 do
                    _Provincia := _Provincia + ' ';

                _Ningbru := '           ';

                _CPostal := _recVendor."Post Code";
                while StrLen(_CPostal) < 8 do
                    _CPostal := ' ' + _CPostal;
            end;
        end;
        //--@r ARIBM.CPA-160613 @v 14397 @m 1

        Clear(TextoTucuman2);
        TextoTucuman2 := (
          Format(_TipoDoc, 2, '<Text>') +
          Format(_Documento, 11, '<Text>') +
          Format(_Nombre, 40, '<Text>') +
          Format(_Domicilio, 40, '<Text>') +
          Format(_No, 5, '<Text>') +
          Format(_Localidad, 15, '<Text>') +
          Format(_Provincia, 15, '<Text>') +
          Format(_Ningbru, 11, '<Text>') +
          Format(_CPostal, 8, '<Text>')
        );


        "#RellenaExcelBuffTucuman2"(TextoTucuman2);


        if (recTucumanTemp."Document Type" = recTucumanTemp."document type"::"Credit Memo") and
           (recTucumanTemp.Type = recTucumanTemp.Type::Sale) then begin
            _recSalesCrMemoHeader.Reset;
            _recSalesCrMemoHeader.SetRange("No.", recTucumanTemp."Document No.");
            //_recSalesCrMemoHeader.SETRANGE("Applies-to Doc. Type", _recSalesCrMemoHeader."Applies-to Doc. Type"::Invoice);//dds14397
            if _recSalesCrMemoHeader.FindFirst then begin
                recSalesCrMemoHeaderTemp.Init;
                recSalesCrMemoHeaderTemp.TransferFields(_recSalesCrMemoHeader);
                recSalesCrMemoHeaderTemp."Applies-to Doc. No." := "#FindDocument"(_recSalesCrMemoHeader."No.");
                recSalesCrMemoHeaderTemp.Insert(false);
            end;
            /*//++@r ARIBM.CPA-160613 @v 14397 @m 1
          //++@r ARIBM.CPA-160613 @v 14397 @m 1
            _recDetCustLedEntry.RESET;
            _recDetCustLedEntry.SETRANGE("Document Type", _recDetCustLedEntry."Document Type"::"Credit Memo");
            _recDetCustLedEntry.SETRANGE("Document No.", recTucumanTemp."Document No.");
            IF _recDetCustLedEntry.FINDFIRST THEN BEGIN
              _recDetCustLedEntry2.RESET;
              _recDetCustLedEntry2.SETRANGE("Entry Type", _recDetCustLedEntry2."Entry Type"::Application);
              _recDetCustLedEntry2.SETRANGE("Cust. Ledger Entry No.", _recDetCustLedEntry."Cust. Ledger Entry No.");
              IF _recDetCustLedEntry2.FINDFIRST THEN BEGIN
                _recDetCustLedEntry3.RESET;
                _recDetCustLedEntry3.SETRANGE("Entry Type", _recDetCustLedEntry3."Entry Type"::Application);
                _recDetCustLedEntry3.SETRANGE("Cust. Ledger Entry No.", _recDetCustLedEntry2."Applied Cust. Ledger Entry No.");
                IF _recDetCustLedEntry3.FINDFIRST THEN BEGIN
                  _recSalesCrMemoHeader.RESET;
                  _recSalesCrMemoHeader.SETRANGE("No.", recTucumanTemp."Document No.");
                  IF _recSalesCrMemoHeader.FINDFIRST THEN BEGIN
                    recSalesCrMemoHeaderTemp.INIT;
                    recSalesCrMemoHeaderTemp.TRANSFERFIELDS(_recSalesCrMemoHeader);
                    recSalesCrMemoHeaderTemp."Applies-to Doc. Type" := recSalesCrMemoHeaderTemp."Applies-to Doc. Type"::Invoice;
                    recSalesCrMemoHeaderTemp."Applies-to Doc. No."  := _recDetCustLedEntry3."Document No.";
                    recSalesCrMemoHeaderTemp.INSERT(FALSE);
                  END;
                END;
              END;
            END;
          //--@r ARIBM.CPA-160613 @v 14397 @m 1
            *///--@r ARIBM.CPA-160613 @v 14397 @m 1
        end;
        //--@r ARIBM.CPA-160613 @v 14202 @m 1

    end;


    procedure "#VatEntryMisiones"()
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
    begin


        EscribirFichero := true;
        NumeroLineasMisiones += 1;

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

        //Fecha
        Campo1 := Format(recMisionesTemp."Posting Date", 10, '<Day,2>-<Month,2>-<Year4>');

        Campo2 := TipoComprobante;

        Campo3 := DelChr(recMisionesTemp."Document No.", '=', DELDOCNUM);

        Campo3 := DelChr(Campo3, '=', DELDOCNUM);

        if StrLen(Campo3) < 6 then begin
            while StrLen(Campo3) < 6 do
                Campo3 := '0' + Campo3;
        end;

        //Razon Social
        Campo4 := Nombre_RazSoc;

        //CUIT
        recVendor2.Reset;
        recVendor2.SetRange("No.", recMisionesTemp."Bill-to/Pay-to No.");
        if recVendor2.FindFirst then
            Campo5 := recVendor2."VAT Registration No.";

        // RecCustomer.Reset;
        // RecCustomer.SetRange("No.", recMisionesTemp."Bill-to/Pay-to No.");
        // if RecCustomer.FindFirst then
        //     Campo5 := RecCustomer."VAT Registration No.";

        Campo5 := DelChr(Campo5, '=', '-');
        Campo5 := CopyStr(Campo5, 1, 2) + '-' + CopyStr(Campo5, 3, 8) + '-' + CopyStr(Campo5, 11, 1);

        //Monto Imp
        begin
            Campo6 += ConvertStr(DelChr(Format(ROUND(recMisionesTemp.Base, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');
        end;


        //Alicuota
        if recMisionesTemp.Base <> 0 then begin
            _Alicuota := ROUND(((recMisionesTemp.Amount * 100) / recMisionesTemp.Base), 0.0001);
            Campo7 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
            '<Precision,1:1><integer><decimals>'), '.', ''), ',', '.');
        end else begin
            _Alicuota := ROUND(((recMisionesTemp.Amount * 100) / 1), 0.0001);
            Campo7 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
            '<Precision,1:1><integer><decimals>'), '.', ''), ',', '.');
        end;

        Clear(TextoMisiones);
        TextoMisiones := (
          Campo1 + ',' +
          Campo2 + ',' +
          Campo3 + ',' +
          Campo4 + ',' +
          Campo5 + ',' +
          Campo6 + ',' +
          Campo7);


        "#RellenaExcelBuffMisiones"(TextoMisiones);


    end;


    procedure "#VatEntryIIBB"()
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _recTaxJur: Record "Tax Jurisdiction";
    begin
        //++@r ARIBM.CPA-160613 @v 12083 @m 1
        EscribirFicheroIIBB := true;
        NumeroLineasIIBB += 1;

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

        //Codigo Regimen Percepcion
        //++@r ARIBM.CPA-160613 @v 12896 @m 1
        _recTaxJur.Reset;
        _recTaxJur.SetRange(Code, IIBB."Tax Jurisdiction Code");
        if _recTaxJur.FindFirst then begin //++@r ARIBM.CPA-160613 @v 14749 @m 1-
            if (_recTaxJur."GMAProvince Code" = '') then
                Error(Text005, IIBB."Tax Jurisdiction Code")
            else
                Campo1 := _recTaxJur."GMAProvince Code"
        end
        else
            Error(Text005, IIBB."Tax Jurisdiction Code");
        //--@r ARIBM.CPA-160613 @v 14749 @m 1
        //--@r ARIBM.CPA-160613 @v 12896 @m 1

        //CUIT
        Proveedor.Reset;
        Proveedor.SetCurrentkey("No.");
        Proveedor.SetRange("No.", IIBB."Bill-to/Pay-to No.");
        if Proveedor.FindFirst then
            Campo2 := Proveedor."VAT Registration No.";

        //Fecha de percepcion
        Campo3 := Format(IIBB."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //++@r ARIBM.CPA-160613 @v 12198 @m 1
        //Numero Fac Parte 1 y 2
        //++@r ARIBM.CPA-160613 @v 14749 @m 1
        Doc := IIBB."External Document No.";
        Doc := DelChr(Doc, '=', '-.');
        Doc := DelChr(Doc, '=', ',.-├â┬â├é┬»+{}├â┬â├é┬╣*[]');
        if StrLen(Doc) >= 20 then
            Doc := CopyStr(Doc, 1, 20)
        else begin
            while StrLen(Doc) < 20 do
                Doc += '0' + Doc;
        end;
        Campo4 := Doc;
        //--@r ARIBM.CPA-160613 @v 14749 @m 1

        //Monto de percepcion
        while StrLen(Campo6) + StrLen(ConvertStr(DelChr(Format(ROUND(IIBB.Amount, 0.01), 0,
        //++@r ARIBM.CPA-160613 @v 14749 @m 1
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',')) < 10 do Campo6 += '0';
        //--@r ARIBM.CPA-160613 @v 14749 @m 1
        begin
            Campo6 += ConvertStr(DelChr(Format(ROUND(IIBB.Amount, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', ',');
        end;
        //--@r ARIBM.CPA-160613 @v 12198 @m 1

        Clear(TextoIIBB);
        TextoIIBB := (
        Format(Campo1, 3, '<Text>') +
        Format(Campo2, 13, '<Text>') +
        Format(Campo3, 10, '<Text>') +
        //++@r ARIBM.CPA-160613 @v 14749 @m 1
        Format(Campo4, 20, '<Text>') +
        Format(Campo6, 10, '<Text>'));
        //--@r ARIBM.CPA-160613 @v 14749 @m 1

        "#RellenaExcelBuffIIBB"(TextoIIBB);

    end;


    procedure "#RellenaExcelBuff"(pTexto: Text[1024])
    begin
        //++@r ARIBM.CPA-160613 @v 12083 @m 1
        TempExcelBuff.Init;
        TempExcelBuff."Row No." := NumeroLineas;
        TempExcelBuff."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuff.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuff.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuff.Insert;
        //--@r ARIBM.CPA-160613 @v 12083 @m 1
    end;


    procedure "#RellenaExcelBuffCordoba"(pTexto: Text[1024])
    begin
        //++@r ARIBM.CPA-160613 @v 12083 @m 1
        TempExcelBuffCordoba.Init;
        TempExcelBuffCordoba."Row No." := NumeroLineasCordoba;
        TempExcelBuffCordoba."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffCordoba.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffCordoba.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffCordoba.Insert;
        //--@r ARIBM.CPA-160613 @v 12083 @m 1
    end;


    procedure "#RellenaExcelBuffCordobaIIBB"(pTexto: Text[1024])
    begin
        //++@r ARIBM.CPA-160613 @v 14397 @m 1
        TempExcelBuffCordobaIIBB.Init;
        TempExcelBuffCordobaIIBB."Row No." := NumeroLineasCordobaIIBB;
        TempExcelBuffCordobaIIBB."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffCordobaIIBB.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffCordobaIIBB.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffCordobaIIBB.Insert;
        //--@r ARIBM.CPA-160613 @v 14397 @m 1
    end;


    procedure "#RellenaExcelBuffSantaFe"(pTexto: Text[1024])
    begin
        //++@r ARIBM.CPA-160613 @v 12083 @m 1
        TempExcelBuffSantaFe.Init;
        TempExcelBuffSantaFe."Row No." := NumeroLineasSantaFe;
        TempExcelBuffSantaFe."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffSantaFe.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffSantaFe.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffSantaFe.Insert;
        //--@r ARIBM.CPA-160613 @v 12083 @m 1
    end;

    local procedure "#RellenaExcelBuffEntreRios"(pTexto: Text[1024])
    begin
        //++@r ARIBM.CPA-160613 @v 29594 @m 1
        TempExcelBuffEntreRios.Init;
        TempExcelBuffEntreRios."Row No." := NumeroLineasEntreRios;
        TempExcelBuffEntreRios."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffEntreRios.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffEntreRios.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffEntreRios.Insert;
        //--@r ARIBM.CPA-160613 @v 29594 @m 1
    end;


    procedure "#RellenaExcelBuffTucuman"(pTexto: Text[1024])
    begin
        //++@r ARIBM.CPA-160613 @v 12083 @m 1
        TempExcelBuffTucuman.Init;
        TempExcelBuffTucuman."Row No." := NumeroLineasTucuman;
        TempExcelBuffTucuman."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffTucuman.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffTucuman.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffTucuman.Insert;
        //--@r ARIBM.CPA-160613 @v 12083 @m 1
    end;


    procedure "#RellenaExcelBuffMisiones"(pTexto: Text[1024])
    begin

        TempExcelBuffMisiones.Init;
        TempExcelBuffMisiones."Row No." := NumeroLineasMisiones;
        TempExcelBuffMisiones."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffMisiones.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffMisiones.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffMisiones.Insert;

    end;


    procedure "#RellenaExcelBuffIIBB"(pTexto: Text[1024])
    begin
        //++@r ARIBM.CPA-160613 @v 12083 @m 1
        TempExcelBuffIIBB.Init;
        TempExcelBuffIIBB."Row No." := NumeroLineasIIBB;
        TempExcelBuffIIBB."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffIIBB.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffIIBB.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffIIBB.Insert;
        //--@r ARIBM.CPA-160613 @v 12083 @m 1
    end;


    procedure "#InsertVATEntryCordobaTemp"()
    begin
        //++@r ARIBM.CPA-160613 @v 14202 @m 1
        recCordobaTemp.Reset;
        recCordobaTemp.SetRange("Document Type", Cordoba."Document Type");
        recCordobaTemp.SetRange("Document No.", Cordoba."Document No.");
        if not recCordobaTemp.FindFirst then begin
            recCordobaTemp.Init;
            recCordobaTemp.TransferFields(Cordoba);
            recCordobaTemp.Insert(false);
        end else begin
            recCordobaTemp.Base += Cordoba.Base;
            recCordobaTemp.Amount += Cordoba.Amount;
            recCordobaTemp.Modify(false);
        end;
        //--@r ARIBM.CPA-160613 @v 14202 @m 1
    end;


    procedure "#InsertVATEntrySantaFeTemp"()
    begin
        //++@r ARIBM.CPA-160613 @v 14202 @m 1
        recSantaFeTemp.Reset;
        recSantaFeTemp.SetRange("Document Type", SantaFe."Document Type");
        recSantaFeTemp.SetRange("Document No.", SantaFe."Document No.");
        if not recSantaFeTemp.FindFirst then begin
            recSantaFeTemp.Init;
            recSantaFeTemp.TransferFields(SantaFe);
            recSantaFeTemp.Insert(false);
        end else begin
            recSantaFeTemp.Base += SantaFe.Base;
            recSantaFeTemp.Amount += SantaFe.Amount;
            recSantaFeTemp.Modify(false);
        end;
        //--@r ARIBM.CPA-160613 @v 14202 @m 1
    end;

    local procedure "#InsertVATEntryEntreRiosTemp"()
    begin

        //++@r ARIBM.SPR-070520 @v 29594 @m 1
        recEntreRiosTemp.Reset;
        recEntreRiosTemp.SetRange("Document Type", SantaFe."Document Type");
        recEntreRiosTemp.SetRange("Document No.", SantaFe."Document No.");
        if not recEntreRiosTemp.FindFirst then begin
            recEntreRiosTemp.Init;
            recEntreRiosTemp.TransferFields(SantaFe);
            recEntreRiosTemp.Insert(false);
        end else begin
            recEntreRiosTemp.Base += SantaFe.Base;
            recEntreRiosTemp.Amount += SantaFe.Amount;
            recEntreRiosTemp.Modify(false);
        end;
        //--@r ARIBM.SPR-070520 @v 29594 @m 1
    end;


    procedure "#InsertVATEntryTucumanTemp"()
    var
        lrecTucumanTemp: Record "VAT Entry";
    begin
        //++@r ARIBM.GPA-160810 @v 15738 @m 3
        lrecTucumanTemp.Reset;
        lrecTucumanTemp.SetCurrentkey("Document No.", "Document Type", "Gen. Prod. Posting Group", "VAT Prod. Posting Group", Type);
        lrecTucumanTemp.SetRange("Document No.", Tucuman."Document No.");
        lrecTucumanTemp.SetRange("Document Type", Tucuman."Document Type");
        lrecTucumanTemp.CalcSums(Amount);
        if lrecTucumanTemp.Amount = 0 then
            exit;
        //--@r ARIBM.GPA-160810 @v 15738 @m 3

        //++@r ARIBM.CPA-160613 @v 14202 @m 1
        recTucumanTemp.Reset;
        recTucumanTemp.SetRange("Document Type", Tucuman."Document Type");
        recTucumanTemp.SetRange("Document No.", Tucuman."Document No.");
        if not recTucumanTemp.FindFirst then begin
            recTucumanTemp.Init;
            recTucumanTemp.TransferFields(Tucuman);
            recTucumanTemp."GMAPoint of Sales" := TipoComprobante;//dds14397 Se completo ese campo para saber que factura es
            recTucumanTemp.Insert(false);
        end else begin
            recTucumanTemp.Base += Tucuman.Base;
            recTucumanTemp.Amount += Tucuman.Amount;
            recTucumanTemp.Modify(false);
        end;
        //--@r ARIBM.CPA-160613 @v 14202 @m 1
    end;


    procedure "#InsertVATEntryMisionesTemp"()
    begin
        //++@r ARIBM.CPA-160613 @v 14202 @m 1
        recMisionesTemp.Reset;
        recMisionesTemp.SetRange("Document Type", Misiones."Document Type");
        recMisionesTemp.SetRange("Document No.", Misiones."Document No.");
        if not recMisionesTemp.FindFirst then begin
            recMisionesTemp.Init;
            recMisionesTemp.TransferFields(Misiones);
            recMisionesTemp.Insert(false);
        end else begin
            recMisionesTemp.Base += Misiones.Base;
            recMisionesTemp.Amount += Misiones.Amount;
            recMisionesTemp.Modify(false);
        end;
        //--@r ARIBM.CPA-160613 @v 14202 @m 1
    end;



    procedure "#RellenaExcelBuffTucuman2"(pTexto: Text[1024])
    begin

        TempExcelBuffTucuman2.Init;
        TempExcelBuffTucuman2."Row No." := NumeroLineasTucuman2;
        TempExcelBuffTucuman2."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffTucuman2.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffTucuman2.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffTucuman2.Insert;

    end;


    procedure "#RellenaExcelBuffTucuman3"(pTexto: Text[1024])
    begin

        TempExcelBuffTucuman3.Init;
        TempExcelBuffTucuman3."Row No." := NumeroLineasTucuman3;
        TempExcelBuffTucuman3."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffTucuman3.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffTucuman3.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffTucuman3.Insert;

    end;


    procedure "#Provincia"(Jurisdiccion: Code[20]; VATProdPostGroup: Code[20]) ReturnValue: Code[20]
    var
        LocTaxJurisdiction: Record "Tax Jurisdiction";
        LocVatProdPostingGroup: Record "VAT Product Posting Group";
        Text006: label 'Debe Configurar la provincia en Grupo Registo IVA Producto %1';
    begin
        IF (Jurisdiccion <> '') then begin
            LocTaxJurisdiction.Reset;
            LocTaxJurisdiction.SetRange(Code, Jurisdiccion);
            if LocTaxJurisdiction.FindFirst then begin
                if (LocTaxJurisdiction."GMAProvince Code" = '') then
                    Error(Text005, Jurisdiccion)
                else
                    ReturnValue := LocTaxJurisdiction."GMAProvince Code";
            end
            else
                Error(Text005, Jurisdiccion);
        end
        else begin
            if (VATProdPostGroup <> '') then begin
                LocVatProdPostingGroup.Reset();
                LocVatProdPostingGroup.SetRange(Code, VATProdPostGroup);
                if LocVatProdPostingGroup.FindFirst() then
                    if (LocVatProdPostingGroup.GMAProvince = '') then
                        Error(Text006, VATProdPostGroup)
                    else
                        ReturnValue := LocVatProdPostingGroup.GMAProvince;
            end;
        end;
    end;


    procedure "#FindDocument"(DocNC: Code[20]) ReturnValue: Text[20]
    var
        LocCustLedgerEntry: Record "Cust. Ledger Entry";
        LocCustLedgerEntry2: Record "Cust. Ledger Entry";
    begin

        LocCustLedgerEntry.Reset;
        LocCustLedgerEntry.SetRange(LocCustLedgerEntry."Document No.", DocNC);
        LocCustLedgerEntry.SetRange(LocCustLedgerEntry."Document Type", LocCustLedgerEntry."document type"::Invoice);
        LocCustLedgerEntry.SetRange(LocCustLedgerEntry."Document Type", LocCustLedgerEntry."document type"::"Credit Memo");
        if (LocCustLedgerEntry.FindFirst) then begin
            LocCustLedgerEntry2.Reset;
            LocCustLedgerEntry2.SetRange(LocCustLedgerEntry2."Closed by Entry No.", LocCustLedgerEntry."Entry No.");
            if (LocCustLedgerEntry2.FindFirst) then
                ReturnValue := LocCustLedgerEntry2."Document No."
            else begin
                if (LocCustLedgerEntry."Closed by Entry No." <> 0) then begin
                    LocCustLedgerEntry2.Reset;
                    LocCustLedgerEntry2.SetRange(LocCustLedgerEntry2."Entry No.", LocCustLedgerEntry."Closed by Entry No.");
                    if (LocCustLedgerEntry2.FindFirst) then
                        ReturnValue := LocCustLedgerEntry2."Document No.";
                end
                else
                    ReturnValue := '';
            end;
        end;

    end;


    procedure "#VatEntryCordobaARP"()
    var
        SalesInvoiceHeader: Record "Sales Cr.Memo Header";
        auxparte1: Text[30];
        auxparte2: Text[30];
        auxparte3: Text[30];
        _Alicuota: Decimal;
        _recCustomer: Record Customer;
        _recTaxArea: Record "Tax Area";
    begin


        EscribirFicheroCordobaARP := true;
        NumeroLineasCordobaARP += 1;

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

        //Identificador
        Campo1 := '04';

        //Codigo de operacion
        Campo2 := Format(recCordobaTemp."Entry No.");
        while StrLen(Campo2) < 8 do
            Campo2 := '0' + Campo2;

        //Tipo percep
        Campo3 := '1';

        //Concepto de retencion/recaudacion
        Campo4 := '01';

        //Fecha percep
        Campo5 := Format(recCordobaTemp."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //Fecha emision de constancia
        Campo6 := Format(recCordobaTemp."Posting Date", 10, '<Day,2>/<Month,2>/<Year4>');

        //Numero de constancia

        Campo7 := DelChr(recCordobaTemp."Document No.", '=', DELDOCNUM);

        Campo7 := DelChr(Campo7, '=', DELDOCNUM);

        while StrLen(Campo7) < 13 do
            Campo7 := '0' + Campo7;

        //CUIT
        if not IsSales then begin
            recVendor.Reset;
            recVendor.SetRange("No.", recCordobaTemp."Bill-to/Pay-to No.");
            if recVendor.FindFirst then
                Campo8 := recVendor."VAT Registration No.";
        end else begin
            RecCustomer.Reset;
            RecCustomer.SetRange("No.", recCordobaTemp."Bill-to/Pay-to No.");
            if RecCustomer.FindFirst then
                Campo8 := RecCustomer."VAT Registration No.";
        end;

        //Base de percep

        while StrLen(Campo9) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Base, 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 13 do Campo9 += '0';


        begin
            Campo9 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Base, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');

        end;

        //Alicuota
        if recCordobaTemp.Base <> 0 then
            _Alicuota := ROUND(((recCordobaTemp.Amount * 100) / recCordobaTemp.Base), 0.0001);
        while StrLen(Campo10) + StrLen(ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
          '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.')) < 8 do Campo10 += '0';


        begin
            Campo10 += ConvertStr(DelChr(Format(ROUND(_Alicuota, 0.0001), 0,
             '<Precision,4:4><integer><decimals>'), '.', ''), ',', '.');

        end;

        while StrLen(Campo11) + StrLen(ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
          '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.')) < 11 do Campo11 += '0';

        begin
            Campo11 += ConvertStr(DelChr(Format(ROUND(recCordobaTemp.Amount, 0.01), 0,
            '<Precision,2:2><integer><decimals>'), '.', ''), ',', '.');

        end;

        Clear(TextoCordobaARP);

        TextoCordobaARP := (
        Format(Campo1, 2, '<Text>') + ',' +
        Format(Campo2, 8, '<Text>') + ',' +
        Format(Campo3, 1, '<Text>') + ',' +
        Format(Campo4, 2, '<Text>') + ',' +
        Format(Campo5, 10, '<Text>') + ',' +
        Format(Campo6, 10, '<Text>') + ',' +
        Format(Campo7, 13, '<Text>') + ',' +
        Format(Campo8, 13, '<Text>') + ',' +
        Format(Campo9, 13, '<Text>') + ',' +
        Format(Campo10, 8, '<Text>') + ',' +
        Format(Campo11, 11, '<Text>'));

        "#RellenaExcelBuffCordobaARP"(TextoCordobaARP);


    end;


    procedure "#RellenaExcelBuffCordobaARP"(pTexto: Text[1024])
    begin

        TempExcelBuffCordobaARP.Init;
        TempExcelBuffCordobaARP."Row No." := NumeroLineasCordobaARP;
        TempExcelBuffCordobaARP."Cell Value as Text" := CopyStr(pTexto, 1, 250);
        TempExcelBuffCordobaARP.Comment := CopyStr(pTexto, 251, 250);
        TempExcelBuffCordobaARP.Formula := CopyStr(pTexto, 501, 250);
        TempExcelBuffCordobaARP.Insert;

    end;

    local procedure RegimenSircar(ParJurisdiccion: Code[3]) ReturnValue: Text
    var
        recProvince: Record GMAProvince;
    begin
        //++@r ARMAS.DDS-230404 @v 46688 @m 1
        recProvince.Get(ParJurisdiccion);
        recProvince.TestField("GMAReg.Percepciones Sircar");
        ReturnValue := recProvince."GMAReg.Percepciones Sircar";
        //--@r ARMAS.DDS-230404 @v 46688 @m 1
    end;

    local procedure DisSircar(ParJurisdiccion: Code[3]) ReturnValue: Text
    var
        recProvince: Record GMAProvince;
    begin
        //++@r ARMAS.DDS-230404 @v 46688 @m 1
        recProvince.Get(ParJurisdiccion);
        ReturnValue := Format(recProvince.GMADis_Sircar);
        //--@r ARMAS.DDS-230404 @v 46688 @m 1
    end;
}

