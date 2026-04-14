module top_module(
    input wire clk, reset,scan_done_tick,
    input wire [7:0] scan_out,
    output reg got_code_tick
   );localparam BRK = 8'hf0; 

   
   localparam
      wait_brk = 1'b0,
      get_code = 1'b1;

   
   reg state_reg, state_next;

   
   
   
   
   always @(posedge clk, posedge reset)
      if (reset)
         state_reg <= wait_brk;
      else
         state_reg <= state_next;

   
   always @*
   begin
      got_code_tick = 1'b0;
      state_next = state_reg;
      case (state_reg)
         wait_brk:  
            if (scan_done_tick==1'b1 && scan_out==BRK)
               state_next = get_code;
         get_code:  
            if (scan_done_tick)
               begin
                  got_code_tick =1'b1;
                  state_next = wait_brk;
               end
      endcase
   end

endmodule