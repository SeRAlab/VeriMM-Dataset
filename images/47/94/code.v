module top_module(
    input [7:0] num1,
    input [7:0] num2,
    input [1:0] mode,
    input clear,
    output reg [15:0] result
);always @(*) begin
    case (mode)
        2'b00: result = num1 + num2; // addition
        2'b01: result = num1 - num2; // subtraction
        2'b10: result = num1 * num2; // multiplication
        2'b11: result = num1 / num2; // division
        default: result = 16'b0; // default to 0
    endcase
end

always @(clear) begin
    if (clear) begin
        result <= 16'b0; // reset to 0
    end
end

endmodule