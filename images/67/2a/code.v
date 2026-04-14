module top_module(clk, rst, op, num1, num2, result, valid);parameter ADD = 2'b00;
parameter SUB = 2'b01;
parameter MUL = 2'b10;
parameter DIV = 2'b11;

input clk, rst;
input [1:0] op;
input [7:0] num1, num2;
output [7:0] result;
output valid;

reg [7:0] result_reg;
reg valid_reg;

always @(posedge clk) begin
    if (rst) begin
        result_reg <= 8'h00;
        valid_reg <= 1'b0;
    end else begin
        case (op)
            ADD: result_reg <= num1 + num2;
            SUB: result_reg <= num1 - num2;
            MUL: result_reg <= num1 * num2;
            DIV: result_reg <= num1 / num2;
        endcase
        valid_reg <= 1'b1;
    end
end

assign result = result_reg;
assign valid = valid_reg;

endmodule