-- Create table
create table BILLS_DEALER
(
  BILL_NO            VARCHAR2(32) not null,
  SN                 VARCHAR2(32),
  STATUS             VARCHAR2(4),
  MODEL              VARCHAR2(32),
  APPEARANCE         VARCHAR2(512),
  WARRANTY           VARCHAR2(16),
  PURDATE            DATE,
  OPEN_DATE          DATE default sysdate,
  CHAN_ID            VARCHAR2(16),
  GU_CLASS           VARCHAR2(16),
  GU_DESC            VARCHAR2(512),
  M_HOUR             VARCHAR2(16),
  D_HOUR             VARCHAR2(16),
  SEND_DATE          DATE,
  SEND_TRACE_NO      VARCHAR2(32),
  SEND_TRACE_NAME    VARCHAR2(16),
  SEND_USER_ID       VARCHAR2(32),
  RETURN_DATE        DATE,
  RETURN_USER_ID     VARCHAR2(32),
  RETURN_TRACE_NO    VARCHAR2(32),
  RETURN_TRACE_NAME  VARCHAR2(32),
  M_TYPE             VARCHAR2(32),
  PART_TYPE          VARCHAR2(32),
  RVC_DATE           DATE,
  RVC_USER_ID        VARCHAR2(32),
  RVC_FLAG           VARCHAR2(16),
  RVC_MEMO           VARCHAR2(512),
  RVC_CHAN_ID        VARCHAR2(32),
  DEALER_RVC_USER_ID VARCHAR2(32),
  DEALER_RVC_DATE    DATE
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
