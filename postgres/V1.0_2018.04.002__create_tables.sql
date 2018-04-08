/* create tables*/

/* ALL PRICE ARE USING INTEGER*/

create table site01.ACCOUNT_INF
(
  PN_NO       VARCHAR(30) not null,
  STN_CODE    VARCHAR(10) not null,
  INOUT_TYPE  site01.IO_TYPE not null,
  REFERENCE   VARCHAR(128),
  OPT_USER    VARCHAR(10) not null,
  OPT_DATE    TIMESTAMP default now() not null,
  PART_STATUS site01.PART_STATUS not null,
  REMARK      VARCHAR(256),
  SN          VARCHAR(32)
) TABLESPACE tsdata;

create table site01.BAD_STOCK_LIST
(
  B_STOCK_ID VARCHAR(32) not null,
  PN         VARCHAR(32),
  PN_DESC    VARCHAR(32),
  IMEI       VARCHAR(32),
  OPT_USER   VARCHAR(32),
  TRACE_NO   VARCHAR(32),
  OPT_DATE   TIMESTAMP,
  STATUS     VARCHAR(32),
  BILL_NO    VARCHAR(32),
  PARTS_ID   VARCHAR(32),
  CHAN_ID    VARCHAR(32),
  SN         VARCHAR(32),
  RVC_DATE   TIMESTAMP,
  RVC_USER   VARCHAR(32),
  TRACE_NAME VARCHAR(128),
  CONSTRAINT BAD_STOCK_LIST_pk
  PRIMARY KEY (B_STOCK_ID) USING INDEX TABLESPACE tsidx
)TABLESPACE tsdata;


create table site01.BILLS
(
  BILL_NO            VARCHAR(32) not null,
  SN                 VARCHAR(32),
  STATUS             VARCHAR(4),
  CUST_TYPE          VARCHAR(16),
  CUST_NAME          VARCHAR(64),
  CUST_TEL           VARCHAR(32),
  DEALER             VARCHAR(64),
  PART_TYPE          VARCHAR(32),
  MODEL              VARCHAR(32),
  APPEARANCE         VARCHAR(512),
  WARRANTY           VARCHAR(16),
  PURDATE            TIMESTAMP,
  OPEN_DATE          TIMESTAMP default now(),
  FIX_DATE           TIMESTAMP,
  GIMEI              VARCHAR(32),
  FIX_RESULT         VARCHAR(16) default 'N',
  OPT_USER           VARCHAR(32),
  OPT_DATE           TIMESTAMP default now(),
  RC_ID              VARCHAR(32),
  OPEN_USER          VARCHAR(32),
  FIX_USER           VARCHAR(32),
  IS_CANCEL          VARCHAR(16) default 'N',
  WARRANTY_SEND_PART VARCHAR(16),
  SYMPTOM_CODE       VARCHAR(16),
  ASSIGN_ENGINEER    VARCHAR(32),
  FIX_ENGINEER       VARCHAR(32),
  ENGINEER2          VARCHAR(32),
  TEST_DESC          VARCHAR(512),
  ENGINEER3          VARCHAR(32),
  FIX_DESC           VARCHAR(512),
  TEST_CODE          VARCHAR(16),
  FIX_CODE           VARCHAR(16),
  IS_END             CHAR(1),
  END_USER           VARCHAR(32),
  END_DATE           TIMESTAMP,
  IS_SATIFY          VARCHAR(8),
  CUST_ADVICE        VARCHAR(512),
  GETOUT_MEMO        VARCHAR(512),
  FIX_MONEY          VARCHAR(32),
  FAULT_TOTAL        VARCHAR(32),
  SYMPTOM_DESC       VARCHAR(256),
  E_MAIL             VARCHAR(32),
  MEMO               VARCHAR(1024),
  M_USE_HOUSE        VARCHAR(16),
  D_USE_HOUSE        VARCHAR(16),
  M_LIGHT            VARCHAR(16),
  D_NBR              VARCHAR(16),
  POWER_ON           VARCHAR(32),
  POWER_OFF          VARCHAR(32),
  FIX_NBR            VARCHAR(32),
  FIX_LIGHT          VARCHAR(32),
  M_NBR              VARCHAR(32),
  TEST_RESULT        CHAR(1),
  M_TYPE             VARCHAR(32),
  BILL_TYPE          CHAR(1) default 'S',
  CONSTRAINT BILLS_pk
  PRIMARY KEY (BILL_NO) USING INDEX TABLESPACE tsidx
)TABLESPACE tsdata;

