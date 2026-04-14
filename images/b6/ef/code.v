module top_module(
    input FIFO_EMPTY,
    input INT_RDY,
	input clk,
    output reg FIFO_RD_EN
    );reg not_empty;
    

    always @(posedge clk) begin
        not_empty <= ~FIFO_EMPTY;
		FIFO_RD_EN <= INT_RDY & not_empty;
	end
endmodule