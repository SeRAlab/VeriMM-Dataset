module top_module(
        iv_data,
        ov_data
        );input[3:0]  iv_data;
  output[3:0] ov_data;

  wire a,b,c,d,e,f,g,h;
  wire t1,t2,t3,t4,t5,t7,t8,t10,t11,t13;

  assign a=iv_data[0];
  assign b=iv_data[1];
  assign c=iv_data[2];
  assign d=iv_data[3];

  assign t1 = ~d; 
  assign t2 = ~(b & t1); 
  assign t3 = a ^ t2; 
  assign t4 = c & t3; 
  assign t5 = ~(c | t3); 
  assign f = ~(t4 | t5); 
  assign t7 = t1 & t3; 
  assign t8 = ~(t5 | t7); 
  assign h = b ^ t8; 
  assign t10 = ~(t3 | h); 
  assign t11 = ~(t4 | t10); 
  assign e = t1 ^ t11; 
  assign t13 = h | e; 
  assign g = t3 ^ t13; 

  assign ov_data={h,g,f,e};
endmodule