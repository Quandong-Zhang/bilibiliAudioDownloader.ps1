function Down-Video($link,$file_name){
    #$link = "https://upos-sz-mirrorcoso1.bilivideo.com/upgcxcode/92/96/732449692/732449692_nb2-1-30280.m4s?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M=&uipk=5&nbs=1&deadline=1654619872&gen=playurlv2&os=coso1bv&oi=0&trid=3bf23bbc4e7e4d89b07fb690ac4da478u&mid=499106648&platform=pc&upsig=990a0ca237e1c0eb4319bd6209727714&uparams=e,uipk,nbs,deadline,gen,os,oi,trid,mid,platform&bvc=vod&nettype=0&orderid=0,2&agrr=1&bw=16669&logo=80000000"
    #$file_name = "D:/pathspace/doc/a.m4s"
    $header = New-Object System.Collections.Generic.Dictionary"[String,String]"
    $header["Referer"]="https://www.bilibili.com/"
    $header["Refer"]="https://www.bilibili.com/"
    $header["origin"]="https://www.bilibili.com"
    #Write-Host "Headers" $header -ForegroundColor Green
    Invoke-WebRequest -Uri $link -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36" -OutFile $file_name -Headers $header
    #Invoke-WebRequest -Uri $link -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox -Headers $header
    }

function ReadJsonFile($jobj) {
        #$content = ReadFile $path
        return ConvertFrom-Json -InputObject $jobj
}
#$folder=Read-Host "folder please"
#cd $folder
$bvid=Read-Host "BVid Please"
$link="https://api.bilibili.com/x/web-interface/view?bvid="+$bvid
$resp = ReadJsonFile (Invoke-WebRequest $link -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
#Write-Host $resp.data
$avid=$resp.data.aid
$bvid=$resp.data.bvid
$cidList=$resp.data.pages#
foreach ($cidArry in $cidList) {
    #cidArry=$cidList[i]
    $title=$cidArry.part
    #if ($cidList.count -eq 1){
    #    $title=$resp.data.title
    #}
    $cid=$cidArry.cid
    #$imgurl=cidArry.first_frame
    $vidapilink="https://api.bilibili.com/x/player/playurl?avid=$avid&cid=$cid&fnval=80"
    Write-Host $vidapilink
    $vurlresp = ReadJsonFile (Invoke-WebRequest $vidapilink -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
    $audiourl=$vurlresp.data.dash.audio[0].baseUrl
    #$url=Read-Host "Enter the URL of the file you want to download"
    #Down-Video $imgurl "./$title.jpg"
    Write-Host "Downloading" $title -ForegroundColor Green
    Down-Video $audiourl "./resptmp.m4s"
    #$file_title=$title -replace '\s',''
    ffmpeg -i "./resptmp.m4s" "./$title.mp3"
    del "./resptmp.m4s"
    }