module top_module(input A, B, C, D,input SEL,input F1,input FCI,input WAD0, WAD1, WAD2, WAD3,input WD,input WCK, WRE,output F,output OFX);parameter MODE = "LOGIC"; 
  parameter [15:0] INIT = 16'h0000; 
  parameter INJECT = "YES"; 
  localparam inject_p = (INJECT == "YES") ? 1'b1 : 1'b0; 
  reg [15:0] lut = INIT; 
  wire [7:0] s3 = D ? INIT[15:8] : INIT[7:0]; 
  wire [3:0] s2 = C ? s3[ 7:4] : s3[3:0]; 
  wire [1:0] s1 = B ? s2[ 3:2] : s2[1:0]; 
  wire Z = A ? s1[1] : s1[0]; 
  wire [3:0] s2_3 = C ? INIT[ 7:4] : INIT[3:0]; 
  wire [1:0] s1_3 = B ? s2_3[ 3:2] : s2_3[1:0]; 
  wire Z3 = A ? s1_3[1] : s1_3[0]; 
  generate 
  if (MODE == "DPRAM") begin 
  always @(posedge WCK) 
  if (WRE) 
  lut[{WAD3, WAD2, WAD1, WAD0}] <= WD; 
  end 
  if (MODE == "CCU2") begin 
  assign F = Z ^ (FCI & ~inject_p); 
  assign FCO = Z ? FCI : (Z3 & ~inject_p); 
  end else begin 
  assign F = Z; 
  end 
  endgenerate 
  assign OFX = SEL ? F1 : F; 
 endmodule