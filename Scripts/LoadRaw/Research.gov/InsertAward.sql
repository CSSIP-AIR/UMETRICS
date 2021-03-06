################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

insert into rg_award
(
    Awardee,
    DoingBusinessAsName,
    PDPIName,
    PDPIPhone,
    PDPIEmail,
    CoPDsCoPIs,
    AwardDate,
    EstimatedTotalAwardAmount,
    FundsObligatedToDate,
    AwardStartDate,
    AwardExpirationDate,
    TransactionType,
    Agency,
    AwardingAgencyCode,
    FundingAgencyCode,
    CFDANumber,
    PrimaryProgramSource,
    AwardTitleOrDescription,
    FederalAwardIDNumber,
    DUNSID,
    ParentDUNSID,
    Program,
    ProgramOfficerName,
    ProgramOfficerPhone,
    ProgramOfficerEmail,
    AwardeeStreet,
    AwardeeCity,
    AwardeeState,
    AwardeeZIP,
    AwardeeCounty,
    AwardeeCountry,
    AwardeeCongressionalDistrict,
    PrimaryOrganizationName,
    PrimaryStreet,
    PrimaryCity,
    PrimaryState,
    PrimaryZIP,
    PrimaryCounty,
    PrimaryCountry,
    PrimaryCongressionalDistrict,
    AbstractAtTimeOfAward,
    PublicationsProducedAsAResultOfThisResearch,
    PublicationsProducedAsConferenceProceedings,
    ProjectOutcomesReport
) values (
     %(Awardee)s,
     %(DoingBusinessAsName)s,
     %(PDPIName)s,
     %(PDPIPhone)s,
     %(PDPIEmail)s,
     %(CoPDsCoPIs)s,
     str_to_date(replace(replace(nullif(%(AwardDate)s, ''), '=', ''), '"', ''), '%m/%d/%Y'),
     cast(replace(replace(replace(replace(nullif(%(EstimatedTotalAwardAmount)s, ''), '=', ''), '"', ''), '$', ''), ',', '') as decimal(13, 2)),
     cast(replace(replace(replace(replace(nullif(%(FundsObligatedToDate)s, ''), '=', ''), '"', ''), '$', ''), ',', '') as decimal(13, 2)),
     str_to_date(replace(replace(nullif(%(AwardStartDate)s, ''), '=', ''), '"', ''), '%m/%d/%Y'),
     str_to_date(replace(replace(nullif(%(AwardExpirationDate)s, ''), '=', ''), '"', ''), '%m/%d/%Y'),
     %(TransactionType)s,
     %(Agency)s,
     %(AwardingAgencyCode)s,
     %(FundingAgencyCode)s,
     %(CFDANumber)s,
     %(PrimaryProgramSource)s,
     %(AwardTitleOrDescription)s,
     %(FederalAwardIDNumber)s,
     %(DUNSID)s,
     %(ParentDUNSID)s,
     %(Program)s,
     %(ProgramOfficerName)s,
     %(ProgramOfficerPhone)s,
     %(ProgramOfficerEmail)s,
     %(AwardeeStreet)s,
     %(AwardeeCity)s,
     %(AwardeeState)s,
     %(AwardeeZIP)s,
     %(AwardeeCounty)s,
     %(AwardeeCountry)s,
     %(AwardeeCongDistrict)s,
     %(PrimaryOrganizationName)s,
     %(PrimaryStreet)s,
     %(PrimaryCity)s,
     %(PrimaryState)s,
     %(PrimaryZIP)s,
     %(PrimaryCounty)s,
     %(PrimaryCountry)s,
     %(PrimaryCongDistrict)s,
     %(AbstractAtTimeOfAward)s,
     %(PublicationsProducedAsAResultOfThisResearch)s,
     %(PublicationsProducedAsConferenceProceedings)s,
     %(ProjectOutcomesReport)s
)
