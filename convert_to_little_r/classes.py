class station:
  def __init__(self,id,lat,lon,observation_height,station_height):
    self.id = id
    self.lat = lat 
    self.lon = lon 
    self.observation_height = observation_height
    self.station_height = station_height

class observation:
  def __init__(self,Station_Id_C,Year,Mon,Day,Hour,PRS,PRS_Sea,PRS_Max,PRS_Min,WIN_S_Max,WIN_S_INST_Max,WIN_D_INST_Max,WIN_D_Avg_10mi,WIN_S_Avg_10mi,WIN_D_S_Max,TEM,TEM_Max,TEM_Min,RHU,VAP,RHU_Min,PRE_1h):
    self.Station_Id_C = Station_Id_C
    self.Year = Year
    self.Mon = Mon
    self.Day = Day
    self.Hour = Hour
    self.PRS = PRS
    self.PRS_Sea = PRS_Sea
    self.PRS_Max = PRS_Max
    self.PRS_Min = PRS_Min
    self.WIN_S_Max = WIN_S_Max
    self.WIN_S_INST_Max = WIN_S_INST_Max
    self.WIN_D_INST_Max = WIN_S_INST_Max 
    self.WIN_D_Avg_10mi = WIN_D_Avg_10mi
    self.WIN_S_Avg_10mi = WIN_S_Avg_10mi
    self.WIN_D_S_Max = WIN_D_S_Max
    self.TEM = TEM
    self.TEM_Max = TEM_Max
    self.TEM_Min = TEM_Min
    self.RHU = RHU
    self.VAP = VAP
    self.RHU_Min = RHU_Min
    self.PRE_1h = PRE_1h

class report_header:
  def __init__(self,latitude,longitude,\
  id,name,platform,source,elevation,\
  num_vld_fld,num_error,num_warning,\
  seq_num,num_dups,is_sound,bogus,discard,\
  sut,julian,date_char,\
  slp,slp_qc,ref_pres,ref_pres_qc,\
  ground_t,ground_t_qc,sst,sst_qc,psfc,psfc_qc,\
  precip,precip_qc,t_max,t_max_qc,t_min,t_min_qc,\
  t_min_night,t_min_night_qc,\
  p_tend03,p_tend03_qc,p_tend24,p_tend24_qc,\
  cloud_cvr,cloud_cvr_qc,ceiling,ceiling_qc):
    self.latitude = latitude
    self.longitude = longitude
    self.id = id
    self.name = name
    self.platform = platform
    self.source = source
    self.elevation = elevation
    self.num_vld_fld = num_vld_fld
    self.num_error = num_error
    self.num_warning = num_warning
    self.seq_num = seq_num
    self.num_dups = num_dups
    self.is_sound = is_sound
    self.bogus = bogus
    self.discard = discard
    self.sut = sut
    self.julian = julian
    self.date_char = date_char
    self.slp = slp
    self.slp_qc = slp_qc
    self.ref_pres = ref_pres
    self.ref_pres_qc = ref_pres_qc
    self.ground_t = ground_t
    self.ground_t_qc = ground_t_qc
    self.sst = sst
    self.sst_qc = sst_qc
    self.psfc = psfc
    self.psfc_qc = psfc_qc
    self.precip = precip
    self.precip_qc = precip_qc
    self.t_max = t_max
    self.t_max_qc = t_max_qc
    self.t_min = t_min
    self.t_min_qc = t_min_qc
    self.t_min_night = t_min_night
    self.t_min_night_qc = t_min_night_qc
    self.p_tend03 = p_tend03
    self.p_tend03_qc = p_tend03_qc
    self.p_tend24 = p_tend24
    self.p_tend24_qc = p_tend24_qc
    self.cloud_cvr = cloud_cvr
    self.cloud_cvr_qc = cloud_cvr_qc
    self.ceiling = ceiling
    self.ceiling_qc = ceiling_qc

class data_records:
  def __init__(self,pressure,pressure_qc,height,height_qc,\
  temperature,temperature_qc,dew_point,dew_point_qc,\
  speed,speed_qc,direction,direction_qc,\
  u,u_qc,v,v_qc,rh,rh_qc,thickness,thickness_qc):
    self.pressure = pressure
    self.pressure_qc = pressure_qc
    self.height = height
    self.height_qc = height_qc
    self.temperature = temperature
    self.temperature_qc = temperature_qc
    self.dew_point = dew_point
    self.dew_point_qc = dew_point_qc
    self.speed = speed
    self.speed_qc = speed_qc
    self.direction = direction
    self.direction_qc = direction_qc
    self.u = u
    self.u_qc = u_qc
    self.v = v
    self.v_qc = v_qc
    self.rh = rh
    self.rh_qc = rh_qc
    self.thickness = thickness
    self.thickness_qc = thickness_qc

class report_end:
  def __init__(self,num_vld_fld,num_error,num_warning):
    self.num_vld_fld = num_vld_fld
    self.num_error = num_error
    self.num_warning = num_warning
