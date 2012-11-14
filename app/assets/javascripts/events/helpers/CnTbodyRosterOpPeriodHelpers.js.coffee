BB.Helpers.CnTbodyRosterOpPeriodHelpers =
  deletePeriodLink: (periodId) ->
    "<a href='#' class='deletePeriod' data-id='#{periodId}'>X</a>"

  # ----- guestLink or RSVP link -----

  actionLink: ->
    event = BB.Collections.events.get(@event_id)
    if event.get('typ') == "training"
      @guestLink()
    else
      @rsvpLink()
  guestLink: ->
      "<a style='margin-right: 40px;' style='display: none;' href='#' class='createGuestLink' id='createGuestLink#{@id}'>add new guest</a>"
  rsvpLink: ->
      "<input style='margin-right: 40px;' type='button' class='rsvpLink' value='link to rsvp'/>"

  # ----- add participants -----

  memberField: ->
    if @isActive
      "<input style='margin-left: 80px;' size=18 class='memberField' id='memberField#{@id}' name='newParticipant' placeholder='add participant...' />"
    else
      "<a style='margin-left: 80px;' href='#' class='selectPeriod'>add participant</a>"

  timeHeaders: ->
    displayState = BB.rosterState.get('state')
    switch displayState
      when "none"    then ""
      when 'transit' then "<th>En-route at</th><th>Return at</th>"
      when "signin"  then "<th>Sign-in at</th><th>Sign-out at</th>"
      else ""