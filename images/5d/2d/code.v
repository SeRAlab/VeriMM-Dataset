module top_module(
input wr,  
input clk,
input [3:0] addr, din,
  output reg [3:0] dout  
);reg [63:0] mem [3:0]; 

  always@(posedge clk)
    begin
      if(wr == 1)
        mem[addr] <= din;
      else
        dout <= mem[addr];
    end
endmodule