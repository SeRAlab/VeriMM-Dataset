module top_module(
    input clk,
    input reset,
    input [3:0] operand1,
    input [3:0] operand2,
    input operation,
    output reg [3:0] result,
    output reg overflow
);always @(posedge clk) begin
    if (reset) begin
        result <= 4'b0;
        overflow <= 1'b0;
    end else begin
        if (operation == 1'b0) begin
            result <= operand1 + operand2;
            overflow <= (result > 4'b1111);
        end else begin
            result <= operand1 - operand2;
            overflow <= (result < 4'b0000);
        end
    end
end

endmodule