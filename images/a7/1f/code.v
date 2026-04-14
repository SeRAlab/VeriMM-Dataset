module top_module(
    input [1:0] op,
    input [7:0] a,
    input [7:0] b,
    input clk,
    input rst,
    output [7:0] result,
    output valid
);reg [7:0] result_reg;
reg valid_reg;

always @(posedge clk) begin
    if (rst) begin
        result_reg <= 0;
        valid_reg <= 0;
    end else begin
        case (op)
            2'b00: result_reg <= a + b; // Addition
            2'b01: result_reg <= a - b; // Subtraction
            2'b10: result_reg <= a * b; // Multiplication
            2'b11: result_reg <= a / b; // Division
        endcase
        valid_reg <= 1;
    end
end

assign result = result_reg;
assign valid = valid_reg;

endmodule