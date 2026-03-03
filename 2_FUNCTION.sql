--함수 (FUNCTION) : 컬럼의 값을 읽어서 계산한 결과 리턴
--단일 행 함수 : 컬럼에 기록된 N개의 값을 읽어 N개의 결과 리턴
--그룹 함수 : 컬럼에 기록된 N개의 값을 읽어 1개의 결과 리턴

--단일 행 함수
--문자 관련 함수
--length 글자 수 반환 , lengthb 바이트 수 반환
select length('오라클'), lengthb('오라클') 
from dual; --가상 테이블(DUMMY TABLE)

select email, length(email), lengthb(email)
from employee;

--INSTR
select instr('AABAACAABBAA','B'), INSTR('AABAACAABBAA','A'),
        instr('AABAACAABBAA','Z') --0
from dual;

select instr('AABAACAABBAA','B',1), --세 번째인자 : 어느 위치부터 읽기 시작할 것이냐
        INSTR('AABAACAABBAA','B',7),
        INSTR('AABAACAABBAA','B',-1),--마지막 글자부터
        INSTR('AABAACAABBAA','A',-3) --뒤에서 3번째 글자부터
from dual;

select instr('AABAACAABBAA','B',1,2)-- 네 번째 인자 : N번째로 나오는 글자읽기
from dual;                          -- 세번째인자(위 코드에선 첫번째) 부터 시작해서 
                                    -- 네번째 인자(위 코드에선 두번째)로 나오는 B의위치
                                    
--employee테이블에서 이메일의 @ 위치
select email, instr(email, '@') from employee;

-- LPAD/RPAD
select lpad(email,20), rpad(email,20) from employee;
--     sun_di@kh.or.kr
--sun_di@kh.or.kr    

select lpad(email,20,'#'), rpad(email,20,'#') from employee;

--LTRIM/RTRIM/TRIM
select LTRIM('   KH   ') A, RTRIM('   KH   ') B FROM DUAL;
select LTRIM('   KH   ', ' ') A, RTRIM('   KH   ', ' ') B FROM DUAL;
select LTRIM('000123456', '0'), RTRIM('123456000', '0') FROM DUAL;
select LTRIM('123123KH123','123'), RTRIM('123KH123123','123')FROM DUAL;
select LTRIM('ACABACCKH','ABC'), RTRIM('KHACABACC','ABC')FROM DUAL;
select LTRIM('2132153447KH', '0123456789') FROM DUAL;
select TRIM('   KH   ') A FROM DUAL;
select TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;
select TRIM('ABC' FROM 'ABCKHABC')FROM DUAL; --트림 설정은 하나 문자만 가지고 있어야 함.
select TRIM(LEADING 'Z' FROM 'ZZZKHZZZ'),
        TRIM(TRAILING '3' FROM '333KH333'),
        TRIM(BOTH '@' FROM '@@@KH@@@') FROM DUAL;

-- SUBSTR (찾을곳 , 시작위치 , 몇글자 )
select substr('HELLOMYGOODFRIENDS',7),
       substr('HELLOMYGOODFRIENDS',5,2),
       substr('HELLOMYGOODFRIENDS',5,0), --길이 0 null
       substr('HELLOMYGOODFRIENDS',-8,3) 
FROM DUAL; 

--employee테이블에서 이름, 이메일, @이후를 제외한 아이디 조회
select emp_name,email, substr(email,1,instr(email,'@')-1) 
from employee;

--주민등록번호를 이용하여 남/녀 판단
--employee테이블에서 이름과 주민번호에서 성별을 나타내는 부분 조회

select emp_name,emp_no, substr(emp_no,-7,1) from employee;
select emp_name,emp_no, substr(emp_no, instr(emp_no,'-')+1,1) 성별 from employee;

select emp_name,'남자' 성별
from employee
where substr(emp_no, instr(emp_no,'-')+1,1) =1;

select emp_name,'여자' 성별
from employee
where substr(emp_no, instr(emp_no,'-')+1,1) =2;

