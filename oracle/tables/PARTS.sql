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
  is '备件号';
comment on column PARTS.BILL_ID
  is '订单号';
comment on column PARTS.STATUS
  is '备件状态8001:申备，8002发货，8003返还，8004返厂, 8000.8009';
comment on column PARTS.PN
  is '备件pn';
comment on column PARTS.STN_CODE
  is '操作维修站';
comment on column PARTS.PART_SN
  is '坏件sn';
comment on column PARTS.NEW_SN
  is '新件sn';
comment on column PARTS.SEND_FLAG
  is '发货状态 ';
comment on column PARTS.SEND_DATE
  is '发货时间';
comment on column PARTS.GET_ENG
  is '领用人 ';
comment on column PARTS.GET_DATE
  is '领用时间';
comment on column PARTS.REQ_DATE
  is '申请时间';
comment on column PARTS.REQ_USER
  is '申请人 ';
comment on column PARTS.BACK_FLAG
  is '返还状态';
comment on column PARTS.BACK_DATE
  is '返还人';
comment on column PARTS.BACK_TYPE
  is '返还类型 好件，坏件';
comment on column PARTS.SEND_PN
  is '发货pn';
comment on column PARTS.OPT_USER
  is '操作人 ';
comment on column PARTS.OPT_DATE
  is '操作时间 ';
comment on column PARTS.SEND_STOCK_ID
  is '库存';
comment on column PARTS.PN_NAME
  is '备件名称';
comment on column PARTS.PN_DESC
  is '备件描述';
comment on column PARTS.OVO_FLAG
  is '是否一对一';
