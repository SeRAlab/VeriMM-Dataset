module top_module(
           in0_re,
           in0_im,
           out0
          );input   signed [15:0] in0_re;  
  input   signed [15:0] in0_im;  
  output  [1:0] out0;  


  wire inphase_lt_zero;
  wire inphase_eq_zero;
  wire quadrature_lt_zero;
  wire quadrature_eq_zero;
  wire [3:0] decisionLUTaddr;  
  wire [1:0] DirectLookupTable_1 [0:15];  
  wire [1:0] hardDecision;  


  assign inphase_lt_zero = (in0_re < 16'sb0000000000000000 ? 1'b1 :
              1'b0);



  assign inphase_eq_zero = (in0_re == 16'sb0000000000000000 ? 1'b1 :
              1'b0);



  assign quadrature_lt_zero = (in0_im < 16'sb0000000000000000 ? 1'b1 :
              1'b0);



  assign quadrature_eq_zero = (in0_im == 16'sb0000000000000000 ? 1'b1 :
              1'b0);



  assign decisionLUTaddr = {inphase_lt_zero, inphase_eq_zero, quadrature_lt_zero, quadrature_eq_zero};



  assign DirectLookupTable_1[0] = 2'b00;
  assign DirectLookupTable_1[1] = 2'b00;
  assign DirectLookupTable_1[2] = 2'b10;
  assign DirectLookupTable_1[3] = 2'b00;
  assign DirectLookupTable_1[4] = 2'b01;
  assign DirectLookupTable_1[5] = 2'b00;
  assign DirectLookupTable_1[6] = 2'b10;
  assign DirectLookupTable_1[7] = 2'b00;
  assign DirectLookupTable_1[8] = 2'b01;
  assign DirectLookupTable_1[9] = 2'b11;
  assign DirectLookupTable_1[10] = 2'b11;
  assign DirectLookupTable_1[11] = 2'b00;
  assign DirectLookupTable_1[12] = 2'b00;
  assign DirectLookupTable_1[13] = 2'b00;
  assign DirectLookupTable_1[14] = 2'b00;
  assign DirectLookupTable_1[15] = 2'b00;
  assign hardDecision = DirectLookupTable_1[decisionLUTaddr];



  assign out0 = hardDecision;

endmodule