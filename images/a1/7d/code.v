module top_module(InA, InB,out);input [31:0] InA,InB;
output reg [31:0] out;

always @(InA, InB) begin
    out <= $signed(InA) + $signed(InB);
end

endmodule