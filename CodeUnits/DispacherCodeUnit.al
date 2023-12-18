codeunit 50128 MyDispatcher
{
    trigger OnRun()
    var
        MyCodeunit: Codeunit "JSONCodeunit";
    begin
        MyCodeunit.GetApiData();
    end;
}