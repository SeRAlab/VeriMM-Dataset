module top_module(one,two,sign,y2,y1,y0);input y2,y1,y0; 
 output one,two,sign; 
 wire [1:0]k; 
 xor x1(one,y0,y1); 
 xor x2(k[1],y2,y1); 
 not n1(k[0],one); 
 and a1(two,k[0],k[1]); 
 assign sign=y2; 
 endmodule