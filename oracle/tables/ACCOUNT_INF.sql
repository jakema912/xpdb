-- Create table
create table ACCOUNT_INF
(
  PN_NO       VARCHAR2(30) not null,
  STN_CODE    VARCHAR2(10) not null,
  INOUT_TYPE  VARCHAR2(10) not null,
  REFERENCE   VARCHAR2(128),
  OPT_USER    VARCHAR2(10) not null,
  OPT_DATE    DATE default sysdate not null,
  PART_STATUS VARCHAR2(30) not null,
  REMARK      VARCHAR2(256),
  SN          VARCHAR2(32)
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
comment on column ACCOUNT_INF.PN_NO
  is 'pn��';
comment on column ACCOUNT_INF.STN_CODE
  is 'ά��վ';
comment on column ACCOUNT_INF.INOUT_TYPE
  is 'IN���OUT����';
comment on column ACCOUNT_INF.REFERENCE
  is '�ο���';
comment on column ACCOUNT_INF.OPT_USER
  is '������';
comment on column ACCOUNT_INF.OPT_DATE
  is 'ʱ��';
comment on column ACCOUNT_INF.PART_STATUS
  is '״̬GOOD BAD';
comment on column ACCOUNT_INF.REMARK
  is '��ע';
comment on column ACCOUNT_INF.SN
  is 'SN';
-- Create/Recreate check constraints 
alter table ACCOUNT_INF
  add constraint CK_ACCOUNT_INF1
  check (inout_type in ('IN','OUT'));
alter table ACCOUNT_INF
  add constraint CK_ACCOUNT_INF2
  check (part_status  in ('GOOD','BAD'));
-- Create/Recreate indexes 
create index IDX_ACCOUNT_INF on ACCOUNT_INF (STN_CODE, PN_NO, PART_STATUS)
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
