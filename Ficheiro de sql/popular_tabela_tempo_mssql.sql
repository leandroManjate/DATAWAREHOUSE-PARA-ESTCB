
-- Bloco de código em T-SQL que definindo "@dataInicial" e a "@dataFinal" 
-- popula a DIM_TEMPO para os valores indicados
 
 declare @dataInicial Date, @dataFinal date, @data date, 
    @ano smallint, @mes smallint, @dia smallint, 
    @diaSemana smallint, @diaUtil char(1), @fimSemana char(1), 
    @feriado char(1), @preFeriado char(1), @posFeriado char(1), 
    @nomeFeriado varchar(30), @nomeDiaSemana varchar(15), 
    @nomeDiaSemanaAbrev char(3), @nomeMes varchar(15), 
    @nomeMesAbrev char(3), @bimestre smallint, @trimestre smallint, 
    @nrSemanaMes smallint, @estacaoAno varchar(15), 
    @dataPorExtenso varchar(50)

--Defina aqui o período para o qual deseja criar os dados
set @dataInicial='01-01-2018'
set @dataFinal='01/01/2023'

delete from dim_tempo

while @dataInicial <= @dataFinal
begin
 set @data = @dataInicial
 set @ano = year(@data)
 set @mes = month(@data)
 set @dia = day(@data)
 set @diaSemana = datepart(weekday,@data)

 if @diaSemana in (1,7) 
 set @fimSemana = 'S'
 else set @fimSemana = 'N'

 /* feriados locais/regionais e aqueles que não possuem data fixa 
 (carnaval, páscoa e corpus cristis) tb devem ser adicionados aqui */

 if (@mes = 1 and @dia in (1,2)) or (@mes = 12 and @dia = 31) --Feriado Universal
 set @nomeFeriado = 'Feriado Universal'
 else 
 if (@mes = 4 and @dia in (25)) --Dia da Liberdade
 set @nomeFeriado = 'Dia da Liberdade'
 else 
 if (@mes = 5 and @dia in (1)) --Dia do trabalhador
 set @nomeFeriado = 'Dia do trabalhador'
 else 
 if (@mes = 6 and @dia in (10)) --Dia de Portugal
 set @nomeFeriado = 'Dia de Portugal'
 else
 if (@mes = 8 and @dia in (15)) --Dia Nossa Senhora Assuncao
 set @nomeFeriado = 'Dia Nossa Senhora Assuncao'
 else 
 if (@mes = 10 and @dia in (5)) --Implantacao Republica
 set @nomeFeriado = 'Implantacao Republica'
 else
 if (@mes = 11 and @dia in (1)) --Dia de Finados
 set @nomeFeriado = 'Dia de Finados'
 else
 if (@mes = 12 and @dia in (1)) --Dia da Restaurcao da Independencia
 set @nomeFeriado = 'proclamação da república'
 else
 if (@mes = 12 and @dia in (8)) --Imaculada Conceicao
 set @nomeFeriado = 'Imaculada Conceicao'
 else
 if (@mes = 12 and @dia in (24,25)) --Natal
 set @nomeFeriado = 'Natal'
 else set @nomeFeriado = null

 if (@mes = 12 and @dia = 31) or --Feriado Universal
 (@mes = 4 and @dia = 24) or --Dia da Liberdade
 (@mes = 4 and @dia = 30) or --Dia do trabalhador
 (@mes = 6 and @dia = 9) or --Dia de Portugal
 (@mes = 8 and @dia = 14) or --Dia Nossa Senhora Assuncao
 (@mes = 10 and @dia = 4) or --Implantacao Republica
 (@mes = 10 and @dia = 31) or --Dia de Finados
 (@mes = 11 and @dia = 30) or --Dia da Restaurcao da Independencia
 (@mes = 12 and @dia = 7) or --Imaculada Conceicao
 (@mes = 12 and @dia = 24) --Natal
 set @preFeriado = 'S'
 else set @preFeriado = 'N'

 if (@mes = 1 and @dia = 1) or --Feriado Universal
 (@mes = 4 and @dia = 25) or --Dia da Liberdade
 (@mes = 5 and @dia = 1) or --Dia do trabalhador
 (@mes = 6 and @dia = 10) or --Dia de Portugal
 (@mes = 8 and @dia = 15) or --Dia Nossa Senhora Assuncao
 (@mes = 10 and @dia = 5) or --Implantacao Republica
 (@mes = 11 and @dia = 1) or --Dia de Finados
 (@mes = 12 and @dia = 1) or --Dia da Restaurcao da Independencia
 (@mes = 12 and @dia = 8) or --Imaculada Conceicao
 (@mes = 12 and @dia = 25) --Natal
 set @feriado = 'S'
 else set @feriado = 'N'

 if (@mes = 1 and @dia = 2) or --Feriado Universal
 (@mes = 4 and @dia = 26) or --Dia da Liberdade
 (@mes = 5 and @dia = 2) or --Dia do trabalhador
 (@mes = 6 and @dia = 11) or --Dia de Portugal
 (@mes = 8 and @dia = 16) or --Dia Nossa Senhora Assuncao
 (@mes = 10 and @dia = 6) or --Implantacao Republica
 (@mes = 11 and @dia = 2) or --Dia de Finados
 (@mes = 12 and @dia = 2) or --Dia da Restaurcao da Independencia
 (@mes = 12 and @dia = 9) or --Imaculada Conceicao
 (@mes = 12 and @dia = 26) --Natal
 set @posFeriado = 'S'
 else set @posFeriado = 'N'

 set @nomeMes = case when @mes = 1 then 'janeiro'
 when @mes = 2 then 'fevereiro'
 when @mes = 3 then 'março'
 when @mes = 4 then 'abril'
 when @mes = 5 then 'maio'
 when @mes = 6 then 'junho'
 when @mes = 7 then 'julho'
 when @mes = 8 then 'agosto'
 when @mes = 9 then 'setembro'
 when @mes = 10 then 'outubro'
 when @mes = 11 then 'novembro'
 when @mes = 12 then 'dezembro' end

 set @nomeMesAbrev = case when @mes = 1 then 'jan'
 when @mes = 2 then 'fev'
 when @mes = 3 then 'mar'
 when @mes = 4 then 'abr'
 when @mes = 5 then 'mai'
 when @mes = 6 then 'jun'
 when @mes = 7 then 'jul'
 when @mes = 8 then 'ago'
 when @mes = 9 then 'set'
 when @mes = 10 then 'out'
 when @mes = 11 then 'nov'
 when @mes = 12 then 'dez' end

 if @fimSemana = 'S' or @feriado = 'S'
 set @diaUtil = 'N'
 else set @diaUtil = 'S'

 set @nomeDiaSemana = case when @diaSemana = 1 then 'domingo'
 when @diaSemana = 2 then 'segunda-feira'
 when @diaSemana = 3 then 'terça-feira'
 when @diaSemana = 4 then 'quarta-feira'
 when @diaSemana = 5 then 'quinta-feira'
 when @diaSemana = 6 then 'sexta-feira'
 else 'sábado' end

 set @nomeDiaSemanaAbrev = case when @diaSemana = 1 then 'dom'
 when @diaSemana = 2 then 'seg'
 when @diaSemana = 3 then 'ter'
 when @diaSemana = 4 then 'qua'
 when @diaSemana = 5 then 'qui'
 when @diaSemana = 6 then 'sex'
 else 'sáb' end

 set @bimestre = case when @mes in (1,2) then 1
 when @mes in (3,4) then 2
 when @mes in (5,6) then 3
 when @mes in (7,8) then 4
 when @mes in (9,10) then 5
 else 6 end

 set @trimestre = case when @mes in (1,2,3) then 1
 when @mes in (4,5,6) then 2
 when @mes in (7,8,9) then 3
 else 4 end

 set @nrSemanaMes = case when @dia < 8 then 1
 when @dia < 15 then 2
 when @dia < 22 then 3
 when @dia < 29 then 4
 else 5 end

 if @data between cast('23/Sep/'+convert(char(4),@ano) as date) and cast('20/Dec/'+convert(char(4),@ano) as date)
 set @estacaoAno = 'outono'
 else if @data between cast('21/Mar/'+convert(char(4),@ano) as date) and cast('20/Jun/'+convert(char(4),@ano) as date)
 set @estacaoAno = 'primavera'
 else if @data between cast('21/Jun/'+convert(char(4),@ano) as date) and cast('22/Sep/'+convert(char(4),@ano) as date)
 set @estacaoAno = 'verao'
 else -- @data between 21/12 e 20/03
 set @estacaoAno = 'inverno'

INSERT INTO dbo.DIM_TEMPO
 SELECT @data
 ,@ano
 ,@mes
 ,@dia
 ,@diaSemana
 ,datepart(dayofyear,@data) --DIA_ANO
 ,case when (@ano % 4) = 0 then 'S' else 'N' end -- ANO_BISSEXTO
 ,@diaUtil
 ,@fimSemana
 ,@feriado
 ,@preFeriado
 ,@posFeriado
 ,@nomeFeriado
 ,@nomeDiaSemana
 ,@nomeDiaSemanaAbrev
 ,@nomeMes
 ,@nomeMesAbrev
 ,case when @dia < 16 then 1 else 2 end -- QUINZENA
 ,@bimestre
 ,@trimestre
 ,case when @mes < 7 then 1 else 2 end -- SEMESTRE
 ,@nrSemanaMes
 ,datepart(wk,@data)--NR_SEMANA_ANO, smallint
 ,@estacaoAno
 ,lower(@nomeDiaSemana + ', ' + cast(@dia as varchar) + ' de ' + @nomeMes + ' de ' + cast(@ano as varchar))
 ,null--EVENTO, varchar(50))

 set @dataInicial = dateadd(day,1,@dataInicial) 
end

select * from dbo.DIM_TEMPO