module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);wire [3:0] xor_result;
    wire [3:0] and_result;
    wire [3:0] or_result;

    // Calculate the XOR of A and B
    assign xor_result = A ^ B;

    // Calculate the AND of A and B
    assign and_result = A & B;

    // Calculate the OR of the AND result and the carry-in signal
    assign or_result = and_result | (Cin << 1);

    // Calculate the sum
    assign Sum = xor_result ^ or_result;

    // Calculate the carry-out signal
    assign Cout = (A & B) | (Cin & (A ^ B));

endmodule