module top_module(input wire C,input wire OCE,input wire S,input wire R,input wire D1,input wire D2,output wire OQ);parameter USE_PHY_ODDR = 0; 
  parameter SRTYPE = "SYNC"; 
  parameter INIT = 0; 
  parameter DDR_CLK_EDGE = "OPPOSITE_EDGE"; 
  generate if (USE_PHY_ODDR != 0) begin 
 ODDR # (.SRTYPE (SRTYPE),.INIT (INIT),.DDR_CLK_EDGE (DDR_CLK_EDGE)) the_oddr (.C (C),.CE (OCE),.S (S),.R (R),.D1 (D1),.D2 (D2),.Q (OQ)); 
  end else begin 
  reg q1; 
  reg q2; 
  initial q1 <= INIT; 
  initial q2 <= INIT; 
  if(DDR_CLK_EDGE == "OPPOSITE_EDGE") begin 
  always @(posedge C) 
  if (OCE) 
  q1 <= D1; 
  always @(negedge C) 
  if (OCE) 
  q2 <= D2; 
  end else if (DDR_CLK_EDGE == "SAME_EDGE" || DDR_CLK_EDGE == "SAME_EDGE_PIPELINED") begin 
  always @(posedge C) 
  if (OCE) 
  q1 <= D1; 
  always @(posedge C) 
  if (OCE) 
  q2 <= D2; 
  end 
  assign OQ = (C) ? q1 : q2; 
  end endgenerate 
 endmodule