# Description:
#   send message to chat room by cron

module.exports = (robot) ->
  userList = [
    'taro',
    'jiro',
    'saburo',
  ]
  assigned = robot.brain.get 'assigned'
  if assigned == null
    assigned =
      turn: buildTurn (new Date('2014-08-01'))
      user: 0

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

  buildTurn = (date) ->
    turn =
      date.getFullYear() +
      '-' + ('0' + (date.getMonth() + 1)).slice(-2) +
      '-' + date.getDay()

  robot.respond /hoge$/i, (msg) ->
    msg.send userList[assigned.user]

  robot.respond /skip$/i, (msg) ->
    forwardUser()
    msg.send userList[assigned.user]

  robot.respond /back$/i, (msg) ->
    backUser()
    msg.send userList[assigned.user]

  robot.respond /bset$/i, (msg) ->
    robot.brain.set 'assigned', assigned

  robot.respond /bget$/i, (msg) ->
    console.log assigned

