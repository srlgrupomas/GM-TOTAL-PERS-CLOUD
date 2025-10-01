page 34006901 "Gen. Journal Batch List"
{
    PageType = List;
    SourceTable = "Gen. Journal Batch";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Journal Batches';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Batch Name';
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Journal Template';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SelectBatch)
            {
                Caption = 'Select';
                ApplicationArea = All;
                Image = Select;

                trigger OnAction()
                begin
                    // Cerrar la página y devolver el registro seleccionado
                    CurrPage.Close();
                end;
            }
        }
    }

    procedure GetSelectedRecord(var GenJournalBatchRecord: Record "Gen. Journal Batch")
    begin
        // Asignar el registro seleccionado a la variable proporcionada
        GenJournalBatchRecord := Rec;
    end;
}