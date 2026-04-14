module top_module(
  input a,
  input b,
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
  end

endmodule