module top_module(
    clk,
    nrst,
    op_code,
    num1,
    num2,
    result,
    valid
);input clk;
input nrst;
input [1:0] op_code;
input [7:0] num1;
input [7:0] num2;

output [7:0] result;
output valid;

reg [7:0] result_reg;
reg valid_reg;

always @(posedge clk) begin
    if (nrst == 0) begin
        result_reg <= 0;
        valid_reg <= 0;
    end else begin
        case (op_code)
            2'b00: result_reg <= num1 + num2; // addition
            2'b01: result_reg <= num1 - num2; // subtraction
            2'b10: result_reg <= num1 * num2; // multiplication
            2'b11: begin // division
                if (num2 == 0) begin
                    result_reg <= 0;
                    valid_reg <= 0;
                end else begin
                    result_reg <= num1 / num2;
                    valid_reg <= 1;
                end
            end
        endcase
    end
end

assign result = result_reg;
assign valid = valid_reg;

endmodule