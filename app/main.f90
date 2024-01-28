program main
  use nml4types

  implicit none

  type data
     integer :: i = 0
     real :: r = 0.0
     character(len = 10) :: s = ""
  end type data
  
  type(data) :: d
  character(:), allocatable :: input_file
  
  input_file = "example_input.nml"
  
  call read_from_input(d, input_file)
  
  print*, "Read the following from the input file:"
  print*, "i = ", d%i
  print*, "r = ", d%r
  print*, "s = ", d%s
  
contains

  subroutine read_from_input(this, parent_nml_file)
    type(data), intent(inout) :: this
    character(*), intent(in) :: parent_nml_file

    integer :: ifile
    character(:), allocatable :: group_nml_file

    namelist /params/ this
    
    call get_group_nml_file(group = 'params', obj = 'this', &
         parent_nml_file = parent_nml_file, &
         child_nml_file = group_nml_file)

    open(newunit = ifile, file = group_nml_file, &
         status = 'old', action = 'read')
    read(ifile, nml = params)
    close(ifile)
  end subroutine read_from_input  
end program main
