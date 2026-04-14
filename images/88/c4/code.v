module top_module(inA, inB, Out,Clk);input inA;
input inB;
input Clk;
output reg Out;

always @(inA,inB) begin
Out<=inA&inB;
end



endmodule