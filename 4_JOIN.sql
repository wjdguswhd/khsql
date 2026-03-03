-- JOIN : 하나 이상의 테이블에서 데이터를 조회하기 위해 사용
-- 테이블 연결은 같은 데이터 값으로

--사번, 사원명, 부서코드, 부서명 조회
--사번, 사원명, 부서코드 -> employee(emp_id, emp_name, dept_code)
--부서코드, 부서명 -> department(dept_id, dept_title)

select emp_id, emp_name, dept_code
from employee;

select dept_id, dept_tilte
from department;
--dept_code에 들어가 있는 값과 dept_id에 들어가 있는 값이 같으므로 서로 연결(join) 가능

--내부 조인(inner join) : 오라클 구문, ansi 표준 구문
--오라클 구문 : from절에 모든 테이블 명 기술, where절에 합치기에 사용할 컬럼 명시
--사번, 사원명, 부서코드, 부서 명 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE,DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
where dept_code = dept_id;

--사번, 사원명, 직급코드, 직급명
select emp_id, emp_name , job.job_code, job_name
from employee , job
where employee.job_code=job.job_code;

select emp_id, emp_name ,e.job_code, job_name
from employee e , job j
where e.job_code=j.job_code;

--ansi 표준 구문 : from절에 연결한 테이블 명 JOIN으로 연결  컬럼 명에 따라 ON/USING 사용

--사번, 사원명, 부서코드, 부서명조회
select emp_id, emp_name, dept_code, dept_title
from employee 
    join department on(dept_code = dept_id);

--사번, 사원명, 직급코드, 직급명조회
select emp_id, emp_name, job_code,job_name
from employee 
    join job using(job_code);
    
select emp_id, emp_name, e.job_code,job_name
from employee e
    join job j on(e.job_code = j.job_code);
    
--부서 명과 해당 부서의 지역 명 조회
--오라클
select dept_title, local_name
from department d, location l
where d.location_id = l.local_code;

--ansi
select dept_title, local_name
from department
    join location on(location_id = local_code);
    
    
--외부 조인(OUTER JOIN) : 컬럼 값이 일치하지 않는 행도 조인에 포함

--LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중  기술된 테이블의 행을 기준으로 join
--사원명,부서명 조회왼편에
--ansi
select emp_name,dept_title
from employeeleft join department on(dept_code= dept_id);
--오라클 : 기준이 아닌 테이블의 컬럼에 (+) 붙이기
select emp_name, dept_title
from employee, department
where dept_code = dept_id(+);

--RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 행을 기준으로 join
--ansi
select emp_name,dept_title
from employee right join department on(dept_code= dept_id);

--오라클
select emp_name,dept_title
from employee,department
where dept_code(+) = dept_id;
    
--FULL [OUTER] JOIN : 합치기에 사용한 두 테이블 모두를 기준으로 join
--ansi
select emp_name, dept_title
from employee
    full outer join department on(dept_code = dept_id);
    
--오라클
select emp_name, dept_title
from employee, department
where dept_code(+) = dept_id(+);


--다중조인
--사번, 사원명, 부서코드, 부서명, 근무지역명
--오라클
select emp_id, emp_name, dept_code, dept_title, local_name
from employee, department, location
where dept_code = dept_id
      and location_id = local_code;

--ansi
select emp_id, emp_name, dept_id, dept_title, local_name
from employee
    join department on(dept_code = dept_id)
    join location on(location_id = local_code);
    
--직급이 대리이면서 아시아 지역에 근무하는 직원의 사번, 이름, 직급명, 부서명, 근무지역명, 급여조회
--오라클
select emp_id,emp_name,job_name,dept_title,local_name,salary
from employee,department,job,location
where employee.job_code=job.job_code 
      and dept_code = dept_id 
      and location_id = local_code
      and job_name = '대리'
      and local_name like 'ASIA%';
      
--ansi
select emp_id, emp_name, job_name, dept_title, local_name, salary
from employee
    join job using(job_code)
    join department on(dept_code = dept_id)
    join location on(location_id = local_code)
where job_name = '대리'
    and local_name like 'ASIA%';

