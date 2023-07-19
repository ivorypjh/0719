-- 데이터베이스 사용 설정
USE mysql;

-- 테이블 생성
-- 테이블 이름은 contact
-- 속성
	-- num 은 정수이고 일련번호 그리고 기본키
	-- name 은 한글 7자까지 저장하고 글자 수는 변경되지 않는다 가정
	-- address 는 한글 100자까지 저장하고 글자 수의 변경이 자주 발생
	-- tel 은 숫자로된 문자열 11자리이고 글자 수의 변경은 발생하지 않음
	-- email 은 영문 100자 이내이고 글자 수의 변경이 자주 발생
	-- birthday 는 날짜만 저장
	-- 주로 조회를 하고 일련번호는 1부터 시작하며 인코딩은 utf8.

-- 들여쓰기는 상관 없음
CREATE TABLE contact(
	num INTEGER auto_increment PRIMARY KEY,
	name varchar(21),	-- 한글이므로 곱하기 3
	address text,		-- 길이 300은 CHAR로 저장할 수 없으므로 text 사용
	tel varchar(11),
	email char(100),
	birthday DATE 		-- 날짜를 저장하는 DATE
) ENGINE = MyISAM auto_increment = 1 DEFAULT charset = utf8;
-- 조회를 주로 하는게 목적이므로 엔진으로 MyISAM 사용

-- contact 테이블에 age 컬럼을 정수 자료형으로 추가
ALTER TABLE contact
ADD age int;

-- contact 테이블의 구조 확인
desc contact;

show tables;

-- contact 테이블의 age 컬럼을 삭제
ALTER TABLE contact 
DROP age;

-- contact 테이블에서 tel 컬럼의 이름을 phone 으로 자료형은 정수로 수정
ALTER TABLE contact 
change tel phone int;

-- contact table 에서 birthday 를 name 다음으로 이동
ALTER TABLE contact 
modify column birthday date after name;

-- contact 테이블 삭제
DROP TABLE contact 

show tables;

-- DEPT 테이블은 EMP 테이블에서 DEPTNO 컬럼을 참조하고 있으므로 삭제 불가
drop table DEPT;

-- NOT NULL 제약 조건을 가지는 테이블
CREATE TABLE Nulltable(
	name CHAR(10) NOT NULL,
	age int
);

insert INTO Nulltable(name, age) values('박', 10);
-- NOT NULL 로 설정된 name 데이터를 넣지 않아서 에러 발생
insert INTO Nulltable(age) values(15)

drop table Nulltable

-- 테이블에 기본값 설정
CREATE TABLE Nulltable(
	name CHAR(10) NOT NULL,
	age int default 0
);

insert INTO Nulltable(name, age) values('박', 10);
-- name 데이터만 입력해도 age 컬럼에는 자동으로 default 값인 0이 삽입됨
insert INTO Nulltable(name) values('나')

select *
from Nulltable;

-- name, gender(성별 - 남 또는 여), age(양수)를 속성으로 갖는 테이블
CREATE TABLE tCheck(
	name char(10) not null,
	gender CHAR(3) CHECK(gender in ('남', '여')),
	age int CHECK(age >= 0)
);

INSERT INTO tCheck(NAME, GENDER, AGE) VALUES ('박', '남', 23);
-- GENDER 가 '남성' 으로 입력되어서 에러
INSERT INTO tCheck(NAME, GENDER, AGE) VALUES ('이', '남성', 27);
-- AGE 가 음수로 입력되어서 에러
INSERT INTO tCheck(NAME, GENDER, AGE) VALUES ('김', '여', -23);

SELECT *
FROM tCheck;

-- 테이블의 AGE 에 대한 제약 수정
ALTER TABLE tCheck
MODIFY AGE INT CHECK(AGE >= 0 AND AGE < 200);

-- AGE 가 200이 넘어서 에러
INSERT INTO tCheck(NAME, GENDER, AGE) VALUES ('박', '남', 223);


-- 기본키 설정 : 제약 조건의 이름 없이 생성
CREATE TABLE PRI1(
	NAME CHAR(10) PRIMARY KEY,
	AGE INT
)

-- 기본키 설정 : 제약 조건의 이름과 함께 생성
-- 보통 컬럼 이름 뒤에는 제약 조건을 만들지 않음
CREATE TABLE PRI2(
	NAME CHAR(10) CONSTRAINT PRI2_PK PRIMARY KEY,
	AGE INT
)

-- 기본키 설정 : 제약 조건의 이름과 함께 생성
-- 컬럼이 모두 끝난 마지막에 제약 조건을 설정하는 테이블 제약 조건
CREATE TABLE PRI3(
	NAME CHAR(10) NOT NULL,
	AGE INT
	CONSTRAINT PRI3_PK PRIMARY KEY(NAME),
)

