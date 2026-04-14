module top_module(

	
	input 	wire 					clk,
	input 	wire 					reset,
	
	
	output 	wire	[ 127 : 0 ]	aso_dma_req_data,
	output	wire					aso_dma_req_valid,
	input		wire					aso_dma_req_ready,

	
	input 	wire	[ 127 : 0 ]	asi_dma_req_data,
	input		wire					asi_dma_req_channel,
	input		wire					asi_dma_req_valid,
	output	wire					asi_dma_req_ready
);assign aso_dma_req_data		= asi_dma_req_data;
assign aso_dma_req_valid	= asi_dma_req_valid;
assign asi_dma_req_ready	= aso_dma_req_ready;

endmodule