module top_module(data_in, shift_amount, shift_direction, data_out);input [31:0] data_in;
  input [4:0] shift_amount;
  input shift_direction;
  output [31:0] data_out;

  assign data_out = shift_direction ? (data_in >> shift_amount) : (data_in << shift_amount);
endmodule