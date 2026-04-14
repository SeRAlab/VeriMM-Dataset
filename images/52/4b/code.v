module top_module(CLK, RST_X, D_IN, WE, RE, D_OUT, D_EN, RDY, ERR);input wire CLK, RST_X, WE, RE; 
  input wire [7:0] D_IN; 
  output reg [7:0] D_OUT; 
  output reg D_EN, ERR; 
  output wire RDY; 
  reg [7:0] mem [0:2048-1]; 
  reg [10:0] head, tail; 
  assign RDY = (D_EN==0 && head!=tail); 
  always @(posedge CLK) begin 
  if(~RST_X) begin 
  {D_EN, ERR, head, tail, D_OUT} <= 0; 
  end 
  else begin 
  if(WE) begin 
  mem[tail] <= D_IN; 
  tail <= tail + 1; 
  if(head == (tail + 1)) ERR <= 1; 
  end 
  if(RE) begin 
  D_OUT <= mem[head]; 
  D_EN <= 1; 
  head <= head + 1; 
  end else begin 
  D_EN <= 0; 
  end 
  end 
  end 
 endmodule