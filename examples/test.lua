package.path = package.path .. ";/usr/local/freeswitch/scripts/?.lua"
local https = require("ssl.https")
--local http = require('requests')
json = require("JSON")
local ltn12 = require("ltn12")

if session:ready() then

    lang = "hi" -- English

    chn = "mono" --mono/stereo

    api = freeswitch.API()

    session:sleep(500)
    session:answer()

    uuid = session:getVariable("uuid")

    session:execute("set", "DEEPGRAM_API_KEY=")
    session:execute("export", "DEEPGRAM_API_KEY=")
    session:execute("set", "DEEPGRAM_SPEECH_MODEL=nova-2")
    session:execute("export", "DEEPGRAM_SPEECH_MODEL=nova-2")
    --session:execute("set", "DEEPGRAM_SPEECH_ENDPOINTING=500")
    --session:execute("export", "DEEPGRAM_SPEECH_ENDPOINTING=500")

    local channel_state = "Ring"
    local i = 0
    while i<300 and channel_state ~= "ACTIVE"  do
        i = i+1
        session:sleep(100)
        channel_state = api:executeString('eval uuid:' .. uuid ..' ${Channel-Call-State}')
        freeswitch.consoleLog("ERR", "channel-call-state from uuid " .. tostring(channel_state))
    end

    session:streamFile("ivr/ivr-welcome.wav")
    starttime_1=os.time()
    starttime_2=os.clock()
    starttime = (starttime_1*1000)+(starttime_2*1000)
    local new_connection = true
    while session:ready() do
        if new_connection == true then
            api:execute("uuid_deepgram_transcribe", uuid.." start "..lang.." interim "..chn)
            con = freeswitch.EventConsumer("CUSTOM","deepgram_transcribe::transcription")
            new_connection = false
        end
        session:sleep(100)
        for e in (function() return con:pop(1,10) end) do
            body_text = e:getBody()
            body_json = json:decode(body_text)
            freeswitch.consoleLog("ERR", body_text)

            if body_json["is_final"] == true then
                channel = body_json["channel"]
                if channel ~= nil then
                    alternatives = channel["alternatives"]
                    if alternatives[1] ~= nil then
                        -- logme(body_json["channel"]["alternatives"][1])
                        speech_text = alternatives[1]["transcript"]
                        if speech_text ~= nil then
                            freeswitch.consoleLog("ERR", "FINAL TRANSCRIBE --------------------------------" .. speech_text)
                            endtime_1=os.time()
                            endtime_2=os.clock()
                            endtime = (endtime_1*1000)+(endtime_2*1000)
                            gp = endtime-starttime
                            freeswitch.consoleLog("ERR", "--------------------------------")
                            freeswitch.consoleLog("ERR", 'Start time ' .. starttime)
                            freeswitch.consoleLog("ERR", 'end time ' .. endtime)
                            freeswitch.consoleLog("ERR", 'STT time ' .. gp)
                            freeswitch.consoleLog("ERR", "--------------------------------")

                            api:execute("uuid_deepgram_transcribe", uuid.." stop")
                            new_connection = true
                            local tts_engine = "google_tts"
                            local tts_voice = "hi-IN-Standard-A"
                            session:execute("speak", tts_engine .. "|" .. tts_voice .. "|" .. speech_text)
                            --freeswitch.consoleLog("ERR", 'API RESPONSE ' .. response_json)
                            freeswitch.consoleLog("ERR", 'API CALL COMPLETED')
                            session:streamFile("ivr/ivr-welcome.wav")
                            starttime_1=os.time()
                            starttime_2=os.clock()
                            starttime = (starttime_1*1000)+(starttime_2*1000)
                        end
                    end
                end
            end
        end
    end
    session:hangup()

end