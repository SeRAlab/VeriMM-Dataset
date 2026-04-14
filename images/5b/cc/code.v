module top_module(data_in, select, enable, data_out);input [15:0] data_in;
  input [3:0] select;
  input enable;
  output data_out;

  wire [15:0] selected_data;
  assign selected_data = {data_in[0+4*select], data_in[1+4*select], data_in[2+4*select], data_in[3+4*select]};

  assign data_out = enable ? selected_data : 1'b0;
endmodule