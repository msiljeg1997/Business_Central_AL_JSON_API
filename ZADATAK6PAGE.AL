page 50113 ageZaDisplayCurrency
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Kurenzies;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Valuta"; Rec."Valuta")
                {
                }
                field("Srednji tecaj"; Rec."Srednji tecaj")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Vidi Tecaj")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var

                    KurenMgm: Codeunit "Codeunit za Currency";
                begin
                    KurenMgm.GetApiData();
                    KurenMgm.ListCurrencyCodes();

                end;
            }
        }
    }
}