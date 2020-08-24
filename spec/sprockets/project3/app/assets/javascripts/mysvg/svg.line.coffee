class @SvgLine extends @SvgShape
  get = (props) =>
    @::__defineGetter__ name, getter for name, getter of props
  set = (props) =>
    @::__defineSetter__ name, setter for name, setter of props

  #get canvas: ->
  #  @_canvas
    
  #set canvas: (canvas) ->
  #  @_canvas = canvas
  get unit: ->
    @_unit 
    
  set unit: (unit) ->
    @_unit = unit  

  get opacity: ->
    @_opacity 
    
  set opacity: (opacity) ->
    @_opacity = opacity  
  
  get color: ->
    @_color 
    
  set color: (color) ->
    @_color = color 

  get thickness: ->
    @_thickness 
    
  set thickness: (thickness) ->
    @_thickness = @length(thickness) 

  constructor: (point_a,point_b) ->
    super()
    @_point_a = point_a
    @_point_b = point_b
    
  path: ->
    lv_pointa = @to_screen(@_point_a)
    lv_pointb = @to_screen(@_point_b)

    lv_path = "M#{lv_pointa.x},#{lv_pointa.y} L#{lv_pointb.x},#{lv_pointb.y}"
    lv_path
  
  #draw: ->
  #  @canvas.path(@path(),true).stroke({opacity: @opacity, color: @color, width: @thickness})
  
