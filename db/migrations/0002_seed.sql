-- Forward-only migration 0002: reference data so a new environment is not empty.
-- Re-runnable: each row is inserted only when its title is absent.
INSERT INTO reporting (title, reference, status, priority)
SELECT 'Sample Reporting 1', 'R-0001', 'new', 'low'
WHERE NOT EXISTS (SELECT 1 FROM reporting WHERE title = 'Sample Reporting 1');
INSERT INTO reporting (title, reference, status, priority)
SELECT 'Sample Reporting 2', 'R-0002', 'in-progress', 'normal'
WHERE NOT EXISTS (SELECT 1 FROM reporting WHERE title = 'Sample Reporting 2');
INSERT INTO reporting (title, reference, status, priority)
SELECT 'Sample Reporting 3', 'R-0003', 'complete', 'high'
WHERE NOT EXISTS (SELECT 1 FROM reporting WHERE title = 'Sample Reporting 3');
INSERT INTO reporting (title, reference, status, priority)
SELECT 'Sample Reporting 4', 'R-0004', 'new', 'low'
WHERE NOT EXISTS (SELECT 1 FROM reporting WHERE title = 'Sample Reporting 4');
