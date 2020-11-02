use master;

create database exercicio_b

use exercicio_b

create table cursos (
    codigo int not null identity(0,1),
    nome varchar(128) not null,
    duracao int not null,
    primary key (codigo)
)

create table disciplinas (
    codigo int not null identity (1,1),
    nome varchar(128) not null,
    carga_horaria int not null,
    primary key (codigo)
)

create table disciplinas_cursos (
    codigo_disciplina int not null,
    codigo_curso int not null,
    primary key (codigo_disciplina, codigo_curso),
    foreign key (codigo_disciplina) references disciplinas(codigo),
    foreign key (codigo_curso) references cursos(codigo)
)

insert into cursos
values ('Análise e Desenvolvimento de Sistemas', 2880),
       ('Logistica', 2880),
       ('Polímeros', 2880),
       ('Comércio Exterior', 2600),
       ('Gestão Empresarial', 2600)

insert into disciplinas
values ('Algoritmos', 80),
       ('Administração', 80),
       ('Laboratório de Hardware', 40),
       ('Pesquisa Operacional', 80),
       ('Física I', 80),
       ('Físico Química', 80),
       ('Comércio Exterior', 80),
       ('Fundamentos de Marketing', 80),
       ('Informática', 40),
       ('Sistemas de Informação', 80)

insert into disciplinas_cursos
values (1, 0),
       (2, 0),
       (2, 1),
       (2, 3),
       (2, 4),
       (3, 0),
       (4, 1),
       (5, 2),
       (6, 2),
       (7, 1),
       (7, 3),
       (8, 1),
       (8, 4),
       (9, 1),
       (9, 3),
       (10, 0),
       (10, 4)

/*
    Criar uma UDF (Function) cuja entrada é o código do curso e, com um cursor, monte uma
    tabela de saída com as informações do curso que é parâmetro de entrada.

    (Código_Disciplina | Nome_Disciplina | Carga_Horaria_Disciplina | Nome_Curso)
*/
create function fn_tabelaCurso (@codigo_curso int)
returns @tabela table (
    codigo_disciplina int,
    nome_disciplina varchar(128),
    carga_horaria int,
    nome_curso varchar(128)
) as
begin
    declare @codigo_disciplina int,
        @nome_disciplina varchar(128),
        @carga_horaria int,
        @nome_curso varchar(128)
    declare c cursor for select d.codigo, d.nome, d.carga_horaria, c.nome from disciplinas d
        inner join disciplinas_cursos dc on d.codigo = dc.codigo_disciplina
        inner join cursos c on c.codigo = dc.codigo_curso
        where c.codigo = @codigo_curso
        order by d.nome asc
    open c
    fetch next from c into @codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso

    while @@fetch_status = 0
    begin
        insert into @tabela values (@codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso)
        fetch next from c into @codigo_disciplina, @nome_disciplina, @carga_horaria, @nome_curso
    end
    close c
    deallocate c

    return
end

select * from fn_tabelaCurso (0)