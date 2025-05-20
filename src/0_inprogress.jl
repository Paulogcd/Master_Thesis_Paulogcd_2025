
# Does not work yet. 
# function plot_survival_3D()
#     
#     Plots.plotly()
#     temperature_range = range(start = 0.01, stop = 4.00, length = 100)
#     age_range = 1:100
# 
#     # age_grid = repeat(age_range', length(temperature_range), 1)
# 	# temp_grid = repeat(temperature_range, 1, length(age_range))
# 
#     # health_levels = [1, 2, 3, 4, 5]  
# 	health_labels = ["Excellent", "VeryGood", "Good", "Fair", "Poor"]
# 
#     p = Plots.plot()
#     for (h,label) in zip(1:5,health_labels)
# 	    pred_grid = [GLM.predict(REG3, 
# 	                  DataFrame(Age=a,
# 								Health = OrdinalMultinomialModels.predict(REG2, DataFrame(Health_1 = h, Age = a, Temperature = t, HP_predicted = HP(Age = a, Temperature = t))),
#                                 HP_predicted = HP(Age = a, Temperature = t), 
# 								Temperature=t))[1]
# 	                  for t in temperature_range, a in age_range]
# 	    
# 	    # Add surface plot
# 	    surface!(p, age_range, temp_range, pred_grid, label = label)
# 	end
# 	Plots.plot!(
# 
# 		fontfamily = "Times",
#     )
#     display(p)
# end
# 
# plot_survival_3D()
