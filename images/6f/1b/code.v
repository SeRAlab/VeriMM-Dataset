module top_module(
    input [7:0] operand1,
    input [7:0] operand2,
    input [1:0] operation,
    output [7:0] result
);wire [8:0] sum;
wire [8:0] diff;

assign sum = operand1 + operand2;
assign diff = operand1 - operand2;

assign result = (operation == 2'b00) ? sum[7:0] : diff[7:0];

endmodule