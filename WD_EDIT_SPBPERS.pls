create or replace PROCEDURE       WD_EDIT_SPBPERS (
        P0            IN     NUMBER DEFAULT NULL,
   P1 in varchar2 default 'No Update',
   P2 in varchar2 default 'No Update',
   P3 in VARCHAR2 default 'No Update',
   p4 in VARCHAR2 default 'No Update',
   p5 in VARCHAR2 default 'No Update',
   p6 in VARCHAR2 default 'No Update',
   p7 in VARCHAR2 default 'No Update',
   p8 in VARCHAR2 default 'No Update',
   p9 in VARCHAR2 default 'No Update',
   p10 in VARCHAR2 default 'No Update',
   p11 in VARCHAR2 default 'No Update',
   p12 in VARCHAR2 default 'No Update',
   p13 in VARCHAR2 default 'No Update',
   p14 in VARCHAR2 default 'No Update',
   p15 in VARCHAR2 default 'No Update',
   p16 in VARCHAR2 default 'No Update',
   p17 in VARCHAR2 default 'No Update',
   p18 in VARCHAR2 default 'No Update',
   p19 in VARCHAR2 default 'No Update',
   p20 in VARCHAR2 default 'No Update',
   p21 in VARCHAR2 default 'No Update',
   p22 in VARCHAR2 default 'No Update',
   p23 in VARCHAR2 default 'No Update',
   p24 in VARCHAR2 default 'No Update',
   p25 in VARCHAR2 default 'No Update',
   p26 in VARCHAR2 default 'No Update',
   p27 in VARCHAR2 default 'No Update',
   p28 in VARCHAR2 default 'No Update',
   p29 in VARCHAR2 default 'No Update',
   p30 in VARCHAR2 default 'No Update',
   p31 in VARCHAR2 default 'No Update',
   p32 in VARCHAR2 default 'No Update',
   p33 in VARCHAR2 default 'No Update',   
   p34 in VARCHAR2 default 'No Update',   
   p35 in varchar2 default 'No Update',
   p36 in varchar2 default 'No Update',
   p37 in varchar2 default 'No Update',
   p38 in varchar2 default 'No Update',
   p39 in varchar2 default 'No Update',
   p40 in varchar2 default 'No Update',
   p41 in varchar2 default 'No Update',
   p42 in varchar2 default 'No Update',
   p43 in varchar2 default 'No Update',
   p44 in varchar2 default 'No Update',
   p45 in varchar2 default 'No Update',
   p46 in varchar2 default 'No Update',
   p47 in varchar2 default 'No Update',
   
   REF_CUR_OUT      OUT SYS_REFCURSOR)


AS
-- ref_cur_out : out REF_CURSOR
-- p0 : {vassar pidm}
-- p1 : /ethnicity
-- p2 : /gender
-- p3 : /marital_status
-- p4 : /ssn
-- p5 : /veteran_status
-- p6 : /date_of_birth
-- p7 : /deceased_status
-- p8 : /citizienship_status
-- p9 : /first_name
-- p10 : /last_name
-- p11 : /middle_initial
-- p12 : /prefix
-- p13 : /suffix
-- p14 : /confidentiality_status
-- p15 : /address/work/street_line_1
-- p16 : /phone/work/phone_number
-- p17 : /phone/home/phone_area
-- p18 : /phone/home/phone_number
-- p19 : /email/work/email_address
-- p20 : /email/home/email_address
-- p21 : /job_profile
-- p22 : /job_title
-- p23 : /rank
-- p24 : /job_status
-- p25 : /current_hire_date
-- p26 : /original_hire_date
-- p27 : /service_years
-- p28 : /last_day_of_work
-- p29 : /cost_center
-- p30 : /supervisory_org
-- p31 : /employment_status
-- p32 : /workspace
-- p33 : /job_family
-- p34 : /job_family_group
-- p35 : /suffrage_status
-- p36 : /cost_center_code
-- p37 : /appt_title
-- p38 : /absence_start
-- p39 : /absence_end
-- p40 : /absence_state
-- p41 : /phone/home/phone_type
-- p42 : /phone/mobile/phone_area
-- p43 : /phone/mobile/phone_number
-- p44 : /position_id
-- p45 : /banner_position
-- p46 : /worker_type
-- p47 : /worker_worker_id



   return_code varchar2(3) := '200';
   return_object varchar2(10) := 'SPBPERS';
   return_status varchar2(100) := 'success';
   
   spbpers_update varchar2(500) := '';
   spbpers_set varchar2(250) := '';
   spbpers_where varchar2(250) := '';
   
   banner_gender varchar2(1) := '';
   
BEGIN

    if p0 = NULL then
      return_code := '401';
      return_status := 'No Banner PIDM provided';
    
    else
    
    
        if p1 != 'No Update' then
          spbpers_set := spbpers_set || 'spbpers_ethn_code = ''' || substr(p1,1,1) || ''', ';
        end if;
    
        if p6 != 'No Update' then
          spbpers_set := spbpers_set || 'spbpers_birth_date = ''' || to_char(to_DATE(p6,'YYYY-MM-DD'),'DD-MON-YYYY') || ''', ';
        end if;
    
        if p4 != 'No Update' then
          spbpers_set := spbpers_set || 'spbpers_ssn = ' || p4 || ', ';
        end if;
    
        if p5 != 'No Update' then
          spbpers_set := spbpers_set || 'spbpers_armed_serv_med_vet_ind = ''Y'', ';
        end if;

        if p2 != 'No Update' then
          if substr(p2,1,1) = 'U' then banner_gender := 'N'; else banner_gender := substr(p2,1,1); end if;
          spbpers_set := spbpers_set || 'spbpers_sex = ''' || banner_gender || ''', ';
        end if;

        if p3 != 'No Update' then
          if substr(p3,1,1) = 'P' then
            spbpers_set := spbpers_set || 'spbpers_mrtl_code = ''L'', ';
          else
            spbpers_set := spbpers_set || 'spbpers_mrtl_code = ''' || substr(p3,1,1) || ''', ';
          end if;
        end if;
        
        if p12 != 'No Update' then
          spbpers_set := spbpers_set || 'spbpers_name_prefix = ''' || p12 || ''', ';
        end if;
        
        if p13 != 'No Update' then
          spbpers_set := spbpers_set || 'spbpers_name_suffix = ''' || p13 || ''', ';
        end if;
        
        if p14 != 'No Update' then
          if p14 = 'null' then
              spbpers_set := spbpers_set || 'spbpers_confid_ind = '''', ';
          else
              spbpers_set := spbpers_set || 'spbpers_confid_ind = ''Y'', ';
          end if;
        end if;
        
    end if;
    
    if spbpers_set IS NOT NULL then -- something to update; proceed
      spbpers_set := spbpers_set || 'spbpers_activity_date = sysdate';
      spbpers_where := 'spbpers_pidm = ' || p0;
   
      spbpers_update := 'UPDATE spbpers SET ' || spbpers_set || ' WHERE ' || spbpers_where;
      begin
      EXECUTE IMMEDIATE spbpers_update;
      exception
         when OTHERS then
            return_code := '401';
            return_status := SUBSTR(SQLERRM, 1, 100);
      end;
   
      OPEN REF_CUR_OUT FOR
            SELECT DISTINCT p0 employee_pidm, return_code return_code, return_status return_status, return_object replace_object from dual;
   
    else
      OPEN REF_CUR_OUT FOR
            SELECT DISTINCT p0 employee_pidm, '200' return_code, 'No Update' return_status, return_object replace_object  from dual;
    
    end if;
   
   
END;