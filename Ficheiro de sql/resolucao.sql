select sum(reprovacoes) Total_Reprovacoes
from tb_fatos TF


use dw1_2122

--Numero de aluno por sexo que estão no primeiro ano que não fizem mais do 6 disciplina 
select    ta.sexo,Count(*) Total_Reprovacoes
from tb_fatos TF, dim_AnoLectivo DT,dim_aluno TA 
where (tf.id_AnoLectivo = DT.id_AnoLectivo) AND (tA.id_aluno=tf.id_aluno) AND (TF.reprovacoes>=6) AND (DT.anoLetivo=1) 
group by ta.sexo

--Numero de alunos por ano que concluiram o curso

select   dte.ANO,Count(*) Numero_AlunosAprovados
from  tb_fatos TF, dim_AnoLectivo DT,dim_aluno TA ,  DIM_TEMPO DTE
where (tf.id_AnoLectivo = DT.id_AnoLectivo) AND (tA.id_aluno=tf.id_aluno) AND  (DT.anoLetivo=4) AND(dte.ID_TEMPO=TF.id_tempo) 
group by dte.ANO


--Numero de alunos que concluiram o curso por curso
select dc.nome_curso,Count(*) Numero_AlunosAprovados
from tb_fatos TF, dim_AnoLectivo DT,dim_aluno TA , dim_curso dc
where (tf.id_AnoLectivo = DT.id_AnoLectivo)AND (tA.id_aluno=tf.id_aluno)AND  (DT.anoLetivo=4)AND(DC.id_curso=TF.id_curso)
group by dc.nome_curso


--Numeros de alunos com media maior 14 por ano lectivo

select ta.sexo,dt.anoletivo,Count(*) NumeroDosAlunos
from tb_fatos TF,dim_AnoLectivo DT,dim_aluno TA
where((tf.id_AnoLectivo = DT.id_AnoLectivo) AND (tA.id_aluno=tf.id_aluno)) AND (TF.media>=14)
group by dt.anoletivo,ta.sexo
Order by  dt.anoletivo


--Numero de alunos com media 9.5 por ano lectivo
select ta.sexo,dt.anoletivo,Count(*) NumeroDosAlunos
from tb_fatos TF,dim_AnoLectivo DT,dim_aluno TA
where((tf.id_AnoLectivo = DT.id_AnoLectivo) AND (tA.id_aluno=tf.id_aluno)) AND (TF.media>=9.5)
group by dt.anoletivo,ta.sexo
Order by  dt.anoletivo

-----------------------------------------------------------
--Obter o resultados das reprovações em termos temporais(semestre, até ao diarios)

--Encontrar as reprovações total
select sum(reprovacoes) Total_Reprovacoes
from tb_fatos TF

--Encontrar o valor total de reprovações , por semestre

select dt.semestre,sum(reprovacoes) Total_Reprovacoes
from tb_fatos TF, DIM_TEMPO DT
where tf.id_tempo = dt.ID_TEMPO
group by dt.semestre

--Encontrar o valor total das reprovações , por semestre e por dia da semana

select dt.NOME_DIA_SEMANA, dt.semestre, sum(reprovacoes) Total_Reprovacoes
from tb_fatos TF, DIM_TEMPO DT
where tf.id_tempo=dt.id_tempo
group by dt.SEMESTRE, dt.Nome_DIA_SEMANA

--Obtenção do PIVOT


SELECT SEM
         ,[1] AS Domingo
		 ,[2] AS Segunda
		 ,[3] AS Terça
		 ,[4] AS Quarta
		 ,[5] AS Quinta
		 ,[6] AS Sexta
		 ,[7] AS Sabado

from(
select DT.Dia_semana, tf.reprovacoes,dt.SEMESTRE SEM
from tb_fatos TF INNER JOIN dim_tempo DT
ON TF.id_tempo=DT.id_tempo

)aa
PIVOT (SUM(Reprovacoes)
FOR Dia_Semana IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))P
ORDER BY 1

