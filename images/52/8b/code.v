module top_module(input clk, input ce, input [4:0] addr, input [5:0] din, output [5:0] dout, input write);reg [5:0] palette [0:31]; 
  initial begin 
  end 
  wire [4:0] addr2 = (addr[1:0] == 0) ? 0 : addr; 
  assign dout = palette[addr2]; 
  always @(posedge clk) if (ce && write) begin 
  if (!(addr[3:2] != 0 && addr[1:0] == 0)) 
  palette[addr2] <= din; 
  end 
 endmodule