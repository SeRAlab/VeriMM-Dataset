module top_module(out, select, I1, I0);output reg [7:0] out;
	input [7:0] I0, I1;
	input select;
	
	always@(*) begin
		out<= select ? I1: I0;
	end 
endmodule