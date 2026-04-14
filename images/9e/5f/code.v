module top_module(clk, init, mem_dat_in, mem_dat_out, mem_addr, rd, wr);input clk;
	input [15:0]mem_dat_in;
	input [7:0]mem_addr; 
	input rd;
	input wr;
	input init;

	output reg [15:0]mem_dat_out;

	
	reg [15:0]ram[255:0]; 
	
	always @(posedge clk) begin
		if(init) begin
			if(wr) begin
				ram[mem_addr] <= mem_dat_in;
			end else if(rd) begin
				mem_dat_out <= ram[mem_addr];
			end
		end
	end
	
endmodule