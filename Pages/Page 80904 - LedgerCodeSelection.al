page 80904 "Ledger Code Selection"
{
    Caption = 'Select Ledger Codes';
    PageType = List;
    SourceTable = "GRP Ledger Code";
    UsageCategory = None;
    MultipleNewLines = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Select)
            {
                ApplicationArea = All;
                Caption = 'Select';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // Store selected records in the temporary table
                    CurrPage.SetSelectionFilter(Rec);
                    TempSelectedLedgerCodes.Reset();
                    TempSelectedLedgerCodes.DeleteAll();
                    if Rec.FindSet() then begin
                        repeat
                            TempSelectedLedgerCodes.Init();
                            TempSelectedLedgerCodes.Code := Rec.Code;
                            TempSelectedLedgerCodes.Description := Rec.Description;
                            TempSelectedLedgerCodes.Insert();
                        until Rec.Next() = 0;
                    end;
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        TempSelectedLedgerCodes: Record "GRP Ledger Code" temporary;
        SelectedLedgerCodes: Text;

    procedure SetLedgerCode(CurrentLedgerCode: Text)
    var
        LedgerCodeList: List of [Text];
        LedgerCode: Text;
    begin
        // Initialize temporary table with current selections
        TempSelectedLedgerCodes.Reset();
        TempSelectedLedgerCodes.DeleteAll();
        if CurrentLedgerCode <> '' then begin
            LedgerCodeList := CurrentLedgerCode.Split('|');
            foreach LedgerCode in LedgerCodeList do begin
                TempSelectedLedgerCodes.Init();
                TempSelectedLedgerCodes.Code := CopyStr(LedgerCode, 1, MaxStrLen(TempSelectedLedgerCodes.Code));
                TempSelectedLedgerCodes.Insert();
            end;
        end;
    end;

    procedure GetSelectedLedgerCodes(): Text
    begin
        // Build pipe-separated string of selected ledger codes
        TempSelectedLedgerCodes.Reset();
        SelectedLedgerCodes := '';
        if TempSelectedLedgerCodes.FindSet() then begin
            repeat
                if SelectedLedgerCodes = '' then
                    SelectedLedgerCodes := TempSelectedLedgerCodes.Code
                else
                    SelectedLedgerCodes += '|' + TempSelectedLedgerCodes.Code;
            until TempSelectedLedgerCodes.Next() = 0;
        end;
        exit(SelectedLedgerCodes);
    end;

    trigger OnOpenPage()
    begin
        // Mark records that were previously selected
        if TempSelectedLedgerCodes.FindSet() then begin
            repeat
                if Rec.Get(TempSelectedLedgerCodes.Code) then begin
                    Rec.Mark(true);
                end;
            until TempSelectedLedgerCodes.Next() = 0;
        end;
    end;
}