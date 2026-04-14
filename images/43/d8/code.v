module top_module(
  input [3:0] select,
  input [7:0] data_in,
  output [15:0] data_out
);wire [15:0] temp_out;
  wire [3:0] inv_select;
  
  assign inv_select = ~select;
  
  and gate0 (temp_out[0], inv_select[0], inv_select[1], inv_select[2], inv_select[3], data_in[0]);
  and gate1 (temp_out[1], inv_select[0], inv_select[1], inv_select[2], select[3], data_in[1]);
  and gate2 (temp_out[2], inv_select[0], inv_select[1], select[2], inv_select[3], data_in[2]);
  and gate3 (temp_out[3], inv_select[0], inv_select[1], select[2], select[3], data_in[3]);
  and gate4 (temp_out[4], inv_select[0], select[1], inv_select[2], inv_select[3], data_in[4]);
  and gate5 (temp_out[5], inv_select[0], select[1], inv_select[2], select[3], data_in[5]);
  and gate6 (temp_out[6], inv_select[0], select[1], select[2], inv_select[3], data_in[6]);
  and gate7 (temp_out[7], inv_select[0], select[1], select[2], select[3], data_in[7]);
  and gate8 (temp_out[8], select[0], inv_select[1], inv_select[2], inv_select[3], data_in[8]);
  and gate9 (temp_out[9], select[0], inv_select[1], inv_select[2], select[3], data_in[9]);
  and gate10 (temp_out[10], select[0], inv_select[1], select[2], inv_select[3], data_in[10]);
  and gate11 (temp_out[11], select[0], inv_select[1], select[2], select[3], data_in[11]);
  and gate12 (temp_out[12], select[0], select[1], inv_select[2], inv_select[3], data_in[12]);
  and gate13 (temp_out[13], select[0], select[1], inv_select[2], select[3], data_in[13]);
  and gate14 (temp_out[14], select[0], select[1], select[2], inv_select[3], data_in[14]);
  and gate15 (temp_out[15], select[0], select[1], select[2], select[3], data_in[15]);
  
  assign data_out = temp_out;

endmodule