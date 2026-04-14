module top_module(input I_clk,input I_rst,input [4:0] I_selA,input [4:0] I_selB,input I_we,input [4:0] I_selD,input [31:0] I_dataD,output [31:0] O_dataA,output [31:0] O_dataB);reg [31:0] regfile [31:0]; 
 assign O_dataA = regfile[I_selA]; 
 assign O_dataB = regfile[I_selB]; 
 always @(posedge I_clk) begin 
  if (I_we) begin 
  $display("%d = %d, out is now %d at %d", I_selD, I_dataD, O_dataB, $time); 
  regfile[I_selD] <= I_dataD; 
  end 
 end 
 reg [5:0] k; 
 initial begin 
  for (k = 0; k <= 31; k = k + 1) begin 
  regfile[k] = 0; 
  end 
  regfile[18] = 32'h0000DFFF; 
 end 
 endmodule