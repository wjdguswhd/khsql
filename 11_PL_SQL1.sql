-- PL/SQL (Procedural Langauge extenstion to SQL)
-- 오라클 자체에 내장되어 있는 절차적 언어
-- SQL문장 내에서 변수 정의, 조건처리, 반복처리 등 지원하며 SQL 단점 보완

-- PL/SQL 구조
-- 선언부(DECLARE SECTION) : DECLARE로 시작, 변수나 상수를 선언하는 부분
-- 실행부(EXECUTABLE SECTION) : BEGIN으로 시작, 제어문, 반복문, 함수 정의 등 로직 기술
-- 예외처리부(EXCEPTION SECTION) : EXCEPTION으로 시작, 예외 발생 시 해결하기 위한 문장 기술

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD'); 
    -- == System.out.println();
END;
/ 
--종결문

SET SERVEROUTPUT ON;

-- 변수 선언
DECLARE 
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(30);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EMP_ID := 888;
    EMP_NAME :='도대담';
    DBMS_OUTPUT.PUT_LINE('EMP_ID: ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME: ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('PI: ' || PI);
END;
/

DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EMP_ID, EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_ID = '&ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID: ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME: ' || EMP_NAME);
END;
/

--레퍼런스 변수로 EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY를 선언하고
--EMPLOYEE테이블에서 사번, 이름, 직급코드, 부서코드, 급여를 조회한 후
--선언한 레퍼런스 변수에 담아 출력
--단, 입력받은 이름과 일치하는 조건의 직원만 조회
DECLARE
    EMP_ID     EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME   EMPLOYEE.EMP_NAME%TYPE;
    DEPT_CODE  EMPLOYEE.DEPT_CODE%TYPE;
    JOB_CODE   EMPLOYEE.JOB_CODE%TYPE;
    SALARY     EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
    INTO   EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
    FROM   EMPLOYEE
    WHERE  EMP_NAME = '&NAME';

    DBMS_OUTPUT.PUT_LINE('사번: ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름: ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('직급코드: ' || JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('부서코드: ' || DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('급여: ' || SALARY);
END;
/

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID :' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME :' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('EMP_NO :' || E.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('SALARY :' || E.SALARY);
END;
/

--조건문(선택문)
--IF~THEN~END IF
--EMP_ID를 입력받아 해당 사번의 사번, 이름, 급여, 보너스율(EX.30%) 출력
--단, 보너스를 받지 않는 사원은 보너스율 출력 전 '보너스를 지급받지 않는 사원입니다' 출력

DECLARE
    EMP_ID     EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME   EMPLOYEE.EMP_NAME%TYPE;
    SALARY     EMPLOYEE.SALARY%TYPE;
    BONUS      EMPLOYEE.BONUS%TYPE; 
BEGIN
    SELECT EMP_ID, EMP_NAME,SALARY, NVL(BONUS,0)
    INTO EMP_ID, EMP_NAME, SALARY,BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID :' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME :' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('SALARY :' || SALARY);
    
    IF(BONUS = 0) --BONUS에 NVL처리 안하면 BONUS IS NULL로 조건식 작성
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
    END IF;

    DBMS_OUTPUT.PUT_LINE('BONUS :' || BONUS*100||'%');
END;
/

--IF~THEN~ELSE~END IF
--EMP_ID를 입력받아 해당 사원의 사번, 이름, 부서명, 소속 출력
--TEAM변수를 만들어 소속이 KO인 사원은 국내팀, 아닌 사원은 해외팀으로 저장
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NATIONAL_CODE LOCATION.NATIONAL_CODE%TYPE;
    
    TEAM VARCHAR2(10);
BEGIN
select EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
INTO EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
from employee
    left join department on(dept_code = dept_id)
    left join location on(location_id=local_code)
WHERE EMP_ID = '&사번';
    
    IF(NATIONAL_CODE='KO')
       THEN TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID :' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME :' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE :' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('NATIONAL_CODE :' || NATIONAL_CODE);
    DBMS_OUTPUT.PUT_LINE('TEAM :' || TEAM);
END;
/

--사용자에게 사번을 받아와 그 사원이 전체 정보를 VEMP에 저장후
--VEMP를 이용하여 연봉 계산 (보너스가 있는 사원은 보너스도 포함하여 계산)
--연봉 계산 결과 값은 YSALARY에 저장
--급여 이름 연봉(\1,000,000 형식)

DECLARE
    VEMP EMPLOYEE%ROWTYPE;
    YSALARY NUMBER;
BEGIN
    SELECT * INTO VEMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    IF VEMP.BONUS IS NULL
        THEN YSALARY := VEMP.SALARY * 12;
    ELSE
        YSALARY := VEMP.SALARY * (1+VEMP.BONUS) * 12;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(VEMP.SALARY || ' ' || VEMP.EMP_NAME || ' ' || TO_CHAR(YSALARY,'FML999,999,999'));
 
END;
/

--IF~THEN~ELSIF~THEN~ELSE~END IF

DECLARE
    SCORE INT;
    GRADE VARCHAR2(2);
BEGIN
    SCORE := '&SCORE';
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >=60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는' || SCORE || '점이고, 학점은 ' || GRADE || '입니다');
END;
/

--CASE~WHEN~THEN~END
DECLARE 
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE :='&점수';
    GRADE := CASE
                WHEN SCORE >=90 THEN 'A'
                WHEN SCORE >=80 THEN 'B'
                WHEN SCORE >=70 THEN 'C'
                WHEN SCORE >=60 THEN 'D'
                ELSE 'F'
            END;
    DBMS_OUTPUT.PUT_LINE('당신의 점수는' || SCORE || '점이고, 학점은 ' || GRADE || '입니다');

END;
/

--반복문
--BASIC LOOP
--LOOP
--      처리문
--      조건문 : IF 조건식 THEN EXIT; END IF;
--            : EXIT WHEN 조건식;
--END LOOP;

DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
        
        /* IF N > 5 THEN EXIT;
        END IF; */
        EXIT WHEN N>5;
    END LOOP;
END;
/

--FOR LOOP
--FOR 인덱스 IN [REVERSE] 초기값..최종값
--LOOP
--      처리문
--END LOOP;

BEGIN
    FOR N IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

BEGIN
    FOR N IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

BEGIN
    FOR N IN REVERSE 1..100
    LOOP
        INSERT INTO TMP_EMPLOYEE
        VALUES(SEQ_TEST.NEXTVAL, '100');
    END LOOP;
END;
/


--WHILE LOOP
--WHILE 조건식
--LOOP
--      처리문
--END LOOP;

DECLARE
    N NUMBER :=1;
BEGIN
    WHILE N<=5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
         N:=N+1;
    END LOOP;
END;
/








