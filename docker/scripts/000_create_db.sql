/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014                    */
/* Created on:     8-5-2023 15:43:47                            */
/*==============================================================*/
USE master
GO
DROP DATABASE IF EXISTS BestFit
GO
CREATE DATABASE BestFit
GO
USE BestFit
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('EmployeeGroupClassType')
             AND o.name = 'fk_employee_empoyeegroupclasstype')
ALTER TABLE EmployeeGroupClassType
    DROP CONSTRAINT fk_employee_empoyeegroupclasstype
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('EmployeeGroupClassType')
             AND o.name = 'fk_employee_employee__groupcla')
ALTER TABLE EmployeeGroupClassType
    DROP CONSTRAINT fk_employee_employee__groupcla
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('EmployeeRole')
             AND o.name = 'fk_role_employee__role')
ALTER TABLE EmployeeRole
    DROP CONSTRAINT fk_role_employee__role
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('EmployeeRole')
             AND o.name = 'fk_employee_employee__role')
ALTER TABLE EmployeeRole
    DROP CONSTRAINT fk_employee_employee__role
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('FitnessRoomSchedule')
             AND o.name = 'fk_fitnessr_fitness_r_employee')
ALTER TABLE FitnessRoomSchedule
    DROP CONSTRAINT fk_fitnessr_fitness_r_employee
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('FitnessRoomSchedule')
             AND o.name = 'fk_fitnessr_fitness_r_room')
ALTER TABLE FitnessRoomSchedule
    DROP CONSTRAINT fk_fitnessr_fitness_r_room
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('GroupClass')
             AND o.name = 'fk_groupclass_employee')
ALTER TABLE GroupClass
    DROP CONSTRAINT fk_groupclass_employee
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('GroupClass')
             AND o.name = 'fk_groupcla_group_cla_groupcla')
ALTER TABLE GroupClass
    DROP CONSTRAINT fk_groupcla_group_cla_groupcla
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('GroupClass')
             AND o.name = 'fk_groupcla_group_cla_room')
ALTER TABLE GroupClass
    DROP CONSTRAINT fk_groupcla_group_cla_room
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('GroupClassTypeSubscriptionType')
             AND o.name = 'fk_group_cl_group_cla_groupcla')
ALTER TABLE GroupClassTypeSubscriptionType
    DROP CONSTRAINT fk_group_cl_group_cla_groupcla
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('GroupClassTypeSubscriptionType')
             AND o.name = 'fk_group_cl_group_cla_subscrip')
ALTER TABLE GroupClassTypeSubscriptionType
    DROP CONSTRAINT fk_group_cl_group_cla_subscrip
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('Machine')
             AND o.name = 'fk_machine_machine_m_machinet')
ALTER TABLE Machine
    DROP CONSTRAINT fk_machine_machine_m_machinet
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('Machine')
             AND o.name = 'fk_machine_machine_r_room')
ALTER TABLE Machine
    DROP CONSTRAINT fk_machine_machine_r_room
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('MachineReservation')
             AND o.name = 'fk_machiner_machine_i_machine')
ALTER TABLE MachineReservation
    DROP CONSTRAINT fk_machiner_machine_i_machine
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('MachineReservation')
             AND o.name = 'fk_machiner_member_in_member')
ALTER TABLE MachineReservation
    DROP CONSTRAINT fk_machiner_member_in_member
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('MemberGroupClass')
             AND o.name = 'fk_member_g_member_gr_member')
ALTER TABLE MemberGroupClass
    DROP CONSTRAINT fk_member_g_member_gr_member
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('MemberGroupClass')
             AND o.name = 'fk_member_g_member_gr_groupcla')
ALTER TABLE MemberGroupClass
    DROP CONSTRAINT fk_member_g_member_gr_groupcla
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('RoomReservation')
             AND o.name = 'fk_roomrese_member_sq_member')
ALTER TABLE RoomReservation
    DROP CONSTRAINT fk_roomrese_member_sq_member
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('RoomReservation')
             AND o.name = 'fk_roomrese_squash_ro_room')
ALTER TABLE RoomReservation
    DROP CONSTRAINT fk_roomrese_squash_ro_room
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('Subscription')
             AND o.name = 'fk_subscrip_member_in_member')
