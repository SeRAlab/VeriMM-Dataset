module top_module(
    input clk, reset,
    input [3:0] a, b,
    input [1:0] op,
    output reg [3:0] result
);always @(posedge clk) begin
    if (reset) begin
        result <= 4'b0;
    end else begin
        case (op)
            2'b00: result <= a + b;
            2'b01: result <= a - b;
            2'b10: result <= a & b;
            default: result <= 4'b0;
        endcase
    end
end

endmodule