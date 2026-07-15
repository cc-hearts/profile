# Git 合并常用命令速查

## 基础合并

```bash
git merge <branch>          # 把 <branch> 合并到当前分支
git merge --no-ff <branch>  # 强制生成 merge commit（保留分支历史）
git merge --ff-only <branch># 仅允许快进合并，否则失败
git merge --squash <branch> # 把 <branch> 的多个 commit 压成一条，不生成 commit（需手动 commit）
```

## 合并冲突处理

```bash
git merge --abort           # 放弃本次合并，回到合并前状态
git merge --continue        # 解决冲突后继续完成合并
git checkout --ours <file>  # 冲突文件保留当前分支版本
git checkout --theirs <file># 冲突文件保留对方分支版本
git checkout --merge <file> # 重新还原冲突标记
git mergetool               # 启动可视化合并工具
git status                  # 查看冲突文件
git add <file>              # 标记冲突已解决，准备提交
```

## 撤销合并

```bash
git reset --hard HEAD~1       # 合并后丢弃最后一个 commit（未 push 时）
git revert -m 1 <merge-commit># 用新 commit 撤销已 push 的 merge commit
```

## 查看合并状态

```bash
git log --oneline --graph      # 图形化查看合并历史
git branch --merged            # 查看已合并到当前分支的分支
git branch --no-merged         # 查看未合并的分支
```

## 变基（Rebase，合并的替代方案）

```bash
git rebase <branch>          # 把当前分支的 commit 重新接到 <branch> 末尾
git rebase --abort           # 放弃 rebase
git rebase --continue        # 解决冲突后继续
git rebase -i HEAD~3         # 交互式修改最近 3 个 commit
```

## Cherry-pick（挑选单个 commit 合并）

```bash
git cherry-pick <commit>     # 把指定 commit 应用到当前分支
git cherry-pick <c1>..<c2>   # 应用区间内的 commit（不含 c1）
git cherry-pick --abort      # 放弃
git cherry-pick --continue   # 解决冲突后继续
```

## 常用流程速记

```bash
# 标准合并流程
git checkout main && git pull
git merge feature
# 有冲突 → 改文件 → git add → git merge --continue

# squash 合并流程
git merge --squash feature
git commit -m "merge: feature 分支"

# 同步上游
git fetch origin
git merge origin/main
```
