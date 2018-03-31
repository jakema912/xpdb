-- Create table
create table GU_ZHANG_INF
(
  GU_ID       VARCHAR2(32),
  GU_DESC     VARCHAR2(156),
  FLAG        CHAR(1),
  OPT_USER    VARCHAR2(32),
  OPT_SYSDATE DATE,
  GU_TYPE     VARCHAR2(8)
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
