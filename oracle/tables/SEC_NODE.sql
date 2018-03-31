-- Create table
create table SEC_NODE
(
  NODE_ID    INTEGER not null,
  NODE_LABEL VARCHAR2(30) not null,
  NODE_URL   VARCHAR2(128) not null,
  NODE_DESC  VARCHAR2(200),
  PARENT_ID  INTEGER not null,
  FLAG       CHAR(1) default 'Y'
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
