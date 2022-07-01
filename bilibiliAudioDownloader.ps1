Param(
    [Parameter()]
    [String]$bvid
)
function Down-Video($link,$file_name){
    $header = New-Object System.Collections.Generic.Dictionary"[String,String]"
    $header["Referer"]="https://www.bilibili.com/"
    $header["Refer"]="https://www.bilibili.com/"
    $header["origin"]="https://www.bilibili.com"
    Invoke-WebRequest -Uri $link -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36" -OutFile $file_name -Headers $header
    }

function ReadJsonFile($jobj) {
        return ConvertFrom-Json -InputObject $jobj
}
if ($bvid -eq ""){
    $bvid=Read-Host "BVid Please"
    }
$link="https://api.bilibili.com/x/web-interface/view?bvid=$bvid"
$resp = ReadJsonFile (Invoke-WebRequest $link -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
$avid=$resp.data.aid
$bvid=$resp.data.bvid
$cidList=$resp.data.pages
$globeVideoTitle=$resp.data.title
$folderName="av$avid"
mkdir $folderName
foreach ($cidArry in $cidList) {
    $title=$cidArry.part
    if ($cidList.count -eq 1){
        $title=$globeVideoTitle
        }
    $cid=$cidArry.cid
    $vidapilink="https://api.bilibili.com/x/player/playurl?avid=$avid&cid=$cid&fnval=80"
    Write-Host $vidapilink
    $vurlresp = ReadJsonFile (Invoke-WebRequest $vidapilink -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
    $audiourl=$vurlresp.data.dash.audio[0].baseUrl
    Write-Host "Downloading" $title -ForegroundColor Green
    Down-Video $audiourl "./$folderName/$title.m4a"
    #$file_title=$title -replace '\s',''
    #ffmpeg -i "./resptmp.m4s" "./$title.mp3"
    #del "./resptmp.m4s"
    }