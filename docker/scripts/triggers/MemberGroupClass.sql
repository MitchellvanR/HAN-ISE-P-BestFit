/**
* TRG-02
* Trigger for the MemberGroupClass table, so the sign ins are valid.
*
* Rollbacks when
*   - The member is already signed up for the group class.
*   - The member is already signed up for another group class, a room- or machine reservation at the time of the group class.
*/
DROP TRIGGER IF EXISTS trg_MemberGroupClass_insertUpdate
GO
CREATE TRIGGER trg_MemberGroupClass_insertUpdate
    ON MemberGroupClass
    AFTER INSERT, UPDATE
    AS
BEGIN
    IF @@ROWCOUNT = 0
        RETURN
    SET NOCOUNT ON
    BEGIN TRY

        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE NOT EXISTS (SELECT *
                                     FROM GroupClassTypeSubscriptionType GCTST
                                              JOIN Subscription S ON GCTST.type = S.type
                                     WHERE I.member_id = S.member_id
                                       AND GCTST.class_name = I.class_name
                                       AND DATEDIFF(DAY, S.end_date, I.start_timestamp) < 0))
            THROW 50001, 'The member has no active subscriptions that allows the member to follow the group class.', 1

        IF 'bad' IN (SELECT CASE WHEN COUNT(*) = 1 THEN 'good' ELSE 'bad' END
                     FROM MemberGroupClass MGC
                              JOIN Inserted I ON MGC.member_id = I.member_id
                     WHERE MGC.class_name = I.class_name
                       AND MGC.start_timestamp = I.start_timestamp
                       AND MGC.room_id = I.room_id
                     GROUP BY MGC.member_id, MGC.class_name, MGC.start_timestamp, MGC.room_id)
            THROW 50001, 'The member has already signed up for this group class.', 1

        IF EXISTS (SELECT *
                   FROM GroupClass GC
                            JOIN GroupClassType GCT ON GC.class_name = GCT.class_name
                            JOIN Inserted I ON I.class_name = GC.class_name
                       AND I.room_id = GC.room_id AND I.start_timestamp = GC.start_timestamp
                   WHERE max_participants < (SELECT COUNT(*)
                                             FROM MemberGroupClass MGC
                                             WHERE MGC.class_name = GC.class_name
                                               AND MGC.room_id = GC.room_id
                                               AND MGC.start_timestamp = GC.start_timestamp))
            THROW 50001, 'The group class is full.', 1


        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE EXISTS(SELECT MGC.member_id, MGC.class_name, MGC.room_id, MGC.start_timestamp
                                FROM MemberGroupClass MGC
                                         JOIN GroupClass GC
                                              ON MGC.class_name = GC.class_name AND MGC.room_id = GC.room_id AND
                                                 MGC.start_timestamp = GC.start_timestamp
                                WHERE MGC.member_id = I.member_id
                                  AND I.start_timestamp BETWEEN MGC.start_timestamp AND GC.end_timestamp
                                EXCEPT
                                SELECT member_id, class_name, room_id, start_timestamp
                                FROM Inserted))
            THROW 50001, 'The member is already signed up for another group class at this time.', 1

        IF EXISTS (SELECT *
                   FROM Inserted I
                            JOIN GroupClass GC ON I.class_name = GC.class_name AND I.room_id = GC.room_id AND
                                                  I.start_timestamp = GC.start_timestamp
                   WHERE EXISTS(SELECT MGC.member_id, MGC.class_name, MGC.room_id, MGC.start_timestamp
                                FROM MemberGroupClass MGC
                                         JOIN GroupClass GC2
                                              ON MGC.class_name = GC2.class_name AND MGC.room_id = GC2.room_id AND
                                                 MGC.start_timestamp = GC2.start_timestamp
                                WHERE MGC.member_id = I.member_id
                                  AND I.start_timestamp BETWEEN MGC.start_timestamp AND GC2.end_timestamp
                                EXCEPT
                                SELECT member_id, class_name, room_id, start_timestamp
                                FROM Inserted))
            THROW 50001, 'The member is already signed up for another group class at this time.', 1

        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE EXISTS
                             (SELECT *
                              FROM MachineReservation MR
                              WHERE MR.member_id = I.member_id
                                AND I.start_timestamp BETWEEN MR.start_timestamp AND MR.end_timestamp))
            THROW 50001, 'The member already has a machine reservation at the time of the group class.', 1


        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE EXISTS
                             (SELECT *
                              FROM GroupClass GC
                              WHERE I.class_name = GC.class_name
                                AND I.room_id = GC.room_id
                                AND I.start_timestamp = GC.start_timestamp
                                AND EXISTS
                                  (SELECT *
                                   FROM MachineReservation MR
                                   WHERE MR.member_id = I.member_id
                                     AND GC.end_timestamp BETWEEN MR.start_timestamp AND MR.end_timestamp)))
            THROW 50001, 'The member already has a machine reservation at the time of the group class.', 1


        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE EXISTS
                             (SELECT *
                              FROM RoomReservation RR
                              WHERE RR.member_id = I.member_id
                                AND I.start_timestamp BETWEEN RR.start_timestamp AND RR.end_timestamp))
            THROW 50001, 'The member already has a room reservation at the time of the group class.', 1

        IF EXISTS (SELECT *
                   FROM Inserted I
                   WHERE EXISTS
                             (SELECT *
                              FROM GroupClass GC
                              WHERE I.class_name = GC.class_name
                                AND I.room_id = GC.room_id
                                AND I.start_timestamp = GC.start_timestamp
                                AND EXISTS
                                  (SELECT *
                                   FROM RoomReservation RR
                                   WHERE RR.member_id = I.member_id
                                     AND GC.end_timestamp BETWEEN RR.start_timestamp AND RR.end_timestamp)))
            THROW 50001, 'The member already has a room reservation at the time of the group class.', 1
    END TRY
    BEGIN CATCH
        ; THROW
    END CATCH
END
GO
