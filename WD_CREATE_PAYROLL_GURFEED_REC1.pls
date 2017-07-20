create or replace PROCEDURE       WD_CREATE_PAYROLL_GURFEED_REC1 (
   P0 IN     VARCHAR2 DEFAULT NULL,
   REF_CUR_OUT      OUT SYS_REFCURSOR)


AS
-- ref_cur_out : out REF_CURSOR
-- p0 : doc_code


   return_code varchar2(3) := '200';
   return_object varchar2(20) := 'GURFEED';
   return_status varchar2(100) := 'success';
   
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
    GURFEED_TRANS_DESC
    )
   values ('PAYROLL', 
   (select distinct max(gurfeed_system_time_stamp)
    from gurfeed
    where gurfeed_doc_code = p0), p0, 1, 0, 0, 0,
   sysdate, 'HEADER_RECORD', null, 
   (select distinct max(gurfeed_trans_date)
    from gurfeed
    where gurfeed_doc_code = p0),
    (select sum(gurfeed_trans_amt)
     from gurfeed
    where gurfeed_doc_code = p0),
    'Payroll Batch Header ' || (select distinct gurfeed_trans_desc
                                           from gurfeed
                                           where gurfeed_doc_code = p0)
   );
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   
/*   
insert into gurfeed (GURFEED_SYSTEM_ID, GURFEED_SYSTEM_TIME_STAMP, GURFEED_DOC_CODE, GURFEED_REC_TYPE, GURFEED_SUBMISSION_NUMBER, GURFEED_ITEM_NUM, GURFEED_SEQ_NUM, GURFEED_ACTIVITY_DATE, GURFEED_USER_ID,
    GURFEED_RUCL_CODE,GURFEED_TRANS_DATE,GURFEED_TRANS_AMT, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND,GURFEED_COAS_CODE, GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_BANK_CODE)
   values ('PAYROLL', (select to_char(sysdate,'YYYYMMDD') from dual), p0, 2, 0, 0, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed z where z.gurfeed_doc_code = p0),
   sysdate, 'WORKDAY', 'HNET', 
   (select distinct y.gurfeed_trans_date from gurfeed y where y.gurfeed_rucl_code = 'HNET' and y.gurfeed_doc_code = p0), 
   (select sum(y.gurfeed_trans_amt) from gurfeed y where y.gurfeed_rucl_code = 'HNET' and y.gurfeed_doc_code = p0), 
   (select distinct y.gurfeed_trans_desc from gurfeed y where y.gurfeed_rucl_code = 'HNET' and y.gurfeed_doc_code = p0), 
   (select distinct y.gurfeed_dr_cr_ind from gurfeed y where y.gurfeed_rucl_code = 'HNET' and y.gurfeed_doc_code = p0), 
   2, '1100', '', '2311', '', '3'
   );*/

 
   -- HNET rollup from Workday Detail

begin
       
