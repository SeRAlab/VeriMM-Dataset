module top_module(
  input logic CLK,
  input logic EN,
  input logic TE,
  output logic ENCLK
);logic gated_clk;
  logic d;

  // D flip-flop
  always_ff @(posedge CLK) begin
    if (EN) begin
      d <= CLK;
    end
  end

  // Clock gate
  assign gated_clk = EN ? CLK : 1'b0;

  // Toggle enable
  always_ff @(posedge CLK) begin
    if (TE) begin
      ENCLK <= ~ENCLK;
    end else begin
      ENCLK <= gated_clk;
    end
  end

endmodule