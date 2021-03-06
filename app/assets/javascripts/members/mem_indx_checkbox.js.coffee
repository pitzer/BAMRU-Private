###
This file has three jQuery functions:
1) update address count
2) select by member type
3) clear all
###

# ----- 1) update address count -----

ootCount = ->
  $('.oot_member .rck:checked').length

window.updateAddressCount = ->
  addr_count = $(".rck:checked").length
  label = if addr_count == 1 then "address" else "addresses"
  if ootCount() == 0 then $('#clearoot').hide() else $('#clearoot').show()
  $("#addr_count").text("#{addr_count} #{label}")

$(document).ready ->
  updateAddressCount()
  $(".rck").click -> updateAddressCount()

# ----- 2) select by member type -----

# checkbox id's are encoded as 'cb_TM' or 'cb_FM'
# the boxType is the part after the underscore...
boxType = (box) -> box.id.split('_')[1]
enCheck = (box) -> $(".#{box}").prop("checked", true)
deCheck = (box) -> $(".#{box}").prop("checked", false)
toggleClick = (box) ->
  box_type = boxType(box)
  if $(box).is(':checked')
    enCheck(box_type)
  else
    deCheck(box_type)
    enCheck("Bd") if $("#cb_Bd").is(':checked')
    enCheck("OL") if $("#cb_OL").is(':checked')
    enCheck("TM") if $("#cb_TM").is(':checked')
    enCheck("FM") if $("#cb_FM").is(':checked')
    enCheck("T")  if $("#cb_T").is(':checked')
    enCheck("R")  if $("#cb_R").is(':checked')
    enCheck("S")  if $("#cb_S").is(':checked')
    enCheck("A")  if $("#cb_A").is(':checked')
  updateAddressCount()

$(document).ready ->
  $(".slx").click -> toggleClick(this)

# ----- 3) clear all -----

clearAll = ->
  deCheck("rck")
  deCheck("slx")
  updateAddressCount()

$(document).ready ->
  $("#clear_all").click -> clearAll()

# ----- 4) clear sms, email, oot -----

window.clearSMS = ->
  $(".sms_ck").prop("checked", false)
  updateAddressCount()

window.selectSMS = ->
  $(".sms_ck").prop("checked", true)
  updateAddressCount()

$(document).ready ->
  $("#clear_sms").click -> clearSMS()

window.clearMail = ->
  $(".mail_ck").prop("checked", false)
  updateAddressCount()

window.selectMail = ->
  $(".mail_ck").prop("checked", true)
  updateAddressCount()

$(document).ready ->
  $("#clear_mail").click -> clearMail()

window.clearOOT = ->
  $(".oot_member .rck").prop("checked", false)
  updateAddressCount()

$(document).ready ->
  $("#clear_oot").click -> clearOOT()

# ----- 5) rsvps -----

responseForm = (name, label, json) ->
  "
  <style type='text/css'>
  .rsvp_lbl {
  display: inline-block;
  width: 30px;
  text-align: right;
  padding-right: 5px;
  }
  </style>
  <input type='hidden' id=rsvp_value name='rsvps' value='#{json}'/>
  <div style='border-bottom: solid 1px; align: center;'>
  <table width=100% style='font-size: 8pt; margin-bottom: 0px;'>
  <tr>
  <td>
  <b>Using the '#{name}' RSVP form</b>
  </td>
  <td align=right>
  <a href='http://wiki.bamru.net/index.php/RSVPs' target='_blank'>help</a>
  </td>
  </tr>
  </table>
  </div>
  <span class='rsvp_lbl'>RSVP:</span>#{label.prompt}<br/>
  <span class='rsvp_lbl'>YES:</span>#{label.yes_prompt}<br/>
  <span class='rsvp_lbl'>NO:</span>#{label.no_prompt}<br/>
  "
  
setPreviewOpts = (prompt, yes_prompt, no_prompt) ->
  PREVIEW_OPTS.prompt = prompt
  PREVIEW_OPTS.yes_prompt = yes_prompt
  PREVIEW_OPTS.no_prompt  = no_prompt

setDisplay = (select) ->
  optName = $(select).attr('value')
  if optName == "NA"
    $('#rsvp_display').hide()
    $('#rsvp_display').html("")
    setPreviewOpts("", "", "")
    updateTextBoxCount()
    return
  labelJSON = $(select).children("option:selected").attr('data-prompt')
  labelObj  = JSON.parse(labelJSON)
  setPreviewOpts(labelObj.prompt, labelObj.yes_prompt, labelObj.no_prompt)
  $('#rsvp_display').html(responseForm(optName, labelObj, labelJSON))
  $('#rsvp_display').show()
  updateTextBoxCount()

$(document).ready ->
  $('#rsvp_display').hide()
  $('#blank_select').attr('selected', 'selected')
  $('#rsvp_select').change ->
    setDisplay(this)

# ----- 6) preview -----

$(document).ready ->
  $('#preview_link').click ->
    PREVIEW_OPTS.text = $('#message_area').attr('value')
    data = escape(JSON.stringify(PREVIEW_OPTS))
    window.open("/preview/init_opts?opts=#{data}", '_blank')

