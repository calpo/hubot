# Description:
#   Notify duty person of the day.
#   It makes daily rotation. And tells who shourd pay the price.
#
# Commands:
#   hubot who has duty - Reply person who has duty
#   hubot skip duty person - Assign next user as duty person.
#   hubot back duty person - Assign previous user as duty person.

module.exports = (robot) ->
  # Duty will call them.
  userList = [
    'taro',
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

  forwardUser = ->
    assignResult.user++
    if assignResult.user >= userList.length
      assignResult.user = 0
    robot.brain.set 'assignResult', assignResult

  backUser = ->
    assignResult.user--
    if assignResult.user < 0
      assignResult.user = userList.length - 1
    robot.brain.set 'assignResult', assignResult

  refreshAssigned = ->
    previousTurn = assignResult.turnId
    assignResult.turnId = buildTurnId today
    if assignResult.turnId == null
      # nothing
    else if previousTurn != assignResult.turnId
      forwardUser()
    robot.brain.set 'assignResult', assignResult

  noticeAssigned = (msg) ->
    if assignResult.turnId == null
      msg.send "No duty today. Previous duty person was #{userList[assignResult.user]}."
      return
    msg.send "#{userList[assignResult.user]} is today's duty person. (#{assignResult.turnId})"

  assignResult = robot.brain.get 'assignResult'
  console.log robot.brain.get 'assignResult'
  if assignResult == null
    assignResult =
      turnId: buildTurnId today
      user: 0

  robot.respond /who has duty$/i, (msg) ->
    refreshAssigned()
    noticeAssigned msg

  robot.respond /skip duty person$/i, (msg) ->
    msg.send "bye #{userList[assignResult.user]}."
    forwardUser()
    noticeAssigned msg

  robot.respond /back duty person$/i, (msg) ->
    msg.send "bye #{userList[assignResult.user]}."
    backUser()
    noticeAssigned msg

  robot.respond /fake date to ([-0-9]+)$/i, (msg) ->
    today = new Date msg.match[1]

  robot.respond /reset faked date$/i, (msg) ->
    today = new Date()

