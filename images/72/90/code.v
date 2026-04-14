module top_module(
		clk,
		RST,
		dclk
);input            clk;
			input            RST;
			output           dclk;
   




			parameter [15:0] CNTENDVAL = 16'b1011011100110101;
			reg [15:0]       cntval;





			
			
			
			always @(posedge clk)
				
				begin
					if (RST == 1'b1)
						cntval <= {16{1'b0}};
					else
						if (cntval == CNTENDVAL)
							cntval <= {16{1'b0}};
						else
							cntval <= cntval + 1'b1;
				end
			
			
			assign dclk = cntval[15];
   
endmodule