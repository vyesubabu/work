PROGRAM bias_correct

! File: bias_correct
! Description: Handles bias correction calculation
! Input: List of WPS intermediate files and long-term means
! Output: Bias corrected files
! Dan Steinhoff
! 12 May 2014
! Updated Feb 2015 - Cindy Bruyere

  USE module_basic
  IMPLICIT NONE
  
  ! Variable Declarations
  INTEGER :: istatus, rstatus, ostatus
  CHARACTER(len=250) :: infile, outfile, anafile, gcmfile
  INTEGER :: i, j
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
  CHARACTER(len=32) :: map_source, map_source_out
  CHARACTER(len=9) :: fieldr, fieldc, fielde
  CHARACTER(len=25) :: units
  CHARACTER(len=46) :: desc
  INTEGER :: iproj
  INTEGER :: version
  INTEGER :: nnx, nny
  LOGICAL :: is_wind_grid_rel

  REAL, ALLOCATABLE, DIMENSION(:,:) :: raw, cesm, era, correct

  INTEGER :: funit, ios
  LOGICAL :: is_used

  CHARACTER (LEN=250) :: in_path, out_path
  CHARACTER (LEN=250) :: input_name, output_name
  CHARACTER (LEN=250) :: avg_ana_path, avg_gcm_path
  CHARACTER (LEN=250) :: avg_ana_name, avg_gcm_name
  CHARACTER (LEN=13) :: start_date, end_date
  INTEGER :: start_year, start_month, start_day, start_hour
  INTEGER :: end_year, end_month, end_day, end_hour
  INTEGER :: interval_hours
  CHARACTER (LEN=13) :: current_date, next_date, avg_date
  INTEGER :: yyyy
  CHARACTER (LEN=250) :: command
  REAL :: test_missing


  NAMELIST /bc/ start_date, end_date, &
                start_year, start_month, start_day, start_hour, &
                end_year,   end_month,   end_day,   end_hour, &
                interval_hours, &
                in_path, input_name, out_path, output_name, &
                avg_ana_path, avg_ana_name, &
                avg_gcm_path, avg_gcm_name

  
  start_date = '0000-00-00_00:00:00'
  end_date = '0000-00-00_00:00:00'
  interval_hours = 0
  in_path= './'
  input_name= 'dummy_in'
  out_path= './'
  output_name= "dummy_out"
  avg_ana_path= './'
  avg_ana_name= "dummy_ana"
  avg_gcm_path= './'
  avg_gcm_name= "dummy_gcm"

 ! Read parameters from Fortran namelist
  DO funit=10,100
    INQUIRE(unit=funit, opened=is_used)
    IF (.not. is_used) EXIT
  END DO
  OPEN(funit,file='namelist.input',status='old',form='formatted',&
       iostat=ios)
  IF ( ios /= 0 ) STOP "ERROR opening namelits.input"
  READ(funit,bc)
  CLOSE(funit)

  IF (start_date == '0000-00-00_00:00:00') then
    ! Build date string
    WRITE(start_date, '(i4.4,a1,i2.2,a1,i2.2,a1,i2.2,a6)') &
          start_year,'-',start_month,'-',start_day,'_',start_hour
    WRITE(end_date, '(i4.4,a1,i2.2,a1,i2.2,a1,i2.2,a6)') &
          end_year,'-',end_month,'-',end_day,'_',end_hour
  END IF

  
  current_date = start_date
  avg_date = start_date
  avg_date(1:4) = "yyyy"
  READ(current_date(1:4),  '(I4)') yyyy


  ! Read the dimensions and allocate the slab arrays
  WRITE(infile, '(A,"/",i4,"/",A,":",A)' ) &
        TRIM(in_path), yyyy, TRIM(input_name), TRIM(current_date)
  OPEN (UNIT=200, FILE=TRIM(infile), STATUS='OLD', &
        FORM='UNFORMATTED', IOSTAT=rstatus)
  READ (UNIT=200,IOSTAT=istatus) version
  READ (UNIT=200,IOSTAT=istatus) hdate, xfcst, map_source, &
       fieldr, units, desc, xlvl, NX, NY, iproj
  CLOSE(200)
  ALLOCATE (raw(NX,NY)) 
  ALLOCATE (cesm(NX,NY)) 
  ALLOCATE (era(NX,NY)) 
  ALLOCATE (correct(NX,NY)) 


  file_loop : DO 

    READ(current_date(1:4),  '(I4)') yyyy
    WRITE(command, '("/bin/mkdir -p ",A,"/",i4)') TRIM(out_path), yyyy
    CALL SYSTEM( TRIM ( command ) )      

    WRITE(infile, '(A,"/",i4,"/",A,":",A)' ) &
          TRIM(in_path), yyyy, TRIM(input_name), TRIM(current_date)
    WRITE(outfile, '(A,"/",i4,"/",A,":",A)' ) &
          TRIM(out_path), yyyy, TRIM(output_name), TRIM(current_date)
    WRITE(anafile, '(A,"/",A,":",A)' ) &
          TRIM(avg_ana_path), TRIM(avg_ana_name), TRIM(avg_date)
    WRITE(gcmfile, '(A,"/",A,":",A)' ) &
          TRIM(avg_gcm_path), TRIM(avg_gcm_name), TRIM(avg_date)
  
    OPEN (UNIT=200, FILE=TRIM(infile), STATUS='OLD', &
          FORM='UNFORMATTED', IOSTAT=rstatus) ! raw
    OPEN (UNIT=300, FILE=TRIM(gcmfile), STATUS='OLD', &
          FORM='UNFORMATTED', IOSTAT=rstatus) ! cesm avg
    OPEN (UNIT=400, FILE=TRIM(anafile), STATUS='OLD', &
          FORM='UNFORMATTED', IOSTAT=rstatus) ! era avg
    OPEN (UNIT=500, FILE=TRIM(outfile), STATUS='REPLACE', &
          ACTION='WRITE', FORM='UNFORMATTED', CONVERT='BIG_ENDIAN') ! bias corrected 
    WRITE(*,"('Bias Correcting: ',A)") TRIM(infile)
    istatus = 0
    
    DO WHILE (istatus == 0)
      CALL read_input (200, version, hdate, xfcst, map_source, fieldr, &
           units, desc, xlvl, nnx, nny, iproj, startloc, startlat, &
           startlon, deltalat, deltalon, truelat1, truelat2, xlonc, &
           earth_radius, is_wind_grid_rel, raw, istatus)
      map_source_out = "BC "//map_source
      test_missing = minval(raw)
      CALL read_input (300, version, hdate, xfcst, map_source, fieldc, &
           units, desc, xlvl, nnx, nny, iproj, startloc, startlat, &
           startlon, deltalat, deltalon, truelat1, truelat2, xlonc, &
           earth_radius, is_wind_grid_rel, cesm, istatus)
      CALL read_input (400, version, hdate, xfcst, map_source, fielde, &
           units, desc, xlvl, nnx, nny, iproj, startloc, startlat, &
           startlon, deltalat, deltalon, truelat1, truelat2, xlonc, &
           earth_radius, is_wind_grid_rel, era, istatus)

      IF ( fieldr .NE. fieldc .OR. fieldr .NE. fielde ) THEN
        print*,"There is a miss match in the order of the field in the IM file"
        print*,"  RAW field is ", TRIM(fieldr)
        print*,"  GCM field is ", TRIM(fieldc)
        print*,"  Reanalysis field is ", TRIM(fielde)
        STOP
      END IF

      IF (istatus == 0) THEN

        correct = era+raw-cesm
        IF ( test_missing .LT. -1E20 ) THEN
          WHERE ( raw .EQ. test_missing ) ! In case we're messing with missing values
              correct = test_missing
          END WHERE
        END IF

        IF (((fieldr(1:2).EQ.'TT').OR.(fieldr(1:2).EQ.'ST').OR. &
           (fieldr(1:3).EQ.'SST').OR.(fieldr(1:8).EQ.'SKINTEMP')).OR. &
           (fieldr(1:7).EQ.'TAVGSFC')) THEN
           WHERE ( (correct.LT.0.).AND.(correct.GT.(-1E20)) ) ! Negative temperature or snow height
              correct = 0.
           END WHERE
        END IF
        IF ((fieldr(1:2).EQ.'SM')) THEN
          WHERE ( (correct.LT.0.).AND.(correct.GT.(-1E20)) ) ! Negative soil moisture, set of 0.05
              correct = 0.05
          END WHERE
        END IF
        IF ((fieldr(1:2).EQ.'RH')) THEN
          WHERE ( (correct.LT.0.).AND.(correct.GT.(-1E20)) ) ! Negative RH, set to 0.5 ERA-Interim value
              correct = era/2.
          ELSEWHERE ( (correct.GT.100.) ) ! Assuming no supersaturation
              correct = 100.
          END WHERE
        END IF
  
        ! These are the fields we just pass along
        IF ((fieldr(1:6).EQ.'SEAICE').OR.(fieldr(1:4).EQ.'SNOW').OR. &
            (fieldr(1:7).EQ.'LANDSEA').OR.(fieldr(1:7).EQ.'SOILHGT')) THEN
          CALL write_output (500, version, hdate, xfcst, map_source_out, &
               fieldr, units, desc, xlvl, nnx, nny, iproj, startloc, &
               startlat, startlon, deltalat, deltalon, truelat1, &
               truelat2, xlonc, earth_radius, is_wind_grid_rel, raw, &
               ostatus)
        ELSE ! If not passing along, write out the corrected fields
          CALL write_output (500, version, hdate, xfcst, map_source_out, &
               fieldr, units, desc, xlvl, nnx, nny, iproj, startloc, &
               startlat, startlon, deltalat, deltalon, truelat1, &
               truelat2, xlonc, earth_radius, is_wind_grid_rel, correct, &
               ostatus)
        END IF
      END IF
    END DO
    
    CLOSE (UNIT=200)
    CLOSE (UNIT=300)
    CLOSE (UNIT=400)
    CLOSE (UNIT=500)

    CALL geth_newdate ( next_date , current_date , interval_hours )
    current_date = next_date
    avg_date = next_date
    avg_date(1:4) = "yyyy"
    IF ( TRIM(current_date) .GT. TRIM(end_date) ) EXIT file_loop

  END DO file_loop

END PROGRAM bias_correct
