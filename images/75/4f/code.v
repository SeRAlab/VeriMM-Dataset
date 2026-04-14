module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] SUM,
    output reg CARRY
);reg [3:0] carry_chain;

always @(*) begin
    SUM = A + B + carry_chain;
    CARRY = (A[3] & B[3]) | (A[3] & carry_chain[2]) | (B[3] & carry_chain[2]);
end

// Implement the carry chain using a for loop
integer i;
initial begin
    carry_chain[0] = 1'b0;
    for (i = 1; i < 4; i = i + 1) begin
        carry_chain[i] = (A[i-1] & B[i-1]) | (A[i-1] & carry_chain[i-1]) | (B[i-1] & carry_chain[i-1]);
    end
end

endmodule