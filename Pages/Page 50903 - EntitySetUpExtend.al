page 34006903 "EntitySetUpExtend"
{
    PageType = List;
    SourceTable = "EntitySetUpExtend";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the dimension code.';

                    trigger OnValidate()
                    var
                        dimensiontable: Record Dimension;
                    begin
                        if Rec."Dimension Code" <> '' then begin
                            if not dimensiontable.Get(Rec."Dimension Code") then
                                Error('The Dimension Code %1 does not exist in the Dimension table.', Rec."Dimension Code");
                        end;
                    end;
                }
                field("Company CBU"; Rec."CompanyCBU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Company CBU.';
                }
                field("Company Alias"; Rec."CompanyAlias")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Company Alias.';
                }
                field("Asset"; Rec."Asset")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Asset.';
                }
                field("AssetValue"; Rec.AssetValue)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = field("Asset"));
                }
                field("Department"; Rec."Department")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Department.';
                }
                field("DepartmentValue"; rec.DepartmentValue)
                {
                    ApplicationArea = all;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = field("Department"));
                }
                field("Intercompany"; Rec."Intercompany")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Intercompany.';
                }
                field("IntercompanyValue"; rec.IntercompanyValue)
                {
                    ApplicationArea = all;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = field("Intercompany"));
                }
            }
        }
    }
}