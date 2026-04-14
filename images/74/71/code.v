module top_module(
    input [15:0] D,
    input [3:0] S,
    output [15:0] Q
);assign Q = (S >= 0) ? (D << S) : (D >> -S);

endmodule