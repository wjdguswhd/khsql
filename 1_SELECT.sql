-- SELECT : 데이터 조회
-- SELECT구문으로 데이터를 조회한 결과물을 RESULT SET이라고 함(반환된 행들의 집합)

--EMPLOYEE테이블의 사번, 이름, 급여 조회

SELECT EMP_ID,EMP_NAME,SALARY
FROM employee;

SELECT ENT_YN
FROM EMPLOYEE
WHERE ENT_YN = 'N'; --리터럴은 ''로 감싸서 사용, 리터럴 대소문자 구분

--EMPLOYEE테이블의 모든 정보 조회

SELECT *
FROM EMPLOYEE;

--JOB 테이블의 모든 정보 조회
select *
from JOB;

--JOB 테이블의 직급 이름 조회
select job_name
from JOB;

--DEPARTMENT테이블의 모든 정보 조회
select *
from department;

--EMPLOYEE테이블의 직원 명, 이메일, 전화번호, 고용일 조회
select emp_name,email,phone,hire_date
from employee;

--EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select hire_date, emp_name, salary
from employee;

--컬럼 값 산술 연산 : 컬럼명 입력 부분에 계산식을 넣어 결과 조회가능
--employee테이블에서 직원 명, 연봉 조회(연봉 =급여*12)

select emp_name,salary*12 
from employee;

--employee테이블에서 직원의 직원 명, 연봉, 보너스를 추가한 연봉조회
select emp_name, salary*12, (salary + (salary*bonus))*12
from employee;

--employee테이블에서 이름, 고용일, 근무일수 (오늘날짜(SYSDATE) - 고용일) 조회
SELECT emp_name,hire_date,(sysdate-hire_date)
from employee;

--컬럼 별칭
--컬럼명 AS 별칭 /컬럼명 AS "별칭" / 컬럼명 별칭/ 컬럼명 "별칭"
--별칭에 띄어쓰기, 특수문자가 들어갈 경우 "" 써야함
--별칭 맨 앞이 숫자로 시작할 경우 "" 써야함

select emp_name AS 이름,salary*12 "연봉"
from employee;

select emp_name AS "직원 이름", salary*12 연봉, 
            (salary + (salary*bonus))*12 "보너스가 들어간 연봉1",
            (salary *(1+BONUS))*12 AS "보너스가 들어간 연봉2"
from employee;

SELECT emp_name 이름 ,hire_date 입사일,(sysdate-hire_date) "근무 일자"
from employee;

--SELECT절에 리터럴 사용
--EMPLOYEE테이블에서 사번, 사원 명, 급여, 단위(원) 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' 단위
FROM EMPLOYEE;

--DISTINCT : 
SELECT JOB_CODE 
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE, DEPT_CODE FROM EMPLOYEE;

--WHERE절 : 조회할 테이블에서 조건이 맞는 값을 가진 행을 골라냄
-- > 크냐, <작냐 , >= 크거나 같냐, <= 작거나 같냐
-- = 같냐, != ^= <> 같지 않냐,

--employee테이블에서 부서코드가 D9인 직원의 이름, 부서코드 조회
select emp_name,dept_code
from employee
where dept_code='D9';

--employee테이블에서 급여가 4000000이상인 직원의 이름, 급여 조회
select emp_name, salary
from employee
where salary>=4000000;


--employee테이블에서 부서코드가 D9가 아닌 사원의 사번, 이름, 부서코드 조회
select emp_id,emp_name,dept_code
from employee
where dept_code != 'D9';

--employee테이블에서 퇴사여부가 N인 직원의 사번, 이름, 고용일, 근무여부를 조회하고
--근무 여부는 재직중으로 표시
select emp_id,emp_name,hire_date,'재직중' "근무 여부"
from employee
where ent_yn = 'N';

--employee테이블에서 월급이 3000000이상인 사원의 이름, 월급, 고용일 조회
select emp_name,salary,hire_date
from employee
where salary >= 3000000;


