module top_module(
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    input start,
    output done,
    output [7:0] result
);reg [7:0] result_reg;
reg done_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        result_reg <= 8'b0;
        done_reg <= 1'b0;
    end
    else if (start) begin
        case (op)
            2'b00: result_reg <= a + b;
            2'b01: result_reg <= a - b;
            2'b10: result_reg <= a * b;
            2'b11: result_reg <= a / b;
        endcase
        done_reg <= 1'b1;
    end
    else begin
        done_reg <= 1'b0;
    end
end

assign done = done_reg;
assign result = result_reg;

endmodule