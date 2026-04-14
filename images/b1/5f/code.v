module top_module(clk, enable, reset, dataIn, ready, result);input clk, enable, reset; 
	input [7:0] dataIn; 

	output ready; 
	output [63:0] result; 
	reg [7:0] regBank[7:0]; 
	reg [3:0] status_int;

	integer i; 

	parameter s1=0, s2=1, s3=2, s4=3, s5=4, s6=5, s7=6, s8=7, s9=8; 

	always @(posedge clk)
	begin
		if (reset == 1)
		begin
			status_int <= s1;
		end else 
		if (enable == 0)
		begin
			regBank[0] <= dataIn; 
			for (i=7; i>0; i=i-1) begin 
				regBank[i] <= regBank[i-1]; 
			end 
		end
		case (status_int)
			s1: if (enable == 0)status_int <= s2;
			s2: if (enable == 0)status_int <= s3;
			s3: if (enable == 0)status_int <= s4;
			s4: if (enable == 0)status_int <= s5;
			s5: if (enable == 0)status_int <= s6;
			s6: if (enable == 0)status_int <= s7;
			s7: if (enable == 0)status_int <= s8;
			s8: if (enable == 0)status_int <= s9;
			s9: begin
				if (enable == 0) 
					status_int <= s2;
				else
					status_int <= s1;
				end
			default: status_int <= s1;
		endcase
	end
	
	assign result = (status_int == s9) ? {regBank[7], regBank[6], regBank[5], regBank[4], regBank[3], regBank[2], regBank[1], regBank[0]} : 64'h0; 
	assign ready = (status_int == s9) ? 1'b0 : 1'b1;
endmodule