gamecake funfont_convert.lua
gamecake funfont_psf.lua
gamecake funfont_c.lua
./funfont_psf.sh
gzip -kf *.psf
cp funfont64.lua ../../../gamecake/lua/wetgenes/gamecake/fun/funfont64.lua
