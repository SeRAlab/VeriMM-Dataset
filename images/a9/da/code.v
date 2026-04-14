module top_module(  
	 input clk,
    input reset,
    input [31:0] IR_in,
    input IR_ld,
    output reg [31:0] IR_out
    );always@(posedge clk, posedge reset)
	begin
		if (reset) IR_out <= 0;
		else if (IR_ld) IR_out <= IR_in;
	end

endmodule