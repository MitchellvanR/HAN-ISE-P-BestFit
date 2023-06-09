/**
* UC-06
* SPROC-11: stored procedure to sign out a member from a group class.
*
* Parameters
*	@member_id varchar(36) The member's ID.
*	@class_name varchar(50) The name of the group class.
*   @room_id int The ID of the room where the group class takes place.
*   @start_timestamp datetime The start date and time of the group class.
*
* Return
*	- The registration in the MemberGroupClass table is deleted.
*
* Rollbacks when
*	- The member did not register for the group class.
*   - The member can't sign out once the group class has started.
*/
DROP PROCEDURE IF EXISTS sproc_signOutGroupClass
GO
CREATE PROCEDURE sproc_signOutGroupClass
    @member_id varchar(36),
	@class_name varchar(50),
    @room_id int,
    @start_timestamp datetime
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF NOT EXISTS (SELECT * FROM MemberGroupClass WHERE member_id = @member_id AND class_name = @class_name AND room_id = @room_id AND start_timestamp = @start_timestamp)
                RAISERROR('The member is not registered for this group class.', 16, 1);
        ELSE IF @start_timestamp < GETDATE()
                RAISERROR('The member cannot sign out once the group class has started.', 16, 1);
        ELSE
                DELETE FROM MemberGroupClass WHERE member_id = @member_id AND class_name = @class_name AND room_id = @room_id AND start_timestamp = @start_timestamp;

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
                    'Error occurred in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO
