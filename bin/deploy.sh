#!/usr/bin/env bash

# 确保脚本抛出遇到的错误
set -e

# 生成静态文件
yarn run build

# 进入生成的文件夹
cd .vuepress/dist

# 如果是发布到自定义域名
echo 'baizhiheizi.com' > CNAME

if [[ ${GIHUB_TOKEN} ]]; then
  # for Github actions
  remote_repo="https://${GITHUB_ACTOR}:${GIHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" && \
  git init && \
  git config user.name "${GITHUB_ACTOR}" && \
  git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
  git add . && \
  git commit -m "vuepress build from Action ${GITHUB_SHA}" && \
  git show-ref && \
  git push --force $remote_repo master:master
else
  # for local deploy
  git init
  git add -A
  git commit -m 'vuepress build from local'
  git push -f git@github.com:baizhiheizi/baizhiheizi.com.git master:master
fi

rm -fr .git
cd -
