module nml4types
  implicit none

  public get_group_nml_file
  
contains
  
  subroutine get_group_nml_file(group, obj, &
       parent_nml_file, &
       child_nml_file)
    character(*), intent(in) :: group, obj, parent_nml_file
    character(:), allocatable, intent(out) ::  child_nml_file
    
    character(:), allocatable :: awk_command

    child_nml_file = trim(adjustl(group)) // ".nml"

    !Use awk/sed magic to create a child input file
    !which takes the following:
    !
    !<parent_nml_file>:
    !&group
    !   i = 1
    ! <some spaces>
    !r = -99.99 !inline comment
    !!Body comment.
    !!! Another body comment.
    !    s = 'jklolz'
    !/ or &end or $end
    !
    !to
    !
    !<child_nml_file>:
    !&<group>
    !<obj>%i = 1
    !<some spaces>
    !<obj>%r = -99.99 !inline comment
    !<obj>%s = 'jklolz'
    !/
    
    !Copy specified group data from parent to child:
    awk_command = "awk 'tolower($0) ~ /^&" // &
         trim(adjustl(group)) // "$/{flag=1;next} " &
         //"tolower($0) ~ /^(\/|&end|\$end)$/{flag=0}flag' " // &
         parent_nml_file // " > " // child_nml_file
    call system(awk_command)

    !Remove trailing white space(s)
    call system("sed -i 's/^[ \t]*//' " // child_nml_file)

    !Remove lines that start with a !
    call system("sed -i '/^\!/d' " // child_nml_file)
    
    !Rename the members on non-empty lines:
    call system("sed -i '/\S/s/^/"//obj//"%/' " // child_nml_file)

    !Prepend the generic heading:
    call system("sed -i '1s;^;\&params\n;' " // child_nml_file)

    !Append the ending
    call system("echo '/' >> " // child_nml_file)
  end subroutine get_group_nml_file
end module nml4types