insert into gurfeed (GURFEED_SYSTEM_ID, GURFEED_SYSTEM_TIME_STAMP, GURFEED_DOC_CODE, GURFEED_REC_TYPE, GURFEED_SUBMISSION_NUMBER, GURFEED_ITEM_NUM, GURFEED_ACTIVITY_DATE, GURFEED_USER_ID,
    GURFEED_RUCL_CODE,GURFEED_TRANS_DATE,GURFEED_TRANS_AMT, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND,GURFEED_COAS_CODE, GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_BANK_CODE,
    GURFEED_SEQ_NUM ) 
   (select a.a, a.b, a.c, a.d, a.e, a.f, a.h, a.i, a.j, a.k, a.l, a.m, a.n, a.otype, a.ptype, a.qtype, a.rtype, a.s, a.t, g+rownum from
(
select 'PAYROLL' a, (select to_char(sysdate,'YYYYMMDD') from dual) b, p0 c, 2 d, 0 e, 0 f, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed where gurfeed_doc_code = p0) g,
   sysdate h, 'WORKDAY' i, 'HNET' j, 
   (select distinct max(y.gurfeed_trans_date) from gurfeed y where y.gurfeed_rucl_code = 'HNET' and y.gurfeed_doc_code = p0) k, 
   sum(GURFEED_TRANS_AMT) l,   
 --  (select distinct y.gurfeed_trans_desc from gurfeed y where y.gurfeed_rucl_code = 'HNET' and y.gurfeed_doc_code = p0) m, 
 gurfeed_trans_desc m,
   --(select distinct y.gurfeed_dr_cr_ind from gurfeed y where y.gurfeed_rucl_code = 'HEEL' and y.gurfeed_doc_code = p0) n, 
   gurfeed_dr_cr_ind n,
   2 otype, '1100' ptype, '' qtype, '2311' rtype, '' s, '3' t
  from gurfeed a
  where gurfeed_rucl_code = 'HNET' and gurfeed_doc_code = p0
  group by GURFEED_FUND_CODE, GURFEED_ACCT_CODE, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND
) a);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   begin
   delete from gurfeed where gurfeed_doc_code = p0 and gurfeed_rucl_code = 'HNET' and gurfeed_coas_code = '1';
   commit;
   end;
   
   begin
   update gurfeed set gurfeed_coas_code = 1 where gurfeed_rucl_code = 'HNET'; 
   commit; 
   end;

   --
   --========================================================================================================
   -- HEEL rollup from Workday Detail (1/3)
   begin
   insert into gurfeed (GURFEED_SYSTEM_ID, GURFEED_SYSTEM_TIME_STAMP, GURFEED_DOC_CODE, GURFEED_REC_TYPE, GURFEED_SUBMISSION_NUMBER, GURFEED_ITEM_NUM, GURFEED_ACTIVITY_DATE, GURFEED_USER_ID,
    GURFEED_RUCL_CODE,GURFEED_TRANS_DATE,GURFEED_TRANS_AMT, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND,GURFEED_COAS_CODE, GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_BANK_CODE,
    GURFEED_SEQ_NUM ) 
   (select a.a, a.b, a.c, a.d, a.e, a.f, a.h, a.i, a.j, a.k, a.l, a.m, a.n, a.otype, a.ptype, a.qtype, a.rtype, a.s, a.t, g+rownum from
(
select 'PAYROLL' a, (select to_char(sysdate,'YYYYMMDD') from dual) b, p0 c, 2 d, 0 e, 0 f, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed where gurfeed_doc_code = p0) g,
   sysdate h, 'WORKDAY' i, 'HEEL' j, 
   (select distinct max(y.gurfeed_trans_date) from gurfeed y where y.gurfeed_rucl_code = 'HEEL' and y.gurfeed_doc_code = p0) k, 
   sum(GURFEED_TRANS_AMT) l,   
  -- (select distinct y.gurfeed_trans_desc from gurfeed y where y.gurfeed_rucl_code = 'HEEL' and y.gurfeed_doc_code = p0) m, 
  gurfeed_trans_desc m,
   --(select distinct y.gurfeed_dr_cr_ind from gurfeed y where y.gurfeed_rucl_code = 'HEEL' and y.gurfeed_doc_code = p0) n, 
   gurfeed_dr_cr_ind n,
   2 otype, GURFEED_FUND_CODE ptype, '' qtype, GURFEED_ACCT_CODE rtype, '' s, '3' t
  from gurfeed a
  where gurfeed_rucl_code = 'HEEL' and gurfeed_doc_code = p0
  and GURFEED_FUND_CODE in ('1100') and GURFEED_ACCT_CODE in  ('1351','1352','1359', '1362','1516','2141','2142','2151','2161','2162','2171','2211','2214','2215','2217','2219','2220','2227','21815','21825','21846','21890','21893','21910','21915','21920','21980')
  group by GURFEED_FUND_CODE, GURFEED_ACCT_CODE, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND
) a);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   begin
   delete from gurfeed where gurfeed_doc_code = p0 and gurfeed_rucl_code = 'HEEL' and gurfeed_coas_code = '1' and GURFEED_FUND_CODE = '1100' 
   and GURFEED_ACCT_CODE in  ('1351','1352','1359', '1362','1516','2141','2142','2151','2161','2162','2171','2211','2214','2215','2217','2219','2220','2227','21815','21825','21846','21890','21893','21910','21915','21920','21980');
   commit;
   end;
   
   begin
   update gurfeed set gurfeed_coas_code = 1 where gurfeed_rucl_code = 'HEEL';
   commit;
   end;
   --
   
      -- HEEL rollup from Workday Detail (2/3)
   begin
   insert into gurfeed (GURFEED_SYSTEM_ID, GURFEED_SYSTEM_TIME_STAMP, GURFEED_DOC_CODE, GURFEED_REC_TYPE, GURFEED_SUBMISSION_NUMBER, GURFEED_ITEM_NUM, GURFEED_ACTIVITY_DATE, GURFEED_USER_ID,
    GURFEED_RUCL_CODE,GURFEED_TRANS_DATE,GURFEED_TRANS_AMT, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND,GURFEED_COAS_CODE, GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_BANK_CODE,
    GURFEED_SEQ_NUM) 
   (select a.a, a.b, a.c, a.d, a.e, a.f, a.h, a.i, a.j, a.k, a.l, a.m, a.n, a.otype, a.ptype, a.qtype, a.rtype, a.s, a.t, g+rownum from
(
select 'PAYROLL' a, (select to_char(sysdate,'YYYYMMDD') from dual) b, p0 c, 2 d, 0 e, 0 f, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed where gurfeed_doc_code = p0) g,
   sysdate h, 'WORKDAY' i, 'HEEL' j, 
   (select distinct max(y.gurfeed_trans_date) from gurfeed y where y.gurfeed_rucl_code = 'HEEL' and y.gurfeed_doc_code = p0) k, 
   sum(GURFEED_TRANS_AMT) l,   
  -- (select distinct y.gurfeed_trans_desc from gurfeed y where y.gurfeed_rucl_code = 'HEEL' and y.gurfeed_doc_code = p0) m, 
  gurfeed_trans_desc m,
   --(select distinct y.gurfeed_dr_cr_ind from gurfeed y where y.gurfeed_rucl_code = 'HEEL' and y.gurfeed_doc_code = p0) n, 
   gurfeed_dr_cr_ind n,
   2 otype, GURFEED_FUND_CODE ptype, '' qtype, GURFEED_ACCT_CODE rtype, '' s, '3' t
  from gurfeed a
  where gurfeed_rucl_code = 'HEEL' and gurfeed_doc_code = p0
  and GURFEED_FUND_CODE in ('3C0024') and GURFEED_ACCT_CODE in  ('9100')
  group by GURFEED_FUND_CODE, GURFEED_ACCT_CODE, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND
) a);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   begin
   delete from gurfeed where gurfeed_doc_code = p0 and gurfeed_rucl_code = 'HEEL' and gurfeed_coas_code = '1' and GURFEED_FUND_CODE = '3C0024' and GURFEED_ACCT_CODE in  ('9100');
   commit;
   end;
   
   begin
   update gurfeed set gurfeed_coas_code = 1 where gurfeed_rucl_code = 'HEEL';
   commit;
   end;
   --
   
    -- HEEL rollup from Workday Detail (3/3)
   begin
   insert into gurfeed (GURFEED_SYSTEM_ID, GURFEED_SYSTEM_TIME_STAMP, GURFEED_DOC_CODE, GURFEED_REC_TYPE, GURFEED_SUBMISSION_NUMBER, GURFEED_ITEM_NUM, GURFEED_ACTIVITY_DATE, GURFEED_USER_ID,
    GURFEED_RUCL_CODE,GURFEED_TRANS_DATE,GURFEED_TRANS_AMT, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND,GURFEED_COAS_CODE, GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_BANK_CODE,
    GURFEED_SEQ_NUM ) 
   (select a.a, a.b, a.c, a.d, a.e, a.f, a.h, a.i, a.j, a.k, a.l, a.m, a.n, a.otype, a.ptype, a.qtype, a.rtype, a.s, a.t, g+rownum from
(
select 'PAYROLL' a, (select to_char(sysdate,'YYYYMMDD') from dual) b, p0 c, 2 d, 0 e, 0 f, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed where gurfeed_doc_code = p0) g,
   sysdate h, 'WORKDAY' i, 'HERL' j, 
   (select distinct max(y.gurfeed_trans_date) from gurfeed y where y.gurfeed_rucl_code = 'HERL' and y.gurfeed_doc_code = p0) k, 
   sum(GURFEED_TRANS_AMT) l,   
  -- (select distinct y.gurfeed_trans_desc from gurfeed y where y.gurfeed_rucl_code = 'HERL' and y.gurfeed_doc_code = p0) m, 
  gurfeed_trans_desc m,
   --(select distinct y.gurfeed_dr_cr_ind from gurfeed y where y.gurfeed_rucl_code = 'HERL' and y.gurfeed_doc_code = p0) n, 
   gurfeed_dr_cr_ind n,
   2 otype, GURFEED_FUND_CODE ptype, '' qtype, GURFEED_ACCT_CODE rtype, '' s, '3' t
  from gurfeed a
  where gurfeed_rucl_code = 'HERL' and gurfeed_doc_code = p0
  and GURFEED_FUND_CODE in ('1100','7C0007') and GURFEED_ORGN_CODE in ('20000','30570','30900','30670') 
  and GURFEED_ACCT_CODE in  ('5200','45150','45151','45152','45154','45155','45158','47601','63650')
  and GURFEED_PROG_CODE in ('10','99','50')
  group by GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND
) a);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   begin
   delete from gurfeed where gurfeed_doc_code = p0 and gurfeed_rucl_code = 'HEEL' and gurfeed_coas_code = '1' and GURFEED_FUND_CODE in ('1100','7C0007') 
   and GURFEED_ORGN_CODE in ('20000','30570','30900','30670') and GURFEED_ACCT_CODE in  ('5200','45150','45151','45152','45154','45155','45158','47601','63650') and GURFEED_PROG_CODE in ('10','99','50');
   commit;
   end;
   
   begin
   update gurfeed set gurfeed_coas_code = 1 where gurfeed_rucl_code = 'HEEL';
   commit;
   end;
   --

