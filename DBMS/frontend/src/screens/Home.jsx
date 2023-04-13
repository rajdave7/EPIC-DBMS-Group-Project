import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { getUser } from "../connections/covalent";

const Home = () => {
    const {id} = useParams();
    const [user, setUser] = useState("");

    useEffect(() => {
        (async () => {
            const _user = await getUser(id);
            setUser(_user);
        })();
      }, []);

    return(
        <div>
            User : {user.user_name}
            Role : {}
        </div>
    )
}

export default Home;