module custom_logic_s (
	input i,
	input j,
	input k,
	input l,
	output reg s);

assign s = i&~j&~k&l | ~i&j&~k&l | ~i&~j&k&~l | i&j&k&l | ~i&~j&~k&l;

endmodule