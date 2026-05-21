local repository видишь только ты, пока ты не запушил его команда не сможет с ним работать и remote repository это уже удаленный репозиторий к которому может подключится команда, отправлять свои правки, создавать свои ветки также и ты можешь пользоваться актуальными данными .
Что такое origin (это самое путаное место)
 origin — это просто имя-сокращение для URL. Всё. Не команда, не ветка, не «тот самый GitHub».
 Представь, что у тебя в телефоне записан контакт «Мама» → +7 999 .... Ты звонишь «Маме», а телефон под капотом набирает реальный номер. «Мама» — это короткое имя для номера.
 git remote -v
    origin  git@github.com:beriks-sudo/ecommerce-platform.git (fetch)
   origin  git@github.com:beriks-sudo/ecommerce-platform.git (push)
local repository -> origin -> remote repository

Что проверить перед push make check, git status --short, git remote -v.

Добавь короткое объяснение, почему git remote add origin ... еще не отправляет код на GitHub. 
чтобы отправить код на github требуется его закомитить и потом воспользоваться командой git push
