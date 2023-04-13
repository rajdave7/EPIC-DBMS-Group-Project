import axios from "axios";
const baseURL = "http://localhost:8081";

export const getUsers = async () => {
  const output = await axios.get(`${baseURL}/users`).catch((err) => {
    console.log(err);
  });
  return output.data;
};

export const getUser = async (id) => {
  const output = await axios.get(`${baseURL}/users/${id}`).catch((err) => {
    console.log(err);
  });
  return output.data;
};

export const createUser = async (user_name, email, address, mobile) => {
  const output = await axios
    .post(`${baseURL}/users`, {
      user_name: user_name,
      user_address: address,
      user_email: email,
      user_mobile: mobile,
    })
    .catch((err) => {
      console.log(err);
    });
  return output.data;
};
