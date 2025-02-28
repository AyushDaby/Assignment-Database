 
 
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

-- Appointment Table
CREATE TABLE Appointment(
    appointment_id apptIdDom,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    staff_id staffidDom,
    owner_id owneridDom,
    PRIMARY KEY (appointment_id),
);


 ALTER TABLE Appointment
  ADD FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
                                 ON DELETE SET NULL 
                                 ON UPDATE CASCADE,
	 ALTER TABLE Appointment
      ADD FOREIGN KEY (owner_id) REFERENCES Owner(owner_id)
                                    ON DELETE SET NULL 
                                    ON UPDATE CASCADE;

-- Treatments Table
CREATE TABLE Treatments(
    treatment_id treatIdDom,
    Treatment_name VARCHAR(40) NOT NULL,
    Tdescription VARCHAR(255),
    cost DECIMAL(5,2) NOT NULL,
    supply_id supIdDom,
    PRIMARY KEY (treatment_id),
);
	Alter TABLE TreatmentS
     ADD FOREIGN KEY (supply_id) REFERENCES supplyEquipment(supply_id) 
                                            ON DELETE SET NULL 
                                            ON UPDATE CASCADE;


-- Staff Table
CREATE TABLE Staff(
    staff_id staffIdDom,
    staff_name VARCHAR(40) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_n VARCHAR(40) NOT NULL,
    hire_date DATE NOT NULL,
    Roles VARCHAR(15) NOT NULL CHECK(Roles IN ('vet', 'nurse', 'admin')),
    salary INT NOT NULL CHECK (salary < 10000),
    hours_worked INT NOT NULL,
    yrs_experience INT,
    appointment_id apptidDom,
    PRIMARY KEY (staff_id),
);

ALTER TABLE Staff
    ADD FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
          ON DELETE SET NULL 
          ON UPDATE CASCADE;

-- Create index for Staff email
CREATE INDEX idx_email ON Staff(email);

-- Creating unique constraint for email in Staff table
ALTER TABLE Staff 
    ADD CONSTRAINT unique_email UNIQUE(email);

-- supplyEquipment Table
CREATE TABLE supplyEquipment(
    supply_id supIdDom,
    sdescription VARCHAR(40) NOT NULL,
    Barcode VARCHAR(50) NOT NULL UNIQUE,
    quantity INT NOT NULL,
    Price DECIMAL(5,2),
    category VARCHAR(40) NOT NULL CHECK (category IN ('ENTERTAINMENT', 'MEDICAL SUPPLY')),
    PRIMARY KEY (supply_id)
);

-- Create index for Barcode in supplyEquipment
CREATE INDEX idx_Barcode ON supplyEquipment(Barcode);

-- Creating unique constraint for Barcode in supplyEquipment
ALTER TABLE supplyEquipment
    ADD CONSTRAINT unique_Barcode UNIQUE(Barcode);

-- Owner Table
CREATE TABLE Owner(
    owner_id ownerIdDom,
    fname VARCHAR(25) NOT NULL,
    lname VARCHAR(25) NOT NULL,
    street VARCHAR(100),
    city VARCHAR(100),
    post_code VARCHAR(100),
    owner_email VARCHAR(50),
    owner_phoneNo VARCHAR(25) NOT NULL,
    pet_id petIdDom,
    appointment_id apptIdDom,
    PRIMARY KEY(owner_id),
	);

ALTER TABLE Owner
    ADD FOREIGN KEY (pet_id) REFERENCES Pets(pet_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
	ALTER TABLE Owner
    ADD FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id);
        
-- Create index for owner_email in Owner table
CREATE INDEX email_idx ON Owner(owner_email);

-- Creating unique constraint for owner_email in Owner table
ALTER TABLE Owner 
    ADD CONSTRAINT unique_Oemail UNIQUE(owner_email);

-- Pets Table
CREATE TABLE Pets(
    pet_id petIdDom,
    name VARCHAR(50) NOT NULL,
    age SMALLINT NOT NULL,
    species VARCHAR(50) NOT NULL CHECK(species IN ('mammals', 'birds', 'fish', 'reptiles')),
    owner_id owneridDom,
    PRIMARY KEY (pet_id),
);

ALTER TABLE Pets
    ADD FOREIGN KEY (owner_id) REFERENCES Owner(owner_id);

-- MedicalRecord Table
CREATE TABLE MedicalRecord(
    record_id recIdDom,
    diagnosis TEXT,
    pet_id petIdDom,
    treatment_id treatIdDom,
    appointment_id apptIdDom,
    PRIMARY KEY (record_id),
);


ALTER TABLE MedicalRecord
    ADD FOREIGN KEY (pet_id) REFERENCES Pets(pet_id);
-- Add foreign key for treatment_id in MedicalRecord table
ALTER TABLE MedicalRecord
    ADD FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id);
        
-- Add foreign key for appointment_id in MedicalRecord table
ALTER TABLE MedicalRecord
    ADD FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id);
