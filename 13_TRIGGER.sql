--TRIGGER : 테이블이나 뷰가 DML문(INSERT, UPDAET, DELETE)에 의해 변경될 경우,
--          자동으로 실행될 내용을 정의하여 저장하는 객체

CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
END;
/
INSERT INTO EMPLOYEE VALUES(999,'홍하하','990611-1454545','hong_hh@kh.or.kr','01012343212','D5','J3','S5',
            3000000,0.1,200,SYSDATE,NULL,DEFAULT);
            
/* 트리거 표현식
CREATE OR REPLACE TRIGGER 트리거명
BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명
[FOR EACH ROW]
[WHEN 조건]
DECLARE
    선언부
BEGIN
    실행부
EXCEPTION
    예외처리부
END;
/
*/

--트리거 종류
--SQL문의 실행 시기에 따른 분류
--      BEFORE TRIGGER : SQL문 실행 전 트리거 실행
--      AFTER TRIGGER : SQL문 실행 후 트리거 실행
--SQL문에 의해 영향을 받는 각 ROW에 따른 분류
--      ROW TRIGGER         :행 트리거, FOR EACH ROW 옵션 작성  
--                           SQL문 각 FOW에 대해 한 번씩 실행
--                            :OLD 참조 전의 열의 값 (INSERT : NULL / UPDATE : 수정 전 값 / DELETE : 삭제할 값)
--                            :NEW 참조 후의 열의 값 (INSERT : 입력 값 / UPDATE : 수정 후 값 / DELETE : NULL)
--      STATEMENT TRIGGER   :문장 트리거, DEFAULT TRIGGER
--                           SQL문에 대해 한 번만 실행    

COMMIT;

--상품 정보 테이블
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY,-- 상품코드
    PNAME VARCHAR2(30),      -- 상품 명
    BRAND VARCHAR2(30),      -- 브랜드
    PRICE NUMBER,            -- 가격
    STOCK NUMBER DEFAULT 0   -- 재고
);

CREATE SEQUENCE SEQ_PCODE;
INSERT INTO PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '다이제', '오리온', 2500, DEFAULT);
INSERT INTO PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '새우깡', '농심', 1000, DEFAULT);
INSERT INTO PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '홈런볼', '해태', 1500, DEFAULT);

select * from product;


--상품 입출고 상세 이력 테이블
create table PRO_DETAIL(
    dcode number primary key,  --상세 코드
    pcode number,              --상품 코드
    pdate date,                --상품 입출고일
    amount number,             --입출고 개수
    status varchar2(10) check(status in('입고','출고')),--상품 상태(입고/출고)
    foreign key(pcode) references product(pcode)
);
create sequence SEQ_DCODE;

SELECT * FROM PRO_DETAIL;
SELECT * FROM PRODUCT;

INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 10,'입고');
UPDATE PRODUCT SET STOCK = STOCK+10 WHERE PCODE=2;
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 20,'입고');
UPDATE PRODUCT SET STOCK = STOCK+20 WHERE PCODE=3;

--1번 상품 7개 입고
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 7,'입고');
UPDATE PRODUCT SET STOCK = STOCK+7 WHERE PCODE=1;

--2번 상품 3개 출고
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 3,'출고');
UPDATE PRODUCT SET STOCK = STOCK-3 WHERE PCODE=2;

CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON PRO_DETAIL
FOR EACH ROW 
BEGIN
    -- 상품이 입고된 경우
    IF : NEW.STATUS = '입고'
    THEN 
        UPDATE PRODUCT SET STOCK = STOCK + :NEW.AMOUNT WHERE PCODE = :NEW.PCODE;
    END IF;
    
    -- 상품이 출고된 경우
    IF : NEW.STATUS = '출고'
    THEN
        UPDATE PRODUCT SET STOCK = STOCK - :NEW.AMOUNT WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/
COMMIT;

SELECT * FROM USER_TRIGGERS;