--LOWER/UPPER/INITCAP
select lower('Welcome To My World'), --다 소문자
       upper('Welcome To My World'), --다 대문자
       initcap('welcome to my world') from dual;--단어 첫글자 대문자

--CONCAT
select concat('가나다라', 'ABCD') from dual;

--REPLACE
select replace('서울시 강남구 역삼동', '역삼동', '삼성동') from dual;
select replace('박신우강사님은 현재 어지럽습니다.' , '강사님', '선생님') from dual;
select replace('박신우강사님은 502강의장 강사님입니다.', '강사님', '선생님') from dual;

--employee테이블에서 사원명 주민번호 조회
--단, 주민번호는 생년월일만 보이게 하고 '-' 다음은 '*'로변경
--ex.260223-*******
select emp_name, emp_no , substr(emp_no, 1, instr(emp_no, '-')) || '*******'주민번호
from employee;

select emp_name, emp_no , concat(substr(emp_no, 1, instr(emp_no, '-')), '*******')주민번호
from employee;

select emp_name, rpad(substr(emp_no , 1, instr(emp_no,'-')), length(emp_no),'*') 주민번호
from employee;

select emp_name, replace(emp_no, substr(emp_no, instr(emp_no,'-')+1),'*******')주민번호
from employee;


--숫자 관련 함수
--ABS
select abs(10.9), abs(-10.9), abs(10), abs(-10) from dual;

--MOD
select mod(10,3), mod(-10,3), mod(10.9,3), mod(-10.9,3),
        mod(10,-3),mod(-10,-3)
from dual;

--ROUND, FLOOR, TRUNC, CEIL (floor,ceil 위치지정불가)
select round(123.456), round(123.678,0), round(123.456,1), round(123.456,2),
        round(123.456,-2)
from dual;

select floor(123.456), floor(123.678) from dual;--수학적 내림

select trunc(123.456), trunc(123.678) from dual;--절삭

select floor(-1.1), trunc(-1.1) from dual;

select trunc(123.456,0), trunc(123.456,1), trunc(123.456,2), trunc(123.456,-1)
from dual;

select ceil(123.456), ceil(123.678) from dual;

--날짜 관련 함수
select sysdate from dual;

--months_between
--employee테이블에서 사원의 이름, 입사일, 근무 개월 수 조회

select emp_name, hire_date, months_between(sysdate,hire_date)
from employee;

select emp_name, hire_date,ceil(abs(months_between(sysdate,hire_date)))개월차
from employee;

--ADD_MONTHS : 날짜에 숫자만큼 개월 수를 더하여 날짜 리턴
select add_months(sysdate,5), add_months(sysdate,12) from dual;

--next_day : 기준 날짜에서 구하려는 요일에 가장 가까운 날짜 리턴
select sysdate, next_day(sysdate, '목요일'),
                next_day(sysdate, 5),--1일,2월,3화~ 5목
                next_day(sysdate, '목'),
                next_day(sysdate, '월급 세 배로 줘')--앞에있는 '월'로 인식
from dual;

select sysdate, next_day(sysdate, '화요일') from dual;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;--THURSDAY면 이런식으로 세션변경
ALTER SESSION SET NLS_LANGUAGE = KOREAN; --화요일이면 이런식으로 세션변경

--LAST_DAY : 해당 달의 마지막 날짜 리턴
select sysdate, last_day(sysdate) 
from dual;

--employee테이블에서 사원 명, 입사일-오늘, 오늘-입사일 조회
--단 별칭은 '근무일수1', '근무일수2'로 하고 모두 정수처리(내림)하여 양수가 되도록 처리

select emp_name, floor(abs(hire_date - sysdate)) 근무일수1,floor(abs(sysdate-hire_date)) 근무일수2
from employee;

--employee테이블에서 근무년수가 20년 이상인 직원 정보 조회(여러개 나올 수 있으므로 다 해보기)

select *
from employee
--where (sysdate - hire_date)/365 >=20;
--where months_between(sysdate, hire_date) >= 240;
where add_months(hire_date,240) <= sysdate;


