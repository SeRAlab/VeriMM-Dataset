module top_module(input clk,input read_a,input read_b,input write,input [23:0] addr,input [7:0] din,output reg [7:0] dout_a,output reg [7:0] dout_b,output reg busy,output reg MemOE,output reg MemWR,output MemAdv,output MemClk,output reg RamCS,output RamCRE,output reg RamUB,output reg RamLB,output reg [22:0] MemAdr,inout [15:0] MemDB);assign MemAdv = 0; 
  assign MemClk = 0; 
  assign RamCRE = 0; 
  reg [7:0] data_to_write; 
  assign MemDB = MemOE ? {data_to_write, data_to_write} : 16'bz; 
  reg [1:0] cycles; 
  reg r_read_a; 
  always @(posedge clk) begin 
  if (!busy) begin 
  if (read_a || read_b || write) begin 
  MemAdr <= addr[23:1]; 
  RamUB <= !(addr[0] != 0); 
  RamLB <= !(addr[0] == 0); 
  RamCS <= 0; 
  MemWR <= !(write != 0); 
  MemOE <= !(write == 0); 
  busy <= 1; 
  data_to_write <= din; 
  cycles <= 0; 
  r_read_a <= read_a; 
  end else begin 
  MemOE <= 1; 
  MemWR <= 1; 
  RamCS <= 1; 
  RamUB <= 1; 
  RamLB <= 1; 
  busy <= 0; 
  cycles <= 0; 
  end 
  end else begin 
  if (cycles == 2) begin 
  if (!MemOE) begin 
  if (r_read_a) dout_a <= RamUB ? MemDB[7:0] : MemDB[15:8]; 
  else dout_b <= RamUB ? MemDB[7:0] : MemDB[15:8]; 
  end 
  MemOE <= 1; 
  MemWR <= 1; 
  RamCS <= 1; 
  RamUB <= 1; 
  RamLB <= 1; 
  busy <= 0; 
  cycles <= 0; 
  end else begin 
  cycles <= cycles + 1; 
  end 
  end 
  end 
 endmodule