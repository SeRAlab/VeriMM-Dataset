module top_module(input wire nRST, input wire CLK, output reg OUT);initial OUT = 0; 
  parameter PATTERN_DATA = 16'h0; 
  parameter PATTERN_LEN = 5'd16; 
  localparam COUNT_MAX = PATTERN_LEN - 1'h1; 
  reg[3:0] count = 0; 
  always @(posedge CLK, negedge nRST) begin 
  if(!nRST) 
  count <= 0; 
  else begin 
  count <= count - 1'h1; 
  if(count == 0) 
  count <= COUNT_MAX; 
  end 
  end 
  always @(*) 
  OUT = PATTERN_DATA[count]; 
 endmodule