-- Create table
create table UPLOAD_INF
(
  ID       INTEGER not null,
  STATUS   VARCHAR2(16) default 'N' not null,
  PN_NO    VARCHAR2(18) not null,
  IMEI     VARCHAR2(32),
  QTY      INTEGER not null,
  MEMO     VARCHAR2(512),
  OPT_USER VARCHAR2(10) not null,
  OPT_DATE DATE not null,
  TRACE_NO VARCHAR2(30) not null,
  CHAN_ID  VARCHAR2(32),
  PN_DESC  VARCHAR2(512)
)
tablespace A_SMS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
