module top_module(
	input clk,
	input rst,
	input [3:0] speedctr,
	output reg clk_gen 
);reg [3:0] speedctr_i = 4'd1;
always @ (posedge clk)
    begin
        if(rst)
        	begin
        		speedctr_i <= speedctr;	
        	end
        else
        	begin
        		speedctr_i <= speedctr_i;
        	end
    end

reg [3:0] counter = 4'd0;
always @ (posedge clk)
    begin
        if(rst)
        	begin
        		counter <= 4'd0;
                clk_gen <= 1'b0;
        	end
        else
        	begin
        		if (counter < speedctr_i) 
        		    begin
        		        counter <= counter + 1'b1;
                        clk_gen <= clk_gen;
        		    end
        		else 
        		    begin
    					counter <= 4'b0000;	
                        clk_gen <= ~clk_gen;	        
        		    end
        	end
    end
endmodule