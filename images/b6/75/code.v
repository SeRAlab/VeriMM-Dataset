module alu(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    output reg [7:0] result
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 8'd0;
        end else begin
            case (op)
                2'b00: result <= a + b;
                2'b01: result <= a - b;
                2'b10: result <= a & b;
                2'b11: result <= a | b;
                default: result <= 8'd0;
            endcase
        end
    end
endmodule