function rgb = hex2rgb(hex)
	% Remove the # symbol if it's there
    hex = strrep(hex, '#', '');
	hex=char(hex);
	
	% Convert hex values to decimal and normalize by dividing by 255
    r = hex2dec(hex(1:2)) / 255;
    g = hex2dec(hex(3:4)) / 255;
    b = hex2dec(hex(5:6)) / 255;

    % Output RGB triplet
    rgb = [r, g, b];
end