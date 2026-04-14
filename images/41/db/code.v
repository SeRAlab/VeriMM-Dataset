module top_module(a, b, gt);input [3:0] a;
input [3:0] b;
output reg gt;

always @(a, b)
begin 
    gt = (a > b)? 1:0;
end

endmodule