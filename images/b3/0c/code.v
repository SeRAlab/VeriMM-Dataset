module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output Cout
);wire [3:0] temp;
    wire C1, C2, C3;
    
    assign temp = A + B;
    assign Cout = C3;
    assign S = temp;
    
    assign {C1, temp[2:0]} = A[2:0] + B[2:0];
    assign {C2, temp[3]} = A[3] + B[3] + C1;
    assign C3 = C2 | (A[3] & B[3]);
    
endmodule