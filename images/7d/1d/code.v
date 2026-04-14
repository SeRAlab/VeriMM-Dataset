module top_module(
  output       DOA,
  output       DOB,
  output       DOC,
  output       DOD,
  output       DOE,
  output       DOF,
  output       DOG,
  output [1:0] DOH,
  input  [5:0] ADDRA, ADDRB, ADDRC, ADDRD, ADDRE, ADDRF, ADDRG,
  input  [4:0] ADDRH,
  input  [1:0] DIA,
  input  [1:0] DIB,
  input  [1:0] DIC,
  input  [1:0] DID,
  input  [1:0] DIE,
  input  [1:0] DIF,
  input  [1:0] DIG,
  input  [1:0] DIH,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input        WCLK,
  input        WE
);parameter [0:0] IS_WCLK_INVERTED = 1'b0;
  reg [63:0] mem_a, mem_b, mem_c, mem_d, mem_e, mem_f, mem_g, mem_h;
  assign DOA = mem_a[ADDRA];
  assign DOB = mem_b[ADDRB];
  assign DOC = mem_c[ADDRC];
  assign DOD = mem_d[ADDRD];
  assign DOE = mem_e[ADDRE];
  assign DOF = mem_f[ADDRF];
  assign DOG = mem_g[ADDRG];
  assign DOH = mem_h[2*ADDRH+:2];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(posedge clk)
    if (WE) begin
      mem_a[2*ADDRH+:2] <= DIA;
      mem_b[2*ADDRH+:2] <= DIB;
      mem_c[2*ADDRH+:2] <= DIC;
      mem_d[2*ADDRH+:2] <= DID;
      mem_e[2*ADDRH+:2] <= DIE;
      mem_f[2*ADDRH+:2] <= DIF;
      mem_g[2*ADDRH+:2] <= DIG;
      mem_h[2*ADDRH+:2] <= DIH;
    end
endmodule