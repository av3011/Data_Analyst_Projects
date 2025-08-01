create database edtech;
use edtech;

/*Here data types are like var(max), bigint which will occupy more space that I don't want. 
I will create tables here and will append from python*/

create Table assigned_managers (
[snr_sm_id] varchar(20),
[jnr_sm_id] varchar(20),
[assigned_date] date,
[cycle] int,
[lead_id] varchar(20)	
)

create table demo_watch (
[lead_id] varchar(20),
[demo_watched_date] date,
[language] varchar(20),
[watched_percentage] int
)

create table lead_details (
[lead_id] varchar(20),
[age] int,
[gender] varchar(10),
[current_city] varchar(50),
[current_education] varchar(50),
[parent_occupation] varchar(50),
[lead_gen_source] varchar(20)
)

create table lead_dropoff_info (
[lead_id] varchar(20),
[drop_off_stage] varchar(20),
[drop_off_reason] varchar(50)
)


create table lead_interaction (
jnr_sm_id varchar(20),
lead_id varchar(20),
lead_stage varchar(20),
call_done_date date,
[call_status] varchar(20),
[call_reason] varchar(50)
)

select * from assigned_managers;
select * from demo_watch;
select * from lead_details;
select * from lead_dropoff_info;
select * from lead_interaction;

-----------------------------------------------------Analysis-------------------------------------------------------------------------------------

-------------------Demo watch table analysis------------------------
select * from demo_watch;

-----In which laguage leads are watching demo: Egnlish being the most popular lang followed by Telugu and Hindi------
select language, count(lead_id) leads_count 
from demo_watch 
group by language
order by leads_count desc;


------Avg watching percentage based on language: most of the leads are watching only half demo-----------
select language, avg(watched_percentage) as avg_duration 
from demo_watch 
group by language;


-------------------Lead details table analysis------------------------
select * from lead_details;


-----------------Gender wise bifercation: Females number are higher than males---------------------
select gender, count(lead_id) as no_of_leads 
from lead_details 
group by gender; 



----------------Locationwise bifercation: most of the leads are from south india---------------
with cte as (
select current_city, 
	   case when current_city in ('Bengaluru','Chennai','Hyderababd','kochi','Visakhapatnam') then 'South India'
			else 'West India' end as location from lead_details)
select location, count(*) from cte group by location;

------------Proffesionwise bifercation: most of the leads are Btech or looking for job-----------------------
select distinct current_education from lead_details

select current_education, count(lead_id) as no_of_leads
from lead_details
group by current_education
order by no_of_leads desc;


--------------lead source: social media is on the top-----------------
select lead_gen_source as lead_souce, count(lead_id) as no_of_leads 
from lead_details 
group by lead_gen_source
order by no_of_leads desc;



----------------------Dropoff table analysis--------------------
select * from lead_dropoff_info;

----------In which stage leads drop off: high no of leads drop off at demo stage----------------
select drop_off_stage, count(lead_id) as no_of_leads 
from lead_dropoff_info
group by drop_off_stage
order by no_of_leads desc;


-------------reason of dropoff: two main reasons are expensive and online-----------------------
select drop_off_reason, count(lead_id) as no_of_leads 
from lead_dropoff_info
group by drop_off_reason
order by no_of_leads desc;



------------------------lead interaction table analysis---------------------------
select * from lead_interaction;

------------leads conversion rate: only 19.45% leads converted as successful leads------------------
with successful_lead as (
select lead_stage, count(distinct lead_id) as no_of_leads 
from lead_interaction
where call_status='successful'
group by lead_stage),
total_leads as (
select sum(no_of_leads) total_leads from successful_lead)
select s.lead_Stage, s.no_of_leads,  ROUND(cast(s.no_of_leads as float)*100 / t.total_leads, 2) AS conversion_percentage
from successful_lead s cross join total_leads t
ORDER BY 
    CASE s.lead_stage
        WHEN 'lead' THEN 1
        WHEN 'awareness' THEN 2
        WHEN 'consideration' THEN 3
        WHEN 'conversion' THEN 4
        
    END;


-------------------Junior manager perfromance: sometimes more assigned leads result in bad manager performance ----------------------------
select distinct jnr_sm_id, count(distinct lead_id) as no_of_leads 
from lead_interaction
group by jnr_sm_id
order by jnr_sm_id;  

with lead_per_manager as (
	select jnr_sm_id, count(distinct lead_id) as total_lead from lead_interaction group by jnr_sm_id),
manager_performance as (
SELECT 
    jnr_sm_id,
    COUNT(DISTINCT CASE WHEN lead_stage = 'lead' THEN lead_id END) AS lead_count,
    COUNT(DISTINCT CASE WHEN lead_stage = 'awareness' THEN lead_id END) AS awareness_count,
    COUNT(DISTINCT CASE WHEN lead_stage = 'consideration' THEN lead_id END) AS consideration_count,
    COUNT(DISTINCT CASE WHEN lead_stage = 'conversion' THEN lead_id END) AS conversion_count
FROM 
    lead_interaction
WHERE 
    call_status = 'successful'
GROUP BY 
    jnr_sm_id)
