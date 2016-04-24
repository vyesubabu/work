import os

def run_ncl(case,root_name,out_dir,ntime_s_6h,ntime_e_6h,ntime_s_3h,ntime_e_3h,\
        ntime_s_day,ntime_e_day,ntime_s_mon,ntime_e_mon,\
        hus_file,ta_file,ua_file,va_file,ps_file,huss_file,tas_file,uas_file,vas_file,\
        mrlsl_file,tsl_file,tos_file,ts_file,snw_file,sic_file,orog_file,sftlf_file,):
        
        os.system("ncl gfdl2wpsim.ncl 'CASE = \"%s\"' 'IM_root_name = \"%s\"' 'outDIR = \"%s\"' \
                'ntime_s_6h = %d'  'ntime_e_6h = %d'  'ntime_s_3h = %d'  'ntime_e_3h = %d' \
                'ntime_s_day = %d' 'ntime_e_day = %d' 'ntime_s_mon = %d' 'ntime_e_mon  = %d' \
                'hus_file = \"%s\"' 'ta_file = \"%s\"' 'ua_file = \"%s\"' 'va_file = \"%s\"' 'ps_file = \"%s\"' \
                'huss_file = \"%s\"' 'tas_file = \"%s\"' 'uas_file = \"%s\"' 'vas_file = \"%s\"' \
                'mrlsl_file = \"%s\"' 'tsl_file = \"%s\"' 'tos_file = \"%s\"' 'ts_file = \"%s\"' \
                'snw_file   = \"%s\"' 'sic_file = \"%s\"' 'orog_file = \"%s\"' 'sftlf_file = \"%s\"'"\
                %(case,root_name,out_dir, \
                ntime_s_6h,ntime_e_6h,ntime_s_3h,ntime_e_3h, \
                ntime_s_day,ntime_e_day,ntime_s_mon,ntime_e_mon, \
                hus_file,ta_file,ua_file,va_file,ps_file, \
                huss_file,tas_file,uas_file,vas_file, \
                mrlsl_file,tsl_file,tos_file,ts_file, \
                snw_file,sic_file,orog_file,sftlf_file))
