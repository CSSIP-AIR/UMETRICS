CREATE TABLE `coauthorname10recent` (
	`CoauthorName10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(200) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`CoauthorName10RecentId`),
	UNIQUE INDEX `CoauthorName10RecentId` (`CoauthorName10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
