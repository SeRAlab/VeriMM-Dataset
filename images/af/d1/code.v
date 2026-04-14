module top_module(
  input clk,
  input [15:0] data_s0,
  input [15:0] data_s1,
  input [15:0] data_s2,
  input [15:0] data_s3,
  input [15:0] data_s4,
  input [15:0] data_s5,
  output reg [15:0] mac_data_0,
  output reg [15:0] mac_data_1
);reg [15:0] product;
  
  always @(posedge clk) begin
    product <= (data_s0 * 2'b10) + (data_s1 * 2'b01) + (data_s2 * 2'b11) +
               (data_s3 * 2'b01) + (data_s4 * 2'b10) + (data_s5 * 2'b01);
    mac_data_0 <= product[15:0];
    mac_data_1 <= product[14:0];
  end
  
endmodule