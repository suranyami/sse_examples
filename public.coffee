Logger = (id) ->
  @el = document.getElementById(id)

closeConnection = ->
  source.close()
  logger.log "> Connection was closed"
  updateConnectionStatus "Disconnected", false

updateConnectionStatus = (msg, connected) ->
  el = document.querySelector("#connection")

  if connected
    if el.classList
      el.classList.add "connected"
      el.classList.remove "disconnected"
    else
      el.addClass "connected"
      el.removeClass "disconnected"
  else
    if el.classList
      el.classList.remove "connected"
      el.classList.add "disconnected"
    else
      el.removeClass "connected"
      el.addClass "disconnected"

  el.innerHTML = msg + "<div></div>"

unless window.DOMTokenList
  Element::containsClass = (name) ->
    new RegExp("(?:^|\\s+)" + name + "(?:\\s+|$)").test @className

  Element::addClass = (name) ->
    unless @containsClass(name)
      c = @className
      @className = (if c then [c, name].join(" ") else name)

  Element::removeClass = (name) ->
    if @containsClass(name)
      c = @className
      @className = c.replace(new RegExp("(?:^|\\s+)" + name + "(?:\\s+|$)", "g"), "")

source = new EventSource("sse")

Logger::log = (msg, opt_class) ->
  fragment = document.createDocumentFragment()
  p = document.createElement("p")
  p.className = opt_class or "info"
  p.textContent = msg
  fragment.appendChild p
  @el.appendChild fragment

Logger::clear = ->
  @el.textContent = ""

logger = new Logger("log")

source.addEventListener "message", ((event) ->
  data = JSON.parse(event.data)
  d = new Date(data.time * 1e3)
  timeStr = [d.getHours(), d.getMinutes(), d.getSeconds()].join(":")
  coolclock.render d.getHours(), d.getMinutes(), d.getSeconds()
  logger.log "lastEventID: " + event.lastEventId + ", server time: " + timeStr, "msg"
), false

source.addEventListener "open", ((event) ->
  logger.log "> Connection was opened"
  updateConnectionStatus "Connected", true
), false

source.addEventListener "error", ((event) ->
  if event.eventPhase is 2 #EventSource.CLOSED
    logger.log "> Connection was closed"
    updateConnectionStatus "Disconnected", false
), false

coolclock = CoolClock.findAndCreateClocks()
