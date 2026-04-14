module vga_vtim(clk, ena, rst, Tsync, Tgdel, Tgate, Tlen, Sync, Gate, Done);
	input clk; 
	input ena; 
	input rst; 
	input [ 7:0] Tsync; 
	input [ 7:0] Tgdel; 
	input [15:0] Tgate; 
	input [15:0] Tlen;  
	output Sync; 
	output Gate; 
	output Done; 
	reg Sync;
	reg Gate;
	reg Done;
	reg  [15:0] cnt, cnt_len;
	wire [16:0] cnt_nxt, cnt_len_nxt;
	wire        cnt_done, cnt_len_done;
	assign cnt_nxt = {1'b0, cnt} -17'h1;
	assign cnt_done = cnt_nxt[16];
	assign cnt_len_nxt = {1'b0, cnt_len} -17'h1;
	assign cnt_len_done = cnt_len_nxt[16];
	reg [4:0] state;
	parameter [4:0] idle_state = 5'b00001;
	parameter [4:0] sync_state = 5'b00010;
	parameter [4:0] gdel_state = 5'b00100;
	parameter [4:0] gate_state = 5'b01000;
	parameter [4:0] len_state  = 5'b10000;
	always @(posedge clk)
	  if (rst)
	    begin
	        state   <= #1 idle_state;
	        cnt     <= #1 16'h0;
	        cnt_len <= #1 16'b0;
	        Sync    <= #1 1'b0;
	        Gate    <= #1 1'b0;
	        Done    <= #1 1'b0;
	    end
	  else if (ena)
	    begin
	        cnt     <= #1 cnt_nxt[15:0];
	        cnt_len <= #1 cnt_len_nxt[15:0];
	        Done    <= #1 1'b0;
	        case (state) 
	          idle_state:
	            begin
	                state   <= #1 sync_state;
	                cnt     <= #1 Tsync;
	                cnt_len <= #1 Tlen;
	                Sync    <= #1 1'b1;
	            end
	          sync_state:
	            if (cnt_done)
	              begin
	                  state <= #1 gdel_state;
	                  cnt   <= #1 Tgdel;
	                  Sync  <= #1 1'b0;
	              end
	          gdel_state:
	            if (cnt_done)
	              begin
	                  state <= #1 gate_state;
	                  cnt   <= #1 Tgate;
	                  Gate  <= #1 1'b1;
	              end
	          gate_state:
	            if (cnt_done)
	              begin
	                  state <= #1 len_state;
	                  Gate  <= #1 1'b0;
	              end
	          len_state:
	            if (cnt_len_done)
	              begin
	                  state   <= #1 sync_state;
	                  cnt     <= #1 Tsync;
	                  cnt_len <= #1 Tlen;
	                  Sync    <= #1 1'b1;
	                  Done    <= #1 1'b1;
	              end
	        endcase
	    end
endmodule