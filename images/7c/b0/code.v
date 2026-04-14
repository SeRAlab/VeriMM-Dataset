module top_module(
    input [3:0] a,
    input [3:0] b,
    input enable,
    output reg [3:0] sum
);always @ (a, b, enable)
begin
    if(enable == 1'b1)
        sum = a + b;
    else
        sum = 4'b0000;
end

endmodule