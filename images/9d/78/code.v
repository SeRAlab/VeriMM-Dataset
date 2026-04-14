module top_module(
  input bus,
  input en,
  output out
);reg out_reg;

  always @ (bus, en) begin
    if (en) begin
      out_reg <= bus;
    end else begin
      out_reg <= out_reg;
    end
  end

  assign out = out_reg;

endmodule