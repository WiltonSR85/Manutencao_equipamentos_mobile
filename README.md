# Controle de Manutenção de Equipamentos - Cliente Flutter

## Objetivo

Este aplicativo Flutter é o cliente mobile do sistema de controle de manutenção de equipamentos, desenvolvido para facilitar o acesso e gerenciamento dos recursos da instituição. Ele consome a API RESTful criada com Django Rest Framework (DRF), utilizando autenticação JWT para garantir segurança nas operações.

---

## Projeto Backend (API Django)

Este aplicativo consome a API desenvolvida em Django.  
Acesse o repositório do backend para instruções de instalação, endpoints e documentação:

- [Repositório da API Django](https://github.com/WiltonSR85/Controle-Manuten-o-de-equipamentos)

---

## Como Executar o Cliente Flutter

1. **Pré-requisitos:**
   - [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
   - Emulador Android ou dispositivo físico conectado

2. **Instalação:**
   - Clone o repositório ou extraia os arquivos do projeto.
   - Acesse a pasta do cliente Flutter pelo terminal.

3. **Instale as dependências do Flutter:**
   ```sh
   flutter pub get
   ```

4. **Configure a URL da API:**
   - Certifique-se de que o endereço da API Django está correto nos arquivos de serviço do Flutter (geralmente em `lib/services/`).
   - Se estiver rodando o app em um emulador Android, utilize o IP `10.0.2.2` para acessar o backend local.

5. **Execute o aplicativo:**
   - Para rodar no emulador Android:
     ```sh
     flutter run
     ```
   - Para rodar em um dispositivo físico:
     ```sh
     flutter devices
     flutter run -d <id_do_dispositivo>
     ```

---

## Funcionalidades

- Autenticação de usuários via JWT
- CRUD completo para Equipamentos, Peças e Técnicos
- Interface intuitiva para login, listagem, criação, edição e exclusão dos recursos
- Consumo seguro das rotas protegidas da API
- Refresh automático do token JWT quando necessário

---

## Integração com a API Django

- **Obtenção do token JWT:**  
  O login é realizado enviando usuário e senha para `/api/token/`.
- **Acesso às rotas protegidas:**  
  O token JWT é enviado no header das requisições.
- **Renovação do token:**  
  O app renova o token automaticamente quando necessário.

Para mais detalhes sobre a API, consulte a [documentação Swagger](http://localhost:8000/swagger/) ou [Redoc](http://localhost:8000/redoc/).

---

## Equipe

- Álex Silva Costa
- Luísa Mel Almeida Martins
- Wilton Silva Rodrigues

---

## Link do vídeo

LINK: [Trabalho Final WEB I]()

---

Se precisar de exemplos de requisições ou integração, consulte a documentação da API ou entre em contato com os desenvolvedores.