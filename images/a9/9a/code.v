module top_module(
    input clk,
    input rst,
    input [7:0] num1,
    input [7:0] num2,
    input [1:0] op,
    output reg [15:0] result
);always @(posedge clk) begin
    if(rst) begin
        result <= 16'd0;
    end else begin
        case(op)
            2'b00: result <= num1 + num2; // addition
            2'b01: result <= num1 - num2; // subtraction
            2'b10: result <= num1 * num2; // multiplication
            2'b11: result <= num1 / num2; // division
        endcase
    end
end

endmodule