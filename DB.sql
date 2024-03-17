DROP DATABASE IF EXISTS `Spring_AM_01`;
CREATE DATABASE `Spring_AM_01`;
USE `Spring_AM_01`;

# article 테이블 생성
CREATE TABLE article(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    title CHAR(100) NOT NULL,
    `body` TEXT NOT NULL
);

# member 테이블 생성
CREATE TABLE `member`(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    loginId CHAR(20) NOT NULL,
    loginPw CHAR(80) NOT NULL,
    `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반,7=관리자)',
    `name` CHAR(20) NOT NULL,
    nickname CHAR(20) NOT NULL,
    cellphoneNum CHAR(20) NOT NULL,
    email CHAR(50) NOT NULL,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
    delDate DATETIME COMMENT '탈퇴 날짜'
);


# article TD 생성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목4',
`body` = '내용4';

# member TD 생성
# (관리자)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = 'admin',
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자',
cellphoneNum = '01012341234',
email = 'abcd@gmail.com';

# (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`name` = '회원1',
nickname = '회원1',
cellphoneNum = '01043214321',
email = 'abcde@gmail.com';

# (일반)
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = '회원2',
nickname = '회원2',
cellphoneNum = '01056785678',
email = 'abcdef@gmail.com';

ALTER TABLE article ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER updateDate;

UPDATE article
SET memberId = 2
WHERE id IN (1,2);

UPDATE article
SET memberId = 3
WHERE id IN (3,4);


# board 테이블 생성
CREATE TABLE board(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `code` CHAR(50) NOT NULL UNIQUE COMMENT 'notice(공지사항), free(자유), QnA(질의응답) ...',
    `name` CHAR(20) NOT NULL UNIQUE COMMENT '게시판 이름',
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
    delDate DATETIME COMMENT '삭제 날짜'
);

# board TD 생성
INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'NOTICE',
`name` = '공지사항';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'FREE',
`name` = '자유';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'QnA',
`name` = '질의응답';

ALTER TABLE article ADD COLUMN boardId INT(10) UNSIGNED NOT NULL AFTER `memberId`;

UPDATE article
SET boardId = 1
WHERE id IN (1,2);

UPDATE article
SET boardId = 2
WHERE id = 3;

UPDATE article
SET boardId = 3
WHERE id = 4;

ALTER TABLE article ADD COLUMN hitCount INT(10) UNSIGNED NOT NULL DEFAULT 0 AFTER `body`;

# reactionPoint 테이블 생성
CREATE TABLE reactionPoint(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
    relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
    `point` INT(10) NOT NULL
);

# reactionPoint 테스트 데이터 생성
# 1번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 1번 회원이 2번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 2번 회원이 1번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 2번 회원이 2번 글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`point` = -1;

# 3번 회원이 1번 글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`point` = 1;

# article 테이블에 좋아요 관련 컬럼 추가
ALTER TABLE article ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE article ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# update join -> 기존 게시물의 good,bad RP 값을 RP 테이블에서 가져온 데이터로 채운다
UPDATE article AS A
INNER JOIN (
    SELECT RP.relTypeCode,RP.relId,
    SUM(IF(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
    SUM(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
    FROM reactionPoint AS RP
    GROUP BY RP.relTypeCode, RP.relId
) AS RP_SUM
ON A.id = RP_SUM.relId
SET A.goodReactionPoint = RP_SUM.goodReactionPoint,
A.badReactionPoint = RP_SUM.badReactionPoint;

# reply 테이블 생성
CREATE TABLE reply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
    relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
    `body`TEXT NOT NULL
);

# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 1';

# 2번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 2';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`body` = '댓글 3';

# 3번 회원이 1번 글에 댓글 작성
INSERT INTO reply
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`body` = '댓글 4';

# reply 테이블에 좋아요 관련 컬럼 추가
ALTER TABLE reply ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE reply ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# reactionPoint 테스트 데이터 생성
# 1번 회원이 1번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 1번 회원이 2번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'reply',
relId = 2,
`point` = 1;

# 2번 회원이 1번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 1,
`point` = -1;

# 2번 회원이 2번 댓글에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'reply',
relId = 2,
`point` = -1;

# 3번 회원이 1번 댓글에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'reply',
relId = 1,
`point` = 1;

# update join -> 기존 게시물의 good,bad RP 값을 RP 테이블에서 가져온 데이터로 채운다
UPDATE reply AS R
INNER JOIN (
    SELECT RP.relTypeCode,RP.relId,
    SUM(IF(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
    SUM(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
    FROM reactionPoint AS RP
    GROUP BY RP.relTypeCode, RP.relId
) AS RP_SUM
ON R.id = RP_SUM.relId
SET R.goodReactionPoint = RP_SUM.goodReactionPoint,
R.badReactionPoint = RP_SUM.badReactionPoint;

###############################################


SELECT * FROM article;
SHOW COLUMNS FROM article;

SELECT * FROM `member`;
SHOW COLUMNS FROM `member`;

SELECT * FROM `board`;
SHOW COLUMNS FROM `board`;

SELECT * FROM reactionPoint;
SHOW COLUMNS FROM reactionPoint;

SELECT * FROM `reply`;
SHOW COLUMNS FROM `reply`;


SELECT goodReactionPoint
FROM article 
WHERE id = 1;

INSERT INTO article
(
    regDate, updateDate, memberId, boardId, title, `body`
)
SELECT NOW(),NOW(), FLOOR(RAND() * 2) + 2, FLOOR(RAND() * 3) + 1, CONCAT('제목_',RAND()), CONCAT('내용_',RAND())
FROM article;

SELECT IFNULL(SUM(RP.point),0)
FROM reactionPoint AS RP
WHERE RP.relTypeCode = 'article'
AND RP.relId = 3
AND RP.memberId = 1;


UPDATE article 
SET title = '제목5'
WHERE id = 5;

UPDATE article 
SET title = '제목11'
WHERE id = 6;

UPDATE article 
SET title = '제목45'
WHERE id = 7;

SELECT FLOOR(RAND() * 2) + 2;

SELECT FLOOR(RAND() * 3) + 1;


SHOW FULL COLUMNS FROM `member`;
DESC `member`;



SELECT LAST_INSERT_ID();


SELECT COUNT(*)
FROM article AS A
WHERE 1
AND boardId = 1
AND A.title LIKE CONCAT('%','0000','%')
OR A.body LIKE CONCAT('%','0000','%')
ORDER BY id DESC;


SELECT hitCount
FROM article
WHERE id = 374;

SELECT A.*
FROM article AS A
WHERE A.id = 1

SELECT A.*, M.nickname AS extra__writer
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
WHERE A.id = 1

# LEFT JOIN
SELECT A.*, M.nickname AS extra__writer, RP.point
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

# 서브쿼리
SELECT A.*,
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(IF(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
FROM (
    SELECT A.*, M.nickname AS extra__writer 
    FROM article AS A
    INNER JOIN `member` AS M
    ON A.memberId = M.id
    ) AS A
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;

# 조인
SELECT A.*, M.nickname AS extra__writer,
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(IF(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
ON A.id = RP.relId AND RP.relTypeCode = 'article'
GROUP BY A.id
ORDER BY A.id DESC;


SELECT *, COUNT(*)
FROM reactionPoint AS RP
GROUP BY RP.relTypeCode,RP.relId

SELECT IF(RP.point > 0, '큼','작음')
FROM reactionPoint AS RP
GROUP BY RP.relTypeCode,RP.relId

# 각 게시물의 좋아요, 싫어요 갯수
SELECT RP.relTypeCode, RP.relId,
SUM(IF(RP.point > 0,RP.point,0)) AS goodReactionPoint,
SUM(IF(RP.point < 0,RP.point * -1,0)) AS badReactionPoint
FROM reactionPoint AS RP
GROUP BY RP.relTypeCode,RP.relId;


###############################################################
# building 테이블 생성
CREATE TABLE building(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    bldgName CHAR(20) NOT NULL,
    bldgAdd VARCHAR(50) NOT NULL,
    roomTotal INT(10) NOT NULL
    );

ALTER TABLE building ADD latitude CHAR(20);
ALTER TABLE building ADD longitude CHAR(20);

SELECT * FROM building;

SELECT *
FROM building AS B
INNER JOIN room AS R
ON B.id = R.bldgId;



# building testdata
INSERT INTO building
SET regDate = NOW(),
updateDate = NOW(),
bldgName = '가나',
bldgAdd = '대전시 송림',
roomTotal = 10,
latitude = 36.3460337761986,
longitude = 127.380830444995;

# building testdata
INSERT INTO building
SET regDate = NOW(),
updateDate = NOW(),
bldgName = '다라',
bldgAdd = '대전시 정림',
roomTotal = 10,
latitude = 36.3473091394007,
longitude = 127.382179238289;

UPDATE building
SET latitude = 36.3460337761986,
longitude = 127.380830444995
WHERE id = 1;

UPDATE building
SET latitude = 36.3473091394007,
longitude = 127.382179238289
WHERE id = 2;

#------------------------------------------------------
# room 테이블 생성
CREATE TABLE room(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    bldgId INT(10) NOT NULL,
    roomNum INT(10) NOT NULL,
    roomType CHAR(20) NOT NULL, 
    standardDeposit INT(10) NOT NULL,
    standardRent INT(10) NOT NULL,
    standardJeonse INT(10) NOT NULL,
    roomArea DOUBLE NOT NULL
);

ALTER TABLE room ADD furnish CHAR(20);

SELECT * FROM room;

SELECT *
FROM room AS R
LEFT JOIN contract AS C
ON R.id = C.roomId
LEFT JOIN building AS B
ON R.bldgId = B.id
LEFT JOIN tenant AS T
ON C.tenantId = T.id
GROUP BY R.id;



# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 101,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 26.10;

# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 102,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 30.25;

# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 201,
roomType = '1.5룸',
standardDeposit = 5000000,
standardRent = 500000,
standardJeonse = 80000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 202,
roomType = '1.5룸',
standardDeposit = 5000000,
standardRent = 500000,
standardJeonse = 80000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 203,
roomType = '투룸',
standardDeposit = 5000000,
standardRent = 600000,
standardJeonse = 100000000,
roomArea = 30.25;


# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 301,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 302,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 48.34;


# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 303,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 30.25;

# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 401,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 30.25;

# room testdata
INSERT INTO room
SET bldgId = 1,
roomNum = 402,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 87.38;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 101,
roomType = '원룸',
standardDeposit = 6000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 30.25;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 102,
roomType = '원룸',
standardDeposit = 6000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 30.25;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 201,
roomType = '1.5룸',
standardDeposit = 6000000,
standardRent = 400000,
standardJeonse = 80000000,
roomArea = 30.25;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 202,
roomType = '1.5룸',
standardDeposit = 6000000,
standardRent =400000,
standardJeonse = 80000000,
roomArea = 30.25;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 203,
roomType = '투룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 100000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 301,
roomType = '원룸',
standardDeposit = 6000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 302,
roomType = '원룸',
standardDeposit = 6000000,
standardRent = 400000,
standardJeonse = 50000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 303,
roomType = '원룸',
standardDeposit = 6000000,
standardRent = 400000,
standardJeonse = 100000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 401,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 100000000,
roomArea = 48.34;

# room testdata
INSERT INTO room
SET bldgId = 2,
roomNum = 402,
roomType = '원룸',
standardDeposit = 5000000,
standardRent = 400000,
standardJeonse = 100000000,
roomArea = 87.38;


SELECT room.* , building.bldgName
FROM room
INNER JOIN building
ON room.bldgId = building.id;


#------------------------------------------------------
# tenant 테이블 생성
CREATE TABLE tenant(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    tenantName CHAR(20) NOT NULL,
    tenantPhone INT(10) NOT NULL,
    tenantCarNum CHAR(20) NOT NULL,
    tenantRegNum INT(10),
    roomId INT(10) NOT NULL
);

SELECT * FROM tenant;

# tenant testdata
INSERT INTO tenant
SET regDate = NOW(),
updateDate = NOW(),
tenantName = '홍길동',
tenantPhone = 01093939393,
tenantCarNum = '02라2032',
roomId = 1;

# tenant testdata
INSERT INTO tenant
SET regDate = NOW(),
updateDate = NOW(),
tenantName = '홍길순',
tenantPhone = 0103453533,
tenantCarNum = '02다3454',
roomId = 2;

# tenant testdata
INSERT INTO tenant
SET regDate = NOW(),
updateDate = NOW(),
tenantName = '이상호',
tenantPhone = 0106562324,
tenantCarNum = '05마4218',
roomId = 6;


# tenant testdata
INSERT INTO tenant
SET regDate = NOW(),
updateDate = NOW(),
tenantName = '김철수',
tenantPhone = 0103453533,
tenantCarNum = '02다3454',
roomId = 10;

# tenant testdata
INSERT INTO tenant
SET regDate = NOW(),
updateDate = NOW(),
tenantName = '이보라',
tenantPhone = 0103453533,
tenantCarNum = '02다3454',
roomId = 15;

# tenant testdata
INSERT INTO tenant
SET regDate = NOW(),
updateDate = NOW(),
tenantName = '강산해',
tenantPhone = 0103453533,
tenantCarNum = '02다3454',
roomId = 16;

# tenant testdata
INSERT INTO tenant
SET regDate = NOW(),
updateDate = NOW(),
tenantName = '김미자',
tenantPhone = 0103453533,
tenantCarNum = '02다3454',
roomId = 17;

SELECT * 
FROM tenant AS T
INNER JOIN contract AS C
ON T.roomId = C.roomId
INNER JOIN room AS R
ON T.roomId = R.id
LEFT JOIN building AS B
ON R.bldgId = B.id;

#------------------------------------------------------
# contract 테이블 생성
CREATE TABLE contract(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    #bldgId INT(10) NOT NULL,
    roomId INT(10) NOT NULL,
    tenantId INT(10) NOT NULL,
    leaseType CHAR(20) NOT NULL,
    deposit CHAR(20) NOT NULL,
    rent CHAR(20) NOT NULL,
    maintenanceFee CHAR(20) NOT NULL,
    contractStartDate CHAR(20) NOT NULL,
    contractEndDate CHAR(20) NOT NULL,
    depositDate CHAR(20) NOT NULL,
    rentDate CHAR(20) NOT NULL
);


# contract testdata
INSERT INTO contract
SET regDate = NOW(),
updateDate = NOW(),
#bldgId =1,
roomId = 1,
tenantId = 1,
leaseType = '월세',
deposit = 5000000,
rent= 500000,
maintenanceFee = 60000,
contractStartDate = '2023.2.2',
contractEndDate= '2025.2.1',
depositDate = 10,
rentDate = 10;

# contract testdata
INSERT INTO contract
SET regDate = NOW(),
updateDate = NOW(),
#bldgId =1,
roomId = 2,
tenantId = 2,
leaseType = '월세',
deposit = 5000000,
rent= 500000,
maintenanceFee = 60000,
contractStartDate = '2022.2.2',
contractEndDate= '2024.6.1',
depositDate = 15,
rentDate = 10;

# contract testdata
INSERT INTO contract
SET regDate = NOW(),
updateDate = NOW(),
#bldgId =2,
roomId = 6,
tenantId = 3,
leaseType = '전세',
deposit = 55000000,
maintenanceFee = 100000,
contractStartDate = '2023.12.2',
contractEndDate= '2025.12.1',
depositDate = 15,
rentDate = 10;

# contract testdata
INSERT INTO contract
SET regDate = NOW(),
updateDate = NOW(),
#bldgId =2,
roomId = 10,
tenantId = 4,
leaseType = '전세',
deposit = 55000000,
maintenanceFee = 100000,
contractStartDate = '2023.12.2',
contractEndDate= '2025.12.1',
depositDate = 15,
rentDate = 15;

# contract testdata
INSERT INTO contract
SET regDate = NOW(),
updateDate = NOW(),
#bldgId =2,
roomId = 15,
tenantId = 5,
leaseType = '월세',
deposit = 5500000,
rent= 400000,
maintenanceFee = 100000,
contractStartDate = '2023.12.2',
contractEndDate= '2025.12.1',
depositDate = 15,
rentDate = 10;


# contract testdata
INSERT INTO contract
SET regDate = NOW(),
updateDate = NOW(),
#bldgId =2,
roomId = 16,
tenantId = 6,
leaseType = '전세',
deposit = 55000000,
maintenanceFee = 100000,
contractStartDate = '2023.12.2',
contractEndDate= '2025.12.1',
depositDate = 15,
rentDate = 20;


# contract testdata
INSERT INTO contract
SET regDate = NOW(),
updateDate = NOW(),
#bldgId =2,
roomId = 17,
tenantId = 7,
leaseType = '월세',
deposit = 5500000,
rent= 500000,
maintenanceFee = 100000,
contractStartDate = '2023.12.2',
contractEndDate= '2025.12.1',
depositDate = 15,
rentDate = 20;

SELECT * FROM contract;

SELECT *
FROM contract AS C
LEFT JOIN room AS R
ON C.roomId = R.id
LEFT JOIN building AS B
ON R.bldgId = B.id
LEFT JOIN tenant AS T
ON C.tenantId = T.id
GROUP BY C.id;


#------------------------------------------------------
# contract_status 테이블 생성
CREATE TABLE contract_status(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    rentDate CHAR(20) NOT  NULL,
    #roomId INT(10) NOT NULL,
    tenantId INT(10) NOT NULL,
    paymentStatus CHAR(20) NOT NULL,
    extraIncome CHAR(20),
    extraExpense CHAR(20)
);

SELECT * FROM contract_status;

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-01',
#roomId = 1,
tenantId = 1,
paymentStatus = '1/11',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-02',
#roomId = 1,
tenantId = 1,
paymentStatus = '2/10',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-03',
#roomId = 1,
tenantId = 1,
paymentStatus = '미납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-01',
#roomId = 2,
tenantId = 2,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
/*INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-02',
#roomId = 2,
tenantId = 2,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';*/

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-02',
#roomId = 2,
tenantId = 3,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
/*INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-01',
#roomId = 2,
tenantId = 4,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';*/

# contract_status testdata
/*INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-02',
#roomId = 2,
tenantId = 4,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';*/


# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-03',
#roomId = 2,
tenantId = 4,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-04',
#roomId = 2,
tenantId = 4,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-05',
#roomId = 2,
tenantId = 4,
paymentStatus = '미납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-01',
#roomId = 2,
tenantId = 5,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-02',
#roomId = 2,
tenantId = 5,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-03',
#roomId = 2,
tenantId = 5,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-04',
#roomId = 2,
tenantId = 5,
paymentStatus = '미납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-05',
#roomId = 2,
tenantId = 5,
paymentStatus = '미납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-01',
#roomId = 2,
tenantId = 6,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2024-01',
#roomId = 2,
tenantId = 7,
paymentStatus = '미납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2023-12',
#roomId = 2,
tenantId = 7,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';

# contract_status testdata
INSERT INTO contract_status
SET regDate = NOW(),
updateDate = NOW(),
rentDate = '2023-11',
#roomId = 2,
tenantId = 7,
paymentStatus = '완납',
extraIncome = '없음',
extraExpense = '없음';



SELECT * FROM contract_status;

SELECT *
FROM contract_status
WHERE rentDate LIKE '2024-01%';

#------------------------------------------------------
# memo 테이블 생성
CREATE TABLE memo(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) NOT NULL,
    boardId INT(10) NOT NULL,
    bldgId INT(10) NOT NULL,
    roomId INT(10) NOT NULL,
    tenantId INT(10) NOT NULL,
    contractId INT(10) NOT NULL,
    title CHAR(20) NOT NULL,
    `body` TEXT NOT NULL,
    repairDate CHAR(20) NOT NULL,
    repairCost INT(10) NOT NULL
);

# memo_board 테이블 생성
CREATE TABLE memo_board(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memoCode CHAR(50) NOT NULL COMMENT '건물(1), 호실(2), 세입자(3), 계약(4), 작업(5), 지출내역(6)',
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
    delDate DATETIME COMMENT '삭제 날짜'
);

SELECT * FROM memo_board;

SELECT * 
FROM memo AS M
LEFT JOIN building AS B
ON M.bldgId = B.id
LEFT JOIN room AS R
ON M.roomId = R.id
LEFT JOIN tenant AS T
ON M.tenantId = T.id
LEFT JOIN contract AS C
ON M.contractId = C.id;

# memo_board 1
INSERT INTO memo_board
SET regDate = NOW(),
updateDate = NOW(),
memoCode = '건물메모';

# memo_board 2
INSERT INTO memo_board
SET regDate = NOW(),
updateDate = NOW(),
memoCode = '호실메모';

# memo_board 3
INSERT INTO memo_board
SET regDate = NOW(),
updateDate = NOW(),
memoCode = '세입자메모';

# memo_board 4
INSERT INTO memo_board
SET regDate = NOW(),
updateDate = NOW(),
memoCode = '계약메모';

# memo_board 5
INSERT INTO memo_board
SET regDate = NOW(),
updateDate = NOW(),
memoCode = '작업일지';

# memo_board 6
INSERT INTO memo_board
SET regDate = NOW(),
updateDate = NOW(),
memoCode = '지출내역';

#------------------------
# memo testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 5,
contractId = 3,
title = '계약에 메모 테스트',
`body`= '3번 계약에 메모임';

# memo-repair testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 5,
roomId = 1,
title = '타일공사작업',
`body`= '101호 타일작업',
repairDate = '2024-1-3',
repairCost = 30000;

# memo-repair testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 5,
roomId = 2,
title = '바닥장판공사작업',
`body`= '102호 타일작업',
repairDate = '2024-1-5',
repairCost = 50000;

# memo-repair testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 5,
roomId = 7,
title = '장판공사작업',
`body`= '302호 타일작업',
repairDate = '2024-1-10',
repairCost = 65000;



# memo testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 1,
bldgId = 1,
title = '1번 회원이 1번 건물 게시판에 글',
`body`= '1번 회원 1번 건물 게시판 내용';

# memo testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
boardId = 2,
roomId = 2,
title = '1번 회원이 2번 호실 게시판에 글',
`body`= '1번 회원 2번 호실 게시판 내용';


# memo testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 1,
bldgId = 1,
title = '2번 회원이 1번 건물 게시판에 글',
`body`= '2번 회원 1번 건물 게시판 내용';


# memo testdata
INSERT INTO memo
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
boardId = 3,
tenantId = 3,
title = '2번 회원이 3번 세입자 게시판에 글',
`body`= '2번 회원 3번 세입자 게시판 내용';



#------------------------------------------------------
# maintenance_fee 테이블 생성
CREATE TABLE maintenance_fee(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate CHAR(20) NOT NULL,
    commonElec INT(10) NOT NULL,
    commonWater INT(10) NOT NULL,
    elevater INT(10) NOT NULL,
    internetTV INT(10) NOT NULL,
    fireSafety INT(10) NOT NULL,
    waterUse INT(10) NOT NULL,
    waterCost INT(10) NOT NULL,
    waterBill INT(10) NOT NULL,
    elecUse INT(10) NOT NULL,
    elecCost INT(10) NOT NULL,
    elecBill INT(10) NOT NULL,
    gasUse INT(10) NOT NULL,
    gasCost INT(10) NOT NULL, 
    gasBill INT(10) NOT NULL,
    monthlyMaintenanceFee INT(10) NOT NULL,
    lateFee INT(10) NOT NULL,
    lateMaintenanceFee INT(10) NOT NULL, 
    maintenanceFeeDate INT(10) NOT NULL,
    tenantId INT(10) NOT NULL
);

# 관리비 월별 상세보기
SELECT *
FROM room AS R
LEFT JOIN contract AS C
ON R.id = C.roomId
LEFT JOIN building AS B
ON R.bldgId = B.id
LEFT JOIN tenant AS T
ON C.tenantId = T.id
LEFT JOIN maintenance_fee AS MF 
ON MF.tenantId = T.id AND MF.updateDate LIKE '2024-03%'
GROUP BY R.id
HAVING B.id = 1;

SELECT * FROM maintenance_fee;

# 관리비 월별 없는 경우 찾기
SELECT *
FROM room AS R
LEFT JOIN contract AS C
ON R.id = C.roomId
LEFT JOIN building AS B
ON R.bldgId = B.id
LEFT JOIN tenant AS T
ON C.tenantId = T.id
LEFT JOIN maintenance_fee AS MF 
ON MF.tenantId = T.id
WHERE MF.updateDate LIKE '2024-02%'
AND MF.tenantId = 1
GROUP BY R.id
HAVING B.id = 1;


# 관리비 월별 전체보기 (관리비도 호실기준 정렬)
SELECT R.*, MF1.monthlyMaintenanceFee AS monthlyMaintenanceFee1
FROM room AS R
LEFT JOIN contract AS C
ON R.id = C.roomId
LEFT JOIN building AS B
ON R.bldgId = B.id
LEFT JOIN tenant AS T
ON C.tenantId = T.id
LEFT JOIN (SELECT tenantId, monthlyMaintenanceFee FROM maintenance_fee WHERE updateDate LIKE '2024-01%') AS MF1
ON MF1.tenantId = T.id
LEFT JOIN (SELECT tenantId, monthlyMaintenanceFee FROM maintenance_fee WHERE updateDate LIKE '2024-02%') AS MF2
ON MF2.tenantId = T.id
GROUP BY R.id;

  
# 위 코드 GPT한테 필터링
SELECT 
    R.*, C.*, B.*, T.*,
    MF1.monthlyMaintenanceFee AS monthlyMaintenanceFee1,
    MF2.monthlyMaintenanceFee AS monthlyMaintenanceFee2,
    MF3.monthlyMaintenanceFee AS monthlyMaintenanceFee3,
    MF4.monthlyMaintenanceFee AS monthlyMaintenanceFee4,
    MF5.monthlyMaintenanceFee AS monthlyMaintenanceFee5,
    MF6.monthlyMaintenanceFee AS monthlyMaintenanceFee6,
    MF7.monthlyMaintenanceFee AS monthlyMaintenanceFee7,
    MF8.monthlyMaintenanceFee AS monthlyMaintenanceFee8,
    MF9.monthlyMaintenanceFee AS monthlyMaintenanceFee9,
    MF10.monthlyMaintenanceFee AS monthlyMaintenanceFee10,
    MF11.monthlyMaintenanceFee AS monthlyMaintenanceFee11,
    MF12.monthlyMaintenanceFee AS monthlyMaintenanceFee12
FROM 
    room AS R
LEFT JOIN 
    contract AS C ON R.id = C.roomId
LEFT JOIN 
    building AS B ON R.bldgId = B.id
LEFT JOIN 
    tenant AS T ON C.tenantId = T.id
LEFT JOIN 
    maintenance_fee AS MF1 ON MF1.tenantId = T.id AND MF1.updateDate LIKE '2024-01%'
LEFT JOIN 
    maintenance_fee AS MF2 ON MF2.tenantId = T.id AND MF2.updateDate LIKE '2024-02%'
LEFT JOIN 
    maintenance_fee AS MF3 ON MF3.tenantId = T.id AND MF3.updateDate LIKE '2024-03%'
LEFT JOIN 
    maintenance_fee AS MF4 ON MF4.tenantId = T.id AND MF4.updateDate LIKE '2024-04%'
LEFT JOIN 
    maintenance_fee AS MF5 ON MF5.tenantId = T.id AND MF5.updateDate LIKE '2024-05%'
LEFT JOIN 
    maintenance_fee AS MF6 ON MF6.tenantId = T.id AND MF6.updateDate LIKE '2024-06%'
LEFT JOIN 
    maintenance_fee AS MF7 ON MF7.tenantId = T.id AND MF7.updateDate LIKE '2024-07%'
LEFT JOIN 
    maintenance_fee AS MF8 ON MF8.tenantId = T.id AND MF8.updateDate LIKE '2024-08%'
LEFT JOIN 
    maintenance_fee AS MF9 ON MF9.tenantId = T.id AND MF9.updateDate LIKE '2024-09%'
LEFT JOIN 
    maintenance_fee AS MF10 ON MF10.tenantId = T.id AND MF10.updateDate LIKE '2024-%10%'
LEFT JOIN 
    maintenance_fee AS MF11 ON MF11.tenantId = T.id AND MF11.updateDate LIKE '2024-%11%'
LEFT JOIN 
    maintenance_fee AS MF12 ON MF12.tenantId = T.id AND MF12.updateDate LIKE '2024-%12%'
GROUP BY 
    R.id;
  
# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-012',
commonElec = 1212,
commonWater =1212,
elevater =11212,
internetTV =121200,
fireSafety=12120,
waterUse =5,
waterCost =12120,
waterBill=12120,
elecUse =68,
elecCost =240,
elecBill =16390,
gasUse = 40,
gasCost = 900,
gasBill =12121212,
monthlyMaintenanceFee=121212,
lateFee =1320,
lateMaintenanceFee =121212,
maintenanceFeeDate =10,
tenantId =1;


# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-01',
commonElec = 23000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =5,
waterCost =1990,
waterBill=9950,
elecUse =68,
elecCost =240,
elecBill =16390,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=26340,
lateFee =1320,
lateMaintenanceFee =27660,
maintenanceFeeDate =10,
tenantId =1;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-01',
commonElec = 23000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =4,
waterCost =1990,
waterBill=7960,
elecUse =86,
elecCost =240,
elecBill =19680,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=27640,
lateFee =1380,
lateMaintenanceFee =29020,
maintenanceFeeDate =28,
tenantId =2;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-01',
commonElec = 23000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=27390,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =3;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-01',
commonElec = 23000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=30210,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =4;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-01',
commonElec = 23000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=40527,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =5;


# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-01',
commonElec = 23000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=42424,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =6;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-01',
commonElec = 23000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=27390,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =7;

#-- 월별 위한 관리비 테스트데이터 
# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-02',
commonElec = 50000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =5,
waterCost =1990,
waterBill=9950,
elecUse =68,
elecCost =240,
elecBill =16390,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=26340,
lateFee =1320,
lateMaintenanceFee =27660,
maintenanceFeeDate =10,
tenantId =1;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-02',
commonElec = 50000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =4,
waterCost =1990,
waterBill=7960,
elecUse =86,
elecCost =240,
elecBill =19680,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=27640,
lateFee =1380,
lateMaintenanceFee =29020,
maintenanceFeeDate =28,
tenantId =2;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-02',
commonElec = 50000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=27390,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =3;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-02',
commonElec = 50000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=58631,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =4;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-02',
commonElec = 50000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=53521,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =5;


# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-02',
commonElec = 50000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=67854,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =6;

# maintenance_fee testdata
INSERT INTO maintenance_fee
SET regDate = NOW(),
updateDate = '2024-02',
commonElec = 50000,
commonWater =10000,
elevater =165000,
internetTV =280000,
fireSafety=75000,
waterUse =7,
waterCost =1990,
waterBill=13930,
elecUse =52,
elecCost =240,
elecBill =13460,
gasUse = 40,
gasCost = 900,
gasBill =32970,
monthlyMaintenanceFee=27390,
lateFee =3870,
lateMaintenanceFee =31260,
maintenanceFeeDate =16,
tenantId =7;


#dashboard join query 
SELECT SUM(deposit) AS depositSum, SUM(rent) AS rentSum, SUM(maintenanceFee) AS maintenanceFeeSum, C.*, R.*, B.*
FROM contract AS C
INNER JOIN room AS R
ON C.roomId = R.id
INNER JOIN building AS B
ON R.bldgId = B.id
GROUP BY B.id;


#dashboard rentStatus 월별 납부현황
#내가 쓴 쿼리
SELECT *
FROM room AS R
LEFT JOIN contract AS C
ON R.id = C.roomId
LEFT JOIN (SELECT paymentStatus, tenantId
FROM contract_Status
WHERE rentDate LIKE '2024-01%') AS CS1
ON C.tenantId = CS1.tenantId
LEFT JOIN (SELECT paymentStatus, tenantId
FROM contract_Status
WHERE rentDate LIKE '2024-02%') AS CS2
ON C.tenantId = CS2.tenantId
LEFT JOIN (SELECT paymentStatus, tenantId
FROM contract_Status
WHERE rentDate LIKE '2024-03%') AS CS3
ON C.tenantId = CS3.tenantId
GROUP BY R.id;

#GPT한테 서브쿼리 풀어달라고 한 쿼리 약간 변경
SELECT *,
MAX(CASE WHEN CS.rentDate LIKE '2024-01%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus1,
MAX(CASE WHEN CS.rentDate LIKE '2024-02%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus2,
MAX(CASE WHEN CS.rentDate LIKE '2024-03%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus3,
MAX(CASE WHEN CS.rentDate LIKE '2024-04%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus4,
MAX(CASE WHEN CS.rentDate LIKE '2024-05%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus5,
MAX(CASE WHEN CS.rentDate LIKE '2024-06%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus6,
MAX(CASE WHEN CS.rentDate LIKE '2024-07%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus7,
MAX(CASE WHEN CS.rentDate LIKE '2024-08%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus8,
MAX(CASE WHEN CS.rentDate LIKE '2024-09%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus9,
MAX(CASE WHEN CS.rentDate LIKE '2024-10%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus10,
MAX(CASE WHEN CS.rentDate LIKE '2024-11%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus11,
MAX(CASE WHEN CS.rentDate LIKE '2024-12%' THEN CS.paymentStatus ELSE NULL END) AS paymentStatus12
FROM room AS R
LEFT JOIN contract AS C
ON R.id = C.roomId
LEFT JOIN building AS B
ON R.bldgId = B.id
LEFT JOIN tenant AS T
ON C.tenantId = T.id
LEFT JOIN contract_Status AS CS 
ON C.tenantId = CS.tenantId
AND (CS.rentDate LIKE '2024-01%' OR CS.rentDate LIKE '2024-02%' OR CS.rentDate LIKE '2024-03%' OR
	 CS.rentDate LIKE '2024-04%' OR CS.rentDate LIKE '2024-05%' OR CS.rentDate LIKE '2024-06%' OR
	 CS.rentDate LIKE '2024-07%' OR CS.rentDate LIKE '2024-08%' OR CS.rentDate LIKE '2024-09%' OR
     CS.rentDate LIKE '2024-10%' OR CS.rentDate LIKE '2024-11%' OR CS.rentDate LIKE '2024-12%')
GROUP BY R.id
HAVING B.id = 2;


# 월별현황 하나 가져오기
SELECT *
FROM room AS R
LEFT JOIN contract AS C ON R.id = C.roomId
LEFT JOIN building AS B ON R.bldgId = B.id
LEFT JOIN tenant AS T ON C.tenantId = T.id
LEFT JOIN contract_Status AS CS ON C.tenantId = CS.tenantId
AND (CS.rentDate LIKE '2024-01%')
GROUP BY R.id
HAVING T.id = 1;



SELECT * FROM building;

SELECT * FROM room;

SELECT * FROM tenant;

SELECT * FROM contract;

SELECT * FROM contract_status;

SELECT * FROM memo;

SELECT * FROM memo_board;

SELECT * FROM `repair`;

SELECT * FROM maintenance_fee;


# 조인업데이트 예시
UPDATE building AS B INNER JOIN room AS R
ON B.id = R.bldgId
SET R.standardDeposit = 100
WHERE R.id = 1;

UPDATE contract AS C INNER JOIN Tenant AS T
ON C.tenantId = T.id
SET T.tenantName = '수정이름'
WHERE C.id = 6;

UPDATE contract AS C INNER JOIN Tenant AS T
ON C.tenantId = T.id
SET C.updateDate = NOW(),
C.leaseType = '반전세',
C.deposit = 40000,
C.rent = 30,
T.tenantName = '수정김'
WHERE C.id = 9;



SELECT *
FROM contract_Status 
WHERE rentDate LIKE '2024-02%' AND tenantId = 2;


