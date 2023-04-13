import { BrowserRouter as Router, Route, Routes} from "react-router-dom";
import './App.css';
import LoginPage from './screens/Login';
import SignUpPage from "./screens/Signup";
import Home from "./screens/Home";

function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path='/' element={<LoginPage />} />
          <Route path='/signup' element={<SignUpPage />} />
          <Route path='/home/:id' element={<Home />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
