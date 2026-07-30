<h1 align="center">🎵 Plataforma de Streaming de Música</h1>

<p align="center">
  <strong>Desafio Final — Módulo 2 | Banco de Dados</strong>
</p>

<p align="center">
  Projeto de modelagem e implementação de um banco de dados relacional para uma plataforma fictícia de streaming de música.
</p>

---

## 📌 Sobre o projeto

Este projeto apresenta a modelagem de um banco de dados para uma plataforma de streaming de música, permitindo o gerenciamento de usuários, artistas, músicas, playlists e reproduções.

A proposta foi desenvolvida com foco em:

* modelagem de dados;
* normalização;
* integridade referencial;
* relacionamentos entre entidades;
* criação e manipulação de dados;
* desenvolvimento de consultas SQL aplicadas a situações reais.

O banco de dados permite representar desde o cadastro de usuários e artistas até a criação de playlists e o registro do histórico de reprodução das músicas.

---

## 🌎 Mini-mundo

A plataforma permite que usuários criem uma conta, escolham um plano e escutem músicas cadastradas por diferentes artistas.

Cada artista pode possuir várias músicas, enquanto cada música pertence a um único artista.

Os usuários podem criar diversas playlists e adicionar diferentes músicas a cada uma delas. Uma mesma música também pode estar presente em várias playlists, caracterizando um relacionamento muitos-para-muitos.

Além disso, cada reprodução realizada por um usuário é registrada, armazenando informações como a música escutada, a data e o horário da reprodução e o tempo total ouvido.

Com esses dados, é possível analisar:

* músicas mais reproduzidas;
* artistas mais populares;
* gêneros mais escutados;
* comportamento dos usuários;
* duração média das reproduções;
* quantidade de músicas por playlist;
* usuários que ainda não criaram playlists;
* músicas que nunca foram reproduzidas.

---

## 🗃️ Entidades

O banco de dados é composto por seis tabelas principais.

### `usuarios`

Armazena as informações dos usuários cadastrados na plataforma.

| Campo           | Descrição                      |
| --------------- | ------------------------------ |
| `usuario_id`    | Identificador único do usuário |
| `nome`          | Nome do usuário                |
| `email`         | E-mail utilizado no cadastro   |
| `plano`         | Plano contratado pelo usuário  |
| `data_cadastro` | Data de criação da conta       |
| `cidade`        | Cidade do usuário              |

### `artistas`

Armazena os dados dos artistas disponíveis na plataforma.

| Campo              | Descrição                      |
| ------------------ | ------------------------------ |
| `artista_id`       | Identificador único do artista |
| `nome_artistico`   | Nome artístico                 |
| `genero_principal` | Principal gênero musical       |
| `pais_origem`      | País de origem                 |

### `musicas`

Armazena as músicas cadastradas na plataforma.

| Campo              | Descrição                       |
| ------------------ | ------------------------------- |
| `musica_id`        | Identificador único da música   |
| `titulo`           | Título da música                |
| `artista_id`       | Artista responsável pela música |
| `genero`           | Gênero musical                  |
| `duracao_segundos` | Duração total em segundos       |
| `ano_lancamento`   | Ano de lançamento               |

### `playlists`

Armazena as playlists criadas pelos usuários.

| Campo          | Descrição                         |
| -------------- | --------------------------------- |
| `playlist_id`  | Identificador único da playlist   |
| `usuario_id`   | Usuário responsável pela playlist |
| `nome`         | Nome da playlist                  |
| `data_criacao` | Data de criação                   |

### `playlist_musica`

Tabela associativa responsável pelo relacionamento muitos-para-muitos entre playlists e músicas.

| Campo         | Descrição                           |
| ------------- | ----------------------------------- |
| `playlist_id` | Identificador da playlist           |
| `musica_id`   | Identificador da música             |
| `data_adicao` | Data em que a música foi adicionada |

### `reproducoes`

Registra as músicas reproduzidas pelos usuários.

| Campo                     | Descrição                         |
| ------------------------- | --------------------------------- |
| `reproducao_id`           | Identificador único da reprodução |
| `usuario_id`              | Usuário que realizou a reprodução |
| `musica_id`               | Música reproduzida                |
| `data_hora`               | Data e horário da reprodução      |
| `duracao_ouvida_segundos` | Tempo ouvido pelo usuário         |

