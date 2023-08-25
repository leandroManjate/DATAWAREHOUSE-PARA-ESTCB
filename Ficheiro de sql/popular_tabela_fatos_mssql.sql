

-- drop procedure populate_tb_fatos

-- Criação do procedimento

Create procedure populate_tb_fatos (@nrRegistos int)
as

declare @aleatorio int, @i int
declare @tmpIdTempo int, @tmpIdCurso int, @tmpIdAluno int
declare @tmpReprovacoes int
declare @tmpValorMedia decimal(3,1)
declare @tmpAnoLectivo  int

set @i=1

delete from tb_fatos

while @i <= @nrRegistos
	begin
	
 		set @tmpIdTempo = rand()*1827 + 1
		
		set @tmpIdCurso = rand()*15 + 1
				
		set @tmpIdAluno = rand()*200 + 1
		
		set @tmpReprovacoes = rand()*48 + 1
		
		set @tmpValorMedia = rand()*19 + 1

		set @tmpAnoLectivo = rand()*8+1
		
		insert into tb_fatos (id_tempo,id_aluno, id_curso,id_AnoLectivo , reprovacoes,media) 
		values (@tmpIdTempo,@tmpIdAluno, @tmpIdCurso,@tmpAnoLectivo  , @tmpReprovacoes, @tmpValorMedia)


 		set @i = @i+1
	end

-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
-- Execução do procedimento com parametro de entrada 5000 (teste esta mesma execução para 
-- valores diferentes no parametro de entrada)
-------------------------------------------------------------------------------------------------

exec populate_tb_fatos 203

select * from tb_fatos