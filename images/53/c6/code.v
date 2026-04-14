module top_module(input clk, rst, en, output rdy);parameter WAIT_CYCLES = 1000000;
	parameter CTR_SIZE = $clog2(WAIT_CYCLES);
	
	reg[CTR_SIZE-1:0] counter;
	
	always@(posedge clk) begin
		if(rst || ~en) counter <= 0;
		else counter <= counter + 1'b1;
	end
	
	assign rdy = counter == WAIT_CYCLES;endmodule