ALTER TABLE Subscription
    DROP CONSTRAINT fk_subscrip_member_in_member
GO

IF EXISTS (SELECT 1
           FROM sys.sysreferences r
                    JOIN sys.sysobjects o ON (o.id = r.constid AND o.type = 'F')
           WHERE r.fkeyid = OBJECT_ID('Subscription')
             AND o.name = 'fk_subscrip_subscript_subscrip')
ALTER TABLE Subscription
    DROP CONSTRAINT fk_subscrip_subscript_subscrip
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('Employee')
             AND type = 'U')
    DROP TABLE Employee
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('EmployeeGroupClassType')
             AND name = 'employee_group_class_type2_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX EmployeeGroupClassType.employee_group_class_type2_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('EmployeeGroupClassType')
             AND name = 'employee_group_class_type_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX EmployeeGroupClassType.employee_group_class_type_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('EmployeeGroupClassType')
             AND type = 'U')
    DROP TABLE EmployeeGroupClassType
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('EmployeeRole')
             AND name = 'employee_role2_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX EmployeeRole.employee_role2_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('EmployeeRole')
             AND name = 'employee_role_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX EmployeeRole.employee_role_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('EmployeeRole')
             AND type = 'U')
    DROP TABLE EmployeeRole
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('FitnessRoomSchedule')
             AND name = 'fitness_room_schedule_fitness_room_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX FitnessRoomSchedule.fitness_room_schedule_fitness_room_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('FitnessRoomSchedule')
             AND name = 'fitness_room_schedule_employee_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX FitnessRoomSchedule.fitness_room_schedule_employee_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('FitnessRoomSchedule')
             AND type = 'U')
    DROP TABLE FitnessRoomSchedule
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('GroupClass')
             AND name = 'group_class_room_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX GroupClass.group_class_room_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('GroupClass')
             AND name = 'group_class_employee_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX GroupClass.group_class_employee_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('GroupClass')
             AND name = 'group_class_in_group_class_type_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX GroupClass.group_class_in_group_class_type_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('GroupClass')
             AND type = 'U')
    DROP TABLE GroupClass
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('GroupClassType')
             AND type = 'U')
    DROP TABLE GroupClassType
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('GroupClassTypeSubscriptionType')
             AND name = 'group_class_type_subscription_type2_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX GroupClassTypeSubscriptionType.group_class_type_subscription_type2_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('GroupClassTypeSubscriptionType')
             AND name = 'group_class_type_subscription_type_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX GroupClassTypeSubscriptionType.group_class_type_subscription_type_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('GroupClassTypeSubscriptionType')
             AND type = 'U')
    DROP TABLE GroupClassTypeSubscriptionType
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('Machine')
             AND name = 'machine_room_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX Machine.machine_room_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('Machine')
             AND name = 'machine_machine_type_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX Machine.machine_machine_type_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('Machine')
             AND type = 'U')
    DROP TABLE Machine
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('MachineReservation')
             AND name = 'member_in_machine_reservation_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX MachineReservation.member_in_machine_reservation_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('MachineReservation')
             AND name = 'machine_in_machine_reservation_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX MachineReservation.machine_in_machine_reservation_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('MachineReservation')
             AND type = 'U')
    DROP TABLE MachineReservation
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('MachineType')
             AND type = 'U')
    DROP TABLE MachineType
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('Member')
             AND type = 'U')
    DROP TABLE Member
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('MemberGroupClass')
             AND name = 'member_group_class2_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX MemberGroupClass.member_group_class2_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('MemberGroupClass')
             AND name = 'member_group_class_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX MemberGroupClass.member_group_class_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('MemberGroupClass')
             AND type = 'U')
    DROP TABLE MemberGroupClass
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('Role')
             AND type = 'U')
    DROP TABLE Role
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('Room')
             AND type = 'U')
    DROP TABLE Room
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('RoomReservation')
             AND name = 'squash_room_squash_reservation_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX RoomReservation.squash_room_squash_reservation_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('RoomReservation')
             AND name = 'member_squash_reservation_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX RoomReservation.member_squash_reservation_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('RoomReservation')
             AND type = 'U')
    DROP TABLE RoomReservation
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('Subscription')
             AND name = 'subscription_type_in_subscription_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX Subscription.subscription_type_in_subscription_fk
