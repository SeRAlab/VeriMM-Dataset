module top_module(DPO, SPO, A0, A1, A2, A3, D, DPRA0, DPRA1, DPRA2, DPRA3, WCLK, WE);parameter INIT = 16'h0000; 
  output DPO, SPO; 
  input A0, A1, A2, A3, D, DPRA0, DPRA1, DPRA2, DPRA3, WCLK, WE; 
  reg [15:0] mem; 
  wire [3:0] adr; 
  assign adr = {A3, A2, A1, A0}; 
  assign SPO = mem[adr]; 
  assign DPO = mem[{DPRA3, DPRA2, DPRA1, DPRA0}]; 
  initial 
  mem = INIT; 
  always @(posedge WCLK) 
  if (WE == 1'b1) 
  mem[adr] <= D; 
 endmodule