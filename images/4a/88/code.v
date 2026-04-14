module sync_fifo #(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input clk,
	input rstn,
	input winc,
	input rinc,
	input [WIDTH-1:0] wdata,
	output reg wfull,
	output reg rempty,
	output reg [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

reg [ADDR_WIDTH:0] wptr;
reg [ADDR_WIDTH:0] rptr;
reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];

always @(posedge clk or negedge rstn) begin
	if (~rstn) begin
		wptr <= 0;
		rptr <= 0;
		wfull <= 0;
		rempty <= 1;
	end else begin
		if (winc && !wfull) begin
			fifo_mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
			wptr <= wptr + 1;
		end
		if (rinc && !rempty) begin
			rdata <= fifo_mem[rptr[ADDR_WIDTH-1:0]];
			rptr <= rptr + 1;
		end
		wfull <= (wptr + 1 == rptr);
		rempty <= (wptr == rptr);
	end
end

endmodule