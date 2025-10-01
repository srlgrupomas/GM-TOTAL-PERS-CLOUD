pageextension 34006885 "Fixed Asset gl journal" extends "Fixed Asset G/L Journal"
{
    layout
    {
        addafter("Posting Date")
        {
            field("GMLOCAdditional-Currency Posting"; rec."Additional-Currency Posting")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("GMLOCCurrency Factor"; rec."Currency Factor")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }

    actions
    {
        modify("P&ost")
        {
            Visible = false;
        }
        addafter("P&ost")
        {
            action(PersPost)
            {
                ApplicationArea = FixedAssets;
                Caption = 'P&ost';
                Image = PostOrder;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    GenJourLine: Record "Gen. Journal Line";
                begin
                    GenJourLine.Reset();
                    GenJourLine.SetRange("Source Type", rec."Source Type"::"Fixed Asset");
                    GenJourLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJourLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJourLine.SetRange(BssiEntityID, rec.BssiEntityID);
                    GenJourLine.SetRange(PersRecalculado, false);
                    if GenJourLine.FindSet() then
                        if Confirm('"Do you want to record without recalculating the fixed asset?') then begin
                            Rec.SendToPosting(Codeunit::"Gen. Jnl.-Post");
                            CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        end;
                    CurrPage.Update(false);
                end;

            }

            action("PersRecalcularAmort")
            {
                Caption = 'Recalculate Depreciation';
                ApplicationArea = FixedAssets;
                Image = CalculateDepreciation;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                    GLEntry: Record "G/L Entry";
                    GenJourLine: Record "Gen. Journal Line";
                begin
                    FixedAsset.Get(Rec."Source No.");

                    GenJourLine.Reset();
                    GenJourLine.SetRange("Source Type", Rec."Source Type"::"Fixed Asset");
                    GenJourLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJourLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJourLine.SetRange(BssiEntityID, Rec.BssiEntityID);
                    GenJourLine.SetRange(PersRecalculado, false);

                    if GenJourLine.FindSet() then begin
                        repeat
                            GenJourLine.Amount := GenJourLine.Amount / FixedAsset."PersExchange Rate FA";
                            GenJourLine."Currency Code" := 'USD';
                            GenJourLine."Currency Factor" := 1 / FixedAsset."PersExchange Rate FA";
                            GenJourLine.PersRecalculado := true;

                            GLEntry.Reset();
                            GLEntry.SetRange("Document No.", GenJourLine."Document No.");
                            GLEntry.SetRange("Posting Date", GenJourLine."Posting Date");
                            GLEntry.SetRange("Source Type", GenJourLine."Source Type");
                            GLEntry.SetRange("Source No.", GenJourLine."Source No.");
                            if GLEntry.FindFirst() then begin
                                GLEntry."PerCurrency Factor FA" := GenJourLine."Currency Factor";
                                GLEntry."Additional-Currency Amount" := GenJourLine.Amount * GenJourLine."Currency Factor";
                                GLEntry.Modify();
                            end;

                            GenJourLine.Modify();
                        until GenJourLine.Next() = 0;
                    end else begin
                        Error('No se encontraron líneas de diario para recalcular o ya han sido procesadas.');
                    end;

                    CurrPage.Update();
                end;
            }
        }
    }
}