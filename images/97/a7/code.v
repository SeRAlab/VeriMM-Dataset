module top_module(Mem_Addr, CLK, Mem_rd, Mem_wr, Mem_DIN, Mem_DOUT);parameter T_rd = 10, T_wr = 10; 
  parameter MemSize = 1024, WordSize = 32; 
  input [WordSize-1:0] Mem_Addr; 
  input CLK, Mem_rd, Mem_wr; 
  input [WordSize-1:0] Mem_DIN; 
  output [WordSize-1:0] Mem_DOUT; 
  reg [WordSize-1:0] Mem_DOUT; 
  reg [WordSize-1:0] Mem[0:MemSize-1]; 
  integer i; 
  always @( Mem_Addr or Mem_rd ) 
  if ( ~Mem_wr && Mem_rd ) 
  Mem_DOUT <= #T_rd Mem[Mem_Addr >> 2]; 
  always @(negedge CLK) 
  if (Mem_wr == 1) 
  begin 
  Mem[Mem_Addr >> 2] <= #T_wr Mem_DIN; 
  end 
 endmodule