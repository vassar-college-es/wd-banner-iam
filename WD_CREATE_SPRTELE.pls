create or replace PROCEDURE       WD_CREATE_SPRTELE (
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

   return_code varchar2(3) := '200';
   return_object varchar2(10) := 'SPRTELE';
   return_status varchar2(100) := 'success';
   
   pr_phone_device varchar2(2) := 'PR';
   
   validated_phone varchar2(7) := '';
   locate_phone_dash number;
   
   
BEGIN
   if p18 is not null then
   -- Work
   begin
   select instr(p18,'-') into locate_phone_dash from dual;
   end;
   if locate_phone_dash > 0 then
       validated_phone := substr(p18,1,3)||substr(p18,5,4);
   else
      validated_phone := substr(p18,1,3)||substr(p18,4,4);
   end if;
   
   begin
   insert into sprtele (sprtele_pidm, sprtele_seqno, sprtele_tele_code, sprtele_phone_area, sprtele_phone_number, sprtele_atyp_code, sprtele_addr_seqno, sprtele_primary_ind, sprtele_user_id, SPRTELE_ACTIVITY_DATE)
   values (p7, 1, 'SC', '845', validated_phone, 'SC', 1, null, 'WORKDAY', sysdate);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   validated_phone := '';
   end if;
   
   if p20 is not null then
   -- Home
   begin
   select instr(p20,'-') into locate_phone_dash from dual;
   end;
   if locate_phone_dash > 0 then
       validated_phone := substr(p20,1,3)||substr(p20,5,4);
   else
      validated_phone := substr(p20,1,3)||substr(p20,4,4);
   end if;
   
   if p41 = 'Mobile' then pr_phone_device := 'CP'; end if; 
   begin
   insert into sprtele (sprtele_pidm, sprtele_seqno, sprtele_tele_code, sprtele_phone_area, sprtele_phone_number, sprtele_atyp_code, sprtele_addr_seqno, sprtele_primary_ind, sprtele_user_id, SPRTELE_ACTIVITY_DATE)
   values (p7, 1, pr_phone_device, p19, validated_phone, 'PR', 1, 'Y', 'WORKDAY', sysdate);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   validated_phone := '';
   end if;
   
   
   if p43 is not null then
   -- Mobile (non primary)
   begin
   select instr(p43,'-') into locate_phone_dash from dual;
   end;
   if locate_phone_dash > 0 then
       validated_phone := substr(p43,1,3)||substr(p43,5,4);
   else
      validated_phone := substr(p43,1,3)||substr(p43,4,4);
   end if;
   
   begin
   insert into sprtele (sprtele_pidm, sprtele_seqno, sprtele_tele_code, sprtele_phone_area, sprtele_phone_number, sprtele_atyp_code, sprtele_addr_seqno, sprtele_primary_ind, sprtele_user_id, SPRTELE_ACTIVITY_DATE)
   values (p7, 1, 'CP', p42, validated_phone, 'PR', 2, null, 'WORKDAY', sysdate);
   exception when OTHERS then
      return_code := 401;
      return_status := SUBSTR(SQLERRM, 1, 100);
   commit;
   end;
   
   validated_phone := '';
   end if;
   
   OPEN REF_CUR_OUT FOR
        SELECT DISTINCT return_code return_code, return_status return_status, return_object new_object from dual;
        
END;