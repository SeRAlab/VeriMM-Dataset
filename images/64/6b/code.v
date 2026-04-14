module top_module(
	input wire        clk,
	input wire        rst,
	input wire [7:0]  data,
	output reg        nextch,
	output reg        txd
);parameter CLK  = 50_000_000;
	parameter BAUD = 9600;

	localparam RATE = CLK/BAUD;
	
	localparam INIT = 0;
	localparam TXD  = 1;
	
	reg        state, next;
	reg [31:0] cnt;
	reg [4:0]  bitcnt;
	reg [9:0]  rshift;
	reg        shift, load, clear, getch, gotch;
	
	always @ (posedge clk or negedge rst) begin
		if (!rst) begin
			state <= INIT;
			cnt <= 0;
			bitcnt <= 0;
			gotch <= 0;
		end
		else begin
			if (nextch) begin
				nextch <= 0;
				gotch <= 1;
			end
			else if (getch && !gotch)
				nextch <= 1;

			cnt <= cnt + 1;
			if (cnt >= RATE) begin
				state <= next;
				cnt <= 0;
				if (load)
					rshift <= {1'b1, data[7:0], 1'b0};
				if (clear) begin
					bitcnt <= 0;
					gotch <= 0;
				end
				if (shift) begin
					rshift <= rshift >> 1;
					bitcnt <= bitcnt + 1;
				end
			end
		end
	end
	
	always @ (state or bitcnt or rshift) begin
		load <= 0;
		shift <= 0;
		clear <= 0;
		getch <= 0;
		txd <= 1;

		case (state)
			INIT: begin
				next <= TXD;
				load <= 1;
				shift <= 0;
				clear <= 0;
			end
			
			TXD: begin
				if (bitcnt >= 9) begin
					next <= INIT;
					clear <= 1;
					getch <= 1;
				end
				else begin
					next <= TXD;
					shift <= 1;
					txd <= rshift[0];
				end
			end
			
		endcase
	end
endmodule