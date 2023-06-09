EXEC [tSQLt].[NewTestClass] 'testAddMember'
GO

DROP PROCEDURE IF EXISTS testAddMember.[SetUp]
GO
CREATE PROCEDURE testAddMember.[SetUp]
AS
BEGIN
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Member'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'Subscription'
    EXEC tSQLt.FakeTable @SchemaName = 'dbo', @TableName = 'SubscriptionType'
    EXEC tSQLt.ApplyConstraint 'dbo.Member', 'ck_member_birthdate'
    EXEC tSQLt.ApplyConstraint 'dbo.Member', 'ck_member_guardian_birthdate'
    EXEC tSQLt.ApplyConstraint 'dbo.Member', 'ck_member_minor_guardian_filled'
    EXEC tSQLt.SpyProcedure @ProcedureName = 'sproc_subscribeMember'
END
GO

/*
* T-01
* Test if a member can be added and get a subscription correctly.
*
* Expects
*   - No exceptions
*/
DROP PROCEDURE IF EXISTS testAddMember.[test if a member can be added and get a subscription correctly.]
GO
CREATE PROCEDURE testAddMember.[test if a member can be added and get a subscription correctly.]
AS
BEGIN
    -- Assemble
    DECLARE @thirty_years_ago date = DATEADD(YEAR, -30, GETDATE());

    IF OBJECT_ID('[testAddMember].[expected]', 'Table') IS NOT NULL
        DROP TABLE [testAddMember].[expected]

    SELECT TOP 0 *
    INTO [testAddMember].[expected]
    FROM dbo.Member;

    INSERT INTO [testAddMember].[expected] (member_id, first_name, last_name, phone_number, email, birthdate, guardian_first_name,
                                            guardian_last_name, guardian_phone_number, guardian_email,
                                            guardian_birthdate)
    VALUES (NULL, 'John', 'Doe', NULL, 'john@doe.com', @thirty_years_ago, NULL, NULL, NULL, NULL, NULL);

    -- Act
    EXEC sproc_addMember 'John', 'Doe', NULL, 'john@doe.com', @thirty_years_ago, NULL, NULL, NULL, NULL, NULL,
         'All monthly';

    UPDATE Member SET member_id = NULL WHERE first_name = 'John';

    -- Assert
    EXEC [tSQLt].[AssertEqualsTable] 'testAddMember.expected', 'dbo.Member', '',
         'Tables do not match!';
END
GO

/*
* T-02
* Test if an underage member can be added with guardian information.
*
* Expects
*   - No exceptions
*/
DROP PROCEDURE IF EXISTS testAddMember.[test if an underage member can be added with guardian information.]
GO
CREATE PROCEDURE testAddMember.[test if an underage member can be added with guardian information.]
AS
BEGIN
    -- Assemble
    DECLARE @a_year_ago date = DATEADD(YEAR, -1, GETDATE());
    DECLARE @thirty_years_ago date = DATEADD(YEAR, -30, GETDATE());

    -- Expect
    EXEC [tSQLt].[ExpectNoException]

    -- Act
    EXEC sproc_addMember 'John', 'Doe', NULL, 'john@doe.com', @a_year_ago, 'Jane', 'Doe', NULL, 'jane@doe.com',
         @thirty_years_ago, 'All monthly';
END
GO


/*
* T-03
* Test if an underage member can't be added without guardian information.
*
* Expects
*   - Exception like: The INSERT statement conflicted with the CHECK constraint "ck_member_minor_guardian_filled".
*/
DROP PROCEDURE IF EXISTS testAddMember.[test if an underage member can't be added without guardian information.]
GO
CREATE PROCEDURE testAddMember.[test if an underage member can't be added without guardian information.]
AS
BEGIN
    -- Assemble
    DECLARE @a_year_ago date = DATEADD(YEAR, -1, GETDATE());

    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%The INSERT statement conflicted with the CHECK constraint "ck_member_minor_guardian_filled".%'

    -- Act
    EXEC sproc_addMember 'John', 'Doe', NULL, 'john@doe.com', @a_year_ago, NULL, NULL, NULL, NULL, NULL, 'All monthly';
END
GO

/*
* T-04
* Test if a member can't be added with the same email as someone else.
*
* Expects
*   - Exception like: Violation of UNIQUE KEY constraint ''uq_member_email''.
*/
DROP PROCEDURE IF EXISTS testAddMember.[test if a member can't be added with the same email as someone else.]
GO
CREATE PROCEDURE testAddMember.[test if a member can't be added with the same email as someone else.]
AS
BEGIN
    -- Assemble
    EXEC tSQLt.ApplyConstraint 'dbo.Member', 'UQ_Member_email'

    DECLARE @thirty_years_ago date = DATEADD(YEAR, -30, GETDATE());

    -- Expect
    EXEC [tSQLt].[ExpectException]
         @ExpectedMessagePattern = '%Violation of UNIQUE KEY constraint ''uq_member_email''.%'
    INSERT INTO Member (email) VALUES ('john@doe.com');

    -- Act
    EXEC sproc_addMember 'John', 'Doe', NULL, 'john@doe.com', @thirty_years_ago, NULL, NULL, NULL, NULL, NULL,
         'All monthly';
END
GO
