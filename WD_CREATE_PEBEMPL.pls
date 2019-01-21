create or replace PROCEDURE       WD_CREATE_PEBEMPL (
                          P0            IN     VARCHAR2 DEFAULT NULL,
   P1 in varchar2 default null,
   P2 in varchar2 default null,
   P3 in VARCHAR2 default null,
   p4 in VARCHAR2 default null,
   p5 in VARCHAR2 default null,
   p6 in VARCHAR2 default null,
   p7 in VARCHAR2 default null,
   p8 in VARCHAR2 default null,
   p9 in VARCHAR2 default null,
   p10 in VARCHAR2 default null,
   p11 in VARCHAR2 default null,
   p12 in VARCHAR2 default null,
   p13 in VARCHAR2 default null,
   p14 in VARCHAR2 default null,
   p15 in VARCHAR2 default null,
   p16 in VARCHAR2 default null,
   p17 in VARCHAR2 default null,
   p18 in VARCHAR2 default null,
   p19 in VARCHAR2 default null,
   p20 in VARCHAR2 default null,
   p21 in VARCHAR2 default null,
   p22 in VARCHAR2 default null,
   p23 in VARCHAR2 default null,
   p24 in VARCHAR2 default null,
   p25 in VARCHAR2 default null,
   p26 in VARCHAR2 default null,
   p27 in VARCHAR2 default null,
   p28 in VARCHAR2 default null,
   p29 in VARCHAR2 default null,
   p30 in VARCHAR2 default null,
   p31 in VARCHAR2 default null,
   p32 in VARCHAR2 default null,
   p33 in VARCHAR2 default null,   
   p34 in varchar2 default null,
   p35 in varchar2 default null,
   p36 in varchar2 default null,
   p37 in varchar2 default null,
   p38 in varchar2 default null,
   p39 in varchar2 default null,
   p40 in varchar2 default null,
   p41 in varchar2 default null,
   p42 in varchar2 default null,
   p43 in varchar2 default null,
   p44 in varchar2 default null,
   p45 in varchar2 default null,
   p46 in varchar2 default null,
   
   REF_CUR_OUT      OUT SYS_REFCURSOR)


AS
-- ref_cur_out : out REF_CURSOR
-- p1 : dob
-- p2 : emp first name
-- p3 : emp last name
-- p4 : emp ssn
-- p5 : emp vet status
-- p6 : emp vassar id
-- p7  : emp vassar pidm
-- p8 : activity date
-- p9 : prefix
-- p10 : suffix
-- p11 : marital status
-- p12 : ethnicity
-- p13 : gender
-- p14 : citizenship
-- p15 ; confid status
-- p16 : work location
-- p17 ; work workspace
-- p18 : work phone
-- p19 : personal phone area
-- p20 : personal phone
-- p21 : work email
-- p22 : personal email
-- p23 : emp class
-- p24 : job profile
-- p25 : job title
-- p26 : empl rank
-- p27 : ftpt status
-- p28 : curr hire date
-- p29 : orig hire date
-- p30 : service years
-- p31 : absence code
-- p32 : absence start date
-- p33 : absence end date
-- p34 : cost center
-- p35 : supervisory org
-- p36 : wd empl id
-- p37 : suffrage status
-- p38 : cost center code
-- p39 : appt title
-- p40 : boxno
-- p41 : personal phone type
-- p42 : mobile area (non primary)
-- p43 : mobile phone (non primary)
-- p44 : position id
-- p45 : banner position id
-- p46 : worker_type

   return_code varchar2(3) := '200';
   return_object varchar2(10) := 'PEBEMPL';
   return_status varchar2(100) := 'success';
   
   banner_ecls    PEBEMPL.PEBEMPL_ECLS_CODE%TYPE := '';
   banner_lcat    PEBEMPL.PEBEMPL_LCAT_CODE%TYPE := '';
   banner_bcat   PEBEMPL.PEBEMPL_BCAT_CODE%TYPE := '';
   
   banner_cost_center varchar2(6) := '';
   
