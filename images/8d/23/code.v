module top_module(input [3:0] binary_number, output [3:0] decimal_number);wire [3:0] abs_binary_number;
wire [3:0] abs_decimal_number;

assign abs_binary_number = (binary_number[3]) ? (~binary_number + 1) : binary_number;
assign abs_decimal_number = (abs_binary_number >= 8) ? (abs_binary_number - 16) : abs_binary_number;

assign decimal_number = (binary_number[3]) ? (~abs_decimal_number + 1) : abs_decimal_number;

endmodule