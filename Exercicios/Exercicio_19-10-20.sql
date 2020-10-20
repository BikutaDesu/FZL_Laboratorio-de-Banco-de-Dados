/*
Considere um quadrangular final de times de volei com 4 times
Time 1, Time 2 Time 3 e Time 4
Todos jogarão contra todos.
Os resultados dos jogos serão armazenados em uma tabela

Tabela times
(Cod Time | Nome Time)
1 Time 1
2 Time 2
3 Time 3
4 Time 4

Jogos
(Cod Time A | Cod Time B | Set Time A | Set Time B)

Considera-se vencedor o time que fez 3 de 5 sets.
Se a vitória for por 3 x 2, o time vencedor ganha 2 pontos e o time perdedor ganha 1.
Se a vitória for por 3 x 0 ou 3 x 1, o vencedor ganha 3 pontos e o perdedor, 0.
*/

create database volei
use volei

create table times
(
    id   integer     not null identity,
    nome varchar(64) not null
        primary key (id)
)

create table jogos
(
    id_time_casa   int not null,
    id_time_fora   int not null,
    sets_time_casa int,
    sets_time_fora int,
    primary key (id_time_casa, id_time_fora),
    foreign key (id_time_casa) references times (id),
    foreign key (id_time_fora) references times (id)
)

insert into times
values ('Time 1'),
       ('Time 2'),
       ('Time 3'),
       ('Time 4')

/*
Fazer uma UDF que apresente:
(Nome Time | Total Pontos | Total Sets Ganhos | Total Sets Perdidos | Set Average (Ganhos - perdidos))
*/
create function fn_tabelaJogos()
    returns @tabela table
                    (
                        id_time             int,
                        nome_time           varchar(64),
                        total_pontos        int,
                        total_sets_ganhos   int,
                        total_sets_perdidos int,
                        average_sets        int
                    )
as
begin

    insert into @tabela (id_time, nome_time) select t.id, t.nome from times t

    update @tabela set total_pontos = (select dbo.fn_totalPontos(id_time))

    update @tabela
    set total_sets_ganhos = (select dbo.fn_totalSetsGanhos(id_time))

    update @tabela
    set total_sets_perdidos = (select dbo.fn_totalSetsPerdidos(id_time))

    update @tabela set average_sets = total_sets_ganhos - total_sets_perdidos

    return
end

create function fn_totalSetsGanhos(@id_time int)
    returns int
as
begin

    return (select case when sum(sets_time_casa) is null then 0 else sum(sets_time_casa) end
            from jogos
            where id_time_casa = @id_time) +
           (select case when sum(sets_time_fora) is null then 0 else sum(sets_time_fora) end
            from jogos
            where id_time_fora = @id_time)
end

create function fn_totalSetsPerdidos(@id_time int)
    returns int
as
begin

    return (select case when sum(sets_time_casa) is null then 0 else sum(sets_time_casa) end
            from jogos
            where id_time_fora = @id_time) +
           (select case when sum(sets_time_fora) is null then 0 else sum(sets_time_fora) end
            from jogos
            where id_time_casa = @id_time)

end

create function fn_totalPontos(@id_time int)
    returns int
as
begin
    return (
        select sum(
                       case
                           when sets_time_casa = 3 and sets_time_fora = 2 and id_time_casa = @id_time then 3
                           when sets_time_fora = 3 and sets_time_casa = 2 and id_time_casa = @id_time then 2

                           when sets_time_casa = 3 and sets_time_fora = 2 and id_time_fora = @id_time then 2
                           when sets_time_fora = 3 and sets_time_casa = 2 and id_time_fora = @id_time then 3

                           when sets_time_casa >= 3 and sets_time_fora < 2 and id_time_casa = @id_time then 3
                           when sets_time_fora >= 3 and sets_time_casa < 2 and id_time_casa = @id_time then 0

                           when sets_time_casa >= 3 and sets_time_fora < 2 and id_time_fora = @id_time then 0
                           when sets_time_fora >= 3 and sets_time_casa < 2 and id_time_fora = @id_time then 3
                           end
                   ) as pontos
        from jogos
        where id_time_casa = @id_time
           or id_time_fora = @id_time)
end


/*
Fazer uma trigger que verifique se os inserts dos sets estão corretos (Máximo 5 sets, sendo que o vencedor tem no máximo 3 sets)
*/
create trigger t_inserirJogo
    on jogos
    for insert
    as
begin
    declare @soma int
    declare @sets_time_casa int
    declare @sets_time_fora int

    set @sets_time_casa = (select sets_time_casa from inserted)
    set @sets_time_fora = (select sets_time_fora from inserted)

    set @soma = @sets_time_casa + @sets_time_fora

    if (@soma > 5 or @soma < 3) or (@sets_time_casa > 3 or @sets_time_fora > 3) or
       (@sets_time_casa < 0 or @sets_time_fora < 0)
        begin
            rollback transaction
            raiserror ('Sets inválidos', 16, 1)
        end
end

create procedure sp_inserirJogo(@id_time_a int, @id_time_b int, @sets_time_a int, @sets_time_b int)
as
begin
    insert into jogos values (@id_time_a, @id_time_b, @sets_time_a, @sets_time_b)
end
go;

exec sp_inserirJogo 1, 2, 2, 3
exec sp_inserirJogo 1, 3, 3, 1
exec sp_inserirJogo 1, 4, 3, 0
exec sp_inserirJogo 2, 3, 3, 1
exec sp_inserirJogo 2, 4, 2, 3
exec sp_inserirJogo 3, 4, 0, 3

-- Teste da Trigger
exec sp_inserirJogo 3, 1, 0, 5

select *
from dbo.fn_tabelaJogos()
