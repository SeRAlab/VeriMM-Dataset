module top_module(s1,s2,d1,d2,c1,c2,od,os,oc,CLK);input wire CLK;
	input wire s1;
	input wire s2;
	input wire c1;
	input wire c2;
	input wire [15:0] d1;
	input wire [15:0] d2;
	output reg [15:0] od;
	output reg os;
	output reg oc;
	
	always@(posedge CLK) 
	begin

		if (s1==1'b1) 
		begin 
			od <= d1; 		
			os <= 1'b1; 
		end else if (s2==1'b1) 
		begin 
			od <= d2; 		
			os <= 1'b1; 
		end else
		begin	
			od <= 16'b0; 	
			os <= 1'b0; 
		end

		if (c1==1'b1 || c2==1'b1) oc <= 1'b1; 
		else oc <= 1'b0; 

	end

endmodule