module top_module(
	input clk,rst_n,
	input [31:0]reg_out1,reg_out2,
	output reg [31:0]reg_A,reg_B
   );always@(posedge clk, negedge rst_n)
	begin
		if(~rst_n)
		begin
			reg_A <= 32'bx;
			reg_B <= 32'bx;
		end
		else
		begin
			reg_A <= reg_out1;
			reg_B <= reg_out2;
		end
	end

endmodule