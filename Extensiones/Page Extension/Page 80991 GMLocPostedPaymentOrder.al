// // Welcome to your new AL extension.
// // Remember that object names and IDs should be unique across all extensions.
// // AL snippets start with t*, like tpageext - give them a try and happy coding!

// namespace DefaultPublisher.ALProject1;

// using Microsoft.Sales.Customer;

// pageextension 34006991 GMLocPostedPaymentOrder extends "GMLocPosted Payment Order"
// {
//     actions
//     {
//         addafter("GMLoc<Action1000000003>")
//         {
//             action("Print Payment order with certification")
//             {
//                 ApplicationArea = ALL;
//                 Caption = 'Print',
//                             ;
//                 Image = Print;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction();
//                 var
//                     postedpaymentorder: Record "GMLocPosted Payment Order";
//                 begin
//                     postedpaymentorder.Reset();
//                     postedpaymentorder.SETRANGE(postedpaymentorder."GMLocPayment O. No.", Rec."GMLocPayment O. No.");
//                     if postedpaymentorder.FindSet() then
//                         postedpaymentorder.SETRECFILTER;
//                     REPORT.RUNMODAL(34006890, true, false, postedpaymentorder);
//                 end;
//             }
//         }
//     }
// }