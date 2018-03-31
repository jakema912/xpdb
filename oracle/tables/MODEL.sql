-- Create table
create table MODEL
(
  MODEL_ID    VARCHAR2(32) not null,
  AIRCRAFT    VARCHAR2(32),
  MODEL_DESC  VARCHAR2(32),
  FLAG        CHAR(1) default 'Y',
  ADD_DATE    DATE,
  OPT_USER    VARCHAR2(32),
  AIRCRAFT_ID VARCHAR2(32)
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
comment on column MODEL.MODEL_ID
  is '主机型号';
comment on column MODEL.AIRCRAFT
  is '机种';
comment on column MODEL.MODEL_DESC
  is '型号描述';
comment on column MODEL.ADD_DATE
  is '加入时间';
comment on column MODEL.OPT_USER
  is '操作人';
comment on column MODEL.AIRCRAFT_ID
  is '机种编号';
