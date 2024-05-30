-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT *
FROM  `students`
WHERE `date_of_birth` LIKE '1990%'; 
-- altra soluzione confrontare solo anno:
--WHERE YEAR(`date_of_birth`) = 1990;

-- Selezionare tutti i corsi che valgono più di 10 crediti (479)

SELECT *
FROM `courses`
WHERE `cfu` > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni

SELECT *
FROM `students`
WHERE TIMESTAMPDIFF(YEAR,`date_of_birth`, CURDATE()) >= 30;
--  TIMESTAMPDIFF FA LA DIFFERENZA TRA LA DATA ODIERNA E LA DATA DI NASCITA. DOPO CONFRONTO IL RISULTATO CON LA CONDIZIONE DATA.

-- 2 soluzione ma risultato diverso. la prima piu corretto.
-- SELECT * 
-- FROM `students` 
-- WHERE `date_of_birth` <= DATE_SUB(CURRENT_DATE(),INTERVAL 30 YEAR);  


-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)

SELECT *
FROM `courses`
WHERE `period` = "I semestre"
AND `year` = 1;

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)

SELECT *
FROM `exams`
WHERE `date` = "2020-06-20"
AND `hour`> "14:00:00";  -- per prendere solo ora possiamo usare anche  HOUR(`hour`) >= 14

-- 6. Selezionare tutti i corsi di laurea magistrale (38)

SELECT *
FROM `degrees`
WHERE `name` LIKE "corso di laurea magistrale%"; -- dato che non è key sensitive uso le minuscole.

-- 7. Da quanti dipartimenti è composta l'università? (12)

SELECT count(*) as quanti_dipartimenti
FROM `departments`;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)

SELECT count(*) as senza_numero
FROM `teachers`
WHERE `phone` IS NULL;

-- 9. Inserire nella tabella degli studenti un nuovo record con i propri dati (per il campo degree_id, inserire un valore casuale)

INSERT INTO `students` (`degree_id`,`name`, `surname`, `date_of_birth`,`fiscal_code`, `enrolment_date`, `registration_number`, `email`)
VALUES ("1","Olga", "Demina", "2000-01-01", "ehehbrhefefe","2020-01-01","900000","olga@demina.it");

-- 10. Cambiare il numero dell’ufficio del professor Pietro Rizzo in 126

UPDATE `teachers`
SET `office_number` = 126
WHERE `id` = 58;

-- 11. Eliminare dalla tabella studenti il record creato precedentemente al punto 9

DELETE FROM `students`
WHERE `id` = 5002;




--  group e join 

-- GROUP
-- 1. Contare quanti iscritti ci sono stati ogni anno

SELECT YEAR(`enrolment_date`), COUNT(*) AS student_count
FROM `students`
GROUP BY YEAR(`enrolment_date`);

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio

SELECT `teachers`.`office_number` ,COUNT(*) AS `count`
FROM `teachers`
GROUP BY `teachers`.`office_number`
HAVING COUNT(*) > 1;

-- 3. Calcolare la media dei voti di ogni appello d'esame

SELECT `exam_id`, AVG(`vote`)
FROM `exam_student`
GROUP BY `exam_id`;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento

SELECT `degrees`.`department_id`, COUNT(*)
FROM `degrees`
GROUP BY `degrees`.`department_id`;


--  JOIN
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia

SELECT `students`.`id`,
  		`students`.`name`,
		`students`.`surname`      
FROM `students`
INNER JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
WHERE `degrees`.`name` = "Corso di Laurea in Economia";

-- 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze

SELECT *
FROM `departments`
INNER JOIN `degrees`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `degrees`.`level`="magistrale"
AND `departments`.`name` = "dipartimento di neuroscienze";
-- result 1

SELECT *
FROM `departments`
INNER JOIN `degrees`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `degrees`.`name`LIKE "Corso di Laurea Magistrale%"
AND `departments`.`name` = "dipartimento di neuroscienze";
-- result 1

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)

SELECT `courses`.`name` AS `NOME CORSI FULVIO AMATO`
FROM `courses`
INNER JOIN `course_teacher`
on `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `teachers`
ON `course_teacher`.`teacher_id` = `teachers`.`id`
WHERE `teachers`.`id` = 44;


SELECT `courses`.`name` AS `NOME CORSI FULVIO AMATO`
FROM `courses`
INNER JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
WHERE `course_teacher`.`teacher_id` = 44;

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome

-- nome | cognome | corso di laurea | dipartimento |  ordine alfabetico per cognome nome

SELECT 	`students`.`surname` AS `Cognome`,
		`students`.`name` AS `Nome`,
        `degrees`.`name` AS `Corso di laurea`,
        `departments`.`name` AS `Dipartimento`
FROM `students`
INNER JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
INNER JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
ORDER BY `students`.`surname`, `students`.`name`;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti

-- nome corso laurea | nome corso | nome | cognome

SELECT 	`teachers`.`name` AS `Nome`,
		`teachers`.`surname` As `Cognome`,
        `degrees`.`name` AS `Corso laurea`,
        `courses`.`name` AS `Corso`
FROM `teachers`
INNER JOIN `course_teacher`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
INNER JOIN `courses`
ON `course_teacher`.`course_id` = `courses`.`id`
INNER JOIN `degrees`
ON `courses`.`degree_id` = `degrees`.`id`

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)

SELECT DISTINCT	`teachers`.`name` AS `Nome`,
		`teachers`.`surname` AS `Cognome`
FROM `departments`
INNER JOIN `degrees`
ON `departments`.`id` = `degrees`.`department_id`
INNER JOIN `courses`
ON `courses`.`degree_id` = `degrees`.`id`
INNER JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `teachers`
ON `course_teacher`.`teacher_id` = `teachers`.`id`
WHERE `departments`.`name` = "Dipartimento di Matematica";

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami

SELECT 	`students`.`name` AS `Nome`,
    	`students`.`surname` AS `Cognome`,
    	`courses`.`name` AS `Corso`,
    	COUNT(`exams`.`id`) AS `Numero Ripetizioni`
FROM `students`
INNER JOIN `exam_student`
ON `students`.`id` = `exam_student`.`student_id`
INNER JOIN `exams`
ON `exam_student`.`exam_id` = `exams`.`id`
INNER JOIN `courses`
ON `exams`.`course_id` = `courses`.`id`
GROUP BY	`students`.`name`, 
    		`students`.`surname`, 
    		`courses`.`name`
HAVING COUNT(`exams`.`id`);

-- having viene puo usare i valori di tutte le tabelle che abbiamo aggregato mentre where non puo farlo.