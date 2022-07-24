/*
  Warnings:

  - The values [overWeight] on the enum `Log_level` will be removed. If these variants are still used in the database, this will fail.
  - Added the required column `steps` to the `Log` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `Log` ADD COLUMN `steps` INTEGER NOT NULL,
    MODIFY `level` ENUM('veryObese', 'obese', 'overweight', 'healthy', 'veryHealthy') NOT NULL;
