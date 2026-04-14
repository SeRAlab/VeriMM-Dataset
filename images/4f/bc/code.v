module top_module(input  wire        clk, 
               input  wire        we3,           
               input  wire [3:0]  ra1, ra2, wa3, 
               input  wire [7:0]  wd3, 			 
               output wire [7:0]  rd1, rd2);reg [7:0] regb[0:15]; 

  
  
  
  always @(posedge clk)
    if (we3) regb[wa3] <= wd3;	
  
  assign rd1 = (ra1 != 0) ? regb[ra1] : 8'b00000000;
  assign rd2 = (ra2 != 0) ? regb[ra2] : 8'b00000000;
endmodule