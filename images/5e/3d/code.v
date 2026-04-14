module top_module(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire dir,
    output reg [31:0] cnt
    );always @(negedge clk)
    begin
	   if(rst==0) cnt <= 32'b0;
	 	else
	 	  begin
	 	    if(enable)
			   begin
	 	        if(dir)
	 	        cnt <=cnt+1 ;
	 	        else
	 	        cnt <=cnt-1 ;
				end
	 	  end
    end	 
endmodule