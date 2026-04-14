module dff_hold (
  input in,
  input enable_l,
  input clock,
  input reset,
  output reg out
);

always @(posedge clock or negedge reset) begin
  if (!reset) begin
    out <= 1'b0;
  end else if (!enable_l) begin
    out <= out;
  end else begin
    out <= in;
  end
end

endmodule