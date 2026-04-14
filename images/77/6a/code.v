module top_module(
	input [15:0] to_display,
	input enable,
	output [3:0] D5,	
	output [3:0] D4,	
	output [3:0] D3,	
	output [3:0] D2,	
	output [3:0] D1	
);reg [15:0] temp;
	reg [3:0] t5;	
	reg [3:0] t4;
	reg [3:0] t3;
	reg [3:0] t2;
	reg [3:0] t1;
	always @(enable or to_display) begin
		if (enable==0) begin
			t5 = 4'b1111 ;
			t4 = 4'b1111 ;
			t3 = 4'b1111 ;
			t2 = 4'b1111 ;
			t1 = 4'b1111 ;
		end	
		else begin
			temp = to_display ;
			t1 = temp % 10 ;
			temp =temp/10 ;
			t2 = temp % 10 ;
			temp =temp/10 ;
			t3 = temp % 10 ;
			temp =temp/10 ;
			t4 = temp % 10 ;
			temp =temp/10 ;
			t5 = temp % 10 ;
		end
	
	end
	assign D5 =t5 ;
	assign D4 = t4 ;
	assign D3 = t3 ;
	assign D2 =  t2;
	assign D1 = t1 ;
		


endmodule