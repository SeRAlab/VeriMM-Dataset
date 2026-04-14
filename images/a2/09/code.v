module top_module(
  input a,
  input b,
  input c,
  input d,
  input sel_a,
  input sel_b1,
  input sel_b2,
  output reg out_mux
);always @(*) begin
    if (sel_a) begin
      out_mux = a;
    end
    else if (!sel_b1 && !sel_b2) begin
      out_mux = b;
    end
    else if (!sel_a && sel_b1 && sel_b2) begin
      out_mux = c;
    end
    else begin
      out_mux = d;
    end
  end

endmodule