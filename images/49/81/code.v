module top_module(cnt, clk, reset_n, inc);input clk,reset_n,inc; 
	output [2:0] cnt; 
	parameter zero = 3'b000; 
	parameter one = 3'b001; 
	parameter two = 3'b010; 
	parameter three = 3'b011; 
	parameter four = 3'b100; 
	
	
	reg [2:0] cnt; 
	reg [2:0] next_cnt; 
	
	always @ (posedge clk or negedge reset_n) 
	begin
		if(reset_n == 1'b0) cnt<=zero; 
		else cnt<=next_cnt; 
	end 

	
	always @ (inc or cnt) 
	begin
		case({cnt,inc})
		{zero,1'b0} : next_cnt<=four;
		{zero,1'b1} : next_cnt<=one;
		{one,1'b0} : next_cnt<=zero;
		{one,1'b1} : next_cnt<=two;
		{two,1'b0} : next_cnt<=one;
		{two,1'b1} : next_cnt<=three;
		{three,1'b0} : next_cnt<=two;
		{three,1'b1} : next_cnt<=four;
		{four,1'b0} : next_cnt<=three;
		{four,1'b1} : next_cnt<=zero;
		default : next_cnt <= 3'bx;
		endcase 
	end 
endmodule