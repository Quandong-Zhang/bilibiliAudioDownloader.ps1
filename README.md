# bilibiliAudioDownloader.ps1
基于power shell的b站视频音轨下载器（支持多P）。对被压制成视频的ost之类的音乐专辑有奇效（doge）
## 好处
1.无需安装环境，是个Windows系统的机器都能跑 </br>
2.有助于戒掉编程(终于没有理由不卸载python了），专心学习233333
## 使用
bilibiliAudioDownloader.ps1是根据bvid（bv号）下载一个视频所有P的音轨 </br>
bilibiliAudioDownloaderByMid.ps1是根据mid下载一个up所有视频的音轨（如有分P，则只下载P1的音轨） </br>
例如:
```shell
bilibiliAudioDownloader.ps1 BV1cY41177SS
```
或者直接双击run.cmd之后输入bv号
<h3>注：普通Windows系统需要先更改组策略允许运行power shell脚本，Windows sever应该是默认允许运行脚本的。</h3></br>
用管理员权限打开power shell，然后输入 
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 
<h2>P.S.power shell的速度实在太香了吧，甩python的you-get几十条街。</h2>
