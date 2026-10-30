$root = 'D:\study\PHM\GPT\relay-sim'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8722/')
$listener.Start()
while($listener.IsListening){
  try{
    $ctx = $listener.GetContext()
    $path = $ctx.Request.Url.LocalPath.TrimStart('/')
    if([string]::IsNullOrEmpty($path)){ $path = 'index.html' }
    $file = Join-Path $root $path
    if((Test-Path $file -PathType Leaf) -and ((Resolve-Path $file).Path.StartsWith($root))){
      $bytes = [System.IO.File]::ReadAllBytes($file)
      $ctx.Response.ContentType = 'text/html; charset=utf-8'
      $ctx.Response.OutputStream.Write($bytes,0,$bytes.Length)
    } else { $ctx.Response.StatusCode = 404 }
    $ctx.Response.Close()
  }catch{}
}
