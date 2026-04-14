module top_module(
    input wire a,
    input wire b,
    output reg q
    );always @* q = ~(a&b);
endmodule