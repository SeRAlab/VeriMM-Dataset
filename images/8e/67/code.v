module top_module(
  clk,
  rst,
  wavelength,
  pos,
  value
);input               clk;
input               rst;
input       [7:0]   pos;
output      [7:0]   wavelength;
output      [15:0]  value;

parameter WAVELENGTH = 44;

assign  wavelength = WAVELENGTH;
assign  value = wave[pos];


wire [15:0] wave [WAVELENGTH:0];

assign wave[0]  =  16'h0000;
assign wave[1]  =  16'h1237; 
assign wave[2]  =  16'h240F;
assign wave[3]  =  16'h352C;
assign wave[4]  =  16'h4533;
assign wave[5]  =  16'h53D2;
assign wave[6]  =  16'h60BC;
assign wave[7]  =  16'h6BAE;
assign wave[8]  =  16'h746E;
assign wave[9]  =  16'h7AD0;
assign wave[10] =  16'h7EB2;
assign wave[11] =  16'h7FFF;
assign wave[12] =  16'h7EB2;
assign wave[13] =  16'h7AD0;
assign wave[14] =  16'h746E;
assign wave[15] =  16'h6BAE;
assign wave[16] =  16'h60BC;
assign wave[17] =  16'h53D2;
assign wave[18] =  16'h4533;
assign wave[19] =  16'h352C;
assign wave[20] =  16'h240F;
assign wave[21] =  16'h1237;
assign wave[22] =  16'h0000;
assign wave[23] =  16'hEDC9;
assign wave[24] =  16'hDBF1;
assign wave[25] =  16'hCAD4;
assign wave[26] =  16'hBACD;
assign wave[27] =  16'hAC2E;
assign wave[28] =  16'h9F43;
assign wave[29] =  16'h9452;
assign wave[30] =  16'h8B92;
assign wave[31] =  16'h8530;
assign wave[32] =  16'h814E;
assign wave[33] =  16'h8001;
assign wave[34] =  16'h814E;
assign wave[35] =  16'h8530;
assign wave[36] =  16'h8B92;
assign wave[37] =  16'h9452;
assign wave[38] =  16'h9F43;
assign wave[39] =  16'hAC2E;
assign wave[40] =  16'hBACD;
assign wave[41] =  16'hCAD4;
assign wave[42] =  16'hDBF1;
assign wave[43] =  16'hEDC9;

endmodule