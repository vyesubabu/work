PROGRAM interp_6hr

! File: interp_6hr.f90
! Description: Interpolates monthly means to 6-hourly means
! Input: Monthly means
! Output: 6-hourly means
! Dan Steinhoff
! 12 May 2014
! Updated Feb 2015 - Cindy Bruyere

  USE module_basic
  IMPLICIT NONE


  INTEGER, DIMENSION(6), PARAMETER :: WEIGHTS = (/ 124, 124, 120, 124, 120, 124 /)
  INTEGER, PARAMETER :: NFILES = 736
  INTEGER, PARAMETER :: interval_hours = 6
  CHARACTER(len=250), DIMENSION(6) :: FILES

! Variable Declarations
  INTEGER :: istatus, status1, status2, istatus1, istatus2, rstatus
  INTEGER, DIMENSION(NFILES) :: file_handles
  CHARACTER(len=8), DIMENSION(NFILES) :: outfiles
  CHARACTER(len=250) :: infile
  INTEGER :: file_handle
  INTEGER :: i, j, c
  CHARACTER(len=24) :: hdate
  CHARACTER (LEN=24), DIMENSION(NFILES)  :: hdates
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
  INTEGER :: nnx, nny
  INTEGER :: iproj
  INTEGER :: version
  LOGICAL :: is_wind_grid_rel
  INTEGER :: funit, ios
  LOGICAL :: is_used
  CHARACTER (LEN=250) :: in_path 
  CHARACTER (LEN=250) :: out_path 
  CHARACTER (LEN=250) :: input_name 
  CHARACTER (LEN=250) :: output_name 
  CHARACTER (LEN=13) :: c_date , next_date, f_date
  CHARACTER (LEN=250) :: command

  REAL, ALLOCATABLE, DIMENSION(:,:) :: slab1, slab2, slab3

  NAMELIST /interp/ in_path, input_name, &
                   out_path, output_name  

  in_path  = './'
  input_name  = 'dummy'
  out_path  = './'
  output_name  = "dummy_6"

 ! Read parameters from Fortran namelist
  DO funit=10,100
    INQUIRE(unit=funit, opened=is_used)
    IF (.not. is_used) EXIT
  END DO
  OPEN(funit,file='namelist.input',status='old',form='formatted',iostat=ios)
  IF ( ios /= 0 ) STOP "ERROR opening namelits.input"
  READ(funit,interp)
  CLOSE(funit)


  ! Read the dimensions and allocate the slab arrays
  WRITE(infile, '(A,"/",A,":yyyy-01-01_00")' ) &
        TRIM(in_path), TRIM(input_name)
  OPEN (UNIT=200, FILE=TRIM(infile), STATUS='OLD', &
        FORM='UNFORMATTED', IOSTAT=rstatus)
  READ (UNIT=200,IOSTAT=istatus) version
  READ (UNIT=200,IOSTAT=istatus) hdate, xfcst, map_source, &
       field, units, desc, xlvl, NX, NY, iproj
  CLOSE(200)
  ALLOCATE (slab1(NX,NY))
  ALLOCATE (slab2(NX,NY))
  ALLOCATE (slab3(NX,NY))


  file_handle = 1000
  c = 1
  c_date = "2001-07-01_00"

! Open output file list, but make sure the path exists first
  WRITE(command, '("/bin/mkdir -p ",A)') TRIM(out_path)
  CALL SYSTEM( TRIM ( command ) )

  WRITE(*,*) 'Open output file list'
  DO i = 1, NFILES
    f_date = c_date
    f_date(1:4) = "yyyy"
    hdates(i) = f_date
    OPEN (UNIT=file_handle, &
      FILE=TRIM(out_path)//"/"//TRIM(output_name)//":"//TRIM(f_date),  &
      STATUS='REPLACE', ACTION='WRITE', FORM='UNFORMATTED', &
      CONVERT='BIG_ENDIAN')
    file_handles(i) = file_handle
    file_handle = file_handle + 1
    outfiles(i) = c_date
    CALL geth_newdate ( next_date , c_date , interval_hours )
    c_date = next_date
  END DO

! Loop through each month
  WRITE(*,*) 'Loop through each month'
  DO i = 1, 6
    WRITE(FILES(i),'(A,":yyyy-",i2.2,"-01_00")') TRIM(input_name),  i
  END DO
  DO i = 1, 6
    WRITE(*,*) 'Month: ', i
    DO j = 1, WEIGHTS(i)
      ! Open input file 1
      infile = FILES(i)
      OPEN (UNIT=100, FILE=TRIM(in_path)//"/"//TRIM(infile), &
            STATUS='OLD', FORM='UNFORMATTED', IOSTAT=status1)
      fileopen1: IF (status1 /= 0) THEN
        WRITE (*,110) TRIM(in_path), TRIM(infile), status1
        110 FORMAT (1X, 'Input file 1 ',A,'/',A,' open failed: ', I6)
      END IF fileopen1

      ! Open input file 2
      IF (i == 6) THEN
        infile = FILES(1)
      ELSE
        infile = FILES(i+1)
      END IF
      OPEN (UNIT=200, FILE=TRIM(in_path)//"/"//TRIM(infile), &
            STATUS='OLD', FORM='UNFORMATTED', IOSTAT=status2)
      fileopen2: IF (status2 /= 0) THEN
        WRITE (*,210) TRIM(in_path), TRIM(infile), status2
        210 FORMAT (1X, 'Input file 1 ',A,'/',A,' open failed: ', I6)
      END IF fileopen2

      ! Read the input data one slab at a time
      istatus1 = 0
      istatus2 = 0

      hdates(c) = hdates(c)//':00:0000000'
      DO WHILE ((istatus1 == 0).AND.(istatus2 == 0))
        CALL read_input (100, version, hdate, xfcst, map_source, field, units, desc, xlvl, nnx, nny, iproj, &
        startloc, startlat, startlon, deltalat, deltalon, truelat1, truelat2, xlonc, earth_radius, is_wind_grid_rel, slab1, istatus1)
        CALL read_input (200, version, hdate, xfcst, map_source, field, units, desc, xlvl, nnx, nny, iproj, &
        startloc, startlat, startlon, deltalat, deltalon, truelat1, truelat2, xlonc, earth_radius, is_wind_grid_rel, slab2, istatus2)
        IF ((istatus1 == 0).AND.(istatus2 == 0)) THEN
          slab3 = (slab1*(REAL(WEIGHTS(i)-(j-1))/REAL(WEIGHTS(i))))+(slab2*(REAL(j-1)/REAL(WEIGHTS(i))))
          CALL write_output (file_handles(c), version, hdates(c), xfcst, map_source, field, units, desc, xlvl, nnx, nny, iproj, &
          startloc, startlat, startlon, deltalat, deltalon, truelat1, truelat2, xlonc, earth_radius, is_wind_grid_rel, slab3, istatus)
        END IF
      END DO
      c = c+1
      CLOSE (UNIT=100)
      CLOSE (UNIT=200)
    END DO
  END DO

! Close output files
  DO i = 1, NFILES
    CLOSE (UNIT=file_handles(i))
  END DO

END PROGRAM interp_6hr
