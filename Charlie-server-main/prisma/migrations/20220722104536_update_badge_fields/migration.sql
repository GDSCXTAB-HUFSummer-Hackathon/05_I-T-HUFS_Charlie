/*
  Warnings:

  - You are about to drop the column `name` on the `Badge` table. All the data in the column will be lost.
  - Added the required column `color` to the `Badge` table without a default value. This is not possible if the table is not empty.
  - Added the required column `steps` to the `Badge` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tier` to the `Badge` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Badge` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX `Badge_name_key` ON `Badge`;

-- AlterTable
ALTER TABLE `Badge` DROP COLUMN `name`,
    ADD COLUMN `color` VARCHAR(191) NOT NULL,
    ADD COLUMN `steps` INTEGER NOT NULL,
    ADD COLUMN `tier` INTEGER NOT NULL,
    ADD COLUMN `type` VARCHAR(191) NOT NULL;
