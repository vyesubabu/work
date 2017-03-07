;----------------------------------------------------------------------
; generate_china_mask.ncl
;
; Concepts illustrated:
;   - Reading shapefiles
;   - Creating a mask variable using outlines from a shapefile
;   - Attaching markers to a map
;   - Attaching polylines to a map plot
;   - Masking a data array based on a geographical area obtained from a shapefile
;----------------------------------------------------------------------
; This script creates a new data mask based on the outline of the
; China. It then draws two plots: the original data,
; and the data with the China mask.
;
; Try both of these files to see if they work for your purposes.
; The national file is larger, and hence takes longer to process
; (206 wall clock seconds on a Mac versus 17 wall clock seconds.)
;
; Once you create the mask, you can set CREATE_MASK to False so
; it doesn't get created again when you run this script.
;
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

; This file still has to be loaded manually
load "./shapefile_utils.ncl"

;----------------------------------------------------------------------
; This is the main code
;----------------------------------------------------------------------
begin
;
; If you already have the mask NetCDF file, set this to False.
; Creating the mask can be slow!
;
    CREATE_MASK = True

;---Whether to draw lat/lon points and shapefile outlines
    ADD_LATLON_POINTS      = False
    ADD_SHAPEFILE_OUTLINES = True

;---Name of shapefile containing USA outlines
    shp_fname = "./CHN_adm_shp/CHN_adm0.shp"

;---Name of file to write mask to or to read mask from.
    mask_fname = "chn_mask.nc"

;---Rough area we are interested in. Everything outside this will be masked.
    minlon =   60
    maxlon =  140
    minlat =   10
    maxlat =   60

;---Read in zonal winds
    a = addfile("../process_output/wrfout_d01_1984-01-01_06:00:00", "r")
    u = a->U10(0,:,:)                                ; read July zonal winds
    u@lat2d = wrf_user_getvar(a, "lat", 0)
    u@lon2d = wrf_user_getvar(a, "lon", 0)

    printVarSummary(u)

    if(CREATE_MASK) then
        print("Creating the mask file...")

;---Create a new mask using a shapefile of China
        udims = dimsizes(u)
        opt             = True
        opt@return_mask = True
;       opt@debug       = True
        opt@minlon      = minlon     ; Makes the shapefile masking
        opt@maxlon      = maxlon     ; go faster.
        opt@minlat      = minlat
        opt@maxlat      = maxlat
        chn_mask        = shapefile_mask_data(u, shp_fname, opt)
        chn_mask!0 = "south_north"
        chn_mask!1 = "west_east"

;---Write new mask to file
        system("rm -f " + mask_fname)
        fout           = addfile(mask_fname, "c")
        fout->chn_mask = chn_mask
    else
        print("Reading mask off file.")

;---Read the new mask from the NetCDF file
        fmask    = addfile(mask_fname, "r")
        chn_mask = fmask->chn_mask
    end if

end
