/**
* UC-02
* SPROC-03: stored procedure to prolong a subscription by an amount of months (the end date, not paid until)
*
* Parameters
*	@member_id varchar(36) The id of the member whose subscription will be prolonged.
*	@type varchar(50) The type of the subscription that'll be prolonged.
*	@months_prolonged integer The amount of months the the subscription will be prolonged by.
*
* Return
*	- The end date of the subscription with the correct type and member id is updated.
*
* Rollbacks when
*	- The member doesn't exist.
*	- The subscription doesn't exist.
*	- The months prolonged is less than 1.
*	- The member is too old for the subscription by the time the subscription would end.
*/
DROP PROCEDURE IF EXISTS sproc_prolongSubscription
GO
CREATE PROCEDURE sproc_prolongSubscription @member_id varchar(36),
                                                    @type varchar(50),
                                                    @months_prolonged integer
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;

        IF EXISTS (SELECT * FROM Subscription WHERE member_id = @member_id AND type = @type)
            BEGIN
                IF @months_prolonged >= 1
                    BEGIN
                        UPDATE Subscription
                        SET end_date = DATEADD(MONTH, @months_prolonged, end_date)
                        WHERE member_id = @member_id
                            AND type = @type;
                    END
                ELSE
                    RAISERROR ('The amount of months prolonged is less than 1.',16,1);
            END
        ELSE
            BEGIN
                IF NOT EXISTS (SELECT * FROM Member WHERE member_id = @member_id)
                    RAISERROR ('This member does not exist.', 16, 1);
                ELSE
                    RAISERROR ('Your subscription is not found.', 16,1);
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
        SET @errormessage = 'Error occurred in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' +
                            ERROR_MESSAGE() + '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO