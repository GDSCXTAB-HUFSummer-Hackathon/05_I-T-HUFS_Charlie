/*
  Warnings:

  - The primary key for the `Mission` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `userId` on the `Mission` table. All the data in the column will be lost.
  - You are about to alter the column `id` on the `Mission` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Int`.
  - The primary key for the `UserMission` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to alter the column `MissionId` on the `UserMission` table. The data in that column could be lost. The data in that column will be cast from `VarChar(191)` to `Int`.

*/
-- DropForeignKey
ALTER TABLE `Mission` DROP FOREIGN KEY `Mission_userId_fkey`;

-- DropForeignKey
ALTER TABLE `UserMission` DROP FOREIGN KEY `UserMission_MissionId_fkey`;

-- AlterTable
ALTER TABLE `Mission` DROP PRIMARY KEY,
    DROP COLUMN `userId`,
    MODIFY `id` INTEGER NOT NULL AUTO_INCREMENT,
    ADD PRIMARY KEY (`id`);

-- AlterTable
ALTER TABLE `UserMission` DROP PRIMARY KEY,
    MODIFY `MissionId` INTEGER NOT NULL,
    ADD PRIMARY KEY (`userId`, `MissionId`);

-- AddForeignKey
ALTER TABLE `UserMission` ADD CONSTRAINT `UserMission_MissionId_fkey` FOREIGN KEY (`MissionId`) REFERENCES `Mission`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