create table site01.BILLS_DEALER
(
  BILL_NO            VARCHAR(32) not null,
  SN                 VARCHAR(32),
  STATUS             VARCHAR(4),
  MODEL              VARCHAR(32),
  APPEARANCE         VARCHAR(512),
  WARRANTY           VARCHAR(16),
  PURDATE            TIMESTAMP,
  OPEN_DATE          TIMESTAMP default now(),
  CHAN_ID            VARCHAR(16),
  GU_CLASS           VARCHAR(16),
  GU_DESC            VARCHAR(512),
  M_HOUR             VARCHAR(16),
  D_HOUR             VARCHAR(16),
  SEND_DATE          TIMESTAMP,
  SEND_TRACE_NO      VARCHAR(32),
  SEND_TRACE_NAME    VARCHAR(16),
  SEND_USER_ID       VARCHAR(32),
  RETURN_DATE        TIMESTAMP,
  RETURN_USER_ID     VARCHAR(32),
  RETURN_TRACE_NO    VARCHAR(32),
  RETURN_TRACE_NAME  VARCHAR(32),
  M_TYPE             VARCHAR(32),
  PART_TYPE          VARCHAR(32),
  RVC_DATE           TIMESTAMP,
  RVC_USER_ID        VARCHAR(32),
  RVC_FLAG           VARCHAR(16),
  RVC_MEMO           VARCHAR(512),
  RVC_CHAN_ID        VARCHAR(32),
  DEALER_RVC_USER_ID VARCHAR(32),
  DEALER_RVC_DATE    TIMESTAMP
)TABLESPACE tsdata;

create table site01.CHAN_INF
(
  CHAN_ID   VARCHAR(16) not null,
  CHAN_NAME VARCHAR(64) not null,
  CITY_CODE VARCHAR(64),
  RC_ID     VARCHAR(4),
  CONTACT   VARCHAR(32),
  TEL       VARCHAR(64),
  FAX       VARCHAR(64),
  ZIP       VARCHAR(8),
  EMAIL     VARCHAR(128),
  ADDRESS   VARCHAR(128),
  CHAN_FLAG VARCHAR(4),
  FLAG      CHAR(1) default 1,
  TEMP      VARCHAR(16),
  MANAGER   VARCHAR(32),
  AREA      VARCHAR(32),
  U_TYPE    VARCHAR(32),
  CONSTRAINT CHAN_INF_pk
  PRIMARY KEY (CHAN_ID) USING INDEX TABLESPACE tsidx
)TABLESPACE tsdata;

create table site01.DIC_SIMPLE
(
  ID    VARCHAR(16) not null,
  NAME  VARCHAR(64) not null,
  GRP   VARCHAR(64) not null,
  VALID CHAR(1) default 'Y' not null,
  ORD   SMALLINT default 1 not null
)TABLESPACE tsdata;


create table site01.GU_ZHANG_INF
(
  GU_ID       VARCHAR(32),
  GU_DESC     VARCHAR(156),
  FLAG        CHAR(1),
  OPT_USER    VARCHAR(32),
  OPT_SYSDATE TIMESTAMP,
  GU_TYPE     VARCHAR(8)
)TABLESPACE tsdata;

create table site01.INVENTORY
(
  PN_NO             VARCHAR(30) not null,
  STN_CODE          VARCHAR(10) not null,
  BAD_QUANTITY      INTEGER not null CHECK (BAD_QUANTITY>=0),
  GOOD_QUANTITY     INTEGER not null CHECK (GOOD_QUANTITY>=0),
  RESERVED_QUANTITY INTEGER default 0 not null CHECK (RESERVED_QUANTITY>=0),
  LAST_OPT_DATE     TIMESTAMP,
  LAST_OPT_USER     VARCHAR(32),
  CONSTRAINT INVENTORY_pk
  PRIMARY KEY (PN_NO, STN_CODE) USING INDEX TABLESPACE tsidx
)TABLESPACE tsdata;

create table site01.MODEL
(
  MODEL_ID    VARCHAR(32) not null,
  AIRCRAFT    VARCHAR(32),
  MODEL_DESC  VARCHAR(32),
  FLAG        CHAR(1) default 'Y',
  ADD_DATE    TIMESTAMP,
  OPT_USER    VARCHAR(32),
  AIRCRAFT_ID VARCHAR(32)
)TABLESPACE tsdata;


create table site01.PARTS
(
  PARTS_ID      VARCHAR(32) not null,
  BILL_ID       VARCHAR(32) not null,
  STATUS        VARCHAR(16),
  PN            VARCHAR(32),
  STN_CODE      VARCHAR(32),
  PART_SN       VARCHAR(32),
  NEW_SN        VARCHAR(32),
  SEND_FLAG     VARCHAR(12) default 'N',
  SEND_DATE     TIMESTAMP,
  GET_ENG       VARCHAR(32),
  GET_DATE      TIMESTAMP,
  REQ_DATE      TIMESTAMP,
  REQ_USER      VARCHAR(32),
  BACK_FLAG     VARCHAR(16),
  BACK_DATE     TIMESTAMP,
  PART_NAME     VARCHAR(128),
  PART_DES      VARCHAR(512),
  BACK_TYPE     VARCHAR(32),
  SEND_PN       VARCHAR(32),
  OPT_USER      VARCHAR(32),
  OPT_DATE      TIMESTAMP,
  SEND_STOCK_ID INTEGER,
  GET_FLAG      VARCHAR(32),
  PN_NAME       VARCHAR(32),
  PN_DESC       VARCHAR(32),
  OVO_FLAG      VARCHAR(1) not null,
  APPROVE_USER  VARCHAR(16),
  APPROVE_DATE  TIMESTAMP,
  APPROVE_MEMO  VARCHAR(512),
  APPROVE_FLAG  VARCHAR(2)
)TABLESPACE tsdata;

