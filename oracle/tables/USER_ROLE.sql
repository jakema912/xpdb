-- Create table
create table USER_ROLE
(
  USER_ID VARCHAR2(32) not null,
  ROLE_ID VARCHAR2(32) not null
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
comment on column USER_ROLE.USER_ID
  is 'ÓÃ»§ID';
comment on column USER_ROLE.ROLE_ID
  is '½ÇÉ«ID';
