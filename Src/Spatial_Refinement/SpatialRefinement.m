function image_saliency = SpatialRefinement(sal, method, im, L)

switch (method)
    case 'SCA' % Saliency Detection via Cellular Automata, CVPR 2015
        image_saliency = SCA_refinement(im, sal, L);
    case 'Graphcut' % Salient objectdetectionviaglobalandlocalcues, Pattern Recognition 2014
        image_saliency = Graphcut_refinement(im, sal);
	case 'Spatial' % Salient Region Detection via High-Dimensional Color Transform, CVPR 2014
        try
            image_saliency = Spatial_refinement(sal, L);
        catch
            image_saliency = sal;
        end
    otherwise
        image_saliency = sal;
end

end