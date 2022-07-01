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
# SIG # Begin signature block
# MIIFlAYJKoZIhvcNAQcCoIIFhTCCBYECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2bHs6ylM1bhhiXUDcMYMkBLK
# frOgggMiMIIDHjCCAgagAwIBAgIQdgzhhEXi3Z5FWoDOcuvXCDANBgkqhkiG9w0B
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
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU2PC3YGOE3ycuhZ7OFKGo
# u+Mc+sYwDQYJKoZIhvcNAQEBBQAEggEAlvhDyWNY3eOana+4VmmRP0so7DHfgN3Q
# RA3+EWypRsoxln+fyfZXD80L8R+kUKcvrl9qeRsVapuXOtSoqSmqCEEoynjPXcFK
# EhqIn7YjOzSFreEbaNDU3W6r513jPi5IU1pmX0HizNKmjxFzT/0mbzLA3mO7SaZX
# r73NGVwAbCWjYDlqxThVgRhsEcZ/Pi+34ocDIVsSpEqSYqweItu/VG3+yoDIzGzs
# /QQDJ0bG94bWCEDblVO5lKhBXNX6pU95P7mOwAFODqe3vuTfHs7YLZV8QyzJWmcC
# kUQ0wBlVoeXXyy+ONIqdcfzH8lUU37TGmo1+1Ads+1j8XmxNRxLazQ==
# SIG # End signature block
