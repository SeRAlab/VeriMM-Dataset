module top_module(
input clk,
input[7:0] direccionram,
input wram,
input [15:0]datorom,
output reg [15:0]datoram
);parameter DWIDTH=16,AWIDTH=8,WORDS=256;
 
reg [DWIDTH-1:0] ram [WORDS-1:0];
       
       
always@(posedge clk ) 
         if (wram) begin  datoram <= ram[direccionram]; end    
         else   ram[direccionram] <= datorom;                                                
  endmodule