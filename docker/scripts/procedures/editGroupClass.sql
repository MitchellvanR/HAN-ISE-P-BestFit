/**
* UC-13
* SPROC-14: stored procedure to edit a scheduled group class.
*
* Parameters
*
*   @identifying_class_name varchar(50) The (current) name of the group class that needs to be edited.
*   @identifying_room_id int The (current) room in which the group class that needs to be edited will be given.
*   @identifying_start_timestamp datetime The (current) starting timestamp on which the group class that needs to be edited will be given.
*   @class_name varchar(50) The new name of the group class (NULL if it should stay the same).
*   @room_id int The new room id of the group class (NULL if it should stay the same).
*   @start_timestamp datetime The new starting timestamp of the group class (NULL if it should stay the same).
*   @employee_id varchar(36) The new employee id of the group class (NULL if it should stay the same).
*   @end_timestamp datetime The new ending timestamp of the group class (NULL if it should stay the same).
*
* Rollbacks when
*	- The room_id is edited to a room that is already in use.
*   - The room_id is edited to a room that doesn't exist.
*   - The room_id is edited to a room that doesn't support group classes.
*   - The start_timestamp is edited to a timestamp that is after the end_timestamp.
*   - The start_timestamp is edited to a timestamp that is in the past.
*   - The employee_id is edited to an employee that isn't qualified to instruct a given group class.
*   - The employee_id is edited to an employee that doesn't exist.
*   - The end_timestamp is edited to a timestamp that is before the start_timestamp.
*   - The end_timestamp is edited to a timestamp that is in the past.
*/
DROP PROCEDURE IF EXISTS sproc_editGroupClass
GO
CREATE PROCEDURE sproc_editGroupClass @identifying_class_name varchar(50),
                                      @identifying_room_id int,
                                      @identifying_start_timestamp datetime,
                                      @class_name varchar(50) = NULL,
                                      @room_id int = NULL,
                                      @start_timestamp datetime = NULL,
                                      @employee_id varchar(36) = NULL,
                                      @end_timestamp datetime = NULL
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF NOT EXISTS
            (SELECT class_name, room_id, start_timestamp
             FROM GroupClass
             WHERE class_name = @identifying_class_name
               AND room_id = @identifying_room_id
               AND start_timestamp = @identifying_start_timestamp)
            RAISERROR ('No group class with this combination of name, location and starting time was found.', 16, 1);

        UPDATE GroupClass
        SET class_name      = ISNULL(@class_name, class_name),
            room_id         = ISNULL(@room_id, room_id),
            start_timestamp = ISNULL(@start_timestamp, start_timestamp),
            employee_id     = ISNULL(@employee_id, employee_id),
            end_timestamp   = ISNULL(@end_timestamp, end_timestamp)
        WHERE class_name = @identifying_class_name
          AND room_id = @identifying_room_id
          AND start_timestamp = @identifying_start_timestamp
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1 AND @startTrancount = 0
            BEGIN
                ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
                IF XACT_STATE() = 1
                    BEGIN
                        ROLLBACK TRANSACTION @savepoint;
                        COMMIT TRANSACTION;
                    END;
            END;
        DECLARE @errormessage varchar(2000);
        SET @errormessage =
                    'Error occurred in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' +
                    ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO
