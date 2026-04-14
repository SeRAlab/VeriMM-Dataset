module top_module(

	input clk,

	
	input [ADDR_WIDTH-1:0] ram_addr,
	input                  ram_cen,
	input            [1:0] ram_wen,
	input           [15:0] ram_din,
	output reg      [15:0] ram_dout,

	
	inout      [15:0] SRAM_DQ,
	output reg [17:0] SRAM_ADDR,
	output reg SRAM_UB_N,
	output reg SRAM_LB_N,
	output reg SRAM_WE_N,
	output reg SRAM_CE_N,
	output reg SRAM_OE_N
);parameter ADDR_WIDTH = 9; 



	
	
	
	
	
	
	


	reg [15:0] sram_dout;

	reg rnw; 
	reg ena; 




	
	always @(negedge clk)
	begin
		SRAM_ADDR <= { {18-ADDR_WIDTH{1'b0}}, ram_addr[ADDR_WIDTH-1:0] };
	end


	
	always @(negedge clk)
	begin
		if( !ram_cen && !(&ram_wen) )
			rnw <= 1'b0;
		else
			rnw <= 1'b1;

		ena <= ~ram_cen;
	end


	
	always @(negedge clk)
		sram_dout <= ram_din;

	
	assign SRAM_DQ = rnw ? {16{1'bZ}} : sram_dout;

	
	always @(posedge clk)
	begin
		if( ena && rnw )
			ram_dout <= SRAM_DQ;
	end


	
	always @(negedge clk)
	begin
		if( !ram_cen )
		begin
			if( &ram_wen[1:0] ) 
			begin
				SRAM_CE_N <= 1'b0;
				SRAM_OE_N <= 1'b0;
				SRAM_WE_N <= 1'b1;
				SRAM_UB_N <= 1'b0;
				SRAM_LB_N <= 1'b0;
			end
			else 
			begin
				SRAM_CE_N <= 1'b0;
				SRAM_OE_N <= 1'b1;
				SRAM_WE_N <= 1'b0;
				SRAM_UB_N <= ram_wen[1];
				SRAM_LB_N <= ram_wen[0];
			end
		end
		else 
		begin
			SRAM_CE_N <= 1'b1;
			SRAM_OE_N <= 1'b1;
			SRAM_WE_N <= 1'b1;
			SRAM_UB_N <= 1'b1;
			SRAM_LB_N <= 1'b1;
		end
	end





endmodule