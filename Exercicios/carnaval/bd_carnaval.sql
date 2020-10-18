use master

create database carnaval;

use carnaval;

create table escolas(
    id int not null identity,
    nome varchar(64),
    total_pontos decimal(3,1),
    primary key (id)
);

create table quesitos(
    id int not null identity,
    nome varchar(32),
    primary key (id)
);

create table jurados(
    id int not null identity,
    nome varchar(128),
    primary key (id)
);

create table quesitos_jurados_notas(
    id_nota int not null,
    id_quesito int not null,
    id_jurado int not null,
    primary key (id_nota, id_quesito, id_jurado),
    foreign key (id_jurado) references jurados(id),
    foreign key (id_quesito) references quesitos(id),
    foreign key (id_nota) references notas(id)
);

create table notas(
    id int not null identity,
    id_escola int not null,
    nota decimal(3,1),
    posicao int not null
    primary key (id),
    foreign key (id_escola) references escolas (id)
)

insert into escolas (nome, total_pontos)
values ('Acadêmicos do Tatuapé', 0),
       ('Rosas de Ouro', 0),
       ('Mancha Verde', 0),
       ('Vai-Vai', 0),
       ('X-9 Paulistana', 0),
       ('Dragões da Real', 0),
       ('Águia de Ouro', 0),
       ('NenÊ de Vila Matilde', 0),
       ('Gaviões da Fiel', 0),
       ('Mocidade Alegre', 0),
       ('Tom Maior', 0),
       ('Unidos de Vila Maria', 0),
       ('Acadêmicos do Tucuruvi', 0),
       ('Império de Casa Verde', 0);

insert into quesitos
values ('Comissão de Frente'),
       ('Evolução'),
       ('Fantasia'),
       ('Bateria'),
       ('Alegoria'),
       ('Harmonia'),
       ('Samba-Enredo'),
       ('Mestre-Sala e Porta-Bandeira'),
       ('Enredo');

insert into jurados
values ('Raizer Varela'),
       ('Caique Vidal'),
       ('Gustavo Alves'),
       ('Victor Neves'),
       ('Júlio Barcelos')

create procedure sp_inserirNota(
    @id_jurado int,
    @id_quesito int,
    @id_escola int,
    @nota decimal(3,1)
    )
as
begin
    declare @id_nota int
    declare @posicao_nota int

    set @posicao_nota = ((select dbo.fn_qtdNotasQuesito(@id_escola)) % 5) + 1

    insert into notas values(@id_escola, @nota, @posicao_nota)
    set @id_nota = (select MAX(n.id) from notas n)

    insert into quesitos_jurados_notas values (@id_nota, @id_quesito, @id_jurado)

    exec sp_notaTotalEscola @id_escola
end
go;

create function fn_qtdNotasQuesito(
    @id_escola int
)
returns int
as
begin
    return (select count(n.id) as qtd_notas from notas n
            inner join escolas e on e.id = n.id_escola
            inner join quesitos_jurados_notas qjn on qjn.id_nota = n.id
            inner join jurados j on j.id = qjn.id_jurado
            where e.id = @id_escola)
end
go;

create function fn_notaQuesitoEscolaPosicao(
    @id_escola int,
    @id_quesito int,
    @posicao int
)
returns decimal(3,1)
as
begin
    return (select n.nota from notas n
            inner join quesitos_jurados_notas qjn
              on qjn.id_nota = n.id
            where id_escola = @id_escola and n.posicao = @posicao
              and qjn.id_quesito = @id_quesito)
end
go;

create function fn_mediaNotasQuesitoEscola(
    @id_escola int,
    @id_quesito int
)
returns decimal(3,1)
as
begin
    return (select AVG(n.nota) from notas n
    left outer join quesitos_jurados_notas qjn
    on qjn.id_nota = n.id
    where n.nota != (select MAX(n.nota) from notas n
            inner join quesitos_jurados_notas qjn
              on qjn.id_nota = n.id
            where id_escola = @id_escola
              and qjn.id_quesito = @id_quesito)
        and n.nota != (select MIN(n.nota) from notas n
            inner join quesitos_jurados_notas qjn
              on qjn.id_nota = n.id
            where id_escola = @id_escola
              and qjn.id_quesito = @id_quesito))
end
go;

select AVG(n.nota) from notas n
    inner join quesitos_jurados_notas qjn
    on qjn.id_nota = n.id
    where n.nota != (select MAX(n.nota) from notas n
            inner join quesitos_jurados_notas qjn
              on qjn.id_nota = n.id
            where id_escola = 1
              and qjn.id_quesito = 1)
        and n.nota != (select MIN(n.nota) from notas n
            inner join quesitos_jurados_notas qjn
              on qjn.id_nota = n.id
            where id_escola = 1
              and qjn.id_quesito = 1)
drop function fn_tabelaNotasQuesitoEscola
create function fn_tabelaNotasQuesitoEscola(
    @id_escola int,
    @id_quesito int
)
returns @tabela table(
    id int identity,
    escola varchar(64),
    quesito varchar(32),
    nota1 decimal(3,1),
    nota2 decimal(3,1),
    nota3 decimal(3,1),
    nota4 decimal(3,1),
    nota5 decimal(3,1),
    maior_nota decimal(3,1),
    menor_nota decimal(3,1),
    nota_final decimal(3,1)
    )
