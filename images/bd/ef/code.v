module top_module(clk, RESET, EN, in1, in2, out1, out2);input[31:0] in1, in2;
input clk, RESET, EN;
output[31:0] out1, out2;
reg[31:0] out1, out2;

always @(posedge clk)
begin
if (RESET) 
begin
    out1 = 0;
    out2 = 0;
end
else
if (EN)
begin
    out1 = in1;
    out2 = in2;
end
end
endmodule