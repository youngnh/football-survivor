(require 'db)

(migration 26
  (up (exec-in-current-db (concat "delete from matchups where home_team='Houston Texans' and week=10;"
                                  "insert into matchups (away_team, home_team, week, kickoff) values ('Baltimore Ravens', 'Houston Texans', 10, '2008-11-09 13:00:00');")))
  (down (exec-in-current-db (concat "delete from matchups where home_team='Houston Texans' and week=10;"
                                    "insert into matchups (away_team, home_team, week, kickoff) values ('Cincinnati Bengals', 'Houston Texans', 10, '2008-11-09 13:00:00');"))))