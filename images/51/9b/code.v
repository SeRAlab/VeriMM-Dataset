module top_module(
  input  wire [3:0]      i,
  output wire [2:0][3:0] o
);wire [2:0][3:0] v;

   

   assign v[0]    = i;
   assign v[1][0] = v[0][1] | v[0][0];

   assign o[1][2] = v[0][2];
   assign o[2][1:0] = {v[1][0] , o[1][0]};

endmodule