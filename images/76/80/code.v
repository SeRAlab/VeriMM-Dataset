module top_module(
	input  wire[7:0]  iMop,
	output reg [8:0]  oUopFlowIdx
);always @ ( iMop )
begin
	case ( iMop )
		8'h7C: oUopFlowIdx = 9'd16;		  //BIT7
		8'h11: oUopFlowIdx = 9'd69;		  //RLr_b
		8'h38: oUopFlowIdx = 9'd477;		//SRL_b

	default:
			oUopFlowIdx = 9'd0;
	endcase
end

endmodule