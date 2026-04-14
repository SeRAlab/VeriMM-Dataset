module top_module(IN3, IN2, IN1, IN0, EN, OUT);input IN3, IN2, IN1, IN0, EN;
	output [15:0] OUT;
	
	assign OUT[0] = EN & ~IN3 & ~IN2 & ~IN1 & ~IN0;
	assign OUT[1] = EN & ~IN3 & ~IN2 & ~IN1 & IN0;
	assign OUT[2] = EN & ~IN3 & ~IN2 & IN1 & ~IN0;
	assign OUT[3] = EN & ~IN3 & ~IN2 & IN1 & IN0;
	assign OUT[4] = EN & ~IN3 & IN2 & ~IN1 & ~IN0;
	assign OUT[5] = EN & ~IN3 & IN2 & ~IN1 & IN0;
	assign OUT[6] = EN & ~IN3 & IN2 & IN1 & ~IN0;
	assign OUT[7] = EN & ~IN3 & IN2 & IN1 & IN0;
	assign OUT[8] = EN & ~IN3 & IN2 & IN1 & IN0;
	assign OUT[9] = EN & IN3 & ~IN2 & ~IN1 & IN0;
	assign OUT[10] = EN & IN3 & ~IN2 & IN1 & ~IN0;
	assign OUT[11] = EN & IN3 & ~IN2 & IN1 & IN0;
	assign OUT[12] = EN & IN3 & IN2 & ~IN1 & ~IN0;
	assign OUT[13] = EN & IN3 & IN2 & ~IN1 & IN0;
	assign OUT[14] = EN & IN3 & IN2 & IN1 & ~IN0;
	assign OUT[15] = EN & IN3 & IN2 & IN1 & IN0;
	
endmodule