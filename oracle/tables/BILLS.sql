-- Create table
create table BILLS
(
  BILL_NO            VARCHAR2(32) not null,
  SN                 VARCHAR2(32),
  STATUS             VARCHAR2(4),
  CUST_TYPE          VARCHAR2(16),
  CUST_NAME          VARCHAR2(64),
  CUST_TEL           VARCHAR2(32),
  DEALER             VARCHAR2(64),
  PART_TYPE          VARCHAR2(32),
  MODEL              VARCHAR2(32),
  PCOLOR             VARCHAR2(32),
  IMEI               VARCHAR2(32),
  PCODE              VARCHAR2(32),
  APPEARANCE         VARCHAR2(512),
  WARRANTY           VARCHAR2(16),
  WAREA              VARCHAR2(16),
  FIX_TYPE           VARCHAR2(16),
  CHANGETYPE         VARCHAR2(16),
  PURDATE            DATE,
  INVOICE            VARCHAR2(32),
  INVOICE_NO         VARCHAR2(32),
  SID                VARCHAR2(32),
  RETURN_TYPE        VARCHAR2(16),
  OPEN_DATE          DATE default sysdate,
  FIX_DATE           DATE,
  GIMEI              VARCHAR2(32),
  FIX_RESULT         VARCHAR2(16) default 'N',
  OPT_USER           VARCHAR2(32),
  OPT_DATE           DATE default sysdate,
  RC_ID              VARCHAR2(32),
  OPEN_USER          VARCHAR2(32),
  FIX_USER           VARCHAR2(32),
  IS_CANCEL          VARCHAR2(16) default 'N',
  WARRANTY_SEND_PART VARCHAR2(16),
  SYMPTOM_CODE       VARCHAR2(16),
  ASSIGN_ENGINEER    VARCHAR2(32),
  FIX_ENGINEER       VARCHAR2(32),
  ENGINEER2          VARCHAR2(32),
  TEST_DESC          VARCHAR2(512),
  ENGINEER3          VARCHAR2(32),
  FIX_DESC           VARCHAR2(512),
  TEST_CODE          VARCHAR2(16),
  FIX_CODE           VARCHAR2(16),
  IS_END             CHAR(1),
  END_USER           VARCHAR2(32),
  END_DATE           DATE,
  IS_SATIFY          VARCHAR2(8),
  CUST_ADVICE        VARCHAR2(512),
  GETOUT_MEMO        VARCHAR2(512),
  FIX_MONEY          VARCHAR2(32),
  FAULT_TOTAL        VARCHAR2(32),
  SYMPTOM_DESC       VARCHAR2(256),
  OLD_VERSION        VARCHAR2(128),
  NEW_VERSION        VARCHAR2(128),
  E_MAIL             VARCHAR2(32),
  MEMO               VARCHAR2(1024),
  M_USE_HOUSE        VARCHAR2(16),
  D_USE_HOUSE        VARCHAR2(16),
  M_LIGHT            VARCHAR2(16),
  D_NBR              VARCHAR2(16),
  POWER_ON           VARCHAR2(32),
  POWER_OFF          VARCHAR2(32),
  FIX_NBR            VARCHAR2(32),
  FIX_LIGHT          VARCHAR2(32),
  M_NBR              VARCHAR2(32),
  TEST_RESULT        CHAR(1),
  M_TYPE             VARCHAR2(32),
  BILL_TYPE          CHAR(1) default 'S'
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
comment on column BILLS.BILL_NO
  is 'ά�޵���';
comment on column BILLS.SN
  is '�������к�';
comment on column BILLS.STATUS
  is '״̬';
comment on column BILLS.CUST_TYPE
  is '�ͻ�����';
comment on column BILLS.CUST_NAME
  is '�ͻ�����';
comment on column BILLS.CUST_TEL
  is '�ͻ��绰';
comment on column BILLS.DEALER
  is '������';
comment on column BILLS.PART_TYPE
  is 'ά�޵Ĳ�������';
comment on column BILLS.MODEL
  is '���������ͺ�';
comment on column BILLS.PCOLOR
  is '��ɫ';
comment on column BILLS.IMEI
  is 'IMEI';
comment on column BILLS.PCODE
  is '��Ʒ����';
comment on column BILLS.APPEARANCE
  is '���';
comment on column BILLS.WARRANTY
  is '��������';
comment on column BILLS.WAREA
  is 'ԭ���޵���';
comment on column BILLS.FIX_TYPE
  is 'ά������';
comment on column BILLS.CHANGETYPE
  is 'DAP/������������';
comment on column BILLS.PURDATE
  is '��������';
comment on column BILLS.INVOICE
  is '��Ʊ����';
comment on column BILLS.INVOICE_NO
  is '��Ʊƾ�ź���';
comment on column BILLS.SID
  is '�������';
comment on column BILLS.RETURN_TYPE
  is '���ع�������';
comment on column BILLS.OPEN_DATE
  is '����ʱ��';
comment on column BILLS.FIX_DATE
  is '�ᵥʱ��';
comment on column BILLS.GIMEI
  is '��IMEI';
comment on column BILLS.FIX_RESULT
  is 'ά�޽��';
comment on column BILLS.RC_ID
  is 'ά��վ';
comment on column BILLS.OPEN_USER
  is '��������ʦ';
comment on column BILLS.FIX_USER
  is '�ᵥ����ʦ';
comment on column BILLS.IS_CANCEL
  is '�Ƿ�ȡ��ά��';
comment on column BILLS.WARRANTY_SEND_PART
  is '�����Ƿ񷢻���';
comment on column BILLS.SYMPTOM_CODE
  is '֢״���� ';
comment on column BILLS.ASSIGN_ENGINEER
  is '���ɹ���ʦ';
comment on column BILLS.FIX_ENGINEER
  is 'ά�޹���ʦ';
comment on column BILLS.ENGINEER2
  is '���Թ���ʦ';
comment on column BILLS.TEST_DESC
  is '���ϼ�¼ ';
comment on column BILLS.ENGINEER3
  is 'ά�޹���ʦ ';
comment on column BILLS.FIX_DESC
  is 'ά������ ';
comment on column BILLS.TEST_CODE
  is '���ϴ���';
comment on column BILLS.FIX_CODE
  is 'ά�޴���';
comment on column BILLS.IS_END
  is '�Ƿ�ᵥ ';
comment on column BILLS.END_USER
  is 'ȡ������ʦ';
comment on column BILLS.END_DATE
  is 'ȡ��ʱ��';
comment on column BILLS.FAULT_TOTAL
  is '֢״����';
comment on column BILLS.SYMPTOM_DESC
  is '֢״����';
comment on column BILLS.OLD_VERSION
  is '�����汾';
comment on column BILLS.NEW_VERSION
  is 'ά�ް汾 ';
comment on column BILLS.E_MAIL
  is '����';
