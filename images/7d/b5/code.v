module top_module(
   input [4:0] RmIn,
	input [4:0] RtIn,
	input  Select,
	output reg [4:0] rrA2Out 
    );always @ (RmIn,RtIn,Select)
		case(Select)
			0: rrA2Out <= RmIn;
			1: rrA2Out <= RtIn; 
		endcase
endmodule