module top_module(
 input clk,
 input rst,
 input en,
 output [15:0] q
);localparam N = 16;      
 localparam M = 2**N-1;  
                         
 reg [N-1:0] qi = 0;
 
 always @(posedge clk)
   if (rst)
     qi <= 0;
   else if (en)
       qi <= qi + 1; 
                     
   else qi<=qi;
   
 assign q = qi;endmodule