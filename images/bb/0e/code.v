module comparator_8bit (lt, eq, gt, a, b);
   input [7:0] a, b;
   output lt, eq, gt;
   
   assign lt = (a < b);
   assign eq = (a == b);
   assign gt = (a > b);
   
endmodule