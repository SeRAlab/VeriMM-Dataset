module top_module(muxCntrl, In_A, In_B, out);input muxCntrl;
input [15:0] In_A, In_B; 
output reg [15:0] out;

always @(muxCntrl, In_A, In_B)
begin

	case (muxCntrl)

		1'b0:
					out = In_A;
		1'b1:
					out = In_B;
		default: 
					out = 16'b0000_0000_0000_0000;
	endcase
end

endmodule