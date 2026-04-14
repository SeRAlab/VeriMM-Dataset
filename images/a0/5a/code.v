module top_module(
	input [2:0] iEsc,
	input reg [31:0] iA, iB, iC, iD,
	output reg [31:0] oSaida
);always @(*)
begin
	case(iEsc)
	3'b000 : oSaida <= iA;
	3'b001 : oSaida <= iB;
	3'b010 : oSaida <= iC;
	3'b011 : oSaida <= iD;
	default : oSaida <= 32'b0;
	endcase
end

endmodule