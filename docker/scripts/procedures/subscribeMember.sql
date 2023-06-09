/**
* UC-01
* SPROC-02: stored procedure to get a new subscription as an already-existing-member.
*
* Parameters
*	@member_id varchar(36) The member's ID.
*	@type varchar(50) The subscription type.
*	@end_date date The end date of the subscription.
*
* Return
*	- The subscription will be saved in the Subscription table. This includes the member id, subscription type,
*		start date (current date) and end date.
*
* Rollbacks when
*	- The member doesn't exist.
*	- The subscription type doesn't exist.
*	- The member already has a subscription with the same type.
*	- The member's age doesn't fit the subscription type.
*/
DROP PROCEDURE IF EXISTS sproc_subscribeMember
GO
CREATE PROCEDURE sproc_subscribeMember @member_id varchar(36),
                                       @type varchar(50)
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;
        BEGIN
            DECLARE @end_date date = (SELECT DATEADD(MONTH, min_length, GETDATE())
                                      FROM SubscriptionType
                                      WHERE type = @type)
            INSERT INTO Subscription VALUES (@member_id, @type, GETDATE(), @end_date);
        END
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
