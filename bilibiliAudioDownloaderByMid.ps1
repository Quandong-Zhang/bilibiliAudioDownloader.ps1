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
# SIG # Begin signature block
# MIIFlAYJKoZIhvcNAQcCoIIFhTCCBYECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHl/8DchtQqUGIVvaHI9lcuIw
# //CgggMiMIIDHjCCAgagAwIBAgIQdgzhhEXi3Z5FWoDOcuvXCDANBgkqhkiG9w0B
# AQsFADAnMSUwIwYDVQQDDBxQb3dlclNoZWxsIENvZGUgU2lnbmluZyBDZXJ0MB4X
# DTIyMDcwMTE2NDcwNVoXDTIzMDcwMTE3MDcwNVowJzElMCMGA1UEAwwcUG93ZXJT
# aGVsbCBDb2RlIFNpZ25pbmcgQ2VydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAKy3IGuf0WFSLG1EJ2YBkZYV6KiX4UMKyj32hU63ulRJnP83WMoLgAJ7
# 2a0uobRfNmLDQfL3A/c/cQGXrIC8cuJenFnJFSlVGIxLFhixirDn62heFiE0U0hh
# H3uqTR6iOa9vcfZRVngNHy/pJo5T5VjpZmtd2Fp2XVIM//FGtQNlEqwMbfpgieGK
# IhmdYPYKQe4u6y2+5oEvEkNuX7BYbA4J6E4OwEmAjNwRjmwXd3zqZoPF1efn/ny2
# JSInhxbXabkCZ2Qc7DdV4YWjksMVvDDQ9/ACMz2J+MisEVIVwEWu7TV07Y2EJqIx
# cboUqRycD89z1mePG9SlqE1tLl6yZPkCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBQk5X/TUYRCnqerfzcdAiF5
# eeDLyzANBgkqhkiG9w0BAQsFAAOCAQEAVrFAaJGjOR0eXBd+hz8Tn5KVdaFWuq9x
# P+k2afQnnePpkrhMOTeHWYi02DzjMdoKocPYZNxPZyFpJ2RYL5gq3or/gTjdmk/l
# 04ek2j1f2BHYHReR+yiWHKhNtE75vkgviIHHMVO1FI5M9d41RhIToZ081S50JdZd
# n/Y9cBi1+J2MRpi0OGvbh+wiHSaBG4XAXVf7nz8k7ZKHUyuSfXnT6QvCFyiLLoMz
# c5U9cxvYqeRA18iVyhj/xKOyDQKM6YDWbwesJXQz27IDcLR6ifTWnf5AUQd7gVzz
# qebZybxlvFl0Pru424xX5/EWv5GWv6O92iOziI+YYA6aIe3x/jmbqjGCAdwwggHY
# AgEBMDswJzElMCMGA1UEAwwcUG93ZXJTaGVsbCBDb2RlIFNpZ25pbmcgQ2VydAIQ
# dgzhhEXi3Z5FWoDOcuvXCDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUyFnUQ/pct/E5ZpZlnIH5
# WbdVAWIwDQYJKoZIhvcNAQEBBQAEggEAJYn5yrCoW/2H3wNIOG1IEy+PPzm2Xwbu
# Yk5GKkKcroGKml5CDdHA6AnxINqITzvLM0Y7mZEp2jgFpNw0CCfYAwazPfOeWHV+
# c7M2hvtT0UOC4xbL1HbJshu545L29Hze8ZaGR7KPfxGVctdS8CqLNhq1xQxMCZFu
# YETbENHzV5hSXd70b6EodCM1taRPBaJfHV81KmxhNFKHnF6SLXZutsZ0mpNyaEkM
# Cz42XXNDBPRFUzrV4/kYwZtCqs3NRlEP5nfDhGq7CFJnbV6xIO/RXko/ZUn8nFQU
# r3lB59DS3vJNS+/tg4WucKcwCnDXj7OzDPfrQs8ECYgyTvgG2dPpxg==
# SIG # End signature block
