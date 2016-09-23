class little_r(object):
    def __init__(self):
        default_str         = ''
        default_float       = -888888.
        default_qc          = 0
        self.latitude       = default_float
        self.longitude      = default_float
        self.station_id     = default_str
        self.name           = 'SURFACE OBS'
        self.platform       = 'FM-12 SYNOP'
        self.source         = 'GTS'
        self.elevation      = default_float
        self.num_vld_fld    = 1
        self.num_error      = 0
        self.num_warning    = 0
        self.seq_num        = 0
        self.num_dups       = 0
        self.is_sound       = 'F'
        self.bogus          = 'F'
        self.discard        = 'F'
        self.sut            = -888888
        self.julian         = -888888
        self.date_char      = default_str
        self.slp            = default_float
        self.slp_qc         = default_qc
        self.ref_pres       = default_float
        self.ref_pres_qc    = default_qc
        self.ground_t       = default_float
        self.ground_t_qc    = default_qc
        self.sst            = default_float
        self.sst_qc         = default_qc
        self.psfc           = default_float
        self.psfc_qc        = default_qc
        self.precip         = default_float
        self.precip_qc      = default_qc
        self.t_max          = default_float
        self.t_max_qc       = default_qc
        self.t_min          = default_float
        self.t_min_qc       = default_qc
        self.t_min_night    = default_float
        self.t_min_night_qc = default_qc
        self.p_tend03       = default_float
        self.p_tend03_qc    = default_qc
        self.p_tend24       = default_float
        self.p_tend24_qc    = default_qc
        self.cloud_cvr      = default_float
        self.cloud_cvr_qc   = default_qc
        self.ceiling        = default_float
        self.ceiling_qc     = default_qc

        self.pressure       = default_float
        self.pressure_qc    = default_qc
        self.height         = default_float
        self.height_qc      = default_qc
        self.temperature    = default_float
        self.temperature_qc = default_qc
        self.dew_point      = default_float
        self.dew_point_qc   = default_qc
        self.speed          = default_float
        self.speed_qc       = default_qc
        self.direction      = default_float
        self.direction_qc   = default_qc
        self.u              = default_float
        self.u_qc           = default_qc
        self.v              = default_float
        self.v_qc           = default_qc
        self.rh             = default_float
        self.rh_qc          = default_qc
        self.thickness      = default_float
        self.thickness_qc   = default_qc

        self.num_vld_fld = 1
        self.num_error   = 0
        self.num_warning = 0

    def print_head(self, f_out):
        print("%20.5f%20.5f%-40s%-40s%-40s%-40s%20.5f%10d%10d%10d%10d%10d%10s%10s%10s%10d%10d%20s%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d"%(\
        self.latitude,\
        self.longitude,\
        self.station_id,\
        self.name,\
        self.platform,\
        self.source,\
        self.elevation,\
        self.num_vld_fld,\
        self.num_error,\
        self.num_warning,\
        self.seq_num,\
        self.num_dups,\
        self.is_sound,\
        self.bogus,\
        self.discard,\
        self.sut,\
        self.julian,\
        self.date_char,\
        self.slp,\
        self.slp_qc,\
        self.ref_pres,\
        self.ref_pres_qc,\
        self.ground_t,\
        self.ground_t_qc,\
        self.sst,\
        self.sst_qc,\
        self.psfc,\
        self.psfc_qc,\
        self.precip,\
        self.precip_qc,\
        self.t_max,\
        self.t_max_qc,\
        self.t_min,\
        self.t_min_qc,\
        self.t_min_night,\
        self.t_min_night_qc,\
        self.p_tend03,\
        self.p_tend03_qc,\
        self.p_tend24,\
        self.p_tend24_qc,\
        self.cloud_cvr,\
        self.cloud_cvr_qc,\
        self.ceiling,\
        self.ceiling_qc), file=f_out)

    def print_data(self, f_out):
        print("%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d"%(\
        self.pressure,\
        self.pressure_qc,\
        self.height,\
        self.height_qc,\
        self.temperature,\
        self.temperature_qc,\
        self.dew_point,\
        self.dew_point_qc,\
        self.speed,\
        self.speed_qc,\
        self.direction,\
        self.direction_qc,\
        self.u,\
        self.u_qc,\
        self.v,\
        self.v_qc,\
        self.rh,\
        self.rh_qc,\
        self.thickness,\
        self.thickness_qc), file=f_out)

    def print_data_end(self, f_out):
        print("%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d"%(\
        -777777,0,-777777,0,\
        1,0,-888888,0,-888888,0,\
        -888888,0,-888888,0,-888888,0,\
        -888888,0,-888888,0), file=f_out)

    def print_end(self, f_out):
        print("%7d%7d%7d"%(\
        self.num_vld_fld,\
        self.num_error,\
        self.num_warning), file=f_out)
