module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input [3:0] num1,
    input [3:0] num2,
    output reg [3:0] result,
    output reg overflow
);always @(*) begin
    case(op)
        2'b00: result = num1 + num2; // addition
        2'b01: result = num1 - num2; // subtraction
        2'b10: result = num1 * num2; // multiplication
        2'b11: result = num1 / num2; // division
    endcase
    
    if(result > 15) // check for overflow
        overflow = 1;
    else
        overflow = 0;
end

endmodule