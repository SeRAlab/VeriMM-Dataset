module SQM_PWM_LOG(
	input [3:0]din,
	output reg [7:0] rep0, 
	output reg [7:0] rep1, 
	output zero
);
assign zero = din==0;
always @(din)
	case (din)
		1: begin
		  rep0=64;
		  rep1=1;
		end
		2: begin
		  rep0=61;
		  rep1=1;
		end
		3: begin
		  rep0=32;
		  rep1=1;
		end
		4: begin
		  rep0=61;
		  rep1=2;
		end
		5: begin
		  rep0=16;
		  rep1=1;
		end
		6: begin
		  rep0=61;
		  rep1=4;
		end
		7: begin
		  rep0=8;
		  rep1=1;
		end
		8: begin
		  rep0=61;
		  rep1=8;
		end
		9: begin
		  rep0=61;
		  rep1=16;
		end
	 10: begin
		  rep0=61;
		  rep1=8;
		end
	 11: begin
		  rep0=2;
		  rep1=1;
		end
	 12: begin
		  rep0=61;
		  rep1=32;
		end
	 13: begin
		  rep0=1;
		  rep1=1;
		end
	 14: begin
		  rep0=61;
		  rep1=64;
		end
	 15: begin
		  rep0=1;
		  rep1=1;
		end
default: begin
		  rep0=1;
		  rep1=1;
		end 
	endcase	
endmodule