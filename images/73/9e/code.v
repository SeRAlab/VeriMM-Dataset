module top_module(input wire clk,input wire rst,input wire [6:0] waddr,input wire [6:0] raddr,input wire wr,input wire [31:0] wdata,output wire [31:0] rdata);reg [31:0] mem [0:127]; 
  integer i; 
  always @(posedge clk, negedge rst) begin 
  if (!rst) begin 
  for (i = 0; i < 128; i=i+1) begin 
  mem[i] <= 32'h0000; 
  end 
  #1 mem[20] <= 32'd10; 
  mem[21] <= 32'h3; 
  end 
  else if (wr) begin 
  mem[waddr] <= wdata; 
  end 
  end 
  assign rdata = mem[raddr][31:0]; 
 endmodule