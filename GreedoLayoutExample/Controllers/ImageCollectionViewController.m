//
//  ImageCollectionViewController.m
//  GreedoLayoutExample
//
//  Created by Denny Hoang on 2016-02-10.
//  Copyright © 2016 500px. All rights reserved.
//

@import Photos;

#import "ImageCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "dynamicLabelcell.h"

@interface ImageCollectionViewController () <GreedoCollectionViewLayoutDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) GreedoCollectionViewLayout *collectionViewSizeCalculator;
@property (strong, nonatomic) PHFetchResult *assetFetchResults;


@end




@implementation ImageCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

  self.arrayOfString = @[@"Mercedes-Benz", @"BMW", @"Porsche",
                             @"Opel", @"Volkswagen", @"Audi",@"constraintW",@"constraintWithItem",@"constraintWithItem",@"constraintWithItem"];
    self.collectionViewSizeCalculator.rowMaximumHeight = CGRectGetHeight(self.collectionView.bounds) / 3;
    self.collectionViewSizeCalculator.fixedHeight = self.hasFixedHeight;

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.collectionView.backgroundColor = [UIColor whiteColor];

    // Configure spacing between cells
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5.0f;
    layout.minimumLineSpacing = 5.0f;
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 5.0f, 5.0f, 5.0f);

    self.collectionView.collectionViewLayout = layout;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"dynamicLabelcell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    

    [self retrieveImagesFromDevice];
}

- (void)retrieveImagesFromDevice
{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.assetFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.assetFetchResults[indexPath.item];

//    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ImageCollectionViewCell class]) forIndexPath:indexPath];
    
    
    
    dynamicLabelcell *cell = (dynamicLabelcell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor clearColor];
//
//    PHImageRequestOptions *options = [PHImageRequestOptions new];
//    options.resizeMode = PHImageRequestOptionsResizeModeFast;
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//    options.version = PHImageRequestOptionsVersionCurrent;
//    options.synchronous = NO;
//
//    CGFloat scale = MIN(2.0, [[UIScreen mainScreen] scale]);
//    CGSize requestImageSize = CGSizeMake(CGRectGetWidth(cell.bounds) * scale, CGRectGetHeight(cell.bounds) * scale);
//    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
//                                                      targetSize:requestImageSize
//                                                     contentMode:PHImageContentModeAspectFit
//                                                         options:options
//                                                   resultHandler:^(UIImage *result, NSDictionary *info) {
//                                                       cell.imageView.image = result;
//                                                   }];
    
    cell.label.text = self.arrayOfString[indexPath.row];
    

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  //  return self.assetFetchResults.count;
    return self.arrayOfString.count;
}



#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewSizeCalculator sizeForPhotoAtIndexPath:indexPath];
}

#pragma mark - <GreedoCollectionViewLayoutDataSource>

- (CGSize)greedoCollectionViewLayout:(GreedoCollectionViewLayout *)layout originalImageSizeAtIndexPath:(NSIndexPath *)indexPath
{
    
//    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    UINib *nib = [UINib nibWithNibName:@"dynamicLabelcell" bundle:nil];
    
    dynamicLabelcell *sizingCell = [nib instantiateWithOwner:nil options:nil][0];
    
    if (self.arrayOfString.count > indexPath.row) {
    sizingCell.label.text = self.arrayOfString[indexPath.row];
        NSLayoutConstraint *heightContraint = [NSLayoutConstraint constraintWithItem:[sizingCell contentView]
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1.0
                                                                            constant:50];
        heightContraint.priority = 1000;
        
        /*var changeSize = UILayoutFittingCompressedSize
         changeSize.width = targetSize.width
         let calculatedSize = self.contentView.systemLayoutSizeFitting(changeSize, withHorizontalFittingPriority: 1000, verticalFittingPriority: 250)
         
         self.contentView.removeConstraint(widthConstraint)
         */
        [sizingCell.contentView addConstraint:heightContraint];
        [sizingCell.contentView setNeedsUpdateConstraints];
        [sizingCell.contentView updateConstraints];
        [sizingCell.contentView setNeedsLayout];
        [sizingCell.contentView layoutIfNeeded];
        
        CGSize changeSize = UILayoutFittingCompressedSize;
        
        changeSize.height = 50;
        
        //  CGSize calculatedSize = [sizingCell.contentView systemLayoutSizeFittingSize:changeSize withHorizontalFittingPriority:250 verticalFittingPriority:1000];
        CGSize calculatedSize = [sizingCell.contentView systemLayoutSizeFittingSize:changeSize];
        [sizingCell.contentView removeConstraint:heightContraint];
        
        
        
        
        // Return the image size to GreedoCollectionViewLayout
        //    if (indexPath.item < self.assetFetchResults.count) {
        //        PHAsset *asset = self.assetFetchResults[indexPath.item];
        //
        //        
        //        return CGSizeMake(widthIs, 50);
        //    }
        return CGSizeMake(calculatedSize.width, 50);
    }else{
     return CGSizeMake(0.1, 0.1);
    }
    
    
//    float widthIs =
//    [sizingCell.label.text
//     boundingRectWithSize:sizingCell.label.frame.size
//     options:NSStringDrawingUsesLineFragmentOrigin
//     attributes:@{ NSFontAttributeName:sizingCell.label.font }
//     context:nil]
//    .size.width;
//    
  
//    return CGSizeMake(0.1, 0.1);
}

#pragma mark - Lazy Loading

- (GreedoCollectionViewLayout *)collectionViewSizeCalculator
{
    if (!_collectionViewSizeCalculator) {
        _collectionViewSizeCalculator = [[GreedoCollectionViewLayout alloc] initWithCollectionView:self.collectionView];
        _collectionViewSizeCalculator.dataSource = self;
    }

    return _collectionViewSizeCalculator;
}

@end
