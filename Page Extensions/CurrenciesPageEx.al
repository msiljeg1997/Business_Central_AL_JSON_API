pageextension 50108 PageExtensionCurrencies extends Currencies
{
    layout
    {
        addbefore(ExchangeRateAmt)
        {
            field(ExchangeRateAmt2; Rec.ExchangeRateAmt2)
            {
                ApplicationArea = All;
                Caption = 'Exchange Rate Amount DVOJKA';
            }
        }
    }

    actions
    {
        addbefore("Exchange Rate Services")
        {
            action(NewRates)
            {
                ApplicationArea = All;
                Caption = 'New Rates';
                Image = New;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NewCurrencysAPI: Codeunit "Codeunit za Currency";
                begin
                    NewCurrencysAPI.GetApiData();
                end;
            }
        }
    }
}



