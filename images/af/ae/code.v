module sync_fifo #(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input clk,
	input rstn,
	input wren,
	input rden,
	input [WIDTH-1:0] wdata,
	output reg [WIDTH-1:0] rdata,
	output full,
	output empty
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];
reg [ADDR_WIDTH:0] wptr, rptr, count;

always @(posedge clk or negedge rstn) begin
	if (!rstn) begin
		wptr <= 0;
		rptr <= 0;
		count <= 0;
	end else begin
		if (wren && !full) begin
			fifo_mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
			wptr <= wptr + 1;
			if (!rden || empty)
				count <= count + 1;
		end
		if (rden && !empty) begin
			rdata <= fifo_mem[rptr[ADDR_WIDTH-1:0]];
			rptr <= rptr + 1;
			if (!wren || full)
				count <= count - 1;
		end
	end
end

assign full = (count == DEPTH);
assign empty = (count == 0);

endmodule