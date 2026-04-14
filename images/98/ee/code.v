module shift_register_4bit(
	input 	clk,
	input 	rst,
	input 	D,
	output reg [3:0] Q
);

always @(posedge clk or posedge rst)
begin
	if (rst)
		Q <= 4'b0000;
	else
		Q <= {Q[2:0], D};
end

endmodule