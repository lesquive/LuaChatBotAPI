import React from "react";
import Chat from "./Chat";
import "./App.css";

function App() {
  return (
    <div className="app-container">
      <div className="app-content">
        <h1>Charley - Bot Experto en Lua 🤖</h1>
        <p>
          Una aplicación interactiva de chat con un bot experto en Lua,
          desarrollada para el curso de Paradigmas de Programación 2024, Primer
          Cuatrimestre, Prof. M. Romero N. - Universidad Fidelitas 🚀
        </p>
        <Chat />
      </div>
    </div>
  );
}

export default App;
