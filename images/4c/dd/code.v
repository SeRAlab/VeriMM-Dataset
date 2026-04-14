module top_module(
		input		clk, 
		input		rst, 
		input		count, 
		input		ud, 
		output reg [5:0]	counter_value 
	);wire [5:0]	counter_value_preserver;


	always@(posedge clk or posedge rst) begin
		if(rst == 1'b1)
			counter_value = 6'h00;
		else begin
			case({count,ud})
				2'b00: counter_value		= counter_value_preserver;
				2'b01: counter_value		= counter_value_preserver;
				2'b10: counter_value		= counter_value_preserver - 1;
				2'b11: counter_value		= counter_value_preserver + 1;
				default: counter_value	= 6'h00;
			endcase
		end
	end

	assign counter_value_preserver = counter_value;

endmodule