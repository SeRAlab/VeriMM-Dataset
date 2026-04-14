module top_module(
	input  wire clk,
	input  wire reset_n,
	input  wire [7:0] duty,
	output wire out
);reg [7:0] counter;

assign out = counter < duty;

always @(posedge clk)
 begin
 
	if(counter == 8'hFF || ~reset_n)
	 begin
		counter <= 8'h00;
	 end
	else
	 begin
		counter <= counter + 8'h01;
	 end
	
 end

endmodule