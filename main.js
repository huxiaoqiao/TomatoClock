require('UIColor');
defineClass('TomatoClock.ViewController',{
            viewDidLoad:function(){
            self.ORIGviewDidLoad();
             self.view().setBackgroundColor(UIColor.colorWithRed_green_blue_alpha(27 / 255.0, 161 / 255.0, 226 / 255.0, 1.0));
           },
})

defineClass('TomatoClock.CheckViewController',{
            viewDidLoad:function(){
            self.ORIGviewDidLoad();
            self.view().setBackgroundColor(UIColor.colorWithRed_green_blue_alpha(27 / 255.0, 161 / 255.0, 226 / 255.0, 1.0));
            },
            })