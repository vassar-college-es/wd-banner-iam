create or replace PROCEDURE       WD_CREATE_SPBPERS (
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

   banner_mrtl_code varchar2(1) := '';
   banner_gend_code varchar2(1) := '';
   banner_confid_code varchar2(1) := '';
   banner_citz_ind varchar2(1) := '';
   banner_vet_code varchar2(1) := 'N';
   banner_citz_code  varchar2(1) := '';
   
   return_code varchar2(3) := '200';
   return_object varchar2(10) := 'SPBPERS';
   return_status varchar2(100) := 'success';
   
BEGIN

   -- Banner Ethnicity
   
   -- Banner Marital Status
   if substr(p11,1,1) = 'P' then
        banner_mrtl_code := 'L';
   else
        begin
          select nvl(substr(p11,1,1),'') into banner_mrtl_code from dual;
        end ;
   end if;
   -- Banner Gender
   begin
   select nvl(substr(p13,1,1),'') into banner_gend_code from dual;
   end ;
   -- Banner  Confid Status
   if p15 is not null then
         banner_confid_code := 'Y';
   end if;
   -- Banner Citizenship
   if p14 is not null then
         banner_citz_ind := 'Y';
         case
            when p14 like '%Citizen%' then banner_citz_code := 'Y';
            when p14 like '%Non-Citizen%' then banner_citz_code := 'N';
            when p14 like '%Perman%' then banner_citz_code := 'P';
            when p14 like '%Temp%' then banner_citz_code := 'N';
            when p14 like '%Visit%' then banner_citz_code := 'N';
            else banner_citz_code := 'Y';
         end case;      
   end if;
   
   -- Banner Service Vet
      if p5 is not null then
         banner_vet_code := 'Y';
   end if;
   
   
   begin
   insert into spbpers (spbpers_pidm, SPBPERS_SSN, SPBPERS_BIRTH_DATE, SPBPERS_ETHN_CODE, SPBPERS_MRTL_CODE, SPBPERS_SEX, SPBPERS_CONFID_IND, SPBPERS_CITZ_IND, SPBPERS_CITZ_CODE, SPBPERS_ACTIVITY_DATE, SPBPERS_ARMED_SERV_MED_VET_IND, SPBPERS_DATA_ORIGIN)
   values (p7, p4, p1, '', banner_mrtl_code, banner_gend_code, banner_confid_code, banner_citz_ind, banner_citz_code, p8, banner_vet_code, 'WORKDAY');
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   OPEN REF_CUR_OUT FOR
        SELECT DISTINCT return_code return_code, return_status return_status, return_object new_object from dual;
        
END;