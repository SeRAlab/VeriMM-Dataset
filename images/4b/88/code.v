module top_module(uart_clk, new_nonces, golden_nonce, serial_send, serial_busy, slave_nonces);parameter SLAVES = 2;

   input uart_clk;
   
   input [SLAVES-1:0] new_nonces;
   input [SLAVES*32-1:0] slave_nonces;
   output [31:0] 	 golden_nonce;
   output 		 serial_send;
   input 		 serial_busy;

   reg 			 serial_send_reg = 0;
   assign serial_send = serial_send_reg;
  
   
   
   reg [SLAVES-1:0] 	new_nonces_flag = 0;
   
   
   
   
   
   

   function integer clog2;		
      input integer value;
      begin
      value = value-1;
      for (clog2=0; value>0; clog2=clog2+1)
      value = value>>1;
      end
   endfunction

   reg [clog2(SLAVES)+1:0] port_counter = 0;
   reg [SLAVES*32-1:0] 	    slave_nonces_shifted = 0;
   assign golden_nonce = slave_nonces_shifted[31:0];

   
   reg [SLAVES-1:0] 	    clear_nonces = 0;
   
   always @(posedge uart_clk)
     begin
	
	
	new_nonces_flag <= (new_nonces_flag & ~clear_nonces) | new_nonces;

	if (port_counter == SLAVES-1)
	  port_counter <= 0;
	else
	  port_counter <= port_counter + 1;
	
	
	
	
	
	if (!serial_busy && new_nonces_flag[port_counter])
	  begin
	     slave_nonces_shifted <= slave_nonces >> port_counter*32;
	     serial_send_reg <= 1;
	     clear_nonces[port_counter] <= 1;
	  end
	else 
	  begin
	     serial_send_reg <= 0;
	     clear_nonces <= 0;
	  end
     end

endmodule