module top_module(
   din_0      , 
   din_1      , 
   sel        , 
   mux_out      
   );`protect

input din_0, din_1, sel ;

output mux_out;

reg  mux_out;

always @ (sel or din_0 or din_1)
begin : MUX
  if (sel == 1'b0) begin
      mux_out = din_0;
  end else begin
      mux_out = din_1 ;
  end
end
`endprotect

endmodule