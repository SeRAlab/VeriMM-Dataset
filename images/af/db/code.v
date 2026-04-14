module top_module(A, B, sum);input [15:0] A;
    input [15:0] B;
    output [15:0] sum;
    
    wire [15:0] carry;
    wire [15:0] xor1;
    wire [15:0] xor2;
    
    assign xor1 = A ^ B;
    assign xor2 = xor1 ^ carry;
    assign carry = (A & B) | (xor1 & carry);
    
    assign sum = xor2;
    
endmodule