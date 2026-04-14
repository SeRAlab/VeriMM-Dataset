module top_module(
		input	clk, 
		input	rst, 
		input	count, 
		output [3:0]	counter_value
	);reg [3:0] counter_value_preserver;


assign counter_value = counter_value_preserver;

always@(posedge clk or posedge rst) begin
	if(rst == 1'b1) begin
		counter_value_preserver = 4'h0;
	end else if ( count == 1'b1 ) begin
		counter_value_preserver = counter_value_preserver + 1;
	end else begin
		counter_value_preserver = counter_value;
	end
end

endmodule