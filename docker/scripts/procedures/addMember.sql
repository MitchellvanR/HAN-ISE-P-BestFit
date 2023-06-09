/**
* UC-16
* SPROC-01: stored procedure to become a member that also calls another stored procedure to give the new member a subscription.
*
* Parameters
*	@first_name varchar(50) The client's first name.
*	@last_name varchar(50) The client's last name.
*	@phone_number varchar(10) (optional) The client's phone number. The client can choose if they'll share it or not,
*	@email varchar(255) The client's email.
*	@birthdate date The client's birthdate.
*	@guardian_first_name varchar(50) (optional) The client's guardian his first name. This only needs to be filled in if the client is underage.
*	@guardian_last_name varchar(50) (optional) The client's guardian his last name. This only needs to be filled in if the client is underage.
*	@guardian_phone_number varchar(10) (optional) The client's guardian his phone number. This can be filled in if the client is underage.
*	@guardian_email varchar(255) (optional) The client's guardian his email. This only needs to be filled in if the client is underage.
*	@guardian_birthdate date (optional) The client's guardian his birthdate. This only needs to be filled in if the client is underage.
*	@type varchar(50) The subscription type the client wants.
*	@end_date date The date until which the client has paid for their subscription.
*
* Return
*	- The client's information will be saved in the Member table.
*	- The subscription will be saved in the Subscription table using the stored procedure sproc_subscribeMember
*
* Rollbacks when
*	- There is no guardian information provided (or guardian information missing) while the new member is under 18.
*	- There's already a member with the provided email.
*	- The sproc_subscribeMember gives an error.
*/
DROP PROCEDURE IF EXISTS sproc_addMember
GO
CREATE PROCEDURE sproc_addMember @first_name varchar(50),
                                 @last_name varchar(50),
                                 @phone_number varchar(10),
                                 @email varchar(255),
                                 @birthdate date,
                                 @guardian_first_name varchar(50) NULL,
                                 @guardian_last_name varchar(50) NULL,
	                             @guardian_phone_number varchar(10) NULL,
	                             @guardian_email varchar(255) NULL,
	                             @guardian_birthdate date NULL,
	                             @type varchar(50)
AS
BEGIN
    DECLARE @savepoint varchar(128)= CAST(OBJECT_NAME(@@PROCID) AS varchar(125)) + CAST(@@NESTLEVEL AS varchar(3));
    DECLARE @startTrancount int= @@TRANCOUNT;
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        SAVE TRANSACTION @savepoint;
        DECLARE @member_id VARCHAR(255);

        SET @member_id = CONVERT(varchar(36), NEWID())
        WHILE EXISTS(SELECT * FROM Member WHERE member_id = @member_id) OR
              EXISTS(SELECT * FROM Employee WHERE employee_id = @member_id)
            BEGIN
                SET @member_id = CONVERT(varchar(36), NEWID())
            END

        INSERT INTO Member (member_id, first_name, last_name, phone_number, email, birthdate, guardian_first_name,
                            guardian_last_name, guardian_phone_number, guardian_email, guardian_birthdate)
        VALUES (@member_id, @first_name, @last_name, @phone_number, @email, @birthdate, @guardian_first_name,
                @guardian_last_name, @guardian_phone_number, @guardian_email, @guardian_birthdate);

        EXEC sproc_subscribeMember @member_id, @type;
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