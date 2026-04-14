module top_module(
  output CDO,
  output O5,
  output O6,
  input I4,
  input I3,
  input I2,
  input I1,
  input I0,
  input CDI,
  input CE,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_CLK_INVERTED" *)
  input CLK
);parameter [31:0] INIT = 32'h00000000;
  parameter [0:0] IS_CLK_INVERTED = 1'b0;
  wire clk = CLK ^ IS_CLK_INVERTED;
  reg [31:0] r = INIT;
  assign CDO = r[31];
  assign O5 = r[{1'b0, I3, I2, I1, I0}];
  assign O6 = r[{I4, I3, I2, I1, I0}];
  always @(posedge clk) if (CE) r <= {r[30:0], CDI};
endmodule