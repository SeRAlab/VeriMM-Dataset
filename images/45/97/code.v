module top_module(
   
   output uart_busy,   
   output uart_tx,     
	output uart_rts,
   
   input uart_wr_i,          
   input [7:0] uart_dat_i,   
	input ser_clk,					
   input sys_rst_i           
);reg [3:0] bitcount;
  reg [8:0] shifter;
  reg uart_tx_reg;
  reg rts_reg;

  always @(posedge ser_clk or negedge sys_rst_i)
  begin
    if (~sys_rst_i) begin
      uart_tx_reg <= 1;
      bitcount <= 0;
      shifter <= 0;
		rts_reg <= 0;
    end else begin
      
      if (uart_wr_i & ~uart_busy) begin
        shifter <= { uart_dat_i[7:0], 1'h0 };
        bitcount <= 4'hA;
		  rts_reg <= 1;
      end else if (uart_busy)
		
      begin
			uart_tx_reg <= shifter[0];
			shifter <= {1'h1, shifter[8:1]};
			bitcount <= bitcount - 4'h1;
			rts_reg <= 0;
      end
    end
  end
  
  assign uart_tx = uart_tx_reg;
  assign uart_rts = rts_reg;
  assign uart_busy = (bitcount) ? 1'h1: 1'h0;

endmodule