module top_module(
    input  wire [ 9:0] A,
    input  wire [ 8:0] B,
    output wire [18:0] Z
);assign Z = A * B;

endmodule