--employee테이블에서 SAL_LEVEL이 S1인 사원의 이름, 월급, 고용일, 연락처 조회
select emp_name, salary, hire_date,phone
from employee
where sal_level = 'S1';


--employee테이블에서 실수령액이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
--실수령액: 총수령액- (연봉*세금 3%)
--총수령액: 보너스가 포함된 연봉

select emp_name, salary, (salary *(1+bonus))*12 - (salary*12*0.03) 실수령액 , hire_date
from employee
where (salary *(1+bonus))*12 - (salary*12*0.03) >=50000000;

--실수령액 수식이 길어 별칭으로 대체하려 했지만 where에서 별칭 사용 불가
--select문의 6개 절은 실행 순서가 정해져있음
--작성 순서: select - from - where - group by - having - order by
--실행 순서: from - where - group by - having - select - order by

select emp_name, salary, (salary *(1+bonus))*12 - (salary*12*0.03) 실수령액 , hire_date
from employee
where "실수령액" >=50000000;

--논리 연산자(AND, OR)
--employee테이블에서 부서코드가 D6이고 급여를 3백만보다 많이 받는 직원 이름, 부서코드, 급여조회
select emp_name,dept_code,salary
from employee
where dept_code = 'D6' AND salary>=3000000;

--employee테이블에서 부서코드가 D6이거나 급여를 3백만보다 많이 받는 직원 이름, 부서코드, 급여조회

select emp_name,dept_code,salary
from employee
where dept_code ='D6' OR salary >= 3000000;

--employee테이블에서 급여를 350만 이상 600만 이하를 받는 직원의 사번,이름,부서코드,직급코드 조회

select emp_id,emp_name,dept_code,job_code
from employee
where salary >= 3500000 AND salary <= 6000000;

--employee테이블에 월급이 400만 이상이고 job_code가 j2인 사원의 전체 내용 조회

select *
from employee
where salary >= 4000000 and job_code = 'j2';

--employee테이블에 부서코드가 D9이거나 D5인 사원 중
--고용일이 02년 1월1일보다 빠른 사원의 이름, 부서코드,고용일 조회
select emp_name, dept_code, hire_date
from employee
where (dept_code = 'D9' OR dept_code = 'D5')
    AND HIRE_DATE < '02/01/01';
    
--컬럼명 BETWEEN X AND Y : 컬럼명이 x값 이상 y값 이하
--급여가 350만 이상이고 600만이하
select emp_id,emp_name,dept_code,job_code
from employee
--where salary >= 3500000 AND salary <= 6000000;
where salary between 3500000 and 6000000;

--급여가 350만 미만이거나 600만 초과
select emp_id,emp_name,dept_code,job_code
from employee
--where salary not between 3500000 and 6000000;
where not salary between 3500000 and 6000000;

--employee테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용 조회
select * from employee
where hire_date between '90/01/01' and '01/01/01';

--LIKE : 비교하려는 값이 지정한 특정 패턴을 만족하는지 검사
--컬럼명 LIKE '문자패턴'
--문자 패턴 구성 : %, _
--% : 0글자 이상
-- '글자%' (글자로 시작하는 값) : 글자, 글자수, 글자라나라머리머리
-- '%글자' (글자로 끝나는 값) : 글자, 비글자, 한글자두글자세글자네글자
-- '글%자' (글로 시작해서 자로 끝나는 값) : 글자, 글을 읽자
-- '%글자%' (글자가 포함된 값) :

--_ : 1글자
-- '_' (1글자) : 꿈, 감, 용, 집
-- '__'(2글자) : 글자, 수업, 만세
-- '___'(3글자) : 오라클, 금요일, 졸리다

--employee테이블에서 성이 전씨인 사원의 사번, 이름, 고용일 조회
select emp_id, emp_name, hire_date
from employee
where emp_name like '전%';

