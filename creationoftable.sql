 
 ---Database creation

CREATE DATABASE VetRecords;

-- Type and Rule creation
GO
CREATE TYPE ownerIdDom FROM CHAR(4);
GO
CREATE RULE ownerIdDomRule AS @value LIKE 'O___';
GO
EXEC SP_BINDRULE 'ownerIdDomRule','ownerIdDom';

CREATE TYPE petIdDom FROM CHAR(4);
GO
CREATE RULE petIdDomRule AS @value LIKE 'P___';
GO
EXEC SP_BINDRULE 'petIdDomRule','petIdDom';

CREATE TYPE treatIdDom FROM CHAR(6);
GO
CREATE RULE treatIdDomRule AS @value LIKE 'TR%';
GO
EXEC SP_BINDRULE 'treatIdDomRule','treatIdDom';

CREATE TYPE apptIdDom FROM CHAR(6);
GO
CREATE RULE apptIdDomRule AS @value LIKE 'AP%';
GO
EXEC SP_BINDRULE 'apptIdDomRule','apptIdDom';

CREATE TYPE staffIdDom FROM CHAR(4);
GO
CREATE RULE staffIdDomRule AS @value LIKE 'S___';
GO
EXEC SP_BINDRULE 'staffIdDomRule','staffIdDom';

CREATE TYPE supIdDom FROM CHAR (4);
GO
CREATE RULE supIdDomRule AS (@value LIKE 'AC%') OR (@value LIKE 'MD%');
GO
EXEC SP_BINDRULE 'supIdDomRule','supIdDom';

CREATE TYPE recIdDom FROM CHAR(6);
GO
CREATE RULE recIdDomRule AS @value LIKE 'RC%';
GO
EXEC SP_BINDRULE 'recIdDomRule','recIdDom';

--- creation of table appointment, supplyEntainment, staff
CREATE TABLE Appointment(
appointment_id apptIdDom ,
appointment_date  DATE NOT NULL,
appointment_time Time NOT NULL,
staff_id staffidDom,
owner_id owneridDom,
PRIMARY KEY (appointment_id),
FOREIGN KEY (staff_id) References Staff
                         ON DELETE SET NULL
						 ON UPDATE CASCADE,
FOREIGN KEY (owner_id) References Owner
                         ON DELETE SET NULL
						 ON UPDATE CASCADE,
);

---table treatment
CREATE TABLE Treatments(
treatment_id treatIdDom ,
Treatment_name VARCHAR(40)  NOT NULL,
Tdescription VARCHAR(255),
cost Decimal(5,2) NOT NULL,
supply_id supIdDom,
PRIMARY KEY (treatment_id),
FOREIGN KEY (supply_id) References supplyEquipment
                         ON DELETE SET NULL
						 ON UPDATE CASCADE,

);

---- table staff
CREATE TABLE Staff(
staff_id staffIdDom ,
staff_name VARCHAR(40)  NOT NULL,
email VARCHAR(255) UNIQUE,
phone_n VARCHAR(40) NOT NULL,
hire_date Date NOT NULL,
Roles VARCHAR(15) NOT NULL CHECK(Roles IN('vet','nurse','admin')),
salary INT NOT NULL CHECK (salary<10000),
hours_worked INT NOT NULL,
yrs_experience INT,
appointment_id apptidDom,
PRIMARY KEY (staff_id),
FOREIGN KEY (appointment_id) References Appointment
                         ON DELETE SET NULL
						 ON UPDATE CASCADE,
);
---create index to allow better search result in the database
CREATE INDEX idx_email ON Staff(email);

--- creating an unique contraint to ensure that each email are unique
ALTER TABLE Staff 
ADD CONSTRAINT unique_email UNIQUE(email);

----supplyEquipment
CREATE TABLE supplyEquipment(
supply_id supIdDom ,
sdescription  VARCHAR(40) NOT NULL,
Barcode VARCHAR(50) NOT NULL UNIQUE,
quantity INT NOT NULL,
Price Decimal(5,2),
category VARCHAR(40)NOT NULL CHECK (category IN('ENTERTAINMENT','MEDICAL SUPPLY')),
PRIMARY KEY (supply_id),
);

---create index to allow better search result in the database
CREATE INDEX idx_Barcode ON supplyEquipment(Barcode);

--- creating an unique contraint to ensure that each Barcodes are unique
ALTER TABLE supplyEquipment
ADD CONTRAINT unique_Barcode UNIQUE(Barcode);



-- Owner Table
CREATE TABLE Owner (
owner_id ownerIdDom ,
fname VARCHAR(25) NOT NULL,
lname VARCHAR(25) NOT NULL,
street VARCHAR(100),
city VARCHAR(100),
post_code VARCHAR(100),
owner_email VARCHAR(50),
owner_phoneNo VARCHAR(25) NOT NULL,
pet_id petIdDom ,
appointment_id apptIdDom,
PRIMARY KEY(owner_id),
FOREIGN KEY (pet_id) REFERENCES Pets(pet_id)
				ON DELETE SET NULL
				ON UPDATE CASCADE,
FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
							 ON DELETE SET NULL
							 ON UPDATE CASCADE,
);



---create index to allow better search result in the database
CREATE INDEX emailIDX ON Owner (owner_email);

--- creating an unique contraint to ensure that each owner email are unique
ALTER TABLE Owner 
ADD CONTRAINT unique_Oemail UNIQUE(owner_email);



-- Pet Table
CREATE TABLE Pets (
pet_id petIdDom ,
name VARCHAR(50) NOT NULL,
age SMALLINT NOT NULL,
species VARCHAR(50) NOT NULL CHECK(species IN('mammals','birds','fish','reptiles')),
owner_id owneridDom ,
PRIMARY KEY (pet_id),
FOREIGN KEY (owner_id) REFERENCES Owner(owner_id)
					ON DELETE SET NULL
					ON UPDATE CASCADE,
);


-- Medical Record Table
CREATE TABLE MedicalRecord (
record_id recIdDom,
diagnosis TEXT,
pet_id petIdDom,
treatment_id treatIdDom,
appointment_id apptIdDom,
PRIMARY KEY (record_id),
FOREIGN KEY (pet_id) REFERENCES Pets(pet_id)
				   ON DELETE SET NULL
				   ON UPDATE CASCADE,

FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id)
						ON DELETE SET NULL
						ON UPDATE CASCADE,

FOREIGN KEY (appointment_id) REFERENCES Appoointment(appointment_id)
							 ON DELETE SET NULL
							 ON UPDATE CASCADE,
);