-- 기본키 설정 : 2개의 COLUMN을 가지고 생성
-- 테이블을 생성할 때 PRIMARY KEY 는 1번 만 사용해야 하므로 에러
CREATE TABLE PRI4(
	NAME CHAR(10) PRIMARY KEY,
	AGE INT PRIMARY KEY
)

-- 2개 이상의 컬럼에 대해 PRIMARY KEY로 만들려면 테이블 제약 조건으로 만들어야 함
CREATE TABLE PRI5(
	NAME CHAR(10),
	AGE INT
	CONSTRAINT PRI5_PK PRIMARY KEY(NAME, AGE)
)

-- 정상 처리됨
INSERT INTO PRI1(NAME, AGE) VALUES ('박', 25);
-- PRIMARY KEY 인 NAME 이 중복되어서 에러
INSERT INTO PRI1(NAME, AGE) VALUES ('박', 23);
-- PRIMARY KEY 인 NAME 이 입력되지 않고 NULL 이 되어서 에러
INSERT INTO PRI1(AGE) VALUES (25);


-- 컬럼에 UNIQUE 제약 조건 설정
CREATE TABLE UNI(
	NAME CHAR(10),
	AGE INT UNIQUE,
	CONSTRAINT UNI PRIMARY KEY(NAME)
);

INSERT INTO UNI(NAME, AGE) VALUES ('박', 25);
-- AGE 가 중복이기에 UNIQUE 제약 조건 때문에 에러 발생
INSERT INTO UNI(NAME, AGE) VALUES ('김', 25);
-- AGE 를 입력하지 않았지만 NOT NULL 이 아니므로 에러가 생기지 않음
-- NULL 은 중복 체크의 대상이 아니라서 삽입도 가능하고 중복도 가능함
INSERT INTO UNI(NAME) VALUES ('김');

SELECT *
FROM UNI

DROP TABLE UNI;



-- 외래키를 지정하지 않는 2개의 테이블

-- 직원 테이블
CREATE TABLE EMPLOYEE(
	NAME CHAR(10) PRIMARY KEY,
	AGE INT NOT NULL
);

INSERT INTO EMPLOYEE(NAME, AGE) VALUES('김', 20);
INSERT INTO EMPLOYEE(NAME, AGE) VALUES('나', 25);
INSERT INTO EMPLOYEE(NAME, AGE) VALUES('이', 32);

SELECT *
FROM EMPLOYEE
ORDER BY AGE DESC;

-- 월급 테이블
-- EMPLOYEE 는 월급을 받는 직원 이름
CREATE TABLE SALARY(
	ID INT PRIMARY KEY,
	EMPLOYEE CHAR(10) NOT NULL,
	SAL INT NOT NULL
);

INSERT INTO SALARY VALUES(1, '김', 1000);
-- 직원 테이블에 없는 '강' 은 데이터가 입력되지 말아야 하는데 입력이 가능
-- 외래키를 사용하지 않아서 테이블 사이에 일관성이 없는 현상
INSERT INTO SALARY VALUES(2, '강', 1200);

SELECT *
FROM SALARY

DROP TABLE SALARY;
DROP TABLE EMPLOYEE;

SHOW TABLES;

-- 외래키 설정 - 직원과 월급은 1 : n 관계
-- 직원 테이블
CREATE TABLE EMPLOYEE(
	NAME CHAR(10) PRIMARY KEY,
	AGE INT NOT NULL
);

INSERT INTO EMPLOYEE(NAME, AGE) VALUES('김', 20);
INSERT INTO EMPLOYEE(NAME, AGE) VALUES('나', 25);
INSERT INTO EMPLOYEE(NAME, AGE) VALUES('이', 32);

SELECT *
FROM EMPLOYEE;

-- 월급 테이블
-- EMPLOYEE 는 월급을 받는 직원 이름
-- EMPLOYEE 테이블의 NAME을 참조함
CREATE TABLE SALARY(
	ID INT PRIMARY KEY,
	EMPLOYEE CHAR(10) NOT NULL REFERENCES EMPLOYEE(NAME),
	SAL INT NOT NULL
);

-- 테이블 제약 조건 방식으로 외래키 설정
-- 위의 컬럼 제약 조건 방식보다 권장하는 방식
CREATE TABLE SALARY(
	ID INT PRIMARY KEY,
	EMP CHAR(10) NOT NULL ,
	SAL INT NOT NULL,
	CONSTRAINT UNI FOREIGN KEY(EMP) REFERENCES EMPLOYEE(NAME)
);


INSERT INTO SALARY VALUES(1, '김', 2000);
-- '강' 은 EMPLOYEE 테이블에 없는 이름이라서 삽입 불가
INSERT INTO SALARY VALUES(2, '강', 2200);
DELETE FROM EMPLOYEE WHERE NAME = '나';
-- '김' 은 SALARY 테이블에서 참조하고 있기 때문에 삭제할 수 없음
-- 마찬가지로 참조로 인해 EMPLOYEE 테이블도 삭제할 수 없음
DELETE FROM EMPLOYEE WHERE NAME = '김';

