# Description:
#   send message to chat room by cron

module.exports = (robot) ->
  userList = [
    'taro',
    'jiro',
    'saburo',
    'siro',
    'goro',
    'rokuro',
    'nanaro',
  ]

  buildTurn = (date) ->
    if date.getDay() == 0
      date.setDate date.getDate() - 2
    if date.getDay() == 6
      date.setDate date.getDate() - 1

    turn =
      date.getFullYear() +
      '-' + ('0' + (date.getMonth() + 1)).slice(-2) +
      '-' + ('0' + date.getDate()).slice(-2)


  forwardUser = ->
    assigned.user++
    if assigned.user >= userList.length
      assigned.user = 0
    robot.brain.set 'assigned', assigned

  backUser = ->
    assigned.user--
    if assigned.user < 0
      assigned.user = userList.length - 1
    robot.brain.set 'assigned', assigned

  refreshAssigned = (str_now) ->
    currentTurn = buildTurn (new Date(str_now))
    if currentTurn != assigned.turn
      assigned.turn = currentTurn
      forwardUser()

  noticeAssigned = (msg) ->
    msg.send assigned.turn
    msg.send userList[assigned.user]

  assigned = robot.brain.get 'assigned'
  if assigned == null
    assigned =
      turn: buildTurn (new Date())
      user: 0

  robot.respond /skip$/i, (msg) ->
    forwardUser()
    noticeAssigned msg

  robot.respond /back$/i, (msg) ->
    backUser()
    noticeAssigned msg

  robot.respond /duty person$/i, (msg) ->
    noticeAssigned msg

  robot.respond /refresh$/i, (msg) ->
    refreshAssigned (new Date()).toString()
    noticeAssigned msg

  robot.respond /set now ([-0-9]+)$/i, (msg) ->
    refreshAssigned msg.match[1]
    noticeAssigned msg

