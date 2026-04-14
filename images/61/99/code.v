module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input clk,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
    wire c1,c2,c3;
    
    assign sum[0] = A[0] ^ B[0] ^ Cin;
    assign c1 = A[0] & B[0];
    assign c2 = A[0] & Cin;
    assign c3 = B[0] & Cin;
    
    assign sum[1] = A[1] ^ B[1] ^ c1;
    assign c1 = (A[1] & B[1]) | (A[1] & c1) | (B[1] & c1);
    
    assign sum[2] = A[2] ^ B[2] ^ c1;
    assign c1 = (A[2] & B[2]) | (A[2] & c1) | (B[2] & c1);
    
    assign sum[3] = A[3] ^ B[3] ^ c1;
    assign Cout = (A[3] & B[3]) | (A[3] & c1) | (B[3] & c1);
    
    assign S = sum;
    
endmodule