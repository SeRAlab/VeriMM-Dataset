module top_module(
    input clk,
    input rst,
    input [7:0] operand_a,
    input [7:0] operand_b,
    input add,
    output reg [7:0] result,
    output reg done
);reg [7:0] temp_result;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            result <= 8'b0;
            done <= 1'b0;
        end
        else begin
            if (add) begin
                temp_result <= operand_a + operand_b;
            end
            else begin
                temp_result <= operand_a - operand_b;
            end
            result <= temp_result;
            done <= 1'b1;
        end
    end

endmodule