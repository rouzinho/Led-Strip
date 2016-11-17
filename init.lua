-- virer read_wifi et try_connecting
--mettre notre portion de code du serveur dans le fichier server.lua

function run_setup()
    wifi.setmode(wifi.SOFTAP)
    cfg={}
    cfg.ssid="Petites Lumieres"
    wifi.ap.config(cfg)
    ws2801.init(2,0)
    ws2801.write(string.char(0, 0, 0):rep(25))
    dofile ("dns-liar.lua")
    dofile ("server.lua")
end

run_setup()

