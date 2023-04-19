use project;
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(255) NOT NULL,
    user_address VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL UNIQUE,
    user_mobile VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE login (
    login_id INT,
    login_role_id INT NOT NULL UNIQUE,
    login_username VARCHAR(255) NOT NULL UNIQUE,
    login_password VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (login_id),
    FOREIGN KEY (login_id) REFERENCES user(user_id)
);
CREATE TABLE role (
    role_id INT NOT NULL PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL,
    role_desc VARCHAR(255) NOT NULL
);
CREATE TABLE permissions (
    per_id INT NOT NULL PRIMARY KEY,
    per_role_id INT NOT NULL UNIQUE,
    per_module VARCHAR(255) NOT NULL,
    per_name VARCHAR(255) NOT NULL
);

CREATE TABLE maintenance_bill (
    mb_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    mb_num INT NOT NULL UNIQUE,
    mb_type VARCHAR(255) NOT NULL,
    mb_date DATE NOT NULL,
    mb_desc VARCHAR(255) NOT NULL
);
CREATE TABLE block (
    block_id INT NOT NULL PRIMARY KEY,
    block_num INT NOT NULL,
    block_desc VARCHAR(255) NOT NULL
);
CREATE TABLE apartment (
    app_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    app_desc VARCHAR(255) NOT NULL,
    app_add VARCHAR(255) NOT NULL,
    app_type VARCHAR(255) NOT NULL,
    app_name VARCHAR(255) NOT NULL
);
CREATE TABLE apartment_owner (
    ao_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ao_name VARCHAR(255) NOT NULL,
    ao_address VARCHAR(255) NOT NULL,
    ao_mobile VARCHAR(255) NOT NULL UNIQUE,
    ao_email VARCHAR(255) NOT NULL UNIQUE,
    ao_password VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE user_role (
    ur_id INT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id)
);


CREATE TABLE user_permissions (
  user_id INT NOT NULL,
  per_id INT NOT NULL,
  PRIMARY KEY (user_id, per_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id),
  FOREIGN KEY (per_id) REFERENCES permissions(per_id)
);


CREATE TABLE appartment_owner_user (
  ao_id INT NOT NULL,
  user_id INT NOT NULL,
  PRIMARY KEY (ao_id, user_id),
  FOREIGN KEY (ao_id) REFERENCES apartment_owner(ao_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
);


ALTER TABLE apartment
ADD COLUMN user_id INT NOT NULL,
ADD CONSTRAINT fk_user
  FOREIGN KEY (user_id)
  REFERENCES user(user_id);



ALTER TABLE apartment
ADD COLUMN block_id INT NOT NULL,
ADD CONSTRAINT fk_block
  FOREIGN KEY (block_id)
  REFERENCES block(block_id);


ALTER TABLE maintenance_bill
ADD COLUMN user_id INT NOT NULL,
ADD CONSTRAINT fk_user_mb
  FOREIGN KEY (user_id)
  REFERENCES user(user_id);


ALTER TABLE login
ADD CONSTRAINT fk_login_role
FOREIGN KEY (login_role_id)
REFERENCES role(role_id);


ALTER TABLE login
ADD CONSTRAINT fk_login_permissions
FOREIGN KEY (login_role_id)
REFERENCES permissions(per_role_id);


CREATE TABLE tenant (
    tenant_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(255),
    move_in_date DATE NOT NULL,
    );

CREATE TABLE lease (
  lease_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  unit_id INT NOT NULL,
  tenant_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  rent DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_unit_id FOREIGN KEY (unit_id) REFERENCES apartment (app_id),
  CONSTRAINT fk_tenant_id FOREIGN KEY (tenant_id) REFERENCES tenant (tenant_id)
);


alter table apartment add column occupancy varchar(25) not null;

DELIMITER $$

CREATE TRIGGER insert_occupancy
AFTER INSERT ON lease
FOR EACH ROW
BEGIN
    UPDATE apartment SET occupancy = occupancy + 1 WHERE unit_id = NEW.unit_id;
END$$

CREATE TRIGGER update_occupancy
AFTER UPDATE ON lease
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        IF NEW.status = 'active' THEN
            UPDATE apartment SET occupancy = occupancy + 1 WHERE unit_id = NEW.unit_id;
        ELSE
            UPDATE apartment SET occupancy = occupancy - 1 WHERE unit_id = NEW.unit_id;
        END IF;
    END IF;
END$$

CREATE TRIGGER delete_occupancy
AFTER DELETE ON lease
FOR EACH ROW
BEGIN
    UPDATE apartment SET occupancy = occupancy - 1 WHERE unit_id = OLD.unit_id;
END$$

DELIMITER ;

ALTER TABLE Apartment ADD app_rate DECIMAL(10,2);
desc apartment;
ALTER TABLE Apartment MODIFY app_rate DECIMAL(10,2) NOT NULL;

alter table maintenance_bill add mb_status varchar(255);
alter table maintenance_bill add mb_total_amt int;
CREATE TABLE maintenance_apartment (
    ma_id INT NOT NULL PRIMARY KEY,
    mb_id INT NOT NULL,
    app_id INT NOT NULL,
    FOREIGN KEY (mb_id) REFERENCES maintenance_bill(mb_id),
    FOREIGN KEY (app_id) REFERENCES apartment(app_id)
);

-- alter table maintenance_bill MODIFY mb_id AUTO_INCREMENT;

DELIMITER //
CREATE PROCEDURE calculate_maintenance_bill(IN p_date DATE, IN p_app_id INT, OUT p_total_bill DECIMAL(10,2))
BEGIN
  DECLARE v_app_rate DECIMAL(10,2);
  DECLARE v_mb_rate INT;

  SELECT app_rate INTO v_app_rate FROM apartment WHERE app_id = p_app_id;

  SELECT mb_rate INTO v_mb_rate FROM maintenance_bill WHERE mb_type = 'monthly';
  
  SET p_total_bill = v_app_rate + (v_mb_rate * (sysdate() - p_date));

  insert into maintenance_bill values()
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE add_apartment(
    IN app_desc VARCHAR(255),
    IN app_address VARCHAR(255),
    IN app_type VARCHAR(255),
    IN app_name VARCHAR(255),
    IN user_id INT,
    IN occupancy VARCHAR(25),
    IN rate DECIMAL(10,2)
)
BEGIN
    INSERT INTO apartment (app_desc, app_add, app_type, app_name, user_id,occupancy, app_rate) 
    VALUES (app_desc, app_address, app_type, app_name, user_id , occupancy, rate);
    SELECT LAST_INSERT_ID();
END //
DELIMITER ;

CALL add_apartment('New apartment', '123 Main St', '2BR', 'Apartment A', 1, 'Occupied', 1000.00);


DELIMITER //

CREATE PROCEDURE add_tenant(
    IN p_first_name VARCHAR(255),
    IN p_last_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(255),
    IN p_move_in_date DATE
)
BEGIN
    INSERT INTO tenant (first_name, last_name, email, phone, move_in_date) VALUES (p_first_name, p_last_name, p_email, p_phone, p_move_in_date);
    
    SELECT CONCAT(p_first_name, ' ', p_last_name, ' added to the tenant table.') AS message;
END //

DELIMITER ;


CALL add_tenant('John', 'Doe', 'johndoe@example.com', '555-1234', '2022-01-01');
