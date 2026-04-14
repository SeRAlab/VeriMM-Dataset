module top_module (
	input d,
	input e,
	input f,
	output reg k);assign k = (~(d & e)) ^ f;
endmodule