--========================================================================================================

   -- HERL rollup from Workday Detail 
   begin
   insert into gurfeed (GURFEED_SYSTEM_ID, GURFEED_SYSTEM_TIME_STAMP, GURFEED_DOC_CODE, GURFEED_REC_TYPE, GURFEED_SUBMISSION_NUMBER, GURFEED_ITEM_NUM, GURFEED_ACTIVITY_DATE, GURFEED_USER_ID,
    GURFEED_RUCL_CODE,GURFEED_TRANS_DATE,GURFEED_TRANS_AMT, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND,GURFEED_COAS_CODE, GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_BANK_CODE,
    GURFEED_SEQ_NUM ) 
   (select a.a, a.b, a.c, a.d, a.e, a.f, a.h, a.i, a.j, a.k, a.l, a.m, a.n, a.otype, a.ptype, a.qtype, a.rtype, a.s, a.t, g+rownum from
(
select 'PAYROLL' a, (select to_char(sysdate,'YYYYMMDD') from dual) b, p0 c, 2 d, 0 e, 0 f, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed where gurfeed_doc_code = p0) g,
   sysdate h, 'WORKDAY' i, 'HERL' j, 
   (select distinct max(y.gurfeed_trans_date) from gurfeed y where y.gurfeed_rucl_code = 'HERL' and y.gurfeed_doc_code = p0) k, 
   sum(GURFEED_TRANS_AMT) l,   
  -- (select distinct y.gurfeed_trans_desc from gurfeed y where y.gurfeed_rucl_code = 'HERL' and y.gurfeed_doc_code = p0) m, 
  gurfeed_trans_desc m,
  -- (select distinct y.gurfeed_dr_cr_ind from gurfeed y where y.gurfeed_rucl_code = 'HERL' and y.gurfeed_doc_code = p0) n, 
   gurfeed_dr_cr_ind n,
   2 otype, GURFEED_FUND_CODE ptype, '' qtype, GURFEED_ACCT_CODE rtype, '' s, '3' t
  from gurfeed a
  where gurfeed_rucl_code = 'HERL' and gurfeed_doc_code = p0
  and GURFEED_FUND_CODE in ('1100') and GURFEED_ACCT_CODE in  ('2143','2144','2163','21846','2201','2203','2205','2220')
  group by GURFEED_FUND_CODE, GURFEED_ACCT_CODE, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND
) a);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   begin
   delete from gurfeed where gurfeed_doc_code = p0 and gurfeed_rucl_code = 'HERL' and gurfeed_coas_code = '1' and GURFEED_FUND_CODE in ('1100') 
   and GURFEED_ACCT_CODE in  ('2143','2144','2163','21846','2201','2203','2205','2220');
   commit;
   end;
   
   begin
   update gurfeed set gurfeed_coas_code = 1 where gurfeed_rucl_code = 'HERL';
   commit;
   end;
   
   begin
   update gurfeed set gurfeed_acct_code = '2205' where gurfeed_rucl_code = 'HERL' and gurfeed_acct_code = '21816' and gurfeed_doc_code = p0;
   commit;
   end;


   --
    --========================================================================================================

   -- HGRB re-map
   begin
   update gurfeed set gurfeed_acct_code = '5851' where gurfeed_rucl_code = 'HGRB' and gurfeed_acct_code = '5857' and gurfeed_doc_code = p0;
   commit;
   end;
    begin
   update gurfeed set gurfeed_acct_code = '5825' where gurfeed_rucl_code = 'HGRB' and gurfeed_acct_code = '5826' and gurfeed_doc_code = p0;
   commit;
   end;

   --
  
  --==========================================================================================================
  -- Account 1/2/3/9 roll up

