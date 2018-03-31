-- Create table
create table CHAN_INF
(
  CHAN_ID   VARCHAR2(16) not null,
  CHAN_NAME VARCHAR2(64) not null,
  CITY_CODE VARCHAR2(64),
  RC_ID     VARCHAR2(4),
  CONTACT   VARCHAR2(32),
  TEL       VARCHAR2(64),
  FAX       VARCHAR2(64),
  ZIP       VARCHAR2(8),
  EMAIL     VARCHAR2(128),
  ADDRESS   VARCHAR2(128),
  CHAN_FLAG VARCHAR2(4),
  FLAG      CHAR(1) default 1,
  TEMP      VARCHAR2(16),
  MANAGER   VARCHAR2(32),
  AREA      VARCHAR2(32),
  U_TYPE    VARCHAR2(32)
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
-- Add comments to the columns 
comment on column CHAN_INF.AREA
  is 'ÇøÓò';
-- Create/Recreate primary, unique and foreign key constraints 
alter table CHAN_INF
  add constraint PK_CHAN_ID primary key (CHAN_ID)
  using index 
  tablespace A_SMS_IDX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 80K
    next 1M
    minextents 1
    maxextents unlimited
  );
