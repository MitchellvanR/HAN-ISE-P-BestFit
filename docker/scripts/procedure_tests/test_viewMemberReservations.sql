EXEC [tSQLt].[NewTestClass] 'testViewMemberReservations'
GO

DROP PROCEDURE IF EXISTS testViewMemberReservations.SetUp
GO
CREATE PROCEDURE testViewMemberReservations.SetUp
AS
BEGIN
    IF OBJECT_ID('[testViewMemberReservations].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testViewMemberReservations].[expected]
    IF OBJECT_ID('[testViewMemberReservations].[actual]', 'Table') IS NOT NULL
        DROP TABLE [testViewMemberReservations].[actual]

    SELECT TOP 0 *
    INTO [testViewMemberReservations].[expected]
    FROM (SELECT MGC.member_id, MGC.class_name AS class_name, MGC.room_id, MGC.start_timestamp, GC.end_timestamp
          FROM MemberGroupClass MGC
                   INNER JOIN GroupClass GC
                              ON GC.class_name = MGC.class_name
                                  AND GC.room_id = MGC.room_id
                                  AND GC.start_timestamp = MGC.start_timestamp) AS E;

    SELECT TOP 0 *
    INTO [testViewMemberReservations].[actual]
    FROM (SELECT MGC.member_id, MGC.class_name AS class_name, MGC.room_id, MGC.start_timestamp, GC.end_timestamp
          FROM MemberGroupClass MGC
                   INNER JOIN GroupClass GC
                              ON GC.class_name = MGC.class_name
                                  AND GC.room_id = MGC.room_id
                                  AND GC.start_timestamp = MGC.start_timestamp) AS A;

    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MemberGroupClass';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'GroupClass';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'RoomReservation';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Room';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'MachineReservation';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Machine';
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member';

    DECLARE @current_timestamp SMALLDATETIME = GETDATE();
    DECLARE @a_day_from_now DATETIME = DATEADD(DAY, 1, @current_timestamp);
    DECLARE @a_day_from_now_plus_30_minutes DATETIME = DATEADD(MINUTE, 30, @a_day_from_now);
    DECLARE @two_days_from_now DATETIME = DATEADD(DAY, 2, @current_timestamp);
    DECLARE @two_days_from_now_plus_30_minutes DATETIME = DATEADD(MINUTE, 30, @two_days_from_now);
    DECLARE @two_days_from_now_plus_1_hour DATETIME = DATEADD(HOUR, 1, @two_days_from_now);
    DECLARE @two_days_from_now_plus_1_hour_30_minutes DATETIME = DATEADD(MINUTE, 30, @two_days_from_now_plus_1_hour);
    DECLARE @two_days_from_now_plus_2_hours DATETIME = DATEADD(HOUR, 2, @two_days_from_now);
    DECLARE @two_days_from_now_plus_2_hours_30_minutes DATETIME = DATEADD(MINUTE, 30, @two_days_from_now_plus_2_hours);
    DECLARE @three_days_from_now DATETIME = DATEADD(DAY, 3, @current_timestamp);
    DECLARE @three_days_from_now_plus_30_minutes DATETIME = DATEADD(MINUTE, 30, @three_days_from_now);
    DECLARE @three_days_from_now_plus_1_hour DATETIME = DATEADD(HOUR, 1, @three_days_from_now);
    DECLARE @three_days_from_now_plus_1_hour_30_minutes DATETIME = DATEADD(MINUTE, 30, @three_days_from_now_plus_1_hour);

    INSERT INTO Member (member_id, first_name, last_name, phone_number, email, birthdate, guardian_first_name,
                        guardian_last_name, guardian_phone_number, guardian_email, guardian_birthdate)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'John', 'Doe', '1234567890', 'john@doe.com', '1970-01-01',
            NULL, NULL, NULL, NULL, NULL),
           ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Jane', 'Doe', '0987654321', 'jane@doe.com', '1975-01-01',
            NULL, NULL, NULL, NULL, NULL)

    INSERT INTO MemberGroupClass (member_id, class_name, room_id, start_timestamp)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Zumba', 1, @a_day_from_now);

    INSERT INTO GroupClass (class_name, room_id, start_timestamp, end_timestamp)
    VALUES ('Zumba', 1, @a_day_from_now, @a_day_from_now_plus_30_minutes);

    INSERT INTO RoomReservation (member_id, room_id, start_timestamp, end_timestamp)
    VALUES ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 2, @two_days_from_now, @two_days_from_now_plus_30_minutes),
           ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 2, @two_days_from_now_plus_1_hour,
            @two_days_from_now_plus_1_hour_30_minutes),
           ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 2, @two_days_from_now_plus_2_hours,
            @two_days_from_now_plus_2_hours_30_minutes);

    INSERT INTO Room (room_id, functionality) VALUES (2, 'Squash');

    INSERT INTO MachineReservation (machine_id, member_id, start_timestamp, end_timestamp)
    VALUES (1, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @three_days_from_now, @three_days_from_now_plus_30_minutes),
           (2, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @three_days_from_now_plus_30_minutes,
            @three_days_from_now_plus_1_hour),
           (3, 'ABCDEFGHIJK-123456789012-ABCDEFGHIJK', @three_days_from_now_plus_1_hour,
            @three_days_from_now_plus_1_hour_30_minutes);

    INSERT INTO Machine (machine_id, type_name, room_id)
    VALUES (1, 'Treadmill', 3),
           (2, 'Exercise bike', 3),
           (3, 'Stair climber', 3);
