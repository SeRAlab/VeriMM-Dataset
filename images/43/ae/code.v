module top_module( input[3:0] ADDR ,output[31:0] DATA_RE,output[31:0] DATA_IM);reg [31:0] re[0:15]; 
 reg [31:0] im[0:15]; 
 initial begin 
 re[0] = 32'h00010000;re[1] = 32'h0000FB15;re[2] = 32'h0000EC83;re[3] = 32'h0000D4DB; 
 re[4] = 32'h0000B505;re[5] = 32'h00008E3A;re[6] = 32'h000061F8;re[7] = 32'h000031F1; 
 re[8] = 32'h00000000;re[9] = 32'hFFFFCE0F;re[10] = 32'hFFFF9E08;re[11] = 32'hFFFF71C6; 
 re[12] = 32'hFFFF4AFB;re[13] = 32'hFFFF2B25;re[14] = 32'hFFFF137D;re[15] = 32'hFFFF04EB; 
 im[0] = 32'h00000000;im[1] = 32'hFFFFCE0F;im[2] = 32'hFFFF9E08;im[3] = 32'hFFFF71C6; 
 im[4] = 32'hFFFF4AFB;im[5] = 32'hFFFF2B25;im[6] = 32'hFFFF137D;im[7] = 32'hFFFF04EB; 
 im[8] = 32'hFFFF0000;im[9] = 32'hFFFF04EB;im[10] = 32'hFFFF137D;im[11] = 32'hFFFF2B25; 
 im[12] = 32'hFFFF4AFB;im[13] = 32'hFFFF71C6;im[14] = 32'hFFFF9E08;im[15] = 32'hFFFFCE0F; 
 end 
 assign DATA_RE = re[ADDR]; 
 assign DATA_IM = im[ADDR]; 
 endmodule