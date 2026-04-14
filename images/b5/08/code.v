module top_module(
    input clk,                // Added clk input
    input [31:0] op1,
    input [31:0] op2,
    output reg [31:0] result,
    output reg carry_out
);reg [31:0] sum;
reg carry;                 // Changed carry to single bit as it's used as carry out

always @(*) begin
    sum = op1 + op2;
    carry = (op1[31] & op2[31]) | ((op1[31] ^ op2[31]) & ~sum[31]); // Proper carry calculation
end

always @(posedge clk) begin
    result <= sum;
    carry_out <= carry;    // Use single bit carry
end

endmodule