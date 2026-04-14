module top_module(clock, reset, write_value, read_value, 
	read_value_reg_en, led_success, led_fail);input clock, reset, read_value_reg_en;
	input [3:0] write_value, read_value;
	output led_success, led_fail;

	
	reg [3:0] read_value_reg;
	
	assign led_success = (write_value == read_value_reg);
	assign led_fail = ~led_success;
				
	
	always @( posedge clock or posedge reset)
		begin
			if(reset)
				begin
					read_value_reg <= 4'b0;
				end
			else if (read_value_reg_en)
				begin
					read_value_reg <= read_value;
				end
		end
		
endmodule