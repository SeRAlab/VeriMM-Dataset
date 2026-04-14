module top_module(
input clk,
input rst_n,
input [5:0] pc_in,
output reg [5:0] pc_out
    );always@(posedge clk,negedge rst_n)
begin
	if(~rst_n)
		pc_out <= 0;
	else
		pc_out <= pc_in;
end


endmodule