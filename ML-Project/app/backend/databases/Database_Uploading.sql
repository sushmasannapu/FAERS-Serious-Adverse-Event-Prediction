USE faers_db;
CREATE TABLE reports (
	source_file VARCHAR(50),
    safetyreportid INT PRIMARY KEY,
    safetyreportversion INT,
    primarysourcecountry VARCHAR(10),
    occurcountry VARCHAR(10),
    transmissiondate INT,
    reporttype INT,
    serious INT,
    seriousnessdeath INT,
    seriousnesslifethreatening INT,
    seriousnesshospitalization INT,
    seriousnessdisabling INT,
    seriousnesscongenitalanomali INT,
    seriousnessother INT,
    receivedate INT,
    receiptdate INT,
    fulfillexpeditecriteria INT,
    companynumb VARCHAR(100),
    duplicate INT,
    reportercountry VARCHAR(10),
    qualification INT,
    senderorganization VARCHAR(100),
    patient_age DECIMAL(6,1),
    patient_age_unit INT,
    patient_age_years DECIMAL(6,1),
    patient_weight_kg DECIMAL(6,1),
    patient_sex INT,
    patient_death_date VARCHAR(20),
    num_drugs INT,
    num_reactions INT,
    suspect_drugs TEXT,
    all_drugs TEXT,
    drug_indications TEXT,
    reactions TEXT,
    reaction_outcomes VARCHAR(200),
    serious_target TINYINT
);


ALTER TABLE reports MODIFY patient_weight_kg DECIMAL(8,2);

TRUNCATE TABLE reports;

LOAD DATA LOCAL INFILE 'C:/Users/Sushma Shekar/sushma python classes/ML Project/data/proccessed/faers_2026q1_reports_cleaned.csv'
INTO TABLE reports
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(source_file, safetyreportid, safetyreportversion, primarysourcecountry, occurcountry,
 transmissiondate, reporttype, @serious, @seriousnessdeath, @seriousnesslifethreatening,
 @seriousnesshospitalization, @seriousnessdisabling, @seriousnesscongenitalanomali,
 @seriousnessother, receivedate, receiptdate, @fulfillexpeditecriteria, companynumb,
 @duplicate, reportercountry, @qualification, senderorganization, @patient_age,
 @patient_age_unit, @patient_age_years, @patient_weight_kg, @patient_sex, patient_death_date,
 num_drugs, num_reactions, suspect_drugs, all_drugs, drug_indications, reactions,
 reaction_outcomes, serious_target)
SET seriousnessdeath = NULLIF(@seriousnessdeath, ''),
	serious = NULLIF(@serious,''),
    qualification = NULLIF(@qualification,''),
    seriousnesslifethreatening = NULLIF(@seriousnesslifethreatening, ''),
    seriousnesshospitalization = NULLIF(@seriousnesshospitalization, ''),
    seriousnessdisabling = NULLIF(@seriousnessdisabling, ''),
    seriousnesscongenitalanomali = NULLIF(@seriousnesscongenitalanomali, ''),
    seriousnessother = NULLIF(@seriousnessother, ''),
    fulfillexpeditecriteria = NULLIF(@fulfillexpeditecriteria, ''),
    duplicate = NULLIF(@duplicate, ''),
    patient_age = NULLIF(@patient_age, ''),
    patient_age_unit = NULLIF(@patient_age_unit, ''),
    patient_age_years = NULLIF(@patient_age_years, ''),
    patient_weight_kg = NULLIF(@patient_weight_kg, ''),
    patient_sex = NULLIF(@patient_sex, '');


SELECT COUNT(*) FROM reports;
SELECT COUNT(*) FROM reports WHERE patient_weight_kg IS NULL;
SELECT COUNT(*) FROM reports WHERE serious IS NULL;
SELECT COUNT(*) FROM reports WHERE qualification IS NULL;

CREATE TABLE reactions (
    source_file VARCHAR(50),
    safetyreportid INT,
    reaction_seq INT,
    reactionmeddrapt VARCHAR(255),
    reactionoutcome INT,
    PRIMARY KEY (safetyreportid, reaction_seq),
    FOREIGN KEY (safetyreportid) REFERENCES reports(safetyreportid)
);

LOAD DATA LOCAL INFILE 'C:/Users/Sushma Shekar/sushma python classes/ML Project/data/proccessed/faers_2026q1_drugs_cleaned.csv'
INTO TABLE reactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(source_file, safetyreportid, reaction_seq, reactionmeddrapt, @reactionoutcome)
SET reactionoutcome = NULLIF(@reactionoutcome, '');

SELECT COUNT(*) FROM reactions;

CREATE TABLE drugs (
    source_file VARCHAR(50),
    safetyreportid INT,
    drug_seq INT,
    drugcharacterization INT,
    medicinalproduct VARCHAR(255),
    drugauthorizationnumb VARCHAR(50),
    drugstructuredosagenumb DECIMAL(10,3),
    drugstructuredosageunit VARCHAR(10),
    drugdosagetext VARCHAR(500),
    drugadministrationroute VARCHAR(10),
    drugindication VARCHAR(500),
    drugstartdate VARCHAR(20),
    drugenddate VARCHAR(20),
    drugtreatmentduration INT,
    drugtreatmentdurationunit VARCHAR(10),
    actiondrug INT,
    activesubstancename VARCHAR(255),
    PRIMARY KEY (safetyreportid, drug_seq),
    FOREIGN KEY (safetyreportid) REFERENCES reports(safetyreportid)
);

LOAD DATA LOCAL INFILE 'C:/Users/Sushma Shekar/sushma python classes/ML Project/data/proccessed/faers_2026q1_reactions_cleaned.csv'
INTO TABLE drugs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(source_file, safetyreportid, drug_seq, @drugcharacterization, medicinalproduct,
 drugauthorizationnumb, @drugstructuredosagenumb, drugstructuredosageunit, drugdosagetext,
 drugadministrationroute, drugindication, drugstartdate, drugenddate,
 @drugtreatmentduration, drugtreatmentdurationunit, @actiondrug, activesubstancename)
SET drugcharacterization = NULLIF(@drugcharacterization, ''),
    drugstructuredosagenumb = NULLIF(@drugstructuredosagenumb, ''),
    drugtreatmentduration = NULLIF(@drugtreatmentduration, ''),
    actiondrug = NULLIF(@actiondrug, '');
    
    SELECT COUNT(*) FROM drugs