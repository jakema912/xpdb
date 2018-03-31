-- Create table
create table DIC_SIMPLE
(
  ID    VARCHAR2(16) not null,
  NAME  VARCHAR2(64) not null,
  GRP   VARCHAR2(64) not null,
  VALID CHAR(1) default 'Y' not null,
  ORD   NUMBER(2) default 1 not null
)
tablespace A_SMS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 80K
    next 1M
    minextents 1
    maxextents unlimited
  );
