-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT *
FROM  `students`
WHERE `date_of_birth` LIKE '1990%';

-- Selezionare tutti i corsi che valgono più di 10 crediti (479)

SELECT *
FROM `courses`
WHERE `cfu` > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni

SELECT *
FROM `students`
WHERE TIMESTAMPDIFF(YEAR,`date_of_birth`, CURDATE()) > 30;
--  TIMESTAMPDIFF FA LA DIFFERENZA TRA LA DATA ODIERNA E LA DATA DI NASCITA. DOPO CONFRONTO IL RISULTATO CON LA CONDIZIONE DATA.


-- 
