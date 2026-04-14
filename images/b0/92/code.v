module top_module(clk,in0,in1,in2,in3,sig
    );input clk;
	 input [2:0] sig;
	 output [2:0] in0;
	 output [2:0] in1;
	 output [2:0] in2;
	 output [2:0] in3;
	 reg [2:0] in0;
	 reg [2:0] in1;
	 reg [2:0] in2;
	 reg [2:0] in3;
	 integer counter = 0;
	 always @(posedge clk)begin
	   if(counter==0)begin
		in0<=sig;
		counter<=counter+1;
		end
		if(counter==1)begin
		in1<=sig;
		counter<=counter+1;
		end
		if(counter==2)begin
		in2<=sig;
		counter<=counter+1;
		end
		if(counter==3)begin
		in3<=sig;
		counter<=counter+1;
		end
	 end
	 


endmodule