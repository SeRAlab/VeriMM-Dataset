module top_module(count8, clk, rst);input clk;
   input rst;
   output reg [2:0] count8; 

   
   always@ (posedge clk) begin
      
      if (rst == 1)
	count8 <= 3'b000;
      else if (rst == 0) begin
	 count8 <= count8 + 1; 

	 if (count8 == 3'b111) begin 
	    count8 <= 3'b000; 
	 end
      end
   end
   
endmodule