GO

IF EXISTS (SELECT 1
           FROM sysindexes
           WHERE id = OBJECT_ID('Subscription')
             AND name = 'member_in_subscription_fk'
             AND indid > 0
             AND indid < 255)
    DROP INDEX Subscription.member_in_subscription_fk
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('Subscription')
             AND type = 'U')
    DROP TABLE Subscription
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('SubscriptionType')
             AND type = 'U')
    DROP TABLE SubscriptionType
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'age')
    DROP TYPE AGE
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'amount_of_months')
    DROP TYPE AMOUNT_OF_MONTHS
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'amount_of_weeks')
    DROP TYPE AMOUNT_OF_WEEKS
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'class_name')
    DROP TYPE CLASS_NAME
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'date')
    DROP TYPE [DATE]
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'duration')
    DROP TYPE DURATION
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'email')
    EXECUTE sp_unbindrule EMAIL
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'email')
    DROP TYPE EMAIL
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'employee_id')
    DROP TYPE EMPLOYEE_ID
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'first_name')
    DROP TYPE FIRST_NAME
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'last_name')
    DROP TYPE LAST_NAME
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'machine_id')
    DROP TYPE MACHINE_ID
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'machine_status')
    EXECUTE sp_unbindrule MACHINE_STATUS
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'machine_status')
    DROP TYPE MACHINE_STATUS
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'machine_type')
    DROP TYPE MACHINE_TYPE
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'member_id')
    DROP TYPE MEMBER_ID
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'phone_number')
    DROP TYPE PHONE_NUMBER
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'quantity')
    DROP TYPE QUANTITY
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'role_name')
    DROP TYPE ROLE_NAME
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'room_functionality')
    EXECUTE sp_unbindrule ROOM_FUNCTIONALITY
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'room_functionality')
    DROP TYPE ROOM_FUNCTIONALITY
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'room_id')
    DROP TYPE ROOM_ID
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'subscription_type')
    DROP TYPE SUBSCRIPTION_TYPE
GO

IF EXISTS(SELECT 1
          FROM systypes
          WHERE name = 'datetime')
    DROP TYPE [DATETIME]
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('r_email')
             AND type = 'R')
    DROP RULE r_email
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('r_machine_status')
             AND type = 'R')
    DROP RULE r_machine_status
GO

IF EXISTS (SELECT 1
           FROM sysobjects
           WHERE id = OBJECT_ID('r_room_functionality')
             AND type = 'R')
    DROP RULE r_room_functionality
GO

CREATE RULE r_email AS
    @column >= '0'
GO

CREATE RULE r_machine_status AS
    @column IN ('Active', 'Out of order')
GO

CREATE RULE r_room_functionality AS
    @column IN ('Fitness', 'GroupClass', 'Squash')
GO

/*==============================================================*/
/* Domain: age                                                  */
/*==============================================================*/
CREATE TYPE AGE
    FROM INT
GO

/*==============================================================*/
/* Domain: amount_of_months                                     */
/*==============================================================*/
CREATE TYPE AMOUNT_OF_MONTHS
    FROM INT
GO

/*==============================================================*/
/* Domain: amount_of_weeks                                      */
/*==============================================================*/
CREATE TYPE AMOUNT_OF_WEEKS
    FROM INT
GO

/*==============================================================*/
/* Domain: class_name                                           */
/*==============================================================*/
CREATE TYPE CLASS_NAME
    FROM VARCHAR(50)
GO

/*==============================================================*/
/* Domain: date                                                 */
/*==============================================================*/
CREATE TYPE [DATE]
    FROM DATE
GO

/*==============================================================*/
/* Domain: duration                                             */
/*==============================================================*/
CREATE TYPE DURATION
    FROM VARCHAR(50)
GO

/*==============================================================*/
/* Domain: email                                                */
/*==============================================================*/
CREATE TYPE EMAIL
    FROM VARCHAR(255)
GO

EXECUTE sp_bindrule r_email, EMAIL
GO

