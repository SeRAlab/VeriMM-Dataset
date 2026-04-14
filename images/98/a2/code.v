module top_module(a, b, ctrl, clk, out);input [3:0] a;
input [3:0] b;
input ctrl;
input clk;
output [3:0] out;

reg [3:0] out;

always @(posedge clk) begin
    if(ctrl == 0) // addition
        out <= a + b;
    else // subtraction
        out <= a - b;
end

endmodule