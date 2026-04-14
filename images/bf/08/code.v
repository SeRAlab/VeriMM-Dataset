module top_module(
    input clk,
    input reset,
    input [3:0] operand1,
    input [3:0] operand2,
    input operation,
    output reg [3:0] result, // Change from wire to reg
    output reg overflow       // Change from wire to reg
);reg [4:0] temp_result; // to detect overflow

    always @(posedge clk) begin
        if (reset) begin
            result <= 4'b0;
            overflow <= 1'b0;
        end else begin
            if (operation == 0) begin
                temp_result <= operand1 + operand2;
            end else begin
                temp_result <= operand1 - operand2;
            end
            if (temp_result > 4'b1111 || temp_result < 4'b0000) begin
                overflow <= 1'b1;
            end else begin
                overflow <= 1'b0;
            end
            result <= temp_result[3:0];
        end
    end

endmodule