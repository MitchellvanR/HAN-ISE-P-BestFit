IF (SELECT COUNT(*) FROM SubscriptionType) = 0
BEGIN
    -- Subscription types
    INSERT INTO SubscriptionType (type, notice_period, min_length, min_age, max_age)
    VALUES  ('Minor monthly', 4, 1, 12, 17),
            ('Adult monthly', 4, 1, 18, 64),
            ('Senior monthly', 4, 1, 65, NULL),
            ('Yoga monthly', 4, 1, NULL, NULL),
            ('Spin monthly', 4, 1, NULL, NULL),
            ('Zumba monthly', 4, 1, NULL, NULL),
            ('Pilates monthly', 4, 1, NULL, NULL),
            ('Dance monthly', 4, 1, NULL, NULL),
            ('Squash monthly', 4, 1, NULL, NULL),
            ('All monthly', 4, 1, NULL, NULL);

    INSERT INTO SubscriptionType (type, notice_period, min_length, min_age, max_age)
    VALUES  ('Minor annual', 4, 12, 12, 17),
            ('Adult annual', 4, 12, 18, 64),
            ('Senior annual', 4, 12, 65, NULL),
            ('Yoga annual', 4, 12, NULL, NULL),
            ('Spin annual', 4, 12, NULL, NULL),
            ('Zumba annual', 4, 12, NULL, NULL),
            ('Pilates annual', 4, 12, NULL, NULL),
            ('Dance annual', 4, 12, NULL, NULL),
            ('Squash annual', 4, 12, NULL, NULL),
            ('All annual', 4, 1, NULL, NULL);
END

IF (SELECT COUNT(*) FROM GroupClassType) = 0
BEGIN
    -- Group class types
    INSERT INTO GroupClassType (class_name, max_participants)
    VALUES  ('Yoga', 20),
            ('Spin', 15),
            ('Zumba', 25),
            ('Pilates', 10),
            ('Dance', 30);
END

IF (SELECT COUNT(*) FROM Role) = 0
BEGIN
    -- Roles
    INSERT INTO Role (role_name)
    VALUES  ('Employee'),
            ('Roster maker'),
            ('Manager');
END

IF (SELECT COUNT(*) FROM MachineType) = 0
BEGIN
    -- Machine types
    INSERT INTO MachineType (type_name)
    VALUES  ('Treadmill'),
            ('Exercise bike'),
            ('Stair climber'),
            ('Smith machine'),
            ('Cable fly'),
            ('Pec deck'),
            ('Leg press'),
            ('Hamstring curl'),
            ('Dumbbell rack'),
            ('Chest press'),
            ('Lat pulldown'),
            ('Shoulder press'),
            ('Leg extension'),
            ('Squat rack'),
            ('Seated row'),
            ('Calf raise'),
            ('Abdominal crunch'),
            ('Assisted pull-up'),
            ('Hip abductor'),
            ('Hip adductor'),
            ('Seated bicep curl'),
            ('Preacher curl');
END

IF (SELECT COUNT(*) FROM Room) = 0
BEGIN
    -- Rooms
    INSERT INTO Room (room_id, functionality, max_people)
    VALUES (1, 'Fitness', 30),
           (2, 'GroupClass', 20),
           (3, 'GroupClass', 20),
           (4, 'GroupClass', 20),
           (5, 'Squash', 2),
           (6, 'Squash', 2),
           (7, 'Squash', 2),
           (8, 'Squash', 2);

END

IF (SELECT COUNT(*) FROM Machine) = 0
BEGIN
    -- Machines
    INSERT INTO Machine (machine_id, room_id, type_name, machine_status)
    VALUES  (1, 1, 'Treadmill', 'Active'),
            (2, 1, 'Treadmill', 'Active'),
            (3, 1, 'Treadmill', 'Active'),
            (4, 1, 'Treadmill', 'Active'),
            (5, 1, 'Treadmill', 'Active'),
            (6, 1, 'Exercise bike', 'Active'),
            (7, 1, 'Stair climber', 'Active'),
            (8, 1, 'Stair climber', 'Active'),
            (9, 1, 'Smith machine', 'Active'),
            (10, 1, 'Cable fly', 'Active'),
            (11, 1, 'Pec deck', 'Active'),
            (12, 1, 'Pec deck', 'Active'),
            (13, 1, 'Leg press', 'Active'),
            (14, 1, 'Dumbbell rack', 'Active'),
            (15, 1, 'Chest press', 'Active'),
            (16, 1, 'Chest press', 'Active'),
            (17, 1, 'Lat pulldown', 'Active'),
            (18, 1, 'Lat pulldown', 'Active'),
            (19, 1, 'Shoulder press', 'Active'),
            (20, 1, 'Leg extension', 'Active'),
            (21, 1, 'Leg extension', 'Active'),
            (22, 1, 'Squat rack', 'Active'),
            (23, 1, 'Squat rack', 'Active'),
            (24, 1, 'Hamstring curl', 'Active'),
            (25, 1, 'Seated row', 'Active'),
            (26, 1, 'Calf raise', 'Active'),
            (27, 1, 'Abdominal crunch', 'Active'),
            (28, 1, 'Assisted pull-up', 'Active'),
            (29, 1, 'Hip abductor', 'Active'),
            (30, 1, 'Hip adductor', 'Active'),
            (31, 1, 'Seated bicep curl', 'Active'),
            (32, 1, 'Preacher curl', 'Active');
END
