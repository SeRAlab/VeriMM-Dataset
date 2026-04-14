module Adder(
    input [7:0] A,
    input [7:0] B,
    output [15:0] C
);

assign C = {8'b0, A} + {8'b0, B};

endmodule