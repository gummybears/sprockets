#window.points = []

jQuery ->

  $('#opacity').slider ->
    
  $("#opacity").on 'slide', (event) ->
    window.grid.board.suspendUpdate()
    lv_opacity = event.value/100
    window.grid.image.setProperty({fillOpacity: lv_opacity})
    window.grid.board.unsuspendUpdate()
    
  if $("#image").length > 0
    window.grid = new SvgBoard('image')

  $("#filename").on 'change', () ->
    lv_option = $(this).find("option:selected")
    lv_value  = lv_option.val()
    window.grid.add_image(lv_value)

  $("#filename").on 'click', () ->
    lv_option = $(this).find("option:selected")
    lv_value  = lv_option.val()
    window.grid.add_image(lv_value)

  $('#clear_curve').on 'click', () ->
    window.grid.clear_curve()      

  $('#clear_image').on 'click', () ->
    window.grid.clear_image()

  $("#curve_catmull").on 'click', () ->
    if window.grid.points.length > 2
      window.grid.curve_catmull()

  $("#curve_cardinal").on 'click', () ->
    if window.grid.points.length > 2
      window.grid.curve_cardinal()

  $("#curve_bspline").on 'click', () ->
    if window.grid.points.length > 2
      window.grid.curve_bspline()

  $("#line_bspline").on 'click', () ->
    if window.grid.points.length > 2
      window.grid.connect_points()

  $("#delete_point").on 'click', () ->
    window.grid.delete_point( $("#element_name").val() )

  $("#create_point").on 'click', () ->
    window.grid.create_point( $("#pos_x").val(), $("#pos_y").val() )

  $("#update_point").on 'click', () ->
    window.grid.update_point( $("#element_name").val(), $("#pos_x").val(), $("#pos_y").val() )

  $("#save").on 'click', () ->
    lv_asy = window.grid.to_asy()
    $("#asy_code").html(lv_asy)

  $("#parse_asy").on 'click', () ->
    lv_asy_code = $("#input_asy").val()
    if lv_asy_code.length > 0
      window.grid.parse_asy(lv_asy_code)

