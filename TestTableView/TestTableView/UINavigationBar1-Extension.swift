//
//  UINavigationBar1-Extension.swift
//  TestTableView
//
//  Created by MAC on 2017/2/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

// MARK: -
// MARK: -
// MARK: - ⚠️方法二
extension UINavigationBar {
    // MARK: - 接口
    /**
     *  隐藏导航栏下的横线，背景色置空 viewWillAppear调用
     */
    func star() {
        let shadowImg: UIImageView? = self.findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = true
        self.backgroundColor = nil
    }
    
    /**
     在func scrollViewDidScroll(_ scrollView: UIScrollView)调用
     @param color 最终显示颜色
     @param scrollView 当前滑动视图
     @param value 滑动临界值，依据需求设置
     */
    func change(_ color: UIColor, with scrollView: UIScrollView, andValue value: CGFloat) {
        if scrollView.contentOffset.y < -value{
            // 下拉时导航栏隐藏，无所谓，可以忽略
            self.isHidden = true
        } else {
            self.isHidden = false
            // 计算透明度
            let alpha: CGFloat = scrollView.contentOffset.y / value > 1.0 ? 1 : scrollView.contentOffset.y / value
            //设置一个颜色并转化为图片
            let image: UIImage? = imageFromColor(color: color.withAlphaComponent(alpha))
            self.setBackgroundImage(image, for: .default)
        }
    }
    
    /**
     *  还原导航栏  viewWillDisAppear调用
     */
    func reset() {
        let shadowImg = findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = false
        self.setBackgroundImage(nil,for: .default)
    }
    
    
    // MARK: - 其他内部方法
    //寻找导航栏下的横线  （递归查询导航栏下边那条分割线）
    fileprivate func findNavLineImageViewOn(view: UIView) -> UIImageView? {
        if (view.isKind(of: UIImageView.classForCoder())  && view.bounds.size.height <= 1.0) {
            return view as? UIImageView
        }
        for subView in view.subviews {
            let imageView = findNavLineImageViewOn(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }
    
    // 通过"UIColor"返回一张“UIImage”
    fileprivate func imageFromColor(color: UIColor) -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}



/*
 /// 方法二：简单使用
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
 self.navigationController?.navigationBar.change(UIColor.orange, with: scrollView, andValue: 64)
 }
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 self.navigationController?.navigationBar.star()
 scrollViewDidScroll(collectionView)
 }
 override func viewWillDisappear(_ animated: Bool) {
 super.viewWillDisappear(animated)
 self.navigationController?.navigationBar.reset()
 }
 */
