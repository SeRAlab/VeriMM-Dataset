module top_module(
    CLK,										
    RST,										
    CLKOUT,									
    CLKOUTn
    );input CLK;
	input RST;
	output CLKOUT;
	output CLKOUTn;





	
	reg CLKOUT = 1'b1;

	
	parameter cntEndVal = 19'h493E0;
	
	reg [18:0] clkCount = 19'h00000;




    
    assign CLKOUTn = ~CLKOUT;
    
	
	
	
	always @(posedge CLK) begin

			
			if(RST == 1'b1) begin
					CLKOUT <= 1'b0;
					clkCount <= 0;
			end
			
			else begin

					if(clkCount == cntEndVal) begin
							CLKOUT <= ~CLKOUT;
							clkCount <= 0;
					end
					else begin
							clkCount <= clkCount + 1'b1;
					end

			end

	end

endmodule