ATFTool
=======

已经整合到[StarlingSwf](http://zmliu.github.io/2013/11/09/StarlingSwfTool/)中，该库不再更新。请移步[StarlingSwf](http://zmliu.github.io/2013/11/09/StarlingSwfTool/)

批量导出Atf的工具，使用是adobe atf 编码核心

####先说一下关于atf的bug
	当atf导出时候 启用了mips选项 会导致：
	如果纹理问长方形时 上传会报错的bug
	解决方法是把纹理改成正方形

####来张截图
<img src="/assets/images/atftool_view.jpg" alt="截图" class="img-rounded">

####功能说明
	输出平台选择
	压缩体积，减小文件大小
	mipmap设置
	支持jpg png 转换
	图像尺寸自动纠正为2幂
	图像自动转换为方形,解决atf上传时 为长方形会报错的bug 仅在使用mips会触发 所以需要启用mips可以考虑勾选这个选项
	目录转换（包含子目录）
	输出质量设置
