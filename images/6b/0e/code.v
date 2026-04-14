module top_module(
    input clk,
    input rst,
    input en,
    input [3:0] input_val,
    output reg [3:0] output_val
);localparam CONSTANT_VAL = 4'b1011;

always @(posedge clk, posedge rst)
    if (rst) begin
        output_val <= 4'b0;
    end else if (en) begin
        output_val <= input_val + CONSTANT_VAL;
    end

endmodule