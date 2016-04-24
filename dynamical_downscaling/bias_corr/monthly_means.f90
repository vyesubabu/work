PROGRAM monthly_means

! File: monthly_means
! Description: Computes monthly means for a given set of input files
! Input: List of WPS intermediate files
! Output: Monthly means
! Dan Steinhoff
! 10 May 2014
! Updated Feb 2015 - Cindy Bruyere


  USE module_basic
  IMPLICIT NONE

  ! Variable Declarations
  INTEGER :: istatus, rstatus, ostatus, rstat
  INTEGER, ALLOCATABLE, DIMENSION(:) :: file_handles
  CHARACTER(len=250) :: infile
  INTEGER :: nfiles
  INTEGER :: file_handle
  INTEGER :: i, iyy, imm
  CHARACTER(len=24) :: hdate
  REAL :: xfcst
  REAL :: xlvl
  CHARACTER(len=8) :: startloc
  REAL :: startlat
  REAL :: startlon
  REAL :: deltalat
  REAL :: deltalon
  REAL :: earth_radius
  REAL :: truelat1
  REAL :: truelat2
  REAL :: xlonc
  CHARACTER(len=32) :: map_source
  CHARACTER(len=9) :: field
  CHARACTER(len=25) :: units
  CHARACTER(len=46) :: desc
  INTEGER :: iproj
  INTEGER :: version
  INTEGER :: nnx, nny
  LOGICAL :: is_wind_grid_rel
  CHARACTER(len=250) :: outfile
  INTEGER :: funit, ios
  LOGICAL :: is_used

  REAL, ALLOCATABLE, DIMENSION(:,:)  :: slab
  REAL, ALLOCATABLE, DIMENSION(:,:)  :: avg_slab

  CHARACTER (LEN=250) :: in_path, path_filename
  CHARACTER (LEN=250) :: out_path
  CHARACTER (LEN=250) :: input_name
  CHARACTER (LEN=250) :: output_name

  CHARACTER (LEN=250) :: command
  INTEGER :: loslen
  INTEGER :: start_year, end_year
  INTEGER :: start_month, end_month
  REAL :: test_missing


  NAMELIST /mean/ in_path, input_name, &
                  out_path, output_name, &
                  start_year, end_year, &
                  start_month, end_month

  in_path= './'
  input_name= 'dummy'
  out_path= './'
  output_name= "dummy_6"
  start_month= 1
  end_month= 12
  start_year= 9999
  end_year= 9999

 ! Read parameters from Fortran namelist
  DO funit=10,100
    INQUIRE(unit=funit, opened=is_used)
    IF (.not. is_used) EXIT
  END DO
  OPEN(funit,file='namelist.input',status='old',form='formatted',&
       iostat=ios)
  IF ( ios /= 0 ) STOP "ERROR opening namelits.input"
  READ(funit,mean)
  CLOSE(funit)


  ! Read the dimensions and allocate the slab arrays
  WRITE(infile, '(A,"/",i4,"/",A,":",i4,"-",i2.2,"-01_00")' ) &
        TRIM(in_path), start_year, TRIM(input_name), &
        start_year, start_month
  OPEN (UNIT=200, FILE=TRIM(infile), STATUS='OLD', &
        FORM='UNFORMATTED', IOSTAT=rstat)
  READ (UNIT=200,IOSTAT=istatus) version
  READ (UNIT=200,IOSTAT=istatus) hdate, xfcst, map_source, &
       field, units, desc, xlvl, NX, NY, iproj
  CLOSE(200)
  ALLOCATE (slab(NX,NY))
  ALLOCATE (avg_slab(NX,NY))


  WRITE(command, '("/bin/mkdir -p ",A)') TRIM(out_path)
  CALL SYSTEM( TRIM ( command ) )

  DO imm=start_month,end_month
    WRITE(*,'("Create Averages for years ",i4, " to ", i4, " for month ", i2)' ) &
               start_year, end_year, imm

    !  Build a UNIX command, and "ls", of all of the files mnatching the "root*" prefix.
    CALL SYSTEM ( '/bin/rm -f .foo'  )
    CALL SYSTEM ( '/bin/rm -f .foo1' )
    DO iyy = start_year,end_year
  
      loslen = LEN ( command )
      CALL all_spaces ( command , loslen )
      WRITE( path_filename, '(A,"/",i4,"/",A,":",i4,"-",i2.2)' )  &
            TRIM(in_path), iyy, TRIM(input_name), iyy, imm
      WRITE ( command ,FMT='("ls -1 ",A,"* >> .foo")' ) &
            TRIM ( path_filename )
    
      CALL SYSTEM ( TRIM ( command ) )
    END DO
    CALL SYSTEM ( '( cat .foo | wc -l > .foo1 )' )
  
    !  Read the number of files.
    OPEN (FILE = '.foo1', UNIT = 112, STATUS = 'OLD', &
          ACCESS = 'SEQUENTIAL', FORM = 'FORMATTED' )
    READ ( 112 , * ) nfiles
    CLOSE ( 112 )
    ALLOCATE (file_handles(nfiles))
  
    WRITE( outfile, '(A,"/",A,":yyyy-",i2.2,"-01_00")' )  &
          TRIM(out_path), TRIM(output_name), imm
    
    file_handle = 1000
    
    ! Read input file list
    WRITE(*,*) 'Read input file list'
    OPEN (UNIT=100, FILE='.foo', STATUS='OLD', ACTION='READ', &
          IOSTAT=istatus)
    
    ! Loop through the input files
    WRITE(*,*) 'Loop through input files'
    fileopen1: IF (istatus == 0) THEN
      DO i = 1, nfiles
        ! Read the file name
        READ (100,110,IOSTAT=rstatus) infile
        110 FORMAT (A100)
  
        ! Open the input file
        OPEN (UNIT=file_handle, FILE=TRIM(infile), STATUS='OLD', &
              FORM='UNFORMATTED', IOSTAT=ostatus)
        fileopen2: IF (ostatus == 0) THEN
          ! Record the file handle
          file_handles(i) = file_handle
          file_handle = file_handle + 1
        ELSE fileopen2
          WRITE (*,120) ostatus
          120 FORMAT (1X, 'Input file open failed: ', I6)
        END IF fileopen2
      END DO
      
    ELSE fileopen1
      WRITE (*,130) istatus
      130 FORMAT (1X, 'File list open failed: ', I6)
    END IF fileopen1
    
    CLOSE (UNIT=100)
    
    ! Open output file
    WRITE(*,*) 'Open output file'
    OPEN (UNIT=200, FILE=TRIM(outfile), STATUS='REPLACE', &
          ACTION='WRITE', FORM='UNFORMATTED', CONVERT='BIG_ENDIAN')
    
    ! Read the input data one slab at a time
    WRITE(*,*) 'Read input data'
    istatus = 0
    DO WHILE (istatus == 0)
      DO i = 1, nfiles
        CALL read_input (file_handles(i), version, hdate, xfcst, &
             map_source, field, units, desc, xlvl, nnx, nny, iproj, &
             startloc, startlat, startlon, deltalat, deltalon, &
             truelat1, truelat2, xlonc, earth_radius, is_wind_grid_rel, &
             slab, istatus)
        test_missing = minval(slab)
        IF (istatus == 0) THEN
          IF (i == 1) THEN
            avg_slab = slab/1000.
          ELSE
            avg_slab = avg_slab + (slab/1000.)
          END IF
          IF ( test_missing .LT. -1E20 ) THEN
            WHERE ( slab .EQ. test_missing ) ! In case we're averaging missing values
              avg_slab = test_missing
            END WHERE
          END IF  
        END IF
      END DO
      IF (istatus == 0) THEN
        avg_slab = (avg_slab / REAL(nfiles)) * 1000.
        IF ( test_missing .LT. -1E20 ) THEN
          WHERE ( slab .EQ. test_missing ) ! In case we're averaging missing values
            avg_slab = test_missing
          END WHERE
        END IF  
        IF ( TRIM(field) .EQ. "LANDSEA") THEN
          WHERE ( avg_slab .GT. 1.0 ) 
            avg_slab = 1.0
          END WHERE
        END IF
        CALL write_output (200, version, hdate, xfcst, map_source, &
             field, units, desc, xlvl, nnx, nny, iproj, startloc, &
             startlat, startlon, deltalat, deltalon, truelat1, &
             truelat2, xlonc, earth_radius, is_wind_grid_rel, &
             avg_slab, istatus)
      END IF
    END DO
  
    ! Close input files
    DO i = 1, nfiles
      CLOSE (UNIT=file_handles(i))
    END DO
  
    ! Close output file
    CLOSE (UNIT=200)
    
    DEALLOCATE (file_handles)
    CALL SYSTEM ( '/bin/rm -f .foo'  )
    CALL SYSTEM ( '/bin/rm -f .foo1' )

  END DO
  
END PROGRAM monthly_means