END
GO

/*
* T-01
* Test if the relevant information of the reservations of members gets fetched correctly.
*
* Expects
*   - The data of the reservations gets fetched correctly
*/
DROP PROCEDURE IF EXISTS testViewMemberReservations.[test if the relevant information of the reservations all members gets fetched correctly]
GO
CREATE PROCEDURE testViewMemberReservations.[test if the relevant information of the reservations all members gets fetched correctly]
AS
BEGIN
    -- Assemble
    DECLARE @current_timestamp SMALLDATETIME = GETDATE();
    DECLARE @a_day_from_now DATETIME = DATEADD(DAY, 1, @current_timestamp);
    DECLARE @a_day_from_now_plus_30_minutes DATETIME = DATEADD(MINUTE, 30, @a_day_from_now);
    DECLARE @two_days_from_now DATETIME = DATEADD(DAY, 2, @current_timestamp);
    DECLARE @two_days_from_now_plus_30_minutes DATETIME = DATEADD(MINUTE, 30, @two_days_from_now);
    DECLARE @two_days_from_now_plus_1_hour DATETIME = DATEADD(HOUR, 1, @two_days_from_now);
    DECLARE @two_days_from_now_plus_1_hour_30_minutes DATETIME = DATEADD(MINUTE, 30, @two_days_from_now_plus_1_hour);
    DECLARE @two_days_from_now_plus_2_hours DATETIME = DATEADD(HOUR, 2, @two_days_from_now);
    DECLARE @two_days_from_now_plus_2_hours_30_minutes DATETIME = DATEADD(MINUTE, 30, @two_days_from_now_plus_2_hours);
    DECLARE @three_days_from_now DATETIME = DATEADD(DAY, 3, @current_timestamp);
    DECLARE @three_days_from_now_plus_30_minutes DATETIME = DATEADD(MINUTE, 30, @three_days_from_now);
    DECLARE @three_days_from_now_plus_1_hour DATETIME = DATEADD(HOUR, 1, @three_days_from_now);
    DECLARE @three_days_from_now_plus_1_hour_30_minutes DATETIME = DATEADD(MINUTE, 30, @three_days_from_now_plus_1_hour);

    INSERT INTO [testViewMemberReservations].[expected] (member_id, class_name, room_id, start_timestamp, end_timestamp)
    VALUES ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Zumba', 1, @a_day_from_now, @a_day_from_now_plus_30_minutes),
           ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Squash', 2, @two_days_from_now, @two_days_from_now_plus_30_minutes),
           ('ZYXWVUTSRQP-210987654321-ZYXWVUTSRQP', 'Squash', 2, @two_days_from_now_plus_1_hour, @two_days_from_now_plus_1_hour_30_minutes),
           ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Squash', 2, @two_days_from_now_plus_2_hours,
            @two_days_from_now_plus_2_hours_30_minutes),
           ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Treadmill', 3, @three_days_from_now, @three_days_from_now_plus_30_minutes),
           ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Exercise bike', 3, @three_days_from_now_plus_30_minutes,
            @three_days_from_now_plus_1_hour),
           ('ABCDEFGHIJK-123456789012-ABCDEFGHIJK', 'Stair climber', 3, @three_days_from_now_plus_1_hour,
            @three_days_from_now_plus_1_hour_30_minutes);

    -- Act
    INSERT INTO [testViewMemberReservations].[actual]
        EXEC sproc_viewMemberReservations;

    -- Assert
    EXEC tSQLt.AssertEqualsTable 'testViewMemberReservations.expected', '[testViewMemberReservations].[actual]', '',
         'Tables do not match!';
END
GO