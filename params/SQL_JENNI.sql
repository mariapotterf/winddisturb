DROP TABLE IF EXISTS opers2;
DROP TABLE IF EXISTS opers3;
DROP TABLE IF EXISTS max_v;

CREATE TABLE max_v AS SELECT comp_unit.id AS id,MAX(comp_unit.V) AS max_v FROM comp_unit GROUP BY comp_unit.id;

CREATE TABLE OPERS2 AS SELECT t.id, t.branch, t.op_date, br.branching_group, case when t.op_name = "clearcut" OR t.op_name = "clearcut_nature_scene" then 1 else 0 end as bool,t.op_name,
(SELECT sum(op_res.income) FROM op_res WHERE t.op_id = op_res.op_id )/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS income, 
(SELECT sum(op_res.cash_flow) FROM op_res WHERE t.op_id = op_res.op_id )/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS cash_flow,
(SELECT sum(op_res.income) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =1 )/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS income_log,
(SELECT sum(op_res.income) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =2 )/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS income_pulp,
(SELECT sum(op_res.income_biomass) FROM op_res WHERE t.op_id = op_res.op_id )/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS income_biomass,
(SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =1)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_log,
(SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =2)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_pulp,
(SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V,
(SELECT sum(op_res.Biomass) FROM op_res WHERE t.op_id = op_res.op_id)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Biomass,
ifnull((SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =1 and op_res.sp = 1),0)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_log_pine,
ifnull((SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =2 and op_res.sp = 1),0)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_pulp_pine,
ifnull((SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =1 and op_res.sp = 2),0)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_log_spruce,
ifnull((SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =2 and op_res.sp = 2),0)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_pulp_spruce,
ifnull((SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =1 and (op_res.sp = 3 or op_res.sp = 4)),0)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_log_birch,
ifnull((SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and op_res.assortment =2 and (op_res.sp = 3 or op_res.sp = 4)),0)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_V_pulp_birch,
ifnull((SELECT sum(op_res.Volume) FROM op_res WHERE t.op_id = op_res.op_id and (op_res.assortment =2 or op_res.assortment =1) and op_res.sp > 4),0)/((select count(*) from (select  * from op_res where t.op_id = op_res.op_id) x)/(select count(*) from (select distinct * from op_res where t.op_id = op_res.op_id ) x)  ) AS Harvested_v_others,    
(CASE WHEN t.op_name is "clearcut" THEN 55 WHEN t.op_name is "clearcut_nature_scene" THEN 55 WHEN t.op_name is "first_thinning" THEN 40 WHEN t.op_name is "thinning" THEN 50 WHEN t.op_name is "selection_cut" THEN 50 WHEN t.op_name is "selection_cut_with_little_open_areas" THEN 50 WHEN t.op_name is "remove_seedtrees" THEN 55 WHEN t.op_name is "seedtree_position" THEN 55 WHEN t.op_name is "seedtree_position_nature_scene" THEN 55 ELSE 9999 END) as P_PINE_LOG,
(CASE WHEN t.op_name is "clearcut" THEN 17 WHEN t.op_name is "clearcut_nature_scene" THEN 17 WHEN t.op_name is "first_thinning" THEN 11 WHEN t.op_name is "thinning" THEN 13 WHEN t.op_name is "selection_cut" THEN 13 WHEN t.op_name is "selection_cut_with_little_open_areas" THEN 13 WHEN t.op_name is "remove_seedtrees" THEN 17 WHEN t.op_name is "seedtree_position" THEN 17 WHEN t.op_name is "seedtree_position_nature_scene" THEN 17 ELSE 9999 END) as P_PINE_PULP,
(CASE WHEN t.op_name is "clearcut" THEN 55 WHEN t.op_name is "clearcut_nature_scene" THEN 55 WHEN t.op_name is "first_thinning" THEN 42 WHEN t.op_name is "thinning" THEN 50 WHEN t.op_name is "selection_cut" THEN 50 WHEN t.op_name is "selection_cut_with_little_open_areas" THEN 50 WHEN t.op_name is "remove_seedtrees" THEN 55 WHEN t.op_name is "seedtree_position" THEN 55 WHEN t.op_name is "seedtree_position_nature_scene" THEN 55 ELSE 9999 END) as P_SPRUCE_LOG,
(CASE WHEN t.op_name is "clearcut" THEN 25 WHEN t.op_name is "clearcut_nature_scene" THEN 25 WHEN t.op_name is "first_thinning" THEN 19 WHEN t.op_name is "thinning" THEN 21 WHEN t.op_name is "selection_cut" THEN 21 WHEN t.op_name is "selection_cut_with_little_open_areas" THEN 21 WHEN t.op_name is "remove_seedtrees" THEN 25 WHEN t.op_name is "seedtree_position" THEN 25 WHEN t.op_name is "seedtree_position_nature_scene" THEN 25 ELSE 9999 END) as P_SPRUCE_PULP,
(CASE WHEN t.op_name is "clearcut" THEN 43 WHEN t.op_name is "clearcut_nature_scene" THEN 43 WHEN t.op_name is "first_thinning" THEN 35 WHEN t.op_name is "thinning" THEN 38 WHEN t.op_name is "selection_cut" THEN 38 WHEN t.op_name is "selection_cut_with_little_open_areas" THEN 38 WHEN t.op_name is "remove_seedtrees" THEN 43 WHEN t.op_name is "seedtree_position" THEN 43 WHEN t.op_name is "seedtree_position_nature_scene" THEN 43 ELSE 9999 END) as P_BIRCH_LOG,
(CASE WHEN t.op_name is "clearcut" THEN 15 WHEN t.op_name is "clearcut_nature_scene" THEN 15 WHEN t.op_name is "first_thinning" THEN 10 WHEN t.op_name is "thinning" THEN 11 WHEN t.op_name is "selection_cut" THEN 11 WHEN t.op_name is "selection_cut_with_little_open_areas" THEN 11 WHEN t.op_name is "remove_seedtrees" THEN 15 WHEN t.op_name is "seedtree_position" THEN 15 WHEN t.op_name is "seedtree_position_nature_scene" THEN 15 ELSE 9999 END) as P_BIRCH_PULP,
(CASE WHEN t.op_name is "clearcut" THEN 10 WHEN t.op_name is "clearcut_nature_scene" THEN 10 WHEN t.op_name is "first_thinning" THEN 7 WHEN t.op_name is "thinning" THEN 8 WHEN t.op_name is "selection_cut" THEN 8 WHEN t.op_name is "selection_cut_with_little_open_areas" THEN 8 WHEN t.op_name is "remove_seedtrees" THEN 10 WHEN t.op_name is "seedtree_position" THEN 10 WHEN t.op_name is "seedtree_position_nature_scene" THEN 10 ELSE 9999 END) as P_OTHER
FROM op_link t
LEFT OUTER JOIN branch_desc br ON br.branch = t.branch AND t.id = br.id
WHERE cash_flow is not null;


CREATE TABLE OPERS3 AS SELECT distinct id, branch, op_date, branching_group, sum(income) as income,
 sum(Harvested_V_pulp) as Harvested_V_pulp, sum(Harvested_V_log) as Harvested_V_log,
 sum(Harvested_V) as Harvested_V, case when sum(bool) > 0 then 1 else 0 end as clearcut,
SUM(income_log) as income_log, SUM(income_pulp) as income_pulp,
SUM(income_biomass) as income_biomass, SUM(Biomass) as Biomass,
sum(Harvested_V_log_pine* P_PINE_LOG+ Harvested_V_log_spruce* P_SPRUCE_LOG+ Harvested_V_log_birch* P_BIRCH_LOG) as income_log_change,
 sum(Harvested_V_pulp_pine* P_PINE_PULP+ Harvested_V_pulp_spruce* P_SPRUCE_PULP+ Harvested_V_pulp_birch* P_BIRCH_PULP+ Harvested_v_others* P_OTHER)as income_pulp_change,
 SUM(cash_flow) as cash_flow
FROM OPERS2
group by id, branch, op_date;
 
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
 l.data_date, b.branch, b.branch_desc, b.branching_group, o.income/u.AREA as income, o.cash_flow/u.AREA as cash_flow,  o.clearcut, o.Harvested_V_log/u.AREA as Harvested_V_log, 
 o.Harvested_V_pulp/u.AREA as Harvested_V_pulp,  o.Harvested_V/u.AREA as Harvested_V,  m.max_v, o.income_log/u.AREA as income_log, o.income_pulp/u.AREA as income_pulp,
o.income_log_change/u.AREA as income_log_change,o.income_pulp_change/u.AREA as income_pulp_change, o.income_biomass, o.Biomass/u.AREA as Biomass
 FROM comp_unit u, data_link l
left outer join branch_desc b on l.branch = b.branch and l.id = b.id 
cross join max_v m on l.id = m.id
left outer join OPERS3 o on o.branch = b.branch and o.id = b.id  and o.op_date= l.data_date
WHERE u.data_id=l.data_id and max_v <1000
ORDER BY u.id, l.branch, l.data_date;

.mode csv
.out SA_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group is Null;

.mode csv
.out BAU_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio harvest";

.mode csv
.out BAU_10_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation harvest 10";

.mode csv
.out BAU_15_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation harvest 15";

.mode csv
.out BAU_30_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation harvest 30";

.mode csv
.out BAU_5_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation harvest 5";

.mode csv
.out BAU_m5_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Short rotation harvest 5";

.mode csv
.out BAUwGTR_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio harvest nature scene";

.mode csv
.out BAUwoT_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio harvest without thinnings";

.mode csv
.out BAUwoT_10_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio harvest without thinnings 10";

.mode csv
.out BAUwoT_m20_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio harvest without thinnings -20";

.mode csv
.out BAUwT_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio thinning";

.mode csv
.out BAUwT_10_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation thinning 10";

.mode csv
.out BAUwT_15_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation thinning 15";

.mode csv
.out BAUwT_30_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation thinning 30";

.mode csv
.out BAUwT_5_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation thinning 5";

.mode csv
.out BAUwT_GTR_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio thinning nature";

.mode csv
.out BAUwT_m5_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Short rotation thinning 5";

.mode csv
.out CCF_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Selection cut";

.mode csv
.out LR_NT_30_p_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group ="Tapio harvest without thinnings 30 p";

.mode csv
.out LR_30_p_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group ="Long rotation harvest 30 p";

.mode csv
.out LR_NT_10_p_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Tapio harvest without thinnings 10 p";

.mode csv
.out LR_10_p_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group = "Long rotation harvest 10 p";

.mode csv
.out SR_NT_10_n_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group ="Tapio harvest without thinnings 10 n";

.mode csv
.out SR_10_n_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group ="Short rotation harvest 10 n";

.mode csv
.out SR_NT_30_n_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group ="Tapio harvest without thinnings 30 n";

.mode csv
.out SR_30_n_XXXXX.csv
.headers on
.nullvalue 0
SELECT u.*
FROM unit u
where u.branching_group ="Short rotation harvest 30 n";
