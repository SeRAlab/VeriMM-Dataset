module top_module(
  output O,
  input A0, A1, A2, A3, A4, A5, A6,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);parameter [127:0] INIT = 128'h00000000000000000000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [6:0] a = {A6, A5, A4, A3, A2, A1, A0};
  reg [127:0] mem = INIT;
  assign O = mem[a];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk) if (WE) mem[a] <= D;
endmodule