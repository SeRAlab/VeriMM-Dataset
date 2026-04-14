module Multiplier64(
    input [63:0] A,
    input [63:0] B,
    output [127:0] P
);
    assign P = A * B; // Simple combinational multiplication
endmodule