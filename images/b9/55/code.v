module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    output [3:0] shifted_value
);assign shifted_value = (C == 0) ? (A << B) : (A >> B);

endmodule