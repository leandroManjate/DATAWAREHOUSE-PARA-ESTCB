

use dw1_2122;

-----------------------------------------------------------------------
-- Fase 1 – A criação dos Filegroups
-----------------------------------------------------------------------

ALTER DATABASE dw1_2122
ADD FILEGROUP FG_D; 

ALTER DATABASE dw1_2122
ADD FILEGROUP FG_E; 

ALTER DATABASE dw1_2122
ADD FILEGROUP FG_F; 

ALTER DATABASE dw1_2122
ADD FILEGROUP FG_G;

ALTER DATABASE dw1_2122
ADD FILEGROUP FG_A;
-------------------------------------------------------------------------
-- Fase 2 – A criação dos ficheiros para os filegroups
-------------------------------------------------------------------------

ALTER DATABASE dw1_2122 ADD FILE
	( NAME = dw1_2122_DW_d,
	  FILENAME = 'd:\fgd\dw1_2122_d.ndf',
          SIZE = 1MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 1MB)
 TO FILEGROUP FG_D;

 ALTER DATABASE dw1_2122 ADD FILE
	( NAME = dw1_2122_e,
	  FILENAME = 'e:\fge\dw1_2122_e.ndf',
          SIZE = 1MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 1MB)
 TO FILEGROUP FG_E;
 
 ALTER DATABASE dw1_2122  ADD FILE
	( NAME = dw1_2122_f,
	  FILENAME = 'f:\fgf\dw1_2122_f.ndf',
          SIZE = 1MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 1MB)
 TO FILEGROUP FG_F;
 
 ALTER DATABASE dw1_2122 ADD FILE
	( NAME = dw1_2122_g,
	  FILENAME = 'g:\fgg\dw1_2122_g.ndf',
          SIZE = 1MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 1MB)
 TO FILEGROUP FG_G;

  ALTER DATABASE dw1_2122 ADD FILE
	( NAME = dw1_2122_a,
	  FILENAME = 'g:\fgg\dw1_2122_a.ndf',
          SIZE = 1MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 1MB)
 TO FILEGROUP FG_A;

-------------------------------------------------------------------------
--  Fase 3 – A criação da tabela de Factos Particionada
-------------------------------------------------------------------------
 
-- 3.1 A criação de uma Função de Partição que serve para definir "limites“;

CREATE PARTITION FUNCTION
partFuncPorIdAluno (int)
AS RANGE LEFT
FOR VALUES (100);

-- 3.2 A criação de esquema de Partição, que serve para associar os limites, criado pela função de partição, 
--     aos diferentes filegroups

CREATE PARTITION SCHEME partSchemePorIdAluno
AS PARTITION partFuncPorIdAluno
TO (FG_D, FG_E);



---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------
-- Criação das tabelas nos respetivos FILEGROUPs
---------------------------------------------------------------------------------------

-- Dimensões (criadas no FILEGROUP "F", logo no disco "f:\")

 ;
create table dim_aluno(
id_aluno int not null,
nome_aluno varchar(50),
localidade varchar(30),
codpostal INT,
idade int,
sexo varchar(50),
estado_civil varchar(10),
) on fg_f;


create table dim_curso(
id_curso int not null,
nome_curso varchar(50)
) on fg_f;

create table dim_AnoLectivo(
id_AnoLectivo int not null,
semestre int,
anoLetivo int
) on fg_f;



CREATE TABLE dbo.DIM_TEMPO(
 ID_TEMPO int IDENTITY(1,1) NOT NULL,
 DATA date NOT NULL,
 ANO smallint NOT NULL,
 MES smallint NOT NULL,
 DIA smallint NOT NULL,
 DIA_SEMANA smallint NOT NULL,
 DIA_ANO smallint NOT NULL,
 ANO_BISSEXTO char(1) NOT NULL,
 DIA_UTIL char(1) NOT NULL,
 FIM_SEMANA char(1) NOT NULL,
 FERIADO char(1) NOT NULL,
 PRE_FERIADO char(1) NOT NULL,
 POS_FERIADO char(1) NOT NULL,
 NOME_FERIADO varchar(30) NULL,
 NOME_DIA_SEMANA varchar(15) NOT NULL,
 NOME_DIA_SEMANA_ABREV char(3) NOT NULL,
 NOME_MES varchar(15) NOT NULL,
 NOME_MES_ABREV char(3) NOT NULL,
 QUINZENA smallint NOT NULL,
 BIMESTRE smallint NOT NULL,
 TRIMESTRE smallint NOT NULL,
 SEMESTRE smallint NOT NULL,
 NR_SEMANA_MES smallint NOT NULL,
 NR_SEMANA_ANO smallint NOT NULL,
 ESTACAO_ANO varchar(15) NOT NULL,
 DATA_POR_EXTENSO varchar(50) NOT NULL,
 EVENTO varchar(50) NULL
 ) on fg_f;

-- PK das Dimensões (criadas no FILEGROUP "G", logo no disco "g:\")

alter table dim_aluno add constraint tb_dim_aluno 
primary key(id_aluno )
on fg_g;

alter table dim_curso add constraint tb_Dim_curso_PK
primary key(id_curso)
on fg_g;

alter table dim_tempo add constraint tb_Dim_tempo_PK
primary key(id_tempo)
on fg_g;


alter table dim_AnoLectivo add constraint tb_Dim_AnoLectivo_PK
primary key(id_AnoLectivo )
on fg_g;



------------------------------------------------------------------------
-- Dimensões (criadas no FILEGROUP "D" e "E")
-- Logo quando o "id_cliente" estiver entre 1<id_cliente<=100 no disco "d:\"
-- Logo quando o "id_cliente" estiver entre 100<id_cliente<.. no disco "e:\"



create table tb_fatos(
id_tempo int,
id_aluno int,
id_curso int,
id_AnoLectivo int,
reprovacoes int,
media decimal(3,1)
)
ON partSchemePorIdAluno(id_aluno);

select * from tb_fatos

--select * from tb_fatos
--ALTER TABLE tb_fatos DROP COLUMN media;

--ALTER TABLE tb_fatos
--ADD media decimal(3,1);


--select * from tb_fatos



-- FKs sempre no filegroup primario----------------------------------------
--ALTER TABLE tb_fatos DROP constraint  tb_fatos_tempo_fk

alter table tb_fatos add constraint tb_fatos_tempo_fk
foreign key(id_tempo) references dim_tempo;

--ALTER TABLE tb_fatos DROP constraint tb_fatos_aluno_fk

alter table tb_fatos add constraint tb_fatos_aluno_fk
foreign key(id_aluno) references dim_aluno;

--ALTER TABLE tb_fatos DROP constraint tb_fatos_curso_fk
alter table tb_fatos add constraint tb_fatos_curso_fk
foreign key(id_curso) references dim_curso;

--ALTER TABLE tb_fatos DROP constraint tb_fatos_anolectivo_fk
alter table tb_fatos add constraint tb_fatos_anolectivo_fk
foreign key (id_AnoLectivo) references  dim_AnoLectivo

-------------------------------------------------------------------------------






 



