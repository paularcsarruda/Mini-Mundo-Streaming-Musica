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
select
    p.nome as playlist,
    u.nome as usuario,
    count(pm.musica_id) as qnt_musicas
from playlists as p
inner join usuarios as u
    on u.usuario_id = p.usuario_id
left join playlist_musica as pm
    on pm.playlist_id = p.playlist_id
group by
    p.playlist_id,
    p.nome,
    u.usuario_id,
    u.nome
order by
    qnt_musicas desc,
    p.nome;

-- =========================================================
-- 4. identificar as músicas mais reproduzidas;
-- =========================================================
select
    m.titulo as musica,
    a.nome_artistico as artista,
    count(r.reproducao_id) as total_reproducoes
from musicas as m
inner join artistas as a
    on a.artista_id = m.artista_id
inner join reproducoes as r
    on r.musica_id = m.musica_id
group by
    m.musica_id,
    m.titulo,
    a.artista_id,
    a.nome_artistico
order by
    total_reproducoes desc;

-- =========================================================
-- 5. Artistas com maior número de reproduções
-- =========================================================
select
    a.nome_artistico as artista,
    count(r.reproducao_id) as total_reproducoes
from artistas as a
inner join musicas as m
    on m.artista_id = a.artista_id
inner join reproducoes as r
    on r.musica_id = m.musica_id
group by
    a.artista_id,
    a.nome_artistico
order by
    total_reproducoes desc,
    artista;


-- =========================================================
-- 6. Tempo total ouvido por usuário
-- =========================================================
select
    u.nome as usuario,
    SUM(m.duracao_segundos) as total_segundos,
    ROUND(SUM(m.duracao_segundos) / 60.0, 2) as total_minutos,
    ROUND(SUM(m.duracao_segundos) / 3600.0, 2) as total_horas
from usuarios as u
inner join reproducoes as r
    on r.usuario_id = u.usuario_id
inner join musicas as m
    ON m.musica_id = r.musica_id
group by
    u.usuario_id,
    u.nome
order by
    total_segundos desc;


-- =========================================================
-- 7. Usuários que ainda não criaram playlists
-- =========================================================
select
    u.usuario_id,
    u.nome as usuario
from usuarios as u
left join playlists as p
    on p.usuario_id = u.usuario_id
where p.playlist_id is null
order by
    u.nome;


-- =========================================================
-- 8. Músicas que nunca foram reproduzidas
-- =========================================================
select
    m.musica_id,
    m.titulo as musica,
    a.nome_artistico as artista
from musicas as m
inner join artistas as a
    on a.artista_id = m.artista_id
left join reproducoes as r
    on r.musica_id = m.musica_id
where r.reproducao_id is null
order by
    a.nome_artistico,
    m.titulo;


-- =========================================================
-- 9. Ranking das músicas mais escutadas
-- DENSE_RANK mantém a mesma posição para músicas empatadas
-- =========================================================
with total_por_musica as (
    select
        m.musica_id,
        m.titulo as musica,
        a.nome_artistico as artista,
        count(r.reproducao_id) as total_reproducoes
    from musicas as m
    inner join artistas as a
        on a.artista_id = m.artista_id
    left join reproducoes as r
        on r.musica_id = m.musica_id
    group by
        m.musica_id,
        m.titulo,
        a.artista_id,
        a.nome_artistico
)
select
    DENSE_RANK() OVER (
        order by total_reproducoes desc
    ) as posicao,
    musica,
    artista,
    total_reproducoes
from total_por_musica
order by
    posicao,
    musica;


-- =========================================================
-- 10. Quantidade de reproduções por gênero musical
-- =========================================================
select
    m.genero,
    count(r.reproducao_id) as total_reproducoes
from musicas as m
left join reproducoes as r
    on r.musica_id = m.musica_id
group by
    m.genero
order by
    total_reproducoes desc,
    m.genero;
