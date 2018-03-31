create or replace trigger "TRIGGERS_STOCK_LIST_LOG" 
   before INSERT OR UPDATE on stock_list
  for each row
declare
  -- local variables here
begin
  INSERT INTO stock_list_log
    (STOCK_ID, old_status, new_status, memo, opt_user,NEW_CHAN_ID,OLD_CHAN_ID,opt_date)
  VALUES
    (:new.stock_id,
     nvl(:old.status,'N'),
     :new.status,
     :new.memo,
     :new.opt_user,
     :new.chan_id,
     :old.chan_id,sysdate);
       
end TRIGGERS_STOCK_LIST_LOG;
/
