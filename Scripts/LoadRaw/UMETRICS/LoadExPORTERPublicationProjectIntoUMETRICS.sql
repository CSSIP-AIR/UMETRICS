################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

################################################################################
# Using the ExPORTER.PublicationProject table, create 'cited' relationships between
# Publications and Grant Awards.
#
# This script assumes that the GrantAward records have already been created and
# that the Publication records have already been created. So this will connect
# the two up by looking for the GrantAward with the NIH_CORE_PROJECT_NUM attribute
# and the Publication with the PMID attribute.
################################################################################

insert ignore into PublicationGrantAward (PublicationId, GrantAwardId, RelationshipCode)
	select pa.PublicationId, gaa.GrantAwardId, 'CITED'
		from ExPORTER.PublicationProject epp
			inner join Attribute a1 on a1.Attribute=epp.CORE_PROJECT_NUM
			inner join GrantAwardAttribute gaa on gaa.AttributeId=a1.AttributeId and gaa.RelationshipCode='NIH_CORE_PROJECT_NUM'
			inner join Attribute a2 on a2.Attribute=cast(epp.PMID as char(100))
			inner join PublicationAttribute pa on pa.AttributeId=a2.AttributeId and pa.RelationshipCode='PMID';
