module top_module(I, S, O);input [3:0] I;
  input [1:0] S;
  output O;
  
  assign O = (S == 2'b00) ? I[0] :
             (S == 2'b01) ? I[1] :
             (S == 2'b10) ? I[2] :
             (S == 2'b11) ? I[3] :
             1'bx;
endmodule