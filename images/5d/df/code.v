module top_module(
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    output [7:0] result,
    output valid
);reg [7:0] result_reg;
reg valid_reg;

always @(posedge clk) begin
    if (rst) begin
        result_reg <= 8'b0;
        valid_reg <= 1'b0;
    end else begin
        case (op)
            2'b00: begin // addition
                result_reg <= a + b;
                valid_reg <= 1'b1;
            end
            2'b01: begin // subtraction
                result_reg <= a - b;
                valid_reg <= 1'b1;
            end
            2'b10: begin // multiplication
                result_reg <= a * b;
                valid_reg <= 1'b1;
            end
            2'b11: begin // division
                if (b == 0) begin
                    result_reg <= 8'b0;
                    valid_reg <= 1'b0;
                end else begin
                    result_reg <= a / b;
                    valid_reg <= 1'b1;
                end
            end
        endcase
    end
end

assign result = result_reg;
assign valid = valid_reg;

endmodule