module top_module(input [3:0] ha_sum, input [4:0] cla_bits, output [4:0] sum);assign sum = {1'b0, ha_sum} ^ cla_bits;
endmodule