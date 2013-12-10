CREATE TABLE `block` (
	`BlockID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(100) NOT NULL,
	`PositionInBlock` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`BlockID`),
	UNIQUE INDEX `BlockID` (`BlockID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;