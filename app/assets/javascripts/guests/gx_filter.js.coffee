# for the guest filter...
$(document).ready ->
  $('#gx_check').prop("checked", true) if readCookie("gx_show") == "true"
  $('#gx_check').click ->
    if $('#gx_check').is(':checked')
      createCookie("gx_show", "true")
    else
      createCookie("gx_show", "false")
    refresh_url = window.location.href.split('?', 1) + "?refresh=true"
    window.location.assign(refresh_url)