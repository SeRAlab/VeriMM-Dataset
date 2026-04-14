module top_module(input clk,input rst,input [31:0] data_a,input [31:0] addr_a,output reg [31:0] data_b,output reg strobe_b,input [31:0] addr_b,input [31:0] data_b_in,input [31:0] data_b_we);reg [31:0] counter; 
  always @(posedge clk) 
  if (~rst) begin 
  counter <= 0; 
  strobe_b <= 0; 
  data_b <= 0; 
  end else begin 
  counter <= counter + 1; 
  if (data_b_we & (addr_b == 65542)) 
  $display(">> Clock cycles: %d", counter); 
  if (addr_b == 65542) begin 
  strobe_b <= 1; 
  data_b <= counter; 
  end else strobe_b <= 0; 
  end 
 endmodule