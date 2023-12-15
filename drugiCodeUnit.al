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

    procedure ProcessJToken(JToken: JsonObject)
    var
        MyRecord: Record "JsonTable";
        JsonToken: JsonToken;
        DecimalValue: Decimal;
    begin
        MyRecord.Init();
        MyRecord.TajmStamp := CurrentDateTime();

        if JToken.Get('id', JsonToken) then
            MyRecord.id := JsonToken.AsValue().AsText();
        if JToken.Get('rank', JsonToken) then
            MyRecord.rank := GetDecimalValue(JsonToken);
        if JToken.Get('symbol', JsonToken) then
            MyRecord.symbol := JsonToken.AsValue().AsText();
        if JToken.Get('name', JsonToken) then
            MyRecord.name := JsonToken.AsValue().AsText();
        if JToken.Get('supply', JsonToken) then
            MyRecord.supply := GetDecimalValue(JsonToken);
        if JToken.Get('maxSupply', JsonToken) then
            MyRecord.maxSupply := GetDecimalValue(JsonToken);
        if JToken.Get('marketCapUsd', JsonToken) then
            MyRecord.marketCapUsd := GetDecimalValue(JsonToken);
        if JToken.Get('volumeUsd24Hr', JsonToken) then
            MyRecord.volumeUsd24Hr := GetDecimalValue(JsonToken);
        if JToken.Get('priceUsd', JsonToken) then
            MyRecord.priceUsd := GetDecimalValue(JsonToken);
        if JToken.Get('changePercent24Hr', JsonToken) then
            MyRecord.changePercent24Hr := GetDecimalValue(JsonToken);
        if JToken.Get('vwap24Hr', JsonToken) then
            MyRecord.vwap24Hr := GetDecimalValue(JsonToken);

        MyRecord.Insert();
    end;

    procedure GetDecimalValue(JsonToken: JsonToken): Decimal;
    begin
        exit(JsonToken.AsValue().AsDecimal());
    end;

    procedure TryParseDecimal(DecimalText: Text; var DecimalValue: Decimal): Boolean
    begin
        exit(Evaluate(DecimalValue, DecimalText));
    end;

    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
}