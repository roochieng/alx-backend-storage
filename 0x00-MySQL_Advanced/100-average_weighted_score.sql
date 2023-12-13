-- Create the stored procedure
DELIMITER //
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id_param INT)
BEGIN
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

    -- Ensure there are scores for the user before calculating the average
    IF total_weight IS NOT NULL AND total_weight > 0 THEN
        DECLARE average_weighted_score DECIMAL(10, 2);
        SET average_weighted_score = total_weighted_score / total_weight;

        INSERT INTO user_average_weighted_scores (user_id, average_weighted_score)
        VALUES (user_id_param, average_weighted_score)
        ON DUPLICATE KEY UPDATE average_weighted_score = average_weighted_score;
    ELSE
        SELECT 'No scores available for the user' AS result;
    END IF;
END //
DELIMITER ;
