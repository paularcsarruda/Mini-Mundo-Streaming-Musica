-- =========================================================
-- PROJETO: PLATAFORMA DE STREAMING DE MÚSICA
-- BANCO DE DADOS: PostgreSQL
-- =========================================================


-- =========================================================
-- 1. TIPO ENUM PARA OS PLANOS
-- =========================================================

CREATE TYPE tipo_plano AS ENUM (
    'gratuito',
    'premium',
    'familia'
);


-- =========================================================
-- 2. TABELA USUARIOS
-- =========================================================

CREATE TABLE usuarios (
    usuario_id INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    plano tipo_plano NOT NULL DEFAULT 'gratuito',
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
    cidade VARCHAR(100),

    CONSTRAINT pk_usuarios
        PRIMARY KEY (usuario_id),

    CONSTRAINT uq_usuarios_email
        UNIQUE (email)
);


-- =========================================================
-- 3. TABELA ARTISTAS
-- =========================================================

CREATE TABLE artistas (
    artista_id INTEGER GENERATED ALWAYS AS IDENTITY,
    nome_artistico VARCHAR(120) NOT NULL,
    genero_principal VARCHAR(80) NOT NULL,
    pais_origem VARCHAR(80),

    CONSTRAINT pk_artistas
        PRIMARY KEY (artista_id)
);


-- =========================================================
-- 4. TABELA MUSICAS
-- =========================================================

CREATE TABLE musicas (
    musica_id INTEGER GENERATED ALWAYS AS IDENTITY,
    titulo VARCHAR(150) NOT NULL,
    artista_id INTEGER NOT NULL,
    genero VARCHAR(80) NOT NULL,
    duracao_segundos INTEGER NOT NULL,
    ano_lancamento INTEGER,

    CONSTRAINT pk_musicas
        PRIMARY KEY (musica_id),

    CONSTRAINT fk_musicas_artistas
        FOREIGN KEY (artista_id)
        REFERENCES artistas (artista_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT ck_musicas_duracao
        CHECK (duracao_segundos > 0),

    CONSTRAINT ck_musicas_ano
        CHECK (
            ano_lancamento IS NULL
            OR ano_lancamento BETWEEN 1900 AND 2100
        )
);


-- =========================================================
-- 5. TABELA PLAYLISTS
-- =========================================================

CREATE TABLE playlists (
    playlist_id INTEGER GENERATED ALWAYS AS IDENTITY,
    usuario_id INTEGER NOT NULL,
    nome VARCHAR(120) NOT NULL,
    data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT pk_playlists
        PRIMARY KEY (playlist_id),

    CONSTRAINT fk_playlists_usuarios
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- =========================================================
-- 6. TABELA ASSOCIATIVA PLAYLIST_MUSICA
-- =========================================================

CREATE TABLE playlist_musica (
    playlist_id INTEGER NOT NULL,
    musica_id INTEGER NOT NULL,
    data_adicao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_playlist_musica
        PRIMARY KEY (playlist_id, musica_id),

    CONSTRAINT fk_playlist_musica_playlist
        FOREIGN KEY (playlist_id)
        REFERENCES playlists (playlist_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_playlist_musica_musica
        FOREIGN KEY (musica_id)
        REFERENCES musicas (musica_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- =========================================================
-- 7. TABELA REPRODUCOES
-- =========================================================

CREATE TABLE reproducoes (
    reproducao_id INTEGER GENERATED ALWAYS AS IDENTITY,
    usuario_id INTEGER NOT NULL,
    musica_id INTEGER NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duracao_ouvida_segundos INTEGER NOT NULL,

    CONSTRAINT pk_reproducoes
        PRIMARY KEY (reproducao_id),

    CONSTRAINT fk_reproducoes_usuarios
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios (usuario_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_reproducoes_musicas
        FOREIGN KEY (musica_id)
        REFERENCES musicas (musica_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT ck_reproducoes_duracao
        CHECK (duracao_ouvida_segundos >= 0)
);


-- =========================================================
-- 8. ÍNDICES
-- =========================================================

CREATE INDEX idx_musicas_artista
    ON musicas (artista_id);

CREATE INDEX idx_playlists_usuario
    ON playlists (usuario_id);

CREATE INDEX idx_reproducoes_usuario
    ON reproducoes (usuario_id);

CREATE INDEX idx_reproducoes_musica
    ON reproducoes (musica_id);

CREATE INDEX idx_reproducoes_data_hora
    ON reproducoes (data_hora);

CREATE INDEX idx_playlist_musica_musica
    ON playlist_musica (musica_id);