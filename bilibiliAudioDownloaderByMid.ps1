function Down-Video($link,$file_name){
    $header = New-Object System.Collections.Generic.Dictionary"[String,String]"
    $header["Referer"]="https://www.bilibili.com/"
    $header["Refer"]="https://www.bilibili.com/"
    $header["origin"]="https://www.bilibili.com"
    Invoke-WebRequest -Uri $link -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36" -OutFile $file_name -Headers $header
    }

function ReadJsonFile($jobj) {
        return ConvertFrom-Json -InputObject $jobj #��jobj������jb!!!
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
    #$file_title=$title -replace '\s','' #���ԶԶ�
    #if ($title -eq ""){
    #    $title=$resp.data.title
    #}
    $title=$resp.data.title
    ffmpeg -i "./resptmp.m4s" "./$title.mp3" #����˵��ҪffmpegѼ
    del "./resptmp.m4s"
#    }
    }

function downFromPn($pn){
$authorURL="https://api.bilibili.com/x/space/arc/search?mid=$memberid&pn=$pn&order=click&jsonp=jsonp&ps=50"
$vidListString=ReadJsonFile (Invoke-WebRequest $authorURL -MaximumRedirection 0 -ErrorAction Ignore -UseBasicParsing).Content
$vList=$vidListString.data.list.vlist
foreach ($vArry in $vList) {#��֪�����������ʱզ���...�����˻����
    $bvid=$vArry.bvid
    $aid=$vArry.aid
    $author=$vArry.author
    Write-Host "BVID is " $bvid "and aID is" $aid
    Write-Host "start to download " $author "'s videos list"
    DownloadFromBVid $bvid #����~~~~~~~
    }
    }

#$memberid="3379951"#�����Ҳ���ʱΪ����д����mid,��²���˭�ģ�doge��
$memberid =Read-Host "memberID Please"
$pn=1
while ($true){#���µ�����Ϊֹ�ɣ�������~~~�����������ʹ���û������~~~~��
    downFromPn $pn
    $pn+=1 
    #Start-Sleep -Seconds 601 #������ר�÷���banIP�����Ī����ban�������������
}
#while($pn -le 5) #ʲô��ֹ���������鷳�ģ����ǹ���...
#{ 
# downFromPn $pn
# $pn +=1 
#}