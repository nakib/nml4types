program main
  use nml_reader

  implicit none

  type data
     integer :: i = 0
     real :: r = 0.0
     character(len = 10) :: s = ""
  end type data
  
  type(data) :: d

  call read_from_input(d)


  print*, "Read the following from the input file:"
  print*, "i = ", d%i
  print*, "r = ", d%r
  print*, "s = ", d%s

contains

  subroutine read_from_input(this)
    type(data), intent(inout) :: this

    integer :: ifile
    character(:), allocatable :: group_nml_file

    namelist /params/ this
    
    call get_group_nml_file(group = 'params', obj = 'this', &
         parent_nml_file = 'input.nml', child_nml_file = group_nml_file)

    print*, group_nml_file

    open(newunit = ifile, file = group_nml_file, &
         status = 'old', action = 'read')
    read(ifile, nml = params)
    close(ifile)
  end subroutine read_from_input  
end program main