--employee테이블에서 사원 명, 입사일, 입사한 월의 근무 일수 조회
select emp_name, hire_date,last_day(hire_date) - hire_date
from employee;

--EXTRACAT : 년,월,일 정보 추출
--EXTRACT(YEAR FROM 날짜), EXTRACT(MONTH FROM 날짜), EXTRACT(DAY FROM 날짜)
--EMPLOYEE테이블에서 사원의 이름, 입사 년, 입사 월, 입사일 조회

select emp_name,extract(year from hire_date) ,extract(month from hire_date),extract(day from hire_date)
from employee;

--형변환 함수
--TO_CHAR : 날짜/숫자 데이터를 문자 데이터로 변경
select 1234 AAAAAAA, TO_CHAR(1234) FROM DUAL; --문자는 결과에서 왼쪽에붙음, 숫자는 오른쪽

SELECT TO_CHAR(1234) + 4321 FROM DUAL; --Oracle은 숫자 + 문자 연산 시 문자를 다시 숫자로 암묵적 형변환

select TO_CHAR(1234,'FM99999'), TO_CHAR(1234,'FM00000'), TO_CHAR(1234,'FML99999')
FROM DUAL;

select to_char(1234,'$99999'), to_char(1234,'fm$99999'),
        to_char(1234,'99,999'), to_char(1234,'00,000'), to_char(1234,'999')
from dual;    

select to_char(sysdate, 'PM HH24:MI:SS') 
FROM DUAL; --AM/PM = 오전/오후 , HH24 = 24시간 , MI:SS = 분:초

select to_char(sysdate,'YYYY'), TO_CHAR(sysdate, 'YY'), to_char(sysdate,'YEAR') 
FROM DUAL; --YYYY = 2026 , YY=26 ,YEAR=TWENTY TWENTY-SIX / 2026년 기준

select to_char(sysdate,'MM'), to_char(sysdate,'MONTH'),
        to_char(sysdate,'MON'), TO_CHAR(sysdate, 'RM')
from dual; --MM = 02 , MONTH = FEBRUARY , MON = FEB , RM = ||(로마숫자) /2월 기준

select to_char(sysdate, 'DDD'), to_char(sysdate,'DD'), to_char(sysdate,'D') 
from dual; --DDD = 올해 몇번 째 날 , DD = 날짜 , D = 요일번호

select to_char(sysdate, 'Q'), to_char(sysdate,'DAY'), to_char(sysdate,'DY') FROM DUAL;
--Q = 분기 , DAY = MONDAY , DY = MON / 2월에 화요일이면 1 , 화요일 , 화

--employee테이블에서 이름, 입사일 조회
--2026년 02월 23일 (월)

select emp_name,
        to_char(hire_date, 'YYYY"년" MM"월" DD"일" (DY)') 
from employee;

--TO_DATE : 문자/숫자 데이터를 날짜 데이터로 변환
select to_date('20100101', 'YYYYMMDD'), TO_DATE(20100101, 'YYYYMMDD')
FROM DUAL;

select to_char(to_date('20100101', 'YYYYMMDD'),'YYYY,MON') FROM DUAL;
select TO_CHAR(to_date('041030 143000', 'YYMMDD HH24MISS'), 'DD-MON-YY HH:MI:SS PM') FROM DUAL;

--Y를 적용하여 무조건 현재세기 적용
--R을 적용하면 연도가50이상일 때는 이전세기 미만일 때는 현제 세기
select to_char(to_date('980630','YYMMDD'), 'YYYYMMDD') CASE1,
       to_char(to_date('140918', 'YYMMDD'), 'YYYYMMDD') CASE2,
       to_char(to_date('980630', 'RRMMDD'), 'YYYYMMDD') CASE3,
       to_Char(to_date('140918', 'RRMMDD'), 'YYYYMMDD') CASE4
FROM DUAL;


--TO_NUMBER (숫자로 변환)
SELECT TO_NUMBER('12345')
from dual;

