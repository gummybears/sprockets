class @SvgCanvas extends @SvgBase
  get = (props) =>
    @::__defineGetter__ name, getter for name, getter of props
  set = (props) =>
    @::__defineSetter__ name, setter for name, setter of props

  constructor: (element) ->
    super()
    @_element = element
    @_width   = $("##{@element}").width()
    @_height  = $("##{@element}").height()
    @_canvas  = SVG(@_element).size(@_width, @_height).fixSubPixelOffset()
    @_canvas_id = "canvas"
    @_canvas.attr({id: @_canvas_id})
    @_unit    = 10
    @shape    = new SvgShape
    @shape.width  = @_width
    @shape.height = @_height
    @shape.unit   = @_unit
    
  get unit: ->
    @_unit
    
  set unit: (unit) ->
    @_unit = unit
    
  get element: ->
    @_element

  set element: (element) ->
    @_element = element

  get width: ->
    @_width

  set width: (width) ->
    @_width = width

  get height: ->
    @_height

  set height: (height) ->
    @_height = height

  get canvas: ->
    @_canvas

  set canvas: (canvas) ->
    @_canvas = canvas

