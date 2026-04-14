/***************************************RAM*****************************************/
module RAM #(parameter DEPTH = 16,  parameter WIDTH = 8)
(
	 input clk,
	 input wen,
	 input [$clog2(DEPTH)-1:0] waddr,
	 input [WIDTH-1:0] wdata,
	 input ren,
	 input [$clog2(DEPTH)-1:0] raddr,
	 output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge clk) begin
	if(wen)
		RAM_MEM[waddr] <= wdata;
	if(ren)
		rdata <= RAM_MEM[raddr];
end 

endmodule  

/**************************************SFIFO*****************************************/
module sync_fifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					clk, 
	input 					rstn,   
	input 					winc,
	input 			 		rinc,
	input 		[WIDTH-1:0]	wdata,

	output wire				wfull,
	output wire				rempty,
	output wire [WIDTH-1:0]	rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

reg 	[ADDR_WIDTH-1:0]	waddr_bin;
reg 	[ADDR_WIDTH-1:0]	raddr_bin;
reg 	[ADDR_WIDTH:0]	wptr;
reg 	[ADDR_WIDTH:0]	rptr;

always @(posedge clk or negedge rstn) begin
	if(~rstn) begin
		waddr_bin <= 'd0;
		raddr_bin <= 'd0;
		wptr <= 'd0;
		rptr <= 'd0;
	end 
	else begin
		if (!wfull && winc) begin
			waddr_bin <= waddr_bin + 1'd1;
			wptr <= wptr + 1'd1;
		end
		if (!rempty && rinc) begin
			raddr_bin <= raddr_bin + 1'd1;
			rptr <= rptr + 1'd1;
		end
	end
end

assign wfull = (wptr == {~rptr[ADDR_WIDTH], rptr[ADDR_WIDTH-1:0]});
assign rempty = (wptr == rptr);

/***********RAM*********/
wire 	wen	;
wire	ren	;
assign wen = winc & !wfull;
assign ren = rinc & !rempty;

RAM #(.DEPTH(DEPTH),
      .WIDTH(WIDTH)
) RAM (
	.clk (clk),  
	.wen (wen),  
	.waddr(waddr_bin),  //The depth is logarithmic to 2 to get the bit width of the address
	.wdata(wdata),       	//data_write
	.ren (ren), 
	.raddr(raddr_bin),   
	.rdata(rdata)  		
);

endmodule