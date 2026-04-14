module top_module(
	input clk,
	input rst_n,

	output reg[3:0]	cnt
);always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 1'b0;
	else 
		cnt <= cnt + 1'b1;
end

endmodule