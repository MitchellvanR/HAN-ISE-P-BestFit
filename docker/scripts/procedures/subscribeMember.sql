/**
* US-01 stored procedure to get a new subscription as an already-existing-member.
*
* Parameters
*	@member_id integer The member's ID.
*	@type varchar(50) The subscription type.
*	@paid_until date The date until which the member has paid.
*
* Return
*	- The subscription will be saved in the Subscription table. This includes the member id, subscription type,
*		start date (current date), end date, subscription status and the date until it's paid.
*
* Rollbacks when
*	- The member doesn't exist.
*	- The subscription type doesn't exist.
*	- The member already has a subscription with the same type.
*	- The member's age doesn't fit the subscription type.
*/
CREATE OR ALTER PROCEDURE sproc_subscribeMember
    @member_id integer,
    @type varchar(50),
    @paid_until date
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;
        IF EXISTS (SELECT * FROM Member WHERE member_id = @member_id)
            BEGIN
                IF EXISTS (SELECT * FROM SubscriptionType WHERE type = @type)
                    BEGIN
                        IF EXISTS (SELECT * FROM Subscription WHERE member_id = @member_id AND type = @type)
                            RAISERROR ('The member already has a subscription of this type.', 16, 1);
                        DECLARE @birthdate date
                        SET @birthdate = (SELECT birthdate FROM Member WHERE member_id = @member_id)
                        IF DATEDIFF(YEAR, @birthdate, GETDATE()) BETWEEN (SELECT CASE WHEN min_age IS NULL THEN 0 ELSE min_age END FROM SubscriptionType WHERE type = @type)
                            AND (SELECT CASE WHEN max_age IS NULL THEN 200 ELSE max_age END FROM SubscriptionType WHERE type = @type)
                            BEGIN
                                DECLARE @end_date date
                                SET @end_date = (SELECT DATEADD(MONTH, min_length, GETDATE()) FROM SubscriptionType WHERE type = @type)
                                INSERT INTO Subscription VALUES (@member_id, @type, GETDATE(), @end_date, 'Actief', @paid_until);
                            END
                        ELSE
                            RAISERROR ('The member does not fit the subscription due to their age.', 16, 1);
                    END
                ELSE
                    RAISERROR('This subscription type does not exist.', 16, 1);
            END
        ELSE
            RAISERROR('This member does not exist.', 16, 1);

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
                    'Error occured in sproc ''' + OBJECT_NAME(@@procid) + '''. Original message: ''' + ERROR_MESSAGE() +
                    '''';
        THROW 50000, @errormessage, 1;
    END CATCH;
END;
GO
