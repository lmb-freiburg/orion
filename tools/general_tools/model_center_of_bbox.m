function c = model_center_of_bbox(model)

xc = mean(minmax(model.x));
yc = mean(minmax(model.y));
zc = mean(minmax(model.z));

c = [xc,yc,zc];