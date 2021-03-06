require "http/client"
require "json"
require "db"
require "mysql"

Data = DB.open "mysql://root@localhost:3306/idmemebot"
API = "412769456:AAFyG7MkqHWg6R9HYYtDhj3nJgiDUdvDUts"
URL = "https://api.telegram.org/bot#{API}/"

loop do
  sleep 50.millisecond
  update = getUpdates()
  puts "[UPDATE] #{Time.now}"
  if !update["result"].to_a.empty?
    len = update["result"].to_a.last["update_id"]
    update["result"].each do |v|
      update_id = v["update_id"]
      update_id == len ? forgot(update_id.to_s.to_i+1) : ""
      msg = v["message"]
      # Try puts msg, to check response value
      sendMessage(msg["chat"]["id"], "Hello World. ^^") if msg == "/start" 
    end
  end
end

def sendMeme()
  Data.query "select chatid from users" do |n|
    n.each do
      a = n.read(String)
      HTTP::Client.get URL + "sendMessage?chat_id=#{cid}&text=#{text}"
    end
  end
end

def getUpdates()
  a = HTTP::Client.get URL + "getUpdates"
  b = JSON.parse a.body
  return b
end

def sendMessage(cid, text)
  a = HTTP::Client.get URL + "sendMessage?chat_id=#{cid}&text=#{text}"
end

def forgot(i)
  HTTP::Client.get URL + "getUpdates?offset=#{i}"
end
