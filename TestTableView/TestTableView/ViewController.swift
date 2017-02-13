//
//  ViewController.swift
//  TestTableView
//
//  Created by MAC on 2017/2/11.
//  Copyright © 2017年 MAC. All rights reserved.
//

import UIKit
import MJRefresh

private let kcellID = "CellID"

private let kNavBarH = 64
private let kAdViewH = 200

class ViewController: UIViewController {


    @IBOutlet weak var collectionView: UICollectionView!
    
    // 初始化广告位
    let adView: UIView = {
        let view: UIView = UIView()
        view.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: kAdViewH)
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setupUI()
        viewBindEvents()
        
    }

    func setupUI() {
        setupCollectionView()
        view.addSubview(adView)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        //layout.headerReferenceSize = CGSizeMake(KScreentW, KProductHeaderCellH);
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kcellID)
        collectionView.contentInset = UIEdgeInsets(top: CGFloat(kAdViewH), left: 0, bottom: 0, right: 0)
        
    }
    
    func viewBindEvents() {
        collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[weak self] in
            self?.collectionView.mj_header.endRefreshing()
        })
    }

}

extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.scrollViewDidScroll(collectionView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.Mg_reset()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kcellID, for: indexPath)
        cell.contentView.backgroundColor = UIColor.gray
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > CGFloat(-kAdViewH + 1) {
            adView.mj_y = CGFloat(-kAdViewH)
            collectionView.addSubview(adView)
        }else {
            adView.mj_y = CGFloat(kNavBarH)
            view.addSubview(adView)
        }
        
        // 设置透明颜色
        let color = UIColor(red: CGFloat(0 / 255.0), green: CGFloat(175 / 255.0), blue: CGFloat(240 / 255.0), alpha: CGFloat(1))
        let offsetY1: CGFloat = scrollView.contentOffset.y
        if offsetY1 < 50 {
            let alpha: CGFloat = max(0, 1 - ((50 + 64 - offsetY1) / 64))
            self.navigationController?.navigationBar.Mg_setBackgroundColor(backgroundColor: color.withAlphaComponent(alpha))
        } else {
            self.navigationController?.navigationBar.Mg_setBackgroundColor(backgroundColor: color.withAlphaComponent(1))
        }
        
    }
}

