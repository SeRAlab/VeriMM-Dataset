module top_module(
    input  wire        clk,
    input  wire [ 7:0] A,
    input  wire [ 7:0] B,
    output reg  [15:0] Z
);always @(posedge clk)
        Z <= Z + (A * B);

endmodule