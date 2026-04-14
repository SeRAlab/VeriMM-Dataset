module top_module(
  input [7:0] data_in,
  input [2:0] shift_amount,
  input shift_direction,
  output [7:0] data_out
);wire [7:0] shifted_data;
  
  assign shifted_data = (shift_direction) ? (data_in << shift_amount) : (data_in >> shift_amount);
  
  assign data_out = shifted_data;
  
endmodule