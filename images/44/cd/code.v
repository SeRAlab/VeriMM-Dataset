module top_module(c0,c1,c2,c3,s1,s0,z,led);input wire c0,c1,c2,c3,s1,s0;
	output wire z;
	output wire [5:0]led;
	assign z=(~s1&&~s0)&&c0 || (~s1&&s0)&&c1 ||(s1&&~s0)&&c2 || (s1&&s0)&&c3;
	assign led[0]=c0;
	assign led[1]=c1;
	assign led[2]=c2;
	assign led[3]=c3;
	assign led[4]=s0;
	assign led[5]=s1;
endmodule