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
