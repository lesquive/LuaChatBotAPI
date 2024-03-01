import React, { useState, useEffect, useRef } from "react";
import "./Chat.css";
import axios from "axios";

const Chat = () => {
  const [input, setInput] = useState("");
  const [messages, setMessages] = useState([]);
  const messagesEndRef = useRef(null);

  useEffect(() => {
    // Desplazar hacia abajo cada vez que cambian los mensajes
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  const handleInputChange = (event) => {
    setInput(event.target.value);
  };

  const handleSendMessage = async () => {
    if (input.trim() === "") return;

    // Make API call to the backend with the user's message
    try {
      const response = await axios.post("http://localhost:8800/openai", {
        content: input,
      });
      const botReply = response.data.choices[0].message.content;
      console.log(botReply);

      // Update the messages state with the user message first
      setMessages((prevMessages) => [
        ...prevMessages,
        { text: input, user: true },
      ]);

      // Use setTimeout to simulate a delay before showing the bot message
      setTimeout(() => {
        setMessages((prevMessages) => [
          ...prevMessages,
          { text: botReply, user: false },
        ]);
      }, 1000);

      // Clear the input field
      setInput("");
    } catch (error) {
      console.error("Error sending message:", error);
    }
  };

  const handleKeyPress = (event) => {
    if (event.key === "Enter") {
      handleSendMessage();
    }
  };

  return (
    <div className="chat-container">
      <div className="message-container">
        {messages.map((msg, index) => (
          <div
            key={index}
            className={msg.user ? "user-message" : "bot-message"}
          >
            {msg.text}
          </div>
        ))}
        <div ref={messagesEndRef}></div>
      </div>
      <div className="input-container">
        <input
          type="text"
          value={input}
          onChange={handleInputChange}
          onKeyPress={handleKeyPress}
          placeholder="Pregunte cualquier cosa sobre Lua..."
        />
        <button onClick={handleSendMessage}>Enviar</button>
      </div>
    </div>
  );
};

export default Chat;