as
begin
    insert into @tabela(quesito)
            select q.nome from quesitos q
            where q.id = @id_quesito

    update @tabela set escola = (select e.nome from escolas e where e.id = @id_escola)

    update @tabela set nota1 = (select dbo.fn_notaQuesitoEscolaPosicao(@id_escola,@id_quesito, 1))

    update @tabela set nota2 = (select dbo.fn_notaQuesitoEscolaPosicao(@id_escola,@id_quesito, 2))

    update @tabela set nota3 = (select dbo.fn_notaQuesitoEscolaPosicao(@id_escola,@id_quesito, 3))

    update @tabela set maior_nota = (select MAX(n.nota) from notas n inner join quesitos_jurados_notas j on j.id_nota = n.id where n.id_escola = @id_escola and j.id_quesito = @id_quesito)
    update @tabela set menor_nota = (select MIN(n.nota) from notas n inner join quesitos_jurados_notas j on j.id_nota = n.id where n.id_escola = @id_escola and j.id_quesito = @id_quesito)

    update @tabela set nota4 = (select dbo.fn_notaQuesitoEscolaPosicao(@id_escola,@id_quesito, 4))

    update @tabela set maior_nota = (select MAX(n.nota) from notas n inner join quesitos_jurados_notas j on j.id_nota = n.id where n.id_escola = @id_escola and j.id_quesito = @id_quesito)
    update @tabela set menor_nota = (select MIN(n.nota) from notas n inner join quesitos_jurados_notas j on j.id_nota = n.id where n.id_escola = @id_escola and j.id_quesito = @id_quesito)

    update @tabela set nota5 = (select dbo.fn_notaQuesitoEscolaPosicao(@id_escola,@id_quesito, 5))

    update @tabela set maior_nota = (select MAX(n.nota) from notas n inner join quesitos_jurados_notas j on j.id_nota = n.id where n.id_escola = @id_escola and j.id_quesito = @id_quesito)
    update @tabela set menor_nota = (select MIN(n.nota) from notas n inner join quesitos_jurados_notas j on j.id_nota = n.id where n.id_escola = @id_escola and j.id_quesito = @id_quesito)

        update @tabela set nota_final = (select dbo.fn_mediaNotasQuesitoEscola(@id_escola,@id_quesito))

    return
end
go;

create procedure sp_notaTotalEscola(
    @id_escola int
)
as
begin
    declare @qtdTotalNotas int
    declare @totalNotas decimal(3,1)
    declare @mediaNotas decimal(3,1)
    declare @i int

    select nota from notas n
    inner join escolas e on e.id = n.id_escola where e.id = @id_escola;

    set @qtdTotalNotas = dbo.fn_qtdNotasQuesito(@id_escola)

    if @qtdTotalNotas = 45
    begin
        set @i = 1
        while @i <= 9
        begin
            set @totalNotas = @totalNotas + (select nota_final from dbo.fn_tabelaNotasQuesitoEscola (@id_escola,@i))

            set @i = @i + 1
        end
        set @mediaNotas = @totalNotas / 9
        update escolas set total_pontos = @mediaNotas where id = @id_escola
    end
end
go;

create function fn_quesitosRestantes(
    @id_jurado int,
    @id_escola int
)
returns @tabela table (
    id int,
    quesito varchar(32)
    )
as
begin
    insert into @tabela
        select q.id, q.nome from quesitos q
            inner join quesitos_jurados_notas qjn
                on q.id = qjn.id_quesito
            where ( select COUNT(n.id) from notas n
                        inner join quesitos_jurados_notas qjn
                            on n.id = qjn.id_nota
                        where qjn.id_jurado = @id_jurado and n.id_escola = @id_escola
                ) < 5
    return
end
go;

create function fn_escolasRestantes()
returns @tabela table (
    id int,
    escola varchar(32),
    total decimal(3,1)
    )
as
begin
    insert into @tabela
        select e.id, e.nome, e.total_pontos from escolas e
            inner join notas n on e.id = n.id_escola
            inner join quesitos_jurados_notas qjn
                on n.id = qjn.id_nota
            group by e.id, e.nome, e.total_pontos
            having COUNT(n.id) < 60
    return
end
go;

-- Não ta funcionando ;-; tenho que pensar como arrumar ainda
create function fn_juradosRestantes(
    @id_escola int
)
returns @tabela table(
    id int,
    nome varchar(128)
)
as
begin
    insert into @tabela
        select j.id, j.nome from jurados j
        inner join quesitos_jurados_notas qjn
            on j.id = qjn.id_jurado
        where (select COUNT(q.id) from quesitos q
            inner join quesitos_jurados_notas qjn
                on q.id = qjn.id_quesito
            inner join notas n
                on n.id = qjn.id_nota
            where n.id_escola = @id_escola) < 9
end
go;

-- Jurados restantes
select j.id, j.nome from jurados j
    left join quesitos_jurados_notas qjn on j.id = qjn.id_jurado
    left join notas n on n.id = qjn.id_nota
    where n.id_escola = 2
    group by j.id, j.nome

    having COUNT(j.id) < 9

-- Testes

exec sp_inserirNota 5,1,1,9.9

select dbo.fn_qtdNotasQuesito (1) % 5

select * from dbo.fn_tabelaNotasQuesitoEscola(1,2)

select dbo.fn_mediaNotasQuesitoEscola (1,2)

select * from escolas;
select * from quesitos_jurados_notas
select * from notas;