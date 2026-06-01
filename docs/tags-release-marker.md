Tag в Git - это имя, которое указывает на конкретный object, чаще всего на commit. Для release обычно используют имя вроде v1.5.0. В отличие от branch, tag не должен двигаться в обычной работе. Branch показывает линию развития, tag показывает точку выпуска. Поэтому release flow из Module 05 выглядит так: candidate проверен, release decision принят, commit в production line определен, tag поставлен, artifact построен из tagged commit или связан с ним.

Lightweight tag - это просто ref на commit. Annotated tag - отдельный tag object с metadata и message, который указывает на commit. Для release лучше annotated tag, потому что он несет release note уровня marker: кто создал tag, когда и с каким описанием. Это не заменяет CHANGELOG.md, но помогает истории быть самодокументируемой. В некоторых командах release tags еще подписывают GPG или SSH signing, чтобы усилить trust.

berik@MacBook-Pro-berik docs % git show --no-patch v1.5.0
tag v1.5.0
Tagger: berik <berik@MacBook-Pro-berik.local>
Date:   Mon Jun 1 18:13:18 2026 +0500

Release v1.5.0

commit b45429fa4b5a384523081fc6562cf0f82e7cf76b (HEAD -> homework-v3-07-04-tags-release-marker, tag: v1.5.0, origin/homework-v3-07-03-semver-release-impact, homework-v3-07-03-semver-release-impact)
Author: berik <berik@MacBook-Pro-berik.local>
Date:   Mon Jun 1 17:27:05 2026 +0500

    docs(homework) add semver md

berik@MacBook-Pro-berik docs % git tag --list
v1.5.0

git tag --list, git show v1.5.0, git log v1.4.0..v1.5.0 --oneline

не пушить tags без release decision; не использовать git push --tags без явной причины.
