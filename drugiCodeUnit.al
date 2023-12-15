codeunit 50123 JSONCodeUnit
{



    procedure GetApiData()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JObject: JsonObject;
        JArray: JsonArray;
        JToken: JsonToken;
        TextReponse: Text;
        i: Integer;
        myRecord: Record "JsonTable";
    begin
        myRecord.DeleteAll();
        if client.Get('https://api.coincap.io/v2/assets', Response) then begin
            if Response.HttpStatusCode = 200 then begin
                Response.Content.ReadAs(TextReponse);

                JObject.ReadFrom(TextReponse);

                if JObject.Get('data', JToken) then begin
                    JArray := JToken.AsArray();

                    for i := 0 to JArray.Count() - 1 do begin
                        JArray.Get(i, JToken);
                        if JToken.IsObject() then
                            ProcessJToken(JToken.AsObject())
                        else
                            Error('JSON token is not an object');
                    end;
                end;
            end else
                error('The http call failed');
        end;
    end;

    procedure ProcessJToken(Jobjekt: JsonObject)
    var
        MyRecord: Record "JsonTable";
        JsonToken: JsonToken;
        DecimalValue: Decimal;
        TextValue: Text;
    begin
        MyRecord.Init();
        MyRecord.TajmStamp := CurrentDateTime();

        if Jobjekt.Get('id', JsonToken) then
            MyRecord.id := JsonToken.AsValue().AsText();
        if Jobjekt.Get('rank', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.rank := DecimalValue;
        if Jobjekt.Get('symbol', JsonToken) then
            MyRecord.symbol := JsonToken.AsValue().AsText();
        if Jobjekt.Get('name', JsonToken) then
            MyRecord.name := JsonToken.AsValue().AsText();
        if Jobjekt.Get('supply', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.supply := DecimalValue;
        if Jobjekt.Get('maxSupply', JsonToken) then
            if JsonToken.IsValue() AND JsonToken.AsValue().IsNull then
                MyRecord.maxSupply := 0
            else
                if Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
                    MyRecord.maxSupply := DecimalValue;
        if Jobjekt.Get('marketCapUsd', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.marketCapUsd := DecimalValue;
        if Jobjekt.Get('volumeUsd24Hr', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.volumeUsd24Hr := DecimalValue;
        if Jobjekt.Get('priceUsd', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.priceUsd := DecimalValue;
        if Jobjekt.Get('changePercent24Hr', JsonToken) and Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
            MyRecord.changePercent24Hr := DecimalValue;
        if Jobjekt.Get('vwap24Hr', JsonToken) then
            if JsonToken.IsValue() AND JsonToken.AsValue().IsNull then
                MyRecord.vwap24Hr := 0
            else
                if Evaluate(DecimalValue, JsonToken.AsValue().AsText()) then
                    MyRecord.vwap24Hr := DecimalValue;
        if Jobjekt.Get('explorer', JsonToken) then
            MyRecord.explorer := JsonToken.AsValue().AsText();

        MyRecord.Insert();
    end;



    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
}