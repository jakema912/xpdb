-- Create table
create table STOCK_LIST_LOG
(
  STOCK_ID    INTEGER,
  NEW_STATUS  VARCHAR2(16),
  OLD_STATUS  VARCHAR2(16),
  MEMO        VARCHAR2(512),
  OPT_USER    VARCHAR2(32),
  OPT_DATE    DATE default sysdate,
  NEW_CHAN_ID VARCHAR2(16),
  OLD_CHAN_ID VARCHAR2(16)
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
