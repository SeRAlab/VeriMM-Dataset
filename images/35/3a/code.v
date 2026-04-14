module two_bit_multiplier (
    input [1:0] A,
    input [1:0] B,
    output [3:0] P
);
    assign P = A * B; // Combinational logic for multiplication
endmodule