--employee테이블에서 이름이 '하'가 포함된 직원의 이름, 주민번호, 부서코드 조회
select emp_name,emp_no,dept_code
from employee
where emp_name like '%하%';

--employee테이블에서 전화번호 4번째 자리가 9로 시작하는 사원의 사번, 이름, 전화번호 조회
select emp_id, emp_name, phone
from employee
where phone like '___9%';

--employee테이블에서 이메일 중 _의 앞 글자가 3자리인 이메일 주소를 가진 사원의 사번, 이름, 이메일 조회
select emp_id,emp_name,email
from employee
where email like '___%';

--ESCAPE OPTION : 문자 패턴과 일반 문자를 구분 시킴
select emp_id,emp_name,email
from employee
where email like '__*_%' ESCAPE '*';
--where email like '__ _%' ESCAPE ' ';
--where email like '__1_%' ESCAPE '1';

--employee테이블에서 김씨 성이 아닌 직원의 사번, 이름, 고용일 조회
select emp_id, emp_name, hire_date
from employee
--where emp_name not like '김%';
where not emp_name like '김%';

--employee테이블에서 이름 끝이 연으로 끝나는 사원의 이름 조회
select emp_name
from employee
where emp_name like '%연';

--employee테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호 조회
select emp_name,phone
from employee
where phone not like '010%';

--employee테이블에서 이메일 주소 _의 앞이 4자이면서 dept_code가 D9 또는 D6 이고
--고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원 전체 조회
select *
from employee
where email like '____*_%' escape '*' and (dept_code = 'D9' OR dept_code = 'D6') 
and (hire_date between '90/01/01' and '00/12/01') and salary>=2700000;

--IS NULL / IS NOT NULL (NOT IS NULL)
--EMPLOYEE테이블에서 보너스를 받지 않는 사원의 사번, 이름, 급여, 보너스 조회

select emp_id, emp_name, salary, bonus
from employee
--where bonus = NULL;
where bonus IS NULL;

--employee테이블에서 보너스를 받는 사원의 사번, 이름, 급여, 보너스 조회
select emp_id, emp_name, salary, bonus
from employee
--where bonus != NULL;
--where bonus is not null;
where not bonus is null;

--employee테이블에서 관리자도 없고 부서 배치도 받지 않은 직원의 이름, 관리자 번호, 부서코드 조회
select emp_name,manager_id,dept_code
from employee
where manager_id is null and dept_code is null;

--employee테이블에서 부서 배치를 받지 않았지만 보너스를 지급 받는 직원의 이름, 보넛, 부서코드 조회
select emp_name,bonus,dept_code
from employee
where dept_code is null and bonus is not null;

-- IN : 목록에 일치하는 값이 있으면
-- 컬럼명 IN (값1, 값2, 값3, ...)

--D6부서와 D9부서원들의 이름,부서코드,급여조회
select emp_name,dept_code,salary
from employee
--where dept_code = 'D6' OR dept_code = 'D9';
where dept_code IN('D6','D9');

--직급코드가 J1,J2,J3,J4인 사람들의 이름, 직급코드, 급여조회
select emp_name,job_code,salary
from employee
--where job_code ='J1' OR job_code ='J2' OR job_code ='J3' OR job_code ='J4'
where job_code in('J1','J2','J3','J4');

--연결 연산자 ||
--employee테이블에서 사번, 이름, 급여를 연결하여 조회
select emp_id || emp_name || salary
from employee;

--employee 테이블에서 '사원 명의 월급은 급여원입니다' 형식으로 조회
select emp_name ||'의 월급은 ' || salary ||'원입니다'
from employee;

select emp_name as 이름, salary || '원'급여, salary*12 || '원' as 연봉, 
    (salary*(bonus+1))*12 ||'원' "총수령액(보너스포함)",
    salary*(bonus+1)*12 - salary*12*0.03 || '원' as "실수령액"
from employee
where bonus is not null;
