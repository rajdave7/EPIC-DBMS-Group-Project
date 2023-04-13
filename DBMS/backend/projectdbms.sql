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
    mb_id INT NOT NULL PRIMARY KEY,
    mn_num INT NOT NULL UNIQUE,
    mb_type VARCHAR(255) NOT NULL,
    mb_date DATE NOT NULL,
    mb_desc VARCHAR(255) NOT NULL
);
drop table maintenance_bill;
CREATE TABLE maintenance_bill (
    mb_id INT NOT NULL PRIMARY KEY,
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
    app_id INT NOT NULL PRIMARY KEY,
    app_desc VARCHAR(255) NOT NULL,
    app_add VARCHAR(255) NOT NULL,
    app_type VARCHAR(255) NOT NULL,
    app_name VARCHAR(255) NOT NULL
);
CREATE TABLE apartment_owner (
    ao_id INT NOT NULL PRIMARY KEY,
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

