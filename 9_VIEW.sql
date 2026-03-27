-- VIEW : 논리적 가상 테이블
-- SELECT쿼리 실행 결과(RESULT SET)를 저장한 객체
-- 표현식 : 
-- CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름[(alias[, alias,...])]
-- AS SUBQUERY
-- [WITH CHECK OPTION]
-- [WITH READ ONLY]

-- 사번, 이름, 부서명, 근무지역의 조회 결과를 뷰 V_EMPLOYEE에 저장
create or replace view v_employee
as select emp_id, emp_name, dept_title, national_name
from employee
    left join department on(dept_code = dept_id)
    left join location on(location_id=local_code)
    left join national using(national_code);
    
grant create view to KH;

select * from v_employee;
select * from v_employee where emp_id = 205;

update employee 
set emp_name = '정중앙'
where emp_id = 205;

select * from employee where emp_id = 205;

-- VIEW 구조
-- 뷰 정의 시 사용한 쿼리 문장이 TEXT컬럼에 저장
-- 뷰가 실행될 때는 TEXT에 기록된 SELECT문장이 다시 실행되면서 결과를 보여주는 구조
select * from user_views; -- USER_VIEWS : 뷰에 대한 정보를 확인하는 데이터 딕셔너리

--생성된 뷰 컬럼에 별칭 부여
--서브쿼리의 SELECT절에 함수가 사용된 경우 반드시 별칭 지정
--사번, 사원 명, 직급, 성별, 근무년수를 뷰 V_EMP_JOB에 저장
create or replace view V_EMP_JOB(사번, "사원 명", 직급, 성별, 근무년수)
as select emp_id, emp_name, job_name, 
       decode(substr(emp_no, instr(emp_no,'-')+1,1), '1','남','여'), 
       extract(year from sysdate)- extract(year from hire_date)
    from employee
        join job using(job_code); 
        
create or replace view V_EMP_JOB
as select emp_id, emp_name, job_name, 
       decode(substr(emp_no, instr(emp_no,'-')+1,1), '1','남','여') 성별, 
       extract(year from sysdate)- extract(year from hire_date) AS 근무년수
    from employee
        join job using(job_code);
        
select * from V_EMP_JOB;

--생성된 뷰를 이용해서 DML 사용 가능, 뷰에서 요쳥한 DML문은 베이스 테이블도 변경
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE,JOB_NAME FROM JOB;
select * from job;
select * from V_JOB;

INSERT INTO V_JOB VALUES('J8','인턴');
update V_JOB SET job_name = '알바' where job_code = 'J8';
delete from v_job where job_code = 'J8';

--DML명령어로 조작이 불가능한 경우
--뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
create or replace view V_JOB2
as select job_code from job;

select * from V_JOB2;

INSERT INTO V_JOB2 VALUES('J8', '인턴');
--SQL 오류: ORA-00913: 값의 수가 너무 많습니다
UPDATE V_JOB2 SET JOB_NAME = '인턴' WHERE JOB_CODE = 'J7';
DELETE FROM V_JOB2 WHERE JOB_NAME = '사원';
--SQL 오류: ORA-00904: "JOB_NAME": 부적합한 식별자


--뷰에 포함되지 않은 컬럼 중에 베이스 테이블 컬럼이 NOT NULL 제약조건 지정된 경우
CREATE OR REPLACE VIEW V_JOB3
AS SELECT JOB_NAME FROM JOB;

SELECT * FROM V_JOB3;

INSERT INTO V_JOB3 VALUES('인턴');
--ORA-01400: NULL을 ("KH"."JOB"."JOB_CODE") 안에 삽입할 수 없습니다

INSERT INTO JOB VALUES('J8','인턴');
UPDATE V_JOB3 SET JOB_NAME = '알바' WHERE JOB_NAME = '인턴';
DELETE FROM V_JOB3 WHERE JOB_NAME = '알바';

--산술 표현식으로 정의된 경우
CREATE OR REPLACE VIEW EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, (SALARY+(SALARY*NVL(BONUS,0)))*12 연봉
    FROM EMPLOYEE;
    
select * from emp_sal;

insert into emp_sal values(123,'차청춘',300000,36000000);
update emp_sal set 연봉=3600000 where emp_id = 200;
--SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다
delete from emp_sal where 연봉=124800000;
ROLLBACK;

--그룹함수나 GROUP BY절을 포함한 경우
CREATE OR REPLACE VIEW V_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) 합계, AVG(SALARY) 평균
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
SELECT * FROM V_GROUPDEPT;

INSERT INTO V_GROUPDEPT VALUES('D10', 6000000, 40000000);
--SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다
UPDATE V_GROUPDEPT SET DEPT_CODE = 'D10' WHERE DEPT_CODE = 'D3';
DELETE FROM V_GROUPDEPT WHERE DEPT_CODE = 'D1';
--SQL 오류: ORA-01732: 뷰에 대한 데이터 조작이 부적합합니다

--DISTINCT를 포함한 경우
CREATE OR REPLACE VIEW V_DT_EMP
AS SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

SELECT * FROM V_DT_EMP;

INSERT INTO V_DT_EMP VALUES('J9');
UPDATE V_DT_EMP SET JOB_CODE = 'J9' WHERE JOB_CODE ='J7';
DELETE FROM V_DT_EMP WHERE JOB_CODE = 'J1';
--SQL 오류: ORA-01732: 뷰에 대한 데이터 조작이 부적합합니다


--JOIN을 이용해 여러 테이블을 연결한 경우
CREATE OR REPLACE VIEW V_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

SELECT * FROM V_JOINEMP;

INSERT INTO V_JOINEMP VALUES(123,'윤예의','인사관리부');
UPDATE V_JOINEMP SET DEPT_TITLE = '인사관리부' WHERE EMP_ID=219;
--SQL 오류: ORA-01776: 조인 뷰에 의하여 하나 이상의 기본 테이블을 수정할 수 없습니다.
--SQL 오류: ORA-01779: 키-보존된것이 아닌 테이블로 대응한 열을 수정할 수 없습니다

DELETE FROM V_JOINEMP WHERE EMP_ID = 219;
UPDATE V_JOINEMP SET EMP_NAME = '테스트' WHERE EMP_ID = 200;
ROLLBACK;

--VIEW 옵션
--OR REPLACE : 기존에 동일한 뷰 이름이 존재하는 경우 덮여쓰고, 존재하지 않으면 새로 생성
--FORCE | NOFORCE (DEFAULT) 
-- : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
--  | 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성(기본값)

CREATE OR REPLACE VIEW V_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT;
    
CREATE OR REPLACE FORCE VIEW V_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT;
    
--WITH CHECK OPTION : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함
CREATE OR REPLACE VIEW V_EMP2
AS SELECT * FROM EMPLOYEE
    WHERE DEPT_CODE = 'D9'
    WITH CHECK OPTION; -- DEPT_CODE에 옵션 걸림
    
UPDATE V_EMP2 SET DEPT_CODE = 'D1' WHERE EMP_ID = 200;
--SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다

--WITH READ ONLY : 뷰에 대해 조회만 가능
CREATE OR REPLACE  VIEW V_DEPT
AS SELECT * FROM DEPARTMENT
WITH READ ONLY;

INSERT INTO V_DEPT VALUES('D10','해외영업4부','L1');
UPDATE V_DEPT SET LOCATION_ID = 'L2' WHERE DEPT_ID='D1';
DELETE FROM V_DEPT;
--SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.




    
