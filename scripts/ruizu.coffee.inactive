# Description:
#   send message to chat room by cron

module.exports = (robot) ->
  roomId = '147342_calpo@conf.hipchat.com'
  cronJob = require('cron').CronJob

  send = (room, msg) ->
    response = new robot.Response(
      robot, {
        user : {id : -1},
        text : "none",
        done : false,
        room: room
      }, [
      ]
    )
    response.send msg

  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('*/5 * * * * *', () ->
    msg = """
ルイズ！ルイズ！ルイズ！ルイズぅぅうううわぁああああああああああああああああああああああん！！！
とどけえええええええ！
    """
    send roomId, "#{msg}"
  ).start()
