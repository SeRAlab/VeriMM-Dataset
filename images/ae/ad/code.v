module top_module(input clk,input [12:0] p1_addr,input [7:0] p1_data,input p1_we,input [12:0] p2_addr,output reg [7:0] p2_data);reg [7:0] mem[0:(3*2048)-1]; 
  always @(posedge clk) 
  begin 
  if (p1_we) begin 
  mem[p1_addr] <= p1_data; 
  end 
  p2_data <= mem[p2_addr]; 
  end 
 endmodule