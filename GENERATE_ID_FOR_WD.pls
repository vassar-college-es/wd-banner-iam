create or replace PROCEDURE generate_id_for_wd (p0 in VARCHAR2 DEFAULT NULL,  p1 in varchar2 default null, p2 in varchar2 default null, p3 in varchar2 default null, p4 in varchar2 default null, REF_CUR_OUT OUT SYS_REFCURSOR)
AS
-- p0 : newhire ssn
-- p1 : first name
-- p2 : last_name
-- p3 : dob
-- p4 : banner id
-- ref_cur_out : out REF_CURSOR

/* 
baninst1.gb_common.f_generate_pidm
baninst1.gb_common.f_generate_id
GORADID - reference IDs
*/


/* Sample Response 
{
	"recruit": [{
			"recruit_wd_empl_id": "P123",
			"recruit_name": "Mark Jackson",
			"recruit_vassar_id": "999132228",
			"recruit_vassar_pidm": 12345678,
			"return_code": 200,
			"return_status": "hire created"
		}, {
			"recruit_wd_empl_id": "P456",
			"recruit_name": "Joe Smith",
			"recruit_vassar_id": null,
			"recruit_vassar_pidm": null,
			"return_code": 310,
			"return_status": "hire may exist"
		}, {
			"recruit_wd_empl_id": "P789",
			"recruit_name": "Sam Jones",
			"recruit_vassar_id": null,
			"recruit_vassar_pidm": null,
			"return_code": 311,
			"return_status": "hire exists"
		}

	]
}
*/


rtn_code_1 number := 200; -- success (new id/pidm)
rtn_mess_1 varchar2(75) := 'hire created';
rtn_code_2 number := 310; -- hire may exist
rtn_mess_2 varchar2(75) := 'hire may exist';
rtn_code_3 number := 311; -- hire exists
rtn_mess_3 varchar2(75) := 'hire exists';

l_ssn spbpers.spbpers_ssn%TYPE := '';
l_id spriden.spriden_id%TYPE := '';
l_pidm spriden.spriden_pidm%TYPE := '';
l_first_name spriden.spriden_first_name%TYPE := '';
l_last_name spriden.spriden_last_name%TYPE := '';
--l_dob spbpers.spbpers_birth_date%TYPE := '';
l_dob varchar2(10) := '';
l_vasr_email GOREMAL.GOREMAL_EMAIL_ADDRESS%TYPE := '';


search_result BOOLEAN := false;

