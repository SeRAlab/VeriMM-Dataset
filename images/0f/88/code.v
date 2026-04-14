module comb_logic (
    input [31:0] A,
    input [31:0] B,
    output [31:0] C,
    output even
);
    wire [31:0] and_result;
    wire [31:0] xor_result;

    assign and_result = A & B;
    assign xor_result = A ^ B;
    assign C = and_result | xor_result;
    assign even = ~C[0]; // Check the least significant bit for evenness
endmodule