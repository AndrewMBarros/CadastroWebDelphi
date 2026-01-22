unit uMainWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, System.Generics.Collections;

type
  TWebModule1 = class(TWebModule)
  private
    Numeros: TList<Integer>;
    Nomes: TList<string>;
    procedure ActIndex(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure ActCadastrar(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure ActPesquisar(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure CreateActions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  WebModule1: TWebModule1;

implementation

{ TWebModule1 }

constructor TWebModule1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Numeros := TList<Integer>.Create;
  Nomes   := TList<string>.Create;

  CreateActions;
end;

destructor TWebModule1.Destroy;
begin
  Numeros.Free;
  Nomes.Free;
  inherited;
end;

procedure TWebModule1.CreateActions;
var
  Action: TWebActionItem;
begin
  Action := Actions.Add;
  Action.Name := 'actIndex';
  Action.PathInfo := '/';
  Action.OnAction := ActIndex;

  Action := Actions.Add;
  Action.Name := 'actCadastrar';
  Action.PathInfo := '/cadastrar';
  Action.OnAction := ActCadastrar;

  Action := Actions.Add;
  Action.Name := 'actPesquisar';
  Action.PathInfo := '/pesquisar';
  Action.OnAction := ActPesquisar;
end;

// Página inicial
procedure TWebModule1.ActIndex(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled := True;
  Response.ContentType := 'text/html; charset=utf-8';
  Response.Content :=
    '<html><body>' +
    '<h2>Bem-vindo ao sistema!</h2>' +

    '<form action="/cadastrar" method="get">' +
    '<button type="submit">Cadastrar</button>' +
    '</form><br>' +

    '<form action="/pesquisar" method="get">' +
    '<button type="submit">Pesquisar</button>' +
    '</form>' +

    '</body></html>';
end;

// Cadastro
procedure TWebModule1.ActCadastrar(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  NumeroStr, NomeStr: string;
  Numero: Integer;
  AlertaQtd: string;
begin
  Handled := True;
  Response.ContentType := 'text/html; charset=utf-8';

  if Request.Method = 'GET' then
  begin
    Response.Content :=
      '<html><body>' +
      '<h2>Cadastro</h2>' +

      '<form method="POST" action="/cadastrar">' +
      'Número:<br>' +
      '<input type="text" name="numero"><br><br>' +
      'Nome:<br>' +
      '<input type="text" name="nome"><br><br>' +
      '<button type="submit">Cadastrar</button>' +
      '</form><br>' +

      '<form action="/" method="get">' +
      '<button type="submit">Voltar</button>' +
      '</form>' +

      '</body></html>';
    Exit;
  end;

  // Limite máximo de cadastros
  if Numeros.Count >= 10 then
  begin
    Response.Content :=
      '<html><body>' +
      '<script>alert("Limite máximo de 10 cadastros atingido!");</script>' +
      '<form action="/cadastrar" method="get">' +
      '<button type="submit">Voltar</button>' +
      '</form>' +
      '</body></html>';
    Exit;
  end;

  NumeroStr := Request.ContentFields.Values['numero'];
  NomeStr   := Request.ContentFields.Values['nome'];

  if not TryStrToInt(NumeroStr, Numero) then
  begin
    Response.Content :=
      '<html><body>' +
      '<script>alert("Número inválido!");</script>' +
      '<form action="/cadastrar" method="get">' +
      '<button type="submit">Voltar</button>' +
      '</form>' +
      '</body></html>';
    Exit;
  end;

  if NomeStr = '' then
  begin
    Response.Content :=
      '<html><body>' +
      '<script>alert("Nome não pode ser vazio!");</script>' +
      '<form action="/cadastrar" method="get">' +
      '<button type="submit">Voltar</button>' +
      '</form>' +
      '</body></html>';
    Exit;
  end;

  if Numeros.Contains(Numero) then
  begin
    Response.Content :=
      '<html><body>' +
      '<script>alert("Número já cadastrado, por favor, informe outro!");</script>' +
      '<form action="/cadastrar" method="get">' +
      '<button type="submit">Voltar</button>' +
      '</form>' +
      '</body></html>';
    Exit;
  end;

  Numeros.Add(Numero);
  Nomes.Add(NomeStr);

  AlertaQtd := '';
  if Numeros.Count = 5 then
    AlertaQtd := '<script>alert("Alerta: 5 nomes cadastrados!");</script>';

  Response.Content :=
    '<html><body>' +
    AlertaQtd +
    '<script>alert("Cadastro realizado com sucesso!");</script>' +

    '<form action="/cadastrar" method="get">' +
    '<button type="submit">Cadastrar outro</button>' +
    '</form><br>' +

    '<form action="/" method="get">' +
    '<button type="submit">Voltar</button>' +
    '</form>' +

    '</body></html>';
end;

// Pesquisa
procedure TWebModule1.ActPesquisar(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  Entrada: string;
  NumerosPesq: TArray<string>;
  NumeroInt, i, j: Integer;
  Resultado: TStringList;
  Encontrou: Boolean;
begin
  Handled := True;
  Response.ContentType := 'text/html; charset=utf-8';

  if Request.Method = 'GET' then
  begin
    Response.Content :=
      '<html><body>' +
      '<h2>Pesquisar</h2>' +

      '<form method="POST" action="/pesquisar">' +
      'Digite números separados por vírgula:<br>' +
      '<input type="text" name="numeros" style="width:300px;"><br><br>' +
      '<button type="submit">Pesquisar</button>' +
      '</form><br>' +

      '<form action="/" method="get">' +
      '<button type="submit">Voltar</button>' +
      '</form>' +

      '</body></html>';
    Exit;
  end;

  Entrada := Request.ContentFields.Values['numeros'];
  Resultado := TStringList.Create;
  try
    NumerosPesq := Entrada.Split([',']);

    for i := 0 to Length(NumerosPesq) - 1 do
    begin
      if TryStrToInt(Trim(NumerosPesq[i]), NumeroInt) then
      begin
        Encontrou := False;
        for j := 0 to Numeros.Count - 1 do
          if Numeros[j] = NumeroInt then
          begin
            Resultado.Add(Nomes[j]);
            Encontrou := True;
            Break;
          end;

        if not Encontrou then
          Resultado.Add('Número ' + Trim(NumerosPesq[i]) + ' não cadastrado');
      end
      else
        Resultado.Add('Número inválido: ' + Trim(NumerosPesq[i]));
    end;

    Response.Content := '<html><body><h2>Resultado da Pesquisa</h2><ul>';
    for i := 0 to Resultado.Count - 1 do
      Response.Content := Response.Content + '<li>' + Resultado[i] + '</li>';
    Response.Content := Response.Content +
      '</ul>' +
      '<form action="/pesquisar" method="get">' +
      '<button type="submit">Nova pesquisa</button>' +
      '</form><br>' +
      '<form action="/" method="get">' +
      '<button type="submit">Voltar</button>' +
      '</form>' +
      '</body></html>';
  finally
    Resultado.Free;
  end;
end;

end.

