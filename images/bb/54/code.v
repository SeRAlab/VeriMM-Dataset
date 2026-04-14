module top_module(
   input [3:0] input_num,
   output [3:0] output_num
);wire [4:0] five_minus_input;
assign five_minus_input = 5'd5 - {1'b0, input_num};

assign output_num = (five_minus_input[4] == 1) ? 4'b0 : five_minus_input[3:0];

endmodule