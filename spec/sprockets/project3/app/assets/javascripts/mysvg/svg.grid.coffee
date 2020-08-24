class @SvgGrid extends @SvgCanvas
  get = (props) =>
    @::__defineGetter__ name, getter for name, getter of props
  set = (props) =>
    @::__defineSetter__ name, setter for name, setter of props

  get points: ->
    @_points
    
  get nr_x_lines: ->
    @_nr_x_lines
    
  get nr_y_lines: ->
    @_nr_y_lines

  get is_visible: ->
    @_is_visible
    
  set is_visible: (flag) ->
    @_is_visible = flag
    
    @hide_x_lines(flag)
    @hide_y_lines(flag)

  get fill_color: ->
    @_fill_color
    
  set fill_color: (color) ->
    @_fill_color = color
    
  get opacity: ->
    @_opacity 
    
  set opacity: (opacity) ->
    @_opacity = opacity  

  get mode: ->
    @_mode 
    
  set mode: (mode) ->
    @_mode = mode  

  #@ID: 1000
      
  constructor: (element) ->
    super(element)
    @_fillcolor = "white"
    @_opacity   = 1.0
    @_points    = []
    @_mode      = 'line'       
    @_asycode   = ""
    @_dot_id    = 0
    @_nr_points = 0
    this.bind_mousedown_to_canvas()
    this.bind_mousemove_to_canvas()
    
    lv_element = SVG.get('horizontal_line')
    if lv_element
      lv_element.remove()
    #this.bind_mouseup_to_canvas()
        
  hide_x_lines: (flag) ->
    for i in [0..@_nr_x_lines]
      lv_path_id = "path_x_#{i}"
      lv_element = SVG.get(lv_path_id)
      if flag == 0
        lv_element.hide()
      else
        lv_element.show()    
  
  hide_y_lines: (flag) ->
    for i in [0..@_nr_y_lines]
      lv_path_id = "path_y_#{i}"
      lv_element = SVG.get(lv_path_id)
      if flag == 0
        lv_element.hide()
      else
        lv_element.show()    
        
  rectangle: ->
    lv_rect = @_canvas.rect(@_width,@_height).fill({color: @_fill_color, opacity: @_opacity})

  x_lines: ->
  
    lv_step_x = @_width/@_unit
    lv_i = 0
    for lv_x in [0..@_width] by lv_step_x
      lv_line = @_canvas.line(lv_x,0,lv_x,@_height)
      lv_line.attr({id: "path_x_#{lv_i}"})
      lv_line.stroke({color: "lightblue", width: 2}).opacity(0.5)
        
      lv_i = lv_i + 1

    lv_step_x = @_width/(10*@_unit)
    for lv_x in [0..@_width] by lv_step_x
      lv_line = @_canvas.line(lv_x,0,lv_x,@_height)
      lv_line.attr({id: "path_x_#{lv_i}"})
      lv_line.stroke({color: "gray", width: 1}).opacity(0.5)
        
      lv_i = lv_i + 1
    
    @_nr_x_lines = lv_i - 1
       
  y_lines: ->
  
    lv_step_y = @_height/@_unit
    lv_i = 0
    for lv_y in [0..@_height] by lv_step_y
      lv_line = @_canvas.line(0,lv_y,@_width,lv_y)
      lv_line.attr({id: "path_y_#{lv_i}"})
      lv_line.stroke({color: "lightblue", width: 2}).opacity(0.5)
        
      lv_i = lv_i + 1

    lv_step_y = @_height/(10*@_unit)
    for lv_y in [0..@_height] by lv_step_y
      lv_line = @_canvas.line(0,lv_y,@_width,lv_y)
      lv_line.attr({id: "path_y_#{lv_i}"})
      lv_line.stroke({color: "gray", width: 1}).opacity(0.5)
        
      lv_i = lv_i + 1
    
    @_nr_y_lines = lv_i - 1

  offset: (lv_id) ->
    lv_offset = $("##{lv_id}").offset()

  mouse_position: (event) ->
    lv_id = @_canvas.parent.id
    lv_offset = this.offset(lv_id)

    s_x = event.pageX - lv_offset.left
    s_y = event.pageY - lv_offset.top 
    new SvgPoint(s_x,s_y)
    
  display_mouse_position: (event) ->
    lv_screen_point = this.mouse_position(event);
    lv_point = @shape.to_xy( new SvgPoint(lv_screen_point.x,lv_screen_point.y) )
    $("#image_display_mouse_pos").text("(x,y) = (#{lv_point.x.toFixed(2)},#{lv_point.y.toFixed(2)})")
    
  clear: ->
    this.remove_line()
    this.remove_curve()
    this.remove_dots()
    @_points = []
        
  draw: ->
    this.rectangle()
    this.x_lines()
    this.y_lines()
    
  image_opacity: (opacity) ->
    lv_element = SVG.get("uploaded_image")
    if lv_element
      lv_element.attr('opacity',opacity/100.0)
      
  image_display: (filename,opacity) ->
    lv_element = SVG.get("uploaded_image")
    if lv_element
      lv_element.attr('href',filename) #,@_width,@_height)
      lv_element.attr('opacity',opacity/100.0)
    else
      lv_image = @_canvas.image(filename,@_width,@_height)
      lv_image.opacity(opacity/100.0)
      lv_image.id("uploaded_image")
    
  update_xy: (lv_id,lv_screen_point) ->
    lv_point = @shape.to_xy( new SvgPoint(lv_screen_point.x,lv_screen_point.y) )
    
    $("#pos_x").val(lv_point.x.toFixed(2))
    $("#pos_y").val(lv_point.y.toFixed(2))
    $("#element_id").val(lv_id)
        
  bind_mousedown_to_canvas:  ->
    @canvas.mousedown (event) =>
      lv_radius = 5
      #@_canvas.style('cursor', 'crosshair')
      this.display_mouse_position(event)    
  
      lv_point   = this.mouse_position(event)  
      lv_circle = @_canvas.circle(2*lv_radius)
      lv_circle.attr({'cx': lv_point.x, 'cy' : lv_point.y })
      lv_circle.stroke({color: "red"}).fill("red")
      lv_circle.attr({id: "dot_#{@_dot_id}" })
 
      this.circle_mouse_down(lv_circle)      
      this.circle_mouse_move(lv_circle)      
      this.circle_mouse_up(lv_circle)      
                        
      @_points.push({x: lv_point.x, y: lv_point.y, id: "dot_#{@_dot_id}" })

      @_dot_id = @_dot_id + 1
      if @_mode == 'line'
        this.connect_line()
      else if @_mode == 'curve'
        this.connect_curve()

  circle_mouse_down: (lv_circle) ->
    lv_circle.mousedown (event) =>
      @_canvas.style('cursor', 'default')
      
      @is_dragging = true
      event.cancelBubble = true
      lv_id = event.currentTarget.id
      lv_element = SVG.get(lv_id)

      lv_point = this.mouse_position(event)
      this.update_xy(lv_id,lv_point)
      
      if lv_element
        lv_element.fill("blue").stroke({color: "black", width: 1})
        
  circle_mouse_move: (lv_circle) ->
    lv_circle.mousemove (event) =>
      @_canvas.style('cursor', 'default')

      lv_id = event.currentTarget.id
      lv_element = SVG.get(lv_id)
      lv_point = this.mouse_position(event)
      
      if lv_element
        lv_element.fill("yellow").stroke({color: "black", width: 1})
        this.update_xy(lv_id,lv_point)

      if @is_dragging
        event.cancelBubble = true
        
        lv_element = SVG.get(lv_id)
        if lv_element
          lv_element.attr({'cx': lv_point.x, 'cy' : lv_point.y })        
          lv_element.fill("green").stroke({color: "black", width: 1})
          # find point in array @_points
          this.adjust_points(lv_id,lv_point)
          this.update_xy(lv_id,lv_point)

  circle_mouse_up:   (lv_circle) ->
    lv_circle.mouseup (event) =>
      @_canvas.style('cursor', 'default')
      #event.cancelBubble = true
      lv_id = event.currentTarget.id
      lv_element = SVG.get(lv_id)
      if lv_element
        lv_element.fill("red").stroke({color: "red"})
        if @is_dragging
          lv_point = this.mouse_position(event)
          lv_element.attr({'cx': lv_point.x, 'cy' : lv_point.y })        
          lv_element.fill("red").stroke({color: "red"})
          this.update_xy(lv_id,lv_point)

      @is_dragging = false
    
  update_dot: (lv_id,lv_x,lv_y) ->
    lv_x = parseFloat(lv_x)
    lv_y = parseFloat(lv_y)
    lv_screen_point = @shape.to_screen( new SvgPoint(lv_x,lv_y) )

    # find existing dot
    lv_element = SVG.get(lv_id)
    if lv_element
      lv_element.attr({'cx': lv_screen_point.x, 'cy' : lv_screen_point.y })
      this.adjust_points(lv_id, lv_screen_point) 

  delete_dot: (lv_id,lv_x,lv_y) ->
    lv_x = parseFloat(lv_x)
    lv_y = parseFloat(lv_y)
    lv_screen_point = @shape.to_screen( new SvgPoint(lv_x,lv_y) )

    @_nr_points = @_points.length
    # find existing dot
    lv_element = SVG.get(lv_id)
    if lv_element
      this.remove_point(lv_id)
      lv_element.remove()
      
  match_digits: (digits) ->      
    digits.match( /(\(\d+\.?\d+,\d+\.?\d+\))/g )
      
  match_digit: (digit) ->      
    digit.match( /(\d+\.?\d+),(\d+\.?\d+)/ )

  strip_brackets: (digit) ->
    digit.replace(/\(/,'').replace(/\)/,'')
          
  parse_asy: (lv_asy) ->
    lv_digits = this.match_digits(lv_asy) #points = lv_asy.match(/(\(\d+\.?\d+,\d+\.?\d+\))/g)
    for index in [0..lv_digits.length - 1]
      
      lv_str_point = this.strip_brackets(lv_digits[index])
      lv_str_points = this.match_digit(lv_str_point)
      if lv_str_points.length >= 2
        lv_x = parseFloat(lv_str_points[1])
        lv_y = parseFloat(lv_str_points[2])
        lv_screen_point = @shape.to_screen( new SvgPoint(lv_x,lv_y) )
  
        # send mouse down to SVG element canvas but take offset into account
        lv_offset = this.offset("image")
        lv_event = jQuery.Event( "mousedown", { 
            pageX: lv_screen_point.x + lv_offset.left, 
            pageY: lv_screen_point.y + lv_offset.top
          } 
        )
        $("##{@_canvas_id}").trigger(lv_event)    
    
  create_dot: (lv_x,lv_y) ->
    lv_x = parseFloat(lv_x)
    lv_y = parseFloat(lv_y)
    lv_screen_point = @shape.to_screen( new SvgPoint(lv_x,lv_y) )
    this.horizontal_line(lv_screen_point)
    this.vertical_line(lv_screen_point)

    $("#image_display_mouse_pos").text("(x,y) = (#{lv_x.toFixed(2)},#{lv_y.toFixed(2)})")

    # send mouse down to SVG element canvas but take offset into account
    lv_offset = this.offset("image")
    lv_event = jQuery.Event( "mousedown", { 
        pageX: lv_screen_point.x + lv_offset.left, 
        pageY: lv_screen_point.y + lv_offset.top
      } 
    )
    $("##{@_canvas_id}").trigger(lv_event)    
    
  bind_mousemove_to_canvas:  ->
    @canvas.mousemove (event) =>
      #@_canvas.style('cursor', 'crosshair')
      this.display_mouse_position(event)    

      lv_point = this.mouse_position(event)
      this.horizontal_line(lv_point)
      this.vertical_line(lv_point)            

  horizontal_line: (lv_point) ->
    lv_horz_x1 = 0
    lv_horz_x2 = @_width
    lv_horz_y = lv_point.y #- 5
    
    lv_element = SVG.get('horizontal_line')
    if lv_element
      lv_element.attr({ y1 : lv_point.y, y2: lv_point.y })
      lv_element.attr({stroke: "red", width: 1, opacity: 0.5})
    else
      lv_horizontal_line = @_canvas.line(lv_horz_x1,lv_horz_y,lv_horz_x2,lv_horz_y)
      lv_horizontal_line.attr({id: 'horizontal_line'})
      lv_horizontal_line.stroke({color: "red", width: 2}).opacity(0.5)
    
  vertical_line: (lv_point) ->
    lv_horz_y1 = 0
    lv_horz_y2 = @_height
    lv_horz_x = lv_point.x #- 5
    
    lv_element = SVG.get('vertical_line')
    if lv_element
      lv_element.attr({ x1 : lv_point.x, x2: lv_point.x })
      lv_element.attr({stroke: "red", width: 1, opacity: 0.5})
    else
      lv_horizontal_line = @_canvas.line(lv_horz_x,lv_horz_y1,lv_horz_x,lv_horz_y2)
      lv_horizontal_line.attr({id: 'vertical_line'})
      lv_horizontal_line.stroke({color: "red", width: 2}).opacity(0.5)

  remove_point: (lv_id) ->
    for index in [0..@_points.length - 1]
      if @_points[index].id == lv_id
        @_points.splice(index,1)
        break
        
  adjust_points: (lv_id, lv_point) ->
    for index in [0..@_points.length - 1]
      if @_points[index].id == lv_id
        @_points[index].x = lv_point.x
        @_points[index].y = lv_point.y
    
  remove_dots: ->
    for index in [0..@_dot_id]
      lv_element = SVG.get("dot_#{index}")
      if lv_element
        lv_element.remove()
       
       
    # reset dot_id
    @_dot_id = 0 
      
  remove_line: ->
    lv_element = SVG.get("polyline_1")
    if lv_element 
      lv_element.remove()
  
  remove_curve: ->
    if @_points.length > 2
      for index in [0..200]
        lv_element = SVG.get("curve_#{index}")
        if lv_element
          lv_element.remove()
            
  to_asy: () ->
    @_asy_code
                
  connect_line: ->
    this.remove_line()
    this.remove_curve()
          
    lv_path = this.polyline()
    lv_line = @_canvas.path(lv_path,true).stroke({ width: 3}).fill("none")
    lv_line.attr({id: 'polyline_1'})
            
  connect_curve: ->
    this.remove_line()
    this.remove_curve()

    if @_points.length > 2
      this.polycurve()

  polycurve: ->
    lv_path = ""
    lv_len  = @_points.length
    # grab (x,y) coordinates of the control points
    x = []
    y = []
    
    for lv_point, index in @_points
      x[index] = @_points[index].x
      y[index] = @_points[index].y
  
    # computes control points p1 and p2 for x and y direction
    px = @computeControlPoints(x)
    py = @computeControlPoints(y)
  
    # updates path settings, the browser will draw the new spline
    @_asy_code = ""

    for index in [0..lv_len - 2] 
      lv_path     = this.curve(x[index],y[index],px.p1[index],py.p1[index],px.p2[index],py.p2[index],x[index+1],y[index+1]);
      @_asy_code += this.asy_curve(x[index],y[index],px.p1[index],py.p1[index],px.p2[index],py.p2[index],x[index+1],y[index+1])
      lv_curve    = @_canvas.path(lv_path,true).fill("none").stroke({color: "black", width: 3 })
      lv_curve.attr({id: "curve_#{index}"})

    lv_xy = @shape.to_xy(@_points[lv_len-1])
    @_asy_code += "..(#{lv_xy.x.toFixed(2)}, #{lv_xy.y.toFixed(2)})"

  polyline: ->
    lv_path = ""
    @_asy_code = ""
    for lv_point, index in @_points
      if index == 0
        lv_path = "M#{lv_point.x},#{lv_point.y} "
        lv_xy = @shape.to_xy(lv_point)
        @_asy_code = "(#{lv_xy.x.toFixed(2)}, #{lv_xy.y.toFixed(2)})"
      else
        lv_path += "L#{lv_point.x},#{lv_point.y}"
        lv_xy = @shape.to_xy(lv_point)
        @_asy_code += "--(#{lv_xy.x.toFixed(2)}, #{lv_xy.y.toFixed(2)})"

    lv_path

  asy_curve: (x1,y1,px1,py1,px2,py2,x2,y2) ->
    lv_xy1 = @shape.to_xy( {x: x1,y: y1})
    lv_p1  = @shape.to_xy( {x: px1,y: py1})
    lv_p2  = @shape.to_xy( {x: px2,y: py2})
    lv_xy2 = @shape.to_xy( {x: x2,y: y2})
    
    if @_mode == "curve"
      #  "(#{lv_xy1.x.toFixed(2)}, #{lv_xy1.y.toFixed(2)})..controls (#{lv_p1.x.toFixed(2)},#{lv_p1.y.toFixed(2)}) and (#{lv_p2.x.toFixed(2)},#{lv_p2.y.toFixed(2)})..(#{lv_xy2.x.toFixed(2)},#{lv_xy2.y.toFixed(2)}).."
      "(#{lv_xy1.x.toFixed(2)}, #{lv_xy1.y.toFixed(2)})..controls (#{lv_p1.x.toFixed(2)},#{lv_p1.y.toFixed(2)}) and (#{lv_p2.x.toFixed(2)},#{lv_p2.y.toFixed(2)}).."    
    else if @_mode == "curve_no_cp"
      #  "(#{lv_xy1.x.toFixed(2)}, #{lv_xy1.y.toFixed(2)})..(#{lv_xy2.x.toFixed(2)},#{lv_xy2.y.toFixed(2)}).."
      "(#{lv_xy1.x.toFixed(2)}, #{lv_xy1.y.toFixed(2)}).."    
      
  curve: (x1,y1,px1,py1,px2,py2,x2,y2) ->
    "M#{x1},#{y1} C #{px1},#{py1} #{px2},#{py2} #{x2},#{y2}"

  computeControlPoints: (K) ->
    p1 = []
    p2 = []
    n  = K.length-1
    
    # rhs vector
    a = []
    b = []
    c = []
    r = []
    
    # left most segment
    a[0]=0
    b[0]=2
    c[0]=1
    r[0] = K[0]+2*K[1]
    
    # internal segments 
    for i in [1..n-1]
      a[i]=1
      b[i]=4
      c[i]=1
      r[i] = 4 * K[i] + 2 * K[i+1]
        
    # right segment
    a[n-1]=2
    b[n-1]=7
    c[n-1]=0
    r[n-1] = 8*K[n-1]+K[n]
    
    # solves Ax=b with the Thomas algorithm (from Wikipedia) 
    for i in [1..n-1]
      m = a[i]/b[i-1]
      b[i] = b[i] - m * c[i - 1]
      r[i] = r[i] - m*r[i-1]
   
    p1[n-1] = r[n-1]/b[n-1]
    for i in [n-2..0] 
      p1[i] = (r[i] - c[i] * p1[i+1]) / b[i]
      
    # we have p1, now compute p2
    for i in [0..n-2] 
      p2[i] = 2*K[i+1]-p1[i+1]
    
    p2[n-1] = 0.5*(K[n]+p1[n-1])
    
    {p1:p1, p2:p2}
