local app = require "milua"
local http = require("socket.http")
local ltn12 = require("ltn12")
local cjson = require("cjson")

local config = dofile("config.lua")
local openaiApiKey = config.openaiApiKey

local apiUrl = "https://api.openai.com/v1/chat/completions"

app.add_handler(
    "OPTIONS",
    "/openai",
    function(captures, query, headers, body)

        return "", {
            ["Access-Control-Allow-Origin"] = "*", 
            ["Access-Control-Allow-Methods"] = "POST, OPTIONS", 
            ["Access-Control-Allow-Headers"] = "Content-Type, Authorization" 
        }
    end
)

app.add_handler(
    "POST",
    "/openai",
    function(captures, query, headers, body)
        -- Parse JSON from the request body
        local requestData = {
            model = "gpt-3.5-turbo",
            messages = {
                {
                role = "system",
                content = "Usted es un experto en Lua Script diseñado para asistir al grupo #1 del Curso de Paradigmas de Programación. Te llamas Charley",
              },{role = "user", content = cjson.decode(body).content}
            },
            temperature = 0.7
        }

        print("Request:", requestData)

        -- Convert Lua table to JSON
        local requestBody = cjson.encode(requestData)

        print("RequestBB:", requestBody)

        local requestHeaders = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. openaiApiKey
        }

        local response = {}
        local _, statusCode, _, _ = http.request{
            url = apiUrl,
            method = "POST",
            headers = requestHeaders,
            source = ltn12.source.string(requestBody),
            sink = ltn12.sink.table(response)
        }

        if statusCode == 200 then
            print("Made it here!")
            local responseBody = table.concat(response)
            print("responseBody", responseBody)
            return responseBody, {
                ["Access-Control-Allow-Origin"] = "*", 
                ["Access-Control-Allow-Methods"] = "POST, OPTIONS", 
                ["Access-Control-Allow-Headers"] = "Content-Type, Authorization" 
            } 
        else
            return "Error", {
                ["Access-Control-Allow-Origin"] = "*", 
                ["Access-Control-Allow-Methods"] = "POST, OPTIONS", 
                ["Access-Control-Allow-Headers"] = "Content-Type, Authorization" 
            }
        end
    end
)

app.start()
