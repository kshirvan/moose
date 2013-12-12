# unsaturated = true
# gravity = false
# supg = false
# transient = false

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
  xmin = -10
  xmax = 10
  ymin = -10
  ymax = 10
  zmin = -10
  zmax = 10
[]

[UserObjects]
  [./DensityConstBulk]
    type = RichardsDensityConstBulk
    dens0 = 1000
    bulk_mod = 2.0 # notice small quantity, so PETSc's "constant state" works
  [../]
  [./SeffVG]
    type = RichardsSeff1VG
    m = 0.8
    al = 1 # same deal with PETSc's "constant state"
  [../]
  [./RelPermPower]
    type = RichardsRelPermPower
    simm = 0.2
    n = 2
  [../]
  [./Saturation]
    type = RichardsSat
    s_res = 0.1
    sum_s_res = 0.1
  [../]
  [./SUPGnone]
    type = RichardsSUPGnone
  [../]
[]

[Variables]
  [./pressure]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = RandomIC
      block = 0
      min = -1
      max = 0
    [../]
  [../]
[]
    
  
[Kernels]
  active = 'richardsf'
  [./richardst]
    type = RichardsMassChange
    variable = pressure
  [../]
  [./richardsf]
    type = RichardsFlux
    variable = pressure
  [../]
[]

[Materials]
  [./rock]
    type = RichardsMaterial
    block = 0
    mat_porosity = 0.1
    mat_permeability = '1E-5 0 0  0 1E-5 0  0 0 1E-5'
    pressure_vars = pressure
    density_UO = DensityConstBulk
    relperm_UO = RelPermPower
    SUPG_UO = SUPGnone
    sat_UO = Saturation
    seff_UO = SeffVG
    viscosity = 1E-3
    gravity = '0 0 0'
    linear_shape_fcns = true
  [../]
[]


[Preconditioning]
  [./andy]
    type = SMP
    full = true
    #petsc_options = '-snes_test_display'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -snes_type'
    petsc_options_value = 'bcgs bjacobi 1E-15 1E-10 10000 test'
  [../]
[]

[Executioner]
  type = Steady
  solve_type = Newton
[]

[Output]
  file_base = jn02
  output_initial = false
  exodus = false
  perf_log = false
  linear_residuals = false
[]
