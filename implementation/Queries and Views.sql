/******************     VIEWS     *********************/
/* View 1 Done */
CREATE VIEW employeesHiredView AS
SELECT firstName,lastName,hireDate 
FROM Employee 
INNER JOIN Person
ON Employee.personID = Person.personID;

/* View 2 Done */
CREATE VIEW nursesInChargeView AS
SELECT firstName,lastName,phone           
FROM CareCenter 
INNER JOIN RegNurse
ON RegNurse.personID = CareCenter.headpersonID 
INNER JOIN Person
ON  RegNurse.personID = Person.personID;

/* view 3 */
CREATE VIEW goodTechnicianView AS
SELECT * FROM Technician 
WHERE SKILL IS NOT NULL;

/* view 4 */
CREATE VIEW careCenterTotalBed AS
SELECT CareCenter.careCenterName, COUNT(bedNumber) As "TotalBeds" 
FROM CareCenter INNER JOIN Bed
ON CareCenter.careCenterName = Bed.CareCenterName
GROUP BY CareCenterName;

CREATE VIEW careCenterTakenBed AS
SELECT CareCenter.careCenterName, COUNT(bedNumber) As "TakenBeds" 
FROM CareCenter INNER JOIN Bed
ON CareCenter.careCenterName = Bed.careCenterName
WHERE Bed.personID IS NOT NULL
GROUP BY careCenterName;

CREATE VIEW careCenterBedsView AS
SELECT careCenterTotalBed.careCenterName, careCenterTakenBed.TakenBeds, careCenterTotalBed.TotalBeds-careCenterTakenBed.TakenBeds AS "FreeBeds"
FROM careCenterTotalBed 
LEFT OUTER JOIN careCenterTakenBed
ON careCenterTotalBed.careCenterName = careCenterTakenBed.careCenterName;

/* view 5 */
CREATE VIEW OutPatientsNotVisitedView AS 
SELECT firstName, lastName
FROM Person 
INNER JOIN Outpatient 
ON Person.personID = Outpatient.personID
INNER JOIN Visit
ON Outpatient.personID = Visit.patientID
WHERE Visit.visitDate is NULL;

/****************      Queries      **********************/
select * From employeesHiredView;
select * From nursesInChargeView;
select * From goodTechnicianView;
select * From careCenterBedsView;
select * From OutPatientsNotVisitedView;

/*Query 1 done*/
select firstName, lastName, 'Volunteer' as jobs
from Person inner join Volunteer
on Person.personID = Volunteer.personID
union
select firstName, lastName, 'Physician' as jobs
from Person inner join Physician
on Person.personID = Physician.personID
union
select firstName, lastName, 'Nurses' as jobs
from Person inner join Nurse
on Person.personID = Nurse.personID
union
select firstName, lastName, 'Technician' as jobs
from Person inner join Technician
on Person.personID = Technician.personID
union
select firstName, lastName, 'Staff' as jobs
from Person inner join Staff
on Person.personID = Staff.personID;

/*Query 2 done*/
select firstName, lastName
from Person inner join Volunteer
on Person.personID = Volunteer.personID
where Volunteer.skill is NULL;

/*Query 3 done*/
select firstName, lastName
from Person inner join Patient
on Person.PersonID = Patient.PersonID
inner join Volunteer
on Patient.PersonID = Volunteer.PersonID;

/*Query 4 done*/

select firstName,lastName
from Person inner join Patient
on Person.PersonID = Patient.PersonID
inner join Outpatient
on Patient.PersonID = Outpatient.PersonID
inner join Visit
on Outpatient.PersonID = Visit.patientID
GROUP BY firstName,lastName
having count(Visit.patientID) = 1;

/*Query 5 done*/
select Volunteer.skill, count(*) AS "Number of People With skill"
from Volunteer
group by Volunteer.skill
UNION 
select Technician.skill, count(*) AS "Number of People With skill"
from Technician
WHERE Technician.skill IS NOT NULL
group by Technician.skill;

/*Query 6 dependent on view 4 done*/
Select CareCenter.careCenterName AS "Full Centers"
FROM CareCenter
INNER JOIN careCenterBedsView
ON careCenterBedsView.careCenterName = CareCenter.careCenterName
WHERE careCenterBedsView.FreeBeds = 0;

