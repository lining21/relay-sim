$sourceRoot = 'C:\Users\FANFAN\.codex\visualizations\2026\10\27\01a17d2c-e0ea-7873-b45b-3d04d7a03eb5'
$pages = @(
    @{ File = 'current.html'; Source = 'relay-current-protection-sim.html'; Title = '三段式电流保护'; Module = '模块 01 · 电网电流保护' },
    @{ File = 'distance.html'; Source = 'distance-protection-mho-sim.html'; Title = '距离保护方向阻抗特性'; Module = '模块 02 · 电网距离保护' },
    @{ File = 'diff.html'; Source = 'transformer-diff-restraint-sim.html'; Title = '变压器纵差比率制动特性'; Module = '模块 03 · 变压器纵差保护' },
    @{ File = 'inrush.html'; Source = 'inrush-harmonic-sim.html'; Title = '励磁涌流与二次谐波制动'; Module = '模块 04 · 变压器励磁涌流' },
    @{ File = 'direction.html'; Source = 'directional-relay-90-sim.html'; Title = '功率方向元件与 90° 接线'; Module = '模块 05 · 方向电流保护' },
    @{ File = 'aar.html'; Source = 'aar-reclose-sim.html'; Title = '自动重合闸与加速配合'; Module = '模块 06 · 自动重合闸' },
    @{ File = 'fourier.html'; Source = 'fourier-window-sim.html'; Title = '傅氏算法与滑动数据窗'; Module = '模块 07 · 微机保护算法' }
)
$template = @'
<!doctype>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="theme-color" content="#08243f">
<title>{{TITLE}} · 电力系统继电保护原理虚拟仿真</title>
<style>
:root{--background:#f2f6fa;--foreground:#172b3f;--card:#fff;--card-foreground:#172b3f;--muted:#edf3f7;--muted-foreground:#587086;--primary:#1268b3;--primary-foreground:#fff;--border:#d9e4ed;--red:#c43b35;--green:#168566;--orange:#d37916;--accent:#e8f3fa;--accent-foreground:#172b3f;--viz-series-1:#1268b3;--viz-series-2:#e18a23;--viz-series-3:#168566;--viz-series-4:#8555b5;--viz-series-5:#d44b45;--viz-series-6:#168a9e}
*{box-sizing:border-box}
body{margin:0;padding:0 16px 42px;background:var(--background);color:var(--foreground);font-family:"Microsoft YaHei","PingFang SC",sans-serif;font-size:14px;line-height:1.65}
.lab-header{margin:0 -16px;background:linear-gradient(112deg,#071d35,#0a3556 65%,#0c526c);color:#fff;border-bottom:2px solid #20a9c4;box-shadow:0 4px 16px rgba(8,38,62,.14)}
.lab-header-inner{max-width:1080px;margin:auto;padding:15px 24px;display:flex;align-items:center;justify-content:space-between;gap:20px}
.lab-brand{display:flex;align-items:center;gap:11px}.lab-mark{width:37px;height:37px;display:grid;place-items:center;border:1px solid rgba(105,216,235,.45);border-radius:8px;color:#70d8e9;background:rgba(40,181,205,.09)}
.lab-brand b{display:block;font-size:15px;letter-spacing:.5px;font-weight:600}.lab-brand small{display:block;color:#92b6cb;font-size:9px;letter-spacing:1.6px;line-height:1.4}.lab-return{color:#d4e8f3;font-size:12px;text-decoration:none;border:1px solid rgba(180,215,230,.3);border-radius:6px;padding:5px 11px;white-space:nowrap;transition:.15s}.lab-return:hover{background:rgba(255,255,255,.1);border-color:#71d2e4}
.lab-subhead{max-width:1080px;margin:18px auto 0;padding:0 4px;display:flex;align-items:center;gap:9px;color:#58738a;font-size:12px}.lab-subhead:before{content:"";width:18px;height:2px;background:#18a9c7}.lab-subhead span{color:#1268b3;letter-spacing:.6px}
.wrap{max-width:1080px;margin:8px auto 0;background:var(--card);border:1px solid var(--border);border-radius:12px;padding:23px 28px 27px;box-shadow:0 7px 24px rgba(21,63,92,.06);position:relative;overflow:hidden}
.wrap:before{content:"";position:absolute;left:0;right:0;top:0;height:3px;background:linear-gradient(90deg,#1268b3,#18a9c7 45%,transparent 90%)}
h3{margin:3px 0 14px;font-size:20px;font-weight:600;line-height:1.45}.wrap>h3{padding-bottom:12px;border-bottom:1px solid var(--border);color:#103c60}
.text-small{font-size:12px}.text-muted{color:var(--muted-foreground)}.tabular-nums{font-variant-numeric:tabular-nums}.text-end{text-align:right}.text-nowrap{white-space:nowrap}
.table{width:100%;border-collapse:collapse;margin:5px 0 9px}.table-sm td,.table-sm th{padding:6px 9px;border-bottom:1px solid var(--border);text-align:left}.table-sm th{background:#f1f6fa;color:#35566e;font-weight:500}.table-sm tr:last-child td{border-bottom:0}.table-sm th.text-end,.table-sm td.text-end{text-align:right}
.form-range{width:100%;accent-color:var(--primary);cursor:pointer}.form-select{padding:6px 30px 6px 10px;border:1px solid #bdcedb;border-radius:6px;background:#fff;color:var(--foreground);font-family:inherit;font-size:14px;outline:none}.form-select:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(18,104,179,.12)}
.form-check{display:inline-flex;align-items:center;gap:5px;cursor:pointer}.form-check-input{accent-color:var(--primary);width:15px;height:15px;margin:0}
.btn{padding:7px 17px;border:1px solid #bdcedb;border-radius:6px;background:#fff;color:var(--foreground);cursor:pointer;font-family:inherit;font-size:14px;transition:background .15s,border-color .15s,box-shadow .15s}.btn:hover{background:#edf5fa;border-color:#7ba9c5}.btn-primary{background:var(--primary);color:var(--primary-foreground);border-color:var(--primary);box-shadow:0 2px 5px rgba(18,104,179,.16)}.btn-primary:hover{background:#0d599c;border-color:#0d599c}.btn:focus-visible{outline:3px solid rgba(24,169,199,.28);outline-offset:2px}.btn-primary:disabled{opacity:.55;cursor:default}
input[type="number"],input[type="text"]{border:1px solid #bdcedb;border-radius:5px;padding:5px 8px;color:var(--foreground);font-family:inherit}input[type="number"]:focus,input[type="text"]:focus{outline:2px solid rgba(18,104,179,.15);border-color:var(--primary)}
@media(max-width:640px){body{padding:0 8px 26px}.lab-header{margin:0 -8px}.lab-header-inner{padding:12px 14px}.lab-brand b{font-size:13px}.lab-brand small{font-size:8px;letter-spacing:1px}.lab-mark{width:32px;height:32px}.lab-return{padding:4px 8px}.wrap{padding:19px 15px 22px}.wrap>h3{font-size:18px}.lab-subhead{padding:0 7px}.table-sm td,.table-sm th{padding:5px}}
</style>
</head>
<body>
<header class="lab-header"><div class="lab-header-inner">
  <div class="lab-brand"><span class="lab-mark"><svg width="23" height="23" viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M13.2 2 5.8 13h5.6L10.8 22l7.4-11h-5.6L13.2 2Z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/></svg></span><span><b>电力系统继电保护原理 · 虚拟仿真实验</b><small>RELAY PROTECTION VIRTUAL LAB</small></span></div>
  <a class="lab-return" href="index.html">← 返回实验目录</a>
</div></header>
<div class="lab-subhead"><span>{{MODULE}}</span> / 交互实验台</div>
<main class="wrap">
'@
foreach ($page in $pages) {
    $fragment = Get-Content -Raw -Encoding UTF8 (Join-Path $sourceRoot $page.Source)
    $head = $template.Replace('{{TITLE}}', $page.Title).Replace('{{MODULE}}', $page.Module)
    $html = $head + $fragment + "`n</main>`n</body>`n</html>`n"
    Set-Content -LiteralPath (Join-Path $PSScriptRoot $page.File) -Value $html -Encoding UTF8 -NoNewline
}
Write-Output "Exported $($pages.Count) simulation modules."
