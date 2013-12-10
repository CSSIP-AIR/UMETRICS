CREATE TABLE `grantid10recent` (
	`GrantID10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(50) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`GrantID10RecentID`),
	UNIQUE INDEX `GrantID10RecentID` (`GrantID10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;