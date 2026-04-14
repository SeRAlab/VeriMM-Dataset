module top_module(
    a,
    b,
    out1
);input [7:0]a, b;

output reg out1;

always@(a,b) begin
    if(a<b)
    out1=1'b1;
    else
    out1=1'b0;
end

endmodule