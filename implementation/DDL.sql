/****************   CREATE Tables   ****************/
CREATE TABLE Person (
    personID        VARCHAR(20) NOT NULL,
    firstName       VARCHAR(20) NOT NULL,
    lastName        VARCHAR(20) NOT NULL,
    birthDate       DATE        NOT NULL,
    phone           VARCHAR(12) NOT NULL,
    CONSTRAINT pk_Person PRIMARY KEY (personID)
);

CREATE TABLE Employee (
    personID  VARCHAR(20) NOT NULL,
    hireDate    DATE        NOT NULL,
    CONSTRAINT fk_Person_Employee FOREIGN KEY (personID) REFERENCES Person (personID),
    CONSTRAINT pk_Employee PRIMARY KEY (personID)
);

CREATE TABLE Physician (
    personID     VARCHAR(20) NOT NULL,
    specialty       VARCHAR(20) NOT NULL,
    pagerNumber     VARCHAR(20) NOT NULL,
    CONSTRAINT fk_Person_Physician FOREIGN KEY (personID)
        REFERENCES Person (personID),
    CONSTRAINT pk_Physician PRIMARY KEY (personID)
);

CREATE TABLE Patient (
    personID               VARCHAR(20),
    contactDate             DATE        NOT NULL,
    treatingpersonID     VARCHAR(20) NOT NULL,
    CONSTRAINT fk_Person_Patient FOREIGN KEY (personID)
        REFERENCES Person (personID),
    CONSTRAINT fk_Physician_Patient FOREIGN KEY (treatingpersonID)
        REFERENCES Physician (personID),
    CONSTRAINT pk_Patient PRIMARY KEY (personID)
);

CREATE TABLE Volunteer (
    personID     VARCHAR(20) NOT NULL,
    Skill        VARCHAR(20)         ,
    CONSTRAINT fk_Person_Volunteer FOREIGN KEY (personID)
        REFERENCES Person (personID),
    CONSTRAINT pk_Volunteer PRIMARY KEY (personID)
);

CREATE TABLE Nurse (
    personID         VARCHAR(20) NOT NULL,
    certificate     BOOLEAN     NOT NULL,
    CONSTRAINT fk_Employee_Nurse FOREIGN KEY (personID)
        REFERENCES Employee (personID),
    CONSTRAINT pk_Nurse PRIMARY KEY (personID)
);

CREATE TABLE RegNurse (
    personID     VARCHAR(20) NOT NULL,
    CONSTRAINT fk_Nurse_RegNurse FOREIGN KEY (personID)
        REFERENCES Employee (personID),
    CONSTRAINT pk_Nurse PRIMARY KEY (personID)
);

CREATE TABLE CareCenter (
    careCenterName      VARCHAR(20) NOT NULL,
    careCenterLocation  VARCHAR(30) NOT NULL,
    headpersonID     VARCHAR(20) NOT NULL,
    personID     VARCHAR(20) NOT NULL,
    CONSTRAINT fk_RegisteredNurse_CareCenter FOREIGN KEY (headpersonID)
        REFERENCES RegNurse(personID),
    CONSTRAINT fk_Nurse_CareCenter FOREIGN KEY (personID)
        REFERENCES Nurse(personID),
    CONSTRAINT pk_CareCenter PRIMARY KEY (careCenterName)
);

CREATE TABLE Resident (
    personID       VARCHAR(20) NOT NULL,
    admittedDate    DATE        NOT NULL,
    CONSTRAINT fk_Patient_Resident FOREIGN KEY (personID)
        REFERENCES Patient (personID),
    CONSTRAINT pk_Resident PRIMARY KEY (personID)
);

create table mimisInsurance(
    insurance_id    VARCHAR(20) NOT NULL,
    personID       VARCHAR(20) NOT NULL, 
    discount        VARCHAR(15) NOT NULL,
    CONSTRAINT fk_mimisInsurance_resident FOREIGN KEY(personID) REFERENCES Resident(personID),
    CONSTRAINT pk_mimisInsurance PRIMARY KEY (personID, insurance_id) 
);

CREATE TABLE Bed (
    careCenterName  VARCHAR(20) NOT NULL,
    bedNumber       INT(10)     NOT NULL,
    personID       VARCHAR(20),
    CONSTRAINT fk_CareCenter_Bed FOREIGN KEY (careCenterName)
        REFERENCES CareCenter (careCenterName),
    CONSTRAINT fk_Resident_Bed FOREIGN KEY (personID)
        REFERENCES Patient (personID),
    CONSTRAINT pk_Bed PRIMARY KEY (careCenterName , bedNumber)
);

CREATE TABLE Staff (
    personID     VARCHAR(20) NOT NULL,
    jobClass    VARCHAR(20) NOT NULL,
    CONSTRAINT fk_Employee_Staff FOREIGN KEY (personID)
        REFERENCES Employee (personID),
    CONSTRAINT pk_Staff PRIMARY KEY (personID)
);

create table Biotech /* A certificate */
(   
    biotech_id VARCHAR(15) NOT NULL,
    certificate_num  VARCHAR(15) NOT NULL,
    bt_type             VARCHAR(20) NOT NULL,
    CONSTRAINT pk_biotech PRIMARY KEY (biotech_id) 
);

CREATE TABLE Technician (
    personID    VARCHAR(20) NOT NULL,
    skill           VARCHAR(20),
    biotech_id VARCHAR(15) NOT NULL,
    CONSTRAINT fk_technician_biotech FOREIGN KEY(biotech_id) REFERENCES Biotech(biotech_id),
    CONSTRAINT fk_Employee_Technician FOREIGN KEY (personID) REFERENCES Employee (personID),
    CONSTRAINT pk_Technician PRIMARY KEY (personID)
);

CREATE TABLE Laboratory (
    labName             VARCHAR(20) NOT NULL,
    CONSTRAINT pk_Laboratory PRIMARY KEY (labName)
);

CREATE TABLE Outpatient (
    personID   VARCHAR(20) NOT NULL,
    CONSTRAINT fk_Patient_Outpatient FOREIGN KEY (personID)
        REFERENCES Patient (personID),
    CONSTRAINT pk_Outpatient PRIMARY KEY (personID)
);

CREATE TABLE Visit (
    patientID       VARCHAR(20) NOT NULL,
    physicianID     VARCHAR(20) NOT NULL,
    visitDate       DATE                ,
    comments        VARCHAR(100),
    CONSTRAINT fk_Outpatient_Visit FOREIGN KEY (patientID)
        REFERENCES Outpatient (personID),
    CONSTRAINT fk_Physician_Visit FOREIGN KEY (physicianID)
        REFERENCES Physician (personID),
    CONSTRAINT pk_Visit PRIMARY KEY (patientID , physicianID)
);


CREATE TABLE TechnicianLab (
    personID    VARCHAR(20) NOT NULL,
    location    VARCHAR(40) NOT NULL,
    labName     VARCHAR(20) NOT NULL,
    CONSTRAINT fk_Technician_TechnicianLab FOREIGN KEY (personID)
        REFERENCES Technician (personID),
    CONSTRAINT fk_Laboratory_TechnicianLab FOREIGN KEY (labName)
        REFERENCES Laboratory (labName),
    CONSTRAINT pk_TechnicianLab PRIMARY KEY (personID , labName, location)
);