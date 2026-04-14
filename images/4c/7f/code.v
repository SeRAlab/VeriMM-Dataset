module top_module(
	
	rom_address,

	

	
	rom_data
);parameter INPUT_CONTROL	= 16'h0040;
parameter CHROMA_GAIN_1	= 16'h2df4;
parameter CHROMA_GAIN_2	= 16'h2e00;



input			[ 5: 0]	rom_address;




output		[26: 0]	rom_data;







reg			[23: 0]	data;

















assign rom_data = {data[23:16], 1'b0, 
						data[15: 8], 1'b0, 
						data[ 7: 0], 1'b0};


always @(*)
begin
	case (rom_address)
	
	10		:	data	<=	{8'h40, 16'h1500};
	11		:	data	<=	{8'h40, 16'h1741};
	12		:	data	<=	{8'h40, 16'h3a16};
	13		:	data	<=	{8'h40, 16'h5004};
	14		:	data	<=	{8'h40, 16'hc305};
	15		:	data	<=	{8'h40, 16'hc480};
	16		:	data	<=	{8'h40, 16'h0e80};
	17		:	data	<=	{8'h40, 16'h5004};
	18		:	data	<=	{8'h40, 16'h5218};
	19		:	data	<=	{8'h40, 16'h58ed};
	20		:	data	<=	{8'h40, 16'h77c5};
	21		:	data	<=	{8'h40, 16'h7c93};
	22		:	data	<=	{8'h40, 16'h7d00};
	23		:	data	<=	{8'h40, 16'hd048};
	24		:	data	<=	{8'h40, 16'hd5a0};
	25		:	data	<=	{8'h40, 16'hd7ea};
	26		:	data	<=	{8'h40, 16'he43e};
	27		:	data	<=	{8'h40, 16'hea0f};
	28		:	data	<=	{8'h40, 16'h3112};
	29		:	data	<=	{8'h40, 16'h3281};
	30		:	data	<=	{8'h40, 16'h3384};
	31		:	data	<=	{8'h40, 16'h37A0};
	32		:	data	<=	{8'h40, 16'he580};
	33		:	data	<=	{8'h40, 16'he603};
	34		:	data	<=	{8'h40, 16'he785};
	35		:	data	<=	{8'h40, 16'h5004};
	36		:	data	<=	{8'h40, 16'h5100};
	37		:	data	<=	{8'h40, INPUT_CONTROL};
	38		:	data	<=	{8'h40, 16'h1000};
	39		:	data	<=	{8'h40, 16'h0402};
	40		:	data	<=	{8'h40, 16'h0860};
	41		:	data	<=	{8'h40, 16'h0a18};
	42		:	data	<=	{8'h40, 16'h1100};
	43		:	data	<=	{8'h40, 16'h2b00};
	44		:	data	<=	{8'h40, 16'h2c8c};
	45		:	data	<=	{8'h40, CHROMA_GAIN_1};
	46		:	data	<=	{8'h40, CHROMA_GAIN_2};
	47		:	data	<=	{8'h40, 16'h2ff4};
	48		:	data	<=	{8'h40, 16'h30d2};
	49		:	data	<=	{8'h40, 16'h0e05};
	default	:	data	<=	{8'h00, 16'h0000};
	endcase
end




endmodule