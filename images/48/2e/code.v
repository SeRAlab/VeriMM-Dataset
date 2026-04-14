module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] result
);wire [7:0] sum1;
wire carry;

// First full-adder implementation
assign sum1 = A ^ B;
assign carry = A & B;
 
// Second full-adder implementation
always @(*) begin
    if (carry == 1'b0) begin
        result = {1'b0, sum1};
    end else begin
        result = {1'b1, sum1 + 1'b1};
    end
end

endmodule