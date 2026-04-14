module top_module(
			input negedge_clk,
			input rx_resetn,
			
			input rx_din,
			
			output reg is_control,
			output reg [5:0] counter_neg
		  );reg control_bit_found;

always@(posedge negedge_clk or negedge rx_resetn)
begin

	if(!rx_resetn)
	begin
		is_control <= 1'b0;
		control_bit_found <= 1'b0;
		counter_neg <= 6'd1;
	end
	else
	begin
		control_bit_found <= rx_din;

		case(counter_neg)
		6'd1:
		begin
			counter_neg <= 6'd2;
		end
		6'd2:
		begin
			if(control_bit_found)
			begin
				is_control  <= 1'b1;	
			end
			else 
			begin
				is_control  <= 1'b0;
			end

			counter_neg <= 6'd4;
		end
		6'd4:
		begin

			is_control <= 1'b0;

			if(is_control)
			begin	
				counter_neg <= 6'd2;
			end
			else
			begin
				counter_neg <= 6'd8;
			end
		end
		6'd8:
		begin
			is_control    <= 1'b0;
			counter_neg <= 6'd16;
		end
		6'd16:
		begin
			is_control    <= 1'b0;
			counter_neg <= 6'd32;
		end
		6'd32:
		begin
			is_control    <= 1'b0;
			counter_neg <= 6'd2;
		end
		endcase
	end
end

endmodule