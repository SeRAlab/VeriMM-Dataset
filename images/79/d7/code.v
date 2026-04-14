module top_module(input CK,input WE,input LOAD,input CLEARING,input [3:0] COLOR_INDEX,input PCK2,input [7:0] SPR_PAL,input [7:0] ADDR_LOAD,output [11:0] DATA_OUT);reg [11:0] LB_RAM[0:255]; 
  reg [7:0] PAL_REG; 
  reg [7:0] ADDR_COUNTER; 
  reg [7:0] ADDR_LATCH; 
  wire [7:0] ADDR_MUX; 
  wire [11:0] DATA_IN; 
  wire [3:0] COLOR_GATED; 
  assign RAM_WE = ~WE; 
  assign RAM_RE = ~RAM_WE; 
  assign COLOR_GATED = COLOR_INDEX | {4{CLEARING}}; 
  assign DATA_IN[3:0] = COLOR_GATED; 
  always @(posedge PCK2) 
  PAL_REG <= SPR_PAL; 
  assign DATA_IN[11:4] = PAL_REG | {8{CLEARING}}; 
  assign ADDR_MUX = LOAD ? (ADDR_COUNTER + 1'b1) : ADDR_LOAD; 
  always @(posedge CK) 
  ADDR_COUNTER <= ADDR_MUX; 
  always @(*) 
  if (WE) ADDR_LATCH <= ADDR_COUNTER; 
  assign #10 DATA_OUT = RAM_RE ? LB_RAM[ADDR_LATCH] : 12'bzzzzzzzzzzzz; 
  always @(posedge RAM_WE) 
  LB_RAM[ADDR_LATCH] <= DATA_IN; 
 endmodule