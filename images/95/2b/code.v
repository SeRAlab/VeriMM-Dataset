module top_module(
       clk,
	   reset,
	   SCLKclk
       );input wire clk, reset;
	   output reg SCLKclk;
	   
	   
       reg cuenta_sclk;  
       always @(posedge clk)   
	   begin
	      if(reset) begin
		  cuenta_sclk<=1'd0;  
		  SCLKclk <=1'd0; 
		  end  else
		              begin	
		  if(cuenta_sclk == 1'd0)
						     		 
				begin 
				cuenta_sclk<= 2'd00; 
				SCLKclk <= ~SCLKclk;
				end else
				cuenta_sclk <= cuenta_sclk + 1'b1;
		          end
	      end

endmodule