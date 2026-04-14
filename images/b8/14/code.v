module top_module(WE, ADDR, DATA, mem_data );input WE; 
  input [3:0] ADDR; 
  inout [3:0] DATA; 
  output [3:0] mem_data; 
  reg [3:0] Mem[0:15]; 
  integer i; 
  initial 
  begin 
  for(i=0; i<15; i=i+1) 
  begin 
  Mem[i] = i[3:0]; 
  end 
  end 
  assign #200 DATA = WE ? Mem[ADDR] : 4'bzzzz; 
  always @(posedge WE) 
  begin 
  Mem[ADDR] <= #200 DATA; 
  end 
  assign mem_data = DATA; 
 endmodule