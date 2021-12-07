3dcalc -a ~/abin/TT_desai_dd_mpm+tlrc                       \
                       -expr 'amongst(a,152,170)' -prefix template_ventricle
3dresample -dxyz 3 3 3 -inset template_ventricle+tlrc \
                       -prefix template_ventricle_3mm