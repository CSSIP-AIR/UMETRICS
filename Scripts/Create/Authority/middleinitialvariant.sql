CREATE TABLE `middleinitialvariant` (
	`MiddleInitialVariantID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (MiddleInitialVariantID),
	UNIQUE INDEX `MiddleInitialVariantID` (`MiddleInitialVariantID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;