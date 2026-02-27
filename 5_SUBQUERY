--SUBQUERY : 메인 쿼리를 위해 보조 역할을 하는 쿼리문
-- = 하나의 SQL문 안에 포함된 또 다른 SQL문

--부서코드가 노옹철 사원과 같은 소속의 직원명단조회
--1) 노옹철 사원의 부서코드
select dept_code from employee where emp_name = '노옹철'; 
--2) 부서코드가 D9인 직원 명단 조회
select emp_name from employee where dept_code = 'D9';

select emp_name
from employee
where dept_code = (select dept_code
                   from employee    
                   where emp_name = '노옹철');
--서브쿼리 규칙1. 반드시 소괄호로 감싸주어야 함.
--서브쿼리 규칙2. 비교할 메인 쿼리의 컬럼과 개수, 자료형 일치

--전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여조회
--1) 전 직원의 평균 급여
select avg(salary) from employee;
--2) 3047662.60869565217391304347826086956522 많이 받는 직원 조회
select emp_id , emp_name, job_code, salary
from employee
where salary>3047662.60869565217391304347826086956522 ;

--1) + 2)
select emp_id, emp_name, job_code, salary
from employee
where salary > (select avg(salary) from employee);

--단일행 서브쿼리 : 서브쿼리의 조회 결과 행 개수가 1개
--노옹철 사원의 급여보다 많이 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여조회
select emp_id,emp_name,dept_code,job_code,salary
from employee
where salary > (select salary from employee where emp_name='노옹철');

--전 직원의 급여 평균보다 적은 급여를 받은 직원의 이름, 직급코드, 부서코드, 급여 조회
select emp_name,job_code,dept_code,salary
from employee
where salary < (select avg(salary) from employee);

--가장적은 급여를 받는 직원의 사번, 이름, 직급코드, 부서코드, 급여, 입사일 조회
select emp_id, emp_name,job_code,dept_code,salary,hire_date
from employee
where salary = (select min(salary) from employee);  

--부서 별 급여 합계 중 가장 큰 부서의 부서명, 급여 합계 조회
--*서브쿼리는 select, where, having, from절에 사용될 수 있음
--1) 부서 별 급여 합계
select sum(salary)
from employee
group by dept_code;

--2) 부서 별 급여 합계 중 가장 큰 급여 합계
select max(sum(salary))
from employee
group by dept_code;

--3) 부서 별 급여 합계가 17700000인 부서명, 급여합계
select dept_title, sum(salary)
from employee
    join department on (dept_code = dept_id)
group by dept_title
having sum(salary) = 17700000;

-- 1)+2)+3)
select dept_title, sum(salary)
from employee
    join department on(dept_code = dept_id)
group by dept_title
having sum(salary) =(select max(sum(salary))
                    from employee
                    group by dept_code);

--다중행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개
--in/not in : 여러 개의 결과 값 중 한개 라도 일치하는 값이 있다면/없다면
-- >any, <any : 여러개의 결과 값중에서 하나라도 큰/작은 경우
--             =가장 작은 값보다 크냐 / 가장 큰 값보다 작냐
-- >all, <all : 모든 값보다 큰/작은 경우
--             =가장 큰 값보다 크냐 / 가장 작은 값보다 작냐

--부서 별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회
--1) 부서 별 최고 급여
select max(salary)
from employee
group by dept_code;

--2)
select emp_name, job_code, dept_code, salary
from employee
where salary in(select max(salary)
                from employee
                group by dept_code);
                
--관리자와 일반 직원에 해당하는 사원 정보추출
--사번, 이름, 부서명, 직급, 구분(관리자/직원)
--1) 관리자에 해당하는 사원 번호 관리
select distinct manager_id
from employee
where manager_id is not null;

select emp_id, emp_name,dept_title, job_name,'직원' 구분
from employee
    left join department on(dept_code = dept_id)
    join job using(job_code)
where emp_id in(select distinct manager_id
            from employee
            where manager_id is not null)
union
select emp_id, emp_name,dept_title, job_name, '관리자 ' 구분
from employee
    left join department on(dept_code = dept_id)
    join job using(job_code)
where emp_id in(select distinct manager_id
            from employee
            where manager_id is not null);  
            
            
            
select emp_id, emp_name, dept_title, job_name,
    case when emp_id in(select distinct(manager_id)
                    from employee
                    where manager_id is not null)then '관리자'
        else'직원'
    end 구분
from employee
    left join department on(dept_code = dept_id)
    join job using(job_code);
    
--대리 직급의 직원들 중 과장 직급의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급, 급여 조회  
select emp_id, emp_name,job_name,salary
from employee
    join job using(job_code)
where job_name = '대리'
    and salary > (select min(salary)
                 from employee
                    join job using(job_code)
                 where job_name = '과장');
                 
select emp_id, emp_name,job_name,salary
from employee
    join job using(job_code)
where job_name = '대리'
    and salary > any(select salary
                 from employee
                    join job using(job_code)
                 where job_name = '과장'); 
                 
--차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 사번, 이름, 직급, 급여조회
select emp_id,emp_name,job_name,salary
from employee
    join job using(job_code)
where job_name = '과장'
    and salary > (select max(salary)
                    from employee
                        join job using(job_code)
                    where job_name = '차장');
                    
select emp_id,emp_name,job_name,salary
from employee
    join job using(job_code)
where job_name = '과장'
    and salary > all(select salary
                    from employee
                        join job using(job_code)
                    where job_name = '차장');
                    
--다중 열 서브쿼리 : 서브쿼리 select절에 나열된 항목 수가 여러 개
--퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 이름, 직급코드, 부서코드, 입사일조회

    
select emp_name, job_code, dept_code,hire_date
from employee
where (dept_code, job_code) = (select dept_code, job_code
                                from employee
                                where ent_yn = 'Y'
                                 and substr(emp_no, instr(emp_no,'-')+1,1) = 2);
 --다중 행 다중 열 서브쿼리
 --자기 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여조회
 --단, 급여 평균은 십만원단위로 계산(TRUNC(컬럼명, -5))
 
select emp_id,emp_name,job_code,salary
from employee
where(job_code,salary) in (select job_code, trunc(avg(salary),-5)
                     from employee
                     group by job_code);

--ROWNUM : 조회된 순서대로 1부터 번호 매김                    
select rownum emp_id,emp_name,job_code,salary
from employee
where(job_code,salary) in (select job_code, trunc(avg(salary),-5)
                     from employee
                     group by job_code);                    

--전 직원 중 급여가 높은 상위 5명의 순위, 이름, 급여 조회
select rownum, emp_name, salary
from employee
where rownum <=5
order by salary desc;

--INLINE VIEW : FROM절에 서브쿼리 = 원하는 판으로 구성 가능
select rownum, emp_name, salary
from ( select * from employee order by salary desc)
where rownum <=5;

--from절에 있는 판은 emp_name, salary만 존재하므로 email추출 불가
select rownum, emp_name, salary,email
from ( select emp_name,salary from employee order by salary desc)
where rownum <=5;

select rownum, 이름, 급여
from ( select emp_name 이름, salary 급여 from employee order by salary desc)
where rownum <=5;

--rank() over/dense_rank() over
select rank() over(order by salary desc) r, dense_rank() over(order by salary desc) dr,
        emp_name, salary
from employee;
