module top_module(
    input [3:0] A,
    input [3:0] B,
    input C_in,
    output [3:0] S,
    output C_out
);wire [3:0] X, Y, Z;
    wire [2:0] C;

    // Full adder
    assign X = A ^ B;
    assign Y = A & B;
    assign Z = C_in & X;
    assign S = X ^ C_in;
    assign C[0] = Y | Z;
    
    // Half adder
    assign X = S[1] ^ B[1];
    assign Y = S[1] & B[1];
    assign Z = C[0] & X;
    assign S[1] = X ^ C[0];
    assign C[1] = Y | Z;
    
    assign X = S[2] ^ B[2];
    assign Y = S[2] & B[2];
    assign Z = C[1] & X;
    assign S[2] = X ^ C[1];
    assign C[2] = Y | Z;
    
    assign X = S[3] ^ B[3];
    assign Y = S[3] & B[3];
    assign Z = C[2] & X;
    assign S[3] = X ^ C[2];
    assign C_out = Y | Z;

endmodule