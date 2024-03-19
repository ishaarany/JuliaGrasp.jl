"""
`module JuliaGRASP`  
    ... Module to manipulate GRASP2018 commands.
"""

module JuliaGrasp

using  Dates, Printf,  LinearAlgebra, IJulia

export  DefaultModule, Basics, RnucleusCmd, RcsfgenerateCmd, RangularCmd, 
        RcsfinteractCmd, RwfnestimateCmd, RmcdhfCmd, RciCmd, RsaveCmd, RcsfzerofirstCmd,
        Jj2lsjCmd, RlevelsCmd, CalcCmd

# Basic data and data structures
include("module-Basics.jl");                using ..Basics
include("module-DefaultModule.jl");         using ..DefaultModule
include("module-RnucleusCmd.jl");           using ..RnucleusCmd
include("module-RcsfgenerateCmd.jl");       using ..RcsfgenerateCmd
include("module-RangularCmd.jl");           using ..RangularCmd
include("module-RcsfzerofirstCmd.jl");      using ..RcsfzerofirstCmd
include("module-RcsfinteractCmd.jl");       using ..RcsfinteractCmd
include("module-RwfnestimateCmd.jl");       using ..RwfnestimateCmd
include("module-RmcdhfCmd.jl");             using ..RmcdhfCmd
include("module-RciCmd.jl");                using ..RciCmd
include("module-RsaveCmd.jl");              using ..RsaveCmd
include("module-Jj2lsjCmd.jl");             using ..Jj2lsjCmd
include("module-RlevelsCmd.jl");            using ..RlevelsCmd
include("module-CalcCmd.jl");               using ..CalcCmd


function __init__()
    # The following variables need to be initialized at runtime to enable precompilation
    global JuliaGRASP_SUMMARY_IOSTREAM = stdout
    global JuliaGRASP_TEST_IOSTREAM    = stdout
end


println("\n\tWelcome to JuliaGrasp:  A Julia Modules to perform a robust GRASP2018 calculations " * 
        "\n\t[(C) Copyright by i.shaarany (2024-)].")


end 