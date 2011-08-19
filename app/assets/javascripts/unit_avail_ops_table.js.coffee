###
This is jQuery code that manages the
table sorting on the unit_certs/index page.

Table sorter plugin at: http://tablesorter.com
###

last_name_options =
  id:     'last_name'                             # the parser name
  is:     (s) -> false                            # disable standard parser
  type:   'text'                                  # either text or numeric
  format: (s) -> (new MemberName(s)).last_name()  # the sort key (last name)

role_score_options =
  id:     'role_score'                            # the parser name
  is:     (s) -> false                            # disable standard parser
  type:   'numeric'                               # either text or numeric
  format: (s) -> (new RoleScore(s)).score()       # the sort key (role score)
   
headers =
  headers:
    0: {sorter: 'role_score'}    # sort col 0 using role_score options
    1: {sorter: 'last_name'}     # sort col 3 using last_name options

filter_params =
  filterContainer:      "#filter-box"
  filterClearContainer: "#filter-clear-button"
  filterColumns:        [0,1,2]
  columns:              ["role", "name", "status"]

$(document).ready ->
  $.tablesorter.addParser last_name_options
  $.tablesorter.addParser role_score_options
  $("#myTable").tablesorter headers
  $("#myTable").tablesorterFilter(filter_params)
  $("#filter-box").focus()
  $("#filter-box").keyup ->
    setTimeout('', 750)