begin

    /* check SSN match */
    begin
    select distinct a.spbpers_ssn, a.spbpers_pidm, b.spriden_id, b.spriden_first_name, b.spriden_last_name, a.spbpers_birth_date, c.GOREMAL_EMAIL_ADDRESS INTO l_ssn, l_pidm, l_id, l_first_name, l_last_name, l_dob, l_vasr_email
    from spriden b, spbpers a, goremal c
    where 
    b.spriden_pidm = a.spbpers_pidm and b.spriden_pidm = c.goremal_pidm(+) and c.goremal_emal_code(+) = 'VASR'
    and  p0 = a.spbpers_ssn and b.spriden_change_ind is null 
    and rownum < 2
    ;
    exception when
      no_data_found then
        l_ssn := '';
    end;
    
    /* SSN match : TRUE */
    if l_ssn is not null then
    search_result := true;
    begin
    OPEN REF_CUR_OUT FOR
    select 
    l_first_name || ' ' || l_last_name recruit_name,
    l_first_name recruit_first_name,
    l_last_name recruit_last_name,
    l_dob recruit_dob,
    l_ssn recruit_ssn,
    l_id recruit_vassar_id,
    l_pidm recruit_vassar_pidm,
    l_vasr_email recruit_vassar_email,
    rtn_code_3 return_code, rtn_mess_3 return_status,
    sysdate activity_date
    from dual;
    end;
    end if;
    
    /* ==================== */
    
    if search_result = false then
    /* check Banner ID match */
    begin
    select distinct a.spbpers_ssn, a.spbpers_pidm, b.spriden_id, b.spriden_first_name, b.spriden_last_name, a.spbpers_birth_date, c.GOREMAL_EMAIL_ADDRESS INTO l_ssn, l_pidm, l_id, l_first_name, l_last_name, l_dob, l_vasr_email
    from spriden b, spbpers a, goremal c
    where 
    b.spriden_pidm = a.spbpers_pidm(+) and b.spriden_pidm = c.goremal_pidm(+) and c.goremal_emal_code(+) = 'VASR'
    and  p4 = b.spriden_id and b.spriden_change_ind is null 
    and rownum < 2
    ;
    exception when
      no_data_found then
        l_id := '';
    end;
    
        /* Banner ID match : TRUE */
    if l_id is not null then
    search_result := true;
    begin
    OPEN REF_CUR_OUT FOR
    select 
    l_first_name || ' ' || l_last_name recruit_name,
    l_first_name recruit_first_name,
    l_last_name recruit_last_name,
    l_dob recruit_dob,
    l_ssn recruit_ssn,
    l_id recruit_vassar_id,
    l_pidm recruit_vassar_pidm,
    l_vasr_email recruit_vassar_email,
    rtn_code_3 return_code, rtn_mess_3 return_status,
    sysdate activity_date
    from dual;
    end;
    end if;
    
    end if;
    /* =========================== */
        
    if search_result = false then
    /* check NAME/DOB match */
    begin
    select distinct a.spbpers_ssn, a.spbpers_pidm, b.spriden_id, b.spriden_first_name, b.spriden_last_name  INTO l_ssn, l_pidm, l_id, l_first_name, l_last_name
    from spriden b, spbpers a
    where 
    b.spriden_pidm = a.spbpers_pidm and b.spriden_change_ind is null
    and  p1 = b.spriden_first_name and p3 /*to_char(to_date(p3,'DD-MON-YYYY','DD-MON-YYYY'))*/ =  to_char(a.spbpers_birth_date,'YYYY-MM-DD')
    ;
    exception 
      when no_data_found then
         l_pidm := '';
      when too_many_rows then
         l_pidm := 1;
         l_id := 1;
    end;
    
    /* NAME/DOB match : TRUE */
    if l_pidm is not null then
    search_result := true;
    l_first_name := p1;
    l_last_name := p2;
    l_dob := p3;
    begin
    OPEN REF_CUR_OUT FOR
    select 
    l_first_name || ' ' || l_last_name recruit_name,
    l_first_name recruit_first_name,
    l_last_name recruit_last_name,
    --to_char(l_dob,'DD-MON-YYYY') recruit_dob,
    l_dob recruit_dob,
    p0 recruit_ssn,
    l_id recruit_vassar_id,
    l_pidm recruit_vassar_pidm,
    '' recruit_vassar_email,
    rtn_code_2 return_code, rtn_mess_2 return_status,
    sysdate activity_date
    from dual;
    end;
    end if;
    
    end if;


    /* ==================== */
    if search_result = false then
    l_first_name := p1;
    l_last_name := p2;
    l_dob := p3;
    /* generate a id/pidm */
    l_pidm := baninst1.gb_common.f_generate_pidm;
    l_id := baninst1.gb_common.f_generate_id;
    /* */
    
    begin
    OPEN REF_CUR_OUT FOR
    select
    l_first_name || ' ' || l_last_name recruit_name,
    l_first_name recruit_first_name,
    l_last_name recruit_last_name,
    --to_char(to_date(l_dob,'YYYY-MM-DD'),'DD-MON-YYYY') recruit_dob,
    l_dob recruit_dob,
    p0 recruit_ssn,
    l_id recruit_vassar_id,
    l_pidm recruit_vassar_pidm,
    '' recruit_vassar_email,
    rtn_code_1 return_code, rtn_mess_1 return_status,
    sysdate activity_date
    from dual;
    end;
    end if;
    
  
    /* ==================== */
   
   
   
   
end;