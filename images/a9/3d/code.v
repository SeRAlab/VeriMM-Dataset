module top_module(
  output O0, O1, O2, O3,
  input A0, A1, A2, A3,
  input D0, D1, D2, D3,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);parameter [15:0] INIT_00 = 16'h0000;
  parameter [15:0] INIT_01 = 16'h0000;
  parameter [15:0] INIT_02 = 16'h0000;
  parameter [15:0] INIT_03 = 16'h0000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [3:0] a = {A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [15:0] mem0 = INIT_00;
  reg [15:0] mem1 = INIT_01;
  reg [15:0] mem2 = INIT_02;
  reg [15:0] mem3 = INIT_03;
  assign O0 = mem0[a];
  assign O1 = mem1[a];
  assign O2 = mem2[a];
  assign O3 = mem3[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D0;
      mem1[a] <= D1;
      mem2[a] <= D2;
      mem3[a] <= D3;
    end
endmodule