BB.Helpers.SidebarRowHelpers =

  eventLink: ->
    shortTitle = _.string.truncate(@title, 12)
    return shortTitle if @isActive
    linkTitle  = => "<a href='/events/#{@id}'>#{shortTitle}</a>"
    if @id then linkTitle() else shortTitle

  bStart: ->
    date = moment(@start)?.strftime("%Y-%m-%d")
    "<nobr>#{date}</nobr>"

  bId        : -> if @id then @id else "NA"

  bLocation  : -> _.string.truncate(@location, 12)

  bTyp       : ->
    prefix = if @published then "+" else "~"
    char   = @typ[0].toUpperCase()
    "#{prefix} #{char}"
    "<span style='color: darkgrey'>#{prefix}</span> #{char}"

  activeClass: ->
    return " class='pubSubdEvent'" if @pubSub?
    return " class='activeEvent'"  if @isActive
    return ""

  linkCell   : -> "<td#{@activeClass()}>#{@eventLink()}</td>"

  locCell    : -> "<td#{@activeClass()}>#{@bLocation()}</td>"
