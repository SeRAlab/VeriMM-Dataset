module top_module(in0,in1,in2,in3, sel, out);input wire [7:0] in0,in1,in2,in3;
	input wire [1:0] sel;
	output reg [7:0] out;
	always @ (*)
		begin
			case (sel)
				0: out<=in0;
				1: out<=in1;
				2: out<=in2;
				3: out<=in3;
				default: out<=0;
			endcase
		end
endmodule