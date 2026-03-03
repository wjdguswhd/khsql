--DML(DATA MANIPULATION LANGUAGE) : 데이터 조작 언어
--테이블에 값을 삽입하거나(INSERT), 수정하거나(UPDATE), 삭제하는(DELETE) 구문
-- => DML후에는 테이블에 데이터 변경사항이 생김
-- => 따라서 트랜잭션 처리를 무조건 해주어야 함(COMMIT, ROLLBACK)

--INSERT : 새로운 행을 추가하는 구문 = 테이블 행 개수 증가
--INSERT INTO 테이블명 VALUES(값1, 값2, 값3, ...);
--테이블의 모든 컬럼에 데이터를 삽입, 데이터를 테이블의 컬럼 순서에 맞춰야 함
--INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3, ...) VALUES(값1, 값2, 값3, ...);
--테이블 중 일부 컬럼 데이터 삽입, 선택이 안 된 컬럼에는 NULL값 삽입(NOT NULL제약조건 유의)
INSERT INTO EMPLOYEE
VALUES(900, '강건강', '981112-1234568', 'kang_kk@kh.or.kr', '01011112222', 'D9','J7',
        'S3', 3000000, 0.1, 200, SYSDATE, NULL, 'N');
        
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, SALARY, DEPT_CODE, JOB_CODE, SAL_LEVEL,PHONE,
                        MANAGER_ID, HIRE_DATE, EMAIL,ENT_YN,ENT_DATE,BONUS)
                        
VALUES(901,'남나눔','990311-1457854', 3000000,'D8','J7','S3','01022223333',200,SYSDATE,
        'nam_nn@kh.or.kr','N',NULL,NULL);
        
INSERT INTO EMPLOYEE(EMP_ID, SAL_LEVEL,JOB_CODE,EMP_NO,EMP_NAME)
VALUES(902,'S3','J7','000223-3011231','도대남');

COMMIT;

INSERT INTO CONS_NAME(
    SELECT EMP_ID, EMP_NAME, EMP_NO
    FROM EMPLOYEE
);

--INSERT ALL : 두 개 이상의 테이블에 한 번에 데이터 삽입
CREATE TABLE EMP_DEPT_D1
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1=0;
    
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1=0;
    
--EMP_DEPT_D1테이블에 EMPLOYEE테이블에 있는 부서코드가 D1인 직원을 조회하여 
--사번,이름,소속부서,입사일을 삽입하고
--EMP_MANAGER테이블에 EMPLOYEE테이블에 있는 부서코드가 D1인 직원을 조회하여
--사번,이름,관리사 사번 삽입

INSERT INTO EMP_DEPT_D1(
    SELECT EMP_ID, EMP_NAME,DEPT_CODE ,HIRE_DATE
    FROM EMPLOYEE
    WHERE DEPT_CODE ='D1'
);

INSERT INTO EMP_MANAGER(
    SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM employee
    WHERE DEPT_CODE ='D1'
);

ROLLBACK;

INSERT ALL
INTO EMP_DEPT_D1 VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

--EMPLOYEE테이블의 입사일을 기준으로 2000년 1월1일 이전에 입사한 사원의
--사번, 이름, 입사일, 급여를 조회해서 EMP_OLD테이블에 삽입하고
--그 이후에 입사한 사원의 정보는 EMP_NEW테이블에 삽입
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;

CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;
    
INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME,HIRE_DATE,SALARY)
ELSE
    INTO EMP_NEW VALUES(EMP_ID,EMP_NAME,HIRE_DATE,SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE,SALARY
FROM EMPLOYEE;

--UPDATE : 테이블에 기록된 값을 수정하는 구문 = 행 개수 변화X
--UPDATE 테이블명 SET 컬럼명1 = 바꿀값1, 컬럼명2 = 바꿀값2, ... WHERE 조건식;
COMMIT;

--EMPLOYEE테이블에서 DEPT_CODE가 D9인 행의 SALARY를 0으로 수정
UPDATE EMPLOYEE
SET SALARY = 0
WHERE DEPT_CODE = 'D9';

ROLLBACK;

--방명수 사원의 급여와 보너스를 유재식 사원과 동일하게 변경(EMPLOYEE_COPY)
select emp_name, salary,bonus
from employee_copy
where emp_name in ('유재식','방명수');

update employee_copy
set salary = (select salary
              from employee_copy
              where emp_name = '유재식'),
    bonus = (select bonus
             from employee_copy
             where emp_name = '유재식')
where emp_name = '방명수';

rollback;

update employee_copy
set (salary,bonus) = (select salary,bonus
                    from employee_copy
                    where emp_name = '유재식')
where emp_name = '방명수'; 

--(employee_copy)아시아 지역 근무 직원의 보너스를 0.3으로 변경
UPDATE EMPLOYEE_COPY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
             FROM EMPLOYEE_COPY
                    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
                    LEFT JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE)
             WHERE LOCAL_NAME LIKE'ASIA%');    
                    
COMMIT;

UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200;

UPDATE CONS_NAME
SET TEST_DATA2 = '강건강'
WHERE TEST_DATA1 = '207';

--DELETE : 테이블의 행을 삭제하는 구문 = 행 개수 줄어듦
--DELETE FROM 테이블명 WHERE 조건식;
COMMIT;

SELECT * FROM EMPLOYEE;

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '강건강';

ROLLBACK;

--삭제 시 FOREIGN KEY 제약조건으로 삭제가 불가능할 경우 제약조건 비활성화 가능
DELETE FROM USER_GRADE
WHERE GRADE_CODE = 10;

ALTER TABLE USER_FOREIGNKEY
DISABLE CONSTRAINT FK_UF_GC CASCADE;


SELECT * FROM USER_GRADE;
SELECT * FROM USER_FOREIGNKEY;

ROLLBACK;

ALTER TABLE USER_FOREIGNKEY
ENABLE CONSTRAINT FK_UF_GC;

--TRUNCATE : 테이블의 전체 행을 삭제할 때 사용
--ROLLBACK을 통한 복구 불가능 -> DELETE보다 수행속도가 빠름
COMMIT;

SELECT * FROM EMP_DEPT_D1;

DELETE FROM EMP_DEPT_D1;

ROLLBACK;

TRUNCATE TABLE EMP_DEPT_D1;



