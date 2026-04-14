module top_module(we,addr,datain,clk,dataout);input [31:0] datain; 
  input [31:0] addr; 
  input clk,we; 
  output [31:0] dataout; 
  reg [31:0] ram [0:31]; 
  assign dataout=ram[addr[6:2]]; 
  always @(posedge clk)begin 
  if(we)ram[addr[6:2]]=datain; 
  end 
  integer i; 
  initial begin 
  for(i=0;i<32;i=i+1) 
  ram[i]=0; 
  ram[5'h00]=126; 
  ram[5'h01]=32'h00000001; 
  ram[5'h14]=32'h00000001; 
  ram[5'h15]=32'h00000027; 
  ram[5'h16]=32'h00000079; 
  ram[5'h17]=32'h00000115; 
  end 
 endmodule