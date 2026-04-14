module top_module(
  input reset,
  input sync_in,
  output sync_out
);reg sync_out_reg;

  always @(posedge reset)
  begin
    if (reset)
      sync_out_reg <= 1'b0;
    else
      sync_out_reg <= sync_in;
  end

  assign sync_out = sync_out_reg;

endmodule