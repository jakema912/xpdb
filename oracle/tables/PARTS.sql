-- Create table
create table PARTS
(
  PARTS_ID      VARCHAR2(32) not null,
  BILL_ID       VARCHAR2(32) not null,
  STATUS        VARCHAR2(16),
  PN            VARCHAR2(32),
  STN_CODE      VARCHAR2(32),
  PART_SN       VARCHAR2(32),
  NEW_SN        VARCHAR2(32),
  SEND_FLAG     VARCHAR2(12) default 'N',
  SEND_DATE     DATE,
  GET_ENG       VARCHAR2(32),
  GET_DATE      DATE,
  REQ_DATE      DATE,
  REQ_USER      VARCHAR2(32),
  BACK_FLAG     VARCHAR2(16),
  BACK_DATE     DATE,
  PART_NAME     VARCHAR2(128),
  PART_DES      VARCHAR2(512),
  BACK_TYPE     VARCHAR2(32),
  SEND_PN       VARCHAR2(32),
  OPT_USER      VARCHAR2(32),
  OPT_DATE      DATE,
  SEND_STOCK_ID VARCHAR2(32),
  GET_FLAG      VARCHAR2(32),
  PN_NAME       VARCHAR2(32),
  PN_DESC       VARCHAR2(32),
  OVO_FLAG      VARCHAR2(1) not null,
  APPROVE_USER  VARCHAR2(16),
  APPROVE_DATE  DATE,
  APPROVE_MEMO  VARCHAR2(512),
  APPROVE_FLAG  VARCHAR2(2)
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
comment on column PARTS.PARTS_ID
  is '������';
comment on column PARTS.BILL_ID
  is '������';
comment on column PARTS.STATUS
  is '����״̬8001:�걸��8002������8003������8004����, 8000.8009';
comment on column PARTS.PN
  is '����pn';
comment on column PARTS.STN_CODE
  is '����ά��վ';
comment on column PARTS.PART_SN
  is '����sn';
comment on column PARTS.NEW_SN
  is '�¼�sn';
comment on column PARTS.SEND_FLAG
  is '����״̬ ';
comment on column PARTS.SEND_DATE
  is '����ʱ��';
comment on column PARTS.GET_ENG
  is '������ ';
comment on column PARTS.GET_DATE
  is '����ʱ��';
comment on column PARTS.REQ_DATE
  is '����ʱ��';
comment on column PARTS.REQ_USER
  is '������ ';
comment on column PARTS.BACK_FLAG
  is '����״̬';
comment on column PARTS.BACK_DATE
  is '������';
comment on column PARTS.BACK_TYPE
  is '�������� �ü�������';
comment on column PARTS.SEND_PN
  is '����pn';
comment on column PARTS.OPT_USER
  is '������ ';
comment on column PARTS.OPT_DATE
  is '����ʱ�� ';
comment on column PARTS.SEND_STOCK_ID
  is '���';
comment on column PARTS.PN_NAME
  is '��������';
comment on column PARTS.PN_DESC
  is '��������';
comment on column PARTS.OVO_FLAG
  is '�Ƿ�һ��һ';