/*Query 7 done*/
SELECT Person.firstName, Person.lastName, Person.phone
FROM Person
INNER JOIN RegNurse 
ON Person.personID = RegNurse.PersonID
WHERE RegNurse.PersonID NOT IN (SELECT CareCenter.PersonID FROM CareCenter);

/*Query 8 needs check*/
SELECT firstName, lastName, phone
FROM Nurse
INNER JOIN CareCenter ON Nurse.personID = CareCenter.personID
INNER JOIN Person ON Nurse.personID = Person.personID
WHERE Nurse.personID = CareCenter.headpersonID;

/*Query 9 done*/
select distinct Laboratory.labName
from Laboratory inner join TechnicianLab
on Laboratory.labName = TechnicianLab.labName
inner join Technician
on TechnicianLab.PersonID = Technician.PersonID
Where Technician.skill is not null;

/*Query 10 done*/
SELECT firstName, lastName
FROM Resident
INNER JOIN Person 
ON Resident.personID = Person.personID
WHERE admittedDate > (SELECT MAX(hireDate) FROM Employee);


/*Query 12*/
Select firstName, lastName
FROM Person 
inner join Patient 
on Person.personID = Patient.personID
INNER JOIN Outpatient
ON Patient.personID = Outpatient.personID
INNER JOIN Visit 
ON Outpatient.personID = Visit.patientID
Where  (Visit.visitDate - Patient.contactdate) > 7;

/* Query 13 */
Select firstName,lastName,visitDate
from Physician
INNER JOIN Visit ON Physician.personID = Visit.physicianID
INNER JOIN Person ON Physician.personID = Person.personID
GROUP BY Physician.personID , visitDate
HAVING COUNT(Visit.physicianID) > 3;

/* Query 14 */
SELECT Person.firstName, Person.lastName, Person.personID FROM
Person NATURAL JOIN
Physician NATURAL JOIN
(SELECT Physician.personID, coalesce(pO.OutPatientCount,0) - coalesce(pR.ResidentCount,0) as "patientDiff" FROM
Physician LEFT OUTER JOIN
(SELECT Patient.personID, COUNT(Patient.personID) AS "OutPatientCount" FROM
Person INNER JOIN Patient ON Person.personID = Patient.personID
INNER JOIN Outpatient ON Outpatient.personID = Patient.personID
GROUP BY Patient.personID) pO
ON Physician.personID = pO.personID
LEFT OUTER JOIN
(SELECT Patient.personID, COUNT(Patient.personID) AS "ResidentCount" FROM
Person INNER JOIN Patient ON Person.personID = Patient.personID
INNER JOIN Resident ON Resident.personID = Patient.personID
GROUP BY Patient.personID) pR
ON Physician.personID = pR.personID) pD
WHERE pD.patientDiff > 0;

/* Query 15 done*/
SELECT Person.firstName, Person.lastName, Person.personID
FROM Person INNER JOIN Visit ON Person.personID = Visit.patientID
INNER JOIN Outpatient ON Visit.patientID = Outpatient.personID
INNER JOIN Patient ON Patient.personID = Outpatient.personID
WHERE Visit.physicianID != Patient.treatingpersonID;

/*Query 16a*/
/*display all the technician with their certificate number and type */
SELECT  firstName,lastName,Biotech.certificate_num,Biotech.bt_type
FROM Biotech
INNER JOIN Technician ON Technician.biotech_id = Biotech.biotech_id
INNER JOIN Person ON Technician.personID = Person.personID;

/*Query 16b*/
/*should display that all the resident have Mimi Issurance */
SELECT  firstName,lastName As 'Resident Patient',Resident.admittedDate,
    mimisInsurance.insurance_id
FROM mimisInsurance
INNER JOIN Resident ON Resident.personID = mimisInsurance.personID
INNER JOIN Person ON Resident.personID = Person.personID;

/*Query 16c*/
SELECT firstName, lastName 
From Person
INNER JOIN Volunteer
ON Person.personId = Volunteer.personId
Where Volunteer.Skill = "Blood Tests"
Union
Select firstName, lastName
From Person
INNER JOIN Technician
ON Person.personID = Technician.personID
Where Technician.Skill = "Blood Tests";