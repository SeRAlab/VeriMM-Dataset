module top_module( INPUT, OUTPUT );input [15:0] INPUT;
  output [31:0] OUTPUT;
  wire   OUTPUT_31, \INPUT[14] , \INPUT[13] , \INPUT[12] , \INPUT[11] ,
         \INPUT[10] , \INPUT[9] , \INPUT[8] , \INPUT[7] , \INPUT[6] ,
         \INPUT[5] , \INPUT[4] , \INPUT[3] , \INPUT[2] , \INPUT[1] ,
         \INPUT[0] ;
  assign OUTPUT[1] = 1'b0;
  assign OUTPUT[0] = 1'b0;
  assign OUTPUT[31] = OUTPUT_31;
  assign OUTPUT[30] = OUTPUT_31;
  assign OUTPUT[29] = OUTPUT_31;
  assign OUTPUT[28] = OUTPUT_31;
  assign OUTPUT[27] = OUTPUT_31;
  assign OUTPUT[26] = OUTPUT_31;
  assign OUTPUT[25] = OUTPUT_31;
  assign OUTPUT[24] = OUTPUT_31;
  assign OUTPUT[23] = OUTPUT_31;
  assign OUTPUT[22] = OUTPUT_31;
  assign OUTPUT[21] = OUTPUT_31;
  assign OUTPUT[20] = OUTPUT_31;
  assign OUTPUT[19] = OUTPUT_31;
  assign OUTPUT[18] = OUTPUT_31;
  assign OUTPUT[17] = OUTPUT_31;
  assign OUTPUT_31 = INPUT[15];
  assign OUTPUT[16] = \INPUT[14] ;
  assign \INPUT[14]  = INPUT[14];
  assign OUTPUT[15] = \INPUT[13] ;
  assign \INPUT[13]  = INPUT[13];
  assign OUTPUT[14] = \INPUT[12] ;
  assign \INPUT[12]  = INPUT[12];
  assign OUTPUT[13] = \INPUT[11] ;
  assign \INPUT[11]  = INPUT[11];
  assign OUTPUT[12] = \INPUT[10] ;
  assign \INPUT[10]  = INPUT[10];
  assign OUTPUT[11] = \INPUT[9] ;
  assign \INPUT[9]  = INPUT[9];
  assign OUTPUT[10] = \INPUT[8] ;
  assign \INPUT[8]  = INPUT[8];
  assign OUTPUT[9] = \INPUT[7] ;
  assign \INPUT[7]  = INPUT[7];
  assign OUTPUT[8] = \INPUT[6] ;
  assign \INPUT[6]  = INPUT[6];
  assign OUTPUT[7] = \INPUT[5] ;
  assign \INPUT[5]  = INPUT[5];
  assign OUTPUT[6] = \INPUT[4] ;
  assign \INPUT[4]  = INPUT[4];
  assign OUTPUT[5] = \INPUT[3] ;
  assign \INPUT[3]  = INPUT[3];
  assign OUTPUT[4] = \INPUT[2] ;
  assign \INPUT[2]  = INPUT[2];
  assign OUTPUT[3] = \INPUT[1] ;
  assign \INPUT[1]  = INPUT[1];
  assign OUTPUT[2] = \INPUT[0] ;
  assign \INPUT[0]  = INPUT[0];

endmodule