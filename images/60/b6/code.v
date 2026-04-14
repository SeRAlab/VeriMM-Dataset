module top_module(out, in0,in1, sel);input [63:0] in0 , in1;
input sel;
output reg [63:0] out;


always @(*)
begin
if(sel)
begin
out <= #2 in1;
end
else
begin
out <= #2 in0;
end
end
endmodule