/*==============================================================*/
/* Domain: employee_id                                          */
/*==============================================================*/
CREATE TYPE EMPLOYEE_ID
    FROM VARCHAR(36) 
GO

/*==============================================================*/
/* Domain: first_name                                           */
/*==============================================================*/
CREATE TYPE FIRST_NAME
    FROM VARCHAR(50)
GO

/*==============================================================*/
/* Domain: last_name                                            */
/*==============================================================*/
CREATE TYPE LAST_NAME
    FROM VARCHAR(50)
GO

/*==============================================================*/
/* Domain: machine_id                                           */
/*==============================================================*/
CREATE TYPE MACHINE_ID
    FROM INT
GO

/*==============================================================*/
/* Domain: machine_status                                       */
/*==============================================================*/
CREATE TYPE MACHINE_STATUS
    FROM VARCHAR(15)
GO

EXECUTE sp_bindrule r_machine_status, MACHINE_STATUS
GO

/*==============================================================*/
/* Domain: machine_type                                         */
/*==============================================================*/
CREATE TYPE MACHINE_TYPE
    FROM VARCHAR(50)
GO

/*==============================================================*/
/* Domain: member_id                                            */
/*==============================================================*/
CREATE TYPE MEMBER_ID
    FROM VARCHAR(36)
GO

/*==============================================================*/
/* Domain: phone_number                                         */
/*==============================================================*/
CREATE TYPE PHONE_NUMBER
    FROM VARCHAR(10)
GO

/*==============================================================*/
/* Domain: quantity                                             */
/*==============================================================*/
CREATE TYPE QUANTITY
    FROM INT
GO

/*==============================================================*/
/* Domain: role_name                                            */
/*==============================================================*/
CREATE TYPE ROLE_NAME
    FROM VARCHAR(50)
GO

/*==============================================================*/
/* Domain: room_functionality                                   */
/*==============================================================*/
CREATE TYPE ROOM_FUNCTIONALITY
    FROM VARCHAR(25)
GO

EXECUTE sp_bindrule r_room_functionality, ROOM_FUNCTIONALITY
GO

/*==============================================================*/
/* Domain: room_id                                              */
/*==============================================================*/
CREATE TYPE ROOM_ID
    FROM INT
GO

/*==============================================================*/
/* Domain: subscription_type                                    */
/*==============================================================*/
CREATE TYPE SUBSCRIPTION_TYPE
    FROM VARCHAR(50)
GO

/*==============================================================*/
/* Domain: datetime                                             */
/*==============================================================*/
CREATE TYPE [DATETIME]
    FROM DATETIME
GO

/*==============================================================*/
/* Table: Employee                                              */
/*==============================================================*/
CREATE TABLE Employee
(
    employee_id EMPLOYEE_ID NOT NULL,
    first_name  FIRST_NAME  NOT NULL,
    last_name   LAST_NAME   NOT NULL,
    CONSTRAINT pk_employee PRIMARY KEY (employee_id)
)
GO

/*==============================================================*/
/* Table: EmployeeGroupClassType                             */
/*==============================================================*/
CREATE TABLE EmployeeGroupClassType
(
    employee_id EMPLOYEE_ID NOT NULL,
    class_name  CLASS_NAME  NOT NULL,
    CONSTRAINT pk_employee_group_class_type PRIMARY KEY (employee_id, class_name)
)
GO

/*==============================================================*/
/* Index: employee_group_class_type_fk                          */
/*==============================================================*/



CREATE NONCLUSTERED INDEX employee_group_class_type_fk ON EmployeeGroupClassType (employee_id ASC)
GO

/*==============================================================*/
/* Index: employee_group_class_type2_fk                         */
/*==============================================================*/



CREATE NONCLUSTERED INDEX employee_group_class_type2_fk ON EmployeeGroupClassType (class_name ASC)
GO

/*==============================================================*/
/* Table: EmployeeRole                                         */
/*==============================================================*/
CREATE TABLE EmployeeRole
(
    role_name   ROLE_NAME   NOT NULL,
    employee_id EMPLOYEE_ID NOT NULL,
    CONSTRAINT pk_employee_role PRIMARY KEY (role_name, employee_id)
)
GO

