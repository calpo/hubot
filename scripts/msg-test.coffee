# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot show msg - Reply with pong

module.exports = (robot) ->
  robot.respond /show msg$/i, (msg) ->
    console.log msg
    msg.send msg.message.user.reply_to
