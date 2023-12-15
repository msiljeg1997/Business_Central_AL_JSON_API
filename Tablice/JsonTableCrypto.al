table 50123 CryptoRatesAPITable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Rank; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; symbol; TEXT[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; name; TEXT[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; supply; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 100;
        }
        field(6; maxSupply; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 100;
        }
        field(7; marketCapUsd; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 100;
        }
        field(8; volumeUsd24Hr; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 100;
        }
        field(9; priceUsd; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 100;
        }
        field(10; changePercent24Hr; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 100;
        }
        field(11; vwap24Hr; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 100;
        }
        field(12; explorer; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(13; TajmStamp; DateTime)
        {
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        key(Key1; TajmStamp, symbol)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}