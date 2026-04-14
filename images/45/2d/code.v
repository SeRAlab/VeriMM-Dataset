module top_module(in1,in2,Zero);input [31:0] in1,in2;
output reg Zero;

always @(in1 or in2)
begin
if (in1==in2) Zero=1;
else Zero=0;
end
endmodule