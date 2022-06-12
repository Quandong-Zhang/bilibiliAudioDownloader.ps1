function Down-Video($link,$file_name){
    $header = New-Object System.Collections.Generic.Dictionary"[String,String]"
    $header["Referer"]="https://www.bilibili.com/"
    $header["Refer"]="https://www.bilibili.com/"
    $header["origin"]="https://www.bilibili.com"
    Invoke-WebRequest -Uri $link -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36" -OutFile $file_name -Headers $header
    }

function ReadJsonFile($jobj) {
        return ConvertFrom-Json -InputObject $jobj #是jobj，不是jb!!!
}

function DownloadFromBVid($bvid) {
$link="https://api.bilibili.com/x/web-interface/view?bvid="+$bvid
$resp = ReadJsonFile (Invoke-WebRequest $link -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
$avid=$resp.data.aid
$bvid=$resp.data.bvid
$cidList=$resp.data.pages#
#foreach ($cidArry in $cidList) {
    $cidArry=$cidList[0]
    $title=$cidArry.part
    #if ($cidList.count -eq 1){
    #    $title=$resp.data.title
    #}
    $cid=$cidArry.cid
    #$imgurl=cidArry.first_frame
    $vidapilink="https://api.bilibili.com/x/player/playurl?avid=$avid&cid=$cid&fnval=80"
    $vurlresp = ReadJsonFile (Invoke-WebRequest $vidapilink -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
    $audiourl=$vurlresp.data.dash.audio[-1].baseUrl
    #Down-Video $imgurl "./$title.jpg"
    Write-Host "Downloading" $title -ForegroundColor Green
    Down-Video $audiourl "./resptmp.m4s"
    #$file_title=$title -replace '\s','' #啊对对对
    #if ($title -eq ""){
    #    $title=$resp.data.title
    #}
    $title=$resp.data.title
    ffmpeg -i "./resptmp.m4s" "./$title.mp3" #所以说需要ffmpeg鸭
    del "./resptmp.m4s"
#    }
    }

function downFromPn($pn){
$authorURL="https://api.bilibili.com/x/space/arc/search?mid=$memberid&pn=$pn&order=click&jsonp=jsonp&ps=50"
$vidListString=ReadJsonFile (Invoke-WebRequest $authorURL -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
$vList=$vidListString.data.list.vlist
foreach ($vArry in $vList) {#鬼知道我起变量名时咋想的...不管了毁灭吧
    $bvid=$vArry.bvid
    $aid=$vArry.aid
    $author=$vArry.author
    Write-Host "BVID is " $bvid "and aID is" $aid
    Write-Host "start to download " $author "'s videos list"
    DownloadFromBVid $bvid #走你~~~~~~~
    }
    }

#$memberid="3379951"#这是我测试时为方便写死的mid,你猜猜是谁的（doge）
$memberid =Read-Host "memberID Please"
$pn=1
while ($true){#舅下到出错为止吧，管他呢~~~（反正出错不就代表没有啦嘛~~~~）
    downFromPn $pn
    $pn+=1 
    #Start-Sleep -Seconds 601 #服务器专用防被banIP，如果莫名被ban可以试试这个。
}
#while($pn -le 5) #什么终止条件，怪麻烦的，都是贵物...
#{ 
# downFromPn $pn
# $pn +=1 
#}