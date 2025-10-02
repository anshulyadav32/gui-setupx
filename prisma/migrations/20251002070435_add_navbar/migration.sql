-- CreateTable
CREATE TABLE "navbars" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_navigation_items" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "icon" TEXT,
    "route" TEXT,
    "order" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "category" TEXT,
    "navbarId" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "navigation_items_navbarId_fkey" FOREIGN KEY ("navbarId") REFERENCES "navbars" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_navigation_items" ("createdAt", "icon", "id", "isActive", "name", "order", "route", "updatedAt") SELECT "createdAt", "icon", "id", "isActive", "name", "order", "route", "updatedAt" FROM "navigation_items";
DROP TABLE "navigation_items";
ALTER TABLE "new_navigation_items" RENAME TO "navigation_items";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE UNIQUE INDEX "navbars_name_key" ON "navbars"("name");
