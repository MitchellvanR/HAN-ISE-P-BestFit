USE master
GO

IF NOT EXISTS(SELECT *
              FROM sys.databases
              WHERE name = N'ise_project_prototype')
    BEGIN
        CREATE DATABASE ise_project_prototype
    END
GO

USE ise_project_prototype
GO

IF NOT EXISTS(SELECT *
              FROM sys.tables
              WHERE name = N'reservations')
    BEGIN
        CREATE TABLE dbo.reservations
        (
            member_id  INT,
            member     VARCHAR(255),
            title      VARCHAR(255),
            date       DATE,
            start_time TIME,
            end_time   TIME,
            persons    INT
        )
    END
GO