module top_module(clk, addr, woffset, wdata, rdata);input clk; 
 input [1:0] addr; 
 input [3:0] wdata; 
 input [1:0] woffset; 
 output reg [7:0] rdata; 
 reg [7:0] mem [0:3]; 
 integer i; 
 always @(posedge clk) begin 
  mem[addr][woffset +: 4] <= wdata; 
  rdata <= mem[addr]; 
 end 
 endmodule