HV3DDrag
========

The project demonstrates a simple way to drag a view in 3D using CoreAnimation's CATransform3D. The project is compiled with base SDK iOS 7 and has a deployment target of iOS 6.

The HVViewController displays the main view with a label displaying a downward pointing arrow. You can pull down anywhere on the main view. As you pan down, the dragView will be revelead and will be dragged down in 3D along the top of the main view. 

The code which performs the 3D drag on pan is mainly in the '-(void)animateViewsForTranslation:(int)translationY' method in HVViewController.m. 
