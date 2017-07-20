create or replace PROCEDURE       WD_EDIT_goremal (
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
   return_object varchar2(10) := 'GOREMAL';
   return_status varchar2(100) := 'success';
   
   goremal_update varchar2(500) := '';
   goremal_set varchar2(250) := '';
   goremal_where varchar2(250) := '';
   
   pers_email varchar2(1) := '';
   
BEGIN

    if p0 = NULL then
      return_code := '401';
      return_status := 'No Banner PIDM provided';
    else
    
        if p20 != 'No Update' then
            -- does this employee  have a PERS email in Banner
            begin
            select distinct 'Y' into pers_email
            from goremal
            where goremal_emal_code = 'PERS' and goremal_status_ind = 'A' and goremal_pidm = p0;
            exception
                when no_data_found then
                          pers_email := 'N';
            end;
            if pers_email = 'Y' then
                goremal_set := goremal_set || 'goremal_email_address = ''' || p20 || ''', ';
                goremal_set := goremal_set || 'goremal_activity_date = sysdate, ';
                goremal_set := goremal_set || 'goremal_preferred_ind = ''Y'' ';

                goremal_where := 'goremal_emal_code = ''PERS'' and goremal_status_ind = ''A'' and goremal_pidm = ' || p0;
   
                goremal_update := 'UPDATE goremal SET ' || goremal_set || ' WHERE ' || goremal_where;
                begin
                  EXECUTE IMMEDIATE goremal_update;
                  exception
                    when OTHERS then
                      return_code := '401';
                      return_status := SUBSTR(SQLERRM, 1, 100);
                end;
            else
                -- No PERS Email yet - let's add it
                begin
                    insert into goremal (goremal_pidm, goremal_emal_code, goremal_email_address, goremal_status_ind, goremal_preferred_ind, GOREMAL_USER_ID, GOREMAL_DISP_WEB_IND, GOREMAL_ACTIVITY_DATE)
                    values (p0, 'PERS', p20, 'A', 'Y', 'WORKDAY', 'N', sysdate);
                    exception when OTHERS then
                      return_code := 401;
                      return_status := SUBSTR(SQLERRM, 1, 100);
                    commit;
                end;
            end if;
             OPEN REF_CUR_OUT FOR
                  SELECT DISTINCT p0 employee_pidm, return_code return_code, return_status return_status, return_object replace_object from dual;
        else
            OPEN REF_CUR_OUT FOR
            SELECT DISTINCT p0 employee_pidm, '200' return_code, 'No Update' return_status, return_object replace_object  from dual;
        end if;
    end if;   
   
END;