CREATE TABLE `titleword10recent` (
	`TitleWord10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(100) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`TitleWord10RecentID`),
	UNIQUE INDEX `TitleWord10RecentID` (`TitleWord10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;