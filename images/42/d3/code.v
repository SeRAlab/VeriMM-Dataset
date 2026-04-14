module top_module(
   
   rrd,
   
   rwd, rra, rwa, rwe, rst, ena, clk
   );output [15:0] rrd; 
   input [15:0]  rwd; 
   input [2:0] 	 rra, 
		 rwa; 
   input 	 rwe; 
   
   input 	 rst,
		 ena,
		 clk;      
   
   reg [15:0] 	 file [0:7]; 

   reg [2:0] 	 r;

   assign rrd = file[rra];   
   
   always @(posedge clk)
     if (ena) begin
	r <= rra;	
	
	if (rwe) begin
	   file[rwa] <= rwd;	
	end
     end
        
endmodule