###############################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

import datetime
import mysql.connector

username ="[username]"
password="[password]"
database="UMETRICS"
host="[host]"


read_cnx = mysql.connector.connect(user=username, password=password, database=database, host=host)
read_cursor = read_cnx.cursor()
write_cnx = mysql.connector.connect(user=username, password=password, database=database, host=host)
write_cursor = write_cnx.cursor()

query_string = "select AUTHOR_LIST, PMID from ExPORTER.Publication;"
read_cursor.execute(query_string)
print(datetime.datetime.now())

num_rows_read = 0
print(datetime.datetime.now(), num_rows_read)

for (AuthorList, PMID) in read_cursor:
    if (AuthorList is not None) and (PMID is not None):
        split_list = AuthorList.split(";")
        for author_name in split_list:
            author_name = author_name.strip()
            if author_name != "":
                query_string = "insert into EXPPublicationAuthorListTemp (AuthorName, PMID) values (%s, %s);"
                write_cursor.execute(query_string, (author_name, PMID))

    num_rows_read += 1
    if divmod(num_rows_read, 10000)[1] == 0:
        write_cnx.commit()
        print(datetime.datetime.now(), num_rows_read)

write_cnx.commit()
write_cursor.close()
write_cnx.close()
read_cursor.close()
read_cnx.close()