/*==============================================================*/
/* Index: employee_role_fk                                      */
/*==============================================================*/



CREATE NONCLUSTERED INDEX employee_role_fk ON EmployeeRole (role_name ASC)
GO

/*==============================================================*/
/* Index: employee_role2_fk                                     */
/*==============================================================*/



CREATE NONCLUSTERED INDEX employee_role2_fk ON EmployeeRole (employee_id ASC)
GO

/*==============================================================*/
/* Table: FitnessRoomSchedule                                   */
/*==============================================================*/
CREATE TABLE FitnessRoomSchedule
(
    employee_id     EMPLOYEE_ID NOT NULL,
    room_id         ROOM_ID     NOT NULL,
    start_timestamp [DATETIME]  NOT NULL,
    end_timestamp   [DATETIME]  NOT NULL,
    CONSTRAINT pk_fitnessroomschedule PRIMARY KEY (employee_id, room_id, start_timestamp),
    CONSTRAINT ck_fitnessroomschedule_start_end CHECK (start_timestamp < end_timestamp),
)
GO

/*==============================================================*/
/* Index: fitness_room_schedule_employee_fk                     */
/*==============================================================*/



CREATE NONCLUSTERED INDEX fitness_room_schedule_employee_fk ON FitnessRoomSchedule (employee_id ASC)
GO

/*==============================================================*/
/* Index: fitness_room_schedule_fitness_room_fk                 */
/*==============================================================*/



CREATE NONCLUSTERED INDEX fitness_room_schedule_fitness_room_fk ON FitnessRoomSchedule (room_id ASC)
GO

/*==============================================================*/
/* Table: GroupClass                                            */
/*==============================================================*/
CREATE TABLE GroupClass
(
    class_name      CLASS_NAME  NOT NULL,
    room_id         ROOM_ID     NOT NULL,
    start_timestamp [DATETIME]  NOT NULL,
    employee_id     EMPLOYEE_ID NOT NULL,
    end_timestamp   [DATETIME]  NOT NULL,
    CONSTRAINT pk_groupclass PRIMARY KEY (class_name, room_id, start_timestamp),
    CONSTRAINT ck_groupclass_start_end CHECK (start_timestamp < end_timestamp),
)
GO

/*==============================================================*/
/* Index: group_class_in_group_class_type_fk                    */
/*==============================================================*/



CREATE NONCLUSTERED INDEX group_class_in_group_class_type_fk ON GroupClass (class_name ASC)
GO

/*==============================================================*/
/* Index: group_class_employee_fk                               */
/*==============================================================*/



CREATE NONCLUSTERED INDEX group_class_employee_fk ON GroupClass (employee_id ASC)
GO

/*==============================================================*/
/* Index: group_class_room_fk                                   */
/*==============================================================*/



CREATE NONCLUSTERED INDEX group_class_room_fk ON GroupClass (room_id ASC)
GO

/*==============================================================*/
/* Table: GroupClassType                                        */
/*==============================================================*/
CREATE TABLE GroupClassType
(
    class_name       CLASS_NAME NOT NULL,
    max_participants QUANTITY   NOT NULL,
    CONSTRAINT pk_groupclasstype PRIMARY KEY (class_name),
    CONSTRAINT ck_groupclasstype_max_participants CHECK (max_participants > 0),
)
GO

/*==============================================================*/
/* Table: GroupClassTypeSubscriptionType                    */
/*==============================================================*/
CREATE TABLE GroupClassTypeSubscriptionType
(
    class_name CLASS_NAME        NOT NULL,
    type       SUBSCRIPTION_TYPE NOT NULL,
    CONSTRAINT pk_group_class_type_subscripti PRIMARY KEY (class_name, type)
)
GO

/*==============================================================*/
/* Index: group_class_type_subscription_type_fk                 */
/*==============================================================*/



CREATE NONCLUSTERED INDEX group_class_type_subscription_type_fk ON GroupClassTypeSubscriptionType (class_name ASC)
GO

/*==============================================================*/
/* Index: group_class_type_subscription_type2_fk                */
/*==============================================================*/



