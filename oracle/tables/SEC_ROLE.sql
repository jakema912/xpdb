-- Create table
create table SEC_ROLE
(
  ROLE_ID   INTEGER not null,
  ROLE_NAME VARCHAR2(30) not null,
  ROLE_DESC VARCHAR2(200)
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
