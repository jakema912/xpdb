/* create tables*/

create INDEX ACCOUNT_INF_IDX  ON site01.ACCOUNT_INF
(STN_CODE, PN_NO, PART_STATUS)
TABLESPACE tsidx;

