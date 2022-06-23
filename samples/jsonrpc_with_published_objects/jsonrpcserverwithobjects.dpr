program jsonrpcserverwithobjects;

 {$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.Console,
  MVCFramework.REPLCommandsHandlerU,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdHTTPWebBrokerBridge,
  MyObjectU in 'MyObjectU.pas',
  MainWebModuleU in 'MainWebModuleU.pas' {MyWebModule: TWebModule},
  MVCFramework.JSONRPC in '..\..\sources\MVCFramework.JSONRPC.pas',
  BusinessObjectsU in '..\commons\BusinessObjectsU.pas',
  RandomUtilsU in '..\commons\RandomUtilsU.pas',
  MainDM in '..\articles_crud_server\MainDM.pas' {dmMain: TDataModule};

{$R *.res}

procedure RunServer(APort: Integer);
var
  lServer: TIdHTTPWebBrokerBridge;
  lCustomHandler: TMVCCustomREPLCommandsHandler;
  lCmd: string;
begin
  Writeln('** DMVCFramework Server ** build ' + DMVCFRAMEWORK_VERSION);
  Writeln('JSON-RPC Server with Published Objects');

  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;

    { more info about MaxConnections
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
    LServer.MaxConnections := 0;

    { more info about ListenQueue
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
    LServer.ListenQueue := 200;

    lServer.Active := True;
    Write('Press return to quit...');
    WaitForReturn;
  finally
    LServer.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  TextColor(TConsoleColor.White);
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    RunServer(8080);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
