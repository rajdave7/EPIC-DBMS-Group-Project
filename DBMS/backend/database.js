import mysql from "mysql2";

const aprs = mysql
  .createPool({
    host: "127.0.0.1",
    user: "root",
    password: "root",
    database: "dbms_proj",
  })
  .promise();

export async function getUsers() {
  const [result] = await aprs.query("SELECT * FROM user");
  return result;
}

export async function getLogins() {
  const [result] = await aprs.query("SELECT * FROM login");
  return result;
}

export async function getUser(id) {
  const [result] = await aprs.query(
    `
        SELECT *
        FROM user
        WHERE user_id = ?
    `,
    [id]
  );
  return result[0];
}

export async function createUser(name, address, email, mobile) {
  const result = await aprs.query(
    `
        INSERT INTO user (user_name, user_address, user_email, user_mobile)
        VALUES (?, ?, ?, ?)
    `,
    [name, address, email, mobile]
  );
  return result;
}

export async function getRole(ur_id, user_id, role_id) {
  const [result] = await aprs.query(
    `
          insert into user_role values(?,?,?)
      `,
    [ur_id, user_id, role_id]
  );
  return result[0];
}
