module top_module(in, sign_extend, out);input [7:0] in;
  input sign_extend;
  output [15:0] out;
  
  assign out = (sign_extend) ? {{8{in[7]}}, in[7:0]} : {8'b0, in[7:0]};
  
endmodule