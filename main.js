require('UIColor,UIFont,UIImage');
defineClass('TomatoClock.AboutViewController',{
            viewDidLoad:function(){
            self.super().viewDidLoad();
            
            var imageView = self.view().subviews().objectAtIndex(1);
            imageView.setImage(UIImage.imageNamed("ShareImage"));
            var label = self.view().subviews().objectAtIndex(3);
            label.setText("番茄时钟 V1.1.0");
            },
            })
defineClass('TomatoClock.ViewController',{
            viewDidLoad:function(){
            self.ORIGviewDidLoad();
             self.view().setBackgroundColor(UIColor.colorWithRed_green_blue_alpha(27 / 255.0, 161 / 255.0, 226 / 255.0, 1.0));
            self.countButton.titleLabel().setFont(UIFont.systemFontOfSize(60));

           },
})

defineClass('TomatoClock.CheckViewController',{
            viewDidLoad:function(){
            self.ORIGviewDidLoad();
            self.view().setBackgroundColor(UIColor.colorWithRed_green_blue_alpha(27 / 255.0, 161 / 255.0, 226 / 255.0, 1.0));
            self.countButton.titleLabel().setFont(UIFont.systemFontOfSize(60));

            },
            })