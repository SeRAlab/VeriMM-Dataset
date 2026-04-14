module top_module(output reg Q0,output reg [1:0] Q1,input wire D0,input wire [1:0] D1,input wire CLK,input wire RST);always @(posedge CLK or posedge RST) 
  if (RST) begin 
  Q0 <= 0; 
  Q1 <= 0; 
  end else begin 
  Q0 <= D0; 
  Q1 <= D1; 
  end 
 endmodule