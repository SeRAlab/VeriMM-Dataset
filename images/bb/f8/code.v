module top_module(
    
      // Interface: clk
      input              clk,
      // Interface: reset
      input              reset_n,
      // Interface: in
      input              in_valid,
      input      [ 7: 0] in_data,
      // Interface: out
      output reg         out_valid,
      output reg [ 7: 0] out_data,
      input              out_ready
);// ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  [ 7: 0] in_payload;
   reg  [ 7: 0] out_payload;
   reg  [ 0: 0] ready;
   reg          in_ready;

   // ---------------------------------------------------------------------
   //| Payload Mapping
   // ---------------------------------------------------------------------
   always @* begin
     in_payload = {in_data};
     {out_data} = out_payload;
   end

   // ---------------------------------------------------------------------
   //| Ready & valid signals.
   // ---------------------------------------------------------------------
   always @* begin
     ready[0] = out_ready;
     out_valid = in_valid & in_ready;
     out_payload = in_payload;
     in_ready = ready[0] | ~out_valid;
   end

endmodule