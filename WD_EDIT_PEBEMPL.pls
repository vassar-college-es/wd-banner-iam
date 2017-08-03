create or replace PROCEDURE       WD_EDIT_pebempl (
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
   return_object varchar2(10) := 'PEBEMPL';
   return_status varchar2(100) := 'success';
   
   pebempl_update varchar2(500) := '';
   pebempl_set varchar2(500) := '';
   pebempl_where varchar2(250) := '';
   
   banner_ecls    PEBEMPL.PEBEMPL_ECLS_CODE%TYPE := '';
   banner_lcat    PEBEMPL.PEBEMPL_LCAT_CODE%TYPE := '';
   banner_bcat   PEBEMPL.PEBEMPL_BCAT_CODE%TYPE := '';
   
   banner_empl_status varchar2(1) := '';
   
   banner_cost_center varchar2(6) := '';
   wd_posn varchar2(9) := '';
  
   existing_pidm number := 0;

   new_pebempl_ref_cursor sys_refcursor;
   
BEGIN

    if p0 = NULL then
      return_code := '401';
      return_status := 'No Banner PIDM provided';
    
    else
       -- Existing PEBEMPL to update?
       begin
         select count(pebempl_pidm) INTO existing_pidm from pebempl where pebempl_pidm = p0;
       end;
       if existing_pidm > 0 then
    
            if p31 != 'No Update' then
                  if substr(p31,1,1) = 'O' then
                      banner_empl_status := 'L';
                else
                      banner_empl_status := substr(p31,1,1);
                end if;
            
                  pebempl_set := pebempl_set || 'pebempl_empl_status = ''' || banner_empl_status || ''', ';
                  -- remove WEID from Banner if a Terminated Job
                  if substr(p31,1,1) = 'T' then
                  begin
                    delete from goradid where goradid_adid_code = 'WEID' and goradid_pidm = p0;
                  end;
                  commit;
                  end if;
            end if;
       
            if p24 != 'No Update' then
                  pebempl_set := pebempl_set || 'pebempl_internal_ft_pt_ind = ''' || substr(p24,1,1) || ''', ';
            end if;
       
            if p36 != 'No Update' then
                    banner_cost_center := p36;
                    if p36 in ('CC8001', 'CC8002', 'CC8003', 'CC8004', 'CC8005', 'CC8006') then
                        banner_cost_center := 'CC8000';
                    end if;
                    if p36 in ('CC3031', 'CC3032', 'CC3033', 'CC3034', 'CC3035', 'CC3036', 'CC3037', 'CC3038', 'CC3039', 'CC3040', 'CC3041', 'CC3042', 'CC3043', 'CC3044', 'CC3045', 'CC3046', 'CC3047') then
                        banner_cost_center := 'CC3030';
                    end if;
                    if p36 in ('CC5011', 'CC5012', 'CC5013', 'CC5014', 'CC5015', 'CC5016', 'CC5017', 'CC5018', 'CC5019', 'CC5020') then
                        banner_cost_center := 'CC5000';
                    end if;
                    pebempl_set := pebempl_set || 'pebempl_orgn_code_home = ''' || banner_cost_center || ''', pebempl_orgn_code_dist = ''' || banner_cost_center || ''', ';
            end if;
       
            if p25 != 'No Update' then
                  pebempl_set := pebempl_set || 'pebempl_current_hire_date = ''' || to_date(p25,'YYYY-MM-DD') || ''', ';
            end if;
       
            if p33 != 'No Update' then
                  case 
                  when p33 like '%Adminstration%' then banner_ecls := 'AD';
                  when p33 like '%Faculty%' then banner_ecls := 'FA';
                  when p33 like '%Service%' then banner_ecls := 'SE';
                  when p33 like '%Staff%' then banner_ecls := 'CL';
                  when p33 like '%Student%' then banner_ecls := 'ST';
                  when p33 like '%Temp%' then banner_ecls := 'CN';
                  when p33 like '%Call%' then banner_ecls := 'SN';
                  else banner_ecls := 'AD'; 
                  end case;
            end if;
       
            if p46 like '%Contingent%' then
                  banner_ecls := 'ZA';
            end if;
       
            if banner_ecls is not null then
                pebempl_set := pebempl_set || 'pebempl_ecls_code = ''' || banner_ecls || ''', ';
            end if;
            
            if p28 != 'No Update' then
                      if p28 = 'null' then
                      pebempl_set := pebempl_set || 'pebempl_last_work_date = null, ';
                      else
                          if substr(p31,1,1) = 'T' then
                              pebempl_set := pebempl_set || 'pebempl_last_work_date = ''' || to_date(p28,'YYYY-MM-DD') || ''', ';
                          end if;
                      end if;
            end if;
    

          if pebempl_set IS NOT NULL then -- something to update; proceed
            pebempl_set := pebempl_set || 'pebempl_user_id = ''WORKDAY'', pebempl_activity_date = sysdate';
            pebempl_where := 'pebempl_pidm = ' || p0;
   
            pebempl_update := 'UPDATE pebempl SET ' || pebempl_set || ' WHERE ' || pebempl_where;
            begin
            EXECUTE IMMEDIATE pebempl_update;
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
   
     else /* No Existing PEBEMPL - let's add */
      
        if p36 = 'No Update' then banner_cost_center := null; else banner_cost_center := p36; end if;
        if p44 = 'No Update' then wd_posn := null; else wd_posn := p44; end if;

        daies.wd_create_pebempl(p7=>to_char(p0), p8=>sysdate, p23=>p33, p27=>p24, p28=>p25, p29=>p26, p38=>banner_cost_center, p44=>wd_posn, p46=>p46, REF_CUR_OUT=>new_pebempl_ref_cursor);
        ref_cur_out := new_pebempl_ref_cursor;
     end if;
     
     end if;
END;