function [sVal_Obj, sVal_Cen, sVal_MagF, sVal_Vel, sVal_Def] = calRegionalChracteristics(Val_Obj, Val_Cen, Val_MagF, Val_Vel, Val_Def, L, mSeg)

sVal_Obj = zeros(mSeg, 1);
sVal_Cen = zeros(mSeg, 1);
sVal_MagF = zeros(mSeg, 1);

iLabel = unique(L);
sVal_Obj(iLabel) = Val_Obj;
sVal_Cen(iLabel) = Val_Cen;
sVal_MagF(iLabel) = Val_MagF;

sVal_Def = Val_Def;
sVal_Vel = Val_Vel;

end