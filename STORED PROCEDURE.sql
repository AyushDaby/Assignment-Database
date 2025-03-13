-- Stored procedure to display medical record
CREATE PROCEDURE sp_disp_record
@pet_id CHAR(4),
@record_id CHAR(6)
AS
BEGIN
    DECLARE @report AS VARCHAR(Max);
    
    SELECT 
        @report = 
            '---------------- Pet Medical Record ----------------' + CHAR(13) +
            'Pet Name: ' + CAST(p.name AS VARCHAR(MAX)) + CHAR(13) +
            'Pet Age: ' + CAST(p.age AS VARCHAR(MAX)) + CHAR(13) +
            'Pet Species: ' + CAST(p.species AS VARCHAR(MAX)) + CHAR(13) +
            'Owner Name: ' + CAST(o.fname AS VARCHAR(MAX)) + ' ' + CAST(o.lname AS NVARCHAR(MAX)) + CHAR(13) +
            'Staff Name: ' + CAST(s.staff_name AS VARCHAR(MAX)) + CHAR(13) +
            'Appointment Date: ' + CONVERT(VARCHAR(MAX), a.appointment_date, 23) + CHAR(13) +
            'Diagnosis: ' + CAST(m.diagnosis AS VARCHAR(MAX)) + CHAR(13) +
            'Record ID: ' + CAST(m.record_id AS VARCHAR(MAX)) + CHAR(13) +
            '---------------------------------------------------'
    FROM
        Pets p
    INNER JOIN
        Owner o ON o.owner_id = o.owner_id
    INNER JOIN
        Appointment a ON o.owner_id = a.owner_id
    INNER JOIN
        Staff s ON a.staff_id = s.staff_id
    INNER JOIN
        MedicalRecord m ON m.appointment_id = a.appointment_id
    WHERE p.pet_id = @pet_id AND m.record_id = @record_id;

    PRINT @report;
END;


EXEC sp_disp_record @pet_id = 'P001', @record_id = 'RC0001';


---CREATE TRIGGER FOR INSERT SUPPLYEQUIPMENT
CREATE TRIGGER tg_insert_supplyEquipment
ON supplyEquipment
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @supply_id supIdDom,
            @sdescription VARCHAR(40),
            @Barcode VARCHAR(50),
            @quantity INT,
            @Price DECIMAL(5,2),
            @category VARCHAR(40);

    -- Retrieve values from the INSERTED table
    SELECT 
        @supply_id = supply_id,
        @sdescription = sdescription,
        @Barcode = Barcode,
        @quantity = quantity,
        @Price = Price,
        @category = category
    FROM INSERTED;

    -- Check if supply_id is NULL
    IF (@supply_id IS NULL)
    BEGIN
        PRINT 'Please enter the supply ID.';
        RETURN; -- Exit the trigger if supply_id is NULL
    END;

    -- Check if quantity is greater than 0
    IF (@quantity <= 0)
    BEGIN
        PRINT 'Quantity must be greater than 0.';
        RETURN; -- Exit the trigger if quantity is invalid
    END;

    -- Perform the actual insert
    INSERT INTO supplyEquipment (supply_id, sdescription, Barcode, quantity, Price, category)
    SELECT 
        supply_id, sdescription, Barcode, quantity, Price, category
    FROM INSERTED;

    PRINT 'A new record has been successfully inserted into the supplyEquipment table.';
END;

-- Trigger to insert appointment into the table
CREATE TRIGGER tg_insert_appointment
ON Appointment
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @app_id apptIdDom, 
            @app_date DATE, 
            @app_time TIME, 
            @staff staffIdDom, 
            @owner ownerIdDom;
   
    SELECT 
        @app_id = appointment_id, 
        @app_date = appointment_date,
        @app_time = appointment_time,
        @staff = staff_id,
        @owner = owner_id
    FROM INSERTED;

  
    IF (@app_id IS NULL)
    BEGIN
        PRINT 'Please enter the appointment id';
        RETURN;
    END;

    INSERT INTO Appointment (appointment_id, appointment_date, appointment_time, staff_id, owner_id)
    SELECT appointment_id, appointment_date, appointment_time, staff_id, owner_id
    FROM INSERTED;
END;

---------------------------MEDICAL RECORDS--------------------------------------------------------------------------------------------

GO
CREATE TRIGGER  tg_insert_appointment
ON MedicalRecord
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @rec_id recIdDom, 
            @diagnosis_text TEXT, 
            @pet petIdDom , 
            @treat treatIdDom, 
            @appoint apptIdDom;
   
     SELECT 
        @rec_id = record_id, 
        @diagnosis_text = diagnosis, 
        @pet = pet_id , 
        @treat = treatment_id, 
        @appoint = appointment_id
     FROM INSERTED;

  
    IF (@rec_id IS NULL)
    BEGIN
        PRINT 'Please enter the record id';
        RETURN;
    END;

    INSERT INTO MedicalRecord(record_id, diagnosis, pet_id, treatment_id, appointment_id)
    SELECT record_id, diagnosis, pet_id, treatment_id, appointment_id
    FROM INSERTED;
END;















