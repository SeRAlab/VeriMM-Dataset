module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Sum
);reg carry;

always @ (A or B)
begin
    Sum[0] = A[0] ^ B[0];
    carry = A[0] & B[0];
    
    Sum[1] = A[1] ^ B[1] ^ carry;
    carry = (A[1] & B[1]) | (A[1] & carry) | (B[1] & carry);
    
    Sum[2] = A[2] ^ B[2] ^ carry;
    carry = (A[2] & B[2]) | (A[2] & carry) | (B[2] & carry);
    
    Sum[3] = A[3] ^ B[3] ^ carry;
end

endmodule