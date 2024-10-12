--1a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
--A: 1881634483

--SELECT npi, SUM(total_claim_count) AS total_claim_count_over_all_drugs
--FROM prescription
--GROUP BY npi 
--ORDER BY total_claim_count_over_all_drugs DESC


--1b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.
--A: "BRUCE"	"PENDLEY"	"Family Practice"	99707

-- SELECT nppes_provider_first_name,nppes_provider_last_org_name, specialty_description, SUM(total_claim_count) AS total_claim_count_over_all_drugs
-- FROM prescription
-- INNER JOIN prescriber
-- ON prescriber.npi=prescription.npi
-- GROUP BY nppes_provider_first_name,nppes_provider_last_org_name, specialty_description
-- ORDER BY total_claim_count_over_all_drugs DESC


--2a. Which specialty had the most total number of claims (totaled over all drugs)?
--A: Family practice
--SELECT specialty_description, SUM(total_claim_count) AS total_claim_count_over_all_drugs
--FROM prescription
--INNER JOIN prescriber
--ON prescriber.npi=prescription.npi
--GROUP BY specialty_description
--ORDER BY total_claim_count_over_all_drugs DESC

--2b. Which specialty had the most total number of claims for opioids?
--A: Nurse Practitioner is first specialty-but this is not a specialty. Nurse practtioner is a type of provider. Te second specialty is Family Practice. 

--SELECT specialty_description, SUM(total_claim_count) AS total_opioid_claim_count
--FROM prescription
--INNER JOIN prescriber
--ON prescriber.npi=prescription.npi
--INNER JOIN drug
--ON prescription.drug_name=drug.drug_name
--WHERE opioid_drug_flag='Y' OR long_acting_opioid_drug_flag='Y'
--GROUP BY specialty_description
--ORDER BY total_opioid_claim_count DESC


--2c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
 --NOT DONE
--SELECT specialty_description, SUM(total_claim_count) AS total_opioid_claim_count
--FROM prescription
--INNER JOIN prescriber
--ON prescriber.npi=prescription.npi
--INNER JOIN drug
--ON prescription.drug_name=drug.drug_name
--WHERE opioid_drug_flag='Y' OR long_acting_opioid_drug_flag='Y'
--GROUP BY specialty_description
--ORDER BY total_opioid_claim_count DESC


--2d. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?
--BONUS-not done

--3a. Which drug (generic_name) had the highest total drug cost?
--A: Insulin Glargine

--SELECT generic_name, SUM(total_drug_cost) AS drug_cost
--FROM drug
--INNER JOIN prescription
--ON prescription.drug_name=drug.drug_name
--GROUP BY generic_name
--ORDER BY drug_cost DESC

--3b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
--A: teriparatide
-- SELECT generic_name, total_drug_cost, total_30_day_fill_count, ROUND(SUM((total_drug_cost*total_30_day_fill_count)/30), 2) AS total_drug_cost_per_day
-- FROM drug
-- INNER JOIN prescription
-- ON prescription.drug_name=drug.drug_name
-- GROUP BY generic_name, total_drug_cost, total_30_day_fill_count
-- ORDER BY total_drug_cost_per_day DESC

--CORRECTION for 3b:



--4a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. Hint: You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/

--SELECT drug_name, 
--CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
--WHEN long_acting_opioid_drug_flag= 'Y' THEN 'opioid'
--WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
--ELSE 'neither' 
--END AS drug_type
--FROM drug
--ORDER BY drug_name


--4b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
--A: Sum of total drug cost for long-acting opioids and opioids is more than the total drug cost for antibiotics

--SELECT MONEY(SUM(prescription.total_drug_cost)) AS total_cost,
--CASE WHEN opioid_drug_flag = 'Y' OR long_acting_opioid_drug_flag= 'Y' THEN 'opioid'
--WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
--ELSE 'neither' 
--END AS drug_type
--FROM drug
--INNER JOIN prescription
--ON prescription.drug_name=drug.drug_name
--GROUP BY opioid_drug_flag, long_acting_opioid_drug_flag, antibiotic_drug_flag
--ORDER BY total_cost


--5a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.
-- SELECT COUNT(cbsa), fips_county.state
-- FROM cbsa
-- INNER JOIN fips_county
-- ON cbsa.fipscounty=fips_county.fipscounty
-- WHERE fips_county.state LIKE 'TN'
-- GROUP BY fips_county.state


--5b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
--A: 34980, Nashville-Davidson--Murfreesboro--Franklin, TN, population 1830410
  --34100, Morristown, TN, population 116352
-- SELECT cbsa, fips_county.state, cbsaname, SUM(population) AS combined_population
-- FROM cbsa
-- INNER JOIN fips_county
-- ON cbsa.fipscounty=fips_county.fipscounty
-- INNER JOIN population
-- ON fips_county.fipscounty=population.fipscounty
-- GROUP BY cbsa,cbsaname,fips_county.state
-- ORDER BY combined_population DESC 

