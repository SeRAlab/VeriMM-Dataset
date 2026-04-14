module top_module(
  output O0, O1,
  input A0, A1, A2, A3, A4,
  input D0, D1,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
);parameter [31:0] INIT_00 = 32'h00000000;
  parameter [31:0] INIT_01 = 32'h00000000;
  parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  wire [4:0] a = {A4, A3, A2, A1, A0};
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  reg [31:0] mem0 = INIT_00;
  reg [31:0] mem1 = INIT_01;
  assign O0 = mem0[a];
  assign O1 = mem1[a];
  always @(posedge clk)
    if (WE) begin
      mem0[a] <= D0;
      mem1[a] <= D1;
    end
endmodule