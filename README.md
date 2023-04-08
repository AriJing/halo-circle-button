# halo-circle-button
A circular button with a flowing light and halo effect.
在 paint 方法的后半部分，代码开始进行绘制圆形按钮的逻辑。
首先，使用 canvas.save() 和 canvas.restore() 包裹的代码块是为了将旋转和填充操作应用于圆形路径的特定部分，而不是应用于整个画布。

接下来，使用 canvas.rotate() 方法将画布旋转，其旋转角度由 animation.value 值乘以 2 * pi 计算得出。这是为了创建按钮旋转的动画效果。

然后，创建了一个新的 Paint 对象 paint，并设置它的样式为 PaintingStyle.fill，颜色为 const Color(0xff00abf2)，这是用于填充圆形按钮的颜色。

接下来，将 shader 属性设置为 null，以避免绘制填充时影响之前创建的渐变效果。最后，使用 canvas.drawPath() 方法绘制圆形按钮的填充部分，其路径为 result。

最后，重写 shouldRepaint() 方法以判断新的动画值是否与旧的动画值不同，如果不同，则表示需要重绘圆形按钮。这是为了避免在动画过程中出现帧跳过或重复渲染的情况，从而使动画更加平滑。
