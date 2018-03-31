create or replace trigger "TRIGGERS_ACCOUNT_INF" 
  before insert on account_inf  
  for each row
declare
  -- local variables here
begin

  --好件增加
  IF :new.inout_type = 'IN' AND :new.part_status = 'GOOD' THEN
    pk_hedy.usp_change_stock(:new.stn_code, :new.pn_no, 1, 0);
  END IF;
  --好件减少
  IF :new.inout_type = 'OUT' AND :new.part_status = 'GOOD' THEN
    pk_hedy.usp_change_stock(:new.stn_code, :new.pn_no, -1, 0);
  END IF;
  --坏件增加
  IF :new.inout_type = 'IN' AND :new.part_status = 'BAD' THEN
    pk_hedy.usp_change_stock(:new.stn_code, :new.pn_no, 0, 1);
  END IF;
  --坏件减少
  IF :new.inout_type = 'OUT' AND :new.part_status = 'BAD' THEN
    pk_hedy.usp_change_stock(:new.stn_code, :new.pn_no, 0, -1);
  END IF;
exception
  when others then
    raise_application_error(-20001, :new.pn_no || '库存不足!');
end triggers_account_inf;
/