CREATE NONCLUSTERED INDEX group_class_type_subscription_type2_fk ON GroupClassTypeSubscriptionType (type ASC)
GO

/*==============================================================*/
/* Table: Machine                                               */
/*==============================================================*/
CREATE TABLE Machine
(
    machine_id     MACHINE_ID     NOT NULL,
    room_id        ROOM_ID        NOT NULL,
    type_name      MACHINE_TYPE   NOT NULL,
    machine_status MACHINE_STATUS NOT NULL,
    CONSTRAINT pk_machine PRIMARY KEY (machine_id)
)
GO

/*==============================================================*/
/* Index: machine_machine_type_fk                               */
/*==============================================================*/



CREATE NONCLUSTERED INDEX machine_machine_type_fk ON Machine (type_name ASC)
GO

/*==============================================================*/
/* Index: machine_room_fk                                       */
/*==============================================================*/



CREATE NONCLUSTERED INDEX machine_room_fk ON Machine (room_id ASC)
GO

/*==============================================================*/
/* Table: MachineReservation                                    */
/*==============================================================*/
CREATE TABLE MachineReservation
(
    machine_id      MACHINE_ID NOT NULL,
    member_id       MEMBER_ID  NOT NULL,
    start_timestamp [DATETIME] NOT NULL,
    end_timestamp   [DATETIME] NOT NULL,
    CONSTRAINT pk_machinereservation PRIMARY KEY (machine_id, member_id, start_timestamp),
    CONSTRAINT ck_machinereservation_start_end CHECK (start_timestamp < end_timestamp),
)
GO

/*==============================================================*/
/* Index: machine_in_machine_reservation_fk                     */
/*==============================================================*/



CREATE NONCLUSTERED INDEX machine_in_machine_reservation_fk ON MachineReservation (machine_id ASC)
GO

/*==============================================================*/
/* Index: member_in_machine_reservation_fk                      */
/*==============================================================*/



CREATE NONCLUSTERED INDEX member_in_machine_reservation_fk ON MachineReservation (member_id ASC)
GO

/*==============================================================*/
/* Table: MachineType                                           */
/*==============================================================*/
CREATE TABLE MachineType
(
    type_name MACHINE_TYPE NOT NULL,
    CONSTRAINT pk_machinetype PRIMARY KEY (type_name)
)
GO

/*==============================================================*/
/* Table: Member                                                */
/*==============================================================*/
CREATE TABLE Member
(
    member_id             MEMBER_ID    NOT NULL,
    first_name            FIRST_NAME   NOT NULL,
    last_name             LAST_NAME    NOT NULL,
    phone_number          PHONE_NUMBER NULL,
    email                 EMAIL        NOT NULL UNIQUE,
    birthdate             [DATE]       NOT NULL,
    guardian_first_name   FIRST_NAME   NULL,
    guardian_last_name    LAST_NAME    NULL,
    guardian_phone_number PHONE_NUMBER NULL,
    guardian_email        EMAIL        NULL,
    guardian_birthdate    [DATE]       NULL,
    CONSTRAINT pk_member PRIMARY KEY (member_id),
    CONSTRAINT uq_member_email UNIQUE (email),
    CONSTRAINT ck_member_birthdate CHECK (birthdate < GETDATE()),
    CONSTRAINT ck_member_guardian_birthdate CHECK (
        (guardian_birthdate < GETDATE()
        AND guardian_birthdate < birthdate
        AND guardian_birthdate <= DATEADD(year, -18, GETDATE()))
        OR guardian_birthdate IS NULL),
    CONSTRAINT ck_member_minor_guardian_filled CHECK (
            (DATEDIFF(YEAR, birthdate, GETDATE()) < 18
                AND (guardian_first_name IS NOT NULL
                    OR guardian_last_name IS NOT NULL
                    OR guardian_email IS NOT NULL
                    OR guardian_birthdate IS NOT NULL))
            OR DATEDIFF(YEAR, birthdate, GETDATE()) >= 18)
)
GO

