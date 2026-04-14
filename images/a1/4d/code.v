module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output reg [3:0] Q,
    output reg COUT // Changed from wire to reg
);reg [3:0] sum;
    reg carry;

    always @(*) begin
        sum = A + B + CIN;
        carry = (A[3] & B[3]) | (A[3] & CIN) | (B[3] & CIN);
        Q = sum;
        COUT = carry; // This is now valid
    end

endmodule