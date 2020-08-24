class @SvgShape extends @SvgCanvas
  get = (props) =>
    @::__defineGetter__ name, getter for name, getter of props
  set = (props) =>
    @::__defineSetter__ name, setter for name, setter of props
  
  get width: ->
    @_width

  set width: (width) ->
    @_width = width

  get height: ->
    @_height

  set height: (height) ->
    @_height = height

  constructor: ->
  
  # scales length
  length: (lv_length) ->
    lv_delta_s = @_width/@_unit
    (lv_length * lv_delta_s)
              
  #
  # converts cartesian coordinates to screen coordinates
  # example
  # unit = 10, width = 300px
  #
  # the x/y is scaled by
  # delta_s = width/unit = 300/10 = 30
  #
  to_screen: (point) ->
    lv_scale_x = @_width/@_unit
    lv_scale_y = @_height/@_unit

    lv_x =  1.0 * lv_scale_x * point.x + @_width/2
    lv_y = -1.0 * lv_scale_y * point.y + @_height/2

    {x: lv_x, y: lv_y}

  # convert screen coordinates to cartesian coordinates
  to_xy: (point) ->
    lv_scale_x = @_unit/@_width
    lv_scale_y = @_unit/@_height

    lv_x =  1.0 * lv_scale_x * ( point.x - @_width/2 ) #- 0.05
    lv_y = -1.0 * lv_scale_y * ( point.y - @_height/2 ) #+ 0.05

    {x: lv_x, y: lv_y}
    
