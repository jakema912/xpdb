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
  is '维修单号';
comment on column BILLS.SN
  is '主机序列号';
comment on column BILLS.STATUS
  is '状态';
comment on column BILLS.CUST_TYPE
  is '客户类型';
comment on column BILLS.CUST_NAME
  is '客户姓名';
comment on column BILLS.CUST_TEL
  is '客户电话';
comment on column BILLS.DEALER
  is '经销商';
comment on column BILLS.PART_TYPE
  is '维修的部件类型';
comment on column BILLS.MODEL
  is '机器附件型号';
comment on column BILLS.PCOLOR
  is '颜色';
comment on column BILLS.IMEI
  is 'IMEI';
comment on column BILLS.PCODE
  is '产品编码';
comment on column BILLS.APPEARANCE
  is '外观';
comment on column BILLS.WARRANTY
  is '保修类型';
comment on column BILLS.WAREA
  is '原保修地区';
comment on column BILLS.FIX_TYPE
  is '维修类型';
comment on column BILLS.CHANGETYPE
  is 'DAP/附件更换类型';
comment on column BILLS.PURDATE
  is '购买日期';
comment on column BILLS.INVOICE
  is '发票附件';
comment on column BILLS.INVOICE_NO
  is '发票凭着号码';
comment on column BILLS.SID
  is '特例编号';
comment on column BILLS.RETURN_TYPE
  is '返回工厂类型';
comment on column BILLS.OPEN_DATE
  is '开单时间';
comment on column BILLS.FIX_DATE
  is '结单时间';
comment on column BILLS.GIMEI
  is '新IMEI';
comment on column BILLS.FIX_RESULT
  is '维修结果';
comment on column BILLS.RC_ID
  is '维修站';
comment on column BILLS.OPEN_USER
  is '开单工程师';
comment on column BILLS.FIX_USER
  is '结单工程师';
comment on column BILLS.IS_CANCEL
  is '是否取消维修';
comment on column BILLS.WARRANTY_SEND_PART
  is '保外是否发货　';
comment on column BILLS.SYMPTOM_CODE
  is '症状代码 ';
comment on column BILLS.ASSIGN_ENGINEER
  is '分派工程师';
comment on column BILLS.FIX_ENGINEER
  is '维修工程师';
comment on column BILLS.ENGINEER2
  is '测试工程师';
comment on column BILLS.TEST_DESC
  is '故障记录 ';
comment on column BILLS.ENGINEER3
  is '维修工程师 ';
comment on column BILLS.FIX_DESC
  is '维修描述 ';
comment on column BILLS.TEST_CODE
  is '故障代码';
comment on column BILLS.FIX_CODE
  is '维修代码';
comment on column BILLS.IS_END
  is '是否结单 ';
comment on column BILLS.END_USER
  is '取机工程师';
comment on column BILLS.END_DATE
  is '取机时间';
comment on column BILLS.FAULT_TOTAL
  is '症状大类';
comment on column BILLS.SYMPTOM_DESC
  is '症状描述';
comment on column BILLS.OLD_VERSION
  is '开单版本';
comment on column BILLS.NEW_VERSION
  is '维修版本 ';
comment on column BILLS.E_MAIL
  is '邮箱';
