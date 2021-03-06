numColumn = (plots, rb, bb, binScale, colScale) ->
	plots.each( (d,i) ->
		xScale = d3.scale.linear()
			.domain(d3.extent(d.mean.concat(0)))
			.range([10,rb-5])

		zero = xScale 0

		xAxis = d3.svg.axis()
			.scale(xScale)
			.orient("bottom")
			.ticks(5)

		g = d3.select(this)
		vals = g.selectAll("g.value").data(d.mean)

		vals.enter().append("g")
			.classed("value", true)
			.attr("id", (_,j) -> "num_#{j}")
			.append("rect")
			.attr("title", (d,i) -> "value = #{d}")
			.attr("width", (d) -> xScale(d) - zero)
			.attr("x", zero)
			.attr("height", bb)
			.attr("y", (_,i) -> binScale(i))
			.attr("fill", (_,i) -> colScale(d.compl[i]))
			.on("mouseenter", highlight)

		ruler = g.append("g")
			.attr("class", "ruler")

		ruler.append("g")
		  .attr("class","x axis")
		  .attr("transform","translate(0,#{binScale.range()[1]})")
		  .call(xAxis)

		yrange = binScale.range()
		rules = ruler.selectAll("line.rule").data(xScale.ticks(5))
		
		rules.enter().append("line")
		  .attr("class", "rule")
		  .attr("x1", xScale)
		  .attr("x2", xScale)
		  .attr("y1", yrange[0])
		  .attr("y2", yrange[1])
		  .attr("stroke", "white")
		  .attr("stroke-opacity", .3)
	  	
	  	ruler.style("display", "none")

		g.on("mouseenter", showScale)
		.on("mouseleave",hideScale)

		g.append("use").attr("id", "top")
		return
	)