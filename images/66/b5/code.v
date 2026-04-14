module top_module(
	
	rom_address,

	

	
	rom_data
);parameter AUD_LINE_IN_LC	= 9'h01A;
parameter AUD_LINE_IN_RC	= 9'h01A;
parameter AUD_LINE_OUT_LC	= 9'h07B;
parameter AUD_LINE_OUT_RC	= 9'h07B;
parameter AUD_ADC_PATH		= 9'h0F8;
parameter AUD_DAC_PATH		= 9'h006;
parameter AUD_POWER			= 9'h000;
parameter AUD_DATA_FORMAT	= 9'h001;
parameter AUD_SAMPLE_CTRL	= 9'h002;
parameter AUD_SET_ACTIVE	= 9'h001;



input			[ 5: 0]	rom_address;




output		[26: 0]	rom_data;







reg			[23: 0]	data;

















assign rom_data = {data[23:16], 1'b0, 
						data[15: 8], 1'b0, 
						data[ 7: 0], 1'b0};


always @(*)
begin
	case (rom_address)
	
	0		:	data	<=	{8'h34, 7'h0, AUD_LINE_IN_LC};
	1		:	data	<=	{8'h34, 7'h1, AUD_LINE_IN_RC};
	2		:	data	<=	{8'h34, 7'h2, AUD_LINE_OUT_LC};
	3		:	data	<=	{8'h34, 7'h3, AUD_LINE_OUT_RC};
	4		:	data	<=	{8'h34, 7'h4, AUD_ADC_PATH};
	5		:	data	<=	{8'h34, 7'h5, AUD_DAC_PATH};
	6		:	data	<=	{8'h34, 7'h6, AUD_POWER};
	7		:	data	<=	{8'h34, 7'h7, AUD_DATA_FORMAT};
	8		:	data	<=	{8'h34, 7'h8, AUD_SAMPLE_CTRL};
	9		:	data	<=	{8'h34, 7'h9, AUD_SET_ACTIVE};
	default	:	data	<=	{8'h00, 7'h0, 9'h000};
	endcase
end




endmodule