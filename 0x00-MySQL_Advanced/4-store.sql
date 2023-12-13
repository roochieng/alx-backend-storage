-- Create trigger to update item quantity after inserting new order
DELIMITER $$
CREATE TRIGGER update_quantity
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Decrement quantity of corresponding item in items table
    UPDATE items
    SET quantity = quantity - NEW.number
    WHERE name = NEW.item_name;
END $$
DELIMITER ;
