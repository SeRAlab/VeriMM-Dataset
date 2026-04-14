module top_module(
    output reg [7:0] ans_wb,
    input [7:0] ans_dm,
    input clk,
    input reset
    );wire[7:0] ans_wb_temp;

	 

	 assign ans_wb_temp = (reset == 1'b0) ? 8'b0000_0000 : ans_dm; 

	 

	always@(posedge clk)
	begin
		ans_wb <= ans_wb_temp;	
	end

endmodule