SELECT *
FROM EMPLOYEE;


DROP TABLE SALARY;
DROP TABLE EMPLOYEE;

SHOW TABLES;


-- 외래키 설정 - 기존과 변화 없음
-- 직원 테이블
CREATE TABLE EMPLOYEE(
	NAME CHAR(10) PRIMARY KEY,
	AGE INT NOT NULL
);

INSERT INTO EMPLOYEE(NAME, AGE) VALUES('김', 20);
INSERT INTO EMPLOYEE(NAME, AGE) VALUES('나', 25);
INSERT INTO EMPLOYEE(NAME, AGE) VALUES('이', 32);

SELECT *
FROM EMPLOYEE;

-- 테이블 제약 조건 방식으로 외래키 설정
-- EMPLOYEE 테이블의 NAME 과 같이 삭제되고 같이 수정되는 방식
CREATE TABLE SALARY(
	ID INT PRIMARY KEY,
	EMP CHAR(10) NOT NULL ,
	SAL INT NOT NULL,
	CONSTRAINT UNI FOREIGN KEY(EMP) REFERENCES EMPLOYEE(NAME)
	ON DELETE CASCADE ON UPDATE CASCADE 
);


INSERT INTO SALARY VALUES(1, '김', 2000);

-- EMPLOYEE 테이블에서 '김' 을 '박'으로 수정
UPDATE EMPLOYEE SET NAME = '박' WHERE NAME = '김';

SELECT *
FROM EMPLOYEE;

-- EMPLOYEE 테이블만 수정했는데 SALARY 테이블도 함께 수정됨
SELECT *
FROM SALARY;

DELETE FROM EMPLOYEE WHERE NAME = '박';

-- EMPLOYEE 테이블만 삭제했는데 SALARY 테이블도 함께 삭제됨
SELECT *
FROM SALARY;

drop table SALARY;

-- EMPLOYEE 테이블의 NAME 이 삭제되면 해당 데이터가 NULL 이 됨
CREATE TABLE SALARY(
	ID INT PRIMARY KEY,
	EMP CHAR(10),
	SAL INT NOT NULL,
	CONSTRAINT UNI FOREIGN KEY(EMP) REFERENCES EMPLOYEE(NAME)
	ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO SALARY VALUES(1, '이', 2000);
-- EMPLOYEE 테이블에서 '이' 가 사라져서 SALARY 테이블의 EMP 에 NULL 이 삽입됨
DELETE FROM EMPLOYEE WHERE NAME = '이';

SELECT *
FROM SALARY;

SHOW TABLES;

DROP TABLE SALARY;
DROP TABLE EMPLOYEE;


-- 일련번호 적용
CREATE TABLE BOARD(
	NUM INT AUTO_INCREMENT UNIQUE,
	TITLE CHAR(100),
	CONTENT TEXT
);
-- 자동으로 NUM 에 1, 2 가 삽입됨
INSERT INTO BOARD(TITLE, CONTENT) VALUES ('제1', '내1');
INSERT INTO BOARD(TITLE, CONTENT) VALUES ('제2', '내2');

DELETE FROM BOARD WHERE NUM = 2;
-- 2번 데이터를 삭제해도 COUNT는 유지되기 때문에 다음으로 3이 삽입됨
INSERT INTO BOARD(TITLE, CONTENT) VALUES ('제3', '내3');

-- AUTO_INCREMENT 자리에 값을 직접 넣을 수 있음
INSERT INTO BOARD(NUM, TITLE, CONTENT) VALUES (10, '제3', '내3');
-- NUM 자리에 11이 삽입됨
INSERT INTO BOARD(TITLE, CONTENT) VALUES ('제?', '내?');


-- 일련번호 초기화
-- 다음 삽입에서 NUM 이 100이 됨
ALTER TABLE BOARD AUTO_INCREMENT = 100;
INSERT INTO BOARD(TITLE, CONTENT) VALUES ('제?', '내?');

SELECT *
FROM BOARD;

SELECT *
FROM information_schema.table_constraints;


DESC tCity;

-- 모든 컬럼 값을 순서대로 입력하여 컬럼 이름 생략하고 삽입
INSERT INTO tCity VALUES('제주', 100, 50, 'n', '제주');

-- NOT NULL 이 설정된 컬럼을 제외하고는 생략하고 삽입 가능
INSERT INTO tCity(name, metro, region) VALUES('경기도', 'y', '경기');

-- VALUES 뒤에 여러 데이터를 넣어서 한 번에 삽입
INSERT INTO tCity 
VALUES('여수', 800, 26, 'n', '전라'), ('포항', 850, 34, 'n', '경상');

SELECT *
FROM tCity;

-- tCity 테이블에서 NAME 이 포항 인 데이터 삭제
DELETE FROM tCity WHERE name = '포항';

-- tCity 테이블에서 NAME 이 여수 인 데이터의 area 를 업데이트
UPDATE tCity SET area = 700 WHERE name = '여수';