SELECT TO_NUMBER('1,000,000', '999,999,999')-- 뒤에 포맷형식은 고정값x, 상황에 맞게 바꾸는 형식
        + TO_NUMBER('4,000,000', '999,999,999')
FROM DUAL;
-- 소수점이 있으면? TO_NUMBER('1,234.56', '9,999.99')
-- 더 큰 숫자면? TO_NUMBER('123,456,789,000', '999,999,999,999')
-- 자리 수가 적으면? TO_NUMBER('1,000', '9,999')


--NULL처리 함수 : 컬럼 값이 NULL일 때 바꿀값의 자료형은 컬럼의 자료형을 따라감
select emp_name, salary*(1+bonus)*12 from employee;--bonus가 null이면 null

select bonus, NVL(bonus,0) --bonus가 null이면 0으로 바꿈
from employee;

select emp_name, salary*(1+nvl(bonus,0))*12 from employee;

--선택 함수
--DECODE(계산식 | 컬럼명 , 조건값1, 선택값1, 조건값2, 선택값2, ...)
--비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과 값 반환

select emp_id, emp_name,emp_no, 
        decode(substr(emp_no,instr(emp_no,'-')+1,1),'1','남','2','여') 성별1,
        decode(substr(emp_no,instr(emp_no,'-')+1,1),'1','남','여') 성별2
from employee;

--직원의 급여를 인상하고자 한다
--직급코드가 J7인 직원은 급여의10%, 직급코드가 J6인 직원은 급여의 15%
--직급코드가 J5인 직원은 급여의 20%, 그 외 직급은 급여의 5%를 인상한다.
--employee테이블에서 직원 명, 직급코드, 급여, 인상급여(위 조건) 조회

select  emp_name,job_code,salary,
    decode(job_code,'J7',salary*1.1,'J6',salary*1.15,'J5',salary*1.2,salary*1.05)인상급여1,
    salary*(1+decode(job_code,'J7',0.1,'J6',0.15,'J5',0.2,0.05)) 인상급여2
from employee;

--CASE WHEN 조건식 THEN 결과값
--     WHEN 조건식 THEN 결과값
--     ELSE 결과값
--END

select emp_id, emp_name, emp_no,
    case when substr(emp_no,instr(emp_no,'-')+1,1) = 1 then '남'    
        else '여'
    end 성별1,
    
    case substr(emp_no,instr(emp_no,'-')+1,1) when '1' then '남'    
        else '여'
    end 성별2
from employee;

--직급에 따른 급여 인상

select emp_name, job_code, salary,
    case when job_code='J7' then salary*(1+0.1)
         when job_code='J6' then salary*(1+0.15)
         when job_code='J5' then salary*(1+0.2)
    else salary*(1+0.05)
end 인상급여1,

case job_code when 'J7' then salary*(1+0.1)
              when 'J6' then salary*(1+0.15)
              when 'J5' then salary*(1+0.2)
              else salary*(1+0.05)
end 인상급여2
from employee;

--그룹 함수

--sum
--employee테이블에서 전 사원의 급여 총합 조회
select sum(salary) from employee;

--employee테이블에서 남자 사원의 급여 총합조회
select sum(salary)
from employee
where substr(emp_no,instr(emp_no,'-')+1,1)=1;

--employee테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합계 조회
select sum((salary + (salary*nvl(bonus,0)))*12)
from employee
where dept_code='D5';

--AVG
--EMPLOYEE테이블에서 전 사원의 급여 평균 조회

select avg(salary)
from employee;

--employee테이블에서 전 사원의 보너스 평균 조회
select avg(bonus) from employee; -- null평균 제외

select avg(nvl(bonus,0)) from employee;

--COUNT
--employee테이블에서 전체 사원 수 주회
select count(*)
from employee;

select count(bonus) 
from employee;

--MIX/MAX
select min(salary),min(emp_name), min(email), min(hire_date)
from employee;

select max(salary),max(emp_name), max(email), max(hire_date) 
from employee;

