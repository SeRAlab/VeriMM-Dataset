module top_module(
  input in,
  input Vth_high,
  input Vth_low,
  output out
);reg out_reg; // register to store previous state of output signal

  always @(in, Vth_high, Vth_low, out_reg) begin
    if (in > Vth_high) begin
      out_reg <= 1'b1; // set output to high
    end else if (in < Vth_low) begin
      out_reg <= 1'b0; // set output to low
    end else begin
      out_reg <= out_reg; // hold previous state
    end
  end

  assign out = out_reg; // assign output to stored value

endmodule