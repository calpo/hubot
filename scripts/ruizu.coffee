# Description:
#   send message to chat room by cron

roomId = '147342_calpo@conf.hipchat.com'

cronJob = require('cron').CronJob

module.exports = (robot) ->
    send = (room, msg) ->
        response = new robot.Response(robot, {user : {id : -1}, text : "none", done : false, room: room}, [])
        response.send msg

    # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
    new cronJob('1 * * * * *', () ->
        msg = """
ルイズ！ルイズ！ルイズ！ルイズぅぅうううわぁああああああああああああああああああああああん！！！
とどけえええええええ！
        """
        send roomId, "#{msg}"
    ).start()
