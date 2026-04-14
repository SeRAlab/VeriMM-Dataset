module top_module(out, in0, in1, sel);output reg  [4:0] out;
	input [4:0] in0;
	input [4:0] in1;
	input sel;

  	always @(sel)
    begin
		case (sel)
			1'b0: out = in0;
			1'b1: out = in1;
		endcase
    end
endmodule