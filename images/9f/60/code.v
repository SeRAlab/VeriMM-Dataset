module top_module(
           in0,
           out0_re,
           out0_im
          );input   [7:0] in0;  
  output  signed [15:0] out0_re;  
  output  signed [15:0] out0_im;  

  parameter signed [15:0] t1_re_0 = 23170;  
  parameter signed [15:0] t1_re_1 = -23170;  
  parameter signed [15:0] t1_re_2 = 23170;  
  parameter signed [15:0] t1_re_3 = -23170;  
  parameter signed [15:0] t1_im_0 = 23170;  
  parameter signed [15:0] t1_im_1 = 23170;  
  parameter signed [15:0] t1_im_2 = -23170;  
  parameter signed [15:0] t1_im_3 = -23170;  

  wire [1:0] constellationLUTaddress;  
  wire signed [15:0] constellationLUT_t1_re [0:3];  
  wire signed [15:0] constellationLUT_t1_im [0:3];  


  assign constellationLUTaddress = in0[1:0];



  assign constellationLUT_t1_re[0] = t1_re_0;
  assign constellationLUT_t1_re[1] = t1_re_1;
  assign constellationLUT_t1_re[2] = t1_re_2;
  assign constellationLUT_t1_re[3] = t1_re_3;
  assign constellationLUT_t1_im[0] = t1_im_0;
  assign constellationLUT_t1_im[1] = t1_im_1;
  assign constellationLUT_t1_im[2] = t1_im_2;
  assign constellationLUT_t1_im[3] = t1_im_3;
  assign out0_re = constellationLUT_t1_re[constellationLUTaddress];
  assign out0_im = constellationLUT_t1_im[constellationLUTaddress];



endmodule