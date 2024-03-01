local app = require "milua"
local http = require("socket.http")
local ltn12 = require("ltn12")
local cjson = require("cjson")

-- Your OpenAI API key
local config = dofile("config.lua")
local openaiApiKey = config.openaiApiKey

-- API endpoint
local apiUrl = "https://api.openai.com/v1/chat/completions"

-- Define a handler for the OPTIONS method
app.add_handler(
    "OPTIONS",
    "/openai",
    function(captures, query, headers, body)

        -- Respond to preflight requests
        return "", {
            ["Access-Control-Allow-Origin"] = "*", -- Allow requests from any origin
            ["Access-Control-Allow-Methods"] = "POST, OPTIONS", -- Allow POST and OPTIONS methods
            ["Access-Control-Allow-Headers"] = "Content-Type, Authorization" -- Allow specified headers
        }
    end
)

-- Define a handler for the "/openai" endpoint
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

        -- Request headers
        local requestHeaders = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. openaiApiKey
        }

        -- Perform HTTP request
        local response = {}
        local _, statusCode, _, _ = http.request{
            url = apiUrl,
            method = "POST",
            headers = requestHeaders,
            source = ltn12.source.string(requestBody),
            sink = ltn12.sink.table(response)
        }

        -- Check the response
        if statusCode == 200 then
            print("Made it here!")
            local responseBody = table.concat(response)
            print("responseBody", responseBody)
            return responseBody, {
                ["Access-Control-Allow-Origin"] = "*", -- Allow requests from any origin
                ["Access-Control-Allow-Methods"] = "POST, OPTIONS", -- Allow POST and OPTIONS methods
                ["Access-Control-Allow-Headers"] = "Content-Type, Authorization" -- Allow specified headers
            } 
        else
            return "Error", {
                ["Access-Control-Allow-Origin"] = "*", -- Allow requests from any origin
                ["Access-Control-Allow-Methods"] = "POST, OPTIONS", -- Allow POST and OPTIONS methods
                ["Access-Control-Allow-Headers"] = "Content-Type, Authorization" -- Allow specified headers
            }
        end
    end
)

-- Start the application
app.start()
