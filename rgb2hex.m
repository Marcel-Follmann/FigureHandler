
function hex = rgb2hex(rgb)
	r = round(rgb(1)*255);
	g = round(rgb(2)*255);
	b = round(rgb(3)*255);

	hex = sprintf("#%02s%02s%02s",dec2hex(r),dec2hex(g),dec2hex(b));
end