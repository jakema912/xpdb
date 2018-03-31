-- Create table
create table BAD_STOCK_LIST
(
  B_STOCK_ID VARCHAR2(32) not null,
  PN         VARCHAR2(32),
  PN_DESC    VARCHAR2(32),
  IMEI       VARCHAR2(32),
  OPT_USER   VARCHAR2(32),
  TRACE_NO   VARCHAR2(32),
  OPT_DATE   DATE,
  STATUS     VARCHAR2(32),
  BILL_NO    VARCHAR2(32),
  PARTS_ID   VARCHAR2(32),
  CHAN_ID    VARCHAR2(32),
  SN         VARCHAR2(32),
  RVC_DATE   DATE,
  RVC_USER   VARCHAR2(32),
  TRACE_NAME VARCHAR2(128)
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
comment on column BAD_STOCK_LIST.SN
  is '描述';
comment on column BAD_STOCK_LIST.RVC_DATE
  is '收货时间';
comment on column BAD_STOCK_LIST.RVC_USER
  is '收货人';
comment on column BAD_STOCK_LIST.TRACE_NAME
  is '快递公司';
-- Create/Recreate primary, unique and foreign key constraints 
alter table BAD_STOCK_LIST
  add constraint B_UK primary key (B_STOCK_ID)
  using index 
  tablespace A_SMS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
