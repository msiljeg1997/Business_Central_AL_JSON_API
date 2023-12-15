table 50103 "APICurrenciesRates"
{
    DataClassification = ToBeClassified;


    fields
    {

        field(5; Valuta; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Srednji Tecaj"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4;

        }
    }

    keys
    {
        key(Valuta; "Valuta")
        {
            Clustered = true;
        }
    }
}

