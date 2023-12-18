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
        myRecord: Record "CryptoRatesAPITable";
    begin
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
        MyRecord: Record "CryptoRatesAPITable";
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
            if JsonToken.IsValue() and not JsonToken.AsValue().IsNull then
                MyRecord.explorer := JsonToken.AsValue().AsText();

        MyRecord.Insert();

    end;


    procedure ExportXmlToFile(XmlText: Text; FileName: Text)
    var
        InStream: InStream;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(XmlText);
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, 'Export XML', '', 'XML Files (*.xml)|*.xml', FileName);
    end;

    procedure
    ExportXML()
    var
        CryptoRatesAPITable: Record "CryptoRatesAPITable";
        SpremanjeText: Text;
        XmlText: Text;
        //SAVING VARS
        FileName: Text;
        OutStream: OutStream;
        InStream: InStream;
        TempBlob: Codeunit "Temp Blob";

    begin
        XmlText := '<?xml version="1.0" encoding="UTF-8"?>' + '\n' + '<CryptoRates>';
        if CryptoRatesAPITable.Find('-') then
            repeat
                XMLText += '<CryptoRate>';
                XMLText += '<id>' + CryptoRatesAPITable.id + '</id>';
                XMLText += '<Rank>' + FORMAT(CryptoRatesAPITable.Rank) + '</Rank>';
                XMLText += '<symbol>' + CryptoRatesAPITable.symbol + '</symbol>';
                XMLText += '<name>' + CryptoRatesAPITable.name + '</name>';
                XMLText += '<supply>' + FORMAT(CryptoRatesAPITable.supply) + '</supply>';
                XMLText += '<maxSupply>' + FORMAT(CryptoRatesAPITable.maxSupply) + '</maxSupply>';
                XMLText += '<marketCapUsd>' + FORMAT(CryptoRatesAPITable.marketCapUsd) + '</marketCapUsd>';
                XMLText += '<volumeUsd24Hr>' + FORMAT(CryptoRatesAPITable.volumeUsd24Hr) + '</volumeUsd24Hr>';
                XMLText += '<priceUsd>' + FORMAT(CryptoRatesAPITable.priceUsd) + '</priceUsd>';
                XMLText += '<changePercent24Hr>' + FORMAT(CryptoRatesAPITable.changePercent24Hr) + '</changePercent24Hr>';
                XMLText += '<vwap24Hr>' + FORMAT(CryptoRatesAPITable.vwap24Hr) + '</vwap24Hr>';
                XMLText += '<explorer>' + CryptoRatesAPITable.explorer + '</explorer>';
                XMLText += '<TajmStamp>' + FORMAT(CryptoRatesAPITable.TajmStamp) + '</TajmStamp>';
                XMLText += '</CryptoRate>';
            until CryptoRatesAPITable.Next() = 0;
        XMLText += '</CryptoRates>';

        //SAVE
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(XmlText);
        TempBlob.CreateInStream(InStream);
        FileName := 'YourFile.xml';
        DownloadFromStream(InStream, 'Save XML', 'XML Files (*.xml)|*.xml', FileName, FileName);
    end;

    var
        myInt: Integer;
}