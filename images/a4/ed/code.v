module top_module(
  input [15:0] data,
  output reg [16:0] parity_data
);assign parity_data[16] = ^data;
  assign parity_data[15:0] = data;
  
endmodule