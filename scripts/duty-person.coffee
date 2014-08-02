# Description:
#   Notify duty person of the day.
#   It makes daily rotation. And tells who shourd pay the price.
#
# Commands:
#   hubot who is duty person - Reply person whom duty calls.
#   hubot skip duty person - Assign next user.
#   hubot back duty person - Assign previous user.

module.exports = (robot) ->
  # RoomID
  roomId = process.env.HUBOT_HIPCHAT_ROOMS

  # Duty will call them.
  userList = [
    'ichiro',
    'jiro',
    'saburo',
    'siro',
    'goro',
    'rokuro',
    'nanaro',
  ]

  # Returns ID of the every single duty day.
  # If there is no duty at the day, this function should return null.
  # If it is weekly duty, this function should return same ID while week, and change it when next week comes.
  buildTurnId = (date) ->
    if date.getDay() == 0
      return null
    if date.getDay() == 6
      return null

    return date.getFullYear() +
      '-' + ('0' + (date.getMonth() + 1)).slice(-2) +
      '-' + ('0' + date.getDate()).slice(-2)

  today = new Date()
  isDateFaked = false

  forwardUser = ->
    assignResult = getAssignResult()
    assignResult.user++
    if assignResult.user >= userList.length
      assignResult.user = 0
    robot.brain.data.assignResult = assignResult
    robot.brain.save()

  backUser = ->
    assignResult = getAssignResult()
    assignResult.user--
    if assignResult.user < 0
      assignResult.user = userList.length - 1
    robot.brain.data.assignResult = assignResult
    robot.brain.save()

  refreshAssigned = ->
    assignResult = getAssignResult()
    previousTurn = assignResult.turnId
    assignResult.turnId = buildTurnId today
    if assignResult.turnId == null
      # nothing
    else if previousTurn != assignResult.turnId
      forwardUser()
    robot.brain.data.assignResult = assignResult
    robot.brain.save()

  getNotificationMessage = ->
    assignResult = getAssignResult()
    if assignResult.turnId == null
      return "No duty today. Previous duty person was #{userList[assignResult.user]}."
    return "#{userList[assignResult.user]} is today's duty person. (#{assignResult.turnId})"

  getAssignResult = ->
    assignResult = robot.brain.data.assignResult || null
    if assignResult == null
      assignResult =
        turnId: buildTurnId today
        user: 0
    return assignResult

  sendMessage = (room, msg) ->
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

  cronJob = require('cron').CronJob
  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('*/10 * * * * *', () ->
    if isDateFaked == false
      today = new Date()
    refreshAssigned()
    sendMessage roomId, getNotificationMessage()
  ).start()

  robot.respond /who is duty person$/i, (msg) ->
    refreshAssigned()
    msg.send getNotificationMessage()

  robot.respond /skip duty person$/i, (msg) ->
    assignResult = getAssignResult()
    msg.send "bye #{userList[assignResult.user]}."
    forwardUser()
    msg.send getNotificationMessage()

  robot.respond /back duty person$/i, (msg) ->
    assignResult = getAssignResult()
    msg.send "bye #{userList[assignResult.user]}."
    backUser()
    msg.send getNotificationMessage()

  robot.respond /fake date to ([-0-9]+)$/i, (msg) ->
    today = new Date msg.match[1]
    isDateFaked = true
    msg.send "Today is #{today.toLocaleString()}"

  robot.respond /reset faked date$/i, (msg) ->
    today = new Date()
    isDateFaked = false
    msg.send "Today is #{today.toLocaleString()}"

