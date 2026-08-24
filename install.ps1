# 把 zimage-portrait-light 装进 Claude Code 的个人 skills 目录（Windows）。
#
#   powershell -ExecutionPolicy Bypass -File install.ps1
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Project
#
# 重复执行是安全的：同名目录会先备份成 <name>.bak-<时间戳> 再覆盖。
param([switch]$Project)

$src = Join-Path $PSScriptRoot "skills"
if (-not (Test-Path $src)) { Write-Host "找不到 skills\ 目录，请在仓库根目录执行"; exit 1 }

if ($Project) {
  $dst = Join-Path (Get-Location) ".claude\skills"; $scope = "项目级"
} else {
  $dst = Join-Path $env:USERPROFILE ".claude\skills"; $scope = "个人级"
}
if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Force -Path $dst | Out-Null }

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$n = 0
foreach ($d in Get-ChildItem -Path $src -Directory) {
  if (-not (Test-Path (Join-Path $d.FullName "SKILL.md"))) { continue }
  $target = Join-Path $dst $d.Name
  if (Test-Path $target) {
    Move-Item -Path $target -Destination "$target.bak-$stamp"
    Write-Host "  已有同名，备份为 $($d.Name).bak-$stamp"
  }
  Copy-Item -Path $d.FullName -Destination $target -Recurse
  Write-Host "  装好 $($d.Name)"
  $n++
}

Write-Host ""
Write-Host "共 $n 个 skill -> $dst（$scope）"
Write-Host ""
Write-Host "现在跟 Claude Code 说一句「帮我写个逆光人像的提示词」就会触发。"
Write-Host "不用 Claude 也行：skills\zimage-portrait-light\SKILL.md 本身就是配方文档，"
Write-Host "十张成品和它们的完整提示词在 docs\配方全文.md。"
