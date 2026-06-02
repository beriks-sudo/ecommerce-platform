- direct commits to protected line
- long-lived feature branches without integration
- broken CI ignored
- release branch as second develop
- hotfix not backported
- environment branch confusion
- no rollback plan
- branch naming without rules
  Days 1-7:
- document current flow
- list protected lines and real bypasses
- add make check to PR checklist
- require CI on main if checks are stable enough

Days 8-20:
- protect release/*
- define release owner and allowed changes
- add hotfix backport checklist
- record deployed SHA for staging and production

Days 21-30:
- measure branch lifetime
- split the largest active PRs
- remove unused branch prefixes
- update onboarding docs and repository settings


What not to do:
New rule: no branches older than 2 days.
No feature flags.
No test stabilization.
No review capacity.
No plan for existing large branches.


How to verify improvement:
Goal: reduce late integration risk.
Step 1: measure active branch age.
Step 2: split new work into smaller PRs.
Step 3: add feature flags for unfinished behavior.
Step 4: set expected branch lifetime after team can comply.
Signal: median branch age decreases and PR size becomes reviewable.