BEGIN
    
    -- determine ECLS
   case 
      when p23 like '%Adminstration%' then banner_ecls := 'AD';
      when p23 like '%Faculty%' then banner_ecls := 'FA';
      when p23 like '%Service%' then banner_ecls := 'SE';
      when p23 like '%Staff%' then banner_ecls := 'CL';
      when p23 like '%Student%' then banner_ecls := 'ST';
      when p23 like '%Temp%' then banner_ecls := 'CN';
      when p23 like '%Call%' then banner_ecls := 'SN';
      else banner_ecls := 'AD'; 
   end case;

    if p44 is null then
         banner_ecls := 'FA';
    end if;
    
   if p46 like '%Contingent%' then 
       banner_ecls := 'ZA';
   end if;
   
   banner_cost_center := p38;
   if p38 in ('CC6001', 'CC6002', 'CC6003') then
        banner_cost_center := 'CC6000';
   end if;
   if p38 in ('CC8001', 'CC8002', 'CC8003', 'CC8004', 'CC8005', 'CC8006') then
         banner_cost_center := 'CC8000';
   end if;
   if p38 in ('CC3031', 'CC3032', 'CC3033', 'CC3034', 'CC3035', 'CC3036', 'CC3037', 'CC3038', 'CC3039', 'CC3040', 'CC3041', 'CC3042', 'CC3043', 'CC3044', 'CC3045', 'CC3046', 'CC3047') then
         banner_cost_center := 'CC3030';
   end if;
   if p38 in ('CC5011', 'CC5012', 'CC5013', 'CC5014', 'CC5015', 'CC5016', 'CC5017', 'CC5018', 'CC5019', 'CC5020') then
         banner_cost_center := '50000';
   end if;

    
   -- determine *CAT_CODE
   case 
      when banner_ecls like '%AD%' or banner_ecls like '%ZA%' then banner_lcat := 'A1';
      when banner_ecls like '%FA%' then banner_lcat := 'F1';
      when banner_ecls like '%SE%' then banner_lcat := 'S1';
      else banner_lcat := 'A1'; 
   end case;
   banner_bcat := banner_lcat;
   
    -- 
   begin
   insert into pebempl 
   (PEBEMPL_PIDM, 
   PEBEMPL_EMPL_STATUS, 
   PEBEMPL_COAS_CODE_HOME,
   PEBEMPL_ORGN_CODE_HOME,
   PEBEMPL_COAS_CODE_DIST,
   PEBEMPL_ORGN_CODE_DIST, 
   PEBEMPL_ECLS_CODE, 
   PEBEMPL_LCAT_CODE, 
   PEBEMPL_BCAT_CODE,
   PEBEMPL_FIRST_HIRE_DATE, 
   PEBEMPL_CURRENT_HIRE_DATE, 
   PEBEMPL_ADJ_SERVICE_DATE, 
   PEBEMPL_SENIORITY_DATE, 
   PEBEMPL_FLSA_IND, 
   PEBEMPL_INTERNAL_FT_PT_IND,
   PEBEMPL_IPEDS_SOFT_MONEY_IND, 
   PEBEMPL_EW2_CONSENT_IND, 
   PEBEMPL_IPEDS_PRIMARY_FUNCTION, 
   PEBEMPL_IPEDS_MED_DENTAL_IND, 
   PEBEMPL_ETAX_CONSENT_IND,
   PEBEMPL_NEW_HIRE_IND, 
   PEBEMPL_1095TX_CONSENT_IND, 
   PEBEMPL_ACTIVITY_DATE)
   values (p7, 
   'A',
   '1',
   decode(banner_cost_center,'','10090',banner_cost_center), 
   '1',
   decode(banner_cost_center,'','10090',banner_cost_center), 
   banner_ecls, 
   banner_lcat, 
   banner_bcat,
   to_date(p29,'YYYY-MM-DD'),
   decode(p28,'',to_date(p29,'YYYY-MM-DD'),to_date(p28,'YYYY-MM-DD')),
   sysdate, 
   to_date(p29,'YYYY-MM-DD'), 
   'N', -- swap?
   decode(p27,'','F',substr(p27,1,1)),
   'N', -- swap?
   'N', -- swap?
   'N', -- swap?
   'N', -- swap?
   'N', -- swap?
   'N', -- swap?
   'N', -- swap?
   p8);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   OPEN REF_CUR_OUT FOR
        SELECT DISTINCT p7 employee_pidm, return_code return_code, return_status return_status, return_object new_object from dual;
        
END;