--Alternative: 
-- (SELECT cbsa, fips_county.state, cbsaname, SUM(population) AS combined_population, "largest" AS FLAG
-- FROM cbsa
-- INNER JOIN fips_county
-- ON cbsa.fipscounty=fips_county.fipscounty
-- INNER JOIN population
-- ON fips_county.fipscounty=population.fipscounty
-- GROUP BY cbsa,cbsaname,fips_county.state
-- ORDER BY combined_population DESC
-- LIMIT 1)

-- UNION

-- (SELECT cbsa, fips_county.state, cbsaname, SUM(population) AS combined_population, "smallest" as flag
-- FROM cbsa
-- INNER JOIN fips_county
-- ON cbsa.fipscounty=fips_county.fipscounty
-- INNER JOIN population
-- ON fips_county.fipscounty=population.fipscounty
-- GROUP BY cbsa,cbsaname,fips_county.state
-- ORDER BY combined_population 
-- LIMIT 1)


--5c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
--A: was still in works
-- SELECT cbsa, fips_county.state, cbsaname, county, SUM(population) AS combined_population
-- FROM cbsa
-- INNER JOIN fips_county
-- ON cbsa.fipscounty=fips_county.fipscounty
-- INNER JOIN population
-- ON fips_county.fipscounty=population.fipscounty
-- WHERE cbsa IS NULL
-- ORDER BY combined_population DESC 
---Try left outer join with cbsa

--Possible answers: 
-- SELECT 	f.county, 
-- 		f.state, 
-- 		SUM(p.population) AS total_pop
-- FROM population AS p
-- INNER JOIN fips_county AS f
-- USING(fipscounty)
-- LEFT JOIN cbsa as c 
-- USING (fipscounty)
-- WHERE c.cbsaname IS NULL
-- GROUP BY f.county, 
-- 		 f.state
-- ORDER BY total_pop DESC;

-- SELECT county, population
-- FROM fips_county
-- INNER JOIN population
-- USING(fipscounty)
-- WHERE fipscounty NOT IN (
-- 	SELECT fipscounty
-- 	FROM cbsa
-- )
-- ORDER BY population DESC;



--6a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- SELECT drug_name, total_claim_count
-- FROM prescription
-- WHERE total_claim_count>3000

--Note: Can use sum(total_claim_count) if wanting to eliminate duplicate drugs

--6b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
-- SELECT DISTINCT p.drug_name, total_claim_count, 
-- CASE WHEN opioid_drug_flag = 'Y' OR long_acting_opioid_drug_flag= 'Y' THEN 'opioid'
-- ELSE 'other' 
-- END AS drug_type
-- FROM prescription AS p
-- INNER JOIN drug AS d
-- ON p.drug_name=d.drug_name
-- WHERE total_claim_count>3000;



--6c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
-- SELECT DISTINCT p.drug_name, total_claim_count, nppes_provider_first_name, nppes_provider_last_org_name,
-- CASE WHEN opioid_drug_flag = 'Y' OR long_acting_opioid_drug_flag= 'Y' THEN 'opioid'
-- ELSE 'other' 
-- END AS drug_type
-- FROM prescription AS p
-- INNER JOIN drug AS d
-- ON p.drug_name=d.drug_name
-- INNER JOIN prescriber
-- ON p.npi=prescriber.npi
-- WHERE total_claim_count>3000;



--The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.


--7a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.
--Cross join function to give all the possible combos

-- SELECT prescriber.npi, drug_name
-- FROM prescriber
-- CROSS JOIN drug 
-- WHERE nppes_provider_city like 'NASHVILLE'
-- AND specialty_description like 'Pain Management'
-- AND opioid_drug_flag like 'Y'
-- ORDER BY prescriber.npi


--7b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
--Addition of sum function; addition of left join to prescription table

-- SELECT prescriber.npi,drug.drug_name,SUM(prescription.total_claim_count) AS sum_total_claims
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING (drug_name)
-- WHERE prescriber.specialty_description = 'Pain Management'
-- AND prescriber.nppes_provider_city = 'NASHVILLE'
-- AND drug.opioid_drug_flag = 'Y'
-- GROUP BY prescriber.npi,drug.drug_name
-- ORDER BY prescriber.npi


--7c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.
--Addition of coalesce function in select statement

-- SELECT prescriber.npi,drug.drug_name,COALESCE(SUM(prescription.total_claim_count),0) AS sum_total_claims
-- FROM prescriber
-- CROSS JOIN drug
-- LEFT JOIN prescription
-- USING (drug_name)
-- WHERE prescriber.specialty_description = 'Pain Management'
-- AND prescriber.nppes_provider_city = 'NASHVILLE'
-- AND drug.opioid_drug_flag = 'Y'
-- GROUP BY prescriber.npi,drug.drug_name
-- ORDER BY prescriber.npi


