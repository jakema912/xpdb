-- Create table
create table PROD_CLASS
(
  ID       INTEGER not null,
  PN_NO    VARCHAR2(32) not null,
  PN_DESC  VARCHAR2(512) not null,
  PN_NAME  VARCHAR2(128) not null,
  GU_CLASS VARCHAR2(32),
  PRICE    NUMBER
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
