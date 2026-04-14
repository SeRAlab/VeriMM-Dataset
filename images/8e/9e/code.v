module top_module(
  output O,
  input DI, 
  input CLK, 
  input WE, 
  input WA7, 
  input WA8,
  input [5:0] A, 
  input [5:0] WA
);parameter [63:0] INIT = 64'h0; 
  parameter IS_WCLK_INVERTED = 1'b0; 
  parameter WA7USED = 1'b0; 
  parameter WA8USED = 1'b0; 
  parameter HIGH_WA7_SELECT = 1'b0; 
  parameter HIGH_WA8_SELECT = 1'b0; 
  
  reg [63:0] mem; 
  initial mem <= INIT; 
  assign O = mem[A]; 
  
  wire clk = CLK ^ IS_WCLK_INVERTED; 
  wire WA7SELECT = !WA7USED | (WA7 == HIGH_WA7_SELECT); 
  wire WA8SELECT = !WA8USED | (WA8 == HIGH_WA8_SELECT); 
  wire address_selected = WA7SELECT & WA8SELECT; 
  
  always @(posedge clk) 
    if (WE & address_selected) mem[WA] <= DI; 

endmodule