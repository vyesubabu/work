MODULE module_basic

! File: module_basic
! Associated Program(s): monthly_means.f90, bias_correct.f90
! Description: Read and write routines for bias correction in WPS Intermediate Format
! Dan Steinhoff
! 7 May 2014
! Updated: Feb 2015 - Cindy Bruyere

  IMPLICIT NONE

  ! Constant Declarations
  INTEGER :: NX
  INTEGER :: NY
  SAVE

  CONTAINS

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  SUBROUTINE read_input (file_handle, version, hdate, xfcst, &
    map_source, field, units, desc, xlvl, nxx, nyy, iproj, startloc, &
    startlat, startlon, deltalat, deltalon, truelat1, truelat2, xlonc, &
    earth_radius, is_wind_grid_rel, slab, istatus)

    ! Description: Reads WPS Intermediate File
    ! Input: WPS Intermediate File
    ! Output: Input Data

    IMPLICIT NONE

    ! Variable Declarations
    INTEGER, INTENT(IN) :: file_handle                ! File unit number
    INTEGER, INTENT(OUT) :: version                   ! Version
    CHARACTER(len=24), INTENT(OUT) :: hdate           ! Date
    REAL, INTENT(OUT) :: xfcst                        ! Forecast hour
    CHARACTER(len=32), INTENT(OUT) :: map_source      ! Source model / originating center
    CHARACTER(len=9), INTENT(OUT) :: field            ! Name of the field
    CHARACTER(len=25), INTENT(OUT) :: units           ! Units
    CHARACTER(len=46), INTENT(OUT) :: desc            ! Short description of data
    REAL, INTENT(OUT) :: xlvl                         ! Vertical level
    INTEGER, INTENT(OUT) :: nxx                       ! x bound
    INTEGER, INTENT(OUT) :: nyy                       ! y bound
    INTEGER, INTENT(OUT) :: iproj                     ! Projection
    CHARACTER(len=8), INTENT(OUT) :: startloc         ! Starting location description
    REAL, INTENT(OUT) :: startlat                     ! Starting latitude
    REAL, INTENT(OUT) :: startlon                     ! Starting longitude
    REAL, INTENT(OUT) :: deltalat                     ! Grid spacing, deg lat
    REAL, INTENT(OUT) :: deltalon                     ! Grid spacing, deg lon
    REAL, INTENT(OUT) :: truelat1                     ! True latitude 1
    REAL, INTENT(OUT) :: truelat2                     ! True latitude 2
    REAL, INTENT(OUT) :: xlonc                        ! Standard longitude
    REAL, INTENT(OUT) :: earth_radius                 ! Earth radius, km
    LOGICAL, INTENT(OUT) :: is_wind_grid_rel          ! Wind flag
    REAL, DIMENSION(NX,NY), INTENT(OUT) :: slab       ! Data
    INTEGER, INTENT(OUT) :: istatus                   ! Status variable

    ! Read version
    READ (UNIT=file_handle,IOSTAT=istatus) version

    ! Read projection input
    READ (UNIT=file_handle,IOSTAT=istatus) hdate, xfcst, map_source, &
         field, units, desc, xlvl, nxx, nyy, iproj

    IF (field == 'HGT      ') field = 'GHT      '

    IF (iproj == 0) THEN   ! Cylindrical equidistant
      READ (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
           startlon, deltalat, deltalon, earth_radius

    ELSE IF (iproj == 1) THEN   ! Mercator
      READ (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
           startlon, deltalat, deltalon, truelat1, earth_radius

    ELSE IF (iproj == 3) THEN   ! Lambert conformal
      READ (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
           startlon, deltalat, deltalon, xlonc, truelat1, truelat2, &
           earth_radius

    ELSE IF (iproj == 4) THEN   ! Gaussian
      READ (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
           startlon, deltalat, deltalon, earth_radius

    ELSE IF (iproj == 5) THEN   ! Polar stereographic
      READ (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
           startlon, deltalat, deltalon, xlonc, truelat1

    ELSE
      istatus = 1
    END IF

    READ (UNIT=file_handle,IOSTAT=istatus) is_wind_grid_rel
    READ (UNIT=file_handle,IOSTAT=istatus) slab

  END SUBROUTINE read_input

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  SUBROUTINE write_output (file_handle, version, hdate, xfcst, &
    map_source, field, units, desc, xlvl, nxx, nyy, iproj, startloc, &
    startlat, startlon, deltalat, deltalon, truelat1, truelat2, xlonc, &
    earth_radius, is_wind_grid_rel, slab, istatus)

    ! Description: Writes four output files (one each for 0, 6, 12, and 18 hours
    ! Input: Filename, hour
    ! Output: Four output files

    IMPLICIT NONE

    ! Variable Declarations
    INTEGER, INTENT(IN) :: file_handle             ! File unit
    INTEGER, INTENT(IN) :: version                 ! Version
    CHARACTER(len=24), INTENT(IN) :: hdate         ! Date
    REAL, INTENT(IN) :: xfcst                      ! Forecast hour
    CHARACTER(len=32), INTENT(IN) :: map_source    ! Source model / originating center
    CHARACTER(len=9), INTENT(IN) :: field          ! Name of the field
    CHARACTER(len=25), INTENT(IN) :: units         ! Units
    CHARACTER(len=46), INTENT(IN) :: desc          ! Short description of data
    REAL, INTENT(IN) :: xlvl                       ! Vertical level
    INTEGER, INTENT(IN) :: nxx                     ! x bound
    INTEGER, INTENT(IN) :: nyy                     ! y bound
    INTEGER, INTENT(IN) :: iproj                   ! Projection
    CHARACTER(len=8), INTENT(IN) :: startloc       ! Starting location description
    REAL, INTENT(IN) :: startlat                   ! Starting latitude
    REAL, INTENT(IN) :: startlon                   ! Starting longitude
    REAL, INTENT(IN) :: deltalat                   ! Grid spacing, deg lat
    REAL, INTENT(IN) :: deltalon                   ! Grid spacing, deg lon
    REAL, INTENT(IN) :: truelat1                   ! True latitude 1
    REAL, INTENT(IN) :: truelat2                   ! True latitude 2
    REAL, INTENT(IN) :: xlonc                      ! Standard longitude
    REAL, INTENT(IN) :: earth_radius               ! Earth radius, km
    LOGICAL, INTENT(IN) :: is_wind_grid_rel        ! Wind flag
    REAL, DIMENSION(NX,NY), INTENT(IN) :: slab     ! Data
    INTEGER, INTENT(OUT) :: istatus                ! Status variable

    ! Write version
    WRITE (UNIT=file_handle) version

    ! Read projection input
    WRITE (UNIT=file_handle) hdate, xfcst, map_source, field, units, &
          desc, xlvl, nxx, nyy, iproj

    IF (iproj == 0) THEN   ! Cylindrical equidistant
      WRITE (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
          startlon, deltalat, deltalon, earth_radius

    ELSE IF (iproj == 1) THEN   ! Mercator
      WRITE (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
          startlon, deltalat, deltalon, truelat1, earth_radius

    ELSE IF (iproj == 3) THEN   ! Lambert conformal
      WRITE (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
          startlon, deltalat, deltalon, xlonc, truelat1, truelat2, &
          earth_radius

    ELSE IF (iproj == 4) THEN   ! Gaussian
      WRITE (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
          startlon, deltalat, deltalon, earth_radius

    ELSE IF (iproj == 5) THEN   ! Polar stereographic
      WRITE (UNIT=file_handle,IOSTAT=istatus) startloc, startlat, &
          startlon, deltalat, deltalon, xlonc, truelat1

    END IF

    ! Write wind flag
    WRITE (UNIT=file_handle, IOSTAT=istatus) is_wind_grid_rel

    ! Write data
    WRITE (UNIT=file_handle, IOSTAT=istatus) slab
    
  END SUBROUTINE write_output

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  SUBROUTINE geth_newdate (ndate, odate, idt)
  !!!! This version of the code does NOT take leap years into account

    IMPLICIT NONE

    !  From old date ('YYYY-MM-DD HH:MM:SS.ffff') and
    !  delta-time, compute the new date.

    !  on entry     -  odate  -  the old hdate.
    !                  idt    -  the change in time

    !  on exit      -  ndate  -  the new hdate.

    INTEGER , INTENT(IN)           :: idt
    CHARACTER (LEN=*) , INTENT(OUT) :: ndate
    CHARACTER (LEN=*) , INTENT(IN)  :: odate

    !  Local Variables

    !  yrold    -  indicates the year associated with "odate"
    !  moold    -  indicates the month associated with "odate"
    !  dyold    -  indicates the day associated with "odate"
    !  hrold    -  indicates the hour associated with "odate"
    !  miold    -  indicates the minute associated with "odate"
    !  scold    -  indicates the second associated with "odate"

    !  yrnew    -  indicates the year associated with "ndate"
    !  monew    -  indicates the month associated with "ndate"
    !  dynew    -  indicates the day associated with "ndate"
    !  hrnew    -  indicates the hour associated with "ndate"
    !  minew    -  indicates the minute associated with "ndate"
    !  scnew    -  indicates the second associated with "ndate"

    !  mday     -  a list assigning the number of days in each month

    !  i        -  loop counter
    !  nday     -  the integer number of days represented by "idt"
    !  nhour    -  the integer number of hours in "idt" after taking out
    !              all the whole days
    !  nmin     -  the integer number of minutes in "idt" after taking out
    !              all the whole days and whole hours.
    !  nsec     -  the integer number of minutes in "idt" after taking out
    !              all the whole days, whole hours, and whole minutes.

    INTEGER :: nlen, olen
    INTEGER :: yrnew, monew, dynew, hrnew, minew, scnew, frnew
    INTEGER :: yrold, moold, dyold, hrold, miold, scold, frold
    INTEGER :: mday(12), nday, nhour, nmin, nsec, nfrac, i, ifrc
    LOGICAL :: opass
    CHARACTER (LEN=10) :: hfrc
    CHARACTER (LEN=1) :: sp

    !  Assign the number of days in a months

    mday( 1) = 31
    mday( 2) = 28
    mday( 3) = 31
    mday( 4) = 30
    mday( 5) = 31
    mday( 6) = 30
    mday( 7) = 31
    mday( 8) = 31
    mday( 9) = 30
    mday(10) = 31
    mday(11) = 30
    mday(12) = 31

    !  Break down old hdate into parts

    hrold = 0
    miold = 0
    scold = 0
    frold = 0
    olen = LEN(odate)
    IF (olen.GE.11) THEN
       sp = odate(11:11)
    else
       sp = ' '
    END IF

    !  Use internal READ statements to convert the CHARACTER string
    !  date into INTEGER components.

    READ(odate(1:4),  '(I4)') yrold
    READ(odate(6:7),  '(I2)') moold
    READ(odate(9:10), '(I2)') dyold
    IF (olen.GE.13) THEN
      READ(odate(12:13),'(I2)') hrold
      IF (olen.GE.16) THEN
        READ(odate(15:16),'(I2)') miold
        IF (olen.GE.19) THEN
          READ(odate(18:19),'(I2)') scold
          IF (olen.GT.20) THEN
            READ(odate(21:olen),'(I2)') frold
          END IF
        END IF
      END IF
    END IF

    !  Check that ODATE makes sense.
    opass = .TRUE.

    !  Check that the month of ODATE makes sense.
    IF ((moold.GT.12).or.(moold.LT.1)) THEN
      WRITE(*,*) 'GETH_NEWDATE:  Month of ODATE = ', moold
      opass = .FALSE.
    END IF

    !  Check that the day of ODATE makes sense.
    IF ((dyold.GT.mday(moold)).or.(dyold.LT.1)) THEN
      WRITE(*,*) 'GETH_NEWDATE:  Day of ODATE = ', dyold
      opass = .FALSE.
    END IF

    !  Check that the hour of ODATE makes sense.
    IF ((hrold.GT.23).or.(hrold.LT.0)) THEN
      WRITE(*,*) 'GETH_NEWDATE:  Hour of ODATE = ', hrold
      opass = .FALSE.
    END IF

    !  Check that the minute of ODATE makes sense.
    IF ((miold.GT.59).or.(miold.LT.0)) THEN
      WRITE(*,*) 'GETH_NEWDATE:  Minute of ODATE = ', miold
      opass = .FALSE.
    END IF

    !  Check that the second of ODATE makes sense.
    IF ((scold.GT.59).or.(scold.LT.0)) THEN
      WRITE(*,*) 'GETH_NEWDATE:  Second of ODATE = ', scold
      opass = .FALSE.
    END IF

    IF (.not.opass) THEN
      WRITE(*,*) 'GETH_NEWDATE: Crazy ODATE: ', odate(1:olen), olen
      STOP 'odate_3'
    END IF

    !  Date Checks are completed.  Continue.


    !  Compute the number of days, hours, minutes, and seconds in idt

    IF (olen.GT.20) THEN !idt should be in fractions of seconds
      ifrc = olen-20
      ifrc = 10**ifrc
      nday   = ABS(idt)/(86400*ifrc)
      nhour  = MOD(ABS(idt),86400*ifrc)/(3600*ifrc)
      nmin   = MOD(ABS(idt),3600*ifrc)/(60*ifrc)
      nsec   = MOD(ABS(idt),60*ifrc)/(ifrc)
      nfrac = MOD(ABS(idt), ifrc)
    ELSE IF (olen.eq.19) THEN  !idt should be in seconds
      ifrc = 1
      nday   = ABS(idt)/86400 ! Integer number of days in delta-time
      nhour  = MOD(ABS(idt),86400)/3600
      nmin   = MOD(ABS(idt),3600)/60
      nsec   = MOD(ABS(idt),60)
      nfrac  = 0
    ELSE IF (olen.eq.16) THEN !idt should be in minutes
      ifrc = 1
      nday   = ABS(idt)/1440 ! Integer number of days in delta-time
      nhour  = MOD(ABS(idt),1440)/60
      nmin   = MOD(ABS(idt),60)
      nsec   = 0
      nfrac  = 0
    ELSE IF (olen.eq.13) THEN !idt should be in hours
      ifrc = 1
      nday   = ABS(idt)/24 ! Integer number of days in delta-time
      nhour  = MOD(ABS(idt),24)
      nmin   = 0
      nsec   = 0
      nfrac  = 0
    ELSE IF (olen.eq.10) THEN !idt should be in days
      ifrc = 1
      nday   = ABS(idt)/24 ! Integer number of days in delta-time
      nhour  = 0
      nmin   = 0
      nsec   = 0
      nfrac  = 0
    ELSE
      WRITE(*,'(''GETH_NEWDATE: Strange length for ODATE: '', i3)') &
           olen
      WRITE(*,*) odate(1:olen)
      STOP 'odate_4'
    END IF

    IF (idt.GE.0) THEN

      frnew = frold + nfrac
      IF (frnew.GE.ifrc) THEN
        frnew = frnew - ifrc
        nsec = nsec + 1
      END IF

      scnew = scold + nsec
      IF (scnew .GE. 60) THEN
        scnew = scnew - 60
        nmin  = nmin + 1
      END IF

      minew = miold + nmin
      IF (minew .GE. 60) THEN
        minew = minew - 60
        nhour  = nhour + 1
      END IF

      hrnew = hrold + nhour
      IF (hrnew .GE. 24) THEN
        hrnew = hrnew - 24
        nday  = nday + 1
      END IF
      dynew = dyold
      monew = moold
      yrnew = yrold
      DO i = 1, nday
        dynew = dynew + 1
        IF (dynew.GT.mday(monew)) THEN
          dynew = dynew - mday(monew)
          monew = monew + 1
          IF (monew .GT. 12) THEN
            monew = 1
            yrnew = yrnew + 1
          END IF
        END IF
      END DO

    ELSE IF (idt.LT.0) THEN

      frnew = frold - nfrac
      IF (frnew .LT. 0) THEN
        frnew = frnew + ifrc
        nsec = nsec - 1
      END IF

      scnew = scold - nsec
      IF (scnew .LT. 00) THEN
        scnew = scnew + 60
        nmin  = nmin + 1
      END IF

      minew = miold - nmin
      IF (minew .LT. 00) THEN
        minew = minew + 60
        nhour  = nhour + 1
      END IF

      hrnew = hrold - nhour
      IF (hrnew .LT. 00) THEN
        hrnew = hrnew + 24
        nday  = nday + 1
      END IF

      dynew = dyold
      monew = moold
      yrnew = yrold
      DO i = 1, nday
        dynew = dynew - 1
        IF (dynew.eq.0) THEN
          monew = monew - 1
          IF (monew.eq.0) THEN
            monew = 12
            yrnew = yrnew - 1
          END IF
          dynew = mday(monew)
        END IF
      END DO
    END IF

    !  Now construct the new mdate

    nlen = LEN(ndate)

    IF (nlen.GT.20) THEN
      WRITE(ndate(1:19),19) yrnew, monew, dynew, hrnew, minew, scnew
      WRITE(hfrc,'(I10)') frnew+1000000000
      ndate = ndate(1:19)//'.'//hfrc(31-nlen:10)

    ELSE IF (nlen.eq.19.or.nlen.eq.20) THEN
      WRITE(ndate(1:19),19) yrnew, monew, dynew, hrnew, minew, scnew
      19   format(I4,'-',I2.2,'-',I2.2,'_',I2.2,':',I2.2,':',I2.2)
      IF (nlen.eq.20) ndate = ndate(1:19)//'.'

    ELSE IF (nlen.eq.16) THEN
      WRITE(ndate,16) yrnew, monew, dynew, hrnew, minew
      16   format(I4,'-',I2.2,'-',I2.2,'_',I2.2,':',I2.2)

    ELSE IF (nlen.eq.13) THEN
      WRITE(ndate,13) yrnew, monew, dynew, hrnew
      13   format(I4,'-',I2.2,'-',I2.2,'_',I2.2)

    ELSE IF (nlen.eq.10) THEN
      WRITE(ndate,10) yrnew, monew, dynew
      10   format(I4,'-',I2.2,'-',I2.2)

    END IF

    IF (olen.GE.11) ndate(11:11) = sp

  END SUBROUTINE geth_newdate

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  SUBROUTINE all_spaces ( command , length_of_char )

    IMPLICIT NONE

    INTEGER                        :: length_of_char
    CHARACTER (LEN=length_of_char) :: command
    INTEGER                        :: loop

    DO loop = 1 , length_of_char
      command(loop:loop) = ' '
    END DO

  END SUBROUTINE all_spaces

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

END MODULE module_basic
