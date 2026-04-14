module top_module(a, out);input a;
  output reg out; // Change wire to reg for the output

  wire R = 26e-3;
  wire C = 0.025e-15;
  wire dt = 1e-12;

  reg v_in = 0;
  wire v_out;

  // Voltage divider
  assign v_out = v_in * R / (R + 1/(dt*C));

  // Input voltage pulse
  always @ (negedge a) begin
    v_in <= 1;
  end

  // Output voltage pulse
  always @ (negedge v_out) begin
    out <= 1; // This is now valid as 'out' is a reg
  end

  // Ground supply
  supply0 gnd;

endmodule