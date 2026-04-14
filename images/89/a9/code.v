module top_module(op,din,dout);input         op;
   input [7:0]   din;
   output [31:0] dout;

   assign dout=(op==1'b0)?{24'h000000,din}:
               {{24{din[7]}},din};

endmodule