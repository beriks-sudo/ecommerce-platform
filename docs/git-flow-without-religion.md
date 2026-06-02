main/master -> released history and tags
develop -> integration line for next release
feature/* -> task isolation before integration
release/* -> stabilization line for a named release
hotfix/* -> emergency fix from production line
tags -> exact released commits


feature/* -> develop -> release/1.4 -> main -> tag v1.4.0
                        |
                        +-> fixes return to develop


tag v1.4.0 -> hotfix/payment-timeout -> main -> tag v1.4.1
                                      \-> develop or next release/support line


team size: 1
release cadence: daily
rollback: cheap
CI: reliable
support: current version only
fit: GitHub Flow or trunk based is enough

- появилась внешняя QA-приемка
- release candidate должен стабилизироваться, пока future work идет дальше
- customers остаются на предыдущих версиях
- rollback дорогой или требует audit trail
- compliance требует evidence для production approvals

- 
- Risks of copying Git Flow blindly
- develop существует, но production deploy всегда идет из main после PR
- release/* живет месяцами и принимает новые features
- hotfix/* создается редко, а backport checklist отсутствует
- tags ставятся вручную без release notes и checks
- команда не может объяснить, какой риск снижает каждая линия