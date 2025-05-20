"""
The `extra_health_survival` function generates an extra plot, of the logistic regression explaining living status with age
and health. 
It is not directly used in my master thesis, but is useful for two reasons. 
First, I confirm that results are similar to articles studying this same relationship. 
Second, it allows to see the link between health state and survival without the effect of temperature.
"""
function extra_health_survival()
    extra_regression_health_survival = load_object("src/data/regressions/extra_health_survival.jld2")    
    age_range = collect(1:100)
    colors = palette(:RdYlGn_10,5)

    Poor        =
		DataFrame(Age = age_range,
				  Health = fill(5,length(age_range)))
	
    Fair        = 
		DataFrame(Age = age_range,
				  Health = fill(4,length(age_range)))
	
    Good        = DataFrame(Age = age_range,
							Health = fill(3,length(age_range)))
	
    VeryGood    = DataFrame(Age = age_range,
							Health = fill(2,length(age_range)))
	
    Excellent   = DataFrame(Age = age_range,
	 						Health = fill(1,length(age_range)))
	 
    pv  = GLM.predict(extra_regression_health_survival,Poor)
    fv  = GLM.predict(extra_regression_health_survival,Fair)
    gv  = GLM.predict(extra_regression_health_survival,Good)
    vgv = GLM.predict(extra_regression_health_survival,VeryGood)
    ev  = GLM.predict(extra_regression_health_survival,Excellent)

    p = Plots.plot(pv, 		label = "Poor", 		 linewidth=5, color = colors[1])
    Plots.plot!(fv, 	label = "Fair", 		linewidth=5, color = colors[2])
    Plots.plot!(gv, 	label = "Good", 		linewidth=5, color = colors[3])
    Plots.plot!(vgv, 	label = "Very good", 	linewidth=5, color = colors[4])
    Plots.plot!(ev, 	label = "Excellent",	linewidth=5, color = colors[5])
    Plots.plot!(xaxis = "Age",
				yaxis = "Probability")
	Plots.plot!(legend = :bottomleft)

	Plots.plot!(
		size = (2400, 1600),
		legendfontsize = 40,
		guidefontsize = 40,
		tickfontsize = 40,

		bottom_margin = 100Plots.px,
		top_margin = 100Plots.px,
		left_margin = 100Plots.px,

		fontfamily = "Times",
    )
    
    if isdir("output")
        Plots.savefig(p, "output/extra_health_survival_plot.png")
    else
        mkdir("output")
        Plots.savefig(p, "output/extra_health_survival_plot.png")
    end
end
