module subtractor_16bit (diff, borrow_out, a, b);
   input [15:0] a, b;
   output [15:0] diff;
   output borrow_out;
   
   assign {borrow_out, diff} = a - b;
   
endmodule