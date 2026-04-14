module four_input_xor(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire out
);
    assign out = a ^ b ^ c ^ d;
endmodule