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
  buildDayId = (date) ->
    if date.getDay() == 0
      #date.setDate date.getDate() - 2
      return null
    if date.getDay() == 6
      #date.setDate date.getDate() - 1
      return null

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
    previousTurn = assigned.turn
    assigned.turn = buildDayId (new Date(str_now))
    if assigned.turn == null
      # nothing
    else if previousTurn != assigned.turn
      forwardUser()
    robot.brain.set 'assigned', assigned

  noticeAssigned = (msg) ->
    if assigned.turn == null
      msg.send "No duty today. Previous duty person was #{userList[assigned.user]}."
      return
    msg.send "#{userList[assigned.user]} is today's duty person. (#{assigned.turn})"

  assigned = robot.brain.get 'assigned'
  if assigned == null
    assigned =
      turn: buildDayId (new Date())
      user: 0

  robot.respond /skip duty person$/i, (msg) ->
    forwardUser()
    noticeAssigned msg

  robot.respond /back duty person$/i, (msg) ->
    backUser()
    noticeAssigned msg

  robot.respond /who has duty$/i, (msg) ->
    noticeAssigned msg

  robot.respond /refresh$/i, (msg) ->
    refreshAssigned (new Date()).toString()
    noticeAssigned msg

  robot.respond /set now ([-0-9]+)$/i, (msg) ->
    refreshAssigned msg.match[1]
    noticeAssigned msg

