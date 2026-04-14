module delay_counter #(
	parameter counter_width = 32
) (
	input clk,
	input reset,
	input [counter_width-1:0] count,	
	input load,
	output done
	);
reg [counter_width-1:0] counter;
always @(posedge clk)
	if(load)
		counter <= count;
	else 
		counter <= counter - 1'b1;
assign done = (counter == 0);
endmodule