create or replace PROCEDURE       WD_EDIT_WD_WORKER_DATA (
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
   return_object varchar2(20) := 'WD_WORKER_DATA';
   return_status varchar2(100) := 'success';
   
   worker_data_update varchar2(500) := '';
   worker_data_set varchar2(2000) := '';
   worker_data_where varchar2(250) := '';
   
   worker_available_for_update varchar2(1) := 'N';
   
   worker_long_title varchar2(2000);
   
BEGIN

    if p0 = NULL then
      return_code := '401';
      return_status := 'No Banner PIDM provided';
    
    else
        -- does this employee exist in WD_WORKER_DATA
        begin
        select distinct 'Y' INTO worker_available_for_update from WD_WORKER_DATA where PIDM = p0;
        exception 
            when no_data_found then
                worker_available_for_update := 'N';
        end;
        if worker_available_for_update = 'Y' then
        
            if p22 != 'No Update' and p22 is not null then
                worker_data_set := worker_data_set || 'wd_job_title = ''' || replace(p22,'''','''''') || ''', ';
            end if;
            if p23 != 'No Update' and p23 is not null then
                worker_data_set := worker_data_set || 'wd_rank = ''' || p23 || ''', ';
            end if;
            if p33 != 'No Update' and p33 is not null  then
                worker_data_set := worker_data_set || 'wd_job_family = ''' || p33 || ''', ';
            end if;
            if p29 != 'No Update' and p29 is not null  then
                worker_data_set := worker_data_set || 'wd_cost_center = ''' || replace(p29,'''','''''') || ''', wd_cost_center_code = ''' || p36 || ''', ';
            end if;
            if p35 != 'No Update' and p35 is not null  then
                worker_data_set := worker_data_set || 'suffrage = ''' || p35 || ''', ';
            end if;
            if p32 != 'No Update' and p32 is not null  then
                worker_data_set := worker_data_set || 'wd_workspace = ''' || replace(p32,'''','''''') || ''', ';
            end if;
            if p37 != 'No Update' and p37 is not null  then
                worker_long_title := replace(p37,'''','''''');
                worker_data_set := worker_data_set || 'wd_appt_title = ''' || replace(worker_long_title,'''','''''') || ''', ';
            end if;
            if p38 != 'No Update' then
                worker_data_set := worker_data_set || 'wd_leave_start = ''' || p38 || ''', ';
            end if;
            if p40 != 'No Update' then
                worker_data_set := worker_data_set || 'wd_leave = ''' || p40 || ''', ';
            end if;
            if p44 != 'No Update' then
                worker_data_set := worker_data_set || 'wd_position_id = ''' || p44 || ''', ';
            end if;
            if p45 != 'No Update' then
                worker_data_set := worker_data_set || 'banner_position_id = ''' || p45 || ''', ';
            end if;
            
            if worker_data_set IS NOT NULL then -- something to update; proceed
            worker_data_set := worker_data_set || 'activity_date = sysdate';
            worker_data_where := 'wd_primary_job = ''Y'' and pidm = ' || p0;
   
            worker_data_update := 'UPDATE DAIES.WD_WORKER_DATA SET ' || worker_data_set || ' WHERE ' || worker_data_where;
            begin
              EXECUTE IMMEDIATE worker_data_update;
              exception
                when OTHERS then
                    return_code := '401';
                    return_status := SUBSTR(SQLERRM, 1, 100);
            end;
   
            OPEN REF_CUR_OUT FOR
                SELECT DISTINCT p0 employee_pidm, return_code return_code, return_status return_status, return_object replace_object from dual;
            end if;
            
            
        -- does not exist; let's add
        else
            worker_data_set := 'insert';
            begin 
              insert into WD_WORKER_DATA (PIDM,WD_JOB_TITLE,WD_RANK,WD_JOB_FAMILY,ACTIVITY_DATE, WD_COST_CENTER,WD_COST_CENTER_CODE,SUFFRAGE, WD_WORKSPACE, WD_APPT_TITLE, WD_POSITION_ID, WD_PRIMARY_JOB, BANNER_POSITION_ID)
              values
              (p0, decode(p22,'No Update',null,p22), decode(p23,'No Update',null,p23), decode(p33,'No Update',null,p33), sysdate, decode(p29,'No Update',null,replace(p29,'''','''''')), decode(p36,'No Update',null,p36), decode(p35,'No Update',null,p35),  
              decode(p32,'No Update',null,replace(p32,'''','''''')), decode(p37,'No Update',null,p37), decode(p44,'No Update',null,p44),'Y',decode(p45, 'No Update',null,p45)   );
              exception
                when OTHERS then
                return_code := '401';
                return_status := SUBSTR(SQLERRM, 1, 100);
            end;
            
            OPEN REF_CUR_OUT FOR
            SELECT DISTINCT p0 employee_pidm, return_code return_code, return_status return_status, return_object replace_object from dual;
            
          --  end if;
        
        end if;
    end if;
    

    if worker_data_set IS NULL then
    
      OPEN REF_CUR_OUT FOR
            SELECT DISTINCT p0 employee_pidm, '200' return_code, 'No Update' return_status, return_object replace_object  from dual;
    
    end if;
   
   
END;