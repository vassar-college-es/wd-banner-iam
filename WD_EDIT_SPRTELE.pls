create or replace PROCEDURE       WD_EDIT_sprtele (
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
   return_object varchar2(10) := 'SPRTELE';
   return_status varchar2(100) := 'No Update';
   
   sprtele_update varchar2(500) := '';
   sprtele_set varchar2(250) := '';
   sprtele_where varchar2(250) := '';
   
   work_phone varchar2(1) := 'N';
   home_phone varchar2(1) := 'N';
   home_phone_area varchar2(6) := '';
   mobile_phone_area varchar2(6) := '';
   non_primary_mobile_phone varchar2(1) := 'N';
   
   pr_phone_device varchar2(2) := 'PR';
   
   locate_phone_dash number;
   validated_phone varchar2(7) := '';
   
BEGIN

    if p0 = NULL then
      return_code := '401';
      return_status := 'No Banner PIDM provided';
    else
    
        -- WORK
        if p16 != 'No Update' then
            begin
               select instr(p16,'-') into locate_phone_dash from dual;
            end;
            if locate_phone_dash > 0 then
                validated_phone := substr(p16,1,3)||substr(p16,5,4);
            else
                validated_phone := substr(p16,1,3)||substr(p16,4,4);
            end if;
   
            return_status := 'success';
        -- does this employee  have a WORK phone in Banner
            begin
            select distinct 'Y' into work_phone
            from sprtele
            where sprtele_tele_code = 'SC' and sprtele_status_ind is null and sprtele_pidm = p0;
            exception
                when no_data_found then
                          work_phone := 'N';
            end;
            if work_phone = 'Y' then
                  sprtele_set := sprtele_set || 'sprtele_phone_number = ''' || validated_phone || ''', ';
                  sprtele_set := sprtele_set || 'sprtele_activity_date = sysdate';
                  sprtele_where := 'sprtele_tele_code = ''SC'' and sprtele_status_ind is null and sprtele_pidm = ' || p0;
   
                  sprtele_update := 'UPDATE sprtele SET ' || sprtele_set || ' WHERE ' || sprtele_where;
                  begin
                    EXECUTE IMMEDIATE sprtele_update;
                    exception
                      when OTHERS then
                        return_code := '401';
                        return_status := SUBSTR(SQLERRM, 1, 100);
                  end;
            else
                -- No SC Phone yet - let's add it
                begin
                    insert into sprtele (SPRTELE_PIDM, SPRTELE_SEQNO, SPRTELE_TELE_CODE, SPRTELE_ACTIVITY_DATE, SPRTELE_PHONE_AREA, SPRTELE_PHONE_NUMBER, SPRTELE_STATUS_IND,SPRTELE_DATA_ORIGIN, SPRTELE_USER_ID)
                    values (p0, (select (nvl(max(z.sprtele_seqno),0)+1) from sprtele z where z.sprtele_pidm = p0),
                    'SC', sysdate, '845', validated_phone, null, 'WORKDAY', 'WORKDAY');
                    exception when OTHERS then
                      return_code := 401;
                      return_status := SUBSTR(SQLERRM, 1, 100);
                    commit;
                end;
            end if;
        end if;
        
        sprtele_set := '';
        
        -- HOME
        if p18 != 'No Update' then
            if p17 != 'No Update' then home_phone_area := p17; end if;
        
            return_status := 'success';
        -- does this employee  have a HOME phone in Banner
            begin
            select distinct 'Y' into home_phone
            from sprtele
            where SPRTELE_ATYP_CODE = 'PR' and sprtele_status_ind is null and sprtele_pidm = p0;
            exception
                when no_data_found then
                          home_phone := 'N';
            end;
            if home_phone = 'Y' then
                  sprtele_set := sprtele_set || 'sprtele_phone_area = ''' || home_phone_area || ''', ';
                  sprtele_set := sprtele_set || 'sprtele_phone_number = ''' || p18 || ''', ';
                  sprtele_set := sprtele_set || 'sprtele_activity_date = sysdate';
                  sprtele_where := 'sprtele_atyp_code = ''PR'' and sprtele_status_ind is null and sprtele_pidm = ' || p0;
   
                  sprtele_update := 'UPDATE sprtele SET ' || sprtele_set || ' WHERE ' || sprtele_where;
                  begin
                    EXECUTE IMMEDIATE sprtele_update;
                    exception
                      when OTHERS then
                        return_code := '401';
                        return_status := SUBSTR(SQLERRM, 1, 100);
                  end;
            else
                -- No PR Phone yet - let's add it
                begin
                    insert into sprtele (SPRTELE_PIDM, SPRTELE_SEQNO, SPRTELE_TELE_CODE, SPRTELE_ACTIVITY_DATE, SPRTELE_PHONE_AREA, SPRTELE_PHONE_NUMBER, SPRTELE_STATUS_IND,SPRTELE_ATYP_CODE, SPRTELE_DATA_ORIGIN, SPRTELE_USER_ID)
                    values (p0, (select (nvl(max(z.sprtele_seqno),0)+1) from sprtele z where z.sprtele_pidm = p0),
                    'PR', sysdate, home_phone_area, p18, null, 'PR', 'WORKDAY', 'WORKDAY');
                    exception when OTHERS then
                      return_code := 401;
                      return_status := SUBSTR(SQLERRM, 1, 100);
                    commit;
                end;
            end if;
        end if;
        
        
        sprtele_set := '';
        
        -- HOME (device change)
        if p41 != 'No Update' and p18 = 'No Update' then
            return_status := 'success';
            
            if p41 = 'Mobile' then pr_phone_device := 'CP'; end if; 
            sprtele_set := sprtele_set || 'sprtele_tele_code = ''' || pr_phone_device || ''', ';
            sprtele_set := sprtele_set || 'sprtele_activity_date = sysdate';
            sprtele_where := 'sprtele_atyp_code = ''PR'' and sprtele_status_ind is null and sprtele_pidm = ' || p0;
   
            sprtele_update := 'UPDATE sprtele SET ' || sprtele_set || ' WHERE ' || sprtele_where;
            
            begin
              EXECUTE IMMEDIATE sprtele_update;
              exception
                  when OTHERS then
                      return_code := '401';
                      return_status := SUBSTR(SQLERRM, 1, 100);
            end;

        end if;
        
        
        sprtele_set := '';
        
        -- MOBILE (non-primary)
        if p43 != 'No Update' then
            if p42 != 'No Update' then mobile_phone_area := p42; end if;
        
            return_status := 'success';
        -- does this employee  have a non-primary Mobile phone in Banner
            begin
            select distinct 'Y' into non_primary_mobile_phone
            from sprtele
            where sprtele_tele_code = 'CP' and sprtele_status_ind is null and sprtele_primary_ind is null and sprtele_pidm = p0;
            exception
                when no_data_found then
                          non_primary_mobile_phone := 'N';
            end;
            if non_primary_mobile_phone = 'Y' then
                  sprtele_set := sprtele_set || 'sprtele_phone_area = ''' || mobile_phone_area || ''', ';
                  sprtele_set := sprtele_set || 'sprtele_phone_number = ''' || p43 || ''', ';
                  sprtele_set := sprtele_set || 'sprtele_activity_date = sysdate';
                  sprtele_where := 'sprtele_tele_code = ''CP'' and sprtele_primary_ind is null and sprtele_status_ind is null and sprtele_pidm = ' || p0;
   
                  sprtele_update := 'UPDATE sprtele SET ' || sprtele_set || ' WHERE ' || sprtele_where;
                  begin
                    EXECUTE IMMEDIATE sprtele_update;
                    exception
                      when OTHERS then
                        return_code := '401';
                        return_status := SUBSTR(SQLERRM, 1, 100);
                  end;
            else
                -- No non-primary CP Phone yet - let's add it
                begin
                    insert into sprtele (SPRTELE_PIDM, SPRTELE_SEQNO, SPRTELE_TELE_CODE, SPRTELE_ACTIVITY_DATE, SPRTELE_PHONE_AREA, SPRTELE_PHONE_NUMBER, SPRTELE_STATUS_IND,SPRTELE_DATA_ORIGIN, SPRTELE_USER_ID)
                    values (p0, (select (nvl(max(z.sprtele_seqno),0)+1) from sprtele z where z.sprtele_pidm = p0),
                    'CP', sysdate, mobile_phone_area, p43, null, 'WORKDAY', 'WORKDAY');
                    exception when OTHERS then
                      return_code := 401;
                      return_status := SUBSTR(SQLERRM, 1, 100);
                    commit;
                end;
            end if;

        end if;

        
   end if;
               
   OPEN REF_CUR_OUT FOR
       SELECT DISTINCT p0 employee_pidm, return_code return_code, return_status return_status, return_object replace_object from dual;
                  
   
END;