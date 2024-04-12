using Scattering
using Scattering.Graphs
using LinearAlgebra
using Scattering.LuxorGraphPlot: Luxor
using Random

# s = 756080199614591, 3.839080041220371e-15
# s = 356850098191873, 6.635008359660213e-14

s = rand(1:10^15)
Random.seed!(435)
x0 = rand(Float64, 20)
g = andrew_hadamard(x0)
outcome = optimize_weighted_momentum(g, rand(Float64))

waves, gt = simulate_ScatterGraph(outcome.g, 1-outcome.minimizer[1])
animate_wave(gt, waves, step = 100, pathname = "examples/chain.gif") isa Luxor.AnimatedGif


# hadamard gate
gh = andrew_hadamard(ones(20))
waves, gt = simulate_ScatterGraph(gh, -0.5)
animate_wave(gt, waves, step = 100, pathname = "examples/chain.gif") isa Luxor.AnimatedGif


using CairoMakie
function plot_rr_momentum(g::ScatterGraph, save_name::String)
	k = -1+1e-10:0.003:-1e-10
	# k=1e-10:0.003:1-1e-10
	rr = [relection_rate(scatter_matrix(g, exp(im * ki * pi))) for ki in k]
	fig = Figure()
	ax = Axis(fig[1, 1])
	lines!(ax, k, rr)
	save(save_name, fig)
	return fig
end



gms = andrew_momentum_separator()
pathn="examples/"
plot_rr_momentum(outcome.g, joinpath(pathn,"rr_momentum$s.png"))
universal_check(g,exp(pi * im * outcome.minimizer[1]), 2)
