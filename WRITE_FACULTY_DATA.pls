create or replace PROCEDURE       WRITE_FACULTY_DATA (   
   P0 in number default null,
   P1 in varchar2 default null,
   P2 in varchar2 default null,
   P3 in varchar2 default null,
   P4 in varchar2 default null,
   P5 in varchar2 default null,

   REF_CUR_OUT      OUT SYS_REFCURSOR
)

AS
/* 
P0 : pidm
P1 : id
P2 : Name
P3 : Appt Title
P4 : UNIT_CODE (WD)
P5 : Rank
*/

   return_code varchar2(3) := '200';
   return_object varchar2(20) := 'FACULTY_ASSOCIATION';
   return_status varchar2(100) := 'success';
   
BEGIN
    delete from bn.faculty_association where pidm = p0 and home = p4;
    commit;
    
   begin
      insert into bn.faculty_association(PIDM, ID, NAME_LF, TITLE, LONG_TITLE, HOME, STATUS, ACADEMICYEAR, SYS_DATE)
      values (p0, p1, p2, p3, p3, p4, p5, '2017-18', sysdate); 
   end;
   
   commit;
   
   begin
      delete from bn.faculty_association where to_char(sys_date,'DD-MON-YYYY') < to_char(sysdate,'DD-MON-YYYY'); 
   end;
   
   commit;
   
/* update attrributes from Banner */
begin
update bn.faculty_association a
set a.email = (select distinct substr(goremal_email_address,1,(instr(goremal_email_address,'@')-1)) from GOREMAL where goremal_emal_code = 'VASR' and goremal_status_ind = 'A' and goremal_pidm = a.pidm)
where a.pidm = p0;
end;

commit;
    
    -- CHAIR
begin
update bn.faculty_association a
set a.chair = 
(select listagg(chairs_dept_code, ', ') within group (order by chairs_dept_code) chairs_dept_code 
from ccr.chairwterm b, fsp_xref_deptorg c 
where b.CHAIRS_DEPT_CODE = c.dept_code and b.term_code = '201703' and b.CHAIRS_PIDM = a.pidm
and c.TYPE = 'D'
group by b.chairs_pidm
)
where pidm = p0
;
end;

-- DIRECTOR
begin
update bn.faculty_association a
set a.director = 
(select listagg(chairs_dept_code, ', ') within group (order by chairs_dept_code) chairs_dept_code 
from ccr.chairwterm b, fsp_xref_deptorg c 
where b.CHAIRS_DEPT_CODE = c.dept_code and b.term_code = '201703' and b.CHAIRS_PIDM = a.pidm
and c.TYPE = 'P'
group by b.chairs_pidm
)
where pidm = p0
;
end;

-- STEERING
begin
update bn.faculty_association a
set a.steering = 
(select listagg(program_code, ', ') within group (order by program_code) pg 
from IA.MULTI_DISC_FACULTY b 
where b.pidm = a.pidm and b.ACADEMIC_YR = '2017-18' and scomm_ind = 'Y'
group by a.pidm
) 
where pidm = p0
;
end;

-- PARTICIPATING
begin
update bn.faculty_association a
set a.PARTICIPATING = 
(select listagg(program_code, ', ') within group (order by program_code) pg 
from 
(select distinct pidm, program_code, academic_yr, facu_ind 
 from IA.MULTI_DISC_FACULTY) b 
where b.pidm = a.pidm and b.ACADEMIC_YR = '2017-18' and facu_ind = 'Y'
group by a.pidm
) 
where pidm = p0
;
end;

-- SITE
begin
update bn.faculty_association a
set a.site = decode(a.home,null,'',a.home) || decode(a.chair,null,'',', '||a.chair) || decode(a.director,null,'',', '||a.director) || decode(a.steering,null,'',', '||a.steering) || decode(a.participating,null,'',', '||a.participating) 
where pidm = p0
;
end;

-- SITE (fix)
begin
update bn.faculty_association a
set site = substr(site,3)
where substr(site,1,1) = ','
;
end;

-- LEAVE ind
begin
update bn.faculty_association a
set leave = 'Y'
where name_lf like '%Leave%';
end;

commit;

OPEN REF_CUR_OUT FOR
SELECT DISTINCT return_code return_code, return_status return_status, return_object object_name from dual;        
END;