module top_module(
    input clk,
    input reset,
    input [1:0] op,
    input [7:0] operand1,
    input [7:0] operand2,
    output reg [7:0] result,
    output reg overflow
);always @(posedge clk) begin
        if (reset == 1) begin
            result <= 8'b0;
            overflow <= 1'b0;
        end
        else begin
            case (op)
                2'b00: begin // addition
                    result <= operand1 + operand2;
                    overflow <= ((operand1[7] == 1) && (operand2[7] == 1) && (result[7] == 0)) ||
                                ((operand1[7] == 0) && (operand2[7] == 0) && (result[7] == 1));
                end
                2'b01: begin // subtraction
                    result <= operand1 - operand2;
                    overflow <= ((operand1[7] == 1) && (operand2[7] == 0) && (result[7] == 0)) ||
                                ((operand1[7] == 0) && (operand2[7] == 1) && (result[7] == 1));
                end
                2'b10: begin // multiplication
                    result <= operand1 * operand2;
                    overflow <= (result[15:8] != 8'b0);
                end
                2'b11: begin // division
                    if (operand2 == 8'b0) begin
                        result <= 8'b0;
                        overflow <= 1'b1;
                    end
                    else begin
                        result <= operand1 / operand2;
                        overflow <= (result[7:0] != operand1) || (operand2 == 8'b1 && operand1[7] == 1);
                    end
                end
                default: begin
                    result <= 8'b0;
                    overflow <= 1'b0;
                end
            endcase
        end
    end

endmodule