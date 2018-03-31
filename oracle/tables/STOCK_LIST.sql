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
  is '序号';
comment on column STOCK_LIST.PN_NO
  is 'pn';
comment on column STOCK_LIST.IMEI
  is 'imei号';
comment on column STOCK_LIST.PN_DESC
  is '描述';
comment on column STOCK_LIST.CHAN_ID
  is '维修站 ';
comment on column STOCK_LIST.IN_DATE
  is '入库时间 ';
comment on column STOCK_LIST.IN_USER
  is '入库人';
comment on column STOCK_LIST.OUT_DATE
  is '出库时间 ';
comment on column STOCK_LIST.OUT_USER
  is '出库人';
comment on column STOCK_LIST.MEMO
  is '备注 ';
comment on column STOCK_LIST.STATUS
  is '状态N:在库 ，T在途，Y已使用 ，R返回KDX,H好件返还再途 F 维修站发货 V 普通到货';
comment on column STOCK_LIST.RETURN_TRACE_NO
  is '返好件运单';
comment on column STOCK_LIST.RETURN_TRACE_NAME
  is '返好件公司';
