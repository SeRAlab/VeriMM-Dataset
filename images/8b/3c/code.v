module top_module(
  output wrdy, wen,
  output reg wptr,
  input wput, wq2_rptr,
  input wclk, wrst_n);always @ (posedge wclk or negedge wrst_n) begin
      if (!wrst_n)
          wptr <= 1'b0;
      else
          wptr <= wptr ^ wen;
  end

  assign wrdy = ~(wptr ^ wq2_rptr);
  assign wen = wput & wrdy;
endmodule