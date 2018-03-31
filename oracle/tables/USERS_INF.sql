-- Create table
create table USERS_INF
(
  LOGIN_ID             VARCHAR2(128) not null,
  USER_ID              VARCHAR2(32) not null,
  PASSWORD             VARCHAR2(128),
  STATION_ID           VARCHAR2(32),
  MOBILE               VARCHAR2(32),
  OPT_USER             VARCHAR2(32),
  OPT_DATE             DATE default sysdate,
  LAST_LOG_DATE        DATE default sysdate,
  LAST_UPDATE_PWD_DATE DATE,
  USER_NAME            VARCHAR2(32),
  FLAG                 CHAR(1) default 'Y',
  ENG_FLAG             VARCHAR2(16),
  MAIL                 VARCHAR2(32),
  ROLE_ID              VARCHAR2(16)
)
tablespace A_SMS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 80K
    next 16K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column USERS_INF.LOGIN_ID
  is '登录名';
comment on column USERS_INF.USER_ID
  is '用户ID';
comment on column USERS_INF.PASSWORD
  is '密码';
comment on column USERS_INF.STATION_ID
  is '所属维修站';
comment on column USERS_INF.MOBILE
  is '电话';
comment on column USERS_INF.USER_NAME
  is '用户名';
comment on column USERS_INF.FLAG
  is '是否可用';
comment on column USERS_INF.ENG_FLAG
  is '是否工程师';
