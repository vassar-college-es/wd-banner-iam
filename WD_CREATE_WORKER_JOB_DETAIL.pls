create or replace PROCEDURE       WD_CREATE_WORKER_JOB_DETAIL (
   P0            IN     VARCHAR2 DEFAULT NULL,
   P1 IN VARCHAR2 DEFAULT NULL,
   P2 IN VARCHAR2 DEFAULT NULL,
   P3 IN VARCHAR2 DEFAULT NULL,
   P4 IN VARCHAR2 DEFAULT NULL,
   P5 IN VARCHAR2 DEFAULT NULL,
   P6 IN VARCHAR2 DEFAULT NULL,
   P7 IN VARCHAR2 DEFAULT NULL,
   P8 IN VARCHAR2 DEFAULT NULL,
   P9 IN VARCHAR2 DEFAULT NULL,
   
    
   REF_CUR_OUT      OUT SYS_REFCURSOR)


AS
-- ref_cur_out : out REF_CURSOR

-- p0 : worker
-- p1 : position_id
-- p2 : job title
-- p3 : cost center
-- p4 : cost center code
-- p5 : rank
-- p6 : job_profile
-- p7 : job_family
-- p8 : long title
-- p9 : banner position id


   return_code varchar2(3) := '200';
   return_object varchar2(20) := 'WD_WORKER_DATA';
   return_status varchar2(100) := 'success';
   
   worker_banner_pidm goradid.goradid_pidm%TYPE := '';
   
   
BEGIN

  
   begin
        select distinct goradid_pidm INTO worker_banner_pidm from goradid where goradid_additional_id = p0;
        exception
            when no_data_found then
                worker_banner_pidm := '987123';              
   end;
   
   -- remove previous additional data 
   begin
      delete from WD_WORKER_DATA where wd_primary_job is null and pidm = worker_banner_pidm and wd_position_id = p1;
      commit;
   end;
   
   if p7 != 'Academic Year' then
   begin
   insert into wd_worker_data (pidm, wd_job_title, wd_position_id, wd_cost_center, wd_cost_center_code ,wd_job_family, activity_date)
   values (worker_banner_pidm, p2, p1, p3, p4, p7, sysdate);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   end if;
   
   
   OPEN REF_CUR_OUT FOR
        SELECT DISTINCT p0 worker_id, p1 position_id, return_code return_code, return_status return_status, return_object new_object from dual;
        
END;