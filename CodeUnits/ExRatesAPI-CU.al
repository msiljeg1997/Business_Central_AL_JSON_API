codeunit 50130 "Codeunit za Currency"
{

    // PROCEDURA ZA DOBIJANJE PODATAKA IZ APIJA
    procedure GetApiData()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JArray: JsonArray;
        JToken: JsonToken;
        TextReponse: Text;
        i: Integer;
        myRecord: Record "APICurrenciesRates";
    begin
        myRecord.DeleteALl();
        if client.Get('https://api.hnb.hr/tecajn-eur/v3', Response) then begin
            if Response.HttpStatusCode = 200 then begin
                Response.Content.ReadAs(TextReponse);
                message(TextReponse);

                JArray.ReadFrom(TextReponse);

                for i := 0 to JArray.Count() - 1 do begin
                    JArray.Get(i, JToken);
                    if JToken.IsObject then
                        ProcessJToken(JToken.AsObject());
                end;
                UpdateExchangeRate(JArray);
            end else
                error('The http call failed');
        end;
    end;

    // PROCESIRANJE JTOKENA IZ APIJA U TABLICU "APICurrenciesRates"
    procedure ProcessJToken(JToken: JsonObject)
    var
        MyRecord: Record "APICurrenciesRates";
        JsonValue: JsonToken;
        Value: Text;
        DecimalValue: Decimal;
    begin
        MyRecord.Init();
        if JToken.Get('srednji_tecaj', JsonValue) then begin
            Value := JsonValue.AsValue().AsText();
            if Evaluate(DecimalValue, Value) then
                MyRecord."Srednji Tecaj" := DecimalValue;
        end;

        if JToken.Get('valuta', JsonValue) then
            MyRecord."Valuta" := JsonValue.AsValue().AsText();
        MyRecord.Insert();
    end;

    // POMOCNA PROCEDURA = IZLISTAJ SVE CURRENCY CODES SA CURRENCY TABLE
    procedure ListCurrencyCodes()
    var
        Currency: Record Currency;
        SpremiCurrency: Text;
    begin
        SpremiCurrency := '';
        if Currency.FindSet() then
            repeat
                SpremiCurrency := SpremiCurrency + Currency."ISO Code" + ' \';
            until Currency.Next() = 0;
        SpremiCurrency := DELSTR(SpremiCurrency, STRLEN(SpremiCurrency), 1);
        message(SpremiCurrency);
    end;

    //SPREMANJE U LISTE
    procedure SpremanjeUListe()
    var
        Currency: Record Currency;
        CurrencyCodes: List of [Text];
        ValutaValues: List of [Text];
        JToken: JsonObject;
        JsonValue: JsonToken;
        Value: Text;
    begin
        // currency lista
        if Currency.FindSet() then
            repeat
                CurrencyCodes.Add(Currency."ISO Code");
            until Currency.Next() = 0;
        // valuta lista
        if JToken.Get('valuta', JsonValue) then begin
            Value := JsonValue.AsValue().AsText();
            ValutaValues.Add(Value);
        end;
    end;

    // GLAVNA PROCEDURA KOJA UPDEJTA "EXCHANGE RATE AMOUNT" SA "SREDNJIM_TECAJEM" IZ APIJA KADA SE MATCHA "ISO CODE" I "VALUTA"
    procedure UpdateExchangeRate(JsonArray: JsonArray)
    var
        Currency: Record Currency;
        JToken: JsonObject;
        JsonValue: JsonToken;
        Value: Text;
        DecimalValue: Decimal;
        i: Integer;
    begin
        for i := 0 to JsonArray.Count - 1 do begin
            if JsonArray.Get(i, JsonValue) then begin
                JToken := JsonValue.AsObject();

                // Get 'valuta' and 'srednji_tecaj'
                if JToken.Get('valuta', JsonValue) then
                    Value := JsonValue.AsValue().AsText();
                if JToken.Get('srednji_tecaj', JsonValue) then begin
                    if Evaluate(DecimalValue, JsonValue.AsValue().AsText()) then begin
                        // Check if 'valuta' matches a "Currency Code"
                        if Currency.Get(Value) then begin
                            // If match, update "ExchangeRateAmt2" in "Currency" table
                            Currency.ExchangeRateAmt2 := DecimalValue;
                            Currency.Modify();
                        end;
                    end;
                end;
            end;
        end;
    end;

    //POMOCNA PROCEDURA ZA PRINTANJE SVIH EXCHANGE RATE AMAUNTOVA
    procedure PrintExchangeRateAmounts()
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        MessageText: Text;
    begin
        if CurrencyExchangeRate.FindSet() then
            repeat
                MessageText += StrSubstNo('Currency Code: %1, Exchange Rate Amount: %2', CurrencyExchangeRate."Currency Code", CurrencyExchangeRate."Exchange Rate Amount") + '\';
            until CurrencyExchangeRate.Next() = 0;

        Message(MessageText);
    end;
}