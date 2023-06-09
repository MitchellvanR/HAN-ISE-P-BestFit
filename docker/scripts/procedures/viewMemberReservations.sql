/**
* UC-10
* SPROC-13: stored procedure to view the member reservations.
*
* Parameters
*	None
*
* Return
*	- For every reservation the member has made:
        - @member_id varchar(36) The id of the member who made the reservation.
*		- @name varchar(50) The name of the reserved item (specific machine, group class, room).
*		- @room_id int The id of the reserved room.
*		- @start_timestamp datetime The start date and time of the reservation.
*		- @end_timestamp datetime The end date and time of the reservation.
*
* Rollbacks when
*    - This procedure doesn't have unique errors. It will throw an error if the member doesn't exist, due to the foreign key constraint.
*/
DROP PROCEDURE IF EXISTS sproc_viewMemberReservations;
GO
CREATE PROCEDURE sproc_viewMemberReservations
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SELECT MGC.member_id, MGC.class_name AS class_name, MGC.room_id, MGC.start_timestamp, GC.end_timestamp
        FROM MemberGroupClass MGC
                 INNER JOIN GroupClass GC
                            ON GC.class_name = MGC.class_name
                                AND GC.room_id = MGC.room_id
                                AND GC.start_timestamp = MGC.start_timestamp
        WHERE MGC.start_timestamp > GETDATE()
          AND MGC.start_timestamp < DATEADD(MONTH, 1, GETDATE())
        UNION ALL
        SELECT RS.member_id AS type, R.functionality AS class_name, RS.room_id, RS.start_timestamp, RS.end_timestamp
        FROM RoomReservation RS
                 INNER JOIN Room R ON R.room_id = RS.room_id
        WHERE RS.start_timestamp > GETDATE()
          AND RS.start_timestamp < DATEADD(MONTH, 1, GETDATE())
        UNION ALL
        SELECT MR.member_id, M.type_name AS class_name, M.room_id, MR.start_timestamp, MR.end_timestamp
        FROM MachineReservation MR
                 INNER JOIN Machine M
                            ON M.machine_id = MR.machine_id
        WHERE MR.start_timestamp > GETDATE()
          AND MR.start_timestamp < DATEADD(MONTH, 1, GETDATE())
    END TRY
    BEGIN CATCH
        ; THROW
    END CATCH
END ;
GO
