DROP TABLE IF EXISTS opers2;
DROP TABLE IF EXISTS opers3;
DROP TABLE IF EXISTS max_v;

CREATE TABLE max_v AS SELECT comp_unit.id AS id,MAX(comp_unit.V) AS max_v FROM comp_unit GROUP BY comp_unit.id;
 
DROP TABLE IF EXISTS unit;

Create Table UNIT AS SELECT u.*,(select max(stratum.H_dom) From stratum where stratum.data_id = u.data_id) as H_dom, 
(select max(stratum.D_gm) From stratum where stratum.data_id = u.data_id) as D_gm, 
(select sum(stratum.N) From stratum where stratum.data_id = u.data_id and D_gm >40) as N_where_D_gt_40,
(select sum(stratum.N) From stratum where stratum.data_id = u.data_id and D_gm <=40 and D_gm > 35) as N_where_D_gt_35_lt_40,
(select sum(stratum.N) From stratum where stratum.data_id = u.data_id and D_gm <=35 and D_gm > 30) as N_where_D_gt_30_lt_35,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and D_gm >40) as V_where_D_gt_40,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and D_gm <=40 and D_gm > 35) as V_where_D_gt_35_lt_40,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and D_gm <=35 and D_gm > 30) as V_where_D_gt_30_lt_35,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 5) as V_populus,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 6) as V_Alnus_incana,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 7) as V_Alnus_glutinosa,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 8) as V_o_coniferous,
(select sum(stratum.V) From stratum where stratum.data_id = u.data_id and SP = 9) as V_o_decidious,
 l.data_date, b.branch, b.branch_desc, b.branching_group, 0 as income, 0 as cash_flow,  0 as clearcut, 0 as Harvested_V_log, 
 0 as Harvested_V_pulp,  0 as Harvested_V,  m.max_v, 0 as income_log, 0 as income_pulp,
0 as income_log_change,  0 as income_pulp_change, 0 as income_biomass, 0 as Biomass
 FROM comp_unit u, data_link l
left outer join branch_desc b on l.branch = b.branch and l.id = b.id 
cross join max_v m on l.id = m.id
WHERE u.data_id=l.data_id and max_v <1000
ORDER BY u.id, l.branch, l.data_date;

DROP TABLE IF EXISTS BAU;
DROP TABLE IF EXISTS BAU_10;DROP TABLE IF EXISTS BAU_15;DROP TABLE IF EXISTS BAU_30;DROP TABLE IF EXISTS BAU_5;DROP TABLE IF EXISTS BAU_m5;DROP TABLE IF EXISTS BAUwGTR;DROP TABLE IF EXISTS BAUwoT;DROP TABLE IF EXISTS BAUwoT_10;DROP TABLE IF EXISTS BAUwoT_m20;DROP TABLE IF EXISTS BAUwT;DROP TABLE IF EXISTS BAUwT_10;DROP TABLE IF EXISTS BAUwT_15;DROP TABLE IF EXISTS BAUwT_30;DROP TABLE IF EXISTS BAUwT_5;DROP TABLE IF EXISTS BAUwT_GTR;DROP TABLE IF EXISTS BAUwt_m5;DROP TABLE IF EXISTS CCF_1;
DROP TABLE IF EXISTS CCF_2;
DROP TABLE IF EXISTS CCF_3;
DROP TABLE IF EXISTS CCF_4;DROP TABLE IF EXISTS SA;

CREATE TABLE SA AS
SELECT u.*
FROM unit u
where u.branching_group is Null;

