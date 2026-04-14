module top_module(
  input 	   clk,
  input 	   rst,
  input 	   en,
  output reg [1:0] data_out
);always @ (posedge clk) begin      
      if (rst == 1'b1) begin           
	      data_out <= 2'b0;           
      end
      else if (en == 1'b1 ) begin	 
	      if(data_out != 2'b11)       
	      data_out <= data_out+1'b1;  
      end
   end

endmodule