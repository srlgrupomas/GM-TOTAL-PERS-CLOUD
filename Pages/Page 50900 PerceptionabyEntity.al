page 80900 PerceptionabyEntity
{
    ApplicationArea = All;
    Caption = 'Perception by Entity';
    PageType = List;
    SourceTable = PerceptionabyEntity;

    layout
    {
        area(Content)
        {

            field(CodProvince; CodProvince)
            {
                Caption = 'Province Code';
                trigger OnAssistEdit()
                var
                begin
                    TableProvince.Reset();
                    IF (TableProvince.FindFirst()) THEN begin
                        CLEAR(PageProvince);
                        PageProvince.SetTableView(TableProvince);
                        PageProvince.LookupMode(true);
                        IF PageProvince.RunModal() = Action::LookupOK then begin
                            PageProvince.GetRecord(TableProvince);
                            CodProvince := TableProvince."GMLocProvince Code";
                            Rec.Reset();
                            Rec.SetRange(ProvinceCode, CodProvince);
                            IF (rec.FindFirst()) THEN;
                        end;

                    end;
                end;

                trigger OnValidate()
                begin
                    Rec.Reset();
                    Rec.SetRange(ProvinceCode, CodProvince);
                    IF (rec.FindFirst()) THEN;
                end;
            }
            repeater(General)
            {

                field(EntityID; Rec.EntityID)
                {

                    ApplicationArea = all;
                }
                field(ProvinceCode; Rec.ProvinceCode)
                {

                    ApplicationArea = all;
                }
                field(Retains; Rec.Retains)
                {

                    ApplicationArea = all;
                }
            }
        }
    }
    var
        TableProvince: Record GMLocProvince;
        CodProvince: Code[20];
        PageProvince: Page GMLocProvinces;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
        rec.ProvinceCode := CodProvince;
    end;

    procedure GetMarkedRecordset(var Recordset: Record PerceptionabyEntity);
    begin

        CurrPage.SETSELECTIONFILTER(Rec);
        CLEAR(Recordset);
        Recordset.COPY(Rec);


    end;

    trigger OnOpenPage()
    var
    begin
        rec.Reset();
        rec.SetRange(ProvinceCode, CodProvince);
        IF rec.FindFirst() then;
    end;


}
