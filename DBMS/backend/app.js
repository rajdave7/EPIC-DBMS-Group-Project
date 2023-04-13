import express from 'express';
import {getUsers, getUser, createUser, getLogins} from './database.js';
import cors from 'cors';

const app = express()

const corsOption = {
    origin:'*',
    credentials:true,
    optionSuccessStatus:200,
}

app.use(express.json())

app.use(cors(corsOption))

app.get("/users", async(req, res)=> {
    const users = await getUsers();
    res.send(users);
})

app.get("/login", async(req, res)=> {
    const users = await getLogins();
    res.send(users);
})

app.get("/users/:id", async(req, res) => {
    const user = await getUser(req.params.id);
    res.send(user);
})

app.post("/users", async(req, res) => {
    const { user_name, user_address, user_email, user_mobile} = req.body;
    const user = await createUser(user_name, user_address, user_email, user_mobile);
    res.status(201).send(user);
})

app.listen(8080, () => {
    console.log('Server is running on port 8080');
})