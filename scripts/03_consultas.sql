-- =========================================================
-- Consultas básicas de reconhecimento
-- =========================================================

select * from artistas a;

select * from usuarios u;

select * from musicas m;

select * from playlists p;

select count(*) AS total_artistas_brasileiros
from artistas
where pais_origem = 'Brasil';

select count(*) as usuarios_recife
from usuarios
where cidade = 'Recife';

-- =========================================================
-- CONSULTAS DESAFIO

-- =========================================================
-- 1. Quantidade de músicas por artista
-- =========================================================
select
    a.nome_artistico AS artista,
    count(m.musica_id) AS qnt_musicas
from artistas AS a
left join musicas as m
    on m.artista_id = a.artista_id
group by 
	a.artista_id,
    a.nome_artistico
order by
    qnt_musicas desc;

-- =========================================================
-- 2. Quantidade de playlists criadas por cada usuário, inclusive as zeradas
-- =========================================================
select 
	u.nome as usuario,
	count(p.playlist_id) as qnt_playlists
from usuarios as u
left join playlists as p
	on u.usuario_id  = p.usuario_id 
group by 
	u.usuario_id,
	u.nome
order by
	qnt_playlists DESC;

-- =========================================================
-- 3. calcular a quantidade de músicas existente em cada playlist;
-- =========================================================
SELECT
    p.nome AS playlist,
    u.nome AS usuario,
    COUNT(pm.musica_id) AS qnt_musicas
FROM playlists AS p
INNER JOIN usuarios AS u
    ON u.usuario_id = p.usuario_id
LEFT JOIN playlist_musica AS pm
    ON pm.playlist_id = p.playlist_id
GROUP BY
    p.playlist_id,
    p.nome,
    u.usuario_id,
    u.nome
ORDER BY
    qnt_musicas DESC,
    p.nome;

-- =========================================================
-- 4. identificar as músicas mais reproduzidas;
-- =========================================================
SELECT
    m.titulo AS musica,
    a.nome_artistico AS artista,
    COUNT(r.reproducao_id) AS total_reproducoes
FROM musicas AS m
INNER JOIN artistas AS a
    ON a.artista_id = m.artista_id
INNER JOIN reproducoes AS r
    ON r.musica_id = m.musica_id
GROUP BY
    m.musica_id,
    m.titulo,
    a.artista_id,
    a.nome_artistico
ORDER BY
    total_reproducoes DESC;

-- =========================================================
-- 5. Artistas com maior número de reproduções
-- =========================================================
SELECT
    a.nome_artistico AS artista,
    COUNT(r.reproducao_id) AS total_reproducoes
FROM artistas AS a
INNER JOIN musicas AS m
    ON m.artista_id = a.artista_id
INNER JOIN reproducoes AS r
    ON r.musica_id = m.musica_id
GROUP BY
    a.artista_id,
    a.nome_artistico
ORDER BY
    total_reproducoes DESC,
    artista;


-- =========================================================
-- 6. Tempo total ouvido por usuário
-- Considerando que cada reprodução corresponde à música inteira
-- e que a duração está armazenada em segundos
-- =========================================================
SELECT
    u.nome AS usuario,
    SUM(m.duracao_segundos) AS total_segundos,
    ROUND(SUM(m.duracao_segundos) / 60.0, 2) AS total_minutos,
    ROUND(SUM(m.duracao_segundos) / 3600.0, 2) AS total_horas
FROM usuarios AS u
INNER JOIN reproducoes AS r
    ON r.usuario_id = u.usuario_id
INNER JOIN musicas AS m
    ON m.musica_id = r.musica_id
GROUP BY
    u.usuario_id,
    u.nome
ORDER BY
    total_segundos DESC;


-- =========================================================
-- 7. Usuários que ainda não criaram playlists
-- =========================================================
SELECT
    u.usuario_id,
    u.nome AS usuario
FROM usuarios AS u
LEFT JOIN playlists AS p
    ON p.usuario_id = u.usuario_id
WHERE p.playlist_id IS NULL
ORDER BY
    u.nome;


-- =========================================================
-- 8. Músicas que nunca foram reproduzidas
-- =========================================================
SELECT
    m.musica_id,
    m.titulo AS musica,
    a.nome_artistico AS artista
FROM musicas AS m
INNER JOIN artistas AS a
    ON a.artista_id = m.artista_id
LEFT JOIN reproducoes AS r
    ON r.musica_id = m.musica_id
WHERE r.reproducao_id IS NULL
ORDER BY
    a.nome_artistico,
    m.titulo;


-- =========================================================
-- 9. Ranking das músicas mais escutadas
-- DENSE_RANK mantém a mesma posição para músicas empatadas
-- =========================================================
WITH total_por_musica AS (
    SELECT
        m.musica_id,
        m.titulo AS musica,
        a.nome_artistico AS artista,
        COUNT(r.reproducao_id) AS total_reproducoes
    FROM musicas AS m
    INNER JOIN artistas AS a
        ON a.artista_id = m.artista_id
    LEFT JOIN reproducoes AS r
        ON r.musica_id = m.musica_id
    GROUP BY
        m.musica_id,
        m.titulo,
        a.artista_id,
        a.nome_artistico
)
SELECT
    DENSE_RANK() OVER (
        ORDER BY total_reproducoes DESC
    ) AS posicao,
    musica,
    artista,
    total_reproducoes
FROM total_por_musica
ORDER BY
    posicao,
    musica;


-- =========================================================
-- 10. Quantidade de reproduções por gênero musical
-- =========================================================
SELECT
    m.genero,
    COUNT(r.reproducao_id) AS total_reproducoes
FROM musicas AS m
LEFT JOIN reproducoes AS r
    ON r.musica_id = m.musica_id
GROUP BY
    m.genero
ORDER BY
    total_reproducoes DESC,
    m.genero;