create table site01.PROD_CLASS
(
  ID       INTEGER not null,
  PN_NO    VARCHAR(32) not null,
  PN_DESC  VARCHAR(512) not null,
  PN_NAME  VARCHAR(128) not null,
  GU_CLASS VARCHAR(32),
  PRICE    NUMERIC(10,2) -- NUMERIC?
)TABLESPACE tsdata;

create table site01.SEC_NODE
(
  NODE_ID    INTEGER not null,
  NODE_LABEL VARCHAR(30) not null,
  NODE_URL   VARCHAR(128) not null,
  NODE_DESC  VARCHAR(200),
  PARENT_ID  INTEGER not null,
  FLAG       CHAR(1) default 'Y'
)TABLESPACE tsdata;

create table site01.SEC_ROLE
(
  ROLE_ID   INTEGER not null,
  ROLE_NAME VARCHAR(30) not null,
  ROLE_DESC VARCHAR(200)
)TABLESPACE tsdata;

create table site01.SEC_ROLE_NODE
(
  ROLE_ID INTEGER not null,
  NODE_ID INTEGER not null
)TABLESPACE tsdata;

create table site01.STOCK_LIST
(
  STOCK_ID          INTEGER,
  PN_NO             VARCHAR(32),
  IMEI              VARCHAR(32),
  PN_DESC           VARCHAR(32),
  CHAN_ID           VARCHAR(16),
  IN_DATE           TIMESTAMP,
  IN_USER           VARCHAR(32),
  OUT_DATE          TIMESTAMP,
  OUT_USER          VARCHAR(32),
  MEMO              VARCHAR(512),
  STATUS            VARCHAR(16),
  OPT_DATE          TIMESTAMP,
  OPT_USER          VARCHAR(32),
  SEND_TRACE_NO     VARCHAR(32),
  RETURN_TRACE_NO   VARCHAR(32),
  RETURN_TRACE_NAME VARCHAR(32),
  SEND_TRACE_NAME   VARCHAR(32),
  SEND_DATE         TIMESTAMP,
  RETURN_DATE       TIMESTAMP
)TABLESPACE tsdata;

create table site01.STOCK_LIST_LOG
(
  STOCK_ID    INTEGER,
  NEW_STATUS  VARCHAR(16),
  OLD_STATUS  VARCHAR(16),
  MEMO        VARCHAR(512),
  OPT_USER    VARCHAR(32),
  OPT_DATE    TIMESTAMP default now(),
  NEW_CHAN_ID VARCHAR(16),
  OLD_CHAN_ID VARCHAR(16)
)TABLESPACE tsdata;

create table site01.UPLOAD_INF
(
  ID       INTEGER not null,
  STATUS   VARCHAR(16) default 'N' not null,
  PN_NO    VARCHAR(18) not null,
  IMEI     VARCHAR(32),
  QTY      INTEGER not null,
  MEMO     VARCHAR(512),
  OPT_USER VARCHAR(10) not null,
  OPT_DATE TIMESTAMP not null,
  TRACE_NO VARCHAR(30) not null,
  CHAN_ID  VARCHAR(32),
  PN_DESC  VARCHAR(512)
)TABLESPACE tsdata;

create table site01.USER_ROLE
(
  USER_ID VARCHAR(32) not null,
  ROLE_ID VARCHAR(32) not null
)TABLESPACE tsdata;


create table site01.USERS_INF
(
  LOGIN_ID             VARCHAR(128) not null,
  USER_ID              VARCHAR(32) not null,
  PASSWORD             VARCHAR(128),
  STATION_ID           VARCHAR(32),
  MOBILE               VARCHAR(32),
  OPT_USER             VARCHAR(32),
  OPT_DATE             TIMESTAMP default now(),
  LAST_LOG_DATE        TIMESTAMP default now(),
  LAST_UPDATE_PWD_DATE TIMESTAMP,
  USER_NAME            VARCHAR(32),
  FLAG                 CHAR(1) default 'Y',
  ENG_FLAG             VARCHAR(16),
  MAIL                 VARCHAR(32),
  ROLE_ID              INTEGER NOT NULL
)TABLESPACE tsdata;