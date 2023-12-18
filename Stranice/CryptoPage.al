page 50102 "Crypto rates API"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = CryptoRatesAPITable;

    layout
    {
        area(Content)
        {
            repeater(Informacije)
            {
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                    Caption = 'ID';

                }
                field(Rank; Rec.Rank)
                {
                    ApplicationArea = All;
                    Caption = 'Rank';
                }
                field(symbol; Rec.symbol)
                {
                    ApplicationArea = All;
                    Caption = 'Symbol';
                }
                field(name; Rec.name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field(supply; Rec.supply)
                {
                    ApplicationArea = All;
                    Caption = 'Supply';
                }
                field(maxSupply; Rec.maxSupply)
                {
                    ApplicationArea = All;
                    Caption = 'Max Supply';
                }
                field(marketCapUsd; Rec.marketCapUsd)
                {
                    ApplicationArea = All;
                    Caption = 'Market Cap USD';
                }
                field(volumeUsd24Hr; Rec.volumeUsd24Hr)
                {
                    ApplicationArea = All;
                    Caption = 'Volume USD 24H';
                }
                field(priceUsd; Rec.priceUsd)
                {
                    ApplicationArea = All;
                    Caption = 'Price USD';
                }
                field(changePercent24Hr; Rec.changePercent24Hr)
                {
                    ApplicationArea = All;
                    Caption = 'Change Percent 24Hr';
                }
                field(vwap24Hr; Rec.vwap24Hr)
                {
                    ApplicationArea = All;
                    Caption = 'VWAP 24Hr';
                }
                field(explorer; Rec.explorer)
                {
                    ApplicationArea = All;
                    Caption = 'Explorer';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Magija)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Magija: Codeunit "JSONCodeUnit";

                begin
                    Magija.GetApiData();


                end;
            }
            action(DownloadXML)
            {
                ApplicationArea = All;
                Caption = 'Skini XML datoteku nije virus';
                Image = New;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DownloadXML: Codeunit "JSONCodeUnit";
                begin
                    DownloadXML.ExportXML();

                end;
            }
        }
    }

    var
        myInt: Integer;
}