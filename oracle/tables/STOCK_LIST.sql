-- Create table
create table STOCK_LIST
(
  STOCK_ID          INTEGER,
  PN_NO             VARCHAR2(32),
  IMEI              VARCHAR2(32),
  PN_DESC           VARCHAR2(32),
  CHAN_ID           VARCHAR2(16),
  IN_DATE           DATE,
  IN_USER           VARCHAR2(32),
  OUT_DATE          DATE,
  OUT_USER          VARCHAR2(32),
  MEMO              VARCHAR2(512),
  STATUS            VARCHAR2(16),
  OPT_DATE          DATE,
  OPT_USER          VARCHAR2(32),
  SEND_TRACE_NO     VARCHAR2(32),
  RETURN_TRACE_NO   VARCHAR2(32),
  RETURN_TRACE_NAME VARCHAR2(32),
  SEND_TRACE_NAME   VARCHAR2(32),
  SEND_DATE         DATE,
  RETURN_DATE       DATE
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
-- Add comments to the columns 
comment on column STOCK_LIST.STOCK_ID
  is '���';
comment on column STOCK_LIST.PN_NO
  is 'pn';
comment on column STOCK_LIST.IMEI
  is 'imei��';
comment on column STOCK_LIST.PN_DESC
  is '����';
comment on column STOCK_LIST.CHAN_ID
  is 'ά��վ ';
comment on column STOCK_LIST.IN_DATE
  is '���ʱ�� ';
comment on column STOCK_LIST.IN_USER
  is '�����';
comment on column STOCK_LIST.OUT_DATE
  is '����ʱ�� ';
comment on column STOCK_LIST.OUT_USER
  is '������';
comment on column STOCK_LIST.MEMO
  is '��ע ';
comment on column STOCK_LIST.STATUS
  is '״̬N:�ڿ� ��T��;��Y��ʹ�� ��R����KDX,H�ü�������; F ά��վ���� V ��ͨ����';
comment on column STOCK_LIST.RETURN_TRACE_NO
  is '���ü��˵�';
comment on column STOCK_LIST.RETURN_TRACE_NAME
  is '���ü���˾';
