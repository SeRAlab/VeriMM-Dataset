module top_module(input clk, reset_n, resume_n, output reg [13:0] random, output reg rnd_ready);wire xnor_taps, and_allbits, feedback;
	reg [13:0] reg_values;
	reg enable=1;
	
	always @ (posedge clk, negedge reset_n, negedge resume_n) begin
		if (!reset_n) begin
			reg_values<=14'b11111111111111;
				
				
				
			enable<=1;
			rnd_ready<=0;
			
		end else if (!resume_n) begin
			enable<=1;
			rnd_ready<=0;
			reg_values<=reg_values;
			
		end else begin
			if (enable) begin
				reg_values[13]=reg_values[0];
				reg_values[12:5]=reg_values[13:6];
				reg_values[4]<=reg_values[0] ^ reg_values[5];
				
				
				reg_values[3]=reg_values[4];
				reg_values[2]<=reg_values[0] ^ reg_values[3];
				
				
				reg_values[1]=reg_values[2];
				reg_values[0]<=reg_values[0] ^ reg_values[1];
			
			
			
			
				if(reg_values >= 1000 && reg_values <=5000)begin
					enable <= 1'b0;
					rnd_ready <= 1'b1;
					random <= reg_values;
				end
			
			
			end 
		end
	end
endmodule