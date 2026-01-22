program CadastroAPI;
{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  IdHTTPWebBrokerBridge,
  Web.WebReq,
  uMainWebModule in 'uMainWebModule.pas';

var
  Server: TIdHTTPWebBrokerBridge;

begin
  try
    Server := TIdHTTPWebBrokerBridge.Create(nil);
    try
      WebRequestHandler.WebModuleClass := TWebModule1;
      Server.DefaultPort := 8080;
      Server.Active := True;
      Writeln('Servidor rodando em http://localhost:8080/');
      Writeln('Pressione CTRL+C para parar.');

      while True do
        Sleep(1000);
    finally
      Server.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

