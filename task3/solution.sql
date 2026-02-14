-- 1. Add a new column for session duration
ALTER TABLE server_logs ADD COLUMN Session_Dur REAL;
UPDATE server_logs
SET Session_Dur =
    (julianday(Session_End) - julianday(Session_Start)) * 24 * 60;
CREATE VIEW v_users_activity AS
SELECT
    users.User_ID,
    users.First_Name,
    users.Last_Name,
    COUNT(server_logs.Log_ID) AS Num_Sessions,
    COALESCE(SUM(server_logs.Session_Dur), 0) AS Total_Session_Time
FROM users
LEFT JOIN server_logs
ON users.User_ID = server_logs.User_ID
GROUP BY
    users.User_ID,
    users.First_Name,
    users.Last_Name
ORDER BY Total_Session_Time DESC;