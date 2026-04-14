module top_module(ALUSrcB, B, Immediate, DestBranch, ImmediateUns, MuxOut);input [2:0] ALUSrcB;
input [31:0] B;
input [31:0] Immediate;
input [31:0] DestBranch;
input [31:0] ImmediateUns;
output reg [31:0] MuxOut;

always @ (ALUSrcB)
begin

case(ALUSrcB)

3'd0:MuxOut <= B;
3'd1:MuxOut <= 32'd4;
3'd2:MuxOut <= Immediate;
3'd3:MuxOut <= DestBranch;
3'd4:MuxOut <= ImmediateUns;
endcase

end
endmodule