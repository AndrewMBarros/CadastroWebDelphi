# 🚀 Desafio Delphi Web (WebBroker + Indy)

## 🎯 Objetivo do desafio
O objetivo deste projeto foi demonstrar a capacidade de aprender uma nova linguagem/tecnologia e transformar uma especificação em um programa funcional, mesmo sem experiência prévia.

O desafio consistia em criar um programa em Delphi com interface web, contendo dois botões:
- 🟢 **Cadastrar**
- 🔍 **Pesquisar**

Além disso, foi exigida a implementação de uma **API em Delphi** que apresentasse um alerta visual quando o cadastro atingisse **5 nomes**.

---

## 🧱 Arquitetura
O projeto utiliza:

### 🧩 WebBroker
Responsável por:
- 🌐 criar rotas (endpoints)
- 📩 receber requisições HTTP
- 🧾 gerar páginas HTML

### ⚙️ Indy (TIdHTTPWebBrokerBridge)
Responsável por:
- 🖥️ executar o servidor HTTP local
- 🔌 escutar a porta **8080**
- 🔗 conectar o WebBroker com o navegador

---

## 🔗 Rotas implementadas

| Rota | Método | Função |
|------|--------|--------|
| `/` | GET | 🏠 Página inicial com botões |
| `/cadastrar` | GET | 📝 Exibe formulário de cadastro |
| `/cadastrar` | POST | ✅ Processa cadastro |
| `/pesquisar` | GET | 🔍 Exibe formulário de pesquisa |
| `/pesquisar` | POST | 🔎 Processa pesquisa |

---

## ✅ Funcionalidades implementadas

### 📝 Cadastro
- 🧾 Exibe campos para número e nome  
- 🔗 Associa cada número a um nome  
- 📌 Permite cadastro de até **10 pares**  
- 🛡️ Validações:
  - 🔢 número inteiro obrigatório
  - 🧑‍💼 nome obrigatório
  - 🚫 número não duplicado
- ⚠️ Ao atingir **5 cadastros**, exibe um alerta visual (alert)

### 🔍 Pesquisa
- 🧮 Permite informar **um ou mais números**, separados por vírgula  
- 🧑‍🏫 Exibe os nomes associados a cada número  
- ❌ Informa quando um número não está cadastrado  
- ⚠️ Informa quando um número informado é inválido  

---

## 🔄 Como funciona o sistema (fluxo)

### 1) 📝 Cadastro
- Usuário clica em **Cadastrar**
- O sistema exibe o formulário
- Usuário envia número e nome
- O sistema valida e armazena em memória
- ⚠️ Ao atingir 5 cadastros, aparece alerta

### 2) 🔍 Pesquisa
- Usuário clica em **Pesquisar**
- O sistema exibe o formulário
- Usuário envia números separados por vírgula
- O sistema retorna os nomes correspondentes

---

## ▶️ Como executar

1. Abra o projeto no Delphi  
2. Execute o arquivo principal:

```bash
CadastroAPI.dpr
Abra o navegador e acesse:

http://localhost:8080/
⚠️ Observações importantes
💾 Os dados são armazenados em memória, usando listas (TList<Integer> e TList<string>).

🔁 Ao reiniciar o servidor, todos os cadastros são perdidos.

🧩 Para persistência real, seria necessário usar banco de dados ou arquivo.

🛠️ Tecnologias utilizadas

Delphi 12 (Object Pascal)

WebBroker

Indy (TIdHTTPWebBrokerBridge)
👤 Autor
Andrew Matheus

🔗 [LinkedIn](https://www.linkedin.com/in/andrewmbs/)

---
