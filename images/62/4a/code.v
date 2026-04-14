module top_module(
  input CLK,
  input D,
  input EN,
  output reg Q
);wire ENCLK;

  // Instantiate a clock gating module (replacing the unknown one with a simple clock gate)
  assign ENCLK = EN ? CLK : 1'b0; // Simple clock gating logic

  always @(posedge ENCLK) begin
    if (EN) begin
      Q <= D;
    end
  end

endmodule