# Parameters
begin 
    granularity = 0.8 # 0.2 # max is 0.8, # 0.2 is too false to be accepted.
	s_range             = (range(start = 0.00, stop = 100.00, length 	= Integer(round(granularity * 100))))
	sprime_range		= (range(start = 0.00, stop = 100.00, length 	= Integer(round(granularity * 100))))
    consumption_range   = (range(start = 0.00, stop = 10.00, length 	= Integer(round(granularity * 100))))
    labor_range         = (range(start = 0.00, stop = 1.50, length 		= Integer(round(granularity * 100))))
    ρ                   = 1.50
    φ                   = 2.00
	r 					= 0.017
end

# Secondary functions: 
begin 
	"""
	The `budget_surplus` function computes the budget states for certain levels of consumption, labor supply, productivity, and savings.

	Its syntax is:
		
		budget_surplus(;c::Float64,
			l::Float64,
			sprime::Float64,
			s::Float64,
			z::Float64,
			r::Float64)::Float64

	"""
	function budget_surplus(;c::Float64,
			l::Float64,
			sprime::Float64,
			s::Float64,
			z::Float64,
			r::Float64)::Float64
		if r == Inf
			return -Inf
		else
			return (l*z + s*(1+r) - c - sprime)::Float64
		end
    end
    
	""" 
	The `ξ` function returns the disutility of work in the utility function.

	Its syntax is: 
		
		ξ(w,h)

	For now, it returns 1.
	
		# (1+abs(w))*(1+1(h=="bad"))
	"""
	function ξ(;w::Float64,h::Float64)::Float64
		return 1.00 # ((1 + abs(w)) * (1+1(h=="bad")))::Float64
	end

	"""
	The `utility` function is defined such that its syntax is:
	
		utility(;c,l,z,w,h,ρ=1.5,φ=2)
	
	It returns:

		(abs(c)^(1-ρ))/(1-ρ) - ξ(w,h) *((abs(l)^(1+φ)/(1+φ)))

	
	"""
	function utility(;c::Float64,
						l::Float64,
						z::Float64,
						w::Float64,
						h::Float64,
						ρ = 1.50::Float64,
						φ = 2.00::Float64)::Float64
		
        return 100 + ( ((abs(c))^(1-ρ)) / (1-ρ) ) - ξ(w=w,h=h) * ( ((abs(l))^(1+φ)) / (1+φ) )::Float64
	end
	nothing
end

using Interpolations

include("2_numerical_methods_1_pure_numerical.jl")
include("2_numerical_methods_1_pure_numerical_interpolated.jl")

include("2_numerical_methods_2_FOC_approximated_1.jl")
include("2_numerical_methods_2_FOC_approximated_1_interpolated.jl")

include("2_numerical_methods_3_FOC_approximated_2.jl")
include("2_numerical_methods_3_FOC_approximated_2_interpolated.jl")

@info("2_numerical_methods_0.jl compiled")