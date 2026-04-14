module top_module(
           up,
           u,
           lo,
           y,
           sat_mode
          );input   signed [17:0] up;  
  input   signed [35:0] u;  
  input   signed [17:0] lo;  
  output  signed [35:0] y;  
  output  sat_mode;


  wire signed [35:0] LowerRelop1_1_cast;  
  wire LowerRelop1_relop1;
  wire signed [35:0] UpperRelop_1_cast;  
  wire UpperRelop_relop1;
  wire signed [35:0] lo_dtc;  
  wire signed [35:0] Switch_out1;  
  wire signed [35:0] up_dtc;  
  wire signed [35:0] Switch2_out1;  
  wire LowerRelop1_out1;


  
  assign LowerRelop1_1_cast = {{11{up[17]}}, {up, 7'b0000000}};
  assign LowerRelop1_relop1 = (u > LowerRelop1_1_cast ? 1'b1 :
              1'b0);



  
  assign UpperRelop_1_cast = {{11{lo[17]}}, {lo, 7'b0000000}};
  assign UpperRelop_relop1 = (u < UpperRelop_1_cast ? 1'b1 :
              1'b0);



  assign lo_dtc = {{11{lo[17]}}, {lo, 7'b0000000}};



  
  assign Switch_out1 = (UpperRelop_relop1 == 1'b0 ? u :
              lo_dtc);



  assign up_dtc = {{11{up[17]}}, {up, 7'b0000000}};



  
  assign Switch2_out1 = (LowerRelop1_relop1 == 1'b0 ? Switch_out1 :
              up_dtc);



  assign y = Switch2_out1;

  
  assign LowerRelop1_out1 = LowerRelop1_relop1 | UpperRelop_relop1;



  assign sat_mode = LowerRelop1_out1;

endmodule