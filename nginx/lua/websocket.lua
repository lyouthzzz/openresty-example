local server = require('resty.websocket.server');

local wb, err = server:new{timeout = 5000, max_payload_len = 65535};
if not wb then
    ngx.log(ngx.ERR, 'failed to new websocket: ', err)
end

wb:set_timeout(5 * 1000)

local writeLoop = function ()
    while true do
        local bytes, err = wb:send_text('hello   fsdfas ')
        if not bytes then
            ngx.log(ngx.ERR, 'failed to send text ', err)
        end
        ngx.sleep(1)
    end
end

local readLoop = function ()
    while true do
        local data, typ, err = wb:recv_frame()
        if not data then
            ngx.log(ngx.ERR, 'failed to receive a frame ', err)
            return ngx.exit(500);
        end
    end
end

ngx.thread.spawn(writeLoop)

ngx.thread.spawn(readLoop)