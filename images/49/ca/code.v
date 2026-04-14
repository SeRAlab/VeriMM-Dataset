module top_module(clk, raddr1, dout1, raddr2, dout2, wr, waddr, din, ram1, ram2, ram3);input clk; 
  input wr; 
  input [4:0] raddr1, raddr2, waddr; 
  input [31:0] din; 
  output reg[31:0] dout1, dout2; 
  output wire[31:0] ram1; 
  output wire[31:0] ram2; 
  output wire[31:0] ram3; 
  reg [31:0] ram [0:31]; 
  assign ram1 = ram[5'b00001]; 
  assign ram2 = ram[5'b00010]; 
  assign ram3 = ram[5'b00011]; 
  always @(posedge clk) 
  begin 
  if (wr == 1'b1) 
  begin 
  ram[waddr] = din; 
  end 
  end 
  always @(negedge clk) 
  begin 
  dout1 <= (raddr1 == 5'b0) ? 32'b0 : ram[raddr1]; 
  dout2 <= (raddr2 == 5'b0) ? 32'b0 : ram[raddr2]; 
  end 
 endmodule