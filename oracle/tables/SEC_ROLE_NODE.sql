-- Create table
create table SEC_ROLE_NODE
(
  ROLE_ID INTEGER not null,
  NODE_ID INTEGER not null
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
