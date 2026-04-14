module top_module(input wire clk,input wire rst,input wire [4:0] raddr1, raddr2, waddr,input wire [31:0] wdata,input wire w_en,output wire [31:0] rdata1, rdata2);reg [31:0] rf [31:0]; 
  assign rdata1 = rf [raddr1]; 
  assign rdata2 = rf [raddr2]; 
  integer ii; 
  initial 
  begin 
  for ( ii = 0; ii < 32; ii= ii + 1 ) 
  rf[ii] = 0; 
  end 
  always @(posedge clk) 
  begin 
  if (rst) 
  rf[0] <= 0; 
  else 
  if(w_en) 
  rf [waddr] <= wdata; 
  end 
 endmodule