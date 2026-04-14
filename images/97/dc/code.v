module top_module(
	input wire        clk,
	input wire        reset,
	input wire        rx,
	input wire        s_tick,
	output reg        rx_done_tick,
	output wire [7:0] dout
);parameter DBIT    = 8;
	parameter SB_TICK = 16;
	
	localparam IDLE  = 0;
	localparam START = 1;
	localparam DATA  = 2;
	localparam STOP  = 3;
	
	reg [1:0] state_reg, state_next;
	reg [3:0] s_reg, s_next;
	reg [3:0] n_reg, n_next;
	reg [7:0] b_reg, b_next;
	
	always @ (posedge clk, posedge reset) begin
		if (reset) begin
			state_reg <= IDLE;
			s_reg <= 0;
			n_reg <= 0;
			b_reg <= 0;
		end
		else begin
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
		end
	end
	
	
	
	
	
	always @ (state_reg, s_reg, n_reg, b_reg, s_tick, rx) begin
		state_next <= state_reg;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		rx_done_tick <= 0;
		
		case (state_reg)
			IDLE: begin
				if (!rx) begin
					state_next <= START;
					s_next <= 0;
				end
			end
			
			START: begin
				if (s_tick) begin
					if (s_reg == 7) begin
						state_next <= DATA;
						s_next <= 0;
						n_next <= 0;
					end
					else
						s_next <= s_reg + 1;
				end
			end
			
			DATA: begin
				if (s_tick) begin
					if (s_reg == 15) begin
						s_next <= 0;
						b_next <= {rx, b_reg[7:1]};
						if (n_reg == DBIT-1)
							state_next <= STOP;
						else
							n_next <= n_reg + 1;
					end
					else
						s_next <= s_reg + 1;
				end
			end
			
			STOP: begin
				if (s_tick) begin
					if (s_reg == SB_TICK-1) begin
						state_next <= IDLE;
						rx_done_tick <= 1;
					end
					else
						s_next <= s_reg + 1;
				end
			end
		endcase
	end

	assign dout = b_reg;
endmodule