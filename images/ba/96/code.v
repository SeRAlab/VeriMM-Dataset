module top_module(clk, en, we, rst, addr, di, dout);input clk; 
input en; 
input we; 
input rst;
input [9:0] addr; 
input [15:0] di; 
output [15:0] dout;

reg [15:0] ram [1023:0];
reg [15:0] dout;

always @(posedge clk)
begin
  if (en) 
    begin
      if (we) 
        ram[addr] <= di;
      if (rst) 
        dout <= 0;
      else
        dout <= ram[addr];
    end
end

endmodule