--PIVOT para o ANO	
	
SELECT ano_Analisado
         ,[1] AS Janeiro
		 ,[2] AS Fevereiro
		 ,[3] AS Março
		 ,[4] AS Abril
		 ,[5] AS Maio
		 ,[6] AS Junho
		 ,[7] AS Julho
		 ,[8] AS Agosto
		 ,[9] AS Setembro
		 ,[10] AS Outubro
		 ,[11] AS Novembro
		 ,[12] AS Dezembro

from(
select DT.MES, tf.reprovacoes,dt.ANO ano_Analisado
from tb_fatos TF INNER JOIN dim_tempo DT
ON TF.id_tempo=DT.id_tempo 

)aa
PIVOT (SUM(Reprovacoes)
FOR mes IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))P
ORDER BY 1


--------------------------------------------------------------------------------

------------------------------------------------------------------------------
PIVOT por curso



--Obtenção dos ROLLUP

Select DT.Nome_Dia_Semana
      ,DT.semestre 'SEM'
	  ,SUM(reprovacoes) TOTAL_REPROVACOES
FROM tb_fatos TF INNER JOIN dim_tempo DT
ON TF.id_tempo = DT.id_tempo
GROUP BY ROLLUP (DT.Nome_Dia_Semana,DT.semestre)


--Obtenção dos CUBE
       
Select DT.Nome_Dia_Semana
      ,DT.semestre 'SEM'
	  ,SUM(reprovacoes) TOTAL_REPROVACOES
FROM tb_fatos TF INNER JOIN dim_tempo DT
ON TF.id_tempo = DT.id_tempo
GROUP BY CUBE (DT.Nome_Dia_Semana,DT.semestre)


--Agrupamentos com GROUPING SETS
Select DT.Nome_Dia_Semana
      ,DT.semestre 'SEM'
	  ,SUM(reprovacoes) TOTAL_REPROVACOES
FROM tb_fatos TF INNER JOIN dim_tempo DT
ON TF.id_tempo = DT.id_tempo
GROUP BY GROUPING SETS (DT.Nome_Dia_Semana,DT.semestre)


--Numero de alunos inscrito nos cursos de Engenharia Eletrotecnica e Telecomunicação, Engenharia Informatica e Desenvolvimento de Software

CREATE VIEW v_DiagVenn
AS
select tf.id_curso,tf.id_curso,tC.nome_curso,tf.media
from tb_fatos TF INNER JOIN dim_aluno TA
ON TF.id_aluno=TA.id_aluno INNER JOIN  dim_curso TC
ON TC.id_curso=TF.id_curso 
WHERE TC.nome_curso IN ('Engenharia Eletrotecnica e Telecomunicação','Engenharia Informatica','Desenvolvimento de Software ') AND (tf.media>14)




select   TC.nome_curso, Count(*)
from tb_fatos TF ,dim_aluno TA,dim_curso TC
where (tf.id_aluno=ta.id_aluno) and (tc.id_curso=tf.id_curso) AND TF.media>=14 AND (TC.nome_curso IN ('Engenharia Eletrotecnica e Telecomunicação','Engenharia Informatica','Desenvolvimento de Software '))
group by tC.nome_curso


Select * from v_DiagVenn


select *
from tb_fatos TF1 CROSS JOIN tb_fatos TF2
WHERE TF1.ID_ALUNO = TF2.id_aluno
AND TF1.ID_curso != tf2.id_curso 
AND TF1.id_curso IN (1,2,3)
AND TF2.id_curso IN (1,2,3)


select tf.id_aluno,tf.id_curso,tC.nome_curso
from tb_fatos TF INNER JOIN dim_aluno TA
ON TF.id_aluno=TA.id_aluno INNER JOIN  dim_curso TC
ON TC.id_curso=TF.id_curso 
WHERE TC.nome_curso IN ('Engenharia Eletrotecnica e Telecomunicação','Engenharia Informatica','Desenvolvimento de Software ') 