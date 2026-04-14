module top_module(notIE, sel, inA, inB, inC, inD, out);input[1:0] notIE;
	input[1:0] sel;
	input[1:0] inA;
	input[1:0] inB;
	input[1:0] inC;
	input[1:0] inD;
	output[1:0] out;
	reg[1:0] out;
	
	always @(*) begin
		case(sel)
			2'b00: #(34+15) out = inA & ~notIE;
			2'b01: #(34+15) out = inB & ~notIE;
			2'b10: #(34+15) out = inC & ~notIE;
			2'b11: #(34+15) out = inD & ~notIE;
		endcase
	end

endmodule