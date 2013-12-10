# Load Program.
load data local infile
	'D:\\Raw Data\\Authority\\SplitFiles\\blocks.txt' ignore
into table
	block
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
(
	@RawID,
	@Position,
	@Name,
	@PositionInBlock
)
set
	RawID = cast(nullif(@RawID, '') as unsigned int),
	Position = cast(nullif(@Position, '') as unsigned int),
	Name = nullif(@Name, ''),
	PositionInBlock = cast(nullif(@PositionInBlock, '') as unsigned int)