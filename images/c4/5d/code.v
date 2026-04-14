module ClockGatingCell (
  input clock,
  input enable,
  output gated_clock
);

  reg gated_clock;

  always @ (posedge clock) begin
    if (enable) begin
      gated_clock <= clock;
    end else begin
      gated_clock <= 1'b0;
    end
  end

endmodule