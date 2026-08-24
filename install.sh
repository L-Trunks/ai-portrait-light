#!/usr/bin/env bash
# 把 ai-portrait-light 装进 Claude Code 的 skills 目录。
#
#   bash install.sh              装到 ~/.claude/skills/（个人级，所有项目可用）
#   bash install.sh --project    装到 ./.claude/skills/（只对当前项目可用）
#
# 重复执行是安全的：同名目录会先备份成 <name>.bak-<时间戳> 再覆盖。
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
DST="$HOME/.claude/skills"
SCOPE="个人级"
if [ "${1:-}" = "--project" ]; then
  DST="$(pwd)/.claude/skills"
  SCOPE="项目级"
fi

[ -d "$SRC" ] || { echo "找不到 skills/ 目录，请在仓库根目录执行"; exit 1; }
mkdir -p "$DST"

stamp=$(date +%Y%m%d-%H%M%S)
n=0
for d in "$SRC"/*/; do
  name=$(basename "$d")
  [ -f "$d/SKILL.md" ] || continue
  if [ -e "$DST/$name" ]; then
    mv "$DST/$name" "$DST/$name.bak-$stamp"
    echo "  已有同名，备份为 $name.bak-$stamp"
  fi
  cp -r "$d" "$DST/$name"
  echo "  装好 $name"
  n=$((n+1))
done

echo
echo "共 $n 个 skill -> $DST（$SCOPE）"
echo
echo "现在跟 Claude Code 说一句「帮我写个逆光人像的提示词」就会触发。"
echo "不用 Claude 也行：skills/portrait-light/SKILL.md 本身就是配方文档，"
echo "十张成品和它们的完整提示词在 docs/配方全文.md。"
