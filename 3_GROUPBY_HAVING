--GROUP BY : 여러 개의 값을 묶어서 그룹 기준 제시
select dept_code, sum(salary)
from employee;

--각 부서 별 급여 합계 조회
select dept_code, sum(salary)
from employee
group by dept_code;

--employee테이블에서 부서 코드 별 그룹을 지정하여
--부서코드, 그룹 별 급여 합계, 그룹 별 급여 평균, 인원수 조회
select dept_code,sum(salary),avg(salary), count(*)
from employee
group by dept_code;


--employee테이블에서 부서코드와 보너스 받는 사원 수 조회
select dept_code,count(bonus)
from employee
group by dept_code;

--employee테이블에서 성별과 성별 별 급여 평균, 급여합계, 인원 수 주회
select decode(substr(emp_no, instr(emp_no,'-')+1,1), '1','남','여') 성별,
        avg(salary), sum(salary), count(*)
from employee
group by substr(emp_no, instr(emp_no,'-')+1,1);

--employee테이블에서 부서코드 별로 같은 직급인 사원의 급여 합계 조회
select dept_code, job_code, sum(salary)
from employee
group by dept_code, job_code;

--HAVING : 그룹함수에 대한 조건 설정
--부서코드와 급여 300만 이상인 직원의 그룹 별 평균 급여 조회
select dept_code , avg(salary)
from employee
where salary >= 3000000
group by dept_code;

--부서코드와 급여 평균이 300만 이상인 그룹 조회
select dept_code, avg(salary)
from employee
group by dept_code
having avg(salary) >=3000000;

--부서 별 그룹의 급여 합계중 9백만원을 초과하는 부서 코드와 합계 조회
select dept_code, sum(salary)
from employee
group by dept_code
having sum(salary) >= 9000000;

/*
select문, 6개의 절 구성

5      select     조회할 컬럼
1      from       참조할 테이블 명
2      where      일반 컬럼 조건식
3      group by   그룹함수에 적용할 그룹 기준
4      having     그룹함수 조건식
6      order by   정렬기준

*/

--order by 컬럼명|컬럼별칭|컬럼순번 [ASC]|DESC [NULLS FIRST|LAST]
select emp_id, emp_name, salary, dept_code
from employee
--order by emp_name; --이름 오름차순
--order by emp_name asc; --이름 오름차순
--order by emp_name desc; --이름 내림차순
--order by 급여 DESC; --급여 내림차순
--order by 1;
--ORDER BY DEPT_CODE NULLS FIRST;
--ORDER BY DEPT_CODE DESC NULL LAST;
order by dept_code, emp_name;

--집합 연산자 : 여러가지 조건이 있을 때 그에 해당하는 여러개의 결과 값을 결합하고 싶을 때

--UNION = 합집합(OR)
select emp_id, emp_name from employee
--where emp_id = 200 or emp_id = 201;
where emp_id in (200,201);

select emp_id, emp_name
from employee
where emp_id = 200;
union
select emp_id, emp_name
from employee
where emp_id = 201;


select emp_name
from employee
where emp_id = 200
union
select dept_title
from department
where dept_id = 'D9';
--SELECT에서 참조하는 컬럼개수가 다르거나 , 타입형이 다르면 오류가남 (문자,숫자 등)
--union은 중복제거

--UNION ALL = 합집합+교집합
--INTERSECT = 교진합(AND)
--MINUS = 차집합
select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
intersect -- AND , 중복제거
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000;
--D5 부서인 직원 , 급여가 300만원 초과인 직원 두 조건을 모두 만족하는 직원만 출력

select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
union all
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000;
--D5 부서 직원, 급여 300만원 초과 직원 두 결과를 그대로 다 합침 ,중복제거안함

select emp_id, emp_name, dept_code, salary
from employee
where dept_code = 'D5'
minus
select emp_id, emp_name, dept_code, salary
from employee
where salary > 3000000;
--D5 부서 직원 중에서 급여 300만원 초과인 사람을 빼라
-- ->D5 부서이면서 급여가 300만원 이하인 직원

