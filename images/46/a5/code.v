module top_module(
    input [2:0] A,
    input [2:0] B,
    input Cin,
    input clk,
    output reg [2:0] S,
    output reg Cout
);reg [2:0] sum;
reg [2:0] carry;

always @(posedge clk) begin
    sum[0] = A[0] ^ B[0] ^ Cin;
    carry[0] = (A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin);
    
    sum[1] = A[1] ^ B[1] ^ carry[0];
    carry[1] = (A[1] & B[1]) | (A[1] & carry[0]) | (B[1] & carry[0]);
    
    sum[2] = A[2] ^ B[2] ^ carry[1];
    Cout = (A[2] & B[2]) | (A[2] & carry[1]) | (B[2] & carry[1]);
    
    S <= sum;
end

endmodule