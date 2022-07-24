/*
  Warnings:

  - You are about to drop the column `body` on the `Charlie` table. All the data in the column will be lost.
  - You are about to drop the column `face` on the `Charlie` table. All the data in the column will be lost.
  - You are about to alter the column `type` on the `Charliedecoration` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Enum("Charliedecoration_type")`.
  - You are about to alter the column `type` on the `Decoration` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Enum("Decoration_type")`.
  - Added the required column `bodyIndex` to the `Charlie` table without a default value. This is not possible if the table is not empty.
  - Added the required column `faceIndex` to the `Charlie` table without a default value. This is not possible if the table is not empty.
  - Added the required column `decorationIndex` to the `Decoration` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `Decoration` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `Charlie` DROP COLUMN `body`,
    DROP COLUMN `face`,
    ADD COLUMN `bodyIndex` INTEGER NOT NULL,
    ADD COLUMN `faceIndex` INTEGER NOT NULL;

-- AlterTable
ALTER TABLE `Charliedecoration` MODIFY `type` ENUM('headwear', 'other') NOT NULL,
    MODIFY `wearing` BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE `Decoration` ADD COLUMN `decorationIndex` INTEGER NOT NULL,
    ADD COLUMN `name` VARCHAR(191) NOT NULL,
    MODIFY `type` ENUM('headwear', 'other') NOT NULL;

-- CreateTable
CREATE TABLE `Mission` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `startDate` DATETIME(3) NOT NULL,
    `endDate` DATETIME(3) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `Mission_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `UserMission` (
    `userId` VARCHAR(191) NOT NULL,
    `MissionId` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`userId`, `MissionId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Mission` ADD CONSTRAINT `Mission_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserMission` ADD CONSTRAINT `UserMission_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserMission` ADD CONSTRAINT `UserMission_MissionId_fkey` FOREIGN KEY (`MissionId`) REFERENCES `Mission`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