/*==============================================================*/
/* Table: MemberGroupClass                                    */
/*==============================================================*/
CREATE TABLE MemberGroupClass
(
    member_id       MEMBER_ID  NOT NULL,
    class_name      CLASS_NAME NOT NULL,
    room_id         ROOM_ID    NOT NULL,
    start_timestamp [DATETIME] NOT NULL,
    CONSTRAINT pk_member_group_class PRIMARY KEY (class_name, member_id, room_id, start_timestamp)
)
GO

/*==============================================================*/
/* Index: member_group_class_fk                                 */
/*==============================================================*/



CREATE NONCLUSTERED INDEX member_group_class_fk ON MemberGroupClass (member_id ASC)
GO

/*==============================================================*/
/* Index: member_group_class2_fk                                */
/*==============================================================*/



CREATE NONCLUSTERED INDEX member_group_class2_fk ON MemberGroupClass (class_name ASC,
                                                                      room_id ASC,
                                                                      start_timestamp ASC)
GO

/*==============================================================*/
/* Table: Role                                                  */
/*==============================================================*/
CREATE TABLE Role
(
    role_name ROLE_NAME NOT NULL,
    CONSTRAINT pk_role PRIMARY KEY (role_name)
)
GO

/*==============================================================*/
/* Table: Room                                                  */
/*==============================================================*/
CREATE TABLE Room
(
    room_id       ROOM_ID            NOT NULL,
    functionality ROOM_FUNCTIONALITY NOT NULL,
    max_people    QUANTITY           NOT NULL,
    CONSTRAINT pk_room PRIMARY KEY (room_id),
    CONSTRAINT ck_room_max_people CHECK (max_people > 0),
)
GO

/*==============================================================*/
/* Table: RoomReservation                                       */
/*==============================================================*/
CREATE TABLE RoomReservation
(
    member_id       MEMBER_ID  NOT NULL,
    room_id         ROOM_ID    NOT NULL,
    start_timestamp [DATETIME] NOT NULL,
    end_timestamp   [DATETIME] NOT NULL,
    quantity        QUANTITY   NOT NULL
    CONSTRAINT ckc_quantity_roomrese CHECK (quantity > 0),
    CONSTRAINT pk_roomreservation PRIMARY KEY (member_id, room_id, start_timestamp),
    CONSTRAINT ck_roomreservation_start_end CHECK (start_timestamp < end_timestamp),
)
GO

/*==============================================================*/
/* Index: member_squash_reservation_fk                          */
/*==============================================================*/



CREATE NONCLUSTERED INDEX member_squash_reservation_fk ON RoomReservation (member_id ASC)
GO

/*==============================================================*/
/* Index: squash_room_squash_reservation_fk                     */
/*==============================================================*/



CREATE NONCLUSTERED INDEX squash_room_squash_reservation_fk ON RoomReservation (room_id ASC)
GO

/*==============================================================*/
/* Table: Subscription                                          */
/*==============================================================*/
CREATE TABLE Subscription
(
    member_id           MEMBER_ID           NOT NULL,
    type                SUBSCRIPTION_TYPE   NOT NULL,
    start_date          [DATE]              NOT NULL,
    end_date            [DATE]              NOT NULL,
    CONSTRAINT pk_subscription PRIMARY KEY (member_id, type, start_date),
    CONSTRAINT ck_subscription_start_date_end_date CHECK (start_date < end_date),
)
GO

/*==============================================================*/
/* Index: member_in_subscription_fk                             */
/*==============================================================*/



CREATE NONCLUSTERED INDEX member_in_subscription_fk ON Subscription (member_id ASC)
GO

/*==============================================================*/
/* Index: subscription_type_in_subscription_fk                  */
/*==============================================================*/



CREATE NONCLUSTERED INDEX subscription_type_in_subscription_fk ON Subscription (type ASC)
GO

/*==============================================================*/
/* Table: SubscriptionType                                      */
/*==============================================================*/
CREATE TABLE SubscriptionType
(
    type          SUBSCRIPTION_TYPE NOT NULL,
    notice_period AMOUNT_OF_WEEKS   NOT NULL,
    min_length    AMOUNT_OF_MONTHS  NOT NULL,
    min_age       AGE               NULL,
    max_age       AGE               NULL,
    CONSTRAINT pk_subscriptiontype PRIMARY KEY (type),
    CONSTRAINT ck_subscriptiontype_min_age CHECK (min_age >= 0),
    CONSTRAINT ck_subscriptiontype_max_age CHECK (max_age >= 0),
    CONSTRAINT ck_subscriptiontype_min_age_max_age CHECK (min_age < max_age),
    CONSTRAINT ck_subscriptiontype_min_length CHECK (min_length > 0),
    CONSTRAINT ck_subscriptiontype_notice_period CHECK (notice_period > 0),
)
GO

