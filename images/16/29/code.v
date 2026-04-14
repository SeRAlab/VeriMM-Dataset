module ripple_carry_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [3:0] carry;

    // Full Adder for bit 0
    assign {carry[0], Sum[0]} = A[0] + B[0] + Cin;
    // Full Adder for bit 1
    assign {carry[1], Sum[1]} = A[1] + B[1] + carry[0];
    // Full Adder for bit 2
    assign {carry[2], Sum[2]} = A[2] + B[2] + carry[1];
    // Full Adder for bit 3
    assign {Cout, Sum[3]} = A[3] + B[3] + carry[2];
endmodule