module top_module(
   input 	     c, 
   input 	     w, 
   input [1:0] 	     a, 
   input [31:0]      wd, 
   output reg [31:0] rd = 0, 
   inout 	     uart 
   );reg [3:0] 	 rx_state = 0;
   reg [6:0] 	 rx_cur_time = 0;
   reg [6:0] 	 rx_next_event = 0;
   reg [6:0] 	 cpb = 100; 
   reg 		 ireg = 1;
   reg 		 oe = 0;
   reg 		 od = 0;
   reg [5:0] 	 tx_bits = 0; 
   reg [6:0] 	 tx_cur_time = 0;
   reg [6:0] 	 tx_next_event = 0;
   reg [38:0] 	 tx_sr = 39'h7FFFFFFFF;

   assign uart = oe ? od : 1'bz;

   always @ (posedge c)
     begin
	
	ireg <= uart;
	if(rx_state == 0)
	  begin
	     rx_cur_time <= 1'b0;
	     if (!ireg)
	       begin
		  rx_state <= 1'b1;
		  rx_next_event <= cpb[6:1];
	       end
	  end
	else
	  begin
	     rx_cur_time <= rx_cur_time + 1'b1;
	     if(rx_next_event == rx_cur_time)
	       begin
		  rx_next_event <= rx_next_event + cpb;
		  rx_state <= rx_state == 10 ? 1'b0 : rx_state + 1'b1;
		  if((rx_state > 1) && (rx_state < 10))
		    rd <= {ireg, rd[31:1]};
	       end
	  end
	
	od <= tx_sr[0];
	oe <= tx_bits != 0;
	if(w)
	  begin
	     if((a == 0) && wd[31])
	       cpb <= wd[6:0];
	     oe <= 1'b1;
	     tx_bits <= 6'd40;
	     tx_cur_time <= 1'b0;
	     tx_next_event <= cpb;
	     tx_sr[38:30] <= a > 2 ? {wd[31:24], 1'b0} : 9'h1FF;
	     tx_sr[29:20] <= a > 1 ? {1'b1, wd[23:16], 1'b0} : 10'h3FF;
	     tx_sr[19:10] <= a > 0 ? {1'b1, wd[15: 8], 1'b0} : 10'h3FF;
	     tx_sr[ 9: 0] <= (a > 0) || (wd[31:30] == 0) ? {1'b1, wd[ 7: 0], 1'b0} :
			     wd[30] == 1 ? 10'h000 : 10'h3FF;
	  end
	else
	  begin
	     tx_cur_time <= tx_cur_time + 1'b1;
	     if(tx_next_event == tx_cur_time)
	       begin
		  tx_next_event <= tx_next_event + cpb;
		  tx_sr <= {1'b1, tx_sr[38:1]};
		  tx_bits <= tx_bits == 0 ? 1'b0 : tx_bits - 1'b1;
	       end
	  end
     end
endmodule