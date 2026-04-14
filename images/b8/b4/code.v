module top_module( x, y , z , w );output x;
  input y , z, w;
  
  assign x =  ~(y | z | w) ;endmodule