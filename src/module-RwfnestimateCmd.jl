"""
`module  JuliaGrasp.RwfnestimateCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RwfnestimateCmd .
"""
module RwfnestimateCmd

    using ..Basics, FieldDefaults, ..DefaultModule

    export Execute, Rwfnestimate

    abstract type AbstractRwfnestimate  end
            
    """
    `struct Rwfnestimate <: AbstractRwfnestimate`                     ... defines a type for Rmcdhf.
    + default                       ::DefaultModule.Default                          ... working directory path
    + radial_wavefunctions          ::String                          ... Enter subshell radial wavefunctions. Choose one below
                                                                            1 -- GRASP2K File
                                                                            2 -- Thomas-Fermi
                                                                            3 -- Screened Hydrogenic
    + relativistic_subshells        ::String                          ... Enter the list of relativistic subshells
    """
    @default_kw mutable struct  Rwfnestimate <: AbstractRwfnestimate
        default                       ::DefaultModule.Default
        radial_wavefunctions          ::Int64|2
        relativistic_subshells        ::String|"*"
    end
    
    function Base.show(io::IO, rwfnestimate::Rwfnestimate)
        radial_wavefunctions   = rwfnestimate.radial_wavefunctions
        relativistic_subshells = rwfnestimate.relativistic_subshells
        state = getRSaveFileName(rwfnestimate);
        println(io, "\t state name     (state)  :\t"*state*"\n")
        println(io, "\t radial_wavefunctions    :\t"*string(radial_wavefunctions)*"\n")
        println(io, "\t relativistic_subshells  :\t"*relativistic_subshells*"\n")
        if radial_wavefunctions == 1                
            println("\t GRASP2K File name       :\t"*state*"\n");
        end
    end


    function getRSaveFileName(m::Rwfnestimate)
        rsavefilename=""
        filepath = joinpath(m.default.state_folder, "rsavename.txt")
        if isfile(filepath)
            lines= Basics.ReadFileLines(filepath)
            rsavefilename= lines[1]
        else
            error("file rsavename.txt not found")
        end

        println("rsavefilename: $rsavefilename")
        return rsavefilename
    end

    function WriteRwfnestimateInputFile(rwfnestimate::Rwfnestimate) 
        state_folder=rwfnestimate.default.state_folder
        in_folder=rwfnestimate.default.in_folder
        rwfnestimate_file= joinpath(in_folder, "rwfnestimate.inp")
        radial_wavefunctions   = rwfnestimate.radial_wavefunctions
        relativistic_subshells = rwfnestimate.relativistic_subshells
        state = getRSaveFileName(rwfnestimate);
        open(rwfnestimate_file, "w") do io
            println(io, "y");
            println(io, radial_wavefunctions);
            if radial_wavefunctions == 1                
                println(io, state*".w");
                println(io, relativistic_subshells);             
                println(io, "2");
            end
            println(io, relativistic_subshells);
        end
        Base.cd(state_folder)
    end


    function Basics.Execute(rwfnestimate::Rwfnestimate)
        state_folder = rwfnestimate.default.state_folder
        Base.cd(state_folder)
        radial_wavefunctions   = rwfnestimate.radial_wavefunctions
        relativistic_subshells = rwfnestimate.relativistic_subshells
        state = getRSaveFileName(rwfnestimate);
        open(`rwfnestimate`, "w", Base.stdout) do io
            println(io, "y");
            println(io, radial_wavefunctions);
            if radial_wavefunctions == 1                
                println(io, state*".w");
                println(io, relativistic_subshells);             
                println(io, "2");
            end
            println(io, relativistic_subshells);
        end

        WriteRwfnestimateInputFile(rwfnestimate)
        println("================================= Rwfnestimate Calc Finished ======================================")
    end
end