module custom_logic_z (
	input u,
	input v,
	input w,
	input x,
	output reg z);

assign z = u&~v&w&~x | u&v&w&x | u&~v&~w&x | u&v&~w&~x;

endmodule