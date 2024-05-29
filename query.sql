-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT *
FROM  `students`
WHERE `date_of_birth` LIKE '1990%';