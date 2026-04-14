module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] out
);always @ (a, b) begin
        out = a | b;
    end

endmodule