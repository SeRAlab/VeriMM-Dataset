module top_module(clk, rst, nrst,clk_i, rst_i);input wire clk_i; 
  input wire rst_i; 
  output wire clk; 
  output wire rst; 
  output wire nrst; 
 `ifdef XILINX 
  wire clk_ibuf; 
  IBUF xclk_ibufg(.I(clk_i), .O(clk_ibuf)); 
 `else 
  assign clk = clk_i; 
  reg [4:0] reset_count =0; 
  assign rst = |reset_count; 
  assign nrst = ~rst; 
  always @(posedge clk_i or posedge rst_i) 
  if (rst_i) begin 
  reset_count <= 1; 
  end else begin 
  if (reset_count) 
  reset_count <= reset_count + 1; 
  end 
 `endif 
 endmodule