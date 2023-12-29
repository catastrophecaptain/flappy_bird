
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name mario -dir "D:/mario/mario/planAhead_run_1" -part xc7k160tffg676-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/mario/mario/top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/mario/mario} {ipcore_dir} }
add_files [list {ipcore_dir/back_rom.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/mario_rom.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/pipe_body_rom.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/pipe_head_rom.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "D:/mario/7k.ucf" [current_fileset -constrset]
add_files [list {D:/mario/7k.ucf}] -fileset [get_property constrset [current_run]]
link_design
