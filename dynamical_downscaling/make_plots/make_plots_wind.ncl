undef("make_plots")
procedure make_plots(wks_name, title_name, variable, times)
begin
    wks = gsn_open_wks("pdf", wks_name)  ; send graphics to PNG file

    f_wrf = addfile("./wrfout_d01_1984-01-01_06:00:00", "r")
    res_map = True
    res_map = wrf_map_resources(f_wrf, res_map)
    res = True
    res@mpProjection      = res_map@mpProjection
    res@mpLimitMode       = res_map@mpLimitMode
    res@mpRightCornerLonF = res_map@mpRightCornerLonF
    res@mpRightCornerLatF = res_map@mpRightCornerLatF
    res@mpLeftCornerLonF  = res_map@mpLeftCornerLonF
    res@mpLeftCornerLatF  = res_map@mpLeftCornerLatF
    res@mpLambertMeridianF   =  res_map@mpLambertMeridianF
    res@mpLambertParallel1F  =  res_map@mpLambertParallel1F
    res@mpLambertParallel2F  =  res_map@mpLambertParallel2F
    res@mpDataBaseVersion  = res_map@mpDataBaseVersion
    res@pmTickMarkDisplayMode = res_map@pmTickMarkDisplayMode
    res@cnInfoLabelOn  = False
    res@gsnDraw  = False
    res@gsnFrame = False
    res@cnFillOn                    = True                 ; turn on color
    res@cnLinesOn                   = False                ; no contour lines
    res@cnLevelSelectionMode        = "ManualLevels"       ; manual levels

;   settings for wind diff
    res@cnFillPalette               = "BlRe"
;   settings for 10m and 850hPa
;    res@cnMinLevelValF              = -0.5
;    res@cnMaxLevelValF              = 0.5
;    res@cnLevelSpacingF             = 0.01
;   settings for 500hPa
    res@cnMinLevelValF              = -2.
    res@cnMaxLevelValF              = 2.
    res@cnLevelSpacingF             = 0.05

;   settings for wind speed
;    res@cnFillPalette               = "MPL_Reds"
;    res@cnMinLevelValF              = 0.0
;   settings for 10m speed 
;    res@cnMaxLevelValF              = 15.0
;    res@cnLevelSpacingF             = 0.1
;   settings for 850hPa speed 
;    res@cnMaxLevelValF              = 20.0
;    res@cnLevelSpacingF             = 0.1
;   settings for 500hPa speed 
;    res@cnMaxLevelValF              = 30.0
;    res@cnLevelSpacingF             = 0.2
;   settings for 300hPa speed 
;    res@cnMaxLevelValF              = 50.0
;    res@cnLevelSpacingF             = 0.5
    
    res@tfDoNDCOverlay = True
;    res@cnLevelSelectionMode = "AutomaticLevels"
    ndims = dimsizes(variable)
    ndim = dimsizes(ndims)

    if (ndim .eq. 2) then
        res@tiMainString    = title_name
        plt = gsn_csm_contour_map(wks, variable, res)
    else
        do i = 0, ndims(0) - 1, 1
            print("ploting time: " + times(i))
            res@tiMainString    = title_name + times(i)
            plt = gsn_csm_contour_map(wks, variable(i,:,:), res)
        end do
    end if

    draw(plt)
    frame(wks)
end
