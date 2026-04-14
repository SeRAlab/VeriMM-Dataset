module top_module(
	
	rom_address,

	exposure,

	

	
	rom_data
);parameter D5M_COLUMN_SIZE	= 16'd2591;
parameter D5M_ROW_SIZE		= 16'd1943;
parameter D5M_COLUMN_BIN	= 16'h0000;
parameter D5M_ROW_BIN		= 16'h0000;



input			[ 4: 0]	rom_address;

input			[15: 0]	exposure;




output		[35: 0]	rom_data;







reg			[31: 0]	data;

















assign rom_data = {data[31:24], 1'b0, 
						data[23:16], 1'b0, 
						data[15: 8], 1'b0, 
						data[ 7: 0], 1'b0};


always @(*)
begin
	case (rom_address)
	0		:	data	<= {8'hBA, 8'h00, 16'h0000};
	1		:	data	<= {8'hBA, 8'h20, 16'hc000}; 
	2		:	data	<= {8'hBA, 8'h09, exposure}; 
	3		:	data	<= {8'hBA, 8'h05, 16'h0000}; 
	4		:	data	<= {8'hBA, 8'h06, 16'h0019}; 
	5		:	data	<= {8'hBA, 8'h0A, 16'h8000}; 
	6		:	data	<= {8'hBA, 8'h2B, 16'h000b}; 
	7		:	data	<= {8'hBA, 8'h2C, 16'h000f}; 
	8		:	data	<= {8'hBA, 8'h2D, 16'h000f}; 
	9		:	data	<= {8'hBA, 8'h2E, 16'h000b}; 
	10		:	data	<= {8'hBA, 8'h10, 16'h0051}; 
	11		:	data	<= {8'hBA, 8'h11, 16'h1807}; 
	12		:	data	<= {8'hBA, 8'h12, 16'h0002}; 
	13		:	data	<= {8'hBA, 8'h10, 16'h0053}; 
	14		:	data	<= {8'hBA, 8'h98, 16'h0000}; 
`ifdef ENABLE_TEST_PATTERN
	15		:	data	<= {8'hBA, 8'hA0, 16'h0001}; 
	16		:	data	<= {8'hBA, 8'hA1, 16'h0123}; 
	17		:	data	<= {8'hBA, 8'hA2, 16'h0456}; 
`else
	15		:	data	<= {8'hBA, 8'hA0, 16'h0000}; 
	16		:	data	<= {8'hBA, 8'hA1, 16'h0000}; 
	17		:	data	<= {8'hBA, 8'hA2, 16'h0FFF}; 
`endif
	18		:	data	<= {8'hBA, 8'h01, 16'h0036}; 
	19		:	data	<= {8'hBA, 8'h02, 16'h0010}; 
	20		:	data	<= {8'hBA, 8'h03, D5M_ROW_SIZE}; 
	21		:	data	<= {8'hBA, 8'h04, D5M_COLUMN_SIZE}; 
	22		:	data	<= {8'hBA, 8'h22, D5M_ROW_BIN}; 
	23		:	data	<= {8'hBA, 8'h23, D5M_COLUMN_BIN}; 
	24		:	data	<= {8'hBA, 8'h49, 16'h01A8}; 
	default	:	data	<= {8'h00, 8'h00, 16'h0000};
	endcase
end




endmodule