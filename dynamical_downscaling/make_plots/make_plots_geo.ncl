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

;   settings for diff
    res@cnFillPalette               = "BlRe"
    res@cnMinLevelValF              = -500.
    res@cnMaxLevelValF              = 500.
    res@cnLevelSpacingF             = 10.

    
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
