module top_module(
  output DPO, SPO,
  input  D,
  (* clkbuf_sink *)
  (* invertible_pin = "IS_WCLK_INVERTED" *)
  input  WCLK,
  input  WE,
  input  A0, A1, A2, A3, A4, A5,
  input  DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5
);parameter INIT = 64'h0;
  parameter IS_WCLK_INVERTED = 1'b0;
  wire [5:0] a = {A5, A4, A3, A2, A1, A0};
  wire [5:0] dpra = {DPRA5, DPRA4, DPRA3, DPRA2, DPRA1, DPRA0};
  reg [63:0] mem = INIT;
  assign SPO = mem[a];
  assign DPO = mem[dpra];
  wire clk = WCLK ^ IS_WCLK_INVERTED;
  always @(negedge clk) if (WE) mem[a] <= D;
  specify
    
    $setup(D , negedge WCLK &&& WE, 453);
    
    $setup(WE, negedge WCLK, 654);
    
    $setup(A0, negedge WCLK &&& WE, 362);
    
    $setup(A1, negedge WCLK &&& WE, 245);
    
    $setup(A2, negedge WCLK &&& WE, 208);
    
    $setup(A3, negedge WCLK &&& WE, 147);
    
    $setup(A4, negedge WCLK &&& WE, 68);
    
    $setup(A5, negedge WCLK &&& WE, 66);
    
    if (WE) (negedge WCLK => (SPO : D))    = 1153;
    if (WE) (negedge WCLK => (DPO : 1'bx)) = 1153;
    (A0 => SPO) = 642; (DPRA0 => DPO) = 642;
    (A1 => SPO) = 632; (DPRA1 => DPO) = 631;
    (A2 => SPO) = 472; (DPRA2 => DPO) = 472;
    (A3 => SPO) = 407; (DPRA3 => DPO) = 407;
    (A4 => SPO) = 238; (DPRA4 => DPO) = 238;
    (A5 => SPO) = 127; (DPRA5 => DPO) = 127;
  endspecify
endmodule