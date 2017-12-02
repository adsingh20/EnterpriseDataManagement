-- Function setup
insert into neuroid.function (functionname) values
('Projects'), -- ID = 1
('Clients'), -- ID = 2
('Industry'), -- ID = 3
('Topic Tags'), -- ID = 4
('Questions'); -- ID = 5

insert into neuroid.roles (rolename) values
('Admin Role'), -- ID = 1
('Technical Role'), -- ID = 2
('Sales Role'), -- ID = 3
('Analyst Role'); -- ID = 4

insert into neuroid.users (loginid,password,firstname,lastname, roleid) values
('admin', 'admin', 'Admin', 'Role',1),  -- ID = 1
('technical', 'technical', 'Technical', 'Role',2), -- ID = 2
('sales', 'sales', 'Sales', 'Role',3), -- ID = 3
('analyst', 'analyst', 'Analyst', 'Role',4); -- ID = 4

-- Admin role gets full access
insert into neuroid.role_function values
(1,1,1),
(1,2,1),
(1,3,1),
(1,4,1),
(1,5,1),
-- Sales Role gets read only access
(3,1,0),
(3,2,0),
(3,3,0),
(3,4,0),
(3,5,0),
-- Analyst Role gets full access to Questions and Topic Tags screens
(4,5,1),
(4,4,1);


/*
Function to be used:

? = neuroid.get_privileges(?,?),

Order of parameters:
1. Output parameter, expect the following values:
    0 -> No Access
    1 -> Read Only access
    2 -> Read and Write access
2. Login ID (Example: ‘admin’, ‘sales’ etc.)
3. Screen ID

Screen ID:

For Projects pass 1
For Clients pass 2
For Industry pass 3
For Topic Tags pass 4
For Questions pass 5

List of Logins and setup done:

1.  Admin Role:
        Login ID: admin
        Password: admin
        Privileges: Full access to everything.
2. Technical Role:
        Login ID: technical
        Password: technical
        Privileges: No Access to everything.
3. Sales Role:
        Login ID: sales
        Password: sales
        Privileges: Read only access to everything.
4. Analyst Role:
        Login ID: analyst
        Password: analyst
        Privileges: Full access to Question and Topic Tags screens and No Access to rest.
*/
