-- Create the stored procedure
DELIMITER //
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id_param INT;
    DECLARE cur CURSOR FOR SELECT DISTINCT user_id FROM scores;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO user_id_param;
        IF done THEN
            LEAVE read_loop;
        END IF;

        DECLARE total_weighted_score DECIMAL(10, 2);
        DECLARE total_weight DECIMAL(10, 2);

        SELECT 
            SUM(score * weight) AS total_weighted_score,
            SUM(weight) AS total_weight
        INTO 
            total_weighted_score,
            total_weight
        FROM 
            scores
        WHERE 
            user_id = user_id_param;

        IF total_weight IS NOT NULL AND total_weight > 0 THEN
            DECLARE average_weighted_score DECIMAL(10, 2);
            SET average_weighted_score = total_weighted_score / total_weight;

            INSERT INTO user_average_weighted_scores (user_id, average_weighted_score)
            VALUES (user_id_param, average_weighted_score)
            ON DUPLICATE KEY UPDATE average_weighted_score = average_weighted_score;
        END IF;
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;
