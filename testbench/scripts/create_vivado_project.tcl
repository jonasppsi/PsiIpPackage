# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "./../vivado"

# Set the project name
set _xil_proj_name_ "IpPackageTb"

# Create project
create_project ${_xil_proj_name_} ${origin_dir}/${_xil_proj_name_} -part xc7k70tfbv676-1 -force

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "part" -value "xc7z015clg485-2" -objects $obj

update_compile_order -fileset sources_1
set_property  ip_repo_paths  ${origin_dir}/../ip_repo/ipi [current_project]
update_ip_catalog

# Proc to create BD bd
proc cr_bd_bd {} {

  create_bd_design "bd"
  set parentCell [get_bd_cells /]
  set parentObj [get_bd_cells $parentCell]
  current_bd_instance $parentObj

  # Create instance: psi_ippackage_dummy, and set properties
  set psi_ippackage_dummy [ create_bd_cell -type ip -vlnv psi.ch:IpPackage:IpPackage_2017_2_1_tb IpPackage_2017_2_1_tb ]

  save_bd_design
  close_bd_design "bd" 
}
# End of cr_bd_bd

cr_bd_bd

foreach bd [get_files -filter {FILE_TYPE == "Block Designs" && !IS_GENERATED}] {
    open_bd_design $bd
}