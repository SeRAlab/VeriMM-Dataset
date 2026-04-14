module top_module(
  output O,
  input [8:0] A,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);parameter [511:0] INIT = 512'h0;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [511:0] mem = INIT;
  assign O = mem[A];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[A] <= D;
endmodule