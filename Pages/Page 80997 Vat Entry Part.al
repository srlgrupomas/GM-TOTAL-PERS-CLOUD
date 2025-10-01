page 34006997 "Vat Entry Part"
{
    ApplicationArea = All;
    Caption = 'Vat Entry Part';
    PageType = ListPart;
    SourceTable = "VAT Entry";
    SourceTableTemporary = true;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';

                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';

                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT entry''s posting date.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("AFIP Voucher Type"; Rec."GMAAFIP Voucher Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the AFIP voucher that the VAT entry belongs to.';
                }
                field("Vendor Name"; VendorName)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the vendor that the entry is linked to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number on the VAT entry.';
                }
                field("CUIT"; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the CUIT of the customer or vendor that the entry is linked to.';
                }
                field("Currency"; Rec."Source Currency Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the currency code of the entry.';
                }
                // field("Client Name"; Rec.)
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies the name of the client.';
                // }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document type that the VAT entry belongs to.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the VAT entry.';
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount that the VAT amount (the amount shown in the Amount field) is calculated from.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the VAT entry in LCY.';
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.';

                }
                field("Additional-Currency Base"; Rec."Additional-Currency Base")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount that the VAT amount is calculated from if you post in an additional reporting currency.';

                }
                field("Additional-Currency Amount"; Rec."Additional-Currency Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the VAT entry. The amount is in the additional reporting currency.';

                }
                field("Add.-Curr. VAT Difference"; Rec."Add.-Curr. VAT Difference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies, in the additional reporting currency, the VAT difference that arises when you make a correction to a VAT amount on a sales or purchase document.';

                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how VAT will be calculated for purchases or sales of items with this particular combination of VAT business posting group and VAT product posting group.';
                }
                field("Ship-to/Order Address Code"; Rec."Ship-to/Order Address Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.';

                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the transaction is related to trade with a third party within the EU.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the VAT entry has been closed by the Calc. and Post VAT Settlement batch job.';
                }
                field("Closed by Entry No."; Rec."Closed by Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the VAT entry that has closed the entry, if the VAT entry was closed with the Calc. and Post VAT Settlement batch job.';
                }
                field("Internal Ref. No."; Rec."Internal Ref. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the internal reference number for the line.';
                }
                field("Tax Group Code"; rec."Tax Group Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the tax group code for the VAT entry.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        VendorName := '';
        if Vendor.Get(Rec."Bill-to/Pay-to No.") then
            VendorName := Vendor.Name
        else if Customer.Get(Rec."Bill-to/Pay-to No.") then
            VendorName := Customer.Name;
    end;

    procedure setTable()
    var
        globalSaveTempMov: Codeunit SaveTempMov;
        tablaTemp: Record "VAT Entry" temporary;
    begin
        globalSaveTempMov.GetLastVatEntry(tablaTemp);
        IF (tablaTemp.FindFirst()) THEN
            repeat
                rec.Init();
                rec.Copy(tablaTemp);
                rec.Insert();

            until tablaTemp.Next() = 0;

    end;

    var
        VendorName: Text[100];
}
