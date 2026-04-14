module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input [7:0] operand_a,
    input [7:0] operand_b,
    output reg [7:0] result
);always @(posedge clk) begin
    if (rst) begin
        result <= 8'b0;
    end else begin
        case(op)
            2'b00: result <= operand_a + operand_b; // addition
            2'b01: result <= operand_a - operand_b; // subtraction
            2'b10: result <= operand_a * operand_b; // multiplication
            2'b11: result <= operand_a / operand_b; // division
        endcase
    end
end

endmodule