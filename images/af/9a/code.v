module top_module(
  output O,
  input DI, 
  input CLK, 
  input WE, 
  input WA7,
  input [5:0] A, 
  input [5:0] WA
);parameter [63:0] INIT = 64'h0; 
  parameter IS_WCLK_INVERTED = 1'b0; 
  parameter HIGH_WA7_SELECT = 1'b0; 

  reg [63:0] mem; 
  initial mem <= INIT; 
  assign O = mem[A]; 
  
  wire clk = CLK ^ IS_WCLK_INVERTED; 
  always @(posedge clk) 
    if (WE & (WA7 == HIGH_WA7_SELECT)) 
      mem[WA] <= DI; 
endmodule