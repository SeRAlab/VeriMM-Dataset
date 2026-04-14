module top_module(
	dout,
	din,
	address,
	size,
	read_write,
	enable,
	lighting,
	reset,
	clk
);parameter WORD = 32;
	parameter LOGWORD = 5;
	parameter LOGWORDBYTE = 2;
	parameter ENABLE = 1'b1;
	parameter WRITE = 1'b1;
	parameter READ = 1'b0;
	
	output reg [WORD-1:0] dout;
	input [WORD-1:0] din;
	input [WORD-1:0] address;
	input [LOGWORDBYTE-1:0] size;
	input read_write;
	input enable;
	output reg [WORD-1:0] lighting;
	input reset;
	input clk;
	
	reg [WORD-1:0] mem[0:(1<<LOGWORD)-1];
	reg [LOGWORD-1:0] addr;
	reg [WORD-1:0] data;
	reg [WORD-1:0] hold;
	
	always @(posedge clk) begin
		if (reset) begin
			addr <= 0;
			data <= 0;
			hold <= 0;
			lighting <= 0;
		end
		else if (enable) begin
			addr <= address[LOGWORDBYTE-1:0]; // Corrected part select to address[LOGWORDBYTE-1:0]
			case (size)
				2'b00: data <= din;
				2'b01: data <= {din[15:0], din[15:0]};
				2'b10: data <= {din[7:0], din[7:0], din[7:0], din[7:0]};
				2'b11: data <= {din[7:0], din[7:0], din[7:0], din[7:0],
								din[7:0], din[7:0], din[7:0], din[7:0]};
			endcase
			if (read_write == WRITE) begin
				mem[addr] <= data;
				hold <= data;
			end
			else begin
				dout <= mem[addr];
				hold <= mem[addr];
			end
			lighting <= hold;
		end
	end
endmodule