import { useState } from "react";
import "./App.css";

function App() {
  const [display, setDisplay] = useState(false);

  return (
    <>
      <div>
        <button name="change" onClick={() => setDisplay((current) => !current)}>
          切り替え
        </button>
      </div>
      <div className="result">
        {display && <span>表示</span>}
        {!display && <span>非表示</span>}
      </div>
    </>
  );
}

export default App;
