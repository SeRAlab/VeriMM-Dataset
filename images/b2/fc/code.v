module top_module(input NPURST,input MCLK,input FCLK,input CLK_SLOW,input CLK_SEL,input CLK_2MHZ,output CLK1,output CLK2);wire CLOCK = !(!(CLK_SLOW & CLK_SEL) & !(!CLK_SEL & CLK_2MHZ)); 
 wire CK_CLK = !((MCLK | FCLK) & !(FCLK & CLOCK)); 
 reg Q1, Q2; 
 always@(negedge CK_CLK or negedge NPURST) 
  if(!NPURST) Q1 <= 1'b1; 
  else Q1 <= (~Q1 & ~Q2) | (Q1 & ~Q2); 
 always@(posedge CK_CLK or negedge NPURST) 
  if(!NPURST) Q2 <= 1'b1; 
  else Q2 <= (~Q2 & Q1) | (Q2 & Q1); 
 assign CLK1 = !(~Q1 | Q2); 
 assign CLK2 = !( Q1 | ~Q2); 
 endmodule