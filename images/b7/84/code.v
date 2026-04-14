module top_module(clk, in, reset, out);input clk, in, reset;
	output reg out;
	parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;
	reg [0:1] PS, NS;
	
always @(posedge clk or posedge reset)
	begin
		if(reset) PS <= s0;
		else 	  PS <= NS;
	end
	
always @(PS,in)
	case (PS)
		s0 : begin
				 out <= 0;
				 if(in == 0)
					NS <= s1;
				 else
					NS <= s0;
			 end
		s1 : begin
				 out <= 0;
				 if(in == 1)
					NS <= s2;
				 else
					NS <= s1;
			 end
		s2 : begin
				 out <= 0;
				 if(in == 1)
					NS <= s3;
				 else
					NS <= s1;
			 end
		s3 : begin
				 if(in == 0)
					out <= 1;
				 if(in == 0)
					NS <= s1;
				 else
					NS <= s0;
			 end
	endcase

endmodule