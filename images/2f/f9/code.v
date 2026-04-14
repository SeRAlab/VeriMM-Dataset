module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [4:0] sum; // To accommodate carry-out

    assign sum = A + B + Cin; // Add A, B and Cin
    assign S = sum[3:0]; // 4-bit sum
    assign Cout = sum[4]; // Carry-out
endmodule