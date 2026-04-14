module top_module(input [2:0] condition, input z, ov, n, taken, output reg miss);localparam Eq = 3'h0;
localparam Gr = 3'h1;
localparam GrEq = 3'h2;
localparam Le = 3'h3;
localparam LeEq = 3'h4;
localparam NEq = 3'h5;
localparam Ov = 3'h6;

always @(*) begin
	case (condition)
		Eq:
			miss = z^taken;
		Gr: 
			miss = (~(z|n))^taken;
		GrEq:
			miss = (~n)^taken;
		Le:
			miss = n ^ taken;
		LeEq:
			miss = (z|n) ^ taken;
		NEq:
			miss = (~z) ^ taken;
		Ov:
			miss = ov ^ taken;
		default:
			miss = 0;
	endcase
end	
endmodule