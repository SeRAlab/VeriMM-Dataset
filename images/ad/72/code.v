module top_module(input clk,rst, output reg [5:0] light
    );reg [3:0] state;
	 parameter s0 = 0,s1 = 1,s2 = 2,s3 = 3,s4 = 4,s5 = 5,s6 = 6;
	 always @(posedge clk or negedge rst ) begin
		if (!rst)
			state <=s0;
		else case(state)
			s0: begin
				state <=s1;
				light = 6'b111111;
			end
			s1: begin
				state<=s2;
				light = 6'b101010;
			end
			s2: begin
				state<=s3;
				light = 6'b100011;
			end
			s3: begin
				state<=s4;
				light = 6'b100111;
			end
			s4: begin
				state<=s5;
				light = 6'b100101;
			end
			s5: begin
				state<=s6;
				light = 6'b100100;
			end
			s6: begin
				state<=s0;
				light = 6'b000000;
			end
		endcase
			end		
endmodule