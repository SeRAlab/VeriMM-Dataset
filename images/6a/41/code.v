module top_module(clk, reset, a, b, op, result);input clk, reset;
input [31:0] a, b;
input [1:0] op;
output reg [31:0] result;

always @(posedge clk) begin
    if (reset) begin
        result <= 32'b0;
    end
    else begin
        case (op)
            2'b00: result <= a + b;
            2'b01: result <= a - b;
            2'b10: result <= a * b;
            2'b11: result <= a / b;
        endcase
    end
end

endmodule