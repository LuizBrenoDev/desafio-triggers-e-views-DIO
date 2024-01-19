-- Desafio DIO
-- Autor: Luiz Breno

USE company_constraints;

CREATE USER 'gerente'@localhost IDENTIFIED BY 'gerente-company';
GRANT SELECT ON company_constraints.managers_list TO 'gerente'@localhost;
GRANT SELECT ON company_constraints.number_of_employee_by_departament TO 'gerente'@localhost;
GRANT SELECT ON company_constraints.number_of_employee_by_location TO 'gerente'@localhost;
GRANT SELECT ON company_constraints.project_departaments_managers_list TO 'gerente'@localhost;
GRANT SELECT ON company_constraints.managers_with_dependents TO 'gerente'@localhost;
GRANT SELECT ON company_constraints.project_employees TO 'gerente'@localhost;

-- Número de empregados por departamento e localidade
CREATE VIEW number_of_employee_by_departament AS
SELECT Dname AS Departament_Name, concat(Fname, ' ', Minit, ' ', Lname) AS Complete_Name, Dno AS Departament_Number  
FROM employee, departament WHERE employee.Dno = departament.Dnumber ORDER BY departament.Dnumber;

DROP VIEW number_of_employee_by_location;
CREATE VIEW number_of_employee_by_location AS
SELECT Dname AS Departament_Name, concat(Fname, ' ', Minit, ' ', Lname) AS Complete_Name, Dlocation AS Location  , dept_locations.Dnumber AS Departament_Number
FROM employee, departament, dept_locations WHERE employee.Dno = departament.Dnumber 
AND departament.Dnumber = dept_locations.Dnumber ORDER BY dept_locations.Dlocation;

-- Lista de departamentos e seus gerentes
CREATE VIEW managers_list AS
SELECT concat(Fname, ' ', Minit, ' ', Lname) AS Complete_Name, Dname AS Departament_name, Mgr_ssn AS Manager_SSN
FROM departament, employee WHERE departament.Mgr_ssn = employee.Super_ssn;

-- Projetos com maior número de empregados
CREATE VIEW project_employees AS
SELECT DISTINCT project.Pname AS Name_of_project, project.Pnumber AS Number_of_project, COUNT(*) OVER(PARTITION BY Pno) AS Number_of_employees
FROM project, works_on, employee 
WHERE project.Pnumber = works_on.Pno
GROUP BY Ssn, Pnumber, Essn HAVING employee.Ssn = works_on.Essn;

-- Lista de projetos, departamentos e gerentes
CREATE VIEW project_departaments_managers_list AS
SELECT Pname AS Project_Name, Dname AS Departament_Name, CONCAT(Fname, ' ', Minit, ' ', Lname) AS Complete_Name
FROM project, departament, employee WHERE employee.Super_ssn = departament.Mgr_ssn AND departament.Dnumber = project.Dnum;

-- Quais empregados possuem dependentes e se são gerentes
CREATE VIEW managers_with_dependents AS
SELECT CONCAT(Fname, ' ', Minit, ' ', Lname) AS Complete_Name, Dependent_name, Relationship, departament.Dname 
FROM employee, dependent, departament
WHERE dependent.Essn = employee.Ssn AND employee.Dno = departament.Dnumber;

/*
Links úteis:
https://www.fasim.com.br/como-criar-uma-conta-de-usuario-mysql-e-conceder-todos-os-privilegios-pelo-shell-prompt-de-comando/#:~:text=Para%20garantir%20todos%20os%20privil%C3%A9gios%20do%20banco%20de,privil%C3%A9gios%20ao%20executar%20o%20seguinte%20comando%3A%20FLUSH%20PRIVILEGES%3B
*/