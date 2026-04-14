module top_module(
	input [15:0] data,
	input LKL_sig,
	input CLK,
	output [15:0] address, 
	output reg LKL_Ready,
	output reg count_en

);reg [15:0] previous_data;
reg [3:0] target;

always@(posedge CLK)
begin

	if(!LKL_sig) 
	begin 
		count_en <= 0;
		LKL_Ready <= 0;
		target <= 0;
		previous_data <= 0;
	end 
	
	else 
	begin 
		count_en <= LKL_sig ? 1 : 0;
		LKL_Ready <= (target == data[15:12]) ? 1 : 0;
		
		target <= count_en ? target : data[11:8];
		
		previous_data <= (target != data[15:12]) ? data[15:0] : previous_data[15:0];
		
	end
end

assign address = LKL_sig ? ((target == data[15:12]) ? previous_data[11:0] : (count_en == 0) ? data[7:0] : data[11:0]) : address;

endmodule