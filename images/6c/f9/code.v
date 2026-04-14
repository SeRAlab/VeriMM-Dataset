module top_module(
  output DOA,
  output DOB,
  output DOC,
  output DOD,
  output DOE,
  output DOF,
  output DOG,
  output DOH,
  input [5:0] ADDRA,
  input [5:0] ADDRB,
  input [5:0] ADDRC,
  input [5:0] ADDRD,
  input [5:0] ADDRE,
  input [5:0] ADDRF,
  input [5:0] ADDRG,
  input [5:0] ADDRH,
  input DIA,
  input DIB,
  input DIC,
  input DID,
  input DIE,
  input DIF,
  input DIG,
  input DIH,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input WCLK,
  input WE
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
  assign DOA = mem_a[ADDRA];
  assign DOB = mem_b[ADDRB];
  assign DOC = mem_c[ADDRC];
  assign DOD = mem_d[ADDRD];
  assign DOE = mem_e[ADDRE];
  assign DOF = mem_f[ADDRF];
  assign DOG = mem_g[ADDRG];
  assign DOH = mem_h[ADDRH];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      mem_a[ADDRH] <= DIA;
      mem_b[ADDRH] <= DIB;
      mem_c[ADDRH] <= DIC;
      mem_d[ADDRH] <= DID;
      mem_e[ADDRH] <= DIE;
      mem_f[ADDRH] <= DIF;
      mem_g[ADDRH] <= DIG;
      mem_h[ADDRH] <= DIH;
    end
endmodule