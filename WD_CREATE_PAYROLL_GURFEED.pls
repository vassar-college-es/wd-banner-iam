create or replace PROCEDURE       WD_CREATE_PAYROLL_GURFEED (
   P0 IN     VARCHAR2 DEFAULT NULL,
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
-- p0 : system tinestamp
-- p1 : rec_type
-- p2 : recl_code
-- p3 : trans_amt
-- p4 : trans_desc
-- p5 : dr_cr
-- p6 : fund
-- p7 : org
-- p8 : acct
-- p9 : prog


   return_code varchar2(3) := '200';
   return_object varchar2(20) := 'GURFEED';
   return_status varchar2(100) := 'success';
   
BEGIN

   /*begin
   insert into goradid (goradid_pidm, goradid_additional_id, goradid_adid_code, goradid_user_id, GORADID_DATA_ORIGIN, GORADID_ACTIVITY_DATE)
   values (p7, p36, 'WEID', 'WD_EMPL_ID', 'WORKDAY', sysdate);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   */
   
   OPEN REF_CUR_OUT FOR
        SELECT DISTINCT return_code return_code, return_status return_status, return_object new_object from dual;
        
END;