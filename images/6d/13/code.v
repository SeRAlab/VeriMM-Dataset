module top_module(
    
      // Interface: clk
      input              clk,
      // Interface: reset
      input              reset_n,
      // Interface: in
      output reg         in_ready,
      input              in_valid,
      input      [ 7: 0] in_data,
      input      [ 7: 0] in_channel,
      input              in_startofpacket,
      input              in_endofpacket,
      // Interface: out
      input              out_ready,
      output reg         out_valid,
      output reg [ 7: 0] out_data,
      output reg         out_startofpacket,
      output reg         out_endofpacket
);reg          out_channel;
   reg          [7:0] max_channel = 4'hF;

   // ---------------------------------------------------------------------
   //| Payload Mapping
   // ---------------------------------------------------------------------
   always @* begin
      in_ready = out_ready;
      out_valid = in_valid;
      out_data = in_data;
      out_startofpacket = in_startofpacket;
      out_endofpacket = in_endofpacket;

      out_channel = in_channel;
      // Suppress channels that are higher than the destination's max_channel.
      if (in_channel > max_channel) begin
         out_valid = 0;
         $display("Channel %d is higher than the destination's max_channel!", in_channel);
      end
   end

endmodule