select *, round(cast(mp.conversion_count as float)*100.0/lm.total_lead,2) as success_rate from lead_per_manager lm join manager_performance mp 
on mp.jnr_sm_id=lm.jnr_sm_id
ORDER BY 
    mp.jnr_sm_id;



-----------------------------percentage of conversion in each stage: lead_Stage has highest conversion rate with 92% but final conversion rate is only 18%-----------------------------
with total_leads as (
	select count(distinct lead_id) as total_lead from lead_interaction),
stage_success_cnt as (select COUNT(DISTINCT CASE WHEN lead_stage = 'lead' THEN lead_id END) AS lead_count,
    COUNT(DISTINCT CASE WHEN lead_stage = 'awareness' THEN lead_id END) AS awareness_count,
    COUNT(DISTINCT CASE WHEN lead_stage = 'consideration' THEN lead_id END) AS consideration_count,
    COUNT(DISTINCT CASE WHEN lead_stage = 'conversion' THEN lead_id END) AS conversion_count
	from lead_interaction
	where call_status='successful')
select round(cast(sc.conversion_count*1.0/tl.total_lead as float)*100,2) total_conversion,
	   round(cast(sc.lead_count*1.0/tl.total_lead as float)*100,2) total_to_lead_percent,
	   round(cast(sc.awareness_count*1.0/sc.lead_count as float)*100,2) lead_awareness_percent,
	   round(cast(sc.consideration_count*1.0/sc.awareness_count as float)*100,2) awareness_consideration_percent,
	   round(cast(sc.conversion_count*1.0/sc.consideration_count as float)*100,2) consideration_conversion_percent
	   from stage_success_cnt sc join total_leads tl on 1=1


-----------------------Assigned manager table analysis--------------------
select * from assigned_managers;
select * from lead_interaction;

-------------count of jn_sm and lead under one sn_sm------------------
select snr_sm_id, count(distinct jnr_sm_id) as no_jnr_sm, count(distinct lead_id) as no_of_leads 
from assigned_managers 
group by snr_sm_id; 


-------------------count of leads under one jn_sm: on avg 20 leads under one junior manager-------------------
select snr_sm_id, jnr_sm_id, count(distinct lead_id) as no_of_leads 
from assigned_managers 
group by snr_sm_id,jnr_sm_id; 

-------------------------Senior manager success rate: acvg sucess rate is around 19.5 percent------------------------
with cte as (
select am.snr_sm_id, count(distinct li.lead_id) total_lead, 
count(distinct case when li.lead_stage='conversion' then li.lead_id end) as conversion_stage_count
from assigned_managers am join lead_interaction li on am.jnr_sm_id=li.jnr_sm_id
where li.call_status='successful'
group by am.snr_sm_id)
select snr_sm_id, round(cast(conversion_stage_count*100.0/total_lead as float),2) success_rate from cte;


---------------------------conversion rate analysis----------------------------------
----------gender  based: females are more likely to take course------------------------
select * from lead_details;


with conversion_count as (
select distinct lead_id as no_of_leads
from lead_interaction 
where lead_stage='conversion' and call_status='successful'
),
gender_count as(
select lead_id, gender from lead_details 
)
select gc.gender, round(cast(count(cc.no_of_leads)*100.0/count(gc.lead_id)as float),2) as conversion_rate
from conversion_count cc right join gender_count gc on cc.no_of_leads=gc.lead_id
group by gc.gender;


----------city wise: Bengaluru has the highest conversion rate, mumbai at the last place-------------------------
with conversion_count as (
select distinct lead_id as no_of_leads
from lead_interaction 
where lead_stage='conversion' and call_status='successful'
),
city_rate as(
select lead_id, current_city from lead_details 
)
select cr.current_city, round(cast(count(cc.no_of_leads)*100.0/count(cr.lead_id)as float),2) as conversion_rate
from conversion_count cc right join city_rate cr on cc.no_of_leads=cr.lead_id
group by cr.current_city
order by conversion_rate desc;


-------------Education based: Degree holders are converting most--------------------------------------
with conversion_count as (
select distinct lead_id as no_of_leads
from lead_interaction 
where lead_stage='conversion' and call_status='successful'
),
education_rate as(
select lead_id, current_education from lead_details 
)
select er.current_education, round(cast(count(cc.no_of_leads)*100.0/count(er.lead_id)as float),2) as conversion_rate
from conversion_count cc right join education_rate er on cc.no_of_leads=er.lead_id
group by er.current_education 
order by conversion_rate desc;


-------------------lead source rate: email marketing most effective-------------------------------
with conversion_count as (
select distinct lead_id as no_of_leads
from lead_interaction 
where lead_stage='conversion' and call_status='successful'
),
leadsource_rate as(
select lead_id, lead_gen_source from lead_details 
)
select lr.lead_gen_source, round(cast(count(cc.no_of_leads)*100.0/count(lr.lead_id)as float),2) as conversion_rate
from conversion_count cc right join leadsource_rate lr on cc.no_of_leads=lr.lead_id
group by lr.lead_gen_source 
order by conversion_rate desc;
