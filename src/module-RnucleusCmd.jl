"""
`module  JuliaGrasp.RnucleusCmd`  
    ... a submodel of JuliaGRASP that use to run GRASP commands: RnucleusCmd .
"""
module RnucleusCmd

    using ..Basics, Pipelines, FieldDefaults, ..DefaultModule

    export Rnucleus, Execute

    abstract type AbstractRNucleus  end

    """
    `struct Rnucleus <: Nucleus`                        ... defines a type for Rnucleus.
        + default     ::DefaultModule.Default           ... working directory path
        + Z           ::Int64                           ... Atomic Number.
        + A           ::Int64                           ... Mass Number.
        + neutralMass ::Float64 | 0                     ... The mass of the neutral atom (in amu).
        + I           ::Int64   | 0                     ... The nuclear spin quantum number (in units of h / 2 pi).
        + NDM         ::Int64   | 0                     ... The nuclear dipole moment (in nuclear magnetons).
        + NQM         ::Int64   | 0                     ... The nuclear quadrupole moment (in barns).
        + rms_radius  ::Float64 |2.4292473557159475     ... The root mean squared radius.
        + thickness   ::Float64 |2.2999999999999998     ... The nuclear skin thickness.
    """
    @default_kw mutable struct Rnucleus <: AbstractRNucleus
        default              ::DefaultModule.Default
        Z                    ::Int64
        A                    ::Int64
        revise               ::String|"n"
        neutralMass          ::Float64|0
        I                    ::Int64|0
        NDM                  ::Int64|0  
        NQM                  ::Int64|0  
        # rms_radius  ::Float64  |2.4292473557159475
        # thickness   ::Float64  |2.2999999999999998
    end

    function Base.join(rnucleus::Rnucleus)
        T = typeof(rnucleus)
        structfields = fieldnames(T)[2:end]
        inputStrings =""
        for name in structfields
            val= getproperty(rnucleus,name)
            inputStrings = string(inputStrings, string(val), " \n")
        end
        return inputStrings
    end
    
    function Base.getproperty(m::Rnucleus, s::String)
        Base.getproperty(m, Symbol(s))        
    end
    


    function Base.show(io::IO, rnucleus::Rnucleus)
        state_folder        = rnucleus.default.state_folder
        state               = rnucleus.default.state
        Z                   = rnucleus.Z
        A                   = rnucleus.A
        I                   = rnucleus.I
        neutralMass         = rnucleus.neutralMass
        NDM                 = rnucleus.NDM
        NQM                 = rnucleus.NQM
        # rms_radius          = getproperty(rnucleus,"rms_radius")
        # thickness           = getproperty(rnucleus,"thickness")
        println(io, "\tworking directory                                  (state_folder):\t"*state_folder*"\n")
        println(io, "\tstate                                                     (state):\t"*state*"\n")
        println(io, "\tAtomic Number                                               (Z)  :\t"*string(Z)*"\n")
        println(io, "\tMass Number                                                 (A)  :\t"*string(A)*"\n")
        println(io, "\tThe mass of the neutral atom (in amu)             (neutralMass)  :\t"*string(neutralMass)*"\n")
        println(io, "\tThe nuclear spin quantum number (in units of h / 2 pi)      (I)  :\t"*string(I)*"\n")
        println(io, "\tThe nuclear dipole moment (in nuclear magnetons)          (NDM)  :\t"*string(NDM)*"\n")
        println(io, "\tThe nuclear quadrupole moment (in barns)                  (NQM)  :\t"*string(NQM)*"\n")
        # println(io, "The root mean squared radius default=2.4292473557159475    : "*string(rms_radius)*"\n")
        # println(io, "The nuclear skin thickness default=2.2999999999999998      : "*string(thickness)*"\n")
    end


    function Basics.Execute(rnucleus::Rnucleus)
        state_folder = rnucleus.default.state_folder
        T = typeof(rnucleus)
        structFields = fieldnames(T)[3:end]
        Base.cd(state_folder)
        open(`rnucleus`, "w", Base.stdout) do io
            for name in structFields
                val= getproperty(rnucleus,name)
                println(io, val)
            end
        end
        println("================================= Rnucleus Calc Finished ======================================\n\n")
    
    end
end