begin
insert into gurfeed (GURFEED_SYSTEM_ID, GURFEED_SYSTEM_TIME_STAMP, GURFEED_DOC_CODE, GURFEED_REC_TYPE, GURFEED_SUBMISSION_NUMBER, GURFEED_ITEM_NUM, GURFEED_ACTIVITY_DATE, GURFEED_USER_ID,
    GURFEED_RUCL_CODE,GURFEED_TRANS_DATE,GURFEED_TRANS_AMT, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND,GURFEED_COAS_CODE, GURFEED_FUND_CODE, GURFEED_ORGN_CODE, GURFEED_ACCT_CODE, GURFEED_PROG_CODE, GURFEED_BANK_CODE,
    GURFEED_SEQ_NUM ) 
(select a.a, a.b, a.c, a.d, a.e, a.f, a.h, a.i, a.j, a.k, a.l, a.m, a.n, a.otype, a.ptype, a.qtype, a.rtype, a.s, a.t, g+rownum from
(
select 'PAYROLL' a, (select to_char(sysdate,'YYYYMMDD') from dual) b, p0 c, 2 d, 0 e, 0 f, 
   (select  (nvl(max(gurfeed_seq_num),0)+1) from gurfeed where gurfeed_doc_code = p0) g,
   sysdate h, 'WORKDAY' i, gurfeed_rucl_code j, 
   (select distinct max(y.gurfeed_trans_date) from gurfeed y where y.gurfeed_doc_code = p0) k, 
   sum(GURFEED_TRANS_AMT) l,   
   --(select distinct y.gurfeed_trans_desc from gurfeed y where y.gurfeed_doc_code = p0 and gurfeed_rec_type = '2') m, 
   gurfeed_trans_desc m,
   --(select distinct y.gurfeed_dr_cr_ind from gurfeed y where y.gurfeed_doc_code = p0 and (GURFEED_ACCT_CODE like '1%' or GURFEED_ACCT_CODE like '2%' or GURFEED_ACCT_CODE like '3%' or GURFEED_ACCT_CODE like '9%')) n, 
   gurfeed_dr_cr_ind n,
   2 otype, GURFEED_FUND_CODE ptype, '' qtype, GURFEED_ACCT_CODE rtype, '' s, '3' t
  from gurfeed a
  where gurfeed_doc_code = p0
  and (GURFEED_ACCT_CODE like '1%' or GURFEED_ACCT_CODE like '2%' or GURFEED_ACCT_CODE like '3%' or GURFEED_ACCT_CODE like '9%')
  group by GURFEED_RUCL_CODE, GURFEED_FUND_CODE, GURFEED_ACCT_CODE, GURFEED_TRANS_DESC, GURFEED_DR_CR_IND
) a);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   begin
   delete from gurfeed where gurfeed_doc_code = p0 and gurfeed_coas_code = '1' and (GURFEED_ACCT_CODE like '1%' or GURFEED_ACCT_CODE like '2%' or GURFEED_ACCT_CODE like '3%' or GURFEED_ACCT_CODE like '9%')
;
   commit;
   end;
   
   begin
   update gurfeed set gurfeed_coas_code = 1 where (GURFEED_ACCT_CODE like '1%' or GURFEED_ACCT_CODE like '2%' or GURFEED_ACCT_CODE like '3%' or GURFEED_ACCT_CODE like '9%');
   commit;
   end;

  
  
  --==========================================================================================================
  

  
  
  
   
   OPEN REF_CUR_OUT FOR
        SELECT DISTINCT p0 doc_code, return_code return_code, return_status return_status, return_object new_object from dual;
        
END;