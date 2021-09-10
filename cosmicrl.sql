-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 10, 2021 at 09:19 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cosmicrl`
--

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `ID` int(11) NOT NULL,
  `Items` text NOT NULL,
  `Weapons` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `player`
--

CREATE TABLE `player` (
  `ID` int(11) NOT NULL,
  `Username` text NOT NULL,
  `Password` text NOT NULL,
  `IP` text NOT NULL,
  `Serial` text NOT NULL,
  `Registerdate` varchar(18) NOT NULL,
  `Birthday` varchar(18) NOT NULL,
  `LastLogin` varchar(18) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `player`
--

INSERT INTO `player` (`ID`, `Username`, `Password`, `IP`, `Serial`, `Registerdate`, `Birthday`, `LastLogin`) VALUES
(1, 'Username', 'ce73e37b12f2a0cc93ff4cdc9540f91d2ec93ac9568658fb9ff7e50cccb2e418', '192.168.0.73', '71A8DF073C36AEB2B0849AD6B36E0602', '09.09.2021', '27.06.2002', '10.09.2021');

-- --------------------------------------------------------

--
-- Table structure for table `playerdata`
--

CREATE TABLE `playerdata` (
  `ID` int(11) NOT NULL,
  `Adminlevel` int(2) NOT NULL,
  `Spawn` int(2) NOT NULL,
  `Money` int(11) NOT NULL,
  `Bankmoney` int(11) NOT NULL,
  `Skin` int(4) NOT NULL,
  `Playtime` int(11) NOT NULL,
  `Payday` int(11) NOT NULL,
  `FactionID` int(2) NOT NULL,
  `FactionRank` int(2) NOT NULL,
  `GroupID` int(2) NOT NULL,
  `GroupRank` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `playerdata`
--

INSERT INTO `playerdata` (`ID`, `Adminlevel`, `Spawn`, `Money`, `Bankmoney`, `Skin`, `Playtime`, `Payday`, `FactionID`, `FactionRank`, `GroupID`, `GroupRank`) VALUES
(1, 0, 0, 950, 300, 29, 129, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle`
--

CREATE TABLE `vehicle` (
  `ID` int(11) NOT NULL,
  `OwnerID` int(11) NOT NULL,
  `Slot` int(2) NOT NULL,
  `Model` int(4) NOT NULL,
  `Spawn` text NOT NULL,
  `Color` text NOT NULL,
  `Lightcolor` text NOT NULL,
  `Plate` varchar(8) NOT NULL,
  `Upgrades` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `playerdata`
--
ALTER TABLE `playerdata`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
