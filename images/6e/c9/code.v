module top_module(
  input in,
  output out1,
  output out2
);reg prev_state;
reg out1_reg;
reg out2_reg;

always @(posedge in) begin
  if (prev_state == 0) begin
    out1_reg <= 1;
    out2_reg <= 0;
  end else begin
    out1_reg <= 0;
    out2_reg <= 1;
  end
  prev_state <= ~prev_state;
end

assign out1 = out1_reg;
assign out2 = out2_reg;

endmodule