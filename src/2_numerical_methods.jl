# Parameters
begin 
    s_range             = (range(start = 0.00, stop = 3.00, length = 30))
    consumption_range   = (range(start = 0.00, stop = 3.00, length = 30))
    labor_range         = (range(start = 0.00, stop = 3.00, length = 30))
    ρ                   = 1.50
    φ                   = 2.00
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
end

include("2_pure_numerical.jl")