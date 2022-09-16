
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_basic_library/flutter_basic_library.dart';
import 'package:flutter_basic_library/utils/size_extension.dart';
/**
  * by zjh
  * 2022/9/7  14:04
 * 支持本地资源 网络资源 同时支持svg的类型 file类型的文件
  */
class ImageLoadWidget extends StatelessWidget{

  String? imgUrl;///支持本地资源 网络资源 同时支持svg的类型
  double? width;
  double? height;
  Alignment? alignment;
  String? placeholder;
  String? erroUrl;
  bool isFile;

  /**
   * color和colorBlendMode用于将颜色和图片进行颜色混合，colorBlendMode表示混合模式，下面介绍的混合模式比较多，浏览一遍即可，此属性可以用于简单的滤镜效果。

      clear：清楚源图像和目标图像。
      color：获取源图像的色相和饱和度以及目标图像的光度。
      colorBurn：将目标的倒数除以源，然后将结果倒数。
      colorDodge：将目标除以源的倒数。
      darken：通过从每个颜色通道中选择最小值来合成源图像和目标图像。
      difference：从每个通道的较大值中减去较小的值。合成黑色没有效果。合成白色会使另一张图像的颜色反转。
      dst：仅绘制目标图像。
      dstATop：将目标图像合成到源图像上，但仅在与源图像重叠的位置合成。
      dstIn：显示目标图像，但仅显示两个图像重叠的位置。不渲染源图像，仅将其视为蒙版。源的颜色通道将被忽略，只有不透明度才起作用。
      dstOut：显示目标图像，但仅显示两个图像不重叠的位置。不渲染源图像，仅将其视为蒙版。源的颜色通道将被忽略，只有不透明度才起作用。
      dstOver：将源图像合成到目标图像下。
      exclusion：从两个图像的总和中减去两个图像的乘积的两倍。
      hardLight：调整源图像和目标图像的成分以使其适合源图像之后，将它们相乘。
      hue：获取源图像的色相，以及目标图像的饱和度和光度。
      lighten：通过从每个颜色通道中选择最大值来合成源图像和目标图像。
      luminosity：获取源图像的亮度，以及目标图像的色相和饱和度。
      modulate：将源图像和目标图像的颜色分量相乘。
      multiply：将源图像和目标图像的分量相乘，包括alpha通道。
      overlay：调整源图像和目标图像的分量以使其适合目标后，将它们相乘。
      plus：对源图像和目标图像的组成部分求和。
      saturation：获取源图像的饱和度以及目标图像的色相和亮度。
      screen：将源图像和目标图像的分量的逆值相乘，然后对结果求逆。
      softLight：对于低于0.5的源值使用colorDodge，对于高于0.5的源值使用colorBurn。
      src：放置目标图像，仅绘制源图像。
      srcATop：将源图像合成到目标图像上，但仅在与目标图像重叠的位置合成。
      srcIn：显示源图像，但仅显示两个图像重叠的位置。目标图像未渲染，仅被视为蒙版。目标的颜色通道将被忽略，只有不透明度才起作用。
      srcOut：显示源图像，但仅显示两个图像不重叠的位置。
      srcOver：将源图像合成到目标图像上。
      xor：将按位异或运算符应用于源图像和目标图像。
   */
  Color? color;
  BlendMode? blendMode;

  /**
   * fill：完全填充，宽高比可能会变。
      contain：等比拉伸，直到一边填充满。
      cover：等比拉伸，直到2边都填充满，此时一边可能超出范围。
      fitWidth：等比拉伸，宽填充满。
      fitHeight：等比拉伸，高填充满。
      none：当组件比图片小时，不拉伸，超出范围截取。
      scaleDown：当组件比图片小时，图片等比缩小，效果和contain一样。
   */
  BoxFit? fit;

  /**
   * 表示当组件有空余位置时，将会重复显示图片
   * repeat：x,y方向都充满。
      repeatX：x方向充满。
      repeatY：y方向充满。
      noRepeat：不重复。
   */
  ImageRepeat? repeat;



  ImageLoadWidget({Key? key, required this.imgUrl,this.width,this.height,this.alignment,this.placeholder,this.erroUrl,this.color,this.fit,this.blendMode,this.repeat,this.isFile=false}) : super(key: key);

  @override
  Widget build(BuildContext context)=>imageWidget();

   Widget imageWidget(){
     if(isFile){
       if(imgUrl!.endsWith('svg')){
         return SvgPicture.file(File(imgUrl!),width: width?? 70.w,height:height?? 70.w,alignment:Alignment.center,color: color!,fit: fit!,);
       }else{
         return Image.file(File(imgUrl!),width: width??80.w,height:height??80.w,alignment: alignment?? Alignment.center,color: color!,fit: fit,colorBlendMode: blendMode,repeat: repeat!,);
       }
     }else{
       if(imgUrl!.endsWith('svg')){
         if(imgUrl!.startsWith('http')){
           return SvgPicture.network(imgUrl!,width: width?? 70.w,height:height?? 70.w,placeholderBuilder:(context){
             return Container(padding: const EdgeInsets.all(30.0),
                 child: const CircularProgressIndicator());
           },alignment:Alignment.center,fit: BoxFit.contain,);
         }else{
           return SvgPicture.asset(imgUrl!,semanticsLabel:'svg',width: width?? 70.w,height:height?? 70.w,alignment:Alignment.center,color: color!,fit: fit!,);
         }
       }else{
         if(imgUrl!.startsWith('http')){
           return FadeInImage.assetNetwork(placeholder: placeholder??'images/ic_default.png',imageErrorBuilder:(context, error, stackTrace) {
// TODO 图片加载错误后展示的 widget
// print("---图片加载错误---");
// 此处不能 setState
             return Image.asset(erroUrl ?? 'images/img_zanwu.png',width: width??80.w,height:height??80.w,);
           },
               image:imgUrl! ,width: width??80.w,height:height??80.w,alignment: alignment ?? Alignment.center,fit: fit);
         }else{
           return Image.asset(imgUrl!,width: width??80.w,height:height??80.w,alignment: alignment?? Alignment.center,color: color!,fit: fit,colorBlendMode: blendMode,repeat: repeat!,);
         }
       }
     }
   }

}


