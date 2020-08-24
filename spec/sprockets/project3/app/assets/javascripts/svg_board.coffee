class @SvgBoard
  constructor: (element) ->
    @points = []
    @curves = []
    @board = JXG.JSXGraph.initBoard(element, {boundingbox:[-5,5,5,-5], axis:false, grid:true, showCopyright:false})

    lv_origin = @board.create('point',[0,0], {face:'o', size:1}, name: '')
    lv_origin.setProperty({fixed:true})

    # add click event to board
    @board.on 'down', @add_point

  curve_catmull: () ->
    if @tau
      @board.removeObject(@tau)

    if @curve
      @board.removeObject(@curve)

    this.curves = []
    @curve = @board.create('curve', JXG.Math.Numerics.CatmullRomSpline(@points), 
               {strokecolor:'blue', strokeOpacity:0.6, strokeWidth:5}) 
    this.curves.push(@curve)


  curve_bspline: () ->
    if @tau
      @board.removeObject(@tau)

    if @curve
      @board.removeObject(@curve)

    this.curves = []
    #@tau = @board.create('slider', [[0,4],[4,4],[3,0.5,5]], {name:'tau'});
    @curve = @board.create('curve', JXG.Math.Numerics.bspline(@points, 4), 
               {strokecolor:'blue', strokeOpacity:0.6, strokeWidth:5}) 
    this.curves.push(@curve)

  connect_points: () ->
    for i in [0..@points.length - 1]
      line = @board.create('line', [@points[i],@points[i+1]], {straightFirst:false, straightLast:false, strokeColor:'red',strokeWidth:1})
  
  curve_cardinal: () ->
    @board.removeObject(this.curves[0])

    if @curve
      @board.removeObject(@curve)

    this.curves = []
    @tau = @board.create('slider', [[0,4],[4,4],[0.001,0.5,1]], {name:'tau'});
    @curve = @board.create('curve', JXG.Math.Numerics.CardinalSpline(@points, () => return @tau.Value() ),
               {strokecolor:'blue', strokeOpacity:0.6, strokeWidth:5}) 
    this.curves.push(@curve)

  get_coordinates: (event) =>

    if event[JXG.touchProperty]
      # index of the finger that is used to extract the coordinates
      i = 0

    lv_pos     = this.board.getCoordsTopLeftCorner(event, 0)
    lv_abs_pos = JXG.getPosition(event, 0)
    lv_dx      = lv_abs_pos[0]-lv_pos[0]
    lv_dy      = lv_abs_pos[1]-lv_pos[1]
    lv_coords  = new JXG.Coords(JXG.COORDS_BY_SCREEN, [lv_dx, lv_dy], this.board)
    return lv_coords

  add_point: (event) =>
    canCreate = true

    lv_coords = this.get_coordinates(event)

    for key, el of this.board.objects
      if (JXG.isPoint(this.board.objects[key]) && this.board.objects[key].hasPoint(lv_coords.scrCoords[1], lv_coords.scrCoords[2]) )  
        canCreate = false
        break
 
    if canCreate 
      lv_point  = this.board.create('point', [lv_coords.usrCoords[1], lv_coords.usrCoords[2]]);
      lv_point.on 'over', this.mouseoverpoint
      #lv_point.on 'move', this.mousemovepoint

      this.points.push(lv_point)

  mouseoverpoint: (event) ->
    $("#element_name").val(this.name)
    $("#pos_x").val(this.coords.usrCoords[1].toFixed(2))
    $("#pos_y").val(this.coords.usrCoords[2].toFixed(2))

  mousemovepoint: (event) ->
    $("#element_name").val(this.name)
    $("#pos_x").val(this.coords.usrCoords[1].toFixed(2))
    $("#pos_y").val(this.coords.usrCoords[2].toFixed(2))

  delete_point: (name) ->
    i = 0
    for point in this.points
      if point.name == name
        this.board.removeObject(point)
        this.points.splice(i,1)
        break

      i = i + 1

    this.board.update()

  update_point: (name,x,y) ->
    for point in this.points
      if point.name == name
        #point.setProperty({coords: [parseFloat(x),parseFloat(y)]})
        point.setPosition(JXG.COORDS_BY_USER,[parseFloat(x),parseFloat(y)])
        break

    this.board.update()

  create_point: (x,y) ->
    lv_point  = this.board.create('point', [parseFloat(x),parseFloat(y)]);
    lv_point.setProperty({fixed:false})

    lv_point.on 'over', this.mouseoverpoint
    this.points.push(lv_point)
    this.board.update()


  clear_curve: ->
    $("#element_id").val("")

    for point in this.points
      this.board.removeObject(point)

    for curve in this.curves
      this.board.removeObject(curve)

    this.curves = []
    this.points = []

  clear_image: ->
    if @image
      this.board.removeObject(@image)

  remove: (element) ->
    this.board.removeObject(element)

  add_image: (url) ->

    if @image
      this.board.removeObject(@image)
    
    @image = @board.create('image',[url, [-5,-5], [10,10] ], id: 'board')

  to_asy: () ->
    lv_str = ""
    for point in this.points

      lv_x = point.coords.usrCoords[1]
      lv_y = point.coords.usrCoords[2]
      lv_str = lv_str + "..(#{lv_x.toFixed(2)},#{lv_y.toFixed(2)})"
    return(lv_str)

  match_digits: (digits) ->      
    digits.match( /(\([-+]?\d+\.?\d+,[-+]?\d+\.?\d+\))/g )
      
  match_digit: (digit) ->      
    digit.match( /([-+]?\d+\.?\d+),([-+]?\d+\.?\d+)/ )

  strip_brackets: (digit) ->
    digit.replace(/\(/,'').replace(/\)/,'')
          
  parse_asy: (lv_asy) ->
    lv_digits = this.match_digits(lv_asy) 
    if lv_digits.length > 0
      this.clear_curve()

      for index in [0..lv_digits.length - 1]
        
        lv_str_point = this.strip_brackets(lv_digits[index])
        lv_str_points = this.match_digit(lv_str_point)

        if lv_str_points.length >= 2
          lv_x = parseFloat(lv_str_points[1])
          lv_y = parseFloat(lv_str_points[2])
          lv_point  = this.board.create('point', [lv_x,lv_y]);
          lv_point.on 'over', this.mouseoverpoint
          this.points.push(lv_point)
    
