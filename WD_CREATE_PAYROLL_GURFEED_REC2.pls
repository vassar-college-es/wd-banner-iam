create or replace PROCEDURE       WD_CREATE_PAYROLL_GURFEED_REC2 (
   P2 IN VARCHAR2 DEFAULT NULL,
   P3 IN VARCHAR2 DEFAULT NULL,
   P4 IN VARCHAR2 DEFAULT NULL,
   P5 IN VARCHAR2 DEFAULT NULL,
   P6 IN VARCHAR2 DEFAULT NULL,
   P7 IN VARCHAR2 DEFAULT NULL,
   P8 IN VARCHAR2 DEFAULT NULL,
   P9 IN VARCHAR2 DEFAULT NULL,
   P10 IN VARCHAR2 DEFAULT NULL,
   P11 IN VARCHAR2 DEFAULT NULL,
   REF_CUR_OUT      OUT SYS_REFCURSOR)


AS
-- ref_cur_out : out REF_CURSOR
-- p2 : rucl_code
-- p3 : trans_amt
-- p4 : trans_desc
-- p5 : dr_cr
-- p6 : fund
-- p7 : org
-- p8 : acct
-- p9 : prog
-- p10 : trans_date
-- p11 : pipe ruuid


   return_code varchar2(3) := '200';
   return_object varchar2(20) := 'GURFEED';
   return_status varchar2(100) := 'success';
   
   bypass_gurfeed boolean;
BEGIN

   begin
   insert into gurfeed (
    GURFEED_SYSTEM_ID,
    GURFEED_SYSTEM_TIME_STAMP,
    GURFEED_DOC_CODE,
    GURFEED_REC_TYPE,
    GURFEED_SUBMISSION_NUMBER,
    GURFEED_ITEM_NUM,
    GURFEED_SEQ_NUM,
    GURFEED_ACTIVITY_DATE,
    GURFEED_USER_ID,
    GURFEED_RUCL_CODE,
    GURFEED_TRANS_DATE,
    GURFEED_TRANS_AMT,
    GURFEED_TRANS_DESC,
    GURFEED_DR_CR_IND,
    GURFEED_COAS_CODE,
    GURFEED_FUND_CODE,
    GURFEED_ORGN_CODE, 
    GURFEED_ACCT_CODE,  
    GURFEED_PROG_CODE,
    GURFEED_BANK_CODE
    )
   values ('PAYROLL', (select to_char(sysdate,'YYYYMMDD') from dual), upper('WD'||substr(p11,1,6)), 2, 0, 0, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed z where z.gurfeed_doc_code = upper('WD'||substr(p11,1,6))),
   sysdate, 'WORKDAY', p2, p10, p3, p4, p5, 1,
   p6, p7, p8, decode(p9,'0',null,p9), '3'
   );
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
      
   OPEN REF_CUR_OUT FOR
        SELECT DISTINCT upper('WD'||substr(p11,1,6)) doc_code, return_code return_code, return_status return_status, return_object new_object from dual;
        
END;