ALTER TABLE EmployeeGroupClassType
    ADD CONSTRAINT fk_employee_empoyeegroupclasstype FOREIGN KEY (employee_id)
        REFERENCES Employee (employee_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE EmployeeGroupClassType
    ADD CONSTRAINT fk_employee_employee__groupcla FOREIGN KEY (class_name)
        REFERENCES GroupClassType (class_name)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE EmployeeRole
    ADD CONSTRAINT fk_role_employee__role FOREIGN KEY (role_name)
        REFERENCES Role (role_name)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE EmployeeRole
    ADD CONSTRAINT fk_employee_employee__role FOREIGN KEY (employee_id)
        REFERENCES Employee (employee_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE FitnessRoomSchedule
    ADD CONSTRAINT fk_fitnessr_fitness_r_employee FOREIGN KEY (employee_id)
        REFERENCES Employee (employee_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE FitnessRoomSchedule
    ADD CONSTRAINT fk_fitnessr_fitness_r_room FOREIGN KEY (room_id)
        REFERENCES Room (room_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE GroupClass
    ADD CONSTRAINT fk_groupclass_employee FOREIGN KEY (employee_id)
        REFERENCES Employee (employee_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE GroupClass
    ADD CONSTRAINT fk_groupcla_group_cla_groupcla FOREIGN KEY (class_name)
        REFERENCES GroupClassType (class_name)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE GroupClass
    ADD CONSTRAINT fk_groupcla_group_cla_room FOREIGN KEY (room_id)
        REFERENCES Room (room_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE GroupClassTypeSubscriptionType
    ADD CONSTRAINT fk_group_cl_group_cla_groupcla FOREIGN KEY (class_name)
        REFERENCES GroupClassType (class_name)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE GroupClassTypeSubscriptionType
    ADD CONSTRAINT fk_group_cl_group_cla_subscrip FOREIGN KEY (type)
        REFERENCES SubscriptionType (type)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE Machine
    ADD CONSTRAINT fk_machine_machine_m_machinet FOREIGN KEY (type_name)
        REFERENCES MachineType (type_name)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE Machine
    ADD CONSTRAINT fk_machine_machine_r_room FOREIGN KEY (room_id)
        REFERENCES Room (room_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE MachineReservation
    ADD CONSTRAINT fk_machiner_machine_i_machine FOREIGN KEY (machine_id)
        REFERENCES Machine (machine_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE MachineReservation
    ADD CONSTRAINT fk_machiner_member_in_member FOREIGN KEY (member_id)
        REFERENCES Member (member_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE MemberGroupClass
    ADD CONSTRAINT fk_member_g_member_gr_member FOREIGN KEY (member_id)
        REFERENCES Member (member_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE MemberGroupClass
    ADD CONSTRAINT fk_member_g_member_gr_groupcla FOREIGN KEY (class_name, room_id, start_timestamp)
        REFERENCES GroupClass (class_name, room_id, start_timestamp)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE RoomReservation
    ADD CONSTRAINT fk_roomrese_member_sq_member FOREIGN KEY (member_id)
        REFERENCES Member (member_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE RoomReservation
    ADD CONSTRAINT fk_roomrese_squash_ro_room FOREIGN KEY (room_id)
        REFERENCES Room (room_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE Subscription
    ADD CONSTRAINT fk_subscrip_member_in_member FOREIGN KEY (member_id)
        REFERENCES Member (member_id)
        ON UPDATE CASCADE ON DELETE CASCADE
GO

ALTER TABLE Subscription
    ADD CONSTRAINT fk_subscrip_subscript_subscrip FOREIGN KEY (type)
        REFERENCES SubscriptionType (type)
        ON UPDATE CASCADE ON DELETE CASCADE
GO