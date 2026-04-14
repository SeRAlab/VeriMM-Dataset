module top_module(
	clk40,
	rst,
	data_offset_delay,
	delay_modifier,
	scan_delay,
	strb,
	adc_clock_delay,
	adc_data_delay,
	adc_drdy_delay,
	saturated
);input clk40;
input rst;
input [6:0] data_offset_delay;
input [6:0] delay_modifier;
input [5:0] scan_delay;
input strb;

output [5:0] adc_clock_delay;
output [5:0] adc_data_delay;
output [5:0] adc_drdy_delay;
output saturated;


reg [5:0] adc_clock_delay;
reg [7:0] adc_data_delay_2s;
reg [7:0] adc_drdy_delay_2s;

always @(posedge clk40) begin
	if (rst) begin
		adc_clock_delay <= 0;
		adc_data_delay_2s <= 0;
		adc_drdy_delay_2s <= 0;
	end else begin
		if (strb) begin
			
			
			
			
			
			
			adc_data_delay_2s <= 8'd32 + {data_offset_delay[6],data_offset_delay} + {delay_modifier[6],delay_modifier} + (8'b1 + ~scan_delay);
			adc_drdy_delay_2s <= 8'd32 + {delay_modifier[6],delay_modifier} + (8'b1 + ~scan_delay);
			adc_clock_delay <= scan_delay;
		end
	end
end


assign adc_data_delay = (adc_data_delay_2s[7] ? 6'b0 : ( (adc_data_delay_2s[6:0] > 6'd63) ? 6'd63 : adc_data_delay_2s[5:0]));
assign adc_drdy_delay = (adc_drdy_delay_2s[7] ? 6'b0 : ( (adc_drdy_delay_2s[6:0] > 6'd63) ? 6'd63 : adc_drdy_delay_2s[5:0]));
assign saturated = ( (adc_data_delay_2s[7] ? 1 : ( (adc_data_delay_2s[6:0] > 6'd63) ? 1 : 0)) ||
							(adc_drdy_delay_2s[7] ? 1 : ( (adc_drdy_delay_2s[6:0] > 6'd63) ? 1 : 0)) );

endmodule