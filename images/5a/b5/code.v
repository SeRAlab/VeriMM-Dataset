module reg_16bit(
	input 	clk,
	input 	clear,
	input 	set,
	output reg [15:0] Q
);

always @(posedge clk or posedge clear)
begin
	if (clear)
		Q <= 16'b0000000000000000;
	else if (set)
		Q <= 16'b1111111111111111;
end

endmodule