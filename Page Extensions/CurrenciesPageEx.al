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
}