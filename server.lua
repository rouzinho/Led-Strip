srv=net.createServer(net.TCP) 
srv:listen(80, function(conn)

  conn:on("receive", function(conn, payload)
    -- print(payload)
    local isOpen = false

    conn:on("sent", function(conn)
      if not isOpen then
        print('open')
        isOpen = true
        file.open(fileName, 'r')
      end
      local data = file.read(1024) -- 1024 max
      if data then
        print('send ' .. #data)
        conn:send(data)
      else
        print('close')
        file.close()
        conn:close()
        conn = nil
      end
    end)

    if string.sub(payload, 1, 6) == 'GET / ' then
      fileName = 'index.html'
      conn:send("HTTP/1.1 200 OK\r\n")
      conn:send("Content-type: text/html\r\n")
      conn:send("Connection: close\r\n\r\n")
    elseif string.sub(payload, 1, 9) == 'GET /off ' then
      conn:close()
      conn = nil
      ws2801.write(string.char(0, 0, 0):rep(25))
    elseif string.sub(payload, 1, 6) == 'GET /~' then
      conn:close()
      conn = nil
      -- print(string.sub(payload, 6, 12))
      local r = tonumber(string.sub(payload, 7, 8), 16)
      local g = tonumber(string.sub(payload, 9, 10), 16)
      local b = tonumber(string.sub(payload, 11, 12), 16)
      ws2801.write(string.char(g, r, b):rep(25))
    else
      conn:close()
    end

  end)

end)
print("HTTP Server: Started")



