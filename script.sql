-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
--escreva a sua solução aqui

-- Active: 1720736393486@@localhost@5432
CREATE DATABASE "student_prediction";
CREATE TABLE "tb_student" (
    "id" SERIAL PRIMARY KEY,
    "mother_edu" INTEGER,
    "father_edu" INTEGER,
    "study_time" INTEGER,
    "partner" INTEGER,
    "salary" INTEGER,
    "prep_exam" INTEGER,
    "grade" INTEGER
);

-- ----------------------------------------------------------------
-- 2 Resultado em função da formação dos pais
--escreva a sua solução aqui
-- nao vinculado a um banco de dados

DO $$
DECLARE
    --1. Declaracao de cursor
    cur_aprovados REFCURSOR;
    v_mother_edu INTEGER;
    v_father_edu INTEGER;
    v_grade INTEGER;
    v_tupla RECORD;

    BEGIN
    --2. Abertura do cursor
    OPEN cur_aprovados SCROLL FOR
        SELECT mother_edu, father_edu, grade
        FROM tb_student
        WHERE grade >=1 AND mother_edu = 6 OR father_edu = 6;
    LOOP
        --3. Recuperacao de dados
        FETCH cur_aprovados INTO v_tupla;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Mae: %, Pai: %, Nota: %', v_tupla.mother_edu, v_tupla.father_edu, v_tupla.grade;
    END LOOP;
        --4. Fechamento do cursor
        CLOSE cur_aprovados;
END 
$$;

-- ----------------------------------------------------------------
-- 3 Resultado em função dos estudos
--escreva a sua solução aqui
-- cursor query dinamica
DO $$

DECLARE
    --1. Declaracao de cursor
    cur_aprovados_estudos_sozinho REFCURSOR;
    v_partner INTEGER;
    v_grade INTEGER;
    v_tupla RECORD;

    BEGIN
    --2. Abertura do cursor
    OPEN cur_aprovados_estudos_sozinho SCROLL FOR
        EXECUTE 'SELECT partner, grade FROM tb_student WHERE grade >= 1 AND partner = 2';
    LOOP
        --3. Recuperacao de dados
        FETCH cur_aprovados_estudos_sozinho INTO v_tupla;
        EXIT WHEN NOT FOUND;
        if cur_aprovados_estudos_sozinho is NULL THEN
            RAISE NOTICE '-1';
        END IF;
        RAISE NOTICE 'Parceiro: %, Nota: %', v_tupla.partner, v_tupla.grade;
    END LOOP;
        --4. Fechamento do cursor
        CLOSE cur_aprovados_estudos_sozinho;
END
$$;


-- ----------------------------------------------------------------
-- 4 Salário versus estudos
--escreva a sua solução aqui
DO $$
DECLARE
    cur_prep_exam_salary REFCURSOR;
    v_salary INTEGER;
    v_grade INTEGER;
    v_tupla RECORD;
BEGIN
    --1. Declaracao de cursor
    OPEN cur_prep_exam_salary SCROLL
    FOR
        SELECT salary, grade
        FROM tb_student
        WHERE salary > 5 AND grade >= 1;
    --2. Abertura do cursor
    LOOP
    --3. Recuperacao de dados
        FETCH cur_prep_exam_salary INTO v_tupla;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Salario: %, Nota: %', v_tupla.salary, v_tupla.grade;
    END LOOP;

    --4. Fechamento do cursor
    CLOSE cur_prep_exam_salary;
END
$$;


DO $$
DECLARE
    --1. Declaracao de cursor
    cur_prep_exam_salary REFCURSOR;
    v_salary INTEGER;
    prep_exam INTEGER;
    v_tupla RECORD;
BEGIN
    --2. Abertura do cursor
    OPEN cur_prep_exam_salary SCROLL
    FOR
        SELECT salary, prep_exam
        FROM tb_student
        WHERE prep_exam = 2 AND salary > 5;
    LOOP
    --3. Recuperacao de dados
        FETCH cur_prep_exam_salary INTO v_tupla;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Salario: %, Preparacao Exame: %', v_tupla.salary, v_tupla.prep_exam;
    END LOOP;

    --4. Fechamento do cursor
    CLOSE cur_prep_exam_salary;
END
$$;

-- ----------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui

DO $$
DECLARE
    cur_tupla_nula REFCURSOR;
    v_tupla RECORD;
BEGIN
    --1. Declaracao de cursor
    OPEN cur_tupla_nula SCROLL
    FOR
        SELECT *
        FROM tb_student
        WHERE mother_edu IS NULL OR father_edu IS NULL OR study_time IS NULL OR partner IS NULL OR salary IS NULL OR prep_exam IS NULL OR grade IS NULL;
    --2. Abertura do cursor
    LOOP
    --3. Recuperacao de dados
        FETCH cur_tupla_nula INTO v_tupla;
        EXIT WHEN NOT FOUND;
        if v.tupla IS NULL THEN
            DELETE FROM tb_student WHERE cur_tupla_nula IS NULL;
        END IF;
        RAISE NOTICE 'ID: %, Mae: %, Pai: %, Tempo de Estudo: %, Parceiro: %, Salario: %, Preparacao Exame: %, Nota: %', v_tupla.id, v_tupla.mother_edu, v_tupla.father_edu, v_tupla.study_time, v_tupla.partner, v_tupla.salary, v_tupla.prep_exam, v_tupla.grade;
    END LOOP;
    --mostre as tuplas remanescentes em ordem decrescente
    LOOP
        FETCH cur_tupla_nula INTO v_tupla;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'ID: %, Mae: %, Pai: %, Tempo de Estudo: %, Parceiro: %, Salario: %, Preparacao Exame: %, Nota: %', v_tupla.id, v_tupla.mother_edu, v_tupla.father_edu, v_tupla.study_time, v_tupla.partner, v_tupla.salary, v_tupla.prep_exam, v_tupla.grade;
    END LOOP;

    --4. Fechamento do cursor
    CLOSE cur_tupla_nula;
END
$$;
-- ----------------------------------------------------------------