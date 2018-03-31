-- Create table
create table INVENTORY
(
  PN_NO             VARCHAR2(30) not null,
  STN_CODE          VARCHAR2(10) not null,
  BAD_QUANTITY      INTEGER not null,
  GOOD_QUANTITY     INTEGER not null,
  RESERVED_QUANTITY INTEGER default 0 not null,
  LAST_OPT_DATE     DATE,
  LAST_OPT_USER     VARCHAR2(32)
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
comment on column INVENTORY.PN_NO
  is 'pn��';
comment on column INVENTORY.STN_CODE
  is 'ά��վ';
comment on column INVENTORY.BAD_QUANTITY
  is '��������';
comment on column INVENTORY.GOOD_QUANTITY
  is '�ü�����';
comment on column INVENTORY.RESERVED_QUANTITY
  is '�������';
comment on column INVENTORY.LAST_OPT_DATE
  is '��������';
comment on column INVENTORY.LAST_OPT_USER
  is '������ʱ��';
-- Create/Recreate primary, unique and foreign key constraints 
alter table INVENTORY
  add constraint PK_INVENTORY primary key (PN_NO, STN_CODE)
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
-- Create/Recreate check constraints 
alter table INVENTORY
  add constraint CK_INVENTORY1
  check (good_quantity>=0);
alter table INVENTORY
  add constraint CK_INVENTORY2
  check (bad_quantity>=0);
alter table INVENTORY
  add constraint CK_INVENTORY3
  check (reserved_quantity>=0);
