page 34006891 "Report Total"
{
    ApplicationArea = All;
    Caption = 'Report Total';
    PageType = List;
    SourceTable = "Purch. Inv. Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group("Date Filter")
            {
                Caption = 'Date Filters';
                field(FechaDesde; FechaDesde)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date From';
                }
                field(FechaHasta; FechaHasta)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date To';
                }
            }

            group("Project Filter")
            {
                Caption = 'Project Filter';

                field(BoolProyecto; BoolProyecto)
                {
                    ApplicationArea = Basic;
                    Caption = 'Project';
                }
            }

            repeater(General)
            {
                field("Company Code"; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Company Code';
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Project No."; rec."Job No.")
                {
                    ApplicationArea = all;
                    Caption = 'Project No.';
                }
                field("Project Task No."; rec."Job No.")
                {
                    ApplicationArea = all;
                    Caption = 'Project Task No.';
                }
                field("Project Line Type"; rec."Job Line Type")
                {
                    ApplicationArea = all;
                    Caption = 'Project Line Type';
                }
                field("Product Code"; rec."No.")
                {
                    ApplicationArea = all;
                    Caption = 'Product Code';
                }
                field("G/L Account Code"; rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    Caption = 'G/L Account Code';
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date';
                }
                field("Description"; rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Description';
                }
                field("Amount"; rec."Amount")
                {
                    ApplicationArea = all;
                    Caption = 'Amount';
                }

                field("Amount (FC)"; ImporteDLMostrar)
                {
                    ApplicationArea = all;
                    Caption = 'Amount (FC)';
                }
                field("Currency Code"; CodigoDivisa)
                {
                    ApplicationArea = all;
                    Caption = 'Currency Code';
                }
                field("Currency Factor"; FactorDivisa)
                {
                    ApplicationArea = all;
                    Caption = 'Currency Factor';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Process)
            {
                ApplicationArea = Basic;
                Caption = 'Process';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    locPurchInvLine: Record "Purch. Inv. Line";
                    item: Record Item;
                    jobLedgerEntry: Record "Job Ledger Entry";
                    purchInvHeader: Record "Purch. Inv. Header";
                    memSetup: Record BssiMEMSystemSetup;
                begin
                    locPurchInvLine.Reset();

                    if FechaDesde <> 0D then
                        locPurchInvLine.SetRange("Posting Date", FechaDesde, FechaHasta);

                    if locPurchInvLine.FindSet() then
                        repeat
                            // Filter within the loop if `BoolProyecto` is enabled
                            if (BoolProyecto = false) or (locPurchInvLine."Job No." <> '') then begin
                                rec.Init();
                                Rec.TransferFields(locPurchInvLine);

                                if item.Get(locPurchInvLine."No.") then
                                    rec."Order No." := item."Gen. Prod. Posting Group";

                                if purchInvHeader.Get(locPurchInvLine."Document No.") then begin
                                    CodigoDivisa := purchInvHeader."Currency Code";
                                    FactorDivisa := purchInvHeader."Currency Factor";
                                end;

                                Rec.Insert();
                            end;
                        until locPurchInvLine.Next() = 0;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        locPurchInvLine: Record "Purch. Inv. Line";
    begin
        if FactorDivisa <> 0 then
            "Importe (DL)" := locPurchInvLine."Amount" / FactorDivisa
        else
            "Importe (DL)" := 0;


        if "Importe (DL)" = 0 then
            ImporteDLMostrar := rec."Amount"
        else
            ImporteDLMostrar := "Importe (DL)";
    end;

    trigger OnOpenPage()
    begin
        if FechaDesde <> 0D then
            Rec.SetRange("Posting Date", FechaDesde, FechaHasta);
    end;

    var
        FechaDesde: Date;
        FechaHasta: Date;
        CodigoDivisa: Code[10];
        FactorDivisa: Decimal;
        CodigoCompania: Code[20];
        "Importe (DL)": Decimal;
        "ImporteDLMostrar": Decimal;
        BoolProyecto: Boolean;
}