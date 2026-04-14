module top_module(
  output [7:0] O,
  input [5:0] A,
  input D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE,
  input [2:0] WSEL
);parameter [63:0] INIT_A = 64'h0000000000000000;
  parameter [63:0] INIT_B = 64'h0000000000000000;
  parameter [63:0] INIT_C = 64'h0000000000000000;
  parameter [63:0] INIT_D = 64'h0000000000000000;
  parameter [63:0] INIT_E = 64'h0000000000000000;
  parameter [63:0] INIT_F = 64'h0000000000000000;
  parameter [63:0] INIT_G = 64'h0000000000000000;
  parameter [63:0] INIT_H = 64'h0000000000000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a = INIT_A;
  reg [63:0] mem_b = INIT_B;
  reg [63:0] mem_c = INIT_C;
  reg [63:0] mem_d = INIT_D;
  reg [63:0] mem_e = INIT_E;
  reg [63:0] mem_f = INIT_F;
  reg [63:0] mem_g = INIT_G;
  reg [63:0] mem_h = INIT_H;
  assign O[7] = mem_a[A];
  assign O[6] = mem_b[A];
  assign O[5] = mem_c[A];
  assign O[4] = mem_d[A];
  assign O[3] = mem_e[A];
  assign O[2] = mem_f[A];
  assign O[1] = mem_g[A];
  assign O[0] = mem_h[A];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      case (WSEL)
      3'b111: mem_a[A] <= D;
      3'b110: mem_b[A] <= D;
      3'b101: mem_c[A] <= D;
      3'b100: mem_d[A] <= D;
      3'b011: mem_e[A] <= D;
      3'b010: mem_f[A] <= D;
      3'b001: mem_g[A] <= D;
      3'b000: mem_h[A] <= D;
      endcase
    end
endmodule