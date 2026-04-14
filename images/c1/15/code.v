module MULT_BY_ALPHA51(b, z); 
input [7:0] b; 
output [7:0] z; 
assign z[0] = b[5]^b[7];  
assign z[1] = b[0]^b[6];  
assign z[2] = b[1]^b[5];  
assign z[3] = b[0]^b[2]^b[5]^b[6]^b[7];  
assign z[4] = b[1]^b[3]^b[5]^b[6]^b[7]^b[7];  
assign z[5] = b[2]^b[4]^b[6]^b[7];  
assign z[6] = b[3]^b[5]^b[7];  
assign z[7] = b[4]^b[6];  
endmodule