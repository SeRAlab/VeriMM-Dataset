module full_adder_4bit(A, B, Cin, Sum, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] Sum;
    output Cout;
    wire [3:0] carry;

    assign {carry[0], Sum[0]} = A[0] + B[0] + Cin;
    assign {carry[1], Sum[1]} = A[1] + B[1] + carry[0];
    assign {carry[2], Sum[2]} = A[2] + B[2] + carry[1];
    assign {carry[3], Sum[3]} = A[3] + B[3] + carry[2];
    assign Cout = carry[3];

endmodule