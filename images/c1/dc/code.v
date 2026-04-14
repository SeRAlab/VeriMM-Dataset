module sparc_exu_rml_inc3 (
   dout, 
   din, inc
   ) ;
   input [2:0] din;
   input       inc;
   output [2:0] dout;
   assign       dout[2] = ((~din[2] & ~din[1] & ~din[0] & ~inc) |
                           (~din[2] & din[1] & din[0] & inc) |
                           (din[2] & din[1] & ~din[0]) |
                           (din[2] & ~din[1] & inc) |
                           (din[2] & din[0] & ~inc));
   assign dout[1] = ((~din[1] & ~din[0] & ~inc) |
                     (din[1] & ~din[0] & inc) |
                     (~din[1] & din[0] & inc) |
                     (din[1] & din[0] & ~inc));
   assign dout[0] = ~din[0];
endmodule