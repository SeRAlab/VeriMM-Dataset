module top_module(input [7:0] in,output [15:0] out);wire[3:0] inlo; 
  wire[7:4] inhi; 
  assign inlo = in[3:0]; 
  assign inhi = in[7:4]; 
  assign out[7:0] = (inlo == 4'd0) ? "0" : 
  (inlo == 4'd1) ? "1" : 
  (inlo == 4'd2) ? "2" : 
  (inlo == 4'd3) ? "3" : 
  (inlo == 4'd4) ? "4" : 
  (inlo == 4'd5) ? "5" : 
  (inlo == 4'd6) ? "6" : 
  (inlo == 4'd7) ? "7" : 
  (inlo == 4'd8) ? "8" : 
  (inlo == 4'd9) ? "9" : 
  (inlo == 4'd10) ? "A" : 
  (inlo == 4'd11) ? "B" : 
  (inlo == 4'd12) ? "C" : 
  (inlo == 4'd13) ? "D" : 
  (inlo == 4'd14) ? "E" : "F"; 
  assign out[15:8]= (inhi == 4'd0) ? "0" : 
  (inhi == 4'd1) ? "1" : 
  (inhi == 4'd2) ? "2" : 
  (inhi == 4'd3) ? "3" : 
  (inhi == 4'd4) ? "4" : 
  (inhi == 4'd5) ? "5" : 
  (inhi == 4'd6) ? "6" : 
  (inhi == 4'd7) ? "7" : 
  (inhi == 4'd8) ? "8" : 
  (inhi == 4'd9) ? "9" : 
  (inhi == 4'd10) ? "A" : 
  (inhi == 4'd11) ? "B" : 
  (inhi == 4'd12) ? "C" : 
  (inhi == 4'd13) ? "D" : 
  (inhi == 4'd14) ? "E" : "F"; 
 endmodule