---

## 🔗 Relacionamentos

O modelo possui os seguintes relacionamentos:

* um artista pode possuir várias músicas;
* uma música pertence a um único artista;
* um usuário pode criar várias playlists;
* uma playlist pertence a um único usuário;
* um usuário pode realizar várias reproduções;
* uma música pode possuir várias reproduções;
* uma playlist pode conter várias músicas;
* uma música pode estar presente em várias playlists.

O relacionamento muitos-para-muitos entre `playlists` e `musicas` é resolvido pela tabela associativa `playlist_musica`.

---
## 🛠️ Tecnologias utilizadas

* PostgreSQL;
* SQL;
* DBeaver;
* dbdiagram.io;
* Git;
* GitHub.

---

## 📁 Estrutura do repositório

```text
streaming-musica/
│
├── docs/
│   └── diagrama-er.png
│
├── scripts/
│   ├── 01_ddl.sql
│   ├── 02_dml.sql
│   └── 03_consultas.sql
│
├── README.md
└── LICENSE
```

### Arquivos

* `01_ddl.sql`: criação das tabelas, chaves e restrições;
* `02_dml.sql`: inserção dos registros utilizados no projeto;
* `03_consultas.sql`: consultas desenvolvidas para análise dos dados;
* `diagrama-er.png`: representação visual do modelo entidade-relacionamento.

---

## 🔍 Consultas desenvolvidas

O projeto contém dez consultas SQL baseadas em possíveis necessidades da plataforma.

Entre as análises desenvolvidas estão:

1. músicas e seus respectivos artistas;
2. playlists criadas por cada usuário, inclusive as zeradas;
3. calcular a quantidade de músicas existente em cada playlist;
4. identificar as músicas mais reproduzidas;
5. encontrar os artistas com maior número de reproduções;
6. calcular o tempo total ouvido por usuário;
7. identificar usuários que ainda não criaram playlists;
8. encontrar músicas que nunca foram reproduzidas;
9. criar um ranking das músicas mais escutadas;
10. analisar a quantidade de reproduções por gênero musical.

As consultas utilizam recursos como:

* filtros com `WHERE`;
* funções de agregação;
* `GROUP BY`;
* `ORDER BY`;
* múltiplos `JOIN`;
* `LEFT JOIN`;
* subconsultas;
* Common Table Expressions, ou CTEs;
* Window Functions.

---

## ▶️ Como executar o projeto

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/streaming-musica.git
```

### 2. Acesse a pasta do projeto

```bash
cd streaming-musica
```

### 3. Crie o banco de dados

No PostgreSQL, crie um banco de dados para o projeto.

```sql
CREATE DATABASE streaming_musica;
```

### 4. Execute os scripts

Execute os arquivos SQL na seguinte ordem:

```text
01_ddl.sql
02_dml.sql
03_consultas.sql
```

Os scripts podem ser executados pelo DBeaver, pelo terminal do PostgreSQL ou por outra ferramenta compatível.

---

## 🎓 Contexto acadêmico

Projeto desenvolvido como desafio final do Módulo 2, contemplando os seguintes requisitos:

* criação de um mini-mundo autoral;
* elaboração de diagrama entidade-relacionamento;
* criação de quatro ou mais tabelas;
* implementação de relacionamento muitos-para-muitos;
* criação de script DDL;
* criação de script DML;
* inserção de no mínimo cinco registros por tabela;
* inclusão de registros sem correspondência;
* desenvolvimento de dez consultas práticas;
* aplicação de filtros;
* utilização de funções de agregação;
* utilização de `GROUP BY`;
* utilização de múltiplos `JOIN`;
* utilização de `LEFT JOIN`;
* utilização de CTE;
* utilização de Window Function.

---
## ⚠️ Aviso

Este projeto não possui finalidade comercial.

Os nomes, usuários, artistas, músicas e demais informações utilizadas no banco de dados são fictícios ou foram incluídos exclusivamente para fins educacionais.

---

<p align="center">
  Desenvolvido para fins de estudo e prática de Banco de Dados.
</p>
