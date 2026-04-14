module top_module(
    input clk,
    input rst,
    input [15:0] operand1,
    input [15:0] operand2,
    input [3:0] operation,
    output reg [15:0] result
);always @(posedge clk) begin
    if (rst) begin
        result <= 16'b0;
    end else begin
        case (operation)
            4'b0000: result <= operand1 + operand2; // add
            4'b0001: result <= operand1 - operand2; // subtract
            4'b0010: result <= operand1 * operand2; // multiply
            4'b0011: result <= operand1 / operand2; // divide
